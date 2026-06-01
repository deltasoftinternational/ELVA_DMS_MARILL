Report 25006113 "BLS Create Invoices Lease"
{
    Caption = 'Create Billing Invoices for Lease';

    ProcessingOnly = true;

    dataset
    {
        dataitem(CalcWorksheetLine; "BLS Calculation Worksheet Line")
        {
            column(ReportForNavId_50000; 50000)
            {
            }

            trigger OnAfterGetRecord()
            var
                LeaseLineType: Option Interest,Base,Total;
            begin

                Service.Get("Service Code");
                CreateInvoice;

                if CalcWorksheetLine."Lease Base Amount" <> 0 then
                    CreateInvoiceLine(LeaseLineType::Base);
                if CalcWorksheetLine."Lease Interest Amount" <> 0 then
                    CreateInvoiceLine(LeaseLineType::Interest);
                CreateInvoiceLinesAddService("Leasing Schedule No.", "Leasing Schedule Line No.");

                CalcLedgEntry.Init;
                CalcLedgEntry.TransferFields(CalcWorksheetLine);
                CalcLedgEntry."Invoice Ledger Entry No." := CalcWorksheetLine."Entry No.";
                CalcLedgEntry.Insert;


                CP += 1;
                Window.Update(1, ROUND(CP / RC * 10000, 1, '<'));
            end;

            trigger OnPreDataItem()
            begin
                CP := 0;
                RC := Count;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Parameters)
                {
                    Caption = 'Parameters';
                    field(InvoiceDate; InvoiceDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoice Date';
                    }
                    field(DueDate; DueDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Due Date';
                    }
                    field(NoSerieCode; NoSerieCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoice No. Serie Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            SalesSetup.Get;
                            SalesSetup.TestField("Invoice Nos.");
                            SalesSetup.TestField("Posted Invoice Nos.");
                            if NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Invoice Nos.", NoSerieCode, NoSerieCode) then;
                        end;
                    }
                    field(CurrentPeriodFromDate; CurrentPeriodFromDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Current Income Period From';
                        Visible = false;
                    }
                    field(CurrentPeriodToDate; CurrentPeriodToDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Current Income Period To';
                        Visible = false;
                    }
                    field(HistoryOnly; HistoryOnly)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Without Invoicing';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            HistoryOnly := false;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        BLSSetup.Get();
        CalcWorksheetLine.DeleteAll;
        CalcWorksheetLine.SetInvCreated(CreatedInvoiceCount);
        Window.Close;
        Commit;

        SalesHeader.Reset;
        SalesHeader.SetRange("Document Type", SalesHeader."document type"::Invoice);
        SalesHeader.SetFilter("No.", '%1..%2', InvoiceNoFirst, InvoiceNoLast);
        SalesHeader.Find('-');
        repeat
            if Codeunit.Run(Codeunit::"Release Sales Document", SalesHeader) then;
            Commit;
            if BLSSetup."Auto Post Lease Invoices" then begin
                if Codeunit.Run(Codeunit::"Sales-Post", SalesHeader) then;
            end;
        until SalesHeader.Next = 0;

        GetProcessInfo(CreatedInvoiceCount, SalesHeader);
        //if Confirm(NewInvoiceMsg, true, CreatedInvoiceCount) then
        //    Page.Run(Page::"Sales Invoice List", SalesHeader);
    end;

    trigger OnPreReport()
    begin
        if not HistoryOnly then begin
            if (InvoiceDate = 0D) then
                Error(DateEmptyErr);
            if (NoSerieCode = '') then
                Error(NoSerieEmptyErr);

            if (DueDate <> 0D) and (DueDate < InvoiceDate) then
                Error(DueDateBeforeInvDateErr, InvoiceDate, DueDate);
        end;

        if InvoiceLedgEntry.FindLast() then;
        InvLedgEntryNo := InvoiceLedgEntry."Entry No.";

        CreatedInvoiceCount := 0;
        InvoiceNoFirst := '';
        InvoiceNoLast := '';
        Window.Open(WindowTxt);

        CompanyInfo.Get;
        SalesSetup.Get;
        SalesSetup.TestField("Invoice Nos.");
        BLSSetup.Get;

        NextEntryNo := GetLastInvoiceEntryNo;
    end;

    var
        BLSSetup: Record "BLS Setup";
        BLSObject: Record "BLS Object";
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        GeneralPostingSetup: Record "General Posting Setup";
        ContractDMS: Record Contract;
        Resource: Record Resource;
        SalesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Service: Record "BLS Service";
        ServiceGroup: Record "Payment Terms";
        CalcLedgEntry: Record "BLS Calculation Ledger Entry";
        InvoiceLedgEntry: Record "BLS Invoicing Ledger Entry";
        Vehicle: Record Vehicle;
        NoSeriesMgt: Codeunit "No. Series";
        DateEmptyErr: label 'Invoice date is empty.';
        NoSerieEmptyErr: label 'No. serie is empty.';
        DueDateBeforeInvDateErr: label 'Invoice date %1 is after Due Date %2';
        NothingCreatedTxt: label 'None invoice created.';
        NewInvoiceMsg: label 'Created %1 invoice(-s). Do You want open invoice list?';
        WindowTxt: label 'Worksheet processing  @1@@@@@@@@@@@@@@\Creating Invoices     @2@@@@@@@@@@@@@@';
        EPSMgt: Codeunit "BLS Management";
        Window: Dialog;
        ObjectAddress: Text;
        NoSerieCode: Code[10];
        PrevCustNo: Code[20];
        PrevCurrCode: Code[10];
        PrevContractNo: Code[20];
        PrevServiceGroupCode: Code[20];
        PrevVehicleNo: Code[20];
        InvoiceNoFirst: Code[20];
        InvoiceNoLast: Code[20];
        InvoiceDate: Date;
        DueDate: Date;
        CurrentPeriodFromDate: Date;
        CurrentPeriodToDate: Date;
        InvoiceFromDate: Date;
        InvoiceToDate: Date;
        CreatedInvoiceCount: Integer;
        NextEntryNo: Integer;
        NextLineNo: Integer;
        CP: Integer;
        RC: Integer;
        PrevContractSource: Integer;
        InENG: Boolean;
        PrevPriceInclVAT: Boolean;
        HistoryOnly: Boolean;
        SeparateInvoicePerVehicle: Boolean;
        InvLedgEntryNo: integer;


    procedure CreateInvoice()
    var
        NewInvoice: Boolean;
    begin

        Clear(SalesHeader);
        Clear(NoSeriesMgt);
        SalesHeader.SetHideValidationDialog(true);

        SalesHeader.Init;
        SalesHeader.Validate("Document Type", SalesHeader."document type"::Invoice);
        SalesHeader.Validate("Posting Date", InvoiceDate);
        SalesHeader.Validate("No. Series", NoSerieCode);
        SalesHeader."No." := NoSeriesMgt.GetNextNo(NoSerieCode, InvoiceDate, true);
        SalesHeader.Insert(true);

        SalesHeader.Modify(true);
        CreatedInvoiceCount += 1;

        if InvoiceNoFirst = '' then
            InvoiceNoFirst := SalesHeader."No.";
        InvoiceNoLast := SalesHeader."No.";

        SalesHeader.Validate("Document Date", InvoiceDate);
        Customer.Get(CalcWorksheetLine."Customer No.");
        // InENG := NOT (CompanyInfo."Country/Region Code" = Customer."Country/Region Code";)
        // InENG := NOT (Customer."Language Code" IN ['', HSSetup."Language Code"]);
        InENG := false;

        SalesHeader.Validate("Sell-to Customer No.", CalcWorksheetLine."Customer No.");
        SalesHeader.Validate("Bill-to Customer No.", CalcWorksheetLine."Customer No.");
        SalesHeader.Validate("Currency Code", CalcWorksheetLine."Currency Code");
        SalesHeader.Validate("BLS Contract No.", CalcWorksheetLine."Contract No.");
        if ContractDMS.Get(CalcWorksheetLine."Contract No.") then
            SalesHeader.Validate("Deal Type Code", ContractDMS."Deal Type For Invoices");
        //SalesHeader.Validate("Prices Including VAT", CalcWorksheetLine."Price Including VAT");
        SalesHeader.Validate("Posting Date", InvoiceDate);
        SalesHeader.Validate("Document Date", InvoiceDate);
        SalesHeader.Validate("Payment Terms Code");

        //if (TempCalcBuffer."Vehicle Serial No." <> '') and SeparateInvoicePerVehicle then begin
        Vehicle.Get(CalcWorksheetLine."Vehicle Serial No.");
        SalesHeader."Make Code" := Vehicle."Make Code";
        SalesHeader."Model Code" := Vehicle."Model Code";
        SalesHeader."Vehicle Serial No." := Vehicle."Serial No.";
        //end;

        //if (CalcWorksheetLine."Contract No." <> '') then begin
        //if ContractDMS.Get(ContractDMS."contract type"::Contract, TempCalcBuffer."Contract No.") then
        //  SalesHeader."External Document No." := ContractDMS."External Doc. No. For Invoices";
        //end;

        if DueDate <> 0D then
            SalesHeader.Validate("Due Date", DueDate);
        // SalesHeader."Automatic Processing" := TRUE;
        SalesHeader."Document Profile" := SalesHeader."Document Profile"::" ";
        SalesHeader.Modify(true);

        PrevServiceGroupCode := '';
        InvoiceFromDate := 0D;
        InvoiceToDate := 0D;
        NextLineNo := 10000;
    end;


    procedure CreateInvoiceLine(LeaseLineType: Option Interest,Base,Total)
    var
        BLSLeaseScheduleheader: Record "BLS Leasing Schedule Header";
    begin
        BLSLeaseScheduleheader.Get(CalcWorksheetLine."Leasing Schedule No.");
        if (LeaseLineType = LeaseLineType::Interest) and (BLSLeaseScheduleheader."Leasing Interest Service Code" <> '') then
            Service.Get(BLSLeaseScheduleheader."Leasing Interest Service Code")
        else
            Service.Get(CalcWorksheetLine."Service Code");

        SalesLine.Init;
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine."Line No." := NextLineNo;
        SalesLine."BLS Invoicing Entry No." := CalcWorksheetLine."Entry No.";
        SalesLine."Leasing Schedule No." := CalcWorksheetLine."Leasing Schedule No.";
        SalesLine."Leasing Schedule Line No." := CalcWorksheetLine."Leasing Schedule Line No.";
        NextLineNo += 1000;

        SalesLine.Insert(true);
        case Service."Posting Type" of
            Service."posting type"::"G/L Account":
                SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
            Service."posting type"::Resource:
                SalesLine.Validate(Type, SalesLine.Type::Resource);
        end;
        SalesLine.Validate("No.", Service."Posting No.");

        case Service."Posting Type" of
            Service."posting type"::"G/L Account":
                SalesLine.Validate("Unit of Measure Code", Service."Base Unit of Measure Code");
            Service."posting type"::Resource:
                begin
                    Resource.Get(Service."Posting No.");
                    SalesLine.Validate("Unit of Measure Code", Resource."Base Unit of Measure");
                end;
        end;

        if Service."Gen. Prod. Posting Group" <> '' then
            SalesLine.Validate("Gen. Prod. Posting Group", Service."Gen. Prod. Posting Group");

        if Service."VAT Prod. Posting Group" <> '' then
            SalesLine.Validate("VAT Prod. Posting Group", Service."VAT Prod. Posting Group");


        SalesLine.Validate(Quantity, CalcWorksheetLine.Quantity);


        //SalesLine.Validate("Line Discount Amount", CalcWorksheetLine."Discount Amount");
        SalesLine."Customer Price Group" := CalcWorksheetLine."Customer Price Group";
        SalesLine."Customer Disc. Group" := CalcWorksheetLine."Customer Discount Group";

        ObjectAddress := '';
        SalesLine.Validate("BLS Service Code", CalcWorksheetLine."Service Code");
        if CalcWorksheetLine."Object Code" <> '' then begin
            BLSObject.Get(CalcWorksheetLine."Object Code");
            ObjectAddress := BLSObject.Name;
            SalesLine.Validate("BLS Object Code", CalcWorksheetLine."Object Code");
        end;

        Clear(Vehicle);
        if CalcWorksheetLine."Vehicle Serial No." <> '' then begin
            Vehicle.Get(CalcWorksheetLine."Vehicle Serial No.");
            //SalesLine."Make Code" := Vehicle."Make Code";
            //SalesLine."Model Code" := Vehicle."Model Code";
            //SalesLine."Vehicle Serial No." := Vehicle."Serial No.";
            //SalesLine."Vehicle Prod. Serial No." := Vehicle."Prod. Serial No.";
            SalesLine.Validate("Make Code", Vehicle."Make Code");
            SalesLine.Validate("Model Code", Vehicle."Model Code");
            SalesLine.Validate("Vehicle Serial No.", Vehicle."Serial No.");
            SalesLine.VIN := Vehicle.VIN;
        end;

        SalesLine."Leasing Schedule No." := CalcWorksheetLine."Leasing Schedule No.";
        SalesLine."Leasing Schedule Line No." := CalcWorksheetLine."Leasing Schedule Line No.";
        SalesLine."BLS Invoicing Entry No." := CalcWorksheetLine."Entry No.";
        if LeaseLineType = LeaseLineType::Interest then
            SalesLine.Validate("Unit Price", CalcWorksheetLine."Lease Interest Amount");
        if LeaseLineType = LeaseLineType::Base then
            SalesLine.Validate("Unit Price", CalcWorksheetLine."Lease Base Amount");
        SalesLine.Modify(true);

        InvLedgEntryNo += 1;
        InvoiceLedgEntry.Init;
        InvoiceLedgEntry.TransferFields(CalcWorksheetLine);
        InvoiceLedgEntry."Entry No." := InvLedgEntryNo;
        InvoiceLedgEntry.Validate("Customer No.");
        InvoiceLedgEntry.Validate("Service Code");
        InvoiceLedgEntry.Validate("Object Code");
        if LeaseLineType = LeaseLineType::Base then
            InvoiceLedgEntry."Base Unit Price" := CalcWorksheetLine."Lease Base Amount"
        else
            if LeaseLineType = LeaseLineType::Interest then
                InvoiceLedgEntry."Base Unit Price" := CalcWorksheetLine."Lease Interest Amount";
        InvoiceLedgEntry.Insert;


    end;

    procedure CreateInvoiceLinesAddService(LeasingScheduleNo: Code[20]; LeasingScheduleLineNo: Integer)
    var
        BLSLeaseScheduleheader: Record "BLS Leasing Schedule Header";
        BLSLeaseSchedulServLine: Record "BLS Leasing Sched. Serv. Line";
        BLSLeaseScheduleLine: Record "BLS Leasing Schedule Line";
    begin
        BLSLeaseScheduleheader.Get(CalcWorksheetLine."Leasing Schedule No.");
        BLSLeaseSchedulServLine.Reset();
        BLSLeaseSchedulServLine.SetRange("Leasing Schedule No.", LeasingScheduleNo);
        if BLSLeaseScheduleLine.get(LeasingScheduleNo, LeasingScheduleLineNo) then begin
            BLSLeaseSchedulServLine.SetFilter("Starting Date", '..%1|%2', BLSLeaseScheduleLine."Payment Date", 0D);
            BLSLeaseSchedulServLine.SetFilter("Ending Date", '%1..|%2', BLSLeaseScheduleLine."Payment Date", 0D);
        end;

        IF BLSLeaseSchedulServLine.FindSet() then
            repeat
                SalesLine.Init;
                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine."Line No." := NextLineNo;
                SalesLine."BLS Invoicing Entry No." := CalcWorksheetLine."Entry No.";
                SalesLine."Leasing Schedule No." := CalcWorksheetLine."Leasing Schedule No.";
                SalesLine."Leasing Schedule Line No." := CalcWorksheetLine."Leasing Schedule Line No.";
                NextLineNo += 1000;
                Service.get(BLSLeaseSchedulServLine."Service Code");
                SalesLine.Insert(true);
                case Service."Posting Type" of
                    Service."posting type"::"G/L Account":
                        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                    Service."posting type"::Resource:
                        SalesLine.Validate(Type, SalesLine.Type::Resource);
                end;
                SalesLine.Validate("No.", Service."Posting No.");

                case Service."Posting Type" of
                    Service."posting type"::"G/L Account":
                        SalesLine.Validate("Unit of Measure Code", Service."Base Unit of Measure Code");
                    Service."posting type"::Resource:
                        begin
                            Resource.Get(Service."Posting No.");
                            SalesLine.Validate("Unit of Measure Code", Resource."Base Unit of Measure");
                        end;
                end;

                if Service."Gen. Prod. Posting Group" <> '' then
                    SalesLine.Validate("Gen. Prod. Posting Group", Service."Gen. Prod. Posting Group");

                if Service."VAT Prod. Posting Group" <> '' then
                    SalesLine.Validate("VAT Prod. Posting Group", Service."VAT Prod. Posting Group");


                SalesLine.Validate(Quantity, CalcWorksheetLine.Quantity);


                //SalesLine.Validate("Line Discount Amount", CalcWorksheetLine."Discount Amount");
                SalesLine."Customer Price Group" := CalcWorksheetLine."Customer Price Group";
                SalesLine."Customer Disc. Group" := CalcWorksheetLine."Customer Discount Group";

                ObjectAddress := '';
                SalesLine.Validate("BLS Service Code", Service."Code");
                if CalcWorksheetLine."Object Code" <> '' then begin
                    BLSObject.Get(CalcWorksheetLine."Object Code");
                    ObjectAddress := BLSObject.Name;
                    SalesLine.Validate("BLS Object Code", CalcWorksheetLine."Object Code");
                end;

                Clear(Vehicle);
                if CalcWorksheetLine."Vehicle Serial No." <> '' then begin
                    Vehicle.Get(CalcWorksheetLine."Vehicle Serial No.");
                    //SalesLine."Make Code" := Vehicle."Make Code";
                    //SalesLine."Model Code" := Vehicle."Model Code";
                    //SalesLine."Vehicle Serial No." := Vehicle."Serial No.";
                    //SalesLine."Vehicle Prod. Serial No." := Vehicle."Prod. Serial No.";
                    SalesLine.Validate("Make Code", Vehicle."Make Code");
                    SalesLine.Validate("Model Code", Vehicle."Model Code");
                    SalesLine.Validate("Vehicle Serial No.", Vehicle."Serial No.");
                    SalesLine.VIN := Vehicle.VIN;
                end;

                SalesLine."Leasing Schedule No." := CalcWorksheetLine."Leasing Schedule No.";
                SalesLine."Leasing Schedule Line No." := CalcWorksheetLine."Leasing Schedule Line No.";
                SalesLine."BLS Invoicing Entry No." := CalcWorksheetLine."Entry No.";
                SalesLine.Validate("Unit Price", BLSLeaseSchedulServLine.Price);

                SalesLine.Modify(true);

                InvLedgEntryNo += 1;
                InvoiceLedgEntry.Init;
                InvoiceLedgEntry.TransferFields(CalcWorksheetLine);
                InvoiceLedgEntry."Entry No." := InvLedgEntryNo;
                InvoiceLedgEntry.Validate("Customer No.");
                InvoiceLedgEntry.Validate("Service Code");
                InvoiceLedgEntry.Validate("Object Code");
                InvoiceLedgEntry."Base Unit Price" := CalcWorksheetLine."Lease Base Amount";
                InvoiceLedgEntry.Insert;

            until BLSLeaseSchedulServLine.Next = 0;
    end;

    local procedure CreateInvoiceLineDescription()
    begin

        Service.Get(CalcWorksheetLine."Service Code");

        SalesLine.Init;
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine."Line No." := NextLineNo;
        SalesLine."BLS Invoicing Entry No." := CalcWorksheetLine."Entry No.";
        NextLineNo += 1000;

        SalesLine.Insert(true);

        SalesLine.Description := CopyStr(StrSubstNo(Service."Invoice Line Description",
                                                    CalcWorksheetLine."Service Code", CalcWorksheetLine."Service Variant Code",
                                                    BLSObject."Object Type", CalcWorksheetLine."Object Code",
                                                    CalcWorksheetLine."Starting Date", CalcWorksheetLine."Ending Date",
                                                    CalcWorksheetLine."Period Starting Date", CalcWorksheetLine."Period Ending Date",
                                                    CalcWorksheetLine."Unit Price", CalcWorksheetLine."Total Price",
                                                    CalcWorksheetLine."Discount, %", CalcWorksheetLine."Discount Amount",
                                                    CalcWorksheetLine."Total Price Incl. Discount",
                                                    CalcWorksheetLine."Service Date",
                                                    CalcWorksheetLine."Vehicle Serial No.", Vehicle.VIN, Vehicle."Make Code",
                                                    Vehicle."Model Code", Vehicle."Model Commercial Name"),
                                         1, MaxStrLen(SalesLine.Description));

        SalesLine."BLS Invoicing Entry No." := CalcWorksheetLine."Entry No.";
        SalesLine.Modify(true);

        if ObjectAddress <> '' then begin
            SalesLine.Init;
            SalesLine.Validate("Document Type", SalesHeader."Document Type");
            SalesLine.Validate("Document No.", SalesHeader."No.");
            SalesLine."Line No." := NextLineNo;
            SalesLine."BLS Invoicing Entry No." := CalcWorksheetLine."Entry No.";
            NextLineNo += 1000;
            SalesLine.Description := ObjectAddress;
            SalesLine."BLS Invoicing Entry No." := 0;
            SalesLine.Modify;
        end;

        if Service."Invoice Line Addit.Description" <> '' then begin
            SalesLine.Init;
            SalesLine.Validate("Document Type", SalesHeader."Document Type");
            SalesLine.Validate("Document No.", SalesHeader."No.");
            SalesLine."Line No." := NextLineNo;
            SalesLine."BLS Invoicing Entry No." := CalcWorksheetLine."Entry No.";
            NextLineNo += 1000;
            SalesLine.Description := CopyStr(StrSubstNo(Service."Invoice Line Addit.Description",
                                                        CalcWorksheetLine."Service Code", CalcWorksheetLine."Service Variant Code",
                                                        BLSObject."Object Type", CalcWorksheetLine."Object Code",
                                                        CalcWorksheetLine."Starting Date", CalcWorksheetLine."Ending Date",
                                                        CalcWorksheetLine."Period Starting Date", CalcWorksheetLine."Period Ending Date",
                                                        CalcWorksheetLine."Unit Price", CalcWorksheetLine."Total Price",
                                                        CalcWorksheetLine."Discount, %", CalcWorksheetLine."Discount Amount",
                                                        CalcWorksheetLine."Total Price Incl. Discount",
                                                        CalcWorksheetLine."Service Date",
                                                        CalcWorksheetLine."Vehicle Serial No.", Vehicle.VIN, Vehicle."Make Code",
                                                        Vehicle."Model Code", Vehicle."Model Commercial Name"),
                                           1, MaxStrLen(SalesLine.Description));
            SalesLine."BLS Invoicing Entry No." := 0;
            SalesLine.Modify;
        end;

        if Service."Invoice Line Addit.Descriptio2" <> '' then begin
            SalesLine.Init;
            SalesLine.Validate("Document Type", SalesHeader."Document Type");
            SalesLine.Validate("Document No.", SalesHeader."No.");
            SalesLine."Line No." := NextLineNo;
            SalesLine."BLS Invoicing Entry No." := CalcWorksheetLine."Entry No.";
            NextLineNo += 1000;
            SalesLine.Description := CopyStr(StrSubstNo(Service."Invoice Line Addit.Descriptio2",
                                                        CalcWorksheetLine."Service Code", CalcWorksheetLine."Service Variant Code",
                                                        BLSObject."Object Type", CalcWorksheetLine."Object Code",
                                                        CalcWorksheetLine."Starting Date", CalcWorksheetLine."Ending Date",
                                                        CalcWorksheetLine."Period Starting Date", CalcWorksheetLine."Period Ending Date",
                                                        CalcWorksheetLine."Unit Price", CalcWorksheetLine."Total Price",
                                                        CalcWorksheetLine."Discount, %", CalcWorksheetLine."Discount Amount",
                                                        CalcWorksheetLine."Total Price Incl. Discount",
                                                        CalcWorksheetLine."Service Date",
                                                        CalcWorksheetLine."Vehicle Serial No.", Vehicle.VIN, Vehicle."Make Code",
                                                        Vehicle."Model Code", Vehicle."Model Commercial Name"),
                                           1, MaxStrLen(SalesLine.Description));
            SalesLine."BLS Invoicing Entry No." := 0;
            SalesLine.Modify;
        end;
    end;

    local procedure GetLastInvoiceEntryNo(): Integer
    var
        InvLedgEntry: Record "BLS Invoicing Ledger Entry";
        EntryNo: Integer;
    begin
        InvLedgEntry.Reset;
        if InvLedgEntry.FindLast then
            exit(InvLedgEntry."Entry No.");

        exit(0);
    end;

    [BusinessEvent(true)]
    procedure GetProcessInfo(var InvCnt: Integer; var CreatedSalesHeader: record "Sales Header")

    begin

    end;
}

