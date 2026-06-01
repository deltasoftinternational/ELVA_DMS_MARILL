Report 25006109 "BLS Create Invoices"
{
    Caption = 'Create Billing Invoices';

    ProcessingOnly = true;

    dataset
    {
        dataitem(CalcWorksheetLine; "BLS Calculation Worksheet Line")
        {
            column(ReportForNavId_50000; 50000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                UpdateCalcBuffer("Customer No.", "Currency Code", "Contract No.",
                                 "Service Code", "Service Variant Code",
                                 "Object Code",
                                 "Starting Date", "Ending Date",
                                 "Period Starting Date", "Period Ending Date",
                                 Quantity, "Unit Price", "Base Unit Price", "Total Price",
                                 "Discount, %", "Discount Amount", "Total Price Incl. Discount",
                                 "Specific Source", "Specific No.", "Invoice Group Code", "Discount Usage",
                                 "Customer Price Group", "Customer Discount Group", "Grouping ID", "Service Date", "Vehicle Serial No.");

                CalcLedgEntry.Init;
                CalcLedgEntry.TransferFields(CalcWorksheetLine);
                CalcLedgEntry."Invoice Ledger Entry No." := TempCalcBuffer."Entry No.";
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
        dataitem(BufferCounter; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_50001; 50001)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempCalcBuffer.FindFirst
                else
                    TempCalcBuffer.Next;

                // TESTFIELD(Status, Status::" ");
                Service.Get(TempCalcBuffer."Service Code");

                SeparateInvoicePerVehicle := false;
                if (TempCalcBuffer."Contract No." <> '') then begin
                    ContractDMS.Get(TempCalcBuffer."Contract No.");
                    SeparateInvoicePerVehicle := ContractDMS."Separate Invoice Per Vehicle";
                end;

                if (PrevCustNo <> TempCalcBuffer."Customer No.") or
                   (PrevCurrCode <> TempCalcBuffer."Currency Code") or
                   (PrevContractNo <> TempCalcBuffer."Contract No.") or
                   SeparateInvoicePerVehicle and (PrevVehicleNo <> TempCalcBuffer."Vehicle Serial No.")
                then
                    CreateInvoice;

                /*
                IF (PrevServiceGroupCode <> TempCalcBuffer."Service Group Code") AND
                   (TempCalcBuffer."Service Group Code" <> '')
                THEN BEGIN
                  ServiceGroup.GET(TempCalcBuffer."Service Group Code");
                  IF ServiceGroup."Invoice Line Description" <> '' THEN BEGIN
                    CreateInvoiceLine;
                    SalesLine."BLS Invoicing Entry No." := 0;
                    SalesLine.Description := ServiceGroup."Invoice Line Description";
                    SalesLine.MODIFY;
                  END;
                  PrevServiceGroupCode := TempCalcBuffer."Service Group Code";
                  PrevPriceInclVAT := TempCalcBuffer."Price Including VAT";
                END;
                */

                if (InvoiceFromDate = 0D) or (InvoiceFromDate > TempCalcBuffer."Starting Date") then
                    InvoiceFromDate := TempCalcBuffer."Starting Date";
                if (InvoiceToDate = 0D) or (InvoiceToDate < TempCalcBuffer."Ending Date") then
                    InvoiceToDate := TempCalcBuffer."Ending Date";

                CreateInvoiceLine;

                case Service."Posting Type" of
                    Service."posting type"::"G/L Account":
                        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                    // Service."Posting Type"::Item:
                    //   SalesLine.VALIDATE(Type, SalesLine.Type::Item);
                    Service."posting type"::Resource:
                        SalesLine.Validate(Type, SalesLine.Type::Resource);
                end;
                SalesLine.Validate("No.", Service."Posting No.");

                case Service."Posting Type" of
                    Service."posting type"::"G/L Account":
                        SalesLine.Validate("Unit of Measure Code", Service."Base Unit of Measure Code");
                    // Service."Posting Type"::Item:
                    //   BEGIN
                    //     Item.GET(Service."Posting No.");
                    //     SalesLine.VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");
                    //   END;
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

                // SalesLine.VALIDATE("Location Code", HSSetup."Location Code");
                SalesLine.Validate(Quantity, TempCalcBuffer.Quantity);
                SalesLine.Validate("Unit Price", TempCalcBuffer."Unit Price");
                SalesLine.Validate("Line Discount Amount", TempCalcBuffer."Discount Amount");
                SalesLine."Customer Price Group" := TempCalcBuffer."Customer Price Group";
                SalesLine."Customer Disc. Group" := TempCalcBuffer."Customer Discount Group";

                ObjectAddress := '';
                SalesLine.Validate("BLS Service Code", TempCalcBuffer."Service Code");
                if TempCalcBuffer."Object Code" <> '' then begin
                    BLSObject.Get(TempCalcBuffer."Object Code");
                    ObjectAddress := BLSObject.Name;
                    SalesLine.Validate("BLS Object Code", TempCalcBuffer."Object Code");
                end;

                Clear(Vehicle);
                if TempCalcBuffer."Vehicle Serial No." <> '' then begin
                    Vehicle.Get(TempCalcBuffer."Vehicle Serial No.");
                    Vehicle.CalcFields("Default Vehicle Acc. Cycle No.");
                    SalesLine."Make Code" := Vehicle."Make Code";
                    SalesLine."Model Code" := Vehicle."Model Code";
                    SalesLine."Vehicle Serial No." := Vehicle."Serial No.";
                    SalesLine."Vehicle Accounting Cycle No." := Vehicle."Default Vehicle Acc. Cycle No.";
                    //SalesLine.Validate("Make Code", Vehicle."Make Code");
                    //SalesLine.Validate("Model Code", Vehicle."Model Code");
                    //SalesLine.Validate("Vehicle Serial No.", Vehicle."Serial No.");
                    SalesLine.VIN := Vehicle.VIN;
                end;

                BLSServiceLedgerEntry.Reset();
                if TempCalcBuffer."BLS Service Ledger Entry No." <> 0 then
                    BLSServiceLedgerEntry.Get(TempCalcBuffer."BLS Service Ledger Entry No.");

                SalesLine.Description := CopyStr(StrSubstNo(Service."Invoice Line Description",
                                                            TempCalcBuffer."Service Code", TempCalcBuffer."Service Variant Code",
                                                            TempCalcBuffer."Object Type", TempCalcBuffer."Object Code",
                                                            TempCalcBuffer."Starting Date", TempCalcBuffer."Ending Date",
                                                            TempCalcBuffer."Period Starting Date", TempCalcBuffer."Period Ending Date",
                                                            TempCalcBuffer."Unit Price", TempCalcBuffer."Total Price",
                                                            TempCalcBuffer."Discount, %", TempCalcBuffer."Discount Amount",
                                                            TempCalcBuffer."Total Price Incl. Discount",
                                                            TempCalcBuffer."Service Date",
                                                            TempCalcBuffer."Vehicle Serial No.", Vehicle.VIN, Vehicle."Make Code",
                                                            Vehicle."Model Code", Vehicle."Model Commercial Name",
                                                            BLSServiceLedgerEntry."Variable Field Run Start 1", BLSServiceLedgerEntry."Variable Field Run End 1",
                                                            BLSServiceLedgerEntry."Variable Field Run Start 2", BLSServiceLedgerEntry."Variable Field Run End 2",
                                                            BLSServiceLedgerEntry."Variable Field Run Start 3", BLSServiceLedgerEntry."Variable Field Run End 3"),
                                                 1, MaxStrLen(SalesLine.Description));

                SalesLine."BLS Invoicing Entry No." := TempCalcBuffer."Entry No.";
                SalesLine.Modify(true);

                if ObjectAddress <> '' then begin
                    CreateInvoiceLine;
                    SalesLine.Description := ObjectAddress;
                    SalesLine."BLS Invoicing Entry No." := 0;
                    SalesLine.Modify;
                end;

                if Service."Invoice Line Addit.Description" <> '' then begin
                    CreateInvoiceLine;
                    SalesLine.Description := CopyStr(StrSubstNo(Service."Invoice Line Addit.Description",
                                                                TempCalcBuffer."Service Code", TempCalcBuffer."Service Variant Code",
                                                                TempCalcBuffer."Object Type", TempCalcBuffer."Object Code",
                                                                TempCalcBuffer."Starting Date", TempCalcBuffer."Ending Date",
                                                                TempCalcBuffer."Period Starting Date", TempCalcBuffer."Period Ending Date",
                                                                TempCalcBuffer."Unit Price", TempCalcBuffer."Total Price",
                                                                TempCalcBuffer."Discount, %", TempCalcBuffer."Discount Amount",
                                                                TempCalcBuffer."Total Price Incl. Discount",
                                                                TempCalcBuffer."Service Date",
                                                                TempCalcBuffer."Vehicle Serial No.", Vehicle.VIN, Vehicle."Make Code",
                                                                Vehicle."Model Code", Vehicle."Model Commercial Name",
                                                                BLSServiceLedgerEntry."Variable Field Run Start 1", BLSServiceLedgerEntry."Variable Field Run End 1",
                                                                BLSServiceLedgerEntry."Variable Field Run Start 2", BLSServiceLedgerEntry."Variable Field Run End 2",
                                                                BLSServiceLedgerEntry."Variable Field Run Start 3", BLSServiceLedgerEntry."Variable Field Run End 3"),
                                                   1, MaxStrLen(SalesLine.Description));
                    SalesLine."BLS Invoicing Entry No." := 0;
                    SalesLine.Modify;
                end;

                if Service."Invoice Line Addit.Descriptio2" <> '' then begin
                    CreateInvoiceLine;
                    SalesLine.Description := CopyStr(StrSubstNo(Service."Invoice Line Addit.Descriptio2",
                                                                TempCalcBuffer."Service Code", TempCalcBuffer."Service Variant Code",
                                                                TempCalcBuffer."Object Type", TempCalcBuffer."Object Code",
                                                                TempCalcBuffer."Starting Date", TempCalcBuffer."Ending Date",
                                                                TempCalcBuffer."Period Starting Date", TempCalcBuffer."Period Ending Date",
                                                                TempCalcBuffer."Unit Price", TempCalcBuffer."Total Price",
                                                                TempCalcBuffer."Discount, %", TempCalcBuffer."Discount Amount",
                                                                TempCalcBuffer."Total Price Incl. Discount",
                                                                TempCalcBuffer."Service Date",
                                                                TempCalcBuffer."Vehicle Serial No.", Vehicle.VIN, Vehicle."Make Code",
                                                                Vehicle."Model Code", Vehicle."Model Commercial Name",
                                                                BLSServiceLedgerEntry."Variable Field Run Start 1", BLSServiceLedgerEntry."Variable Field Run End 1",
                                                                BLSServiceLedgerEntry."Variable Field Run Start 2", BLSServiceLedgerEntry."Variable Field Run End 2",
                                                                BLSServiceLedgerEntry."Variable Field Run Start 3", BLSServiceLedgerEntry."Variable Field Run End 3"),
                                                   1, MaxStrLen(SalesLine.Description));
                    SalesLine."BLS Invoicing Entry No." := 0;
                    SalesLine.Modify;
                end;

                InvoiceLedgEntry.Init;
                InvoiceLedgEntry.TransferFields(TempCalcBuffer);
                InvoiceLedgEntry.Validate("Customer No.");
                InvoiceLedgEntry.Validate("Service Code");
                InvoiceLedgEntry.Validate("Object Code");
                InvoiceLedgEntry.Insert;

                CP += 1;
                Window.Update(2, ROUND(CP / RC * 10000, 1, '<'));

            end;

            trigger OnPostDataItem()
            begin
                if SalesHeader."No." <> '' then
                    UpdateInvoiceHeader;
            end;

            trigger OnPreDataItem()
            begin
                if HistoryOnly then
                    CurrReport.Skip;

                TempCalcBuffer.Reset;
                TempCalcBuffer.SetCurrentkey("Customer No.", "Currency Code", "Contract No.", "Price Including VAT", "Vehicle Serial No.",
                                             "Service Code", "Service Variant Code", "Object Code", "Starting Date", "Ending Date", "Specific Source", "Specific No.");
                CP := 0;
                RC := TempCalcBuffer.Count;

                SetRange(Number, 1, RC);

                PrevCustNo := '';
                PrevCurrCode := '';
                PrevContractSource := -1;
                PrevContractNo := '';
                PrevServiceGroupCode := '';
                PrevPriceInclVAT := false;
                PrevVehicleNo := '';
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

        CreatedInvoiceCount := 0;
        InvoiceNoFirst := '';
        InvoiceNoLast := '';
        Window.Open(WindowTxt);

        CompanyInfo.Get;
        SalesSetup.Get;
        SalesSetup.TestField("Invoice Nos.");
        BLSSetup.Get;

        TempCalcBuffer.Reset;
        TempCalcBuffer.DeleteAll;

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
        TempCalcBuffer: Record "BLS Calculation Buffer" temporary;
        CalcLedgEntry: Record "BLS Calculation Ledger Entry";
        InvoiceLedgEntry: Record "BLS Invoicing Ledger Entry";
        BLSServiceLedgerEntry: Record "BLS Ledger Entry";
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


    procedure CreateInvoice()
    var
        NewInvoice: Boolean;
    begin
        if SalesHeader."No." <> '' then
            UpdateInvoiceHeader;

        Clear(SalesHeader);
        Clear(NoSeriesMgt);
        SalesHeader.SetHideValidationDialog(true);

        SalesHeader.Init;
        SalesHeader.Validate("Document Type", SalesHeader."document type"::Invoice);
        SalesHeader.Validate("Posting Date", InvoiceDate);
        SalesHeader.Validate("No. Series", NoSerieCode);
        //>>DELTA
        OnBeforeInsertContractInvoiceHeader(SalesHeader);
        //<<DELTA
        SalesHeader."No." := NoSeriesMgt.GetNextNo(NoSerieCode, InvoiceDate, true);
        SalesHeader.Insert(true);

        SalesHeader.Modify(true);
        CreatedInvoiceCount += 1;

        if InvoiceNoFirst = '' then
            InvoiceNoFirst := SalesHeader."No.";
        InvoiceNoLast := SalesHeader."No.";

        SalesHeader.Validate("Document Date", InvoiceDate);
        Customer.Get(TempCalcBuffer."Customer No.");
        // InENG := NOT (CompanyInfo."Country/Region Code" = Customer."Country/Region Code";)
        // InENG := NOT (Customer."Language Code" IN ['', HSSetup."Language Code"]);
        InENG := false;

        SalesHeader.Validate("Sell-to Customer No.", TempCalcBuffer."Customer No.");
        SalesHeader.Validate("Bill-to Customer No.", TempCalcBuffer."Customer No.");
        SalesHeader.Validate("Currency Code", TempCalcBuffer."Currency Code");
        SalesHeader.Validate("BLS Contract No.", TempCalcBuffer."Contract No.");
        SalesHeader.Validate("Prices Including VAT", TempCalcBuffer."Price Including VAT");
        SalesHeader.Validate("Posting Date", InvoiceDate);
        SalesHeader.Validate("Document Date", InvoiceDate);
        SalesHeader.Validate("Payment Terms Code");
        if ContractDMS.Get(TempCalcBuffer."Contract No.") then
            SalesHeader.Validate("Deal Type Code", ContractDMS."Deal Type For Invoices");
        if (TempCalcBuffer."Vehicle Serial No." <> '') and SeparateInvoicePerVehicle then begin
            Vehicle.Get(TempCalcBuffer."Vehicle Serial No.");
            SalesHeader."Make Code" := Vehicle."Make Code";
            SalesHeader."Model Code" := Vehicle."Model Code";
            SalesHeader."Vehicle Serial No." := Vehicle."Serial No.";
        end;

        if (TempCalcBuffer."Contract No." <> '') then begin
            if ContractDMS.Get(TempCalcBuffer."Contract No.") then
                SalesHeader."External Document No." := ContractDMS."External Doc. No. For Invoices";
        end;

        if DueDate <> 0D then
            SalesHeader.Validate("Due Date", DueDate);
        // SalesHeader."Automatic Processing" := TRUE;
        SalesHeader."Document Profile" := SalesHeader."Document Profile"::" ";
        SalesHeader.Modify(true);
        //>>DELTA
        OnAfterCreateContractInvoiceHeader(SalesHeader, ContractDMS);
        //<<DELTA

        PrevCustNo := TempCalcBuffer."Customer No.";
        PrevCurrCode := TempCalcBuffer."Currency Code";
        PrevContractNo := TempCalcBuffer."Contract No.";
        PrevServiceGroupCode := '';
        InvoiceFromDate := 0D;
        InvoiceToDate := 0D;
        NextLineNo := 10000;
    end;


    procedure CreateInvoiceLine()
    begin
        Service.Get(TempCalcBuffer."Service Code");

        SalesLine.Init;
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine."Line No." := NextLineNo;
        SalesLine."BLS Invoicing Entry No." := TempCalcBuffer."Entry No.";
        NextLineNo += 1000;

        SalesLine.Insert(true);
    end;

    local procedure UpdateInvoiceHeader()
    var
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        /*
        SalesHeader."Special Remarks" := STRSUBSTNO('%1 - %2',
                                                    FORMAT(InvoiceFromDate, 0, '<Day,2>.<Month,2>.<Year4>'),
                                                    FORMAT(InvoiceToDate, 0, '<Day,2>.<Month,2>.<Year4>'));
        SalesHeader.MODIFY;
        */

    end;

    local procedure UpdateCalcBuffer(CustomerNo: Code[20]; CurrencyCode: Code[10]; ContractNo: Code[20]; ServiceCode: Code[20]; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; FromDate: Date; ToDate: Date; PeriodFromDate: Date; PeriodToDate: Date; Qty: Decimal; UnitPrice: Decimal; BaseUnitPrice: Decimal; TotalPrice: Decimal; DiscountPercent: Decimal; DiscountAmount: Decimal; TotalPriceInclDiscount: Decimal; SpecificSource: Integer; SpecificNo: Code[20]; InvGrCode: Code[20]; DiscountUsage: Integer; CustPriceGroupCode: Code[20]; CustDiscGroupCode: Code[20]; GroupID: Integer; ServiceDate: Date; VehicleNo: Code[20]): Boolean
    var
        Service: Record "BLS Service";
    begin
        if Service.Code <> ServiceCode then
            Service.Get(ServiceCode);

        // Clear parameter to consolidate records. Example: clear Service Variant Code or Price to compbine in one row
        if Service."Calculate Average Price" = Service."calculate average price"::"On Invoicing" then begin
            UnitPrice := 0;
            BaseUnitPrice := 0;
            DiscountPercent := 0;
        end;

        if Service."Combine Service Variants" = Service."combine service variants"::"On Invoicing" then
            ServiceVariantCode := '';

        if Service."Combine Objects" = Service."combine objects"::"On Invoicing" then
            ObjectCode := '';

        // Looking for buffer entry to update
        TempCalcBuffer.Reset;
        TempCalcBuffer.SetRange("Customer No.", CustomerNo);
        TempCalcBuffer.SetRange("Currency Code", CurrencyCode);
        TempCalcBuffer.SetRange("Contract No.", ContractNo);
        TempCalcBuffer.SetRange("Period Starting Date", PeriodFromDate);
        TempCalcBuffer.SetRange("Period Ending Date", PeriodToDate);
        TempCalcBuffer.SetRange("Starting Date", FromDate);
        TempCalcBuffer.SetRange("Ending Date", ToDate);

        TempCalcBuffer.SetRange("Service Code", ServiceCode);
        TempCalcBuffer.SetRange("Service Variant Code", ServiceVariantCode);
        TempCalcBuffer.SetRange("Object Code", ObjectCode);

        TempCalcBuffer.SetRange("Unit Price", UnitPrice);
        TempCalcBuffer.SetRange("Base Unit Price", BaseUnitPrice);
        TempCalcBuffer.SetRange("Discount, %", DiscountPercent);

        TempCalcBuffer.SetRange("Specific Source", SpecificSource);
        TempCalcBuffer.SetRange("Specific No.", SpecificNo);

        TempCalcBuffer.SetRange("Discount Usage", DiscountUsage);

        TempCalcBuffer.SetRange("Customer Price Group", CustPriceGroupCode);
        TempCalcBuffer.SetRange("Customer Discount Group", CustDiscGroupCode);

        TempCalcBuffer.SetRange("Grouping ID", GroupID);
        TempCalcBuffer.SetRange("Vehicle Serial No.", VehicleNo);

        if not TempCalcBuffer.FindFirst then begin
            TempCalcBuffer.Init;
            NextEntryNo += 1;
            TempCalcBuffer."Entry No." := NextEntryNo;

            TempCalcBuffer."Customer No." := CustomerNo;
            TempCalcBuffer."Currency Code" := CurrencyCode;
            TempCalcBuffer."Contract No." := ContractNo;
            TempCalcBuffer."Period Starting Date" := PeriodFromDate;
            TempCalcBuffer."Period Ending Date" := PeriodToDate;
            TempCalcBuffer."Starting Date" := FromDate;
            TempCalcBuffer."Ending Date" := ToDate;

            TempCalcBuffer."Service Group Code" := Service."Service Group Code";
            TempCalcBuffer."Service Code" := ServiceCode;
            TempCalcBuffer."Service Variant Code" := ServiceVariantCode;
            TempCalcBuffer."Object Code" := ObjectCode;

            TempCalcBuffer."Unit Price" := UnitPrice;
            TempCalcBuffer."Base Unit Price" := BaseUnitPrice;
            TempCalcBuffer."Price Including VAT" := Service."Price Including VAT";
            TempCalcBuffer."Discount, %" := DiscountPercent;

            TempCalcBuffer."Specific Source" := SpecificSource;
            TempCalcBuffer."Specific No." := SpecificNo;

            TempCalcBuffer."Discount Usage" := DiscountUsage;

            TempCalcBuffer."Customer Price Group" := CustPriceGroupCode;
            TempCalcBuffer."Customer Discount Group" := CustDiscGroupCode;

            TempCalcBuffer."Grouping ID" := GroupID;
            TempCalcBuffer."BLS Service Ledger Entry No." := GroupID;
            TempCalcBuffer."Service Date" := ServiceDate;

            TempCalcBuffer."Vehicle Serial No." := VehicleNo;

            TempCalcBuffer.Insert;
        end;

        // Update buffer entry
        TempCalcBuffer.Quantity += Qty;
        TempCalcBuffer."Total Price" += TotalPrice;
        TempCalcBuffer."Discount Amount" += DiscountAmount;
        TempCalcBuffer."Total Price Incl. Discount" += TotalPriceInclDiscount;

        if Service."Calculate Average Price" = Service."calculate average price"::"On Invoicing" then begin
            if TempCalcBuffer.Quantity = 0 then
                TempCalcBuffer."Unit Price" := 0
            else
                TempCalcBuffer."Unit Price" := TempCalcBuffer."Total Price" / TempCalcBuffer.Quantity;

            if TempCalcBuffer."Total Price" = 0 then
                DiscountPercent := 0
            else
                DiscountPercent := 100 - TempCalcBuffer."Total Price Incl. Discount" * 100 / TempCalcBuffer."Total Price";
        end;

        TempCalcBuffer.Modify;

        exit(true);
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

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateContractInvoiceHeader(var SalesHeader: Record "Sales Header"; Contract: Record Contract)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertContractInvoiceHeader(var SalesHeader: Record "Sales Header")
    begin
    end;
}

