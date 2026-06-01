Codeunit 25006101 "Service-Post EDMS"
{
    //>>DELTA 01 RC (08/09/2021) Add Publisher OnBefore OnAfter

    // 09.10.2017 EB/AKR Warranty
    //   Modified function:
    //     CreateSalesLine
    // 
    // 06.10.2017 EB.AKR Warranty
    //   Modified function:
    //     CreatePostedServiceLines
    //     CreatePostedServiceHeader
    // 
    // 04.10.2017 EB.AKR Warranty
    //   Modified function:
    //     CreateSalesHeader
    // 
    // 20.12.2016 EB.RC DMS bug corrected
    //   Modified function:
    //     FillDetServJnlByResource
    // 
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified CreateInvoices(), removed UserProfile variable
    // 
    // 30.07.2015 EB.P30 #T045
    //   Modified procedure
    //     CreatePostedServiceLines
    // 
    // 30.07.2015 EB.P30 #T043
    //   Modified procedure
    //     PostServiceOrder
    //     ArchiveUnpostedOrder
    // 
    // 27.07.2015 EB.P30 #WIP
    //   Modified procedure:
    //     PostServiceOrder
    // 
    // 07.07.2015 EB.P7 #Schedule 3.0
    //   Modified procedure:
    //     FillDetServJnlByResource
    // 
    // 28.05.2015 EB.P30 #T030
    //   Modified procedure:
    //     FillDetServJnlByResource
    // 
    // 12.05.2015 EB.P30 #T030
    //   Modified procedures:
    //     FillDetServJnlByResource
    //     CreatePostedServiceLines
    // 
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     CreatePostedServiceLines
    // 
    // 10.05.2014 Elva Baltic P8 #S0082 MMG7.00
    //   * At prepaiment create in order must be filled vehicle
    // 
    // 08.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     CreateInvoices
    // 
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedures:
    //     CreateInvoices
    //     CreateSalesLine
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     CreateInvoices
    // 
    // 02.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Modified function CreateSalesHeader
    // 
    // 31.03.2014 Elva Baltic P18
    //   Modified
    //     GetNewInvoiceNo
    // 
    // 31.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     CreateSalesHeader
    //     CreateSalesLine
    // 
    // 26.03.2014 Elva Baltic P18 MMG7.00
    //   Added Code to
    //     CopyServCommLinesToPosted()
    //     CreatePostedServiceHeader(VAR ServiceOrder : Record "Service Header EDMS")
    // 
    // 14.02.2014 Elva Baltic P7 #F145 MMG7.00
    //   * Reset Due Date
    // 
    // 25.10.2013 EDMS P8
    //   * Added function CheckDim
    // 
    // 13.06.2013 EDMS P8
    //   * Merged code with NAV2009
    // 
    // 10.04.2013 EDMS P8
    //   * fix in dimension set for header
    // 
    // 27.02.2013 EDMS P8
    //   * Implement new dimension set
    // 
    // 23.01.2013 EDMS P8
    //   * Implement use of Resources
    // 
    // 2012.09.15 EDMS P8
    //   * Add support for fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 2012.07.31 EDMS P8
    //   * fill of new fields: 'Variable Field Run 2', 'Variable Field Run 3', 'Document Line No.'
    // 
    // 2012.04.17 EDMS P8
    //   * Implemet use of "Det. Serv. Journal Line" table
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management
    // 
    // 28.01.2010 EDMS P2
    //   * Added function CreateTodoFromService
    //   * Added code CreateServiceHeader, CreateServiceLine, CreateSalesLine
    // 
    // 10.07.2009. EDMS P2
    //   * Added function SumServiceLines2
    //   * Added code CreateSalesHeader

    TableNo = "Service Header EDMS";

    trigger OnRun()
    begin
        ServiceHeaderTemp := Rec;
        ServiceHeaderGlobal.Get(Rec."Document Type", Rec."No.");
        CheckServiceHeader(Rec);
        CheckDim(Rec);  //25.10.2013 EDMS P8
        //>>DELTA 01
        OnBeforePostServiceDoc(Rec, FALSE, FALSE);
        //<<DELTA
        CreateInvoices(Rec);
        PostServiceOrder(Rec);
        PostSalesInvoices(ServiceHeaderTemp);
        //>>DELTA 01
        OnAfterPostServiceDoc(Rec, FALSE, FALSE);
        //<<DELTA 01
    end;

    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        cuReleaseSalesDoc: Codeunit "Release Sales Document";
        tcSer003: label 'Put Items to "';
        ScheduleMgt: Codeunit "Service Schedule Mgt.";
        tcSer004: label '" invoice.';
        tcSer005: label 'Invoice creation is interupted.';
        TotalServiceLine: Record "Service Line EDMS";
        TempServiceLine: Record "Service Line EDMS" temporary;
        TempPrepaymentServiceLine: Record "Service Line EDMS" temporary;
        GenPostingSetup: Record "General Posting Setup";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        GLSetup: Record "General Ledger Setup";
        CustPostingGr: Record "Customer Posting Group";
        ServiceHeaderGlobal: Record "Service Header EDMS";
        ServiceLineGlobal: Record "Service Line EDMS";
        ServiceLineACY: Record "Service Line EDMS";
        TotalServiceLineLCY: Record "Service Line EDMS";
        SalesSetup: Record "Sales & Receivables Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        UseDate: Date;
        RoundingLineNo: Integer;
        RoundingLineInserted: Boolean;
        LastLineRetrieved: Boolean;
        Text004: label 'An error occurred during the posting of the %1 %2.';
        Text016: label 'VAT Amount';
        Text017: label '%1% VAT';
        Text028: label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text029: label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text030: label 'The dimensions used in %1 %2 are invalid. %3';
        Text031: label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        Text047: label 'The quantity to ship does not match the quantity defined in Item Tracking.';
        Text048: label 'must be at least %1';
        SourceCode: Code[20];
        SourceCodeSetup: Record "Source Code Setup";
        //SIEAssgntLine: Record "SIE Assignment";
        //SIEAssgnt: Codeunit "SIE Assignment";
        NoSeriesMgt: Codeunit "No. Series";
        ServiceHeaderTemp: Record "Service Header EDMS" temporary;
        ReserveServLine: Codeunit "Service Line EDMS-Reserve";
        Text050: label 'Service Line reservation must be to inventory.';
        InvPartSellTo: Boolean;
        InvPartBillTo: Boolean;
        SalesDocType: Integer;
        SalesDocNoSellTo: Code[20];
        SalesDocNoBillTo: Code[20];
        TempDocNo: Code[20];
        Text100: label 'Resource must be specified for %1 %2 line No. %3';
        Text101: label 'Transfer Order exist for service document %1 %2.';
        TempLaborCostGenJnlLine: Record "Gen. Journal Line" temporary;
        PreviewMode: Boolean;
        PostingDateWarning: label 'Posting date is not today. Do you want to continue?';
        PostingDateError: Label 'Posting has been cancelled. You can update Posting Date.';


    procedure CreateInvoices(ServiceHeader: Record "Service Header EDMS")
    var
        Vehicle: Record Vehicle;
        ServiceLine: Record "Service Line EDMS";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Location: Record Location;
        NewSalesLine: Record "Sales Line";
        ServLedgEntry: Record "Service Ledger Entry EDMS";
        ReservEntryST: Record "Reservation Entry";
        ReservEntryBT: Record "Reservation Entry";
        BalLineOffset: Integer;
        AllTransferred: Boolean;
        TextNothingToPost: label 'Nothing to post.';
        NewLineNo: Integer;
        UseServiceLineNo: Boolean;
        DocAttachMgtEDMS: Codeunit "Document Attachment Mgmt EDMS";
    begin
        ServiceSetup.Get;
        UseServiceLineNo := true;

        // Checks whether there is anything to post
        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetFilter(Type, '');
        ServiceLine.SetFilter("No.", '<>''''');
        if not ServiceLine.FindFirst then
            Error(TextNothingToPost);

        if ServiceSetup."Resource No. Mandatory" then begin
            ServiceLine.Reset;
            ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
            ServiceLine.SetRange("Document No.", ServiceHeader."No.");
            ServiceLine.SetRange(Type, ServiceLine.Type::Labor);
            if ServiceLine.FindFirst then
                repeat
                    if (ServiceLine.GetResourceTextFieldValue = '') and (ServiceHeader.GetResourceTextFieldValue = '') then
                        Error(Text100, ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."Line No.");
                until ServiceLine.Next = 0;
        end;

        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.FindFirst;

        if (ServiceHeader."Document Type" = ServiceHeader."document type"::Order) and ServiceSetup."Payment Method Mandatory" then
            ServiceHeader.TestField("Payment Method Code");

        ServiceHeader.TestField("Location Code");

        ArchiveUnpostedOrder(ServiceHeader);

        // Creates Sales Headers
        SalesHeader.Reset;
        CreateSalesHeader(ServiceHeader, SalesHeader);
        SalesDocType := SalesHeader."Document Type";

        case SalesDocType of
            SalesHeader."document type"::Invoice:
                if (ServiceSetup."Posted Invoice Nos." <> '')
                   and not ServiceSetup."Use Order No. for Inv.&Cr.Memo"
                then
                    SalesHeader.Validate("Posting No. Series", ServiceSetup."Posted Invoice Nos.");
            SalesHeader."document type"::"Credit Memo":
                begin
                    if (ServiceSetup."Posted Credit Memo Nos." <> '')
                       and not ServiceSetup."Use Order No. for Inv.&Cr.Memo"
                    then
                        SalesHeader.Validate("Posting No. Series", ServiceSetup."Posted Credit Memo Nos.");

                    // Automatic application
                    ServLedgEntry.SetCurrentkey("Document Type", "Service Order No.", "Bill-to Customer No.");
                    ServLedgEntry.SetRange("Document Type", ServLedgEntry."document type"::Invoice);
                    ServLedgEntry.SetRange("Service Order No.", ServiceHeader."Applies-to Doc. No.");
                    ServLedgEntry.SetRange("Bill-to Customer No.", ServiceHeader."Bill-to Customer No.");
                    if ServLedgEntry.FindFirst then begin
                        SalesHeader."Applies-to Doc. Type" := SalesHeader."applies-to doc. type"::Invoice;
                        SalesHeader."Applies-to Doc. No." := ServLedgEntry."Document No."
                    end;
                end
        end;

        SalesHeader.Validate("Salesperson Code", ServiceHeader."Service Advisor");
        SalesHeader."Allow Line Disc." := true;
        SalesHeader.Validate("Payment Method Code", ServiceHeader."Payment Method Code");
        SalesHeader.Validate("Payment Terms Code", ServiceHeader."Payment Terms Code");
        SalesHeader."Due Date" := ServiceHeader."Due Date";
        SalesHeader."External Document No." := ServiceHeader."External Document No.";
        SalesHeader."Prices Including VAT" := ServiceHeader."Prices Including VAT";
        SalesHeader.Validate("Document Profile", SalesHeader."document profile"::Service);
        SalesHeader.Validate("Location Code", ServiceHeader."Location Code");
        if ServiceHeader."Vehicle Serial No." <> '' then begin
            Vehicle.Get(ServiceHeader."Vehicle Serial No.");
            if ServiceHeader."Vehicle Item Charge No." <> '' then begin
                Vehicle.TestField("Model Version No.");
                SalesHeader."Vehicle Item Charge No." := ServiceHeader."Vehicle Item Charge No.";
            end;
        end;
        SalesHeader."Model Version No." := Vehicle."Model Version No.";
        SalesHeader."Shortcut Dimension 1 Code" := ServiceHeader."Shortcut Dimension 1 Code";
        SalesHeader."Shortcut Dimension 2 Code" := ServiceHeader."Shortcut Dimension 2 Code";
        SalesHeader."Dimension Set ID" := ServiceHeader."Dimension Set ID";

        SalesHeader."Ship-to Code" := ServiceHeader."Service Address Code";
        SalesHeader."Ship-to Name" := ServiceHeader."Service Address Name";
        SalesHeader."Ship-to Address" := ServiceHeader."Service Address";
        SalesHeader."Ship-to Address 2" := ServiceHeader."Service Address 2";
        SalesHeader."Ship-to Post Code" := ServiceHeader."Service Address Post Code";
        SalesHeader."Ship-to City" := ServiceHeader."Service Address City";
        SalesHeader."Ship-to Contact" := ServiceHeader."Service Address Contact";
        SalesHeader."Opportunity No." := ServiceHeader."Opportunity No.";
        OnBeforeModifySalesInvoiceHeader(SalesHeader, ServiceHeader);

        SalesHeader.Modify;

        UpdateOpportunities(ServiceHeader, SalesHeader);

        CopyServCommLinesToSale(ServiceHeader."Document Type", SalesHeader."Document Type", ServiceHeader."No.", SalesHeader."No.");

        DocAttachMgtEDMS.DocCopyServiceToSales(ServiceHeader, SalesHeader);
        // Create Sales Lines
        repeat
            CreateSalesLine(SalesHeader, ServiceLine, NewSalesLine, NewLineNo, UseServiceLineNo);
        until ServiceLine.Next = 0;
    end;


    procedure GetNoSeriesCode(SalesHeader: Record "Sales Header"): Code[10]
    begin
        case SalesHeader."Document Type" of
            SalesHeader."document type"::Invoice:
                exit(ServiceSetup."Invoice Nos.");
            SalesHeader."document type"::"Credit Memo":
                exit(ServiceSetup."Credit Memo Nos.")
        end
    end;


    procedure CreateSalesHeader(ServiceHeader: Record "Service Header EDMS"; var SalesHeader: Record "Sales Header")
    var
        NoSeriesMgt: Codeunit "No. Series";
        codNo: Code[20];
        Vehicle: Record Vehicle;
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        // Creates sales invoice header
        ServiceSetup.Get;
        if ServiceSetup."Deal Type Mandatory" then
            ServiceHeader.TestField("Deal Type");

        SalesHeader.Init;

        if ServiceHeader."Document Type" = ServiceHeader."document type"::Order then
            SalesHeader.Validate("Document Type", SalesHeader."document type"::Invoice)
        else
            SalesHeader.Validate("Document Type", SalesHeader."document type"::"Credit Memo");

        if ServiceSetup."Use Order No. for Inv.&Cr.Memo" then begin
            //codNo := GetNewInvoiceNo(ServiceHeader);
            SalesHeader.Validate("No.", ServiceHeader."No.");
        end else
            SalesHeader."No. Series" := GetNoSeriesCode(SalesHeader);
        //>>DELTA 01
        OnBeforeInitSalesInvoiceHeader(SalesHeader, ServiceHeader);
        //<<DELTA 01
        SalesHeader.Insert(true);

        SalesHeader.SetDontFindContract(true);
        SalesHeader.Validate("Posting Date", ServiceHeader."Posting Date");
        SalesHeader.SetHideValidationDialog(true);
        SalesHeader.Validate("Sell-to Customer No.", ServiceHeader."Sell-to Customer No.");
        SalesHeader.Validate("Bill-to Customer No.", ServiceHeader."Bill-to Customer No.");
        SalesHeader.Validate("Document Date", ServiceHeader."Document Date");
        SalesHeader.Validate("Payment Method Code", ServiceHeader."Payment Method Code");
        SalesHeader."Make Code" := ServiceHeader."Make Code";
        SalesHeader."Model Code" := ServiceHeader."Model Code";
        SalesHeader."Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
        SalesHeader."Vehicle Accounting Cycle No." := ServiceHeader."Vehicle Accounting Cycle No.";
        SalesHeader."Vehicle Registration No." := ServiceHeader."Vehicle Registration No.";
        SalesHeader."Service Document" := true;
        SalesHeader."VAT Bus. Posting Group" := ServiceHeader."VAT Bus. Posting Group";
        SalesHeader."Service Document No." := ServiceHeader."No.";
        SalesHeader."Order Date" := ServiceHeader."Order Date";
        SalesHeader."Posting No." := codNo;
        SalesHeader."Deal Type Code" := ServiceHeader."Deal Type";
        SalesHeader."Vehicle Status Code" := ServiceHeader."Vehicle Status Code";
        SalesHeader."Language Code" := ServiceHeader."Language Code";
        SalesHeader."Warranty Claim No." := ServiceHeader."Warranty Claim No.";
        SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type";
        SalesHeader."Applies-to Doc. No." := SalesHeader."Applies-to Doc. No.";

        FillSalesVariableFields(SalesHeader, ServiceHeader);
        SalesHeader."Variable Field Run 1" := ServiceHeader."Variable Field Run 1";
        SalesHeader."Variable Field Run 2" := ServiceHeader."Variable Field Run 2";
        SalesHeader."Variable Field Run 3" := ServiceHeader."Variable Field Run 3";

        SalesHeader."Currency Code" := ServiceHeader."Currency Code";
        SalesHeader."Currency Factor" := ServiceHeader."Currency Factor";
        SalesHeader."EU 3-Party Trade" := ServiceHeader."EU 3-Party Trade";
        SalesHeader."Transaction Type" := ServiceHeader."Transaction Type";
        SalesHeader."Transport Method" := ServiceHeader."Transport Method";
        SalesHeader."Exit Point" := ServiceHeader."Exit Point";
        SalesHeader.Area := ServiceHeader.Area;
        SalesHeader."Transaction Specification" := ServiceHeader."Transaction Specification";
        SalesHeader."Shortcut Dimension 1 Code" := ServiceHeader."Shortcut Dimension 1 Code";
        SalesHeader."Shortcut Dimension 2 Code" := ServiceHeader."Shortcut Dimension 2 Code";
        SalesHeader."Dimension Set ID" := ServiceHeader."Dimension Set ID";
        SalesHeader."Invoice Discount Calculation" := ServiceHeader."Invoice Discount Calculation";
        SalesHeader."Invoice Discount Value" := ServiceHeader."Invoice Discount Value";

        SalesHeader."Service Document No." := ServiceHeader."No.";        // link to service document
        SalesHeader.Correction := ServiceHeader.Correction;
        SalesHeader."Contract No." := ServiceHeader."Contract No.";

        SalesHeader."Prepayment %" := ServiceHeader."Prepayment %";
        SalesHeader."Last Prepayment No." := ServiceHeader."Last Prepayment No.";
        SalesHeader."Prepayment No. Series" := ServiceHeader."Prepayment No. Series";
        SalesHeader."Prepmt. Cr. Memo No. Series" := ServiceHeader."Prepmt. Cr. Memo No. Series";
        SalesHeader."Prepmt. Payment Discount %" := ServiceHeader."Prepmt. Payment Discount %";

        SalesHeader."Initial Service Order No." := ServiceHeader."Initial Service Order No."; //04.10.2017 EB.AKR Warranty
        SalesHeader."Work Description" := ServiceHeader."Work Description";

        SalesHeader."Your Reference" := ServiceHeader."Your Reference";

        AfterFillSalesHeaderFromServiceHeader(SalesHeader, ServiceHeader);

        RecordLinkManagement.CopyLinks(ServiceHeader, SalesHeader);

        if (SalesHeader."Vehicle Registration No." = '') and (SalesHeader."Vehicle Serial No." <> '') then
            if Vehicle.Get(SalesHeader."Vehicle Serial No.") then
                SalesHeader."Vehicle Registration No." := Vehicle."Registration No.";
        //>>DELTA 01
        OnBeforeInsertSalesInvoiceHeader(SalesHeader, ServiceHeader);
        //<<DELTA 01
        SalesHeader.Modify
    end;


    procedure CreateSalesLine(SalesHeader: Record "Sales Header"; var ServiceLine: Record "Service Line EDMS"; var SalesLine: Record "Sales Line"; var NewLineNo: Integer; UseServiceLineNo: Boolean)
    var
        GenPostSetup: Record "General Posting Setup";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesShpmtHdr: Record "Sales Shipment Header";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        // Creates a new sales line

        if UseServiceLineNo then
            NewLineNo := ServiceLine."Line No."
        else
            NewLineNo += 10000;

        SalesLine.Init;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NewLineNo;
        SalesLine."Make Code" := ServiceLine."Make Code";
        SalesLine."Line Type" := ServiceLine.Type;
        SalesLine."Service Order No. EDMS" := ServiceLine."Document No.";
        SalesLine."Service Order Line No. EDMS" := ServiceLine."Line No.";
        SalesLine."Order Line Type No." := ServiceLine."No.";
        SalesLine."Appl.-to Item Entry" := ServiceLine."Appl.-to Item Entry";
        SalesLine.Group := ServiceLine.Group;
        SalesLine."Group ID" := ServiceLine."Group ID";
        SalesLine."Package No." := ServiceLine."Package No.";
        SalesLine."Package Version No." := ServiceLine."Package Version No.";
        SalesLine."Package Version Spec. Line No." := ServiceLine."Package Version Spec. Line No.";
        SalesLine."External Serv. Tracking No." := ServiceLine."External Serv. Tracking No.";
        SalesLine."Contract No." := ServiceLine."Contract No.";

        case ServiceLine.Type of
            ServiceLine.Type::Labor:
                begin
                    SalesLine.Type := SalesLine.Type::"G/L Account";
                    GenPostSetup.Get(ServiceLine."Gen. Bus. Posting Group", ServiceLine."Gen. Prod. Posting Group");
                    GenPostSetup.TestField("Sales Account");
                    SalesLine."No." := GenPostSetup."Sales Account";
                end;

            ServiceLine.Type::"External Service":
                begin
                    SalesLine.Type := SalesLine.Type::"External Service";
                    SalesLine."No." := ServiceLine."No.";
                end;

            ServiceLine.Type::Item:
                begin
                    SalesLine.Type := SalesLine.Type::Item;
                    SalesLine."No." := ServiceLine."No.";
                end;

            ServiceLine.Type::"G/L Account":
                begin
                    SalesLine.Type := SalesLine.Type::"G/L Account";
                    SalesLine."No." := ServiceLine."No.";
                end;

            ServiceLine.Type::Comment:
                begin
                    SalesLine.Type := SalesLine.Type::" ";
                    SalesLine."No." := ServiceLine."No.";
                end;

            ServiceLine.Type::Resource:
                begin
                    SalesLine.Type := SalesLine.Type::Resource;
                    SalesLine."No." := ServiceLine."No.";
                end;
        end;

        SalesLine."Line Discount %" := ServiceLine."Line Discount %";

        SalesLine.Validate("No.");
        SalesLine."Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";
        SalesLine."VAT Bus. Posting Group" := ServiceLine."VAT Bus. Posting Group";

        SalesLine."Location Code" := ServiceLine."Location Code";
        SalesLine."Allow Line Disc." := true;
        //>>Delta Move "Unit Cost (LCY)" before validate
        SalesLine."Unit Cost (LCY)" := ServiceLine."Unit Cost (LCY)";
        //<<Delta Move "Unit Cost (LCY)" before validate

        if ServiceLine.Type <> ServiceLine.Type::Comment then begin
            SalesLine.Validate("Gen. Prod. Posting Group", ServiceLine."Gen. Prod. Posting Group");
            SalesLine.Validate("VAT Prod. Posting Group", ServiceLine."VAT Prod. Posting Group");
            SalesLine.Validate("Unit of Measure Code", ServiceLine."Unit of Measure Code");
            SalesLine.Validate(Quantity, ServiceLine.Quantity);
            SalesLine.Validate("Unit Price", ServiceLine."Unit Price");
            SalesLine.Validate("Unit Cost (LCY)");
            SalesLine.Validate("Line Discount %", ServiceLine."Line Discount %");
        end;

        SalesLine.Description := ServiceLine.Description;
        SalesLine."Shipment Date" := SalesHeader."Posting Date";
        SalesLine.VIN := SalesHeader.VIN;
        SalesLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
        SalesLine."Document Profile" := SalesLine."document profile"::Service;
        SalesLine."Appl.-from Item Entry" := ServiceLine."Appl.-from Item Entry";
        SalesLine."Inv. Discount Amount" := ServiceLine."Inv. Discount Amount";
        SalesLine."Inv. Disc. Amount to Invoice" := ServiceLine."Inv. Disc. Amount to Invoice";

        SalesLine."Prepayment %" := ServiceLine."Prepayment %";
        SalesLine."Prepmt. Line Amount" := ServiceLine."Prepmt. Line Amount";
        SalesLine."Prepmt. Amt. Inv." := ServiceLine."Prepmt. Amt. Inv.";
        SalesLine."Prepmt. Amt. Incl. VAT" := ServiceLine."Prepmt. Amt. Incl. VAT";
        SalesLine."Prepayment Amount" := ServiceLine."Prepayment Amount";
        SalesLine."Prepmt. VAT Base Amt." := ServiceLine."Prepmt. VAT Base Amt.";
        SalesLine."Prepayment VAT %" := ServiceLine."Prepayment VAT %";
        SalesLine."Prepmt. VAT Calc. Type" := ServiceLine."Prepmt. VAT Calc. Type";
        SalesLine."Prepayment VAT Identifier" := ServiceLine."Prepayment VAT Identifier";
        SalesLine."Prepayment Tax Area Code" := ServiceLine."Prepayment Tax Area Code";
        SalesLine."Prepayment Tax Liable" := ServiceLine."Prepayment Tax Liable";
        SalesLine."Prepayment Tax Group Code" := ServiceLine."Prepayment Tax Group Code";
        SalesLine."Prepmt Amt to Deduct" := ServiceLine."Prepmt Amt to Deduct";
        SalesLine."Prepmt Amt Deducted" := ServiceLine."Prepmt Amt Deducted";
        SalesLine."Prepayment Line" := ServiceLine."Prepayment Line";
        SalesLine."Prepmt. Amount Inv. Incl. VAT" := ServiceLine."Prepayment Amount Incl. VAT";
        SalesLine."Prepmt. Amount Inv. (LCY)" :=
          ROUND(CurrExchRate.ExchangeAmtFCYToLCY(ServiceLine."Posting Date", ServiceLine."Currency Code",
                ServiceLine."Prepayment Amount", SalesHeader."Currency Factor"), 0.01);
        SalesLine."Prepmt. VAT Amount Inv. (LCY)" :=
          ROUND(CurrExchRate.ExchangeAmtFCYToLCY(ServiceLine."Posting Date", ServiceLine."Currency Code",
                ServiceLine."Prepayment Amount Incl. VAT" - ServiceLine."Prepmt. VAT Base Amt.", SalesHeader."Currency Factor"), 0.01);


        //>>DELTA XX
        SalesLine."Variant Code" := ServiceLine."Variant Code";
        //<<DELTA XX
        ReserveServLine.TransServLineToSalesLine(
          ServiceLine, SalesLine, ServiceLine."Outstanding Qty. (Base)");

        SalesLine."Standard Time" := ServiceLine."Standard Time";
        SalesLine."Campaign No." := ServiceLine."Campaign No.";
        FillSalesLineVariableFields(SalesLine, ServiceLine);
        SalesLine."Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
        SalesLine."Dimension Set ID" := ServiceLine."Dimension Set ID";

        // do link to service document
        SalesLine."Service Order No. EDMS" := ServiceLine."Document No.";
        SalesLine."Service Order Line No. EDMS" := ServiceLine."Line No.";

        //SalesLine."Labor Type" := ServiceLine."Labor Type";                   //09.10.2017 EB/AKR Warranty  SalesLine."Labor Type" no such a field
        SalesLine."Ordering Price Type Code" := ServiceLine."Ordering Price Type Code";   //09.10.2017 EB/AKR Warranty
                                                                                          //SalesLine."Separate Line on Invoice" := "Separate Line on Invoice";   //09.10.2017 EB/AKR Warranty  SalesLine."Separate Line on Invoice" no such a field
        AfterFillSalesLineFromServiceLine(SalesLine, ServiceLine);
        //>>DELTA XX
        OnBeforeInsertSalesInvoiceLine(SalesLine, SalesHeader, ServiceLine);
        //<<DELTA XX

        SalesLine.Insert;
    end;


    procedure GetNewInvoiceNo(ServiceHeader: Record "Service Header EDMS") codNo: Code[20]
    var
        SalHed: Record "Sales Header";
        SalInv: Record "Sales Invoice Header";
        NoPost: Code[20];
    begin
        SalHed.SetFilter("No.", ServiceHeader."No." + '*');
        if SalHed.FindLast then begin
            if SalHed."No." = ServiceHeader."No." then
                codNo := ServiceHeader."No." + '-01'
            else
                codNo := IncStr(SalHed."No.");
        end else
            codNo := ServiceHeader."No.";

        SalInv.SetFilter("No.", ServiceHeader."No." + '*');
        if SalInv.FindLast then begin
            if SalInv."No." = ServiceHeader."No." then
                NoPost := ServiceHeader."No." + '-01'
            else
                NoPost := IncStr(SalInv."No.");
        end else
            NoPost := ServiceHeader."No.";

        if codNo < NoPost then
            codNo := NoPost;
    end;


    procedure InsertServiceHeaderLine(ServiceHeader: Record "Service Header EDMS"; var NewServiceLine: Record "Service Line EDMS"; LineNo: Integer; BillTo: Code[20]; LineType: Integer; ItemNo: Code[20])
    begin
        NewServiceLine.Init;
        NewServiceLine."Document Type" := ServiceHeader."Document Type";
        NewServiceLine."Document No." := ServiceHeader."No.";
        NewServiceLine."Line No." := LineNo;
        NewServiceLine.Validate("Sell-to Customer No.", ServiceHeader."Sell-to Customer No.");
        NewServiceLine.Validate("Bill-to Customer No.", BillTo);
        NewServiceLine."Location Code" := ServiceHeader."Location Code";
        NewServiceLine."System-Created Entry" := true;
        NewServiceLine."Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
        NewServiceLine."Make Code" := ServiceHeader."Make Code";
        NewServiceLine."Vehicle Registration No." := ServiceHeader."Vehicle Registration No.";
        NewServiceLine."Model Code" := ServiceHeader."Model Code";
        NewServiceLine.VIN := ServiceHeader.VIN;
        NewServiceLine.Type := LineType;
        NewServiceLine.Validate("No.", ItemNo);
        NewServiceLine.Insert;
    end;


    procedure PostSalesInvoices(var ServiceHeader: Record "Service Header EDMS" temporary): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
    begin
        //COMMIT;                                                                 // 30.07.2015 EB.P30 #T043
        SalesHeader.Reset;
        SalesHeader.SetCurrentkey("Service Document No.");
        SalesHeader.SetRange("Service Document No.", ServiceHeader."No.");
        if ServiceHeader."Document Type" = ServiceHeader."document type"::Order then
            SalesHeader.SetRange("Document Type", SalesHeader."document type"::Invoice)
        else
            SalesHeader.SetRange("Document Type", SalesHeader."document type"::"Credit Memo");
        if SalesHeader.FindFirst then
            repeat
                SalesHeader2 := SalesHeader;
                Clear(SalesPost);
                //      IF NOT                                                            // 30.07.2015 EB.P30 #T043
                SalesPost.SetPreviewMode(PreviewMode);
                //>>DELTA RC
                SalesPost.SetSuppressCommit(true);
                //>>DELTA RC
                SalesPost.Run(SalesHeader2);
            //      THEN                                                              // 30.07.2015 EB.P30 #T043
            //        ERROR(Text004,SalesHeader2.TABLECAPTION,SalesHeader2."No.")     // 30.07.2015 EB.P30 #T043
            until SalesHeader.Next = 0;
    end;


    procedure DelSalesInvoices(var ServiceHeader: Record "Service Header EDMS" temporary): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
    begin
        SalesHeader.Reset;
        SalesHeader.SetCurrentkey("Service Document No.");
        SalesHeader.SetRange("Service Document No.", ServiceHeader."No.");
        if ServiceHeader."Document Type" = ServiceHeader."document type"::Order then
            SalesHeader.SetRange("Document Type", SalesHeader."document type"::Invoice)
        else
            SalesHeader.SetRange("Document Type", SalesHeader."document type"::"Credit Memo");
        if SalesHeader.FindFirst then
            repeat
                SalesHeader2 := SalesHeader;
                SalesHeader2.Delete(true);
            until SalesHeader.Next = 0;
    end;


    procedure GetServiceLines(var NewServiceHeader: Record "Service Header EDMS"; var NewServiceLine: Record "Service Line EDMS"; QtyType: Option General,Invoicing,Shipping)
    var
        OldServiceLine: Record "Service Line EDMS";
        MergedServiceLines: Record "Service Line EDMS" temporary;
        TotalAdjCostLCY: Decimal;
    begin
        ServiceHeaderGlobal := NewServiceHeader;

        //EDMS1.0.00 >>
        if QtyType = Qtytype::Invoicing then begin
            CreateServPrepaymentLines(ServiceHeaderGlobal, TempPrepaymentServiceLine, false);
            MergeServiceLines(ServiceHeaderGlobal, OldServiceLine, TempPrepaymentServiceLine, MergedServiceLines);
            SumServiceLines(NewServiceLine, MergedServiceLines, QtyType, true, false, TotalAdjCostLCY);
        end else
            SumServiceLines(NewServiceLine, OldServiceLine, QtyType, true, false, TotalAdjCostLCY);
        //EDMS1.0.00 <<
    end;


    procedure CreateServPrepaymentLines(ServiceHeader: Record "Service Header EDMS"; var TempPrepmtServiceLine: Record "Service Line EDMS"; CompleteFunctionality: Boolean)
    var
        GLAcc: Record "G/L Account";
        ServiceLine: Record "Service Line EDMS";
        TempExtTextLine: Record "Extended Text Line" temporary;
        DimMgt: Codeunit DimensionManagement;
        TransferExtText: Codeunit "Transfer Extended Text";
        NextLineNo: Integer;
        Fraction: Decimal;
        TempLineFound: Boolean;
        GenLedgSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        if not ServiceLine.FindLast then
            exit;
        NextLineNo := ServiceLine."Line No." + 10000;
        ServiceLine.SetFilter(Quantity, '>0');
        TempPrepmtServiceLine.SetHasBeenShown;
        if ServiceLine.FindSet then
            repeat
                if CompleteFunctionality then begin
                    Fraction := ServiceLine.Quantity / ServiceLine.Quantity;
                    case true of
                        (ServiceLine."Prepmt Amt to Deduct" <> 0) and
                      (ServiceLine."Prepmt Amt to Deduct" > Fraction * ServiceLine."Line Amount"):
                            ServiceLine.FieldError(
                              "Prepmt Amt to Deduct",
                              StrSubstNo(Text047,
                                ROUND(Fraction * ServiceLine."Line Amount", GLSetup."Amount Rounding Precision")));
                        (ServiceLine."Prepmt. Amt. Inv." <> 0) and
                      ((1 - Fraction) * ServiceLine."Line Amount" <
                      ServiceLine."Prepmt. Amt. Inv." - ServiceLine."Prepmt Amt Deducted" - ServiceLine."Prepmt Amt to Deduct"):
                            ServiceLine.FieldError(
                              "Prepmt Amt to Deduct",
                              StrSubstNo(Text048,
                                ROUND(
                                  ServiceLine."Prepmt. Amt. Inv." - ServiceLine."Prepmt Amt Deducted" - (1 - Fraction) * ServiceLine."Line Amount",
                                  GLSetup."Amount Rounding Precision")));
                    end;
                end;
                if ServiceLine."Prepmt Amt to Deduct" <> 0 then begin
                    if (ServiceLine."Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") or
                       (ServiceLine."Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                    then begin
                        GenPostingSetup.Get(ServiceLine."Gen. Bus. Posting Group", ServiceLine."Gen. Prod. Posting Group");
                        GenPostingSetup.TestField("Service Prepayments Account");
                    end;
                    GLAcc.Get(GenPostingSetup."Service Prepayments Account");
                    TempLineFound := false;
                    if ServiceHeader."Compress Prepayment" then begin
                        TempPrepmtServiceLine.SetRange("No.", GLAcc."No.");
                        if TempPrepmtServiceLine.FindFirst then
                            TempLineFound := (ServiceLine."Dimension Set ID" = TempPrepmtServiceLine."Dimension Set ID");
                        TempPrepmtServiceLine.SetRange("No.");
                    end;
                    if TempLineFound then begin
                        TempPrepmtServiceLine.Validate(
                          "Unit Price", TempPrepmtServiceLine."Unit Price" + ServiceLine."Prepmt Amt to Deduct");
                        TempPrepmtServiceLine.Modify;
                    end else begin
                        TempPrepmtServiceLine.Init;
                        TempPrepmtServiceLine."Document Type" := ServiceHeader."Document Type";
                        TempPrepmtServiceLine."Document No." := ServiceHeader."No.";
                        TempPrepmtServiceLine."Line No." := 0;
                        TempPrepmtServiceLine."System-Created Entry" := true;
                        if CompleteFunctionality then
                            TempPrepmtServiceLine.Validate(Type, TempPrepmtServiceLine.Type::"G/L Account")
                        else
                            TempPrepmtServiceLine.Type := TempPrepmtServiceLine.Type::"G/L Account";
                        TempPrepmtServiceLine.Validate("No.", GenPostingSetup."Service Prepayments Account");
                        if GLSetup."Calc.Prepmt.VAT by Line PostGr" then begin
                            TempPrepmtServiceLine.Validate("Gen. Prod. Posting Group", ServiceLine."Gen. Prod. Posting Group");
                            TempPrepmtServiceLine.Validate("VAT Prod. Posting Group", ServiceLine."VAT Prod. Posting Group")
                        end;
                        TempPrepmtServiceLine.Validate(Quantity, -1);
                        TempPrepmtServiceLine."Prepayment Line" := true;
                        TempPrepmtServiceLine.Validate("Unit Price", ServiceLine."Prepmt Amt to Deduct");
                        TempPrepmtServiceLine."Line No." := NextLineNo;
                        NextLineNo := NextLineNo + 10000;
                        TempPrepmtServiceLine.Insert;


                        TransferExtText.PrepmtGetAnyExtText(
                          TempPrepmtServiceLine."No.", Database::"Sales Invoice Line",
                          ServiceHeader."Document Date", ServiceHeader."Language Code", TempExtTextLine);
                        if TempExtTextLine.FindSet then
                            repeat
                                TempPrepmtServiceLine.Init;
                                TempPrepmtServiceLine.Description := TempExtTextLine.Text;
                                TempPrepmtServiceLine."System-Created Entry" := true;
                                TempPrepmtServiceLine."Prepayment Line" := true;
                                TempPrepmtServiceLine."Line No." := NextLineNo;
                                NextLineNo := NextLineNo + 10000;
                                TempPrepmtServiceLine.Insert;
                            until TempExtTextLine.Next = 0;
                    end;
                end;
            until ServiceLine.Next = 0
    end;


    procedure MergeServiceLines(ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS"; var ServiceLine2: Record "Service Line EDMS"; var MergedServiceLine: Record "Service Line EDMS")
    begin
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        if ServiceLine.FindSet then
            repeat
                MergedServiceLine := ServiceLine;
                MergedServiceLine.Insert;
            until ServiceLine.Next = 0;
        ServiceLine2.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine2.SetRange("Document No.", ServiceHeader."No.");
        if ServiceLine2.FindSet then
            repeat
                MergedServiceLine := ServiceLine2;
                MergedServiceLine.Insert;
            until ServiceLine2.Next = 0;
    end;


    procedure PostServiceOrder(ServiceHeader: Record "Service Header EDMS")
    var
        ServiceOrder: Record "Service Header EDMS";
        Vehicle: Record Vehicle;
        DocType: Option Quote,"Order","Return Order";
        ServiceWIPMgt: Codeunit "Service WIP Management";

    begin
        // 27.07.2015 EB.P30 #WIP >>
        ServiceWIPMgt.ServiceOrderCheckAndPostWIP(ServiceHeader."No.", ServiceHeader."Posting Date");
        ServiceWIPMgt.DeleteCalculatedWIP(ServiceHeader."No.");
        // 27.07.2015 EB.P30 #WIP <<

        CreateServPrepaymentLines(ServiceHeader, TempPrepaymentServiceLine, true);

        ServiceHeader.TestField("Document Type");
        ServiceHeader.TestField("Sell-to Customer No.");
        ServiceHeader.TestField("Bill-to Customer No.");
        ServiceHeader.TestField("Posting Date");
        ServiceHeader.TestField("Document Date");

        SourceCodeSetup.Get;
        SourceCode := SourceCodeSetup."Service Management EDMS";
        //>>DELTA 01
        OnBeforeCreatePostedServiceHeader(ServiceHeader);
        //<<DELTA 01
        CreatePostedServiceHeader(ServiceHeader);

        CreatePostedServiceLines(ServiceHeader);
        OnBeforePostServiceOrder(ServiceHeader);
        //Copy SIE Assignment lines
        /*
        SIEAssgntLine.SetCurrentkey("Applies-to Type", "Applies-to Doc. Type", "Applies-to Doc. No.", "Line No.");
        SIEAssgntLine.SetRange("Applies-to Type", Database::"Service Line EDMS");
        SIEAssgntLine.SetRange("Applies-to Doc. Type", SIEAssgntLine."applies-to doc. type"::Order);
        SIEAssgntLine.SetRange("Applies-to Doc. No.", ServiceHeader."No.");
        if SIEAssgntLine.Count > 0 then
            SIEAssgnt.MoveAssgntToPostedDocLine(Database::"Service Line EDMS", ServiceHeader."Document Type",
              ServiceHeader."No.", 0, Database::"Posted Serv. Order Line", ServiceHeader."Document Type",
              ServiceHeader."Posting No.", 0);
        */


        DeleteServiceOrder(ServiceHeader);
    end;


    procedure CreatePostedServiceHeader(var ServiceOrder: Record "Service Header EDMS")
    var
        PstOrdHeader: Record "Posted Serv. Order Header";
        PstReturnOrdHeader: Record "Posted Serv. Ret. Order Header";
        ServCommentLine: Record "Service Comment Line EDMS";
        ServPlanMgt: Codeunit "Service Plan Management";
        DocAttachMgtEDMS: Codeunit "Document Attachment Mgmt EDMS";
    begin
        case ServiceOrder."Document Type" of
            ServiceOrder."document type"::"Return Order":
                begin
                    // Insert posted return order header
                    PstReturnOrdHeader.Init;
                    PstReturnOrdHeader.TransferFields(ServiceOrder);

                    if (ServiceOrder."Pst. Return Order No." = '') then begin
                        ServiceOrder.TestField("Pst. Return Order No. Series");
                        ServiceOrder."Pst. Return Order No." := NoSeriesMgt.GetNextNo(ServiceOrder."Pst. Return Order No. Series", ServiceOrder."Posting Date", true);
                    end;
                    PstReturnOrdHeader.TestField("No.");

                    PstReturnOrdHeader."No." := ServiceOrder."Pst. Return Order No.";
                    PstReturnOrdHeader."No. Series" := ServiceOrder."Pst. Return Order No. Series";
                    PstReturnOrdHeader."Return Order No. Series" := ServiceOrder."No. Series";
                    PstReturnOrdHeader."Return Order No." := ServiceOrder."No.";
                    if ServiceSetup."Ext. Doc. No. Mandatory" then
                        ServiceOrder.TestField("External Document No.");

                    PstReturnOrdHeader."No. Printed" := 0;
                    FillPstReturnVariableFields(PstReturnOrdHeader, ServiceOrder);
                    CopyServCommLinesToPosted(ServiceOrder."Document Type", ServiceOrder."Document Type", ServiceOrder."No.", PstReturnOrdHeader."No."); // 26.03.2014 Elva Baltic P18 MMG7.00
                    PstReturnOrdHeader.Insert(true);

                    ServPlanMgt.UpdateDocLinkDocNo(1, ServiceOrder."No.", 3, PstReturnOrdHeader."No.");

                    ModifyProcessChecklist(ServiceOrder, Database::"Posted Serv. Ret. Order Header", PstReturnOrdHeader."No.");

                    //23.02.2010 EDMSB P2 >>
                    ScheduleMgt.PostingServHdr(ServiceOrder, PstReturnOrdHeader."No.");
                    //23.02.2010 EDMSB P2 <<

                    DocAttachMgtEDMS.DocAttachForPostedServiceDocs(ServiceOrder, PstOrdHeader, PstReturnOrdHeader);

                end;

            ServiceOrder."document type"::Order:
                begin
                    PstOrdHeader.Init;
                    PstOrdHeader.TransferFields(ServiceOrder);

                    if (ServiceOrder."Posting No." = '') then begin
                        ServiceOrder.TestField("Posting No. Series");
                        ServiceOrder."Posting No." := NoSeriesMgt.GetNextNo(ServiceOrder."Posting No. Series", ServiceOrder."Posting Date", true);
                    end;

                    PstOrdHeader.TestField("No.");
                    PstOrdHeader."No." := ServiceOrder."Posting No.";
                    PstOrdHeader."No. Series" := ServiceOrder."Posting No. Series";
                    PstOrdHeader."Order No." := ServiceOrder."No.";
                    PstOrdHeader."Order No. Series" := ServiceOrder."No. Series";
                    if ServiceSetup."Ext. Doc. No. Mandatory" then
                        ServiceOrder.TestField("External Document No.");

                    FillPstOrderVariableFields(PstOrdHeader, ServiceOrder);
                    //23.01.2013 EDMS P8 >>
                    PstOrdHeader.Resources := CopyStr(ServiceOrder.GetResourceTextFieldValue, 1, 100);
                    //23.01.2013 EDMS P8 <<
                    CopyServCommLinesToPosted(ServiceOrder."Document Type", ServiceOrder."Document Type", ServiceOrder."No.", PstOrdHeader."No."); // 26.03.2014 Elva Baltic P18 MMG7.00

                    AfterFillPostedServiceHeader(PstOrdHeader, ServiceOrder);

                    PstOrdHeader.Insert;

                    ServPlanMgt.UpdateDocLinkDocNo(0, ServiceOrder."No.", 2, PstOrdHeader."No.");

                    ModifyProcessChecklist(ServiceOrder, Database::"Posted Serv. Order Header", PstOrdHeader."No.");
                    //>>DELTA 01
                    OnAfterModifyProcessChecklist(ServiceOrder, PstOrdHeader);
                    //<<DELTA 01
                    //28.01.2010 EDMSB P2 >>
                    CreateToDoFromService(PstOrdHeader);
                    //28.01.2010 EDMSB P2 <<

                    //23.02.2010 EDMSB P2 >>
                    ScheduleMgt.PostingServHdr(ServiceOrder, PstOrdHeader."No.");
                    //23.02.2010 EDMSB P2 <<

                    DocAttachMgtEDMS.DocAttachForPostedServiceDocs(ServiceOrder, PstOrdHeader, PstReturnOrdHeader);
                    OnAfterCreatePostedServiceHeader(PstOrdHeader);
                end
        end
    end;


    procedure CreatePostedServiceLines(ServiceHeader: Record "Service Header EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
        PstOrdLine: Record "Posted Serv. Order Line";
        ServJnlLine: Record "Serv. Journal Line";
        ServJnlPostLine: Codeunit "Serv. Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        PstReturnOrdLine: Record "Posted Serv. Return Order Line";
        ServJnlLineLineNo: Integer;
        ServLedgEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange("Prepayment Line", false);
        if not ServiceLine.FindFirst then
            exit;
        ServJnlLineLineNo := 0;
        repeat
            ServJnlLine.Init;
            ServJnlLine."Posting Date" := ServiceHeader."Posting Date";
            ServJnlLine."Document Date" := ServiceHeader."Document Date";
            ServJnlLine."Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
            ServJnlLine."Make Code" := ServiceHeader."Make Code";
            ServJnlLine."Model Code" := ServiceHeader."Model Code";
            ServJnlLine."Vehicle Accounting Cycle No." := ServiceHeader."Vehicle Accounting Cycle No.";
            ServJnlLine."Model Version No." := ServiceHeader."Model Version No.";

            ServJnlLine.Description := ServiceLine.Description;
            ServJnlLine."Job No." := ServiceLine."Job No.";
            ServJnlLine."Unit of Measure Code" := ServiceLine."Unit of Measure Code";
            ServJnlLine."Minutes Per UoM" := ServiceLine."Minutes Per UoM";
            ServJnlLine."Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
            ServJnlLine."Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
            ServJnlLine."Dimension Set ID" := ServiceLine."Dimension Set ID";
            ServJnlLine."Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";

            ServJnlLine."Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
            ServJnlLine."Entry Type" := ServJnlLine."entry type"::Usage;
            ServJnlLine."Initial Service Order No." := ServiceHeader."Initial Service Order No."; //06.10.2017 EB.AKR Warranty

            case ServiceHeader."Document Type" of
                ServiceHeader."document type"::"Return Order":
                    begin
                        ServJnlLine."Document Type" := ServJnlLine."document type"::"Return Order";
                        ServJnlLine."Document No." := ServiceHeader."Pst. Return Order No.";
                        if ServiceHeader."Applies-to Doc. No." <> '' then
                            ServJnlLine."Service Order No." := ServiceHeader."Applies-to Doc. No."
                        else
                            ServJnlLine."Service Order No." := ServiceHeader."No.";
                    end;
                ServiceHeader."document type"::Order:
                    begin
                        ServJnlLine."Document Type" := ServJnlLine."document type"::Order;
                        ServJnlLine."Document No." := ServiceHeader."Posting No.";
                        ServJnlLine."Service Order No." := ServiceHeader."No."
                    end
            end;

            ServJnlLine."Pre-Assigned No." := ServiceHeader."No.";
            ServJnlLine."External Document No." := ServiceHeader."External Document No.";

            CalculateAmountLCY(ServJnlLine, ServiceHeader, ServiceLine);
            if not ServiceHeader."Prices Including VAT" then begin
                ServJnlLine."Line Discount Amount" := ServiceLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := ServiceLine."Inv. Discount Amount";
                ServJnlLine."Unit Price" := ServiceLine."Unit Price";
            end else begin
                ServJnlLine."Line Discount Amount" := ROUND(ServiceLine."Line Discount Amount" / (1 + ServiceLine."VAT %" / 100));
                ServJnlLine."Inv. Discount Amount" := ROUND(ServiceLine."Inv. Discount Amount" / (1 + ServiceLine."VAT %" / 100));
                ServJnlLine."Unit Price" := ROUND(ServiceLine."Unit Price" / (1 + ServiceLine."VAT %" / 100));
            end;

            if ServiceHeader."Document Type" = ServiceHeader."document type"::Order then begin
                ServJnlLine.Quantity := ServiceLine.Quantity;
                ServJnlLine."Quantity (Hours)" := ServiceLine.GetTimeQty;
                ServJnlLine."Unit Cost" := ServiceLine."Unit Cost (LCY)";
                ServJnlLine."Total Cost" := ServiceLine."Unit Cost (LCY)" * ServJnlLine.Quantity;
                ServJnlLine.Amount := ServiceLine.Amount;
                ServJnlLine."Amount Including VAT" := ServiceLine."Amount Including VAT";
                ServJnlLine."Amount (LCY)" := ServJnlLine."Amount (LCY)";
                ServJnlLine."Amount Including VAT (LCY)" := ServJnlLine."Amount Including VAT (LCY)";
                ServJnlLine."Line Discount Amount" := ServJnlLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := ServJnlLine."Inv. Discount Amount";
                ServJnlLine."Line Discount Amount (LCY)" := ServJnlLine."Line Discount Amount (LCY)";
                ServJnlLine."Inv. Discount Amount (LCY)" := ServJnlLine."Inv. Discount Amount (LCY)";
            end else begin  //Return Order
                ServJnlLine.Quantity := -ServiceLine.Quantity;
                ServJnlLine."Quantity (Hours)" := -ServiceLine.GetTimeQty;
                ServJnlLine."Unit Cost" := ServiceLine."Unit Cost (LCY)";
                ServJnlLine."Total Cost" := ServiceLine."Unit Cost (LCY)" * ServJnlLine.Quantity;
                ServJnlLine.Amount := -ServiceLine.Amount;
                ServJnlLine."Amount Including VAT" := -ServiceLine."Amount Including VAT";
                ServJnlLine."Amount (LCY)" := -ServJnlLine."Amount (LCY)";
                ServJnlLine."Amount Including VAT (LCY)" := -ServJnlLine."Amount Including VAT (LCY)";
                ServJnlLine."Line Discount Amount" := -ServJnlLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := -ServJnlLine."Inv. Discount Amount";
                ServJnlLine."Line Discount Amount (LCY)" := -ServJnlLine."Line Discount Amount (LCY)";
                ServJnlLine."Inv. Discount Amount (LCY)" := -ServJnlLine."Inv. Discount Amount (LCY)";
            end;
            ServJnlLine."Source Code" := SourceCode;
            ServJnlLine.Chargeable := true;
            ServJnlLine.Type := ServiceLine.Type;
            ServJnlLine."No." := ServiceLine."No.";
            ServJnlLine."Customer No." := ServiceHeader."Sell-to Customer No.";
            ServJnlLine."Bill-to Customer No." := ServiceHeader."Bill-to Customer No.";
            ServJnlLine."Posting No. Series" := ServiceHeader."Posting No. Series";
            ServJnlLine."Location Code" := ServiceHeader."Location Code";
            ServJnlLine."Discount %" := ServiceLine."Line Discount %";
            ServJnlLine."Payment Method Code" := ServiceHeader."Payment Method Code";
            ServJnlLine."Warranty Claim No." := ServiceHeader."Warranty Claim No.";
            ServJnlLine."Variable Field Run 1" := ServiceHeader."Variable Field Run 1";
            ServJnlLine."Variable Field Run 2" := ServiceHeader."Variable Field Run 2";
            ServJnlLine."Variable Field Run 3" := ServiceHeader."Variable Field Run 3";
            ServJnlLine."Package No." := ServiceLine."Package No.";
            ServJnlLine."Package Version No." := ServiceLine."Package Version No.";
            ServJnlLine."Package Version Spec. Line No." := ServiceLine."Package Version Spec. Line No.";
            ServJnlLine."Currency Code" := ServiceHeader."Currency Code";
            ServJnlLine."Deal Type Code" := ServiceHeader."Deal Type";

            //28.01.2010 EDMSB P2 >>
            ServJnlLine."Standard Time" := ServiceLine."Standard Time";
            ServJnlLine."Campaign No." := ServiceLine."Campaign No.";
            //28.01.2010 EDMSB P2 <<

            // 29.09.2011 EDMS P8 >>
            ServJnlLine."Vehicle Axle Code" := ServiceLine."Vehicle Axle Code";
            ServJnlLine."Tire Position Code" := ServiceLine."Tire Position Code";
            ServJnlLine."Tire Code" := ServiceLine."Tire Code";
            ServJnlLine."Tire Operation Type" := ServiceLine."Tire Operation Type";
            ServJnlLine."New Vehicle Axle Code" := ServiceLine."New Vehicle Axle Code";
            ServJnlLine."New Tire Position Code" := ServiceLine."New Tire Position Code";
            // 29.09.2011 EDMS P8 <<



            // 2012.07.31 EDMS P8 >>
            ServJnlLine."Document Line No." := ServiceLine."Line No.";
            ServJnlLine."Plan No." := ServiceLine."Plan No.";
            ServJnlLine."Plan Stage Recurrence" := ServiceLine."Plan Stage Recurrence";
            ServJnlLine."Plan Stage Code" := ServiceLine."Plan Stage Code";
            // 2012.07.31 EDMS P8 <<

            // 30.07.2015 EB.P30 #T045 >>
            ServJnlLine."Service Receiver" := ServiceHeader."Service Advisor";
            // 30.07.2015 EB.P30 #T045 <<

            ServJnlLine."Labor Type" := ServiceLine."Labor Type"; //06.10.2017 EB.AKR Warranty

            ServJnlLine."Service Address Code" := ServiceHeader."Service Address Code";
            ServJnlLine."Service Address" := ServiceHeader."Service Address";

            FillServJournalVariableFields(ServJnlLine, ServiceLine);

            AfterFillServiceJournalInPost(ServJnlLine, ServiceLine);

            //2012.06.28 EDMS P8 >>
            FillDetServJnlByResource(ServJnlLine, ServiceLine."Document Type", ServiceLine."Document No.",
              ServiceLine."Line No.", '110');
            //2012.06.28 EDMS P8 <<

            ServJnlPostLine.RunWithCheck(ServJnlLine);

            case ServiceHeader."Document Type" of
                ServiceHeader."document type"::"Return Order":
                    begin
                        PstReturnOrdLine.Init;
                        PstReturnOrdLine.TransferFields(ServiceLine);
                        PstReturnOrdLine."Document No." := ServiceHeader."Pst. Return Order No.";
                        //12.05.2015 EB.P30 #T030 >>
                        ServiceLine.CalcFields("Res. Cost Amount Finished");
                        ServLedgEntry.Reset;
                        ServLedgEntry.SetRange("Document Type", ServLedgEntry."document type"::"Return Order");
                        ServLedgEntry.SetRange("Document No.", ServiceLine."Document No.");
                        ServLedgEntry.SetRange("Document Line No.", ServiceLine."Line No.");
                        if ServLedgEntry.FindFirst then
                            ServLedgEntry.CalcFields("Resource Cost Amount");
                        PstReturnOrdLine."Resource Cost Amount" := -ServLedgEntry."Resource Cost Amount";
                        //12.05.2015 EB.P30 #T030 <<

                        // 29.09.2011 EDMS P8 >>
                        PstReturnOrdLine."Vehicle Serial No." := ServJnlLine."Vehicle Serial No.";
                        // 29.09.2011 EDMS P8 <<

                        FillPstReturnLineVarFields(PstReturnOrdLine, ServiceLine);

                        PstReturnOrdLine.Resources := CopyStr(ServiceLine.GetResourceTextFieldValue, 1, 100);      // 12.05.2014 Elva Baltic P21

                        PstReturnOrdLine.Insert;
                        ScheduleMgt.PostingServLine(ServiceLine, ServiceHeader."Pst. Return Order No.");
                    end;
                ServiceHeader."document type"::Order:
                    begin
                        PstOrdLine.Init;
                        PstOrdLine.TransferFields(ServiceLine);
                        PstOrdLine."Document No." := ServiceHeader."Posting No.";
                        //12.05.2015 EB.P30 #T030 >>
                        ServLedgEntry.Reset;
                        ServLedgEntry.SetRange("Document Type", ServLedgEntry."document type"::Order);
                        ServLedgEntry.SetRange("Document No.", ServiceLine."Document No.");
                        ServLedgEntry.SetRange("Document Line No.", ServiceLine."Line No.");
                        if ServLedgEntry.FindFirst then
                            ServLedgEntry.CalcFields("Resource Cost Amount");
                        PstOrdLine."Resource Cost Amount" := ServLedgEntry."Resource Cost Amount";
                        //12.05.2015 EB.P30 #T030 <<

                        // 29.09.2011 EDMS P8 >>
                        PstOrdLine."Vehicle Serial No." := ServJnlLine."Vehicle Serial No.";
                        // 29.09.2011 EDMS P8 <<

                        FillPstOrderLineVariableFields(PstOrdLine, ServiceLine);

                        //23.01.2013 EDMS P8 >>
                        PstOrdLine.Resources := CopyStr(ServiceLine.GetResourceTextFieldValue, 1, 100);
                        //23.01.2013 EDMS P8 <<

                        AfterFillPostedServiceLine(PstOrdLine, ServiceLine);

                        PstOrdLine.Insert;
                        ScheduleMgt.PostingServLine(ServiceLine, ServiceHeader."Posting No.");
                        OnAfterInsertPstOrdLine(PstOrdLine);
                    end
            end;

        until GetNextServiceLine(ServiceLine);
        //2012.06.28 EDMS P8 >>
        ClearDetServJnlOfLine(ServJnlLine);
        //2012.06.28 EDMS P8 <<
    end;


    procedure DeleteServiceOrder(ServiceOrder: Record "Service Header EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
    begin
        //Dimensions

        if ServiceOrder.HasLinks then ServiceOrder.DeleteLinks;

        //Lines
        ServiceLine.SetRange("Document Type", ServiceOrder."Document Type");
        ServiceLine.SetRange("Document No.", ServiceOrder."No.");
        if ServiceLine.FindFirst then
            repeat
                if ServiceLine.HasLinks then
                    ServiceLine.DeleteLinks;
            until ServiceLine.Next = 0;

        ServiceLine.DeleteAll;

        //Header
        ServiceOrder.Delete;
    end;


    procedure CopyServCommLinesToPosted(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        ServCommentLine: Record "Service Comment Line EDMS";
        ServCommentLine2: Record "Service Comment Line EDMS";
        FrDocType: Option Quote,"Order","Return Order";
        ToDocType: Option "Service Quote","Service Order",Symtom,"Recall Campaign",Labor,"External Service","Service Package","Service Package Specification",Contract,Vehicle,"Service Return Order","Posted Service Order","Posted Service Return Order";
    begin
        // 26.03.2014 Elva Baltic P18 MMG7.00 >>
        if FromDocumentType = Frdoctype::Order then
            ToDocumentType := Todoctype::"Posted Service Order";
        if FromDocumentType = Frdoctype::"Return Order" then
            ToDocumentType := Todoctype::"Posted Service Return Order";
        // 26.03.2014 Elva Baltic P18 MMG7.00 <<
        ServCommentLine.SetRange(Type, FromDocumentType);
        ServCommentLine.SetRange("No.", FromNumber);
        if ServCommentLine.Find('-') then
            repeat
                ServCommentLine.CalcFields("Extended Comment (BLOB)");
                ServCommentLine2.Init;
                ServCommentLine2 := ServCommentLine;
                ServCommentLine2.Type := ToDocumentType;
                ServCommentLine2."No." := ToNumber;
                ServCommentLine2.Insert;
            until ServCommentLine.Next = 0;
    end;


    procedure CopyServCommLinesToSale(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        ServCommentLine: Record "Service Comment Line EDMS";
        SalesCommentLine: Record "Sales Comment Line";
    begin
        ServCommentLine.SetRange(Type, FromDocumentType);
        ServCommentLine.SetRange("No.", FromNumber);
        if ServCommentLine.FindSet then
            repeat
                SalesCommentLine.Init;
                SalesCommentLine."Document Type" := ToDocumentType;
                SalesCommentLine."No." := ToNumber;
                SalesCommentLine."Line No." := ServCommentLine."Line No.";
                SalesCommentLine.Date := ServCommentLine.Date;
                SalesCommentLine.Comment := ServCommentLine.Comment;
                SalesCommentLine.Insert;
            until ServCommentLine.Next = 0;
    end;

    local procedure SumServiceLines(var NewServiceLine: Record "Service Line EDMS"; var OldServiceLine: Record "Service Line EDMS"; QtyType: Option General,Invoicing,Shipping; InsertServiceLine: Boolean; CalcAdCostLCY: Boolean; var TotalAdjCostLCY: Decimal)
    var
        ServiceLineQty: Decimal;
        AdjCostLCY: Decimal;
    begin
        TotalAdjCostLCY := 0;

        TempVATAmountLineRemainder.DeleteAll;
        OldServiceLine.CalcVATAmountLines(QtyType, ServiceHeaderGlobal, OldServiceLine, TempVATAmountLine);
        GLSetup.Get;
        SalesSetup.Get;
        GetCurrency;
        OldServiceLine.SetRange("Document Type", ServiceHeaderGlobal."Document Type");
        OldServiceLine.SetRange("Document No.", ServiceHeaderGlobal."No.");
        //Fix RC 04/09/2023
        OldServiceLine.SetFilter(type, '<>%1', oldserviceline.type::Comment);
        RoundingLineInserted := false;
        if OldServiceLine.FindSet then
            repeat
                if not RoundingLineInserted then
                    ServiceLineGlobal := OldServiceLine;
                case QtyType of
                    Qtytype::General:
                        ServiceLineQty := ServiceLineGlobal.Quantity;
                    Qtytype::Invoicing:
                        ServiceLineQty := ServiceLineGlobal.Quantity;
                end;
                DivideAmount(QtyType, ServiceLineQty);
                ServiceLineGlobal.Quantity := ServiceLineQty;
                if ServiceLineQty <> 0 then begin
                    if (ServiceLineGlobal.Amount <> 0) and not RoundingLineInserted then
                        if TotalServiceLine.Amount = 0 then
                            TotalServiceLine."VAT %" := ServiceLineGlobal."VAT %"
                        else
                            if TotalServiceLine."VAT %" <> ServiceLineGlobal."VAT %" then
                                TotalServiceLine."VAT %" := 0;
                    RoundAmount(ServiceLineQty);
                    ServiceLineGlobal := TempServiceLine;
                end;
                if InsertServiceLine then begin
                    NewServiceLine := ServiceLineGlobal;
                    NewServiceLine.Insert;
                end;
                if RoundingLineInserted then
                    LastLineRetrieved := true
                else begin
                    LastLineRetrieved := OldServiceLine.Next = 0;
                    if LastLineRetrieved and SalesSetup."Invoice Rounding" then
                        InvoiceRounding(true);
                end;
            until LastLineRetrieved;
    end;

    local procedure GetCurrency()
    begin
        if ServiceHeaderGlobal."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            Currency.Get(ServiceHeaderGlobal."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
    end;

    local procedure DivideAmount(QtyType: Option General,Invoicing,Shipping; ServiceLineQty: Decimal)
    begin
        if RoundingLineInserted and (RoundingLineNo = ServiceLineGlobal."Line No.") then
            exit;
        if ServiceLineQty = 0 then begin
            ServiceLineGlobal."Line Amount" := 0;
            ServiceLineGlobal."Line Discount Amount" := 0;
            ServiceLineGlobal."VAT Base Amount" := 0;
            ServiceLineGlobal.Amount := 0;
            ServiceLineGlobal."Amount Including VAT" := 0;
        end else begin
            TempVATAmountLine.Get(ServiceLineGlobal."VAT Identifier", ServiceLineGlobal."VAT Calculation Type", ServiceLineGlobal."Tax Group Code", false, ServiceLineGlobal."Line Amount" >= 0);
            if ServiceLineGlobal."VAT Calculation Type" = ServiceLineGlobal."vat calculation type"::"Sales Tax" then
                ServiceLineGlobal."VAT %" := TempVATAmountLine."VAT %";
            TempVATAmountLineRemainder := TempVATAmountLine;
            if not TempVATAmountLineRemainder.Find then begin
                TempVATAmountLineRemainder.Init;
                TempVATAmountLineRemainder.Insert;
            end;
            ServiceLineGlobal."Line Amount" := ROUND(ServiceLineQty * ServiceLineGlobal."Unit Price", Currency."Amount Rounding Precision");
            if ServiceLineQty <> ServiceLineGlobal.Quantity then
                ServiceLineGlobal."Line Discount Amount" :=
                  ROUND(ServiceLineGlobal."Line Amount" * ServiceLineGlobal."Line Discount %" / 100, Currency."Amount Rounding Precision");
            ServiceLineGlobal."Line Amount" := ServiceLineGlobal."Line Amount" - ServiceLineGlobal."Line Discount Amount";

            if ServiceLineGlobal."Allow Invoice Disc." and (TempVATAmountLine."Inv. Disc. Base Amount" <> 0) then
                if not (QtyType = Qtytype::Invoicing) then begin
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount" +
                      TempVATAmountLine."Invoice Discount Amount" * ServiceLineGlobal."Line Amount" /
                      TempVATAmountLine."Inv. Disc. Base Amount";
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount";
                end;

            if ServiceHeaderGlobal."Prices Including VAT" then begin
                if (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" = 0) or
                   (ServiceLineGlobal."Line Amount" = 0)
                then begin
                    TempVATAmountLineRemainder."VAT Amount" := 0;
                    TempVATAmountLineRemainder."Amount Including VAT" := 0;
                end else begin
                    TempVATAmountLineRemainder."VAT Amount" :=
                      TempVATAmountLineRemainder."VAT Amount" +
                      TempVATAmountLine."VAT Amount" *
                      (ServiceLineGlobal."Line Amount") /
                      (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                    TempVATAmountLineRemainder."Amount Including VAT" :=
                      TempVATAmountLineRemainder."Amount Including VAT" +
                      TempVATAmountLine."Amount Including VAT" *
                      (ServiceLineGlobal."Line Amount") /
                      (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                end;
                ServiceLineGlobal."Amount Including VAT" :=
                  ROUND(TempVATAmountLineRemainder."Amount Including VAT", Currency."Amount Rounding Precision");
                ServiceLineGlobal.Amount :=
                  ROUND(ServiceLineGlobal."Amount Including VAT", Currency."Amount Rounding Precision") -
                  ROUND(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision");
                ServiceLineGlobal."VAT Base Amount" :=
                  ROUND(
                    ServiceLineGlobal.Amount * (1 - ServiceHeaderGlobal."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                TempVATAmountLineRemainder."Amount Including VAT" :=
                  TempVATAmountLineRemainder."Amount Including VAT" - ServiceLineGlobal."Amount Including VAT";
                TempVATAmountLineRemainder."VAT Amount" :=
                  TempVATAmountLineRemainder."VAT Amount" - ServiceLineGlobal."Amount Including VAT" + ServiceLineGlobal.Amount;
            end else begin
                if ServiceLineGlobal."VAT Calculation Type" = ServiceLineGlobal."vat calculation type"::"Full VAT" then begin
                    ServiceLineGlobal."Amount Including VAT" := ServiceLineGlobal."Line Amount";
                    ServiceLineGlobal.Amount := 0;
                    ServiceLineGlobal."VAT Base Amount" := 0;
                end else begin
                    ServiceLineGlobal.Amount := ServiceLineGlobal."Line Amount";
                    ServiceLineGlobal."VAT Base Amount" :=
                      ROUND(
                        ServiceLineGlobal.Amount * (1 - ServiceHeaderGlobal."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                    if TempVATAmountLine."VAT Base" = 0 then
                        TempVATAmountLineRemainder."VAT Amount" := 0
                    else
                        TempVATAmountLineRemainder."VAT Amount" :=
                         TempVATAmountLineRemainder."VAT Amount" +
                         TempVATAmountLine."VAT Amount" *
                         (ServiceLineGlobal."Line Amount") /
                         (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                    ServiceLineGlobal."Amount Including VAT" :=
                      ServiceLineGlobal.Amount + ROUND(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."VAT Amount" :=
                      TempVATAmountLineRemainder."VAT Amount" - ServiceLineGlobal."Amount Including VAT" + ServiceLineGlobal.Amount;
                end;
            end;

            TempVATAmountLineRemainder.Modify;
        end;
    end;

    local procedure RoundAmount(ServiceLineQty: Decimal)
    var
        NoVAT: Boolean;
    begin
        IncrAmount(TotalServiceLine);
        Increment(TotalServiceLine.Quantity, ServiceLineQty);
        TempServiceLine := ServiceLineGlobal;
        ServiceLineACY := ServiceLineGlobal;

        if ServiceHeaderGlobal."Currency Code" <> '' then begin
            if (ServiceLineGlobal."Document Type" in [ServiceLineGlobal."document type"::Quote]) and
               (ServiceHeaderGlobal."Posting Date" = 0D)
            then
                UseDate := WorkDate
            else
                UseDate := ServiceHeaderGlobal."Posting Date";

            NoVAT := ServiceLineGlobal.Amount = ServiceLineGlobal."Amount Including VAT";
            ServiceLineGlobal."Amount Including VAT" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeaderGlobal."Currency Code",
                  TotalServiceLine."Amount Including VAT", ServiceHeaderGlobal."Currency Factor")) -
                    TotalServiceLineLCY."Amount Including VAT";
            if NoVAT then
                ServiceLineGlobal.Amount := ServiceLineGlobal."Amount Including VAT"
            else
                ServiceLineGlobal.Amount :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, ServiceHeaderGlobal."Currency Code",
                      TotalServiceLine.Amount, ServiceHeaderGlobal."Currency Factor")) -
                        TotalServiceLineLCY.Amount;
            ServiceLineGlobal."Line Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeaderGlobal."Currency Code",
                  TotalServiceLine."Line Amount", ServiceHeaderGlobal."Currency Factor")) -
                    TotalServiceLineLCY."Line Amount";
            ServiceLineGlobal."Line Discount Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeaderGlobal."Currency Code",
                  TotalServiceLine."Line Discount Amount", ServiceHeaderGlobal."Currency Factor")) -
                    TotalServiceLineLCY."Line Discount Amount";
            ServiceLineGlobal."VAT Difference" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeaderGlobal."Currency Code",
                  TotalServiceLine."VAT Difference", ServiceHeaderGlobal."Currency Factor")) -
                    TotalServiceLineLCY."VAT Difference";
        end;

        IncrAmount(TotalServiceLineLCY);
        Increment(TotalServiceLineLCY."Unit Cost (LCY)", ROUND(ServiceLineQty * ServiceLineGlobal."Unit Cost (LCY)"));
    end;

    local procedure InvoiceRounding(UseTempData: Boolean)
    var
        InvoiceRoundingAmount: Decimal;
        NextLineNo: Integer;
    begin
        Currency.TestField("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -ROUND(
            TotalServiceLine."Amount Including VAT" -
            ROUND(
              TotalServiceLine."Amount Including VAT",
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");
        if InvoiceRoundingAmount <> 0 then begin
            CustPostingGr.Get(ServiceHeaderGlobal."Customer Posting Group");
            CustPostingGr.TestField("Invoice Rounding Account");
            ServiceLineGlobal.Init;
            NextLineNo := ServiceLineGlobal."Line No." + 10000;
            ServiceLineGlobal."System-Created Entry" := true;
            if UseTempData then begin
                ServiceLineGlobal."Line No." := 0;
                ServiceLineGlobal.Type := ServiceLineGlobal.Type::"G/L Account";
            end else begin
                ServiceLineGlobal."Line No." := NextLineNo;
                ServiceLineGlobal.Validate(Type, ServiceLineGlobal.Type::"G/L Account");
            end;
            ServiceLineGlobal.Validate("No.", CustPostingGr."Invoice Rounding Account");
            ServiceLineGlobal.Validate(Quantity, 1);
            if ServiceHeaderGlobal."Prices Including VAT" then
                ServiceLineGlobal.Validate("Unit Price", InvoiceRoundingAmount)
            else
                ServiceLineGlobal.Validate(
                  "Unit Price",
                  ROUND(
                    InvoiceRoundingAmount /
                    (1 + (1 - ServiceHeaderGlobal."VAT Base Discount %" / 100) * ServiceLineGlobal."VAT %" / 100),
                    Currency."Amount Rounding Precision"));
            ServiceLineGlobal.Validate("Amount Including VAT", InvoiceRoundingAmount);
            ServiceLineGlobal."Line No." := NextLineNo;
            if not UseTempData then begin


            end;
            LastLineRetrieved := false;
            RoundingLineInserted := true;
            RoundingLineNo := ServiceLineGlobal."Line No.";
        end;
    end;

    local procedure IncrAmount(var TotalServiceLine: Record "Service Line EDMS")
    begin
        if ServiceHeaderGlobal."Prices Including VAT" or
   (ServiceLineGlobal."VAT Calculation Type" <> ServiceLineGlobal."vat calculation type"::"Full VAT")
then
            Increment(TotalServiceLine."Line Amount", ServiceLineGlobal."Line Amount");
        Increment(TotalServiceLine.Amount, ServiceLineGlobal.Amount);
        Increment(TotalServiceLine."VAT Base Amount", ServiceLineGlobal."VAT Base Amount");
        Increment(TotalServiceLine."VAT Difference", ServiceLineGlobal."VAT Difference");
        Increment(TotalServiceLine."Amount Including VAT", ServiceLineGlobal."Amount Including VAT");
        Increment(TotalServiceLine."Line Discount Amount", ServiceLineGlobal."Line Discount Amount");
        Increment(TotalServiceLine."Inv. Discount Amount", ServiceLineGlobal."Inv. Discount Amount");
        Increment(TotalServiceLine."Inv. Disc. Amount to Invoice", ServiceLineGlobal."Inv. Disc. Amount to Invoice");

        //EDMS1.0.00 P3>>
        Increment(TotalServiceLine."Prepmt. Line Amount", ServiceLineGlobal."Prepmt. Line Amount");
        Increment(TotalServiceLine."Prepmt. Amt. Inv.", ServiceLineGlobal."Prepmt. Amt. Inv.");
        Increment(TotalServiceLine."Prepmt Amt to Deduct", ServiceLineGlobal."Prepmt Amt to Deduct");
        Increment(TotalServiceLine."Prepmt Amt Deducted", ServiceLineGlobal."Prepmt Amt Deducted");
        //EDMS1.0.00 P3>>
    end;

    local procedure Increment(var Number: Decimal; Number2: Decimal)
    begin
        Number := Number + Number2;
    end;


    procedure SumServiceLinesTemp(var NewServiceHeader: Record "Service Header EDMS"; var OldServiceLine: Record "Service Line EDMS"; QtyType: Option General,Invoicing,Shipping; var NewTotalServiceLine: Record "Service Line EDMS"; var NewTotalServiceLineLCY: Record "Service Line EDMS"; var VATAmount: Decimal; var VATAmountText: Text[30]; var ProfitLCY: Decimal; var ProfitPct: Decimal; var TotalAdjCostLCY: Decimal)
    var
        ServiceLine: Record "Service Line EDMS";
    begin
        ServiceHeaderGlobal := NewServiceHeader;

        SumServiceLines(ServiceLine, OldServiceLine, QtyType, false, true, TotalAdjCostLCY);

        ProfitLCY := TotalServiceLineLCY.Amount - TotalServiceLineLCY."Unit Cost (LCY)";
        if TotalServiceLineLCY.Amount = 0 then
            ProfitPct := 0
        else
            ProfitPct := ROUND(ProfitLCY / TotalServiceLineLCY.Amount * 100, 0.1);
        VATAmount := TotalServiceLine."Amount Including VAT" - TotalServiceLine.Amount;
        if TotalServiceLine."VAT %" = 0 then
            VATAmountText := Text016
        else
            VATAmountText := StrSubstNo(Text017, TotalServiceLine."VAT %");
        NewTotalServiceLine := TotalServiceLine;
        NewTotalServiceLineLCY := TotalServiceLineLCY;
    end;


    procedure ModifyProcessChecklist(ServiceHdr: Record "Service Header EDMS"; NewSourceType: Integer; NewSourceID: Code[20])
    var
        ProcessChecklistHdr: Record "Process Checklist Header";
    begin
        ProcessChecklistHdr.Reset;
        ProcessChecklistHdr.SetCurrentkey("Source Type", "Source Subtype", "Source ID");
        ProcessChecklistHdr.SetRange("Source Type", Database::"Service Header EDMS");
        ProcessChecklistHdr.SetRange("Source Subtype", ServiceHdr."Document Type");
        ProcessChecklistHdr.SetRange("Source ID", ServiceHdr."No.");
        if ProcessChecklistHdr.FindFirst then
            repeat
                ProcessChecklistHdr."Source Type" := NewSourceType;
                ProcessChecklistHdr."Source Subtype" := 0;
                ProcessChecklistHdr."Source ID" := NewSourceID;
                ProcessChecklistHdr.Modify;
            until ProcessChecklistHdr.Next = 0;
    end;

    local procedure GetNextServiceLine(var ServiceLine: Record "Service Line EDMS"): Boolean
    begin
        if ServiceLine.Next = 1 then
            exit(false);
        if TempPrepaymentServiceLine.FindFirst then begin
            ServiceLine := TempPrepaymentServiceLine;
            TempPrepaymentServiceLine.Delete;
            exit(false);
        end;
        exit(true);
    end;


    procedure CalculateAmountLCY(var ServJnlLine: Record "Serv. Journal Line"; ServiceHeader: Record "Service Header EDMS"; ServiceLine: Record "Service Line EDMS")
    var
        UseDate: Date;
    begin
        if ServiceHeader."Currency Code" <> '' then begin
            if (ServiceHeader."Document Type" in [ServiceHeader."document type"::Quote]) and (ServiceHeader."Posting Date" = 0D) then
                UseDate := WorkDate
            else
                UseDate := ServiceHeader."Posting Date";

            ServJnlLine."Amount (LCY)" :=
                ROUND(
                     CurrExchRate.ExchangeAmtFCYToLCY(
                     UseDate, ServiceHeader."Currency Code",
                     ServiceLine.Amount, ServiceHeader."Currency Factor"));
            ServJnlLine."Amount Including VAT (LCY)" :=
                ROUND(
                     CurrExchRate.ExchangeAmtFCYToLCY(
                     UseDate, ServiceHeader."Currency Code",
                     ServiceLine."Amount Including VAT", ServiceHeader."Currency Factor"));
            ServJnlLine."Line Discount Amount (LCY)" :=
                ROUND(
                     CurrExchRate.ExchangeAmtFCYToLCY(
                     UseDate, ServiceHeader."Currency Code",
                     ServiceLine."Line Discount Amount", ServiceHeader."Currency Factor"));
            ServJnlLine."Inv. Discount Amount (LCY)" :=
                ROUND(
                     CurrExchRate.ExchangeAmtFCYToLCY(
                     UseDate, ServiceHeader."Currency Code",
                     ServiceLine."Inv. Discount Amount", ServiceHeader."Currency Factor"));
        end else begin
            ServJnlLine."Amount (LCY)" := ServiceLine.Amount;
            ServJnlLine."Amount Including VAT (LCY)" := ServiceLine."Amount Including VAT";
            ServJnlLine."Line Discount Amount (LCY)" := ServiceLine."Line Discount Amount";
            ServJnlLine."Inv. Discount Amount (LCY)" := ServiceLine."Inv. Discount Amount";
        end;

        if ServiceHeader."Prices Including VAT" then begin
            ServJnlLine."Line Discount Amount (LCY)" := ROUND(ServJnlLine."Line Discount Amount (LCY)" / (1 + ServiceLine."VAT %" / 100));
            ServJnlLine."Inv. Discount Amount (LCY)" := ROUND(ServJnlLine."Inv. Discount Amount (LCY)" / (1 + ServiceLine."VAT %" / 100));
        end;
    end;


    procedure ArchiveUnpostedOrder(ServiceHeader: Record "Service Header EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
        ArchiveManagement: Codeunit ArchiveManagement;
        Vehmgnt: Codeunit "Vehicle Proposal Mgt. EDMS";

    begin
        if not ServiceSetup."Archive Quotes and Orders" then
            exit;
        if not (ServiceHeader."Document Type" in [ServiceHeader."document type"::Order, ServiceHeader."document type"::"Return Order"])
        then
            exit;
        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetFilter(Quantity, '<>0');
        if not ServiceLine.IsEmpty then begin
            Vehmgnt.ArchServDocumentNoConfirm(ServiceHeader);
            //COMMIT;  // 30.07.2015 EB.P30 #T043
        end;
    end;


    procedure FillSalesVariableFields(var SalesHdr: Record "Sales Header"; ServiceHdr: Record "Service Header EDMS")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        SalesHdr."Variable Field 25006800" := '';
        SalesHdr."Variable Field 25006801" := '';
        SalesHdr."Variable Field 25006802" := '';

        RecordRef.Open(Database::"Service Header EDMS");
        RecordRef.GetTable(ServiceHdr);
        RecordRef2.Open(Database::"Sales Header");
        RecordRef2.GetTable(SalesHdr);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Header EDMS");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Sales Header");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(SalesHdr);
    end;


    procedure FillPstReturnVariableFields(var PstReturnOrdHeader: Record "Posted Serv. Ret. Order Header"; ServiceHdr: Record "Service Header EDMS")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        PstReturnOrdHeader."Variable Field 25006800" := '';
        PstReturnOrdHeader."Variable Field 25006801" := '';
        PstReturnOrdHeader."Variable Field 25006802" := '';

        RecordRef.Open(Database::"Service Header EDMS");
        RecordRef.GetTable(ServiceHdr);
        RecordRef2.Open(Database::"Posted Serv. Ret. Order Header");
        RecordRef2.GetTable(PstReturnOrdHeader);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Header EDMS");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Posted Serv. Ret. Order Header");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(PstReturnOrdHeader);
    end;


    procedure FillPstOrderVariableFields(var PstOrdHeader: Record "Posted Serv. Order Header"; ServiceHdr: Record "Service Header EDMS")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        PstOrdHeader."Variable Field 25006800" := '';
        PstOrdHeader."Variable Field 25006801" := '';
        PstOrdHeader."Variable Field 25006802" := '';

        RecordRef.Open(Database::"Service Header EDMS");
        RecordRef.GetTable(ServiceHdr);
        RecordRef2.Open(Database::"Posted Serv. Order Header");
        RecordRef2.GetTable(PstOrdHeader);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Header EDMS");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Posted Serv. Order Header");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(PstOrdHeader);
    end;


    procedure FillSalesLineVariableFields(var SalesLine: Record "Sales Line"; ServiceLine: Record "Service Line EDMS")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        SalesLine."Variable Field 25006800" := '';
        SalesLine."Variable Field 25006801" := '';
        SalesLine."Variable Field 25006802" := '';

        RecordRef.Open(Database::"Service Line EDMS");
        RecordRef.GetTable(ServiceLine);
        RecordRef2.Open(Database::"Sales Line");
        RecordRef2.GetTable(SalesLine);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Line EDMS");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Sales Line");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(SalesLine);
    end;


    procedure FillPstReturnLineVarFields(var PstReturnOrdLine: Record "Posted Serv. Return Order Line"; ServiceLine: Record "Service Line EDMS")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        PstReturnOrdLine."Variable Field 25006800" := '';
        PstReturnOrdLine."Variable Field 25006801" := '';
        PstReturnOrdLine."Variable Field 25006802" := '';

        RecordRef.Open(Database::"Service Line EDMS");
        RecordRef.GetTable(ServiceLine);
        RecordRef2.Open(Database::"Posted Serv. Return Order Line");
        RecordRef2.GetTable(PstReturnOrdLine);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Line EDMS");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Posted Serv. Return Order Line");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(PstReturnOrdLine);
    end;


    procedure FillPstOrderLineVariableFields(var PstOrdLine: Record "Posted Serv. Order Line"; ServiceLine: Record "Service Line EDMS")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        PstOrdLine."Variable Field 25006800" := '';
        PstOrdLine."Variable Field 25006801" := '';
        PstOrdLine."Variable Field 25006802" := '';

        RecordRef.Open(Database::"Service Line EDMS");
        RecordRef.GetTable(ServiceLine);
        RecordRef2.Open(Database::"Posted Serv. Order Line");
        RecordRef2.GetTable(PstOrdLine);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Line EDMS");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Posted Serv. Order Line");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(PstOrdLine);
    end;


    procedure FillServJournalVariableFields(var ServJournalLine: Record "Serv. Journal Line"; ServiceLine: Record "Service Line EDMS")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        ServJournalLine."Variable Field 25006800" := '';
        ServJournalLine."Variable Field 25006801" := '';
        ServJournalLine."Variable Field 25006802" := '';

        RecordRef.Open(Database::"Service Line EDMS");
        RecordRef.GetTable(ServiceLine);
        RecordRef2.Open(Database::"Serv. Journal Line");
        RecordRef2.GetTable(ServJournalLine);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Line EDMS");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Serv. Journal Line");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(ServJournalLine);
    end;


    procedure SumServiceLines2(var NewServHeader: Record "Service Header EDMS"; QtyType: Option General,Invoicing,Shipping; var NewTotalServLine: Record "Service Line EDMS"; var NewTotalServLineLCY: Record "Service Line EDMS"; var VATAmount: Decimal; var VATAmountText: Text[30]; var ProfitLCY: Decimal; var ProfitPct: Decimal; var TotalAdjCostLCY: Decimal)
    var
        OldServLine: Record "Service Line EDMS";
    begin
        SumServiceLinesTemp(
          NewServHeader, OldServLine, QtyType, NewTotalServLine, NewTotalServLineLCY,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);
    end;


    procedure CreateToDoFromService(PstServiceHeader: Record "Posted Serv. Order Header")
    var
        ToDo: Record "To-do";
    begin
        ServiceSetup.Get;
        if not ServiceSetup."Create To-do After Posting" then
            exit;

        ToDo.Init;
        ToDo."No." := '';
        ToDo.Insert(true);
        ToDo.Validate(Type, ToDo.Type::"Phone Call");
        ToDo.Validate("Interaction Template Code", ServiceSetup."To-do Interaction Template");
        ToDo.Validate("Salesperson Code", PstServiceHeader."Service Advisor");
        ToDo.Validate("Contact No.", PstServiceHeader."Sell-to Contact No.");
        ToDo.Validate(Date, CalcDate(ServiceSetup."To-do Date Formula", PstServiceHeader."Posting Date"));
        ToDo.Validate(Description, CopyStr(ToDo.Description + ';' + PstServiceHeader."No." + ' ' + PstServiceHeader.Description,
                                           1, MaxStrLen(ToDo.Description)));
        ToDo.Validate(Location, PstServiceHeader."Location Code");
        ToDo.Validate("Vehicle Serial No.", PstServiceHeader."Vehicle Serial No.");
        ToDo."Service Source Type" := Database::"Posted Serv. Order Header";
        ToDo."Service Source ID" := PstServiceHeader."No.";
        ToDo.Modify;
    end;


    procedure CheckFullyReservedToInventory(ServiceHeader: Record "Service Header EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
        Text001: label 'Items on Service Lines are not fully transfered to service location';
        Item: Record Item;
    begin
        if ServiceHeader."Document Type" <> ServiceHeader."document type"::Order then
            exit;
        ServiceLine.Reset;
        ServiceLine.SetCurrentkey(Type, "No.");
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange(Type, ServiceLine.Type::Item);
        if ServiceLine.FindFirst then
            repeat
                Item.Get(ServiceLine."No.");
                if (Item.Type = Item.Type::Inventory) then begin
                    if not ServiceLine.FullyReservedToInventory then
                        Error(Text001);
                end;
            until ServiceLine.Next = 0;
    end;


    procedure CheckServiceHeader(ServiceHeader: Record "Service Header EDMS")
    var
        TransferHeader: Record "Transfer Header";
    begin
        if ServiceHeader."Document Type" = ServiceHeader."document type"::Order then begin
            ServiceSetup.Get;
            if ServiceSetup."Fully Transfered Mandatory" then
                CheckFullyReservedToInventory(ServiceHeader);
            if ServiceSetup."Posting Date Warnings" and (ServiceHeader."Posting Date" <> Today) and GuiAllowed then
                if not Confirm(PostingDateWarning, false) then
                    Error(PostingDateError);
        end;
        //17.04.2014 Elva Baltic P1 #RX MMG7.00 >>
        TransferHeader.Reset;
        TransferHeader.SetRange("Document Profile", TransferHeader."document profile"::Service);
        TransferHeader.SetRange("Source Type", Database::"Service Header EDMS");
        TransferHeader.SetRange("Source Subtype", ServiceHeader."Document Type");
        TransferHeader.SetRange("Source No.", ServiceHeader."No.");
        if TransferHeader.FindFirst then
            Error(Text101, ServiceHeader."Document Type", ServiceHeader."No.");
        //17.04.2014 Elva Baltic P1 #RX MMG7.00 <<

        OnAfterCheckServiceHeader(ServiceHeader);
    end;


    procedure FillDetServJnlByResource(ServJournalLine: Record "Serv. Journal Line"; DocType: Integer; DocNo: Code[20]; LineNo: Integer; ModeParams: Text[30])
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        ServLaborAllocEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocEntry2: Record "Serv. Labor Allocation Entry";
        DetServJournalLine: Record "Det. Serv. Journal Line";
        ServiceHeaderLoc: Record "Service Header EDMS";
        ServiceLineLoc: Record "Service Line EDMS";
        PostedServOrderHeaderLoc: Record "Posted Serv. Order Header";
        PostedServOrderLineLoc: Record "Posted Serv. Order Line";
        DetservJnlLineStep: Integer;
        DetservJnlLineNo: Integer;
        DoLookHeaderResources: Boolean;
        DoLookLineResources: Boolean;
        DoLookHeaderPosted: Boolean;
        QuantityLine: Decimal;
        QuantityHeader: Decimal;
        QuantitySum: Decimal;
        AllocTotalTimeSpent: Decimal;
        Resource: Record Resource;
        ResourceQuantitySum: Decimal;
        TotalResourceCountLine: Integer;
        QuantityLineCoef: Decimal;
        QuantityHeaderCoef: Decimal;
        TotalTimeSpentSum: Decimal;
        AllocTotalTimeSpentResource: Decimal;
    begin
        ClearDetServJnlOfLine(ServJournalLine);
        if ServJournalLine.Type <> ServJournalLine.Type::Labor then
            exit;
        DoLookLineResources := true;
        if StrLen(ModeParams) > 0 then
            Evaluate(DoLookHeaderResources, CopyStr(ModeParams, 1, 1));
        if StrLen(ModeParams) > 1 then
            Evaluate(DoLookLineResources, CopyStr(ModeParams, 2, 1));
        if StrLen(ModeParams) > 2 then
            Evaluate(DoLookHeaderPosted, CopyStr(ModeParams, 3, 1));

        DetservJnlLineStep := 10000;
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Document Type", DocType);
        ServLaborAllocApplication.SetRange("Document No.", DocNo);
        ServLaborAllocApplication.SetRange("Document Line No.", LineNo);
        if (DoLookHeaderResources and DoLookLineResources) then begin
            ServLaborAllocApplication.SetFilter("Document Line No.", '=0|' + Format(LineNo));
        end else begin
            if DoLookHeaderResources then
                ServLaborAllocApplication.SetRange("Document Line No.", 0);
        end;
        DetservJnlLineNo := 0;
        if ServLaborAllocApplication.FindFirst then begin

            // part to define quantity of header
            if DoLookHeaderPosted then begin
                if PostedServOrderHeaderLoc.Get(DocNo) then begin
                    PostedServOrderLineLoc.SetRange("Document No.", DocNo);
                    PostedServOrderLineLoc.SetRange(Type, PostedServOrderLineLoc.Type::Labor);
                    if PostedServOrderLineLoc.FindFirst then
                        repeat
                            QuantityHeader += PostedServOrderLineLoc.Quantity;
                        until PostedServOrderLineLoc.Next = 0;
                end;
            end else begin
                if ServiceHeaderLoc.Get(DocType, DocNo) then begin
                    ServiceLineLoc.SetRange("Document Type", DocType);
                    ServiceLineLoc.SetRange("Document No.", DocNo);
                    ServiceLineLoc.SetRange(Type, ServiceLineLoc.Type::Labor);
                    if ServiceLineLoc.FindFirst then
                        repeat
                            QuantityHeader += ServiceLineLoc.Quantity;
                        until ServiceLineLoc.Next = 0;
                end;
            end;

            repeat
                TotalTimeSpentSum := 0;

                DetservJnlLineNo += DetservJnlLineStep;
                DetServJournalLine.Init;
                DetServJournalLine."Journal Template Name" := ServJournalLine."Journal Template Name";
                DetServJournalLine."Journal Batch Name" := ServJournalLine."Journal Batch Name";
                DetServJournalLine."Journal Line No." := ServJournalLine."Line No.";
                DetServJournalLine."Line No." := DetservJnlLineNo;
                DetServJournalLine."Resource No." := ServLaborAllocApplication."Resource No.";
                DetServJournalLine."Unit Cost" := ServLaborAllocApplication."Unit Cost";

                //IF ServLaborAllocEntry.GET("Allocation Entry No.") THEN;
                //ServLaborAllocEntry.CALCFIELDS("Total Time Spent","Total Time Spent Travel");  //time spent for one resource from time reg entries

                //TotalTimeSpentLine := GetAllocTotalTimeSpent(DocType,DocNo,LineNo); //Summ Application entries for line
                //TotalTimeSpentLineTravel := GetAllocTotalTimeSpentTravel(DocType,DocNo,LineNo);//Summ Application travel entries for line
                TotalResourceCountLine := GetAllocResourceCountLine(DocType, DocNo, LineNo); //Resource count on line
                QuantityLine := Abs(ServJournalLine."Quantity (Hours)"); //Quantity on line for coef
                QuantitySum := GetQuantityOfLinesInAlloc(ServLaborAllocApplication, DoLookHeaderPosted, ServJournalLine."Quantity (Hours)"); //Quantity summed for coef
                if QuantitySum = 0 then
                    QuantitySum := QuantityLine;

                //20.12.2016 EB.RC DMS bug corrected >>
                if QuantitySum = 0 then
                    QuantityLineCoef := 0
                else
                    QuantityLineCoef := QuantityLine / QuantitySum;
                //20.12.2016 EB.RC DMS bug corrected <<

                if QuantityHeader = 0 then
                    QuantityHeader := QuantityLine;
                QuantityHeaderCoef := QuantityLine / QuantityHeader;

                if ServLaborAllocApplication."Document Line No." <> 0 then begin
                    //Line Allocations
                    if ServLaborAllocEntry.Get(ServLaborAllocApplication."Allocation Entry No.") then begin
                        if GetApplicationCount(ServLaborAllocApplication."Allocation Entry No.") > 1 then begin
                            AllocTotalTimeSpent := GetAllocTotalTimeSpent(ServLaborAllocApplication."Allocation Entry No.");
                            TotalTimeSpentSum := AllocTotalTimeSpent * QuantityLineCoef;
                        end else begin
                            if ServLaborAllocApplication."Allocation Entry No." <> 0 then begin
                                ServLaborAllocEntry2.Get(ServLaborAllocApplication."Allocation Entry No.");
                                ServLaborAllocEntry2.CalcFields("Total Time Spent", "Total Time Spent Travel");
                                TotalTimeSpentSum := ServLaborAllocEntry2."Total Time Spent" + ServLaborAllocEntry2."Total Time Spent Travel"; //Manual time + Time Reg Entries
                            end else
                                TotalTimeSpentSum := ServLaborAllocApplication."Finished Quantity (Hours)";
                        end;
                    end else begin
                        TotalTimeSpentSum := ServLaborAllocApplication."Finished Quantity (Hours)";
                    end;
                end else begin
                    //Header Allocation
                    if ServLaborAllocApplication."Allocation Entry No." <> 0 then begin
                        ServLaborAllocEntry2.Get(ServLaborAllocApplication."Allocation Entry No.");
                        ServLaborAllocEntry2.CalcFields("Total Time Spent", "Total Time Spent Travel");
                        TotalTimeSpentSum := (ServLaborAllocEntry2."Total Time Spent" + ServLaborAllocEntry2."Total Time Spent Travel") * QuantityHeaderCoef;
                    end else
                        TotalTimeSpentSum := ServLaborAllocApplication."Finished Quantity (Hours)" * QuantityHeaderCoef;
                end;

                if not (TotalTimeSpentSum = 0) then begin
                    if ServLaborAllocApplication.Travel then
                        DetServJournalLine."Finished Qty. (Hours) Travel" := TotalTimeSpentSum
                    else
                        DetServJournalLine."Finished Quantity (Hours)" := TotalTimeSpentSum;
                    DetServJournalLine."Quantity (Hours)" := TotalTimeSpentSum;
                end else begin
                    if TotalResourceCountLine <> 0 then begin //20.12.2016 EB.RC DMS bug corrected
                        DetServJournalLine."Finished Quantity (Hours)" := QuantityLine / TotalResourceCountLine;
                        DetServJournalLine."Quantity (Hours)" := QuantityLine / TotalResourceCountLine;
                    end; //20.12.2016 EB.RC DMS bug corrected
                end;

                DetServJournalLine."Cost Amount" := DetServJournalLine."Finished Quantity (Hours)" * ServLaborAllocApplication."Unit Cost";
                DetServJournalLine.Insert;
            until ServLaborAllocApplication.Next = 0;

            //23.03.2016 EB.P7 #Correct Rounded Resource Quantity >>
            ResourceQuantitySum := 0;
            DetServJournalLine.Reset;
            DetServJournalLine.SetRange("Journal Template Name", ServJournalLine."Journal Template Name");
            DetServJournalLine.SetRange("Journal Batch Name", ServJournalLine."Journal Batch Name");
            DetServJournalLine.SetRange("Journal Line No.", ServJournalLine."Line No.");
            if DetServJournalLine.FindFirst then
                repeat
                    ResourceQuantitySum += DetServJournalLine."Quantity (Hours)";
                until DetServJournalLine.Next = 0;

            if ServJournalLine."Quantity (Hours)" - ResourceQuantitySum > 0 then
                if DetServJournalLine.FindLast then begin
                    DetServJournalLine."Quantity (Hours)" += ServJournalLine."Quantity (Hours)" - ResourceQuantitySum;
                    ServLaborAllocApplication.Modify;
                end;

            //23.03.2016 EB.P7 #Correct Rounded Resource Quantity <<


        end;
    end;


    procedure ClearDetServJnlOfLine(ServJournalLine: Record "Serv. Journal Line")
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        DetServJournalLine: Record "Det. Serv. Journal Line";
        DetservJnlLineStep: Integer;
        DetservJnlLineNo: Integer;
        DoLookHeaderResources: Boolean;
    begin
        DetServJournalLine.Reset;
        DetServJournalLine.SetRange("Journal Template Name", ServJournalLine."Journal Template Name");
        DetServJournalLine.SetRange("Journal Batch Name", ServJournalLine."Journal Batch Name");
        DetServJournalLine.SetRange("Journal Line No.", ServJournalLine."Line No.");
        DetServJournalLine.DeleteAll;
    end;


    procedure GetQuantityOfLinesInAlloc(ServLaborAllocApplicationPar: Record "Serv. Labor Alloc. Application"; DoLookHeaderPosted: Boolean; CurrentLineQty: Decimal) RetValue: Decimal
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS";
        PostedServOrderLineLoc: Record "Posted Serv. Order Line";
    begin
        if ServLaborAllocApplicationPar."Allocation Entry No." = 0 then
            exit(CurrentLineQty);
        if not (ServLaborAllocApplication."Document Type" in [0, 1]) then
            exit(0);
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Allocation Entry No.", ServLaborAllocApplicationPar."Allocation Entry No.");
        if ServLaborAllocApplication.FindFirst then
            repeat
                if DoLookHeaderPosted then begin
                    PostedServOrderLineLoc.SetRange("Document No.", ServLaborAllocApplication."Document No.");
                    PostedServOrderLineLoc.SetRange(Type, PostedServOrderLineLoc.Type::Labor);
                    PostedServOrderLineLoc.SetRange("Line No.", ServLaborAllocApplication."Document Line No.");
                    if PostedServOrderLineLoc.FindFirst then
                        repeat
                            RetValue += PostedServOrderLineLoc."Quantity (Hours)";
                        until PostedServOrderLineLoc.Next = 0;
                end else begin
                    ServiceLine.SetRange("Document Type", ServLaborAllocApplication."Document Type");
                    ServiceLine.SetRange("Document No.", ServLaborAllocApplication."Document No.");
                    ServiceLine.SetRange(Type, ServiceLine.Type::Labor);
                    ServiceLine.SetRange("Line No.", ServLaborAllocApplication."Document Line No.");
                    if ServiceLine.FindFirst then
                        repeat
                            RetValue += ServiceLine."Quantity (Hours)";
                        until ServiceLine.Next = 0;
                end;
            until ServLaborAllocApplication.Next = 0;

        exit(RetValue);
    end;

    local procedure CheckDim(ServiceHeader: Record "Service Header EDMS")
    var
        ServiceLineLoc: Record "Service Line EDMS";
    begin
        //25.10.2013 EDMS P8 >>
        if (ServiceHeader."Document Type" <> ServiceHeaderGlobal."Document Type") or
            (ServiceHeaderGlobal."No." <> ServiceHeader."No.") then
            ServiceHeaderGlobal.Get(ServiceHeader."Document Type", ServiceHeader."No.");
        ServiceLineLoc."Line No." := 0;
        CheckDimValuePosting(ServiceLineLoc);
        CheckDimComb(ServiceLineLoc);

        ServiceLineLoc.SetRange("Document Type", ServiceHeaderGlobal."Document Type");
        ServiceLineLoc.SetRange("Document No.", ServiceHeaderGlobal."No.");
        ServiceLineLoc.SetFilter(Type, '<>%1', ServiceLineLoc.Type::Comment);
        if ServiceLineLoc.FindSet then
            repeat
                CheckDimComb(ServiceLineLoc);
                CheckDimValuePosting(ServiceLineLoc);
            until ServiceLineLoc.Next = 0;
    end;

    local procedure CheckDimComb(ServiceLinePar: Record "Service Line EDMS")
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        if ServiceLinePar."Line No." = 0 then
            if not DimMgt.CheckDimIDComb(ServiceHeaderGlobal."Dimension Set ID") then
                Error(
                  Text028,
                  ServiceHeaderGlobal."Document Type", ServiceHeaderGlobal."No.", DimMgt.GetDimCombErr);

        if ServiceLinePar."Line No." <> 0 then
            if not DimMgt.CheckDimIDComb(ServiceLinePar."Dimension Set ID") then
                Error(
                  Text029,
                  ServiceHeaderGlobal."Document Type", ServiceHeaderGlobal."No.", ServiceLinePar."Line No.", DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(var ServiceLinePar: Record "Service Line EDMS")
    var
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
        DimMgt: Codeunit DimensionManagement;
    begin
        if ServiceLinePar."Line No." = 0 then begin
            TableIDArr[1] := Database::"Vehicle Status";
            NumberArr[1] := ServiceHeaderGlobal."Vehicle Status Code";
            TableIDArr[2] := Database::Customer;
            NumberArr[2] := ServiceHeaderGlobal."Bill-to Customer No.";
            TableIDArr[3] := Database::"Salesperson/Purchaser";
            NumberArr[3] := ServiceHeaderGlobal."Service Advisor";
            TableIDArr[4] := Database::"Responsibility Center";
            NumberArr[4] := ServiceHeaderGlobal."Responsibility Center";
            TableIDArr[5] := Database::"Deal Type";
            NumberArr[5] := ServiceHeaderGlobal."Deal Type";
            TableIDArr[6] := Database::Vehicle;
            NumberArr[6] := ServiceHeaderGlobal.VIN;
            TableIDArr[7] := Database::Make;
            NumberArr[7] := ServiceHeaderGlobal."Make Code";
            TableIDArr[8] := Database::Vehicle;
            NumberArr[8] := ServiceHeaderGlobal."Vehicle Serial No.";
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, ServiceHeaderGlobal."Dimension Set ID") then
                Error(
                  Text030,
                  ServiceHeaderGlobal."Document Type", ServiceHeaderGlobal."No.", DimMgt.GetDimValuePostingErr);
        end else begin
            TableIDArr[1] := Database::"Responsibility Center";
            NumberArr[1] := ServiceLinePar."Responsibility Center";
            TableIDArr[2] := EDMSTypeToTableID5(ServiceLinePar.Type);
            NumberArr[2] := ServiceLinePar."No.";
            TableIDArr[3] := Database::Vehicle;
            NumberArr[3] := ServiceLinePar."Vehicle Serial No.";

            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, ServiceLinePar."Dimension Set ID") then
                Error(
                  Text031,
                  ServiceLinePar."Document Type", ServiceLinePar."Document No.", ServiceLinePar."Line No.", DimMgt.GetDimValuePostingErr);
        end;
    end;

    local procedure GetAllocTotalTimeSpent(AllocationEntryNo: Integer) TotalTimeSpent: Decimal
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        ServLaborAllocEntry: Record "Serv. Labor Allocation Entry";
    begin
        if ServLaborAllocEntry.Get(AllocationEntryNo) then begin
            ServLaborAllocEntry.CalcFields("Total Time Spent", "Total Time Spent Travel");
            TotalTimeSpent := ServLaborAllocEntry."Total Time Spent" + ServLaborAllocEntry."Total Time Spent Travel";
        end;

        // ServLaborAllocApplication.RESET;
        // ServLaborAllocApplication.SETRANGE("Allocation Entry No.",AllocationEntryNo);
        // IF ServLaborAllocApplication.FINDFIRST THEN
        //  REPEAT
        //    TotalTimeSpent += ServLaborAllocApplication."Finished Quantity (Hours)";
        //  UNTIL ServLaborAllocApplication.NEXT = 0;
    end;

    local procedure GetAllocResourceCountLine(DocType: Integer; DocNo: Code[20]; LineNo: Integer) ResourceCount: Decimal
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
    begin
        ServLaborAllocApplication.SetRange("Document Type", DocType);
        ServLaborAllocApplication.SetRange("Document No.", DocNo);
        ServLaborAllocApplication.SetRange("Document Line No.", LineNo);
        ResourceCount := ServLaborAllocApplication.Count;
    end;

    local procedure GetAllocResourceCountHead(DocType: Integer; DocNo: Code[20]) ResourceCount: Decimal
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
    begin
        ServLaborAllocApplication.SetRange("Document Type", DocType);
        ServLaborAllocApplication.SetRange("Document No.", DocNo);
        ServLaborAllocApplication.SetRange("Document Line No.", 0);
        ResourceCount := ServLaborAllocApplication.Count;
    end;

    local procedure GetApplicationCount(AllocationEntryNo: Integer) ResourceCount: Decimal
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
    begin
        ServLaborAllocApplication.SetRange("Allocation Entry No.", AllocationEntryNo);
        ServLaborAllocApplication.SetFilter("Allocation Entry No.", '<>%1', 0);
        ResourceCount := ServLaborAllocApplication.Count;
    end;

    local procedure PostInvoiceLaborCostToGL(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        DimMgt: Codeunit DimensionManagement;
        GenJnPostLine: Codeunit "Gen. Jnl.-Post Line";
        DetServLedgEntry: Record "Det. Serv. Ledger Entry EDMS";
        Resource: Record Resource;
        GenJnlLine: Record "Gen. Journal Line";
        LaborCostDescriptionTxt: label 'Labor cost for document %1';
    begin
        TempLaborCostGenJnlLine.Reset;
        TempLaborCostGenJnlLine.DeleteAll;
        ServiceSetup.Get;
        SourceCodeSetup.Get;
        case ServiceSetup."Service Cost Handling" of
            ServiceSetup."service cost handling"::"Post from Labor Cost":
                begin
                    SalesInvoiceLine.Reset;
                    SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                    SalesInvoiceLine.SetRange("Line Type", SalesInvoiceLine."line type"::Labor);
                    if SalesInvoiceLine.FindSet then
                        repeat
                            GenPostingSetup.Get(SalesInvoiceLine."Gen. Bus. Posting Group", SalesInvoiceLine."Gen. Prod. Posting Group");
                            GenPostingSetup.TestField("Labor Cost Account");
                            GenPostingSetup.TestField("Labor Cost Adjustment Account");
                            FillLaborCostGlJournalLine(SalesInvoiceLine."Gen. Bus. Posting Group", SalesInvoiceLine."Gen. Prod. Posting Group"
                                          , SalesInvoiceHeader."Posting Date", GenPostingSetup."Labor Cost Account", GenPostingSetup."Labor Cost Adjustment Account"
                                          , ROUND(SalesInvoiceLine."Quantity (Base)" * SalesInvoiceLine."Unit Cost (LCY)", 0.01)
                                          , SalesInvoiceHeader."No.", SourceCodeSetup.Sales, StrSubstNo(LaborCostDescriptionTxt, SalesInvoiceHeader."No."), SalesInvoiceLine."Dimension Set ID"
                                          , SalesInvoiceHeader."Deal Type Code", TempLaborCostGenJnlLine."document type"::Invoice, SalesInvoiceHeader."Vehicle Serial No."
                                          , SalesInvoiceHeader."Vehicle Accounting Cycle No.");
                            Clear(DimMgt);
                        //DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID",GenJnlLine."Shortcut Dimension 1 Code",
                        //          GenJnlLine."Shortcut Dimension 2 Code");
                        //GenJnPostLine.RunWithCheck(GenJnlLine);
                        until SalesInvoiceLine.Next = 0;
                end;
            ServiceSetup."service cost handling"::"Post from Resource Cost":
                begin
                    DetServLedgEntry.Reset;
                    DetServLedgEntry.SetRange("Document Type", DetServLedgEntry."document type"::Invoice);
                    DetServLedgEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
                    if DetServLedgEntry.FindSet then
                        repeat
                            Resource.Get(DetServLedgEntry."Resource No.");
                            //06.10.2021 EB.P7 BUG.112>>
                            Resource.TestField("Gen. Prod. Posting Group");
                            //06.10.2021 EB.P7 BUG.112<<
                            GenPostingSetup.Get(SalesInvoiceHeader."Gen. Bus. Posting Group", Resource."Gen. Prod. Posting Group");
                            GenPostingSetup.TestField("Labor Cost Account");
                            GenPostingSetup.TestField("Labor Cost Adjustment Account");
                            FillLaborCostGlJournalLine(SalesInvoiceHeader."Gen. Bus. Posting Group", Resource."Gen. Prod. Posting Group"
                                          , SalesInvoiceHeader."Posting Date", GenPostingSetup."Labor Cost Account", GenPostingSetup."Labor Cost Adjustment Account"
                                          , DetServLedgEntry."Cost Amount", SalesInvoiceHeader."No.", SourceCodeSetup.Sales, StrSubstNo(LaborCostDescriptionTxt, SalesInvoiceHeader."No."), SalesInvoiceHeader."Dimension Set ID"
                                          , SalesInvoiceHeader."Deal Type Code", TempLaborCostGenJnlLine."document type"::Invoice, SalesInvoiceHeader."Vehicle Serial No."
                                          , SalesInvoiceHeader."Vehicle Accounting Cycle No.");
                        until DetServLedgEntry.Next = 0;
                end;
        end;

        TempLaborCostGenJnlLine.Reset;
        if TempLaborCostGenJnlLine.FindSet then
            repeat
                GenJnlLine.Init;
                GenJnlLine.TransferFields(TempLaborCostGenJnlLine);
                Clear(DimMgt);
                DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code",
                                GenJnlLine."Shortcut Dimension 2 Code");
                GenJnPostLine.RunWithCheck(GenJnlLine);
            until TempLaborCostGenJnlLine.Next = 0;
    end;

    local procedure PostCrMemoLaborCostToGL(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        DimMgt: Codeunit DimensionManagement;
        GenJnPostLine: Codeunit "Gen. Jnl.-Post Line";
        DetServLedgEntry: Record "Det. Serv. Ledger Entry EDMS";
        Resource: Record Resource;
        GenJnlLine: Record "Gen. Journal Line";
        LaborCostDescriptionTxt: label 'Labor cost for document %1';
    begin
        TempLaborCostGenJnlLine.Reset;
        TempLaborCostGenJnlLine.DeleteAll;
        ServiceSetup.Get;
        SourceCodeSetup.Get;
        GLSetup.Get;
        case ServiceSetup."Service Cost Handling" of
            ServiceSetup."service cost handling"::"Post from Labor Cost":
                begin
                    SalesCrMemoLine.Reset;
                    SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
                    SalesCrMemoLine.SetRange("Line Type", SalesCrMemoLine."line type"::Labor);
                    if SalesCrMemoLine.FindSet then
                        repeat
                            GenPostingSetup.Get(SalesCrMemoLine."Gen. Bus. Posting Group", SalesCrMemoLine."Gen. Prod. Posting Group");
                            GenPostingSetup.TestField("Labor Cost Account");
                            GenPostingSetup.TestField("Labor Cost Adjustment Account");
                            FillLaborCostGlJournalLine(SalesCrMemoLine."Gen. Bus. Posting Group", SalesCrMemoLine."Gen. Prod. Posting Group"
                                          , SalesCrMemoHeader."Posting Date", GenPostingSetup."Labor Cost Account", GenPostingSetup."Labor Cost Adjustment Account"
                                          , -ROUND(SalesCrMemoLine."Quantity (Base)" * SalesCrMemoLine."Unit Cost (LCY)", GLSetup."Amount Rounding Precision")
                                          , SalesCrMemoHeader."No.", SourceCodeSetup.Sales, StrSubstNo(LaborCostDescriptionTxt, SalesCrMemoHeader."No."), SalesCrMemoLine."Dimension Set ID"
                                          , SalesCrMemoHeader."Deal Type Code", TempLaborCostGenJnlLine."document type"::"Credit Memo", SalesCrMemoHeader."Vehicle Serial No."
                                          , SalesCrMemoHeader."Vehicle Accounting Cycle No.");
                        until SalesCrMemoLine.Next = 0;
                end;
            ServiceSetup."service cost handling"::"Post from Resource Cost":
                begin
                    DetServLedgEntry.Reset;
                    DetServLedgEntry.SetRange("Document Type", DetServLedgEntry."document type"::"Credit Memo");
                    DetServLedgEntry.SetRange("Document No.", SalesCrMemoHeader."No.");
                    if DetServLedgEntry.FindSet then
                        repeat
                            Resource.Get(DetServLedgEntry."Resource No.");
                            GenPostingSetup.Get(SalesCrMemoHeader."Gen. Bus. Posting Group", Resource."Gen. Prod. Posting Group");
                            GenPostingSetup.TestField("Labor Cost Account");
                            GenPostingSetup.TestField("Labor Cost Adjustment Account");
                            FillLaborCostGlJournalLine(SalesCrMemoHeader."Gen. Bus. Posting Group", Resource."Gen. Prod. Posting Group"
                                          , SalesCrMemoHeader."Posting Date", GenPostingSetup."Labor Cost Account", GenPostingSetup."Labor Cost Adjustment Account"
                                          , ROUND(DetServLedgEntry."Cost Amount", GLSetup."Amount Rounding Precision"), SalesCrMemoHeader."No.", SourceCodeSetup.Sales, StrSubstNo(LaborCostDescriptionTxt, SalesCrMemoHeader."No."), SalesCrMemoHeader."Dimension Set ID"
                                          , SalesCrMemoHeader."Deal Type Code", TempLaborCostGenJnlLine."document type"::"Credit Memo", SalesCrMemoHeader."Vehicle Serial No."
                                          , SalesCrMemoHeader."Vehicle Accounting Cycle No.");
                        until DetServLedgEntry.Next = 0;
                end;
        end;

        TempLaborCostGenJnlLine.Reset;
        if TempLaborCostGenJnlLine.FindSet then
            repeat
                GenJnlLine.Init;
                GenJnlLine.TransferFields(TempLaborCostGenJnlLine);
                Clear(DimMgt);
                DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code",
                                GenJnlLine."Shortcut Dimension 2 Code");
                GenJnPostLine.RunWithCheck(GenJnlLine);
            until TempLaborCostGenJnlLine.Next = 0;
    end;

    local procedure FillLaborCostGlJournalLine(GenBusPostingGr: Code[20]; GenProdPostingGr: Code[20]; PostingDate: Date; AccountNo: Code[20]; BalAccountNo: Code[20]; Amount: Decimal; DocumentNo: Code[20]; SrcCode: Code[10]; Description: Text; DimSetID: Integer; DealType: Code[10]; DocType: Integer; VehicleSerialNo: Code[20]; VehAccCycleNo: Code[20])
    var
        LineNo: Integer;
    begin
        if Amount = 0 then
            exit;
        TempLaborCostGenJnlLine.Reset;
        if TempLaborCostGenJnlLine.FindLast then
            LineNo := 10000 + TempLaborCostGenJnlLine."Line No."
        else
            LineNo := 10000;

        TempLaborCostGenJnlLine.Reset;
        TempLaborCostGenJnlLine.SetRange("Account No.", AccountNo);
        TempLaborCostGenJnlLine.SetRange("Bal. Account No.", BalAccountNo);
        TempLaborCostGenJnlLine.SetRange("Dimension Set ID", DimSetID);
        TempLaborCostGenJnlLine.SetRange("Deal Type Code", DealType);
        //TempLaborCostGenJnlLine.SETRANGE("Gen. Bus. Posting Group", GenBusPostingGr);
        //TempLaborCostGenJnlLine.SETRANGE("Gen. Prod. Posting Group", GenProdPostingGr);
        if not TempLaborCostGenJnlLine.FindFirst then begin
            TempLaborCostGenJnlLine.Init;
            TempLaborCostGenJnlLine."Line No." := LineNo;
            TempLaborCostGenJnlLine."Posting Date" := PostingDate;
            TempLaborCostGenJnlLine."Account No." := AccountNo;
            TempLaborCostGenJnlLine."Bal. Account No." := BalAccountNo;
            TempLaborCostGenJnlLine."Document No." := DocumentNo;
            TempLaborCostGenJnlLine."Source Code" := SrcCode;
            TempLaborCostGenJnlLine.Description := Description;
            TempLaborCostGenJnlLine."System-Created Entry" := true;
            //TempLaborCostGenJnlLine."Gen. Posting Type" := TempLaborCostGenJnlLine."Gen. Posting Type"::Sale;
            TempLaborCostGenJnlLine."Dimension Set ID" := DimSetID;
            TempLaborCostGenJnlLine."Deal Type Code" := DealType;
            TempLaborCostGenJnlLine."Document Type" := DocType;
            TempLaborCostGenJnlLine."Vehicle Serial No." := VehicleSerialNo;
            TempLaborCostGenJnlLine."Vehicle Accounting Cycle No." := VehAccCycleNo;
            //TempLaborCostGenJnlLine."Gen. Bus. Posting Group" := GenBusPostingGr;
            //TempLaborCostGenJnlLine."Gen. Prod. Posting Group" := GenProdPostingGr;
            TempLaborCostGenJnlLine.Insert;
        end;
        TempLaborCostGenJnlLine.Amount += Amount;
        TempLaborCostGenJnlLine.Modify;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure PostLaborCostToGL(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        ServiceSetup.Get;
        if ServiceSetup."Service Cost Handling" = ServiceSetup."service cost handling"::"Show from Labor Cost" then
            exit;
        if SalesInvHdrNo <> '' then begin
            SalesInvHeader.Get(SalesInvHdrNo);
            if SalesInvHeader."Document Profile" = SalesInvHeader."document profile"::Service then
                PostInvoiceLaborCostToGL(SalesInvHeader);
        end else
            if SalesCrMemoHdrNo <> '' then begin
                SalesCrMemoHeader.Get(SalesCrMemoHdrNo);
                if SalesCrMemoHeader."Document Profile" = SalesCrMemoHeader."document profile"::Service then
                    PostCrMemoLaborCostToGL(SalesCrMemoHeader);
            end;

    end;

    local procedure UpdateOpportunities(var ServiceHeader: Record "Service Header EDMS"; SalesHeader: Record "Sales Header")
    var
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
    begin
        if ServiceHeader."Document Type" = ServiceHeader."document type"::Order then begin
            Opp.Reset;
            Opp.SetCurrentkey("Sales Document Type", "Sales Document No.");
            Opp.SetRange("Sales Document Type", Opp."sales document type"::Order);
            Opp.SetRange("Sales Document No.", ServiceHeader."No.");
            Opp.SetRange(Status, Opp.Status::Won);
            if Opp.FindFirst then begin
                Opp."Sales Document Type" := Opp."sales document type"::Order;
                Opp."Sales Document No." := SalesHeader."No.";
                Opp.Modify;
                SalesHeader."Opportunity No." := Opp."No.";
                SalesHeader.Modify;
            end;
        end;
    end;

    procedure SetPreviewMode(NewPreviewMode: Boolean)
    begin
        PreviewMode := NewPreviewMode;
    end;

    //>>DELTA 1
    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforePostServiceDoc(var ServiceHeader: Record "Service Header EDMS"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterPostServiceDoc(var ServiceHeader: Record "Service Header EDMS"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(true, False)]
    local procedure OnBeforeInsertSalesInvoiceHeader(VAR SalesInvoiceHeader: Record "Sales Header"; ServiceHeader: Record "Service Header EDMS")
    begin

    end;

    [IntegrationEvent(true, False)]
    LOCAL procedure OnBeforeInsertSalesInvoiceLine(VAR SalesInvoiceLine: Record "Sales Line"; SalesInvoiceHeader: Record "Sales Header"; ServiceLine: Record "Service Line EDMS")
    begin

    end;


    [IntegrationEvent(true, False)]
    local procedure OnBeforeInitSalesInvoiceHeader(VAR SalesInvoiceHeader: Record "Sales Header"; ServiceHeader: Record "Service Header EDMS")
    begin

    end;

    [IntegrationEvent(true, False)]
    local procedure OnBeforeCreatePostedServiceHeader(ServiceHeader: Record "Service Header EDMS")
    begin

    end;

    [IntegrationEvent(true, False)]
    local procedure OnAfterModifyProcessChecklist(ServiceHeader: Record "Service Header EDMS"; PstOrdHeader: Record "Posted Serv. Order Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostServiceOrder(ServiceHeader: Record "Service Header EDMS")
    begin
    end;



    [IntegrationEvent(true, False)]
    local procedure OnBeforeModifySalesInvoiceHeader(VAR SalesInvoiceHeader: Record "Sales Header"; ServiceHeader: Record "Service Header EDMS")
    begin

    end;

    //<<DELTA 01
    //------------------------------- codeunit 408 DimensionManagement

    procedure EDMSTypeToTableID5(Type: Option " ","G/L Account",Item,Labor,"External Service",Resource): Integer
    begin
        case Type of
            Type::" ":
                exit(0);
            Type::Item:
                exit(Database::Item);
            Type::"G/L Account":
                exit(Database::"G/L Account");
            // 20.03.2013 EDMS >>
            Type::Resource:
                exit(Database::Resource);
            //  Type::Cost:
            //    EXIT(DATABASE::"Service Cost");
            Type::Labor:
                exit(Database::"Service Labor");
            Type::"External Service":
                exit(Database::"External Service");
        // 20.03.2013 EDMS <<

        end;
    end;

    procedure EDMSTypeToTableID6(Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)","External Service") TableId: Integer
    begin
        case Type of
            Type::" ":
                exit(0);
            Type::"G/L Account":
                exit(Database::"G/L Account");
            Type::Item:
                exit(Database::Item);
            Type::Resource:
                exit(Database::Resource);
            Type::"Fixed Asset":
                exit(Database::"Fixed Asset");
            Type::"Charge (Item)":
                exit(Database::"Item Charge");
            Type::"External Service":
                exit(Database::"External Service");
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterFillSalesHeaderFromServiceHeader(var SalesHeader: Record "Sales Header"; var ServiceHeader: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterFillSalesLineFromServiceLine(var SalesLine: Record "Sales Line"; var ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterFillPostedServiceHeader(var PostedServiceHeader: Record "Posted Serv. Order Header"; var ServiceHeader: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterFillPostedServiceLine(var PostedServiceLine: Record "Posted Serv. Order Line"; var ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterFillServiceJournalInPost(var ServJournalLine: Record "Serv. Journal Line"; var ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterCheckServiceHeader(var ServiceHeader: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertPstOrdLine(PstOrdLine: Record "Posted Serv. Order Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePostedServiceHeader(PstOrdHeader: Record "Posted Serv. Order Header")
    begin
    end;

}

