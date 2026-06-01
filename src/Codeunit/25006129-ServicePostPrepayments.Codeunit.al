Codeunit 25006129 "Service-Post Prepayments"
{
    // 27.02.2013 EDMS P8
    //   * Implement new dimension set
    // 
    // 13.02.2013 EDMS P8
    //   * Add use of GetInvCount. Use of fields *" Run 1", Resources
    //   * Same Variables in name has BT - means Bill-To
    // 
    // 08.04.2008. EDMS P2
    //   * Added new functions for statistics
    //              UpdatePrepmtAmountOnServLines
    //              SumPrepmt
    // 
    // 08.11.2007 P3
    //   * Code - to assign default CM PVN posting grp. if it is set up
    // 
    // 05-09-2007 EDMS P3
    //   * Added code to hold correction status in posted prepayments
    // 
    // 13.07.2007. EDMS M.Kumerdanks
    //   * Added function
    //      GetServiceLines

    Permissions = TableData "Sales Invoice Header" = rim,
                  TableData "Sales Invoice Line" = rim,
                  TableData "Sales Cr.Memo Header" = rim,
                  TableData "Sales Cr.Memo Line" = rim;

    trigger OnRun()
    begin
    end;

    var
        DimBufMgt: Codeunit "Dimension Buffer Management";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenPostingSetup: Record "General Posting Setup";
        Text000: label 'is not within your range of allowed posting dates';
        Text001: label 'There is nothing to post.';
        Text020: label 'There prepayment part of Sell-To is bigger than amount of total document split.';
        Text002: label 'Posting Prepayment Lines   #2######\';
        Text003: label '%1 %2 -> Invoice %3';
        Text004: label 'Posting purchases and VAT  #3######\';
        Text005: label 'Posting to vendors         #4######\';
        Text006: label 'Posting to bal. account    #5######';
        Text007: label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text008: label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text009: label 'The dimensions used in %1 %2 are invalid. %3';
        Text010: label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        Text011: label '%1 %2 -> Credit Memo %3';
        Text012: label 'Prepayment %1, %2 %3.';
        Text013: label 'It is not possible to assign a prepayment amount of %1 to the purchase lines.';
        Text014: label 'VAT Amount';
        Text015: label '%1% VAT';
        Text016: label 'The new prepayment amount must be between %1 and %2.';
        Text017: label 'At least one line must have %1 > 0 to distribute prepayment amount.';
        Text018: label 'must be positive when %1 is not 0';
        Text019: label 'Invoice,Credit Memo';
        EDMSSetup: Record "Make Setup";
        DocumentTypeGlobal: Option Invoice,"Credit Memo";


    procedure Invoice(var ServHeader: Record "Service Header EDMS")
    begin
        Code(ServHeader, 0);
    end;


    procedure CreditMemo(var ServHeader: Record "Service Header EDMS")
    begin
        Code(ServHeader, 1);
    end;

    local procedure "Code"(var ServHeader2: Record "Service Header EDMS"; DocumentType: Option Invoice,"Credit Memo")
    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        SourceCodeSetup: Record "Source Code Setup";
        PaymentTerms: Record "Payment Terms";
        Cust: Record Customer;
        ServHeader: Record "Service Header EDMS";
        ServLine: Record "Service Line EDMS";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvHeaderBT: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoHeaderBT: Record "Sales Cr.Memo Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        PrepmtInvBuffer: Record "Prepayment Inv. Line Buffer" temporary;
        PrepmtInvBufferST: Record "Prepayment Inv. Line Buffer" temporary;
        TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer";
        GenJnlLine: Record "Gen. Journal Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempDimBuf: Record "Dimension Buffer" temporary;
        CustLedgEntry: Record "Cust. Ledger Entry";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        GenJnlLineDocNo: Code[20];
        GenJnlLineDocNoBT: Code[20];
        GenJnlLineExtDocNo: Code[20];
        SrcCode: Code[10];
        PostingDescription: Text[50];
        GenJnlLineDocType: Integer;
        PrevLineNo: Integer;
        LineCount: Integer;
        LineNo: Integer;
        DocRef: RecordRef;
        SalesSetup: Record "Sales & Receivables Setup";
        BillTo: Code[20];
        CompressPrepayment: Boolean;
    begin
        ServHeader := ServHeader2;
        ServHeader.TestField("Document Type", ServHeader."document type"::Order);
        ServHeader.TestField("Sell-to Customer No.");
        ServHeader.TestField("Bill-to Customer No.");
        ServHeader.TestField("Posting Date");
        ServHeader.TestField("Document Date");
        if GenJnlCheckLine.DateNotAllowed(ServHeader."Posting Date") then
            ServHeader.FieldError("Posting Date", Text000);

        if not CheckOpenPrepaymentLines(ServHeader, DocumentType) then
            Error(Text001);

        Cust.Get(ServHeader."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, PrepmtDocTypeToDocType(ServHeader."Document Type"), false, true);
        if ServHeader."Bill-to Customer No." <> ServHeader."Sell-to Customer No." then begin
            Cust.Get(ServHeader."Bill-to Customer No.");
            Cust.CheckBlockedCustOnDocs(Cust, PrepmtDocTypeToDocType(ServHeader."Document Type"), false, true);
        end;

        // Get Doc. No. and save
        case DocumentType of
            Documenttype::Invoice:
                begin
                    ServHeader.TestField("Prepayment Due Date");
                    ServHeader.TestField("Prepmt. Cr. Memo No.", '');
                    if ServHeader."Prepayment No." = '' then begin
                        ServHeader.TestField("Prepayment No. Series");
                        ServHeader."Prepayment No." :=
                          NoSeriesMgt.GetNextNo(ServHeader."Prepayment No. Series", ServHeader."Posting Date", true);
                        ServHeader.Modify;
                        Commit;
                    end;
                    GenJnlLineDocNo := ServHeader."Prepayment No.";
                end;
            Documenttype::"Credit Memo":
                begin
                    ServHeader.TestField("Prepayment No.", '');
                    if ServHeader."Prepmt. Cr. Memo No." = '' then begin
                        ServHeader.TestField("Prepmt. Cr. Memo No. Series");
                        ServHeader."Prepmt. Cr. Memo No." :=
                          NoSeriesMgt.GetNextNo(ServHeader."Prepmt. Cr. Memo No. Series", ServHeader."Posting Date", true);
                        ServHeader.Modify;
                        Commit;
                    end;
                    GenJnlLineDocNo := ServHeader."Prepmt. Cr. Memo No.";
                end;
        end;

        Window.Open(
          '#1#################################\\' +
          Text002 +
          Text004 +
          Text005 +
          Text006);
        Window.Update(1, StrSubstNo('%1 %2', SelectStr(1 + DocumentType, Text019), ServHeader."No."));

        ServiceSetup.Get;
        SourceCodeSetup.Get;
        EDMSSetup.Get(ServHeader."Make Code");  //EDMS P1
        SrcCode := SourceCodeSetup."Service Management EDMS";
        if ServHeader."Prepmt. Posting Description" <> '' then
            PostingDescription := ServHeader."Prepmt. Posting Description"
        else
            PostingDescription :=
              CopyStr(
                StrSubstNo(Text012, SelectStr(1 + DocumentType, Text019), ServHeader."Document Type", ServHeader."No."),
                1, MaxStrLen(ServHeader."Posting Description"));

        // Create posted header
        if ServiceSetup."Ext. Doc. No. Mandatory" then
            ServHeader.TestField("External Document No.");
        case DocumentType of
            Documenttype::Invoice:
                begin
                    //Creates Sales Headers
                    GenJnlLineDocType := GenJnlLine."document type"::Invoice;
                    CreateSalesHeader(ServHeader, SalesInvHeader, PostingDescription, GenJnlLineDocNo, SrcCode,
                      ServHeader."Bill-to Customer No.");
                    Window.Update(1, StrSubstNo(Text003, ServHeader."Document Type", ServHeader."No.", SalesInvHeader."No."));
                end;
            Documenttype::"Credit Memo":
                begin
                    //Creates Sales Headers
                    GenJnlLineDocType := GenJnlLine."document type"::"Credit Memo";
                    CreateCrMemoHeader(ServHeader, SalesCrMemoHeader, PostingDescription, GenJnlLineDocNo, SrcCode,
                      ServHeader."Bill-to Customer No.");
                    Window.Update(1, StrSubstNo(Text003, ServHeader."Document Type", ServHeader."No.", SalesCrMemoHeader."No."));
                end;
        end;

        GenJnlLineExtDocNo := ServHeader."External Document No.";

        // Create Lines
        PrepmtInvBuffer.DeleteAll;
        CalcVATAmountLines(ServHeader, ServLine, TempVATAmountLine, DocumentType);
        UpdateVATOnLines(ServHeader, ServLine, TempVATAmountLine, DocumentType);
        CompressPrepayment := ServHeader."Compress Prepayment";
        ServHeader."Compress Prepayment" := false;
        BuildInvLineBuffer(
          ServHeader, ServLine, DocumentType, PrepmtInvBuffer, SalesSetup."Invoice Rounding");

        CopyBufferToBuffer(PrepmtInvBuffer, PrepmtInvBufferST, true);

        ServHeader."Compress Prepayment" := CompressPrepayment;
        if ServHeader."Compress Prepayment" then begin
            CompressInvLineBuffer(ServHeader, PrepmtInvBuffer);
        end;
        if PrepmtInvBuffer.FindFirst then begin
            TempDimBuf.Init;
            repeat
                LineCount := LineCount + 1;
                Window.Update(2, LineCount);
                if PrepmtInvBuffer."Line No." <> 0 then
                    LineNo := LineNo + PrepmtInvBuffer."Line No."
                else
                    LineNo := LineNo + 10000;
                TempDimBuf.Reset;
                TempDimBuf.DeleteAll;
                case DocumentType of
                    Documenttype::Invoice:
                        begin
                            CreateSalesLine(ServHeader, SalesInvHeader, PrepmtInvBuffer, SalesInvLine, TempDimBuf, LineNo, 100);
                        end;
                    Documenttype::"Credit Memo":
                        begin
                            CreateCrMemoLine(ServHeader, SalesCrMemoHeader, PrepmtInvBuffer, SalesCrMemoLine, TempDimBuf, LineNo, 100);
                        end;
                end;
            until PrepmtInvBuffer.Next = 0;
        end;

        // G/L Posting
        LineCount := 0;
        CompressInvLineBuffer(ServHeader, PrepmtInvBuffer);

        TotalPrepmtInvLineBuffer.Init;
        TotalPrepmtInvLineBufferLCY.Init;
        if PrepmtInvBuffer.FindLast then begin
            repeat
                LineCount := LineCount + 1;
                Window.Update(3, LineCount);

                if DocumentType = Documenttype::Invoice then
                    ReverseAmounts(PrepmtInvBuffer);
                RoundAmounts(ServHeader, PrepmtInvBuffer, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY);
                CreateGenJnlLine(ServHeader, PrepmtInvBuffer, GenJnlLine, PostingDescription, GenJnlLineDocType,
                  GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, BillTo);
            until PrepmtInvBuffer.Next(-1) = 0;
        end;
        LineCount := 0;

        // Post customer entry
        Window.Update(4, 1);
        if TotalPrepmtInvLineBuffer.Amount <> 0 then begin
            CreateGenJnlLineCustomer(ServHeader, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY,
              GenJnlLine, PostingDescription, GenJnlLineDocType,
              GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, ServHeader."Bill-to Customer No.", ServHeader."Bill-to Customer No.");
        end;

        // Balancing account
        if ServHeader."Bal. Account No." <> '' then begin
            Window.Update(5, 1);
            CustLedgEntry.FindLast;
            if TotalPrepmtInvLineBuffer.Amount <> 0 then
                CreateGenJnlLineBalanc(ServHeader, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY,
                  GenJnlLine, CustLedgEntry, PostingDescription, GenJnlLineDocType,
                  GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, ServHeader."Bill-to Customer No.", ServHeader."Bill-to Customer No.");
        end;

        // Update lines & header
        PrepmtInvBufferST.Reset;
        ServLine.Reset;
        ServLine.SetRange("Document Type", ServHeader."Document Type");
        ServLine.SetRange("Document No.", ServHeader."No.");
        if DocumentType = Documenttype::Invoice then begin
            ServHeader."Last Prepayment No." := GenJnlLineDocNo;
            ServHeader."Prepayment No." := '';
            ServLine.SetFilter("Prepmt. Line Amount", '<>0');
            if ServLine.FindSet then begin
                repeat
                    if ServLine."Prepmt. Line Amount" <> ServLine."Prepmt. Amt. Inv." then begin
                        ServLine."Prepmt. Amt. Inv." := ServLine."Prepmt. Line Amount";
                        ServLine."Prepmt. Amt. Incl. VAT" += ServLine."Prepayment Amount Incl. VAT";  //13.03.2013 EDMS P8
                        ServLine."Prepmt Amt to Deduct" :=
                          ServLine."Prepmt. Amt. Inv." - ServLine."Prepmt Amt Deducted";
                        PrepmtInvBufferST.SetRange("Line No.", ServLine."Line No.");
                        ServLine.Modify;
                    end;
                until ServLine.Next = 0;
            end;
        end else begin
            ServHeader."Last Prepmt. Cr. Memo No." := GenJnlLineDocNo;
            ServHeader."Prepmt. Cr. Memo No." := '';
            ServLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
            if ServLine.FindSet(true, false) then
                repeat
                    ServLine."Prepmt. Amt. Inv." := ServLine."Prepmt Amt Deducted";
                    ServLine."Prepmt Amt to Deduct" := 0;
                    ServLine.Modify;
                until ServLine.Next = 0;
        end;
        if ServHeader.Status <> ServHeader.Status::"Pending Prepayment" then
            ServHeader.Status := ServHeader.Status::"Pending Prepayment";
        ServHeader.Modify;

        ServHeader2 := ServHeader;
    end;


    procedure CheckOpenPrepaymentLines(ServHeader: Record "Service Header EDMS"; DocumentType: Option Invoice,"Credit Memo"): Boolean
    var
        ServLine: Record "Service Line EDMS";
    begin
        ApplyFilter(ServHeader, DocumentType, ServLine);
        if ServLine.FindSet then begin
            repeat
                if PrepmtAmount(ServLine, DocumentType) <> 0 then
                    exit(true);
            until ServLine.Next = 0;
        end;
    end;


    procedure CreateSalesHeader(ServiceHeaderPar: Record "Service Header EDMS"; var SalesInvHeaderPar: Record "Sales Invoice Header"; PostingDescription: Text[50]; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]; BillTo: Code[20])
    var
        SalesHeaderLoc: Record "Sales Header";
        DocRef: RecordRef;
        DimMgt: Codeunit DimensionManagement;
        PostedDocTabNo: Integer;
    begin
        SalesInvHeaderPar.Init;
        DocRef.GetTable(SalesInvHeaderPar);
        TransferServDoc(DocRef, ServiceHeaderPar, 0);
        DocRef.SetTable(SalesInvHeaderPar);
        SalesInvHeaderPar."Posting Description" := PostingDescription;
        SalesInvHeaderPar."Payment Terms Code" := ServiceHeaderPar."Prepmt. Payment Terms Code";
        SalesInvHeaderPar."Due Date" := ServiceHeaderPar."Prepayment Due Date";
        SalesInvHeaderPar."Pmt. Discount Date" := ServiceHeaderPar."Prepmt. Pmt. Discount Date";
        SalesInvHeaderPar."Payment Discount %" := ServiceHeaderPar."Prepmt. Payment Discount %";
        SalesInvHeaderPar."No." := GenJnlLineDocNo;
        SalesInvHeaderPar."Pre-Assigned No. Series" := '';
        SalesInvHeaderPar."Source Code" := SrcCode;
        SalesInvHeaderPar."User ID" := UserId;
        SalesInvHeaderPar."No. Printed" := 0;
        SalesInvHeaderPar."Prepayment Invoice" := true;
        SalesInvHeaderPar."Prepayment Order No." := ServiceHeaderPar."No.";
        SalesInvHeaderPar."Order Date" := ServiceHeaderPar."Order Date";
        SalesInvHeaderPar."Document Profile" := SalesInvHeaderPar."document profile"::Service;
        SalesInvHeaderPar.Resources := CopyStr(ServiceHeaderPar.GetResourceTextFieldValue, 1, 100);

        SalesInvHeaderPar.Insert;
        SalesInvHeaderPar.Validate("Sell-to Customer No.", ServiceHeaderPar."Sell-to Customer No.");
        if not (SalesInvHeaderPar."Sell-to Contact No." = ServiceHeaderPar."Sell-to Contact No.") then
            SalesInvHeaderPar.Validate("Sell-to Contact No.", ServiceHeaderPar."Sell-to Contact No.");
        if BillTo <> SalesInvHeaderPar."Bill-to Customer No." then begin
            SalesInvHeaderPar.Validate("Bill-to Customer No.", BillTo);
        end;
        SalesHeaderLoc.Init;
        SalesHeaderLoc."Bill-to Customer No." := BillTo;
        SalesHeaderLoc.UpdateBillToCont(SalesHeaderLoc."Bill-to Customer No.");
        if SalesInvHeaderPar."Bill-to Contact No." <> SalesHeaderLoc."Bill-to Contact No." then
            SalesInvHeaderPar.Validate("Bill-to Contact No.", SalesHeaderLoc."Bill-to Contact No.");
        SalesInvHeaderPar.Modify;
        PostedDocTabNo := Database::"Sales Invoice Header";
    end;


    procedure CreateSalesLine(ServiceHeaderPar: Record "Service Header EDMS"; SalesInvHeaderPar: Record "Sales Invoice Header"; PrepmtInvBufferPar: Record "Prepayment Inv. Line Buffer" temporary; var SalesInvLinePar: Record "Sales Invoice Line"; var TempDimBuf: Record "Dimension Buffer" temporary; LineNo: Integer; decPart: Decimal)
    var
        DocRef: RecordRef;
        DimMgt: Codeunit DimensionManagement;
        PostedDocTabNo: Integer;
    begin
        SalesInvLinePar.Init;
        SalesInvLinePar."Document No." := SalesInvHeaderPar."No.";
        SalesInvLinePar.TestField("Document No.");
        SalesInvLinePar."Line No." := LineNo;
        SalesInvLinePar."Sell-to Customer No." := SalesInvHeaderPar."Sell-to Customer No.";
        SalesInvLinePar."Bill-to Customer No." := SalesInvHeaderPar."Bill-to Customer No.";
        SalesInvLinePar.Type := SalesInvLinePar.Type::"G/L Account";
        SalesInvLinePar."No." := PrepmtInvBufferPar."G/L Account No.";
        SalesInvLinePar."Shortcut Dimension 1 Code" := PrepmtInvBufferPar."Global Dimension 1 Code";
        SalesInvLinePar."Shortcut Dimension 2 Code" := PrepmtInvBufferPar."Global Dimension 2 Code";

        SalesInvLinePar."Shipment Date" := SalesInvHeaderPar."Posting Date";
        SalesInvLinePar.VIN := SalesInvHeaderPar.VIN;
        SalesInvLinePar."Model Version No." := SalesInvHeaderPar."Model Version No.";
        SalesInvLinePar."Vehicle Serial No." := SalesInvHeaderPar."Vehicle Serial No.";
        SalesInvLinePar."Vehicle Accounting Cycle No." := SalesInvHeaderPar."Vehicle Accounting Cycle No.";
        SalesInvLinePar.Description := PrepmtInvBufferPar.Description;
        SalesInvLinePar.Quantity := 1;
        if ServiceHeaderPar."Prices Including VAT" then begin
            SalesInvLinePar."Unit Price" := PrepmtInvBufferPar."Amount Incl. VAT";
            SalesInvLinePar."Line Amount" := PrepmtInvBufferPar."Amount Incl. VAT" * decPart / 100;
        end else begin
            SalesInvLinePar."Unit Price" := PrepmtInvBufferPar.Amount;
            SalesInvLinePar."Line Amount" := PrepmtInvBufferPar.Amount * decPart / 100;
        end;
        SalesInvLinePar."Gen. Bus. Posting Group" := PrepmtInvBufferPar."Gen. Bus. Posting Group";
        SalesInvLinePar."Gen. Prod. Posting Group" := PrepmtInvBufferPar."Gen. Prod. Posting Group";
        SalesInvLinePar."VAT Bus. Posting Group" := PrepmtInvBufferPar."VAT Bus. Posting Group";
        SalesInvLinePar."VAT Prod. Posting Group" := PrepmtInvBufferPar."VAT Prod. Posting Group";
        SalesInvLinePar."VAT %" := PrepmtInvBufferPar."VAT %";
        SalesInvLinePar.Amount := PrepmtInvBufferPar.Amount * decPart / 100;
        SalesInvLinePar."Amount Including VAT" := PrepmtInvBufferPar."Amount Incl. VAT" * decPart / 100;
        SalesInvLinePar."VAT Calculation Type" := PrepmtInvBufferPar."VAT Calculation Type";
        SalesInvLinePar."VAT Base Amount" := PrepmtInvBufferPar."VAT Base Amount" * decPart / 100;
        SalesInvLinePar."VAT Identifier" := PrepmtInvBufferPar."VAT Identifier";
        SalesInvLinePar."Document Profile" := SalesInvLinePar."document profile"::Service;
        SalesInvLinePar.Insert;
        PostedDocTabNo := Database::"Sales Invoice Line";
        InsertExtendedText(
          PostedDocTabNo, SalesInvLinePar."Document No.", PrepmtInvBufferPar."G/L Account No.",
            ServiceHeaderPar."Document Date", ServiceHeaderPar."Language Code", LineNo);
    end;


    procedure CreateCrMemoHeader(ServiceHeaderPar: Record "Service Header EDMS"; var SalesCrMemoHeaderPar: Record "Sales Cr.Memo Header"; PostingDescription: Text[50]; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]; BillTo: Code[20])
    var
        SalesHeaderLoc: Record "Sales Header";
        PaymentTerms: Record "Payment Terms";
        DocRef: RecordRef;
    begin
        SalesCrMemoHeaderPar.Init;
        DocRef.GetTable(SalesCrMemoHeaderPar);
        TransferServDoc(DocRef, ServiceHeaderPar, 1);
        DocRef.SetTable(SalesCrMemoHeaderPar);
        SalesCrMemoHeaderPar."Payment Terms Code" := ServiceHeaderPar."Prepmt. Payment Terms Code";
        SalesCrMemoHeaderPar."Pmt. Discount Date" := ServiceHeaderPar."Prepmt. Pmt. Discount Date";
        SalesCrMemoHeaderPar."Payment Discount %" := ServiceHeaderPar."Prepmt. Payment Discount %";
        if ServiceHeaderPar."Prepmt. Payment Terms Code" <> '' then begin
            PaymentTerms.Get(ServiceHeaderPar."Prepmt. Payment Terms Code");
            if not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then begin
                SalesCrMemoHeaderPar."Payment Discount %" := 0;
                SalesCrMemoHeaderPar."Pmt. Discount Date" := 0D;
            end;
        end;
        SalesCrMemoHeaderPar."Posting Description" := PostingDescription;
        SalesCrMemoHeaderPar."Due Date" := ServiceHeaderPar."Prepayment Due Date";
        SalesCrMemoHeaderPar."No." := GenJnlLineDocNo;
        SalesCrMemoHeaderPar."Pre-Assigned No. Series" := '';
        SalesCrMemoHeaderPar."Source Code" := SrcCode;
        SalesCrMemoHeaderPar."User ID" := UserId;
        SalesCrMemoHeaderPar."No. Printed" := 0;
        SalesCrMemoHeaderPar."Prepayment Credit Memo" := true;
        SalesCrMemoHeaderPar."Prepayment Order No." := ServiceHeaderPar."No.";
        SalesCrMemoHeaderPar.Correction := SalesCrMemoHeaderPar.Correction;  //05-09-2007 EDMS P3
        SalesCrMemoHeaderPar."Document Profile" := SalesCrMemoHeaderPar."document profile"::Service;
        SalesCrMemoHeaderPar.Insert;
        SalesCrMemoHeaderPar.Validate("Sell-to Customer No.", ServiceHeaderPar."Sell-to Customer No.");
        if not (SalesCrMemoHeaderPar."Sell-to Contact No." = ServiceHeaderPar."Sell-to Contact No.") then
            SalesCrMemoHeaderPar.Validate("Sell-to Contact No.", ServiceHeaderPar."Sell-to Contact No.");
        if BillTo <> SalesCrMemoHeaderPar."Bill-to Customer No." then
            SalesCrMemoHeaderPar.Validate("Bill-to Customer No.", BillTo);
        SalesHeaderLoc.Init;
        SalesHeaderLoc."Bill-to Customer No." := BillTo;
        SalesHeaderLoc.UpdateBillToCont(SalesHeaderLoc."Bill-to Customer No.");
        if SalesCrMemoHeaderPar."Bill-to Contact No." <> SalesHeaderLoc."Bill-to Contact No." then
            SalesCrMemoHeaderPar.Validate("Bill-to Contact No.", SalesHeaderLoc."Bill-to Contact No.");
        SalesCrMemoHeaderPar.Modify;
    end;


    procedure CreateCrMemoLine(ServiceHeaderPar: Record "Service Header EDMS"; SalesCrMemoHeaderPar: Record "Sales Cr.Memo Header"; PrepmtInvBufferPar: Record "Prepayment Inv. Line Buffer" temporary; var SalesCrMemoLinePar: Record "Sales Cr.Memo Line"; var TempDimBuf: Record "Dimension Buffer" temporary; LineNo: Integer; decPart: Decimal)
    var
        DocRef: RecordRef;
        DimMgt: Codeunit DimensionManagement;
        PostedDocTabNo: Integer;
    begin
        SalesCrMemoLinePar.Init;
        SalesCrMemoLinePar."Document No." := SalesCrMemoHeaderPar."No.";
        SalesCrMemoLinePar."Line No." := LineNo;
        SalesCrMemoLinePar."Sell-to Customer No." := SalesCrMemoHeaderPar."Sell-to Customer No.";
        SalesCrMemoLinePar."Bill-to Customer No." := SalesCrMemoHeaderPar."Bill-to Customer No.";
        SalesCrMemoLinePar.Type := SalesCrMemoLinePar.Type::"G/L Account";
        SalesCrMemoLinePar."No." := PrepmtInvBufferPar."G/L Account No.";
        SalesCrMemoLinePar."Shortcut Dimension 1 Code" := PrepmtInvBufferPar."Global Dimension 1 Code";
        SalesCrMemoLinePar."Shortcut Dimension 2 Code" := PrepmtInvBufferPar."Global Dimension 2 Code";
        SalesCrMemoLinePar.Description := PrepmtInvBufferPar.Description;
        SalesCrMemoLinePar.Quantity := 1;
        if ServiceHeaderPar."Prices Including VAT" then begin
            SalesCrMemoLinePar."Unit Price" := PrepmtInvBufferPar."Amount Incl. VAT";
            SalesCrMemoLinePar."Line Amount" := PrepmtInvBufferPar."Amount Incl. VAT";
        end else begin
            SalesCrMemoLinePar."Unit Price" := PrepmtInvBufferPar.Amount;
            SalesCrMemoLinePar."Line Amount" := PrepmtInvBufferPar.Amount;
        end;
        SalesCrMemoLinePar."Gen. Bus. Posting Group" := PrepmtInvBufferPar."Gen. Bus. Posting Group";
        SalesCrMemoLinePar."Gen. Prod. Posting Group" := PrepmtInvBufferPar."Gen. Prod. Posting Group";
        SalesCrMemoLinePar."VAT Bus. Posting Group" := PrepmtInvBufferPar."VAT Bus. Posting Group";
        SalesCrMemoLinePar."VAT Prod. Posting Group" := PrepmtInvBufferPar."VAT Prod. Posting Group";
        SalesCrMemoLinePar."VAT %" := PrepmtInvBufferPar."VAT %";
        SalesCrMemoLinePar.Amount := PrepmtInvBufferPar.Amount;
        SalesCrMemoLinePar."Amount Including VAT" := PrepmtInvBufferPar."Amount Incl. VAT";
        SalesCrMemoLinePar."VAT Calculation Type" := PrepmtInvBufferPar."VAT Calculation Type";
        SalesCrMemoLinePar."VAT Base Amount" := PrepmtInvBufferPar."VAT Base Amount";
        SalesCrMemoLinePar."VAT Identifier" := PrepmtInvBufferPar."VAT Identifier";
        SalesCrMemoLinePar."Document Profile" := SalesCrMemoLinePar."document profile"::Service;
        SalesCrMemoLinePar.Insert;
        PostedDocTabNo := Database::"Sales Cr.Memo Line";
        InsertExtendedText(
          PostedDocTabNo, SalesCrMemoLinePar."Document No.", PrepmtInvBufferPar."G/L Account No.",
            ServiceHeaderPar."Document Date", ServiceHeaderPar."Language Code", LineNo);
    end;


    procedure CreateGenJnlLine(ServiceHeaderPar: Record "Service Header EDMS"; PrepmtInvBuffer: Record "Prepayment Inv. Line Buffer" temporary; var GenJnlLinePar: Record "Gen. Journal Line"; PostingDescription: Text[50]; GenJnlLineDocType: Integer; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[10]; BillTo: Code[20])
    var
        DocRef: RecordRef;
        DimMgt: Codeunit DimensionManagement;
        PostedDocTabNo: Integer;
    begin
        GenJnlLinePar.Init;
        GenJnlLinePar."Posting Date" := ServiceHeaderPar."Posting Date";
        GenJnlLinePar."Document Date" := ServiceHeaderPar."Document Date";
        GenJnlLinePar.Description := PostingDescription;
        GenJnlLinePar."Document Type" := GenJnlLineDocType;
        GenJnlLinePar."Document No." := GenJnlLineDocNo;
        GenJnlLinePar.TestField("Document No.");
        GenJnlLinePar."External Document No." := GenJnlLineExtDocNo;
        GenJnlLinePar."Account No." := PrepmtInvBuffer."G/L Account No.";
        GenJnlLinePar."System-Created Entry" := true;
        GenJnlLinePar.Amount := PrepmtInvBuffer.Amount;
        GenJnlLinePar."Source Currency Code" := ServiceHeaderPar."Currency Code";
        GenJnlLinePar."Source Currency Amount" := PrepmtInvBuffer."Amount (ACY)";
        GenJnlLinePar.Correction := ServiceHeaderPar.Correction;
        GenJnlLinePar."Gen. Posting Type" := GenJnlLinePar."gen. posting type"::Sale;
        GenJnlLinePar."Gen. Bus. Posting Group" := PrepmtInvBuffer."Gen. Bus. Posting Group";
        GenJnlLinePar."Gen. Prod. Posting Group" := PrepmtInvBuffer."Gen. Prod. Posting Group";
        GenJnlLinePar."VAT Bus. Posting Group" := PrepmtInvBuffer."VAT Bus. Posting Group";
        GenJnlLinePar."VAT Prod. Posting Group" := PrepmtInvBuffer."VAT Prod. Posting Group";
        GenJnlLinePar."Tax Area Code" := PrepmtInvBuffer."Tax Area Code";
        GenJnlLinePar."Tax Liable" := PrepmtInvBuffer."Tax Liable";
        GenJnlLinePar."Tax Group Code" := PrepmtInvBuffer."Tax Group Code";
        GenJnlLinePar."VAT Calculation Type" := PrepmtInvBuffer."VAT Calculation Type";
        GenJnlLinePar."VAT Base Amount" := PrepmtInvBuffer."VAT Base Amount";
        GenJnlLinePar."VAT Base Discount %" := ServiceHeaderPar."VAT Base Discount %";
        GenJnlLinePar."Source Curr. VAT Base Amount" := PrepmtInvBuffer."VAT Base Amount (ACY)";
        GenJnlLinePar."VAT Amount" := PrepmtInvBuffer."VAT Amount";
        GenJnlLinePar."Source Curr. VAT Amount" := PrepmtInvBuffer."VAT Amount (ACY)";
        GenJnlLinePar."VAT Difference" := PrepmtInvBuffer."VAT Difference";
        GenJnlLinePar."VAT Posting" := GenJnlLinePar."vat posting"::"Manual VAT Entry";
        GenJnlLinePar."Shortcut Dimension 1 Code" := PrepmtInvBuffer."Global Dimension 1 Code";
        GenJnlLinePar."Shortcut Dimension 2 Code" := PrepmtInvBuffer."Global Dimension 2 Code";
        GenJnlLinePar."Job No." := PrepmtInvBuffer."Job No.";
        GenJnlLinePar."Source Code" := SrcCode;
        GenJnlLinePar."Bill-to/Pay-to No." := BillTo;
        GenJnlLinePar."VAT Registration No." := ServiceHeaderPar."VAT Registration No.";
        GenJnlLinePar."Source Type" := GenJnlLinePar."source type"::Customer;
        GenJnlLinePar."Source No." := ServiceHeaderPar."Bill-to Customer No.";
        GenJnlLinePar."Posting No. Series" := ServiceHeaderPar."Posting No. Series";
        GenJnlLinePar.VIN := ServiceHeaderPar.VIN;
        GenJnlLinePar."Make Code" := ServiceHeaderPar."Make Code";
        GenJnlLinePar."Model Code" := ServiceHeaderPar."Model Code";
        GenJnlLinePar."Model Version No." := ServiceHeaderPar."Model Version No.";
        GenJnlLinePar."Vehicle Accounting Cycle No." := ServiceHeaderPar."Vehicle Accounting Cycle No.";
        GenJnlLinePar."Vehicle Serial No." := ServiceHeaderPar."Vehicle Serial No.";
        RunGenJnlPostLine(GenJnlLinePar);
    end;


    procedure CreateGenJnlLineCustomer(ServiceHeaderPar: Record "Service Header EDMS"; PrepmtInvBuffer: Record "Prepayment Inv. Line Buffer" temporary; PrepmtInvBufferLCY: Record "Prepayment Inv. Line Buffer" temporary; var GenJnlLinePar: Record "Gen. Journal Line"; PostingDescription: Text[50]; GenJnlLineDocType: Integer; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[10]; BillTo: Code[20]; AcctNo: Code[20])
    var
        PaymentTerms: Record "Payment Terms";
        DimMgt: Codeunit DimensionManagement;
        PostedDocTabNo: Integer;
    begin
        GenJnlLinePar.Init;
        GenJnlLinePar."Posting Date" := ServiceHeaderPar."Posting Date";
        GenJnlLinePar."Document Date" := ServiceHeaderPar."Document Date";
        GenJnlLinePar.Description := PostingDescription;
        GenJnlLinePar."Shortcut Dimension 1 Code" := ServiceHeaderPar."Shortcut Dimension 1 Code";
        GenJnlLinePar."Shortcut Dimension 2 Code" := ServiceHeaderPar."Shortcut Dimension 2 Code";
        GenJnlLinePar."Account Type" := GenJnlLinePar."account type"::Customer;
        GenJnlLinePar."Account No." := AcctNo;
        GenJnlLinePar."Document Type" := GenJnlLineDocType;
        GenJnlLinePar."Document No." := GenJnlLineDocNo;
        GenJnlLinePar.TestField("Document No.");
        GenJnlLinePar."External Document No." := GenJnlLineExtDocNo;
        GenJnlLinePar."Currency Code" := ServiceHeaderPar."Currency Code";
        GenJnlLinePar.Amount := -PrepmtInvBuffer."Amount Incl. VAT";
        GenJnlLinePar."Source Currency Code" := ServiceHeaderPar."Currency Code";
        GenJnlLinePar."Source Currency Amount" := -PrepmtInvBuffer."Amount Incl. VAT";
        GenJnlLinePar."Amount (LCY)" := -PrepmtInvBufferLCY."Amount Incl. VAT";
        if ServiceHeaderPar."Currency Code" = '' then
            GenJnlLinePar."Currency Factor" := 1
        else
            GenJnlLinePar."Currency Factor" := ServiceHeaderPar."Currency Factor";
        GenJnlLinePar.Correction := ServiceHeaderPar.Correction;
        GenJnlLinePar."Sales/Purch. (LCY)" := -PrepmtInvBufferLCY.Amount;
        GenJnlLinePar."Profit (LCY)" := -PrepmtInvBufferLCY.Amount;
        GenJnlLinePar."Sell-to/Buy-from No." := ServiceHeaderPar."Sell-to Customer No.";
        GenJnlLinePar."Bill-to/Pay-to No." := ServiceHeaderPar."Bill-to Customer No.";
        GenJnlLinePar."Salespers./Purch. Code" := ServiceHeaderPar."Service Advisor";
        GenJnlLinePar."System-Created Entry" := true;
        GenJnlLinePar."Due Date" := ServiceHeaderPar."Prepayment Due Date";
        GenJnlLinePar."Payment Terms Code" := ServiceHeaderPar."Prepmt. Payment Terms Code";
        if GenJnlLinePar."Payment Terms Code" <> '' then
            PaymentTerms.Get(GenJnlLinePar."Payment Terms Code");
        if (DocumentTypeGlobal = Documenttypeglobal::Invoice) or
           PaymentTerms."Calc. Pmt. Disc. on Cr. Memos"
        then begin
            GenJnlLinePar."Pmt. Discount Date" := ServiceHeaderPar."Prepmt. Pmt. Discount Date";
            GenJnlLinePar."Payment Discount %" := ServiceHeaderPar."Prepmt. Payment Discount %";
        end;
        GenJnlLinePar."Source Type" := GenJnlLinePar."source type"::Customer;
        GenJnlLinePar."Source No." := ServiceHeaderPar."Bill-to Customer No.";
        GenJnlLinePar."Source Code" := SrcCode;
        GenJnlLinePar."Posting No. Series" := ServiceHeaderPar."Posting No. Series";
        GenJnlLinePar.Prepayment := true;

        GenJnlLinePar.VIN := ServiceHeaderPar.VIN;
        GenJnlLinePar."Make Code" := ServiceHeaderPar."Make Code";
        GenJnlLinePar."Model Code" := ServiceHeaderPar."Model Code";
        GenJnlLinePar."Model Version No." := ServiceHeaderPar."Model Version No.";
        GenJnlLinePar."Vehicle Accounting Cycle No." := ServiceHeaderPar."Vehicle Accounting Cycle No.";
        GenJnlLinePar."Vehicle Serial No." := ServiceHeaderPar."Vehicle Serial No.";
        GenJnlPostLine.RunWithCheck(GenJnlLinePar);
    end;


    procedure CreateGenJnlLineBalanc(ServiceHeaderPar: Record "Service Header EDMS"; PrepmtInvBuffer: Record "Prepayment Inv. Line Buffer" temporary; PrepmtInvBufferLCY: Record "Prepayment Inv. Line Buffer" temporary; var GenJnlLinePar: Record "Gen. Journal Line"; CustLedgEntry: Record "Cust. Ledger Entry"; PostingDescription: Text[50]; GenJnlLineDocType: Integer; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[10]; BillTo: Code[20]; AcctNo: Code[20])
    var
        PaymentTerms: Record "Payment Terms";
        TempDimBuf: Record "Dimension Buffer" temporary;
        DimMgt: Codeunit DimensionManagement;
        PostedDocTabNo: Integer;
    begin
        GenJnlLinePar.Init;
        GenJnlLinePar."Posting Date" := ServiceHeaderPar."Posting Date";
        GenJnlLinePar."Document Date" := ServiceHeaderPar."Document Date";
        GenJnlLinePar.Description := PostingDescription;
        GenJnlLinePar."Shortcut Dimension 1 Code" := ServiceHeaderPar."Shortcut Dimension 1 Code";
        GenJnlLinePar."Shortcut Dimension 2 Code" := ServiceHeaderPar."Shortcut Dimension 2 Code";
        GenJnlLinePar."Account Type" := GenJnlLinePar."account type"::Customer;
        GenJnlLinePar."Account No." := AcctNo;
        if GenJnlLineDocType = GenJnlLinePar."document type"::"Credit Memo".AsInteger() then
            GenJnlLinePar."Document Type" := GenJnlLinePar."document type"::Refund
        else
            GenJnlLinePar."Document Type" := GenJnlLinePar."document type"::Payment;
        GenJnlLinePar."Document No." := GenJnlLineDocNo;
        GenJnlLinePar.TestField("Document No.");
        GenJnlLinePar."External Document No." := GenJnlLineExtDocNo;
        if ServiceHeaderPar."Bal. Account Type" = ServiceHeaderPar."bal. account type"::"Bank Account" then
            GenJnlLinePar."Bal. Account Type" := GenJnlLinePar."bal. account type"::"Bank Account";
        GenJnlLinePar."Bal. Account No." := ServiceHeaderPar."Bal. Account No.";
        GenJnlLinePar."Currency Code" := ServiceHeaderPar."Currency Code";
        GenJnlLinePar.Amount :=
            PrepmtInvBuffer."Amount Incl. VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";
        GenJnlLinePar."Source Currency Code" := ServiceHeaderPar."Currency Code";
        GenJnlLinePar."Source Currency Amount" := GenJnlLinePar.Amount;
        CustLedgEntry.CalcFields(Amount);
        if CustLedgEntry.Amount = 0 then
            GenJnlLinePar."Amount (LCY)" := PrepmtInvBufferLCY.Amount
        else
            GenJnlLinePar."Amount (LCY)" :=
              PrepmtInvBufferLCY.Amount +
              ROUND(
                CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor");
        if ServiceHeaderPar."Currency Code" = '' then
            GenJnlLinePar."Currency Factor" := 1
        else
            GenJnlLinePar."Currency Factor" := ServiceHeaderPar."Currency Factor";
        GenJnlLinePar.Correction := ServiceHeaderPar.Correction;
        GenJnlLinePar."Applies-to Doc. Type" := GenJnlLineDocType;
        GenJnlLinePar."Applies-to Doc. No." := GenJnlLineDocNo;
        GenJnlLinePar."Source Type" := GenJnlLinePar."source type"::Customer;
        GenJnlLinePar."Source No." := BillTo;
        GenJnlLinePar."Source Code" := SrcCode;
        GenJnlLinePar."Posting No. Series" := ServiceHeaderPar."Posting No. Series";
        GenJnlLinePar."System-Created Entry" := true;

        GenJnlLinePar.VIN := ServiceHeaderPar.VIN;
        GenJnlLinePar."Make Code" := ServiceHeaderPar."Make Code";
        GenJnlLinePar."Model Code" := ServiceHeaderPar."Model Code";
        GenJnlLinePar."Model Version No." := ServiceHeaderPar."Model Version No.";
        GenJnlLinePar."Vehicle Accounting Cycle No." := ServiceHeaderPar."Vehicle Accounting Cycle No.";
        GenJnlLinePar."Vehicle Serial No." := ServiceHeaderPar."Vehicle Serial No.";
        GenJnlPostLine.RunWithCheck(GenJnlLinePar);
    end;

    local procedure PrepmtDocTypeToDocType(DocumentType: Option Invoice,"Credit Memo"): Integer
    begin
        case DocumentType of
            Documenttype::Invoice:
                exit(2);
            Documenttype::"Credit Memo":
                exit(3);
        end;
        exit(2);
    end;

    local procedure CopyCommentLines(FromNumber: Code[20]; ToDocType: Integer; ToNumber: Code[20])
    var
        ServCommentLine: Record "Service Comment Line EDMS";
        SalesCommentLine2: Record "Sales Comment Line";
    begin
        ServCommentLine.SetRange("No.", FromNumber);
        if ServCommentLine.FindSet then
            repeat
                SalesCommentLine2.TransferFields(ServCommentLine);
                case ToDocType of
                    Database::"Sales Invoice Header":
                        SalesCommentLine2."Document Type" :=
                          SalesCommentLine2."document type"::"Posted Invoice";
                    Database::"Sales Cr.Memo Header":
                        SalesCommentLine2."Document Type" :=
                          SalesCommentLine2."document type"::"Posted Credit Memo";
                end;
                SalesCommentLine2."No." := ToNumber;
                SalesCommentLine2.Insert;
            until ServCommentLine.Next = 0;
    end;


    procedure UpdateVATOnLines(ServHeader: Record "Service Header EDMS"; var ServLine: Record "Service Line EDMS"; var VATAmountLine: Record "VAT Amount Line"; DocumentType: Option Invoice,"Credit Memo",Statistic)
    var
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        ChangeLogMgt: Codeunit "Change Log Management";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        PrepmtAmt: Decimal;
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        ServSetup: Record "Service Mgt. Setup EDMS";
    begin
        if ServHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(ServHeader."Currency Code");

        ApplyFilter(ServHeader, DocumentType, ServLine);
        ServLine.LockTable;
        if ServLine.FindSet then
            repeat
                PrepmtAmt := PrepmtAmount(ServLine, DocumentType);
                if PrepmtAmt <> 0 then begin
                    VATAmountLine.Get(
                      ServLine."Prepayment VAT Identifier",
                      ServLine."Prepmt. VAT Calc. Type",
                      ServLine."Prepayment Tax Group Code",
                      false,
                      PrepmtAmt >= 0);
                    if VATAmountLine.Modified then begin
                        xRecRef.GetTable(ServLine);
                        if not TempVATAmountLineRemainder.Get(
                             ServLine."Prepayment VAT Identifier",
                             ServLine."Prepmt. VAT Calc. Type",
                             ServLine."Prepayment Tax Group Code",
                             false,
                             PrepmtAmt >= 0)
                        then begin
                            TempVATAmountLineRemainder := VATAmountLine;
                            TempVATAmountLineRemainder.Init;
                            TempVATAmountLineRemainder.Insert;
                        end;

                        if ServHeader."Prices Including VAT" then begin
                            if PrepmtAmt = 0 then begin
                                VATAmount := 0;
                                NewAmountIncludingVAT := 0;
                            end else begin
                                VATAmount :=
                                  TempVATAmountLineRemainder."VAT Amount" +
                                  VATAmountLine."VAT Amount" * PrepmtAmt / VATAmountLine."Line Amount";
                                NewAmountIncludingVAT :=
                                  TempVATAmountLineRemainder."Amount Including VAT" +
                                  VATAmountLine."Amount Including VAT" * PrepmtAmt / VATAmountLine."Line Amount";
                            end;
                            NewAmount :=
                              ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision") -
                              ROUND(VATAmount, Currency."Amount Rounding Precision");
                            NewVATBaseAmount :=
                              ROUND(
                                NewAmount * (1 - ServHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                        end else begin
                            NewAmount := PrepmtAmt;
                            NewVATBaseAmount :=
                              ROUND(
                                NewAmount * (1 - ServHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                            if VATAmountLine."VAT Base" = 0 then
                                VATAmount := 0
                            else
                                VATAmount :=
                                  TempVATAmountLineRemainder."VAT Amount" +
                                  VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                            NewAmountIncludingVAT := NewAmount + ROUND(VATAmount, Currency."Amount Rounding Precision");
                        end;

                        ServLine."Prepayment Amount" := NewAmount;
                        ServLine."Prepayment Amount Incl. VAT" :=
                          ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision");  //13.03.2013 EDMS P8
                        ServLine."Prepmt. VAT Base Amt." := NewVATBaseAmount;

                        ServLine.Modify;
                        RecRef.GetTable(ServLine);

                        // ChangeLogMgt.LogModification(RecRef,xRecRef);//30.10.2012 EDMS
                        ChangeLogMgt.LogModification(RecRef);//30.10.2012 EDMS

                        TempVATAmountLineRemainder."Amount Including VAT" :=
                          NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                        TempVATAmountLineRemainder.Modify;
                    end;
                end;
            until ServLine.Next = 0;
    end;


    procedure CalcVATAmountLines(var ServHeader: Record "Service Header EDMS"; var ServLine: Record "Service Line EDMS"; var VATAmountLine: Record "VAT Amount Line"; DocumentType: Option Invoice,"Credit Memo",Statistic)
    var
        PrevVatAmountLine: Record "VAT Amount Line";
        Currency: Record Currency;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        NewAmount: Decimal;
    begin
        if ServHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(ServHeader."Currency Code");

        VATAmountLine.DeleteAll;

        ApplyFilter(ServHeader, DocumentType, ServLine);
        if ServLine.FindSet then
            repeat
                NewAmount := PrepmtAmount(ServLine, DocumentType);
                if NewAmount <> 0 then begin
                    if ServLine."Prepmt. VAT Calc. Type" in
                       [ServLine."vat calculation type"::"Reverse Charge VAT", ServLine."vat calculation type"::"Sales Tax"]
                    then
                        ServLine."VAT %" := 0;
                    if not VATAmountLine.Get(
                         ServLine."Prepayment VAT Identifier",
                         ServLine."Prepmt. VAT Calc. Type", ServLine."Prepayment Tax Group Code",
                         false, NewAmount >= 0)
                    then begin
                        VATAmountLine.Init;
                        VATAmountLine."VAT Identifier" := ServLine."Prepayment VAT Identifier";
                        VATAmountLine."VAT Calculation Type" := ServLine."Prepmt. VAT Calc. Type";
                        VATAmountLine."Tax Group Code" := ServLine."Prepayment Tax Group Code";
                        VATAmountLine."VAT %" := ServLine."Prepayment VAT %";
                        VATAmountLine.Modified := true;
                        VATAmountLine.Positive := NewAmount >= 0;
                        VATAmountLine."Includes Prepayment" := true;
                        VATAmountLine.Insert;
                    end;
                    VATAmountLine."Line Amount" := VATAmountLine."Line Amount" + NewAmount;
                    VATAmountLine.Modify;
                end;
            until ServLine.Next = 0;

        if VATAmountLine.FindSet then
            repeat
                if (PrevVatAmountLine."VAT Identifier" <> VATAmountLine."VAT Identifier") or
                   (PrevVatAmountLine."VAT Calculation Type" <> VATAmountLine."VAT Calculation Type") or
                   (PrevVatAmountLine."Tax Group Code" <> VATAmountLine."Tax Group Code") or
                   (PrevVatAmountLine."Use Tax" <> VATAmountLine."Use Tax")
                then
                    PrevVatAmountLine.Init;
                if ServHeader."Prices Including VAT" then begin
                    case VATAmountLine."VAT Calculation Type" of
                        VATAmountLine."vat calculation type"::"Normal VAT",
                        VATAmountLine."vat calculation type"::"Reverse Charge VAT":
                            begin
                                VATAmountLine."VAT Base" :=
                                  ROUND(
                                    (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") / (1 + VATAmountLine."VAT %" / 100),
                                    Currency."Amount Rounding Precision") - VATAmountLine."VAT Difference";
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(
                                    PrevVatAmountLine."VAT Amount" +
                                    (VATAmountLine."Line Amount" - VATAmountLine."VAT Base" - VATAmountLine."VAT Difference") *
                                    (1 - ServHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Base" + VATAmountLine."VAT Amount";
                                if VATAmountLine.Positive then
                                    PrevVatAmountLine.Init
                                else begin
                                    PrevVatAmountLine := VATAmountLine;
                                    PrevVatAmountLine."VAT Amount" :=
                                      (VATAmountLine."Line Amount" - VATAmountLine."VAT Base" - VATAmountLine."VAT Difference") *
                                      (1 - ServHeader."VAT Base Discount %" / 100);
                                    PrevVatAmountLine."VAT Amount" :=
                                      PrevVatAmountLine."VAT Amount" -
                                      ROUND(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                end;
                            end;
                        VATAmountLine."vat calculation type"::"Sales Tax":
                            begin
                                VATAmountLine."Amount Including VAT" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Base" :=
                                  ROUND(
                                    SalesTaxCalculate.ReverseCalculateTax(
                                      ServHeader."Tax Area Code", VATAmountLine."Tax Group Code", ServHeader."Tax Liable",
                                      ServHeader."Posting Date", VATAmountLine."Amount Including VAT", VATAmountLine.Quantity, ServHeader."Currency Factor"),
                                    Currency."Amount Rounding Precision");
                                VATAmountLine."VAT Amount" := VATAmountLine."VAT Difference" + VATAmountLine."Amount Including VAT" - VATAmountLine."VAT Base";
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmountLine."VAT %" := 0
                                else
                                    VATAmountLine."VAT %" := ROUND(100 * VATAmountLine."VAT Amount" / VATAmountLine."VAT Base", 0.00001);
                            end;
                    end;
                end else begin
                    case VATAmountLine."VAT Calculation Type" of
                        VATAmountLine."vat calculation type"::"Normal VAT",
                        VATAmountLine."vat calculation type"::"Reverse Charge VAT":
                            begin
                                VATAmountLine."VAT Base" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(
                                    PrevVatAmountLine."VAT Amount" +
                                    VATAmountLine."VAT Base" * VATAmountLine."VAT %" / 100 * (1 - ServHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" + VATAmountLine."VAT Amount";
                                if VATAmountLine.Positive then
                                    PrevVatAmountLine.Init
                                else begin
                                    PrevVatAmountLine := VATAmountLine;
                                    PrevVatAmountLine."VAT Amount" :=
                                      VATAmountLine."VAT Base" * VATAmountLine."VAT %" / 100 * (1 - ServHeader."VAT Base Discount %" / 100);
                                    PrevVatAmountLine."VAT Amount" :=
                                      PrevVatAmountLine."VAT Amount" -
                                      ROUND(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                end;
                            end;
                        VATAmountLine."vat calculation type"::"Sales Tax":
                            begin
                                VATAmountLine."VAT Base" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Amount" :=
                                  SalesTaxCalculate.CalculateTax(
                                    ServHeader."Tax Area Code", VATAmountLine."Tax Group Code", ServHeader."Tax Liable",
                                    ServHeader."Posting Date", VATAmountLine."VAT Base", VATAmountLine.Quantity, ServHeader."Currency Factor");
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmountLine."VAT %" := 0
                                else
                                    VATAmountLine."VAT %" := ROUND(100 * VATAmountLine."VAT Amount" / VATAmountLine."VAT Base", 0.00001);
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(VATAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Base" + VATAmountLine."VAT Amount";
                            end;
                    end;
                end;
                VATAmountLine."Calculated VAT Amount" := VATAmountLine."VAT Amount" - VATAmountLine."VAT Difference";
                VATAmountLine.Modify;
            until VATAmountLine.Next = 0;
    end;


    procedure BuildInvLineBuffer(ServHeader: Record "Service Header EDMS"; var ServLine: Record "Service Line EDMS"; DocumentType: Option Invoice,"Credit Memo",Statistic; var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer"; InvoiceRounding: Boolean)
    var
        GLAcc: Record "G/L Account";
        PrepmtInvBuf2: Record "Prepayment Inv. Line Buffer";
        PrepmtInvBufBillTo2: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBufferDummy: Record "Prepayment Inv. Line Buffer";
    begin
        ApplyFilter(ServHeader, DocumentType, ServLine);
        if ServLine.FindSet then
            repeat
                if PrepmtAmount(ServLine, DocumentType) <> 0 then begin
                    if ServLine.Quantity < 0 then
                        ServLine.FieldError(Quantity, StrSubstNo(Text018, ServHeader.FieldCaption("Prepayment %")));
                    if ServLine."Unit Price" < 0 then
                        ServLine.FieldError("Unit Price", StrSubstNo(Text018, ServHeader.FieldCaption("Prepayment %")));
                    if (ServLine."Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") or
                       (ServLine."Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                    then begin
                        GenPostingSetup.Get(
                          ServLine."Gen. Bus. Posting Group", ServLine."Gen. Prod. Posting Group");
                        GenPostingSetup.TestField("Service Prepayments Account");
                    end;
                    GLAcc.Get(GenPostingSetup."Service Prepayments Account");

                    //08.11.2007 P3 >>
                    if not ServHeader.Correction and (EDMSSetup."Default CM VAT Prod. Post. Grp" <> '')
                      and (DocumentType = Documenttype::"Credit Memo")
                    then
                        ServLine."VAT Prod. Posting Group" := EDMSSetup."Default CM VAT Prod. Post. Grp";
                    //08.11.2007 P3 >>
                    FillInvLineBuffer2(ServHeader, ServLine, GLAcc, PrepmtInvBuf2, PrepmtInvBufBillTo2);
                    if PrepmtInvBuf2.Amount <> 0 then begin
                        InsertInvLineBuffer(PrepmtInvBuf, PrepmtInvBuf2);
                        if InvoiceRounding then
                            RoundAmounts(
                              ServHeader, PrepmtInvBuf2, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferDummy);
                    end;
                end;
            until ServLine.Next = 0;
        if InvoiceRounding then
            if InsertInvoiceRounding(
              ServHeader, PrepmtInvBuf2, TotalPrepmtInvLineBuffer, ServLine."Line No.")
            then
                InsertInvLineBuffer(PrepmtInvBuf, PrepmtInvBuf2); // P8 the question is to which part rounding goes? For now is SellTo
    end;

    local procedure InsertExtendedText(TabNo: Integer; DocNo: Code[20]; GLAccNo: Code[20]; DocDate: Date; LanguageCode: Code[10]; var PrevLineNo: Integer)
    var
        TempExtTextLine: Record "Extended Text Line" temporary;
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TransferExtText: Codeunit "Transfer Extended Text";
        NextLineNo: Integer;
    begin
        TransferExtText.PrepmtGetAnyExtText(GLAccNo, TabNo, DocDate, LanguageCode, TempExtTextLine);
        if TempExtTextLine.FindSet then begin
            NextLineNo := PrevLineNo + 10000;
            repeat
                case TabNo of
                    Database::"Sales Invoice Line":
                        begin
                            SalesInvLine."Document No." := DocNo;
                            SalesInvLine."Line No." := NextLineNo;
                            SalesInvLine.Description := TempExtTextLine.Text;
                            SalesInvLine.Insert;
                        end;
                    Database::"Sales Cr.Memo Line":
                        begin
                            SalesCrMemoLine."Document No." := DocNo;
                            SalesCrMemoLine."Line No." := NextLineNo;
                            SalesCrMemoLine.Description := TempExtTextLine.Text;
                            SalesCrMemoLine.Insert;
                        end;
                end;
                PrevLineNo := NextLineNo;
                NextLineNo := NextLineNo + 10000;
            until TempExtTextLine.Next = 0;
        end;
    end;

    local procedure CompressInvLineBuffer(ServHeader: Record "Service Header EDMS"; var PrepmtInvBuffer: Record "Prepayment Inv. Line Buffer")
    var
        PrepmtInvBuffer2: Record "Prepayment Inv. Line Buffer" temporary;
    begin
        if ServHeader."Compress Prepayment" then
            exit;

        PrepmtInvBuffer.FindSet;
        repeat
            PrepmtInvBuffer2 := PrepmtInvBuffer;
            PrepmtInvBuffer2."Line No." := 0;
            if PrepmtInvBuffer2.Find then begin
                IncrAmountsEDMS(PrepmtInvBuffer, PrepmtInvBuffer2);
                PrepmtInvBuffer2.Modify;
            end else
                PrepmtInvBuffer2.Insert;
        until PrepmtInvBuffer.Next = 0;

        PrepmtInvBuffer.DeleteAll;

        PrepmtInvBuffer2.FindSet;
        repeat
            PrepmtInvBuffer := PrepmtInvBuffer2;
            PrepmtInvBuffer.Insert;
        until PrepmtInvBuffer2.Next = 0;
    end;

    local procedure ReverseAmounts(var PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    begin
        PrepmtInvLineBuffer.Amount := -PrepmtInvLineBuffer.Amount;
        PrepmtInvLineBuffer."Amount Incl. VAT" := -PrepmtInvLineBuffer."Amount Incl. VAT";
        PrepmtInvLineBuffer."VAT Amount" := -PrepmtInvLineBuffer."VAT Amount";
        PrepmtInvLineBuffer."VAT Base Amount" := -PrepmtInvLineBuffer."VAT Base Amount";
        PrepmtInvLineBuffer."Amount (ACY)" := -PrepmtInvLineBuffer."Amount (ACY)";
        PrepmtInvLineBuffer."VAT Amount (ACY)" := -PrepmtInvLineBuffer."VAT Amount (ACY)";
        PrepmtInvLineBuffer."VAT Base Amount (ACY)" := -PrepmtInvLineBuffer."VAT Base Amount (ACY)";
        PrepmtInvLineBuffer."VAT Difference" := -PrepmtInvLineBuffer."VAT Difference";
    end;

    local procedure RoundAmounts(ServHeader: Record "Service Header EDMS"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBufLCY: Record "Prepayment Inv. Line Buffer")
    var
        VAT: Boolean;
    begin
        IncrAmountsEDMS(PrepmtInvLineBuf, TotalPrepmtInvLineBuf);

        if ServHeader."Currency Code" <> '' then begin
            VAT := PrepmtInvLineBuf.Amount <> PrepmtInvLineBuf."Amount Incl. VAT";

            PrepmtInvLineBuf."Amount Incl. VAT" :=
              AmountToLCY(
                ServHeader, TotalPrepmtInvLineBuf."Amount Incl. VAT", TotalPrepmtInvLineBufLCY."Amount Incl. VAT");
            if VAT then
                PrepmtInvLineBuf.Amount :=
                  AmountToLCY(
                    ServHeader, TotalPrepmtInvLineBuf.Amount, TotalPrepmtInvLineBufLCY.Amount)
            else
                PrepmtInvLineBuf.Amount := PrepmtInvLineBuf."Amount Incl. VAT";
            PrepmtInvLineBuf."VAT Amount" :=
              AmountToLCY(
                ServHeader, TotalPrepmtInvLineBuf."VAT Amount", TotalPrepmtInvLineBufLCY."VAT Amount");
            PrepmtInvLineBuf."VAT Base Amount" :=
              AmountToLCY(
                ServHeader, TotalPrepmtInvLineBuf."VAT Base Amount", TotalPrepmtInvLineBufLCY."VAT Base Amount");
        end;

        IncrAmountsEDMS(PrepmtInvLineBuf, TotalPrepmtInvLineBufLCY);
    end;


    procedure ApplyFilter(ServHeader: Record "Service Header EDMS"; DocumentType: Option Invoice,"Credit Memo",Statistic; var ServLine: Record "Service Line EDMS")
    begin
        ServLine.Reset;
        ServLine.SetRange("Document Type", ServHeader."Document Type");
        ServLine.SetRange("Document No.", ServHeader."No.");
        ServLine.SetFilter(Type, '<>%1', ServLine.Type::Comment);
        if DocumentType in [Documenttype::Invoice, Documenttype::Statistic] then
            ServLine.SetFilter("Prepmt. Line Amount", '<>0')
        else
            ServLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
    end;


    procedure PrepmtAmount(ServLine: Record "Service Line EDMS"; DocumentType: Option Invoice,"Credit Memo",Statistic): Decimal
    begin
        case DocumentType of
            Documenttype::Statistic:
                exit(ServLine."Prepmt. Line Amount");
            Documenttype::Invoice:
                exit(ServLine."Prepmt. Line Amount" - ServLine."Prepmt. Amt. Inv.");
            else
                exit(ServLine."Prepmt. Amt. Inv." - ServLine."Prepmt Amt Deducted");
        end;
    end;


    procedure GetServiceLines(ServiceHeader: Record "Service Header EDMS"; DocumentType: Option Invoice,"Credit Memo",Statistic; var ToServiceLine: Record "Service Line EDMS")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        FromServiceLine: Record "Service Line EDMS";
        InvRoundingServiceLine: Record "Service Line EDMS";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TotalAmt: Decimal;
        NextLineNo: Integer;
    begin
        ApplyFilter(ServiceHeader, DocumentType, FromServiceLine);
        if FromServiceLine.FindSet then begin
            repeat
                ToServiceLine := FromServiceLine;
                ToServiceLine.Insert;
            until FromServiceLine.Next = 0;

            SalesSetup.Get;
            if SalesSetup."Invoice Rounding" then begin
                CalcVATAmountLines(ServiceHeader, ToServiceLine, TempVATAmountLine, 2);
                UpdateVATOnLines(ServiceHeader, ToServiceLine, TempVATAmountLine, 2);
                ToServiceLine.FindSet;
                repeat
                    TotalAmt := TotalAmt + ToServiceLine."Prepmt. Amt. Incl. VAT";
                until ToServiceLine.Next = 0;
                if InitInvoiceRoundingLine(ServiceHeader, TotalAmt, InvRoundingServiceLine) then begin
                    NextLineNo := ToServiceLine."Line No." + 1;
                    ToServiceLine := InvRoundingServiceLine;
                    ToServiceLine."Line No." := NextLineNo;

                    if DocumentType <> Documenttype::"Credit Memo" then
                        ToServiceLine."Prepmt. Line Amount" := ToServiceLine."Line Amount"
                    else
                        ToServiceLine."Prepmt. Amt. Inv." := ToServiceLine."Line Amount";
                    ToServiceLine."Prepmt. VAT Calc. Type" := ToServiceLine."VAT Calculation Type";
                    ToServiceLine."Prepayment VAT Identifier" := ToServiceLine."VAT Identifier";
                    ToServiceLine."Prepayment Tax Group Code" := ToServiceLine."Tax Group Code";
                    ToServiceLine."Prepayment VAT Identifier" := ToServiceLine."VAT Identifier";
                    ToServiceLine."Prepayment Tax Group Code" := ToServiceLine."Tax Group Code";
                    ToServiceLine."Prepayment VAT %" := ToServiceLine."VAT %";
                    ToServiceLine.Insert;
                end;
            end;
        end;
    end;

    local procedure CheckDimValuePosting(ServHeader: Record "Service Header EDMS"; var ServLine: Record "Service Line EDMS")
    var
        DimMgt: Codeunit DimensionManagement;
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        if ServLine."Line No." = 0 then begin
            TableIDArr[1] := Database::Customer;
            NumberArr[1] := ServHeader."Bill-to Customer No.";
            TableIDArr[2] := Database::Job;
            // NumberArr[2] := ServHeader."Job No.";
            TableIDArr[3] := Database::"Salesperson/Purchaser";
            NumberArr[3] := ServHeader."Service Advisor";
            TableIDArr[4] := Database::Campaign;
            NumberArr[4] := ServHeader."Campaign No.";
            TableIDArr[5] := Database::"Responsibility Center";
            NumberArr[5] := ServHeader."Responsibility Center";
        end else begin
            TableIDArr[1] := DimMgt.SalesLineTypeToTableID(ServLine.Type);
            NumberArr[1] := ServLine."No.";
            TableIDArr[2] := Database::Job;
            NumberArr[2] := ServLine."Job No.";
        end;
    end;


    procedure FillInvLineBuffer(ServHeader: Record "Service Header EDMS"; ServLine: Record "Service Line EDMS"; GLAcc: Record "G/L Account"; var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer")
    begin
        Clear(PrepmtInvBuf);

        PrepmtInvBuf."G/L Account No." := GLAcc."No.";
        PrepmtInvBuf."Gen. Bus. Posting Group" := ServLine."Gen. Bus. Posting Group";
        PrepmtInvBuf."VAT Bus. Posting Group" := ServLine."VAT Bus. Posting Group";
        PrepmtInvBuf."Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        PrepmtInvBuf."VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
        PrepmtInvBuf."VAT Calculation Type" := ServLine."Prepmt. VAT Calc. Type";
        PrepmtInvBuf."Global Dimension 1 Code" := ServLine."Shortcut Dimension 1 Code";
        PrepmtInvBuf."Global Dimension 2 Code" := ServLine."Shortcut Dimension 2 Code";
        PrepmtInvBuf."Job No." := ServLine."Job No.";
        PrepmtInvBuf.Amount := ServLine."Prepayment Amount";
        PrepmtInvBuf."Amount Incl. VAT" := ServLine."Prepayment Amount Incl. VAT";  //13.03.2013 EDMS P8
        PrepmtInvBuf."VAT Base Amount" := ServLine."Prepayment Amount";
        PrepmtInvBuf."VAT Amount" := (ServLine."Prepayment Amount Incl. VAT" - ServLine."Prepayment Amount");
        PrepmtInvBuf."Amount (ACY)" := ServLine."Prepayment Amount";
        PrepmtInvBuf."VAT Base Amount (ACY)" := ServLine."Prepayment Amount";
        PrepmtInvBuf."VAT Amount (ACY)" := (ServLine."Prepayment Amount Incl. VAT" - ServLine."Prepayment Amount");
        PrepmtInvBuf."VAT %" := ServLine."Prepayment VAT %";
        PrepmtInvBuf."VAT Identifier" := ServLine."Prepayment VAT Identifier";
        PrepmtInvBuf."Tax Area Code" := ServLine."Tax Area Code";
        PrepmtInvBuf."Tax Liable" := ServLine."Tax Liable";
        PrepmtInvBuf."Tax Group Code" := ServLine."Tax Group Code";
        if not ServHeader."Compress Prepayment" then begin
            PrepmtInvBuf."Line No." := ServLine."Line No.";
            PrepmtInvBuf.Description := ServLine.Description;
        end else
            PrepmtInvBuf.Description := GLAcc.Name;
    end;


    procedure FillInvLineBuffer2(ServHeader: Record "Service Header EDMS"; ServLine: Record "Service Line EDMS"; GLAcc: Record "G/L Account"; var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer"; var PrepmtInvBufBillTo: Record "Prepayment Inv. Line Buffer")
    var
        amtPart: Decimal;
    begin
        Clear(PrepmtInvBuf);
        Clear(PrepmtInvBufBillTo);
        FillInvLineBuffer(ServHeader, ServLine, GLAcc, PrepmtInvBuf);
    end;


    procedure InsertInvLineBuffer(var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer"; PrepmtInvBuf2: Record "Prepayment Inv. Line Buffer")
    begin
        PrepmtInvBuf := PrepmtInvBuf2;
        if PrepmtInvBuf.Find then begin
            IncrAmountsEDMS(PrepmtInvBuf2, PrepmtInvBuf);
            PrepmtInvBuf.Modify;
        end else
            PrepmtInvBuf.Insert;
    end;

    local procedure InsertInvoiceRounding(ServHeader: Record "Service Header EDMS"; var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer"; TotalPrepmtInvBuf: Record "Prepayment Inv. Line Buffer"; PrevLineNo: Integer): Boolean
    var
        ServLine: Record "Service Line EDMS";
    begin
        if InitInvoiceRoundingLine(ServHeader, TotalPrepmtInvBuf."Amount Incl. VAT", ServLine) then begin
            CreateDimensions(ServLine);//30.10.2012 EDMS
            Clear(PrepmtInvBuf);
            PrepmtInvBuf."Invoice Rounding" := true;
            PrepmtInvBuf."G/L Account No." := ServLine."No.";
            PrepmtInvBuf."Gen. Bus. Posting Group" := ServHeader."Gen. Bus. Posting Group";
            PrepmtInvBuf."VAT Bus. Posting Group" := ServHeader."VAT Bus. Posting Group";
            PrepmtInvBuf."Gen. Prod. Posting Group" := ServLine."Gen. Prod. Posting Group";
            PrepmtInvBuf."VAT Prod. Posting Group" := ServLine."VAT Prod. Posting Group";
            PrepmtInvBuf."VAT Calculation Type" := ServLine."VAT Calculation Type";
            PrepmtInvBuf."Global Dimension 1 Code" := ServLine."Shortcut Dimension 1 Code";
            PrepmtInvBuf."Global Dimension 2 Code" := ServLine."Shortcut Dimension 2 Code";
            PrepmtInvBuf.Amount := ServLine."Line Amount";
            PrepmtInvBuf."Amount Incl. VAT" := ServLine."Amount Including VAT";
            PrepmtInvBuf."VAT Base Amount" := ServLine."Line Amount";
            PrepmtInvBuf."VAT Amount" := ServLine."Amount Including VAT" - ServLine."Line Amount";
            PrepmtInvBuf."Amount (ACY)" := ServLine."Prepayment Amount";
            PrepmtInvBuf."VAT Base Amount (ACY)" := ServLine."Line Amount";
            PrepmtInvBuf."VAT Amount (ACY)" := ServLine."Amount Including VAT" - ServLine."Line Amount";
            PrepmtInvBuf."VAT %" := ServLine."VAT %";
            PrepmtInvBuf."VAT Identifier" := ServLine."VAT Identifier";
            PrepmtInvBuf."Tax Area Code" := ServLine."Tax Area Code";
            PrepmtInvBuf."Tax Liable" := ServLine."Tax Liable";
            PrepmtInvBuf."Tax Group Code" := ServLine."Tax Group Code";
            PrepmtInvBuf."Line No." := PrevLineNo + 10000;
            exit(true);
        end;
    end;

    local procedure IncrAmountsEDMS(PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer")
    begin
        TotalPrepmtInvLineBuf.Amount := TotalPrepmtInvLineBuf.Amount + PrepmtInvLineBuf.Amount;
        TotalPrepmtInvLineBuf."Amount Incl. VAT" := TotalPrepmtInvLineBuf."Amount Incl. VAT" + PrepmtInvLineBuf."Amount Incl. VAT";
        TotalPrepmtInvLineBuf."VAT Amount" := TotalPrepmtInvLineBuf."VAT Amount" + PrepmtInvLineBuf."VAT Amount";
        TotalPrepmtInvLineBuf."VAT Base Amount" := TotalPrepmtInvLineBuf."VAT Base Amount" + PrepmtInvLineBuf."VAT Base Amount";
        TotalPrepmtInvLineBuf."Amount (ACY)" := TotalPrepmtInvLineBuf."Amount (ACY)" + PrepmtInvLineBuf."Amount (ACY)";
        TotalPrepmtInvLineBuf."VAT Amount (ACY)" := TotalPrepmtInvLineBuf."VAT Amount (ACY)" + PrepmtInvLineBuf."VAT Amount (ACY)";
        TotalPrepmtInvLineBuf."VAT Base Amount (ACY)" := TotalPrepmtInvLineBuf."VAT Base Amount (ACY)" + PrepmtInvLineBuf."VAT Base Amount (ACY)";
    end;

    local procedure AmountToLCY(ServHeader: Record "Service Header EDMS"; TotalAmt: Decimal; PrevTotalAmt: Decimal): Decimal
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        CurrExchRate.Init;
        exit(
  ROUND(
    CurrExchRate.ExchangeAmtFCYToLCY(ServHeader."Posting Date", ServHeader."Currency Code", TotalAmt, ServHeader."Currency Factor")) -
  PrevTotalAmt);
    end;

    local procedure InitInvoiceRoundingLine(ServHeader: Record "Service Header EDMS"; TotalAmount: Decimal; var ServLine: Record "Service Line EDMS"): Boolean
    var
        Currency: Record Currency;
        CustPostingGr: Record "Customer Posting Group";
        GLAcc: Record "G/L Account";
        InvoiceRoundingAmount: Decimal;
    begin
        if ServHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(ServHeader."Currency Code");
        Currency.TestField("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -ROUND(
            TotalAmount -
            ROUND(
              TotalAmount,
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");

        if InvoiceRoundingAmount = 0 then
            exit(false);

        CustPostingGr.Get(ServHeader."Customer Posting Group");
        CustPostingGr.TestField("Invoice Rounding Account");
        GLAcc.Get(CustPostingGr."Invoice Rounding Account");
        ServLine.SetHideValidationDialog(true);
        ServLine."Document Type" := ServHeader."Document Type";
        ServLine."Document No." := ServHeader."No.";
        ServLine."System-Created Entry" := true;
        ServLine.Type := ServLine.Type::"G/L Account";
        ServLine.Validate("No.", CustPostingGr."Invoice Rounding Account");
        ServLine.Validate(Quantity, 1);
        if ServHeader."Prices Including VAT" then
            ServLine.Validate("Unit Price", InvoiceRoundingAmount)
        else
            ServLine.Validate(
              "Unit Price",
              ROUND(
                InvoiceRoundingAmount /
                (1 + (1 - ServHeader."VAT Base Discount %" / 100) * ServLine."VAT %" / 100),
                Currency."Amount Rounding Precision"));
        ServLine.Validate("Amount Including VAT", InvoiceRoundingAmount);
        exit(true);
    end;

    local procedure CreateDimensions(var ServLine: Record "Service Line EDMS")
    var
        SourceCodeSetup: Record "Source Code Setup";
        DimMgt: Codeunit DimensionManagement;
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        Dimsource: List of [Dictionary of [Integer, code[20]]];
    begin
        SourceCodeSetup.Get;
        /* TableID[1] := Database::"G/L Account";
         No[1] := ServLine."No.";
         TableID[2] := Database::Job;
         No[2] := ServLine."Job No.";
         TableID[3] := Database::"Responsibility Center";
         No[3] := ServLine."Responsibility Center";*/
        ServLine."Shortcut Dimension 1 Code" := '';
        ServLine."Shortcut Dimension 2 Code" := '';
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Database::"G/L Account", ServLine."No.");
        DimMgt.AddDimSource(Dimsource, Database::Job, ServLine."Job No.");
        DimMgt.AddDimSource(Dimsource, Database::"Responsibility Center", ServLine."Responsibility Center");
        DimMgt.GetDefaultDimID(
          Dimsource, SourceCodeSetup."Service Management EDMS",
          ServLine."Shortcut Dimension 1 Code", ServLine."Shortcut Dimension 2 Code", ServLine."Dimension Set ID", Database::"Service Line EDMS");//30.10.2012 EDMS
    end;


    procedure TransferServDoc(var DocRef: RecordRef; ServHeader: Record "Service Header EDMS"; DocType: Option Inv,CrMem)
    var
        FieldR: FieldRef;
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.Get;
        FieldR := DocRef.Field(2);
        FieldR.Value(ServHeader."Sell-to Customer No.");
        FieldR := DocRef.Field(4);
        FieldR.Value(ServHeader."Bill-to Customer No.");
        FieldR := DocRef.Field(35);
        FieldR.Value(ServHeader."Prices Including VAT");
        FieldR := DocRef.Field(28);
        FieldR.Value(ServHeader."Location Code");
        FieldR := DocRef.Field(31);
        FieldR.Value(ServHeader."Customer Posting Group");
        FieldR := DocRef.Field(74);
        FieldR.Value(ServHeader."Gen. Bus. Posting Group");
        FieldR := DocRef.Field(5);
        FieldR.Value(ServHeader."Bill-to Name");
        FieldR := DocRef.Field(7);
        FieldR.Value(ServHeader."Bill-to Address");
        FieldR := DocRef.Field(9);
        FieldR.Value(ServHeader."Bill-to City");
        FieldR := DocRef.Field(10);
        FieldR.Value(ServHeader."Bill-to Contact");
        FieldR := DocRef.Field(20);
        FieldR.Value(ServHeader."Posting Date");
        FieldR := DocRef.Field(29);
        FieldR.Value(ServHeader."Shortcut Dimension 1 Code");
        FieldR := DocRef.Field(30);
        FieldR.Value(ServHeader."Shortcut Dimension 2 Code");
        FieldR := DocRef.Field(37);
        FieldR.Value(ServHeader."Invoice Disc. Code");
        FieldR := DocRef.Field(40);
        FieldR.Value(ServHeader."Customer Disc. Group");
        FieldR := DocRef.Field(41);
        FieldR.Value(ServHeader."Language Code");
        FieldR := DocRef.Field(43);
        FieldR.Value(ServHeader."Service Advisor");
        FieldR := DocRef.Field(70);
        FieldR.Value(ServHeader."VAT Registration No.");
        FieldR := DocRef.Field(79);
        FieldR.Value(ServHeader."Sell-to Customer Name");
        FieldR := DocRef.Field(81);
        FieldR.Value(ServHeader."Sell-to Address");
        FieldR := DocRef.Field(83);
        FieldR.Value(ServHeader."Sell-to City");
        FieldR := DocRef.Field(84);
        FieldR.Value(ServHeader."Sell-to Contact");
        FieldR := DocRef.Field(85);
        FieldR.Value(ServHeader."Bill-to Post Code");
        FieldR := DocRef.Field(87);
        FieldR.Value(ServHeader."Bill-to Country/Region Code");
        FieldR := DocRef.Field(94);
        FieldR.Value(ServHeader."Bal. Account Type");
        FieldR := DocRef.Field(99);
        FieldR.Value(ServHeader."Document Date");
        FieldR := DocRef.Field(100);
        FieldR.Value(ServHeader."External Document No.");
        FieldR := DocRef.Field(104);
        FieldR.Value(ServHeader."Payment Method Code");
        FieldR := DocRef.Field(108);
        FieldR.Value(ServHeader."No. Series");
        FieldR := DocRef.Field(113);
        FieldR.Value(SourceCodeSetup."Service Management EDMS");
        FieldR := DocRef.Field(116);
        FieldR.Value(ServHeader."VAT Bus. Posting Group");
        FieldR := DocRef.Field(119);
        FieldR.Value(ServHeader."VAT Base Discount %");
        FieldR := DocRef.Field(480);
        FieldR.Value(ServHeader."Dimension Set ID");
        FieldR := DocRef.Field(25006000);
        FieldR.Value(2);
        FieldR := DocRef.Field(25006001);
        FieldR.Value(ServHeader."Deal Type");
        FieldR := DocRef.Field(25006120);
        FieldR.Value(ServHeader."No.");
        FieldR := DocRef.Field(25006370);
        FieldR.Value(ServHeader."Make Code");
        FieldR := DocRef.Field(25006371);
        FieldR.Value(ServHeader."Model Code");
        FieldR := DocRef.Field(25006378);
        FieldR.Value(ServHeader."Vehicle Serial No.");
        FieldR := DocRef.Field(25006379);
        FieldR.Value(ServHeader."Vehicle Accounting Cycle No.");
        FieldR := DocRef.Field(25006670);
        FieldR.Value(ServHeader.VIN);
        FieldR := DocRef.Field(25006995);
        FieldR.Value(ServHeader."Variable Field Run 1");
        FieldR := DocRef.Field(25006996);
        FieldR.Value(ServHeader."Variable Field Run 2");
        FieldR := DocRef.Field(25006997);
        FieldR.Value(ServHeader."Variable Field Run 3");
        FieldR := DocRef.Field(25006400);
        FieldR.Value(CopyStr(ServHeader.GetResourceTextFieldValue, 1, FieldR.Length));
        case DocType of
            Doctype::Inv:
                begin
                    FieldR := DocRef.Field(131);
                    FieldR.Value(ServHeader."Prepayment No. Series")
                end;
            Doctype::CrMem:
                begin
                    FieldR := DocRef.Field(134);
                    FieldR.Value(ServHeader."Prepmt. Cr. Memo No. Series")
                end
        end
    end;


    procedure GetFieldNo(RecRef: RecordRef; FieldName: Text[50]): Integer
    var
        i: Integer;
        FieldRef2: FieldRef;
    begin
        for i := 1 to RecRef.FieldCount do begin
            FieldRef2 := RecRef.FieldIndex(i);
            if FieldRef2.Name = FieldName then exit(FieldRef2.Number);
        end;
        Error('Field %1 was not found in table %2', FieldName, RecRef.Name);
    end;


    procedure UpdatePrepmtAmountOnServLines(ServiceHeader: Record "Service Header EDMS"; NewTotalPrepmtAmount: Decimal)
    var
        Currency: Record Currency;
        ServiceLine: Record "Service Line EDMS";
        ChangeLogMgt: Codeunit "Change Log Management";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        TotalLineAmount: Decimal;
        TotalPrepmtAmount: Decimal;
        TotalPrepmtAmtInv: Decimal;
        LastLineNo: Integer;
    begin
        if ServiceHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(ServiceHeader."Currency Code");

        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetFilter(Type, '<>%1', ServiceLine.Type::Comment);
        ServiceLine.SetFilter("Line Amount", '<>0');
        ServiceLine.SetFilter("Prepayment %", '<>0');
        ServiceLine.LockTable;
        if ServiceLine.Find('-') then
            repeat
                TotalLineAmount := TotalLineAmount + ServiceLine."Line Amount";
                TotalPrepmtAmtInv := TotalPrepmtAmtInv + ServiceLine."Prepmt. Amt. Inv.";
                LastLineNo := ServiceLine."Line No.";
            until ServiceLine.Next = 0
        else
            Error(Text017, ServiceLine.FieldCaption("Prepayment %"));
        if TotalLineAmount = 0 then
            Error(Text013, NewTotalPrepmtAmount);
        if not (NewTotalPrepmtAmount in [TotalPrepmtAmtInv .. TotalLineAmount]) then
            Error(Text016, TotalPrepmtAmtInv, TotalLineAmount);
        if ServiceLine.FindSet then
            repeat
                xRecRef.GetTable(ServiceLine);
                if ServiceLine."Line No." <> LastLineNo then
                    ServiceLine.Validate(
                      "Prepmt. Line Amount",
                      ROUND(
                        NewTotalPrepmtAmount * ServiceLine."Line Amount" / TotalLineAmount,
                        Currency."Amount Rounding Precision"))
                else
                    ServiceLine.Validate("Prepmt. Line Amount", NewTotalPrepmtAmount - TotalPrepmtAmount);
                TotalPrepmtAmount := TotalPrepmtAmount + ServiceLine."Prepmt. Line Amount";
                ServiceLine.Modify;
                RecRef.GetTable(ServiceLine);

                // ChangeLogMgt.LogModification(RecRef,xRecRef);//30.10.2012 EDMS
                ChangeLogMgt.LogModification(RecRef);//30.10.2012 EDMS
            until ServiceLine.Next = 0;
    end;


    procedure CopyBufferToBuffer(var PrepmtInvBufferFrom: Record "Prepayment Inv. Line Buffer"; var PrepmtInvBufferTo: Record "Prepayment Inv. Line Buffer"; ClearBufferTo: Boolean)
    begin
        if ClearBufferTo then
            PrepmtInvBufferTo.DeleteAll;
        if PrepmtInvBufferFrom.FindFirst then
            repeat
                PrepmtInvBufferTo.TransferFields(PrepmtInvBufferFrom);
                PrepmtInvBufferTo.Insert;
            until PrepmtInvBufferFrom.Next = 0;
    end;


    procedure SumPrepmt(ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS"; var VATAmountLine: Record "VAT Amount Line"; var TotalAmount: Decimal; var TotalVATAmount: Decimal; var VATAmountText: Text[30])
    var
        SalesSetup: Record "Sales & Receivables Setup";
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        PrepmtInvBufferBillTo: Record "Prepayment Inv. Line Buffer" temporary;
        TotalPrepmtBuf: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtBufLCY: Record "Prepayment Inv. Line Buffer";
        DifVATPct: Boolean;
        PrevVATPct: Decimal;
    begin
        SalesSetup.Get;
        CalcVATAmountLines(ServiceHeader, ServiceLine, VATAmountLine, 2);
        UpdateVATOnLines(ServiceHeader, ServiceLine, VATAmountLine, 2);
        BuildInvLineBuffer(ServiceHeader, ServiceLine, 2, PrepmtInvBuf, SalesSetup."Invoice Rounding");//30.10.2012 EDMS

        if PrepmtInvBuf.FindSet then begin
            PrevVATPct := PrepmtInvBuf."VAT %";
            repeat
                RoundAmounts(ServiceHeader, PrepmtInvBuf, TotalPrepmtBuf, TotalPrepmtBufLCY);
                if PrepmtInvBuf."VAT %" <> PrevVATPct then
                    DifVATPct := true;
            until PrepmtInvBuf.Next = 0;
        end;
        if PrepmtInvBufferBillTo.FindSet then begin
            PrevVATPct := PrepmtInvBufferBillTo."VAT %";
            repeat
                RoundAmounts(ServiceHeader, PrepmtInvBufferBillTo, TotalPrepmtBuf, TotalPrepmtBufLCY);
                if PrepmtInvBufferBillTo."VAT %" <> PrevVATPct then
                    DifVATPct := true;
            until PrepmtInvBufferBillTo.Next = 0;
        end;

        TotalAmount := TotalPrepmtBuf.Amount;
        TotalVATAmount := TotalPrepmtBuf."VAT Amount";
        if DifVATPct or (PrepmtInvBuf."VAT %" = 0) then
            VATAmountText := Text014
        else
            VATAmountText := StrSubstNo(Text015, PrevVATPct);
    end;


    procedure GetDimBuf(DimEntryNo: Integer)
    var
        TempDimBuf: Record "Dimension Buffer" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        TempDimBuf.Init;
        DimBufMgt.GetDimensions(DimEntryNo, TempDimBuf);
    end;

    local procedure RunGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlPostLine.Run(GenJnlLine);
    end;
}

