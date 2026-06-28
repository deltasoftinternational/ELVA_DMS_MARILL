Codeunit 25006607 "Rent-Post"
{
    TableNo = "Rent Header";

    trigger OnRun()
    begin
        Window.Open(
          '#1#################################\\' +
          Text033);

        Window.Update(1, StrSubstNo(Text044, Rec."No."));

        RentHeaderTemp := Rec;
        PostRentOrder(Rec);

        Window.Close;
    end;

    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        RentSetup: Record "Rent Mgt. Setup";
        cuReleaseSalesDoc: Codeunit "Release Sales Document";
        tcSer003: label 'Put Items to "';
        ScheduleMgt: Codeunit "Service Schedule Mgt.";
        tcSer004: label '" invoice.';
        tcSer005: label 'Invoice creation is interupted!';
        tcSer006: label 'Not all quantity is transferred.';
        TotalServiceLine: Record "Service Line EDMS";
        TempServiceLine: Record "Service Line EDMS" temporary;
        TempPrepaymentServiceLine: Record "Service Line EDMS" temporary;
        GenPostingSetup: Record "General Posting Setup";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        GLSetup: Record "General Ledger Setup";
        CustPostingGr: Record "Customer Posting Group";
        ServiceHeader: Record "Service Header EDMS";
        RentLine: Record "Rent Line";
        RentSalesLine: Record "Rent Sales Line";
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
        Text047: label 'The quantity to ship does not match the quantity defined in Item Tracking.';
        Text048: label 'must be at least %1';
        SourceCode: Code[20];
        SourceCodeSetup: Record "Source Code Setup";
        NoSeriesMgt: Codeunit "No. Series";
        RentHeaderTemp: Record "Rent Header" temporary;
        ReserveServLine: Codeunit "Service Line EDMS-Reserve";
        Text050: label 'Service Line reservation must be to inventory.';
        PrintInvoice: Boolean;
        Error001: label 'Please type short Description of the job before posting';
        Text001: label '%1 created. Document No.: %2';
        Err001: label 'Can not post the Rent Order. There are uninvoiced sales lines.';
        Err001c: label 'Can not post the Rent Order. There are uninvoiced sales lines.\Would you like to continue?';
        Err002: label 'Can not post the Rent Order. There are uncompleted rent lines.';
        Err002c: label 'Can not post the Rent Order. There are uncompleted rent lines.\Would you like to continue?';
        Err003: label 'Can not post the Rent Order. Motor Hours To are not defined.';
        Err003c: label 'Can not post the Rent Order. Motor Hours To are not defined.\Would you like to continue?';
        Text033: label 'Posting lines     #2######';
        Text044: label 'Transfer Order %1';
        Window: Dialog;
        DialogLineCount: Integer;
        UserSetup: Record "User Setup";
        CancelDocDescriptTxt: label 'Cancels Line from document: %1  %2';
        InvoiceTxt: label 'Invoice';
        CrMemoTxt: label 'Credit Memo';
        PostedInvoiceTxt: label 'Posted Invoice';
        PostedCreditMemoTxt: label 'Posted Credit Memo';
        Text011: label '%1 %2 is created. Would you like to open?';


    procedure CreateInvoices(RentHeader: Record "Rent Header"; ShowInvoiceConfirm: Boolean; InvoiceDate: Date) SalesInvoiceNo: Code[20]
    var
        RentSalesLine: Record "Rent Sales Line";
        SalesHeader2: Record "Sales Header";
        SalesLine2: Record "Sales Line";
        UserProfile: Record "Sales Analysis Line";
        Location: Record Location;
        cuWorkplaceMgt: Codeunit UserProfileManagement;
        NewSalesLine: Record "Sales Line";
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        BalLineOffset: Integer;
        AllTransferred: Boolean;
        TextNothingToPost: label 'Nothing to post!';
        InvCount: Integer;
        NewLineNo: Integer;
        NewLineNo2: Integer;
        SalesHeader: Record "Sales Header";
        Text100: label 'Quantity in line %1 must be fully reserved to inventory';
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
        SalesDocumentNo: Code[20];
        SalesDocumentType: Option;
        NoInvoicesCreatedErr: label 'There is no Invoices to create';
        SalesLinesForInvoicesExists: Boolean;
        InvoiceTotalAmount: Decimal;
        RentInvoice: Page "Sales Invoice";
        RentCrMemo: Page "Sales Credit Memo";
        Text101: label 'Deal Type is missing. You must specify Deal Type to continue';
        RentLine2: Record "Rent Line";
        IsHandled: Boolean;
    begin
        RentSetup.Get;
        if RentSetup."Deal Type Mandatory" then
            if RentHeader."Deal Type" = '' then
                Error(Text101);

        //Checks whether there is anything to post
        RentSalesLine.Reset;
        RentSalesLine.SetRange("Document Type", RentHeader."Document Type");
        RentSalesLine.SetRange("Document No.", RentHeader."No.");
        RentSalesLine.SetFilter(Type, '<>''''');
        RentSalesLine.SetFilter("No.", '<>''''');
        RentSalesLine.SetFilter("Rent Ledg. Entry Document No.", '%1', '');
        RentSalesLine.SetRange("To Invoice", true);
        SalesDocumentNo := '';
        SalesLinesForInvoicesExists := false;
        if not RentSalesLine.FindFirst then
            Error(NoInvoicesCreatedErr)
        else begin
            repeat
                // Check if Sales Document already exists for rent sales line
                RentSalesLine.GetSalesDocument(SalesDocumentType, SalesDocumentNo);
                if SalesDocumentNo = '' then
                    SalesLinesForInvoicesExists := true;
                OnBeforeCreateInvoiceCheckValues(RentSalesLine);
            until RentSalesLine.Next = 0;
            if not SalesLinesForInvoicesExists then
                Error(NoInvoicesCreatedErr);
        end;

        RentSalesLine.CalcSums("Line Amount");
        InvoiceTotalAmount := RentSalesLine."Line Amount";

        if RentSalesLine.FindFirst then begin
            RentSetup.Get;
            SalesSetup.Get;

            //Creates Sales Headers

            SalesHeader.Reset;
            CreateSalesHeader(RentHeader, SalesHeader, InvoiceTotalAmount);
            SalesHeader.SetHideValidationDialog(true);

            case SalesHeader."Document Type" of
                SalesHeader."document type"::Invoice:
                    if (RentSetup."Posted Invoice Nos." <> '') then
                        SalesHeader.Validate("Posting No. Series", RentSetup."Posted Invoice Nos.");

                SalesHeader."document type"::"Credit Memo":
                    begin
                        //  if (ServiceSetup."Posted Credit Memo Nos." <> '') then
                        //      SalesHeader.Validate("Posting No. Series", ServiceSetup."Posted Credit Memo Nos.");
                        //>>DELTA XX
                        if (RentSetup."Posted Credit Memo Nos." <> '') then
                            SalesHeader.Validate("Posting No. Series", RentSetup."Posted Credit Memo Nos.");
                        //<<DELTA XX
                    end
            end;

            SalesHeader."Allow Line Disc." := true;
            SalesHeader.Validate("Payment Method Code", RentHeader."Payment Method Code");
            SalesHeader.Validate("Payment Terms Code", RentHeader."Payment Terms Code");
            SalesHeader."Prices Including VAT" := RentHeader."Prices Including VAT";
            SalesHeader.Validate("Location Code", RentHeader."Location Code");
            SalesHeader."Shortcut Dimension 1 Code" := RentHeader."Shortcut Dimension 1 Code";
            SalesHeader."Shortcut Dimension 2 Code" := RentHeader."Shortcut Dimension 2 Code";
            SalesHeader."Dimension Set ID" := RentHeader."Dimension Set ID";
            SalesHeader."Contract No." := RentHeader."Contract No.";
            SalesHeader.Validate("Posting Date", InvoiceDate);   //add invoice date
            //>>DELTA XX
            OnAfterCreateInvoiceHeader(SalesHeader, InvoiceDate);
            //<<DELTA XX
            SalesHeader.Modify;

            SalesInvoiceNo := SalesHeader."No.";

            //Lines copy
            repeat
                CreateSalesLine(SalesHeader, RentSalesLine, NewSalesLine, 100, NewLineNo, true);
                //Add invoice no and invoiced
                //RentSalesLine.Invoiced := TRUE;
                //RentSalesLine."Invoice No." := SalesHeader."No.";
                RentSalesLine."To Invoice" := false;
                RentSalesLine.Modify;
                OnBeforeCreateDescriptionSalesLine(SalesHeader, RentSalesLine, RentHeader, IsHandled, NewLineNo);
                If not IsHandled Then begin
                    if RentSalesLine."Cancels Line No." <> 0 then
                        CreateCancelingDescriptionLine(SalesHeader, RentSalesLine, NewLineNo);
                    if RentSalesLine."Attached to Rent Line No." <> 0 then begin
                        if RentSetup."Sales Inv. Line Decr. Text 2" <> '' then
                            CreateDescriptionSalesLine(RentSetup."Sales Inv. Line Decr. Text 2", SalesHeader, RentSalesLine, NewLineNo);
                        if RentSetup."Sales Inv. Line Decr. Text 3" <> '' then
                            CreateDescriptionSalesLine(RentSetup."Sales Inv. Line Decr. Text 3", SalesHeader, RentSalesLine, NewLineNo);
                        if RentSetup."Sales Inv. Line Decr. Text 4" <> '' then
                            CreateDescriptionSalesLine(RentSetup."Sales Inv. Line Decr. Text 4", SalesHeader, RentSalesLine, NewLineNo);
                        if RentLine2.Get(RentSalesLine."Document Type", RentSalesLine."Document No.", RentSalesLine."Attached to Rent Line No.") then
                            if RentLine2."Invoice Additional Description" <> '' then
                                CreateDescriptionSalesLine(RentLine2."Invoice Additional Description", SalesHeader, RentSalesLine, NewLineNo);
                    end;
                end;
            until RentSalesLine.Next = 0;

        end;
        if ShowInvoiceConfirm then
            if Confirm(Text011, true, Format(SalesHeader."Document Type"), SalesHeader."No.") then begin
                if SalesHeader."Document Type" = SalesHeader."document type"::Invoice then begin
                    RentInvoice.SetRecord(SalesHeader);
                    RentInvoice.Run;
                end else
                    if SalesHeader."Document Type" = SalesHeader."document type"::"Credit Memo" then begin
                        RentCrMemo.SetRecord(SalesHeader);
                        RentCrMemo.Run;
                    end;
            end;
    end;

    procedure CreateInvoiceByRentOrders(var RentOrdersCombined: Record "Rent Billing Worksheet Line"; ShowInvoiceConfirm: Boolean; InvoiceDate: Date) SalesInvoiceNo: Code[20]
    var
        RentSalesLine: Record "Rent Sales Line";
        SalesHeader2: Record "Sales Header";
        SalesLine2: Record "Sales Line";
        UserProfile: Record "Sales Analysis Line";
        Location: Record Location;
        cuWorkplaceMgt: Codeunit UserProfileManagement;
        NewSalesLine: Record "Sales Line";
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        BalLineOffset: Integer;
        AllTransferred: Boolean;
        TextNothingToPost: label 'Nothing to post!';
        InvCount: Integer;
        NewLineNo: Integer;
        NewLineNo2: Integer;
        SalesHeader: Record "Sales Header";
        Text100: label 'Quantity in line %1 must be fully reserved to inventory';
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
        SalesDocumentNo: Code[20];
        SalesDocumentType: Option;
        NoInvoicesCreatedErr: label 'There is no Invoices to create';
        SalesLinesForInvoicesExists: Boolean;
        InvoiceTotalAmount: Decimal;
        RentInvoice: Page "Sales Invoice";
        RentCrMemo: Page "Sales Credit Memo";
        RentSalesLinesExists: Boolean;
        RentHeader: Record "Rent Header";
        RentLine2: Record "Rent Line";
        IsHandled: Boolean;
    begin
        RentSetup.Get;

        RentOrdersCombined.Reset;
        if RentOrdersCombined.FindFirst() then begin
            RentHeader.get(RentOrdersCombined."Document Type", RentOrdersCombined."Document No.");
            repeat
                //Checks whether there is anything to post
                RentSalesLine.Reset;
                RentSalesLine.SetRange("Document Type", RentOrdersCombined."Document Type");
                RentSalesLine.SetRange("Document No.", RentOrdersCombined."Document No.");
                RentSalesLine.SetFilter(Type, '<>''''');
                RentSalesLine.SetFilter("No.", '<>''''');
                RentSalesLine.SetFilter("Rent Ledg. Entry Document No.", '%1', '');
                RentSalesLine.SetRange("To Invoice", true);
                RentSalesLinesExists := false;
                if RentSalesLine.FindFirst then begin
                    RentSalesLinesExists := true;
                end;
                RentSalesLine.CalcSums("Line Amount");
                InvoiceTotalAmount += RentSalesLine."Line Amount";
            until RentOrdersCombined.Next() = 0;
        end;
        if not RentSalesLinesExists then
            Error(NoInvoicesCreatedErr);

        RentSetup.Get;
        SalesSetup.Get;
        //Creates Sales Headers

        SalesHeader.Reset;
        CreateSalesHeader(RentHeader, SalesHeader, InvoiceTotalAmount);
        SalesHeader.SetHideValidationDialog(true);

        case SalesHeader."Document Type" of
            SalesHeader."document type"::Invoice:
                if (RentSetup."Posted Invoice Nos." <> '') then
                    SalesHeader.Validate("Posting No. Series", RentSetup."Posted Invoice Nos.");

            SalesHeader."document type"::"Credit Memo":
                begin
                    if (ServiceSetup."Posted Credit Memo Nos." <> '') then
                        SalesHeader.Validate("Posting No. Series", ServiceSetup."Posted Credit Memo Nos.");
                end
        end;

        SalesHeader."Allow Line Disc." := true;
        SalesHeader.Validate("Payment Method Code", RentHeader."Payment Method Code");
        SalesHeader.Validate("Payment Terms Code", RentHeader."Payment Terms Code");
        SalesHeader."Prices Including VAT" := RentHeader."Prices Including VAT";
        SalesHeader.Validate("Location Code", RentHeader."Location Code");
        SalesHeader."Shortcut Dimension 1 Code" := RentHeader."Shortcut Dimension 1 Code";
        SalesHeader."Shortcut Dimension 2 Code" := RentHeader."Shortcut Dimension 2 Code";
        SalesHeader."Dimension Set ID" := RentHeader."Dimension Set ID";
        SalesHeader.Validate("Posting Date", InvoiceDate);
        //>>DELTA XX
        OnAfterCreateInvoiceHeaderByRentOrders(SalesHeader, InvoiceDate);
        //<<DELTA XX
        SalesHeader.Modify;

        SalesInvoiceNo := SalesHeader."No.";

        RentOrdersCombined.Reset;
        if RentOrdersCombined.FindFirst() then begin
            repeat
                RentSalesLine.Reset;
                RentSalesLine.SetRange("Document Type", RentOrdersCombined."Document Type");
                RentSalesLine.SetRange("Document No.", RentOrdersCombined."Document No.");
                RentSalesLine.SetFilter(Type, '<>''''');
                RentSalesLine.SetFilter("No.", '<>''''');
                RentSalesLine.SetFilter("Rent Ledg. Entry Document No.", '%1', '');
                RentSalesLine.SetRange("To Invoice", true);
                RentSalesLinesExists := false;

                if RentSalesLine.FindFirst then begin
                    //Lines copy
                    repeat
                        CreateSalesLine(SalesHeader, RentSalesLine, NewSalesLine, 100, NewLineNo, true);

                        RentSalesLine."To Invoice" := false;
                        RentSalesLine.Modify;
                        OnBeforeCreateDescriptionSalesLine(SalesHeader, RentSalesLine, RentHeader, IsHandled, NewLineNo);
                        If Not IsHandled Then begin
                            if RentSalesLine."Cancels Line No." <> 0 then
                                CreateCancelingDescriptionLine(SalesHeader, RentSalesLine, NewLineNo);
                            if RentSalesLine."Attached to Rent Line No." <> 0 then begin
                                if RentSetup."Sales Inv. Line Decr. Text 2" <> '' then
                                    CreateDescriptionSalesLine(RentSetup."Sales Inv. Line Decr. Text 2", SalesHeader, RentSalesLine, NewLineNo);
                                if RentSetup."Sales Inv. Line Decr. Text 3" <> '' then
                                    CreateDescriptionSalesLine(RentSetup."Sales Inv. Line Decr. Text 3", SalesHeader, RentSalesLine, NewLineNo);
                                if RentSetup."Sales Inv. Line Decr. Text 4" <> '' then
                                    CreateDescriptionSalesLine(RentSetup."Sales Inv. Line Decr. Text 4", SalesHeader, RentSalesLine, NewLineNo);
                                if RentLine2.Get(RentSalesLine."Document Type", RentSalesLine."Document No.", RentSalesLine."Attached to Rent Line No.") then
                                    if RentLine2."Invoice Additional Description" <> '' then
                                        CreateDescriptionSalesLine(RentLine2."Invoice Additional Description", SalesHeader, RentSalesLine, NewLineNo);

                            end;
                        end;


                    until RentSalesLine.Next = 0;
                end;
            until RentOrdersCombined.Next() = 0;
        end;
        if ShowInvoiceConfirm then
            if Confirm(Text011, true, Format(SalesHeader."Document Type"), SalesHeader."No.") then begin
                if SalesHeader."Document Type" = SalesHeader."document type"::Invoice then begin
                    RentInvoice.SetRecord(SalesHeader);
                    RentInvoice.Run;
                end else
                    if SalesHeader."Document Type" = SalesHeader."document type"::"Credit Memo" then begin
                        RentCrMemo.SetRecord(SalesHeader);
                        RentCrMemo.Run;
                    end;
            end;
    end;


    procedure GetNoSeriesCode(SalesHeader: Record "Sales Header"): Code[10]
    begin
        case SalesHeader."Document Type" of
            SalesHeader."document type"::Invoice:
                exit(RentSetup."Invoice Nos.");
            SalesHeader."document type"::"Credit Memo":
                exit(RentSetup."Credit Memo Nos.")
        end
    end;


    procedure CreateSalesHeader(RentHeader: Record "Rent Header"; var SalesHeader: Record "Sales Header"; InvTotalAmt: Decimal)
    var
        NoSeriesMgt: Codeunit "No. Series";
        codNo: Code[20];
    begin
        RentSetup.Get;
        SalesHeader.Init;

        SalesHeader.SetHideValidationDialog(true);

        SalesHeader."Document Profile" := SalesHeader."document profile"::Rent;

        if InvTotalAmt >= 0 then
            SalesHeader.Validate("Document Type", SalesHeader."document type"::Invoice)
        else
            SalesHeader.Validate("Document Type", SalesHeader."document type"::"Credit Memo");

        SalesHeader."No. Series" := GetNoSeriesCode(SalesHeader);
        //>>DELTA XX
        OnBeforeCreateRentInvoiceHeader(SalesHeader, RentHeader);
        //<<DELTA XX
        SalesHeader.Insert(true);

        //SalesHeader.Validate("Posting Date", "Posting Date");
        //SalesHeader.Validate("Document Date", "Document Date");
        //SalesHeader.Validate("Shipment Date", "Shipment Date");
        SalesHeader.Validate("Sell-to Customer No.", RentHeader."Sell-to Customer No.");
        if RentHeader."Sell-to Contact No." <> '' then
            SalesHeader.Validate("Sell-to Contact No.", RentHeader."Sell-to Contact No.");
        if RentHeader."Bill-to Customer No." <> RentHeader."Sell-to Customer No." then
            SalesHeader.Validate("Bill-to Customer No.", RentHeader."Bill-to Customer No.");
        if RentHeader."Ship-to Code" <> '' then
            SalesHeader.Validate("Ship-to Code", RentHeader."Ship-to Code");
        SalesHeader.Validate("Payment Method Code", RentHeader."Payment Method Code");
        SalesHeader.Validate("Payment Terms Code", RentHeader."Payment Terms Code");
        SalesHeader.Validate("VAT Bus. Posting Group", RentHeader."VAT Bus. Posting Group");
        //SalesHeader.Validate("Order Date", "Order Date");
        OnAfterSetCustomerNoOnRentalInvoice(SalesHeader, RentHeader);
        SalesHeader."Posting No." := codNo;
        SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type";
        SalesHeader."Applies-to Doc. No." := SalesHeader."Applies-to Doc. No.";
        SalesHeader.Validate("Currency Code", RentHeader."Currency Code");
        SalesHeader."Rent Order No." := RentHeader."No.";
        SalesHeader.Validate("Responsibility Center", RentHeader."Responsibility Center");
        SalesHeader.Validate("Deal Type Code", RentHeader."Deal Type");
        SalesHeader."Document Profile" := SalesHeader."document profile"::Rent;
        SalesHeader.Validate("Salesperson Code", RentHeader."Salesperson Code");
        SalesHeader."Rent Order No." := RentHeader."No.";
        SalesHeader."External Document No." := RentHeader."External Document No.";
        SalesHeader.Modify
    end;


    procedure CreateSalesLine(SalesHeader: Record "Sales Header"; var RentSalesLineFrom: Record "Rent Sales Line"; var SalesLine: Record "Sales Line"; decPart: Decimal; var NewLineNo: Integer; UseRentLineNo: Boolean)
    var
        GenPostSetup: Record "General Posting Setup";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesShpmtHdr: Record "Sales Shipment Header";
        ItemLedgEntry: Record "Item Ledger Entry";
        RentLineAttachedTo: Record "Rent Line";
        Vehicle: Record Vehicle;
        IsHandled: Boolean;
    begin
        RentSetup.Get;
        //IF UseRentLineNo THEN
        //  NewLineNo := RentSalesLine."Line No."
        //ELSE
        NewLineNo += 10000;

        Clear(RentLineAttachedTo);
        if RentLineAttachedTo.Get(RentSalesLineFrom."Document Type", RentSalesLineFrom."Document No.", RentSalesLineFrom."Attached to Rent Line No.") then;

        SalesLine.Init;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NewLineNo;
        SalesLine."Line Type" := RentSalesLineFrom.Type;
        SalesLine."Order Line Type No." := RentSalesLineFrom."No.";
        SalesLine."Document Profile" := SalesLine."document profile"::Rent;
        case RentSalesLineFrom.Type of
            RentSalesLineFrom.Type::"External Service":
                begin
                    SalesLine.Type := SalesLine.Type::"External Service";
                    SalesLine."No." := RentSalesLineFrom."No.";
                end;
            RentSalesLineFrom.Type::Item:
                begin
                    SalesLine.Type := SalesLine.Type::Item;
                    SalesLine."No." := RentSalesLineFrom."No.";
                end;
            RentSalesLineFrom.Type::"G/L Account":
                begin
                    SalesLine.Type := SalesLine.Type::"G/L Account";
                    SalesLine."No." := RentSalesLineFrom."No.";
                end;
            RentSalesLineFrom.Type::Resource:
                begin
                    SalesLine.Type := SalesLine.Type::Resource;
                    SalesLine."No." := RentSalesLineFrom."No.";
                end;
            RentSalesLineFrom.Type::"Fixed Asset":
                begin
                    SalesLine.Type := SalesLine.Type::"Fixed Asset";
                    SalesLine."No." := RentSalesLineFrom."No.";
                end;
            RentSalesLineFrom.Type::"Charge (Item)":
                begin
                    SalesLine.Type := SalesLine.Type::"Charge (Item)";
                    SalesLine."No." := RentSalesLineFrom."No.";
                end;
            RentSalesLineFrom.Type::" ":
                begin
                    SalesLine.Type := SalesLine.Type::" ";
                    SalesLine."No." := RentSalesLineFrom."No.";
                end;
        end;
        SalesLine."Line Discount %" := RentSalesLineFrom."Line Discount %";
        SalesLine.Validate("No.");
        SalesLine."Location Code" := RentSalesLineFrom."Location Code";
        SalesLine."Allow Line Disc." := true;
        SalesLine.Description := RentSalesLineFrom.Description;
        SalesLine."Shipment Date" := RentSalesLineFrom."Shipment Date";

        if RentSalesLineFrom.Type <> RentSalesLineFrom.Type::" " then begin
            case SalesHeader."Document Type" of
                SalesHeader."document type"::Invoice:
                    begin
                        SalesLine.Validate("Unit of Measure Code", RentSalesLineFrom."Unit of Measure Code");
                        SalesLine.Validate(Quantity, RentSalesLineFrom.Quantity);
                        SalesLine.Validate("Unit Price", RentSalesLineFrom."Unit Price");
                        SalesLine.Validate("Unit Cost (LCY)");
                        SalesLine.Validate("Line Discount %", RentSalesLineFrom."Line Discount %");
                    end;
                SalesHeader."document type"::"Credit Memo":
                    begin
                        SalesLine.Validate("Unit of Measure Code", RentSalesLineFrom."Unit of Measure Code");
                        SalesLine.Validate(Quantity, -RentSalesLineFrom.Quantity);
                        SalesLine.Validate("Unit Price", RentSalesLineFrom."Unit Price");
                        SalesLine.Validate("Unit Cost (LCY)");
                        SalesLine.Validate("Line Discount %", RentSalesLineFrom."Line Discount %");
                    end;
            end;
        end;
        SalesLine."Rent Order No." := RentSalesLineFrom."Document No.";
        SalesLine."Rent Order Line No." := RentLineAttachedTo."Line No.";
        SalesLine."Rent Order Sales Line No." := RentSalesLineFrom."Line No.";
        SalesLine."Rent Item No." := RentSalesLineFrom."Rent Item No.";
        SalesLine."Rent Asset No." := RentLineAttachedTo."Rent Asset No.";
        SalesLine."Rent Start Date" := RentSalesLineFrom."Start Date";
        SalesLine."Rent End Date" := RentSalesLineFrom."End Date";
        OnbeforeSetSalesLineDescription(RentSetup, SalesLine, RentSalesLineFrom, IsHandled);
        if not IsHandled then begin
            if RentSalesLineFrom.Type = RentSalesLineFrom.Type::Resource then
                if RentSetup."Sales Inv. Line Decr. Text 1" <> '' then
                    SetSalesLineDescription(RentSetup."Sales Inv. Line Decr. Text 1", SalesLine, RentSalesLineFrom);
        end;
        SalesLine."Shortcut Dimension 1 Code" := RentSalesLineFrom."Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := RentSalesLineFrom."Shortcut Dimension 2 Code";
        SalesLine."Dimension Set ID" := RentSalesLineFrom."Dimension Set ID";
        SalesLine.Insert(true);
        OnAfterInsertSalesLineFromRent(SalesLine, RentSalesLineFrom);
        if RentSalesLineFrom."Vehicle Serial No." <> '' then begin
            Vehicle.Get(RentSalesLineFrom."Vehicle Serial No.");
            SalesLine."Vehicle Serial No." := RentSalesLineFrom."Vehicle Serial No.";
            SalesLine."Make Code" := Vehicle."Make Code";
            SalesLine."Model Code" := Vehicle."Model Code";
            Vehicle.CalcFields("Default Vehicle Acc. Cycle No.");
            SalesLine."Vehicle Accounting Cycle No." := Vehicle."Default Vehicle Acc. Cycle No.";
            SalesLine.VIN := Vehicle.VIN;
        end;
        SalesLine.Modify;
    end;


    procedure PostSalesInvoices(var ServiceHeader: Record "Service Header EDMS" temporary)
    var
        SalesHeader: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
        SalesPostPrint: Codeunit "Sales-Post + Print";
    begin
        Commit;
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
                if not SalesPost.Run(SalesHeader2) then
                    Error(Text004, SalesHeader2.TableCaption, SalesHeader2."No.");
                SalesPostPrint.GetReport(SalesHeader2);

            until SalesHeader.Next = 0;
    end;


    procedure PostRentOrder(RentHeader: Record "Rent Header")
    var
        ServiceOrder: Record "Service Header EDMS";
        Vehicle: Record Vehicle;
        DocType: Option Quote,"Order","Return Order";
    begin
        /*
        //CreateServPrepaymentLines(ServiceHeader,TempPrepaymentServiceLine,PrepmtDocDim,TRUE);
        //Check if all lines are invoiced
        //Check Salse Lines
        UserSetup.GET(USERID);
        RentSalesLine.RESET;
        RentSalesLine.SETRANGE("Document Type",RentHeader."Document Type");
        RentSalesLine.SETRANGE("Document No.",RentHeader."No.");
        //RentSalesLine.SETRANGE(Invoiced,FALSE);
        IF RentSalesLine.FINDFIRST THEN
        //  IF UserSetup."Allow post Rent with Errors" THEN BEGIN
        //    IF NOT CONFIRM(Err001c,FALSE) THEN
        //      ERROR(Err001);
        //    END ELSE
        //    ERROR(Err001);
        
        {
        RentLine.RESET;
        RentLine.SETRANGE("Document Type",RentHeader."Document Type");
        RentLine.SETRANGE("Document No.",RentHeader."No.");
        IF RentLine.FINDFIRST THEN
          REPEAT
            IF RentLine."Quantity Invoiced" <> RentLine.Quantity THEN BEGIN
        //      IF UserSetup."Allow post Rent with Errors" THEN BEGIN
        //        IF NOT CONFIRM(Err002c,FALSE) THEN
        //          ERROR(Err002);
        //        END ELSE
                ERROR(Err002);
              END;
              IF RentLine."Motor Hours To" = 0 THEN
        //        IF UserSetup."Allow post Rent with Errors" THEN BEGIN
        //          IF NOT CONFIRM(Err003c,FALSE) THEN
        //            ERROR(Err003);
        //        END ELSE
                  ERROR(Err003);
          UNTIL RentLine.NEXT = 0;
        }
        
        WITH RentHeader DO BEGIN
          TESTFIELD("Document Type");
          TESTFIELD("Sell-to Customer No.");
          TESTFIELD("Bill-to Customer No.");
          TESTFIELD("Posting Date");
          TESTFIELD("Document Date");
        
          SourceCodeSetup.GET;
          SourceCode := SourceCodeSetup."Rent Management";
        
          CreateRentHeader(RentHeader);
          CreateRentLine(RentHeader);
          CreateRentSalesLine(RentHeader);
          DeleteRentOrder(RentHeader);
        
        END;
        */

    end;


    procedure CreateRentHeader(var RentOrder: Record "Rent Header")
    var
        PstReturnOrdHeader: Record "Posted Serv. Ret. Order Header";
        RentCommentLine: Record "Rent Comment Line";
        ServPlanMgt: Codeunit "Service Plan Management";
    begin
        /*WITH RentOrder DO BEGIN
         CASE "Document Type" OF
           "Document Type"::"Return Order":
            BEGIN
              PstOrdHeader.INIT;
              PstOrdHeader.TRANSFERFIELDS(RentOrder);
        
              IF ("Posting No." = '') THEN BEGIN
                TESTFIELD("Posting No. Series");
                "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series","Posting Date",TRUE);
              END;
        
              PstOrdHeader.TESTFIELD("No.");
              PstOrdHeader."No." := "Posting No.";
              PstOrdHeader."No. Series" := "Posting No. Series";
              PstOrdHeader."Order No." := "No.";
              PstOrdHeader."Order No. Series" := "No. Series";
              PstOrdHeader.INSERT;
            END;
        
           "Document Type"::Order:
            BEGIN
              PstOrdHeader.INIT;
              PstOrdHeader.TRANSFERFIELDS(RentOrder);
        
              IF ("Posting No." = '') THEN BEGIN
                TESTFIELD("Posting No. Series");
                "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series","Posting Date",TRUE);
              END;
        
              PstOrdHeader.TESTFIELD("No.");
              PstOrdHeader."No." := "Posting No.";
              PstOrdHeader."No. Series" := "Posting No. Series";
              PstOrdHeader."Order No." := "No.";
              PstOrdHeader."Order No. Series" := "No. Series";
              PstOrdHeader.INSERT;
        
            END
         END
        END
        */

    end;


    procedure CreateRentLine(RentHeader: Record "Rent Header")
    var
        RentLine: Record "Rent Line";
        RentJnlLine: Record "Rent Journal Line";
        RentJnlPostLine: Codeunit "Rent Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        PstReturnOrdLine: Record "Posted Serv. Return Order Line";
        RentLineCount: Integer;
    begin
        /*RentLine.RESET;
        RentLine.SETRANGE("Document Type",RentHeader."Document Type");
        RentLine.SETRANGE("Document No.",RentHeader."No.");
        IF NOT RentLine.FIND('-') THEN
          EXIT;
        
        REPEAT
         DialogLineCount := DialogLineCount + 1;
         Window.UPDATE(2,DialogLineCount);
        
         WITH RentHeader DO BEGIN
           RentJnlLine.INIT;
           RentJnlLine."Posting Date" := "Posting Date";
           RentJnlLine.Description := RentLine.Description;
           RentJnlLine."Rent Item No." := RentLine."Rent Item No.";
           RentJnlLine."Shortcut Dimension 1 Code" := RentLine."Shortcut Dimension 1 Code";
           RentJnlLine."Shortcut Dimension 2 Code" := RentLine."Shortcut Dimension 2 Code";
           RentJnlLine."Dimension Set ID" := RentLine."Dimension Set ID";
           RentJnlLine."Sell-to Customer No." := "Sell-to Customer No.";
           RentJnlLine."Bill-to Customer No." := "Bill-to Customer No.";
        
           CASE "Document Type" OF
            "Document Type"::"Return Order":
              BEGIN
              END;
            "Document Type"::Order:
              BEGIN
                RentJnlLine."Document No." := "Posting No.";
              END
           END;
        
           RentJnlLine."Source Code" := SourceCode;
           RentJnlPostLine.RunWithCheck(RentJnlLine);
        
           CASE "Document Type" OF
             "Document Type"::"Return Order":
              BEGIN
              END;
             "Document Type"::Order:
               BEGIN
                 PstOrdLine.INIT;
                 PstOrdLine.TRANSFERFIELDS(RentLine);
                 PstOrdLine."Document No." := "Posting No.";
                 PstOrdLine.INSERT;
               END
           END;
          END;
        UNTIL RentLine.NEXT = 0;
        */

    end;


    procedure CreateRentSalesLine(RentHeader: Record "Rent Header")
    var
        RentLine: Record "Rent Line";
        RentJnlLine: Record "Rent Journal Line";
        RentJnlPostLine: Codeunit "Rent Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        PstReturnOrdLine: Record "Posted Serv. Return Order Line";
        SalesLineCount: Integer;
    begin
        /*RentSalesLine.RESET;
        RentSalesLine.SETRANGE("Document Type",RentHeader."Document Type");
        RentSalesLine.SETRANGE("Document No.",RentHeader."No.");
        IF NOT RentSalesLine.FIND('-') THEN
          EXIT;
        
        REPEAT
         DialogLineCount := DialogLineCount + 1;
         Window.UPDATE(2,DialogLineCount);
        
         WITH RentHeader DO BEGIN
           RentJnlLine.INIT;
           RentJnlLine."Posting Date" := "Posting Date";
           RentJnlLine.Description := RentSalesLine.Description;
           RentJnlLine."Shortcut Dimension 1 Code" := RentSalesLine."Shortcut Dimension 1 Code";
           RentJnlLine."Shortcut Dimension 2 Code" := RentSalesLine."Shortcut Dimension 2 Code";
           RentJnlLine."Dimension Set ID" := RentSalesLine."Dimension Set ID";
           RentJnlLine.Type := RentSalesLine.Type;
           RentJnlLine."No." := RentSalesLine."No.";
           RentJnlLine."Salesperson Code" := "Salesperson Code";
           RentJnlLine."Sell-to Customer No." := "Sell-to Customer No.";
           RentJnlLine."Bill-to Customer No." := "Bill-to Customer No.";
        
           CASE "Document Type" OF
            "Document Type"::"Return Order":
              BEGIN
              END;
            "Document Type"::Order:
              BEGIN
                RentJnlLine."Document No." := "Posting No.";
              END
           END;
        
           RentJnlLine."Source Code" := SourceCode;
           RentJnlPostLine.RunWithCheck(RentJnlLine);
        
           CASE "Document Type" OF
             "Document Type"::"Return Order":
              BEGIN
              END;
             "Document Type"::Order:
               BEGIN
                 PstOrdSalesLine.INIT;
                 PstOrdSalesLine.TRANSFERFIELDS(RentSalesLine);
                 PstOrdSalesLine."Document No." := "Posting No.";
                 PstOrdSalesLine.INSERT;
               END
           END;
          END;
        UNTIL RentSalesLine.NEXT = 0;
        */

    end;


    procedure DeleteRentOrder(RentOrder: Record "Rent Header")
    var
        RentLine1: Record "Rent Line";
        RentSalesLine1: Record "Rent Sales Line";
    begin

        if RentOrder.HasLinks then RentOrder.DeleteLinks;

        //Lines
        RentLine1.SetRange("Document Type", RentLine1."document type"::Order);
        RentLine1.SetRange("Document No.", RentOrder."No.");
        if RentLine1.FindFirst then
            repeat
                if RentLine1.HasLinks then
                    RentLine1.DeleteLinks;
            until RentLine1.Next = 0;
        RentLine1.DeleteAll;

        //Sales Lines
        RentSalesLine1.SetRange("Document Type", RentSalesLine1."document type"::Order);
        RentSalesLine1.SetRange("Document No.", RentOrder."No.");
        if RentSalesLine1.FindFirst then
            repeat
                if RentSalesLine1.HasLinks then
                    RentSalesLine1.DeleteLinks;
            until RentSalesLine1.Next = 0;

        RentSalesLine1.DeleteAll;

        //Header
        RentOrder.Delete;
    end;


    procedure CopyServCommLinesToSale(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        ServCommentLine: Record "Service Comment Line EDMS";
        SalesCommentLine: Record "Sales Comment Line";
    begin
        ServCommentLine.SetRange(Type, FromDocumentType);
        ServCommentLine.SetRange("No.", FromNumber);
        if ServCommentLine.Find('-') then
            repeat
                SalesCommentLine.Init;
                SalesCommentLine."Document Type" := ToDocumentType;
                SalesCommentLine."No." := ToNumber;
                SalesCommentLine."Line No." := ServCommentLine."Line No.";
                SalesCommentLine.Date := ServCommentLine.Date;
                SalesCommentLine.Comment := ServCommentLine.Comment;
                //SalesCommentLine."User ID" := ServCommentLine."User ID";
                //SalesCommentLine."Comment Type" := ServCommentLine."Comment Type";
                //SalesCommentLine.Cause := ServCommentLine.Cause;
                //SalesCommentLine.Repair := ServCommentLine.Repair;
                //SalesCommentLine."Final Remarks" := ServCommentLine."Final Remarks";
                //SalesCommentLine."Resource No." := ServCommentLine."Resource No.";
                SalesCommentLine.Insert;
            until ServCommentLine.Next = 0;
    end;

    local procedure GetNextServiceLine(var ServiceLine: Record "Service Line EDMS"): Boolean
    begin
        if ServiceLine.Next = 1 then
            exit(false);
        if TempPrepaymentServiceLine.Find('-') then begin
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


    procedure SetPrintInvoice(pPrintInvoice: Boolean)
    begin
        PrintInvoice := pPrintInvoice;
    end;

    procedure SetSalesLineDescription(DescriptionTemplate: Text; var SalesLineTo: Record "Sales Line"; RentSalesLineFrom: Record "Rent Sales Line")
    var
        RentLineFrom: Record "Rent Line";
        RentHeader: Record "Rent Header";
        RentAsset: Record "Rent Asset";
        RentPeriod: Record "Rent Period";
        Contract: Record Contract;
        Vehicle: Record Vehicle;
    begin
        if RentSalesLineFrom."Attached to Rent Line No." = 0 then
            exit;
        if RentSalesLineFrom."Extra Charge Line" = true then
            exit;

        Clear(RentAsset);
        Clear(Contract);
        Clear(Vehicle);

        RentHeader.Get(RentSalesLineFrom."Document Type", RentSalesLineFrom."Document No.");
        RentLineFrom.Get(RentSalesLineFrom."Document Type", RentSalesLineFrom."Document No.", RentSalesLineFrom."Attached to Rent Line No.");
        if RentAsset.Get(RentLineFrom."Rent Asset No.") then;
        RentPeriod.Get(RentLineFrom."Rent Period Type");
        if Contract.Get(RentHeader."Contract No.") then;
        if Vehicle.Get(RentAsset."Vehicle Serial No.") then;

        SalesLineTo.Description := DelStr(StrSubstNo(DescriptionTemplate
                                  , RentAsset."No.", RentAsset.Description, RentAsset."Make Code", RentAsset."Serial No.", RentAsset."Model Code", RentAsset."Model Commercial Name"
                                  , RentPeriod.Code, RentPeriod.Description
                                  , Format(RentLineFrom."Rent Start Date"), Format(RentLineFrom."Rent End Date")
                                  , RentSalesLineFrom."No.", RentSalesLineFrom.Description, Format(RentSalesLineFrom."Start Date"), Format(RentSalesLineFrom."End Date")
                                  , Format(RentSalesLineFrom."Unit Price"), Format(RentSalesLineFrom."Line Amount")
                                  , Format(RentSalesLineFrom."VF Run 1 From"), Format(RentSalesLineFrom."VF Run 1 To")
                                  , Format(RentSalesLineFrom."VF Run 2 From"), Format(RentSalesLineFrom."VF Run 2 To")
                                  , Format(RentSalesLineFrom."VF Run 3 From"), Format(RentSalesLineFrom."VF Run 3 To")
                                  , RentSalesLineFrom."Document No.", RentHeader."Contract No.", Contract."External Contract No.", Vehicle."Registration No."
                                  ), 101);
    end;

    procedure CreateDescriptionSalesLine(var DescriptionTemplate: Text; SalesHeader: Record "Sales Header"; RentSalesLineFrom: Record "Rent Sales Line"; var NewLineNo: Integer)
    var
        SalesLine: Record "Sales Line";
    begin
        RentSetup.Get;
        NewLineNo += 100;
        if RentSalesLineFrom."Attached to Rent Line No." = 0 then
            exit;
        if RentSalesLineFrom."Extra Charge Line" = true then
            exit;
        SalesLine.Init;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NewLineNo;
        SalesLine."Line Type" := SalesLine."line type"::Comment;
        SalesLine."Document Profile" := SalesLine."document profile"::Rent;
        SalesLine."Rent Order No." := RentSalesLine."Document No.";
        SalesLine."Rent Order Sales Line No." := RentSalesLine."Line No.";
        SetSalesLineDescription(DescriptionTemplate, SalesLine, RentSalesLineFrom);

        SalesLine.Insert(true);
    end;

    procedure CreateCancelingDescriptionLine(SalesHeader: Record "Sales Header"; var RentSalesLineFrom: Record "Rent Sales Line"; NewLineNo: Integer)
    var
        SalesLine: Record "Sales Line";
        CanceledRentSalesLine: Record "Rent Sales Line";
        CanceledDocumentType: Option " ",Invoice,"Credit Memo","Posted Invoice","Posted Credit Memo";
        CanceledDocumentNo: Code[20];
        DocumentTypeTxt: Text;
    begin
        RentSetup.Get;
        CanceledRentSalesLine.Get(RentSalesLineFrom."Document Type", RentSalesLineFrom."Document No.", RentSalesLineFrom."Cancels Line No.");
        SalesLine.Init;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NewLineNo - 1;
        ;
        SalesLine."Line Type" := SalesLine."line type"::Comment;
        SalesLine."Document Profile" := SalesLine."document profile"::Rent;
        SalesLine."Rent Order No." := RentSalesLineFrom."Document No.";
        SalesLine."Rent Order Sales Line No." := RentSalesLineFrom."Line No.";
        CanceledDocumentType := CanceledRentSalesLine.GetSalesDocumentType;
        case CanceledDocumentType of
            Canceleddocumenttype::Invoice:
                DocumentTypeTxt := InvoiceTxt;
            Canceleddocumenttype::"Credit Memo":
                DocumentTypeTxt := CrMemoTxt;
            Canceleddocumenttype::"Posted Invoice":
                DocumentTypeTxt := PostedInvoiceTxt;
            Canceleddocumenttype::"Posted Credit Memo":
                DocumentTypeTxt := PostedCreditMemoTxt;
        end;
        SalesLine.Description := StrSubstNo(CancelDocDescriptTxt, DocumentTypeTxt, CanceledRentSalesLine.GetSalesDocumentNo);
        SalesLine.Insert(true);
    end;


    procedure ModifyProcessChecklist(RentHeader: Record "Rent Header"; NewSourceType: Integer; NewSourceID: Code[20])
    var
        ProcessChecklistHdr: Record "Process Checklist Header";
    begin
        ProcessChecklistHdr.Reset;
        ProcessChecklistHdr.SetCurrentkey("Source Type", "Source Subtype", "Source ID");
        ProcessChecklistHdr.SetRange("Source Type", Database::"Rent Header");
        ProcessChecklistHdr.SetRange("Source Subtype", RentHeader."Document Type");
        ProcessChecklistHdr.SetRange("Source ID", RentHeader."No.");
        if ProcessChecklistHdr.FindFirst then
            repeat
                ProcessChecklistHdr."Source Type" := NewSourceType;
                ProcessChecklistHdr."Source Subtype" := 0;
                ProcessChecklistHdr."Source ID" := NewSourceID;
                ProcessChecklistHdr.Modify;
            until ProcessChecklistHdr.Next = 0;
    end;

    procedure GroupRentOrderMerchants(var RentWrkshtLine: Record "Rent Billing Worksheet Line"; var RentWrkshtLineCombined: Record "Rent Billing Worksheet Line" temporary)
    var
        EntryNo: Integer;
    begin
        RentWrkshtLineCombined.DeleteAll();
        RentWrkshtLine.SetRange("Process Line", true);
        RentWrkshtLine.SetRange("To Invoice", true);
        if RentWrkshtLine.FindFirst() then begin
            RentWrkshtLineCombined.Reset();
            if RentWrkshtLineCombined.FindLast() then
                EntryNo := RentWrkshtLineCombined."Entry No." + 1
            else
                EntryNo := 1;
            repeat
                RentWrkshtLineCombined.Reset();
                RentWrkshtLineCombined.SetRange("Sell-to Customer No.", RentWrkshtLine."Sell-to Customer No.");
                RentWrkshtLineCombined.SetRange("Bill-to Customer No.", RentWrkshtLine."Bill-to Customer No.");
                if not RentWrkshtLineCombined.FindFirst() then begin
                    RentWrkshtLineCombined.Init();
                    RentWrkshtLineCombined."Entry No." := EntryNo;
                    RentWrkshtLineCombined."Sell-to Customer No." := RentWrkshtLine."Sell-to Customer No.";
                    RentWrkshtLineCombined."Bill-to Customer No." := RentWrkshtLine."Bill-to Customer No.";
                    RentWrkshtLineCombined.Insert();
                end;
                EntryNo += 1;
            until RentWrkshtLine.Next() = 0;
        end;
    end;

    procedure GroupRentOrders(var RentWrkshtLine: Record "Rent Billing Worksheet Line"; var RentOrdersCombined: Record "Rent Billing Worksheet Line" temporary)
    var
        EntryNo: Integer;
    begin
        RentOrdersCombined.Reset();
        if RentOrdersCombined.FindLast() then
            EntryNo := RentOrdersCombined."Entry No." + 1
        else
            EntryNo := 1;

        RentOrdersCombined.Reset();
        RentOrdersCombined.SetRange("Document Type", RentWrkshtLine."Document Type");
        RentOrdersCombined.SetRange("Document No.", RentWrkshtLine."Document No.");
        if not RentOrdersCombined.FindFirst() then begin
            RentOrdersCombined.Init();
            RentOrdersCombined."Entry No." := EntryNo;
            RentOrdersCombined."Document Type" := RentWrkshtLine."Document Type";
            RentOrdersCombined."Document No." := RentWrkshtLine."Document No.";
            RentOrdersCombined.Insert();
        end;
    end;

    procedure AutoPostRentInvoices(InvoiceNoFirst: COde[20]; InvoiceNoLast: Code[20])
    var
        RentSetup: Record "Rent Mgt. Setup";
        SalesHeader: Record "Sales Header";
        NothingToPosteMessage: Label 'There were no invoices created';
    begin
        RentSetup.Get();
        //CalcWorksheetLine.DeleteAll;
        //CalcWorksheetLine.SetInvCreated(CreatedInvoiceCount);
        //Window.Close;
        //Commit;
        Commit;
        If (InvoiceNoFirst = '') and (InvoiceNoLast = '') then begin
            Message(NothingToPosteMessage);
            exit;
        end;
        SalesHeader.Reset;
        //DELTA XX
        //SalesHeader.SetRange("Document Type", SalesHeader."document type"::Invoice);
        SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."document type"::Invoice, SalesHeader."document type"::"Credit Memo");
        SalesHeader.SetFilter("No.", '%1..%2', InvoiceNoFirst, InvoiceNoLast);
        SalesHeader.Find('-');
        repeat
            if Codeunit.Run(Codeunit::"Release Sales Document", SalesHeader) then;
            Commit;
            if RentSetup."Auto Post Rent Invoices" then begin
                if Codeunit.Run(Codeunit::"Sales-Post", SalesHeader) then;
            end;
        until SalesHeader.Next = 0;

        //GetProcessInfo(CreatedInvoiceCount, SalesHeader);
        //if Confirm(NewInvoiceMsg, true, CreatedInvoiceCount) then
        //    Page.Run(Page::"Sales Invoice List", SalesHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateDescriptionSalesLine(SalesHeader: Record "Sales Header"; Var RentSalesLine: Record "Rent Sales Line"; RentHeader: Record "Rent Header"; var IsHandled: Boolean; var NewLineNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnbeforeSetSalesLineDescription(RentSetup: Record "Rent Mgt. Setup"; var SalesLine: Record "Sales Line"; RentSalesLineFrom: Record "Rent Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetCustomerNoOnRentalInvoice(var SalesHeader: Record "Sales Header"; RentHeader: Record "Rent Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateInvoiceCheckValues(RentSalesLine: Record "Rent Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertSalesLineFromRent(var SalesLine: Record "Sales Line"; var RentSalesLineFrom: Record "Rent Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateInvoiceHeaderByRentOrders(var SalesHeader: Record "Sales Header"; DocumentDate: Date)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateInvoiceHeader(var SalesHeader: Record "Sales Header"; DocumentDate: Date)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateRentInvoiceHeader(var SalesHeader: Record "Sales Header"; var RentHeader: Record "Rent Header")
    begin

    end;



}

