Report 25006126 "Rent Calculate Worksheet Lines"
{
    Caption = 'Rent Calculate Worksheet';
    ProcessingOnly = true;

    dataset
    {
        dataitem(RentHeaderFilter; "Rent Header")
        {
            RequestFilterFields = "Sell-to Customer No.", "Document Date";
            RequestFilterHeading = 'Rent Header';
            trigger OnAfterGetRecord()
            var
                RentLine: Record "Rent Line";
                RentWkshtLine: Record "Rent Billing Worksheet Line";
                RentWkshEntryNo: Integer;
                CalcToDateLine: Date;
                CalcFromDateLine: Date;
                RentPeriod: Record "Rent Period";
                DaysInPeriod: Decimal;
                Customer: Record Customer;
                RentSalesLine: Record "Rent Sales Line";
                RentSalesLineNo: Integer;
                RentItem: Record "Rent Item";
                RentAsset: Record "Rent Asset";
                MapViewTelematics: Record "Vehicle Telematics";
                VF1From: Decimal;
                VF1To: Decimal;
                RentSetup: Record "Rent Mgt. Setup";
                DatesValidToCharge: Boolean;
            begin
                RentWkshtLine.Reset();
                if RentWkshtLine.FindLast() then
                    RentWkshEntryNo := RentWkshtLine."Entry No." + 1
                else
                    RentWkshEntryNo := 1000;

                RentSetup.Get;
                if RentSetup."Deal Type Mandatory" then
                    if "Deal Type" = '' then
                        Error(Txt001, "No.");

                RentLine.Reset();
                RentLine.SetRange("Document Type", "Document Type");
                RentLine.SetRange("Document No.", "No.");
                //RentLine.SetFilter(Status, '%1|%2', RentLine.Status::Rented, RentLine.Status::Returned);
                RentLine.SetFilter("Last Date Invoiced", '..%1', CalculateOnDate);
                if RentLine.FindFirst() then begin
                    repeat
                        VF1From := 0;
                        VF1To := 0;
                        DatesValidToCharge := false;
                        if (RentLine.CalculatedStatus = RentLine.Status::Rented) or (RentLine.CalculatedStatus = RentLine.Status::Returned) or (RentLine.CalculatedStatus = RentLine.Status::"In Service") then begin
                            CalcFromDateLine := 0D;
                            CalcToDateLine := 0D;
                            RentLine.CalcFields("Sell-to Customer No.", "Actual Shipment Date", "Actual Return Date", "Quantity Shipped", "Quantity Returned");
                            CalcToDateLine := CalculateOnDate;

                            if (RentLine."Rent End Date" > 0D) AND (RentLine."Rent End Date" < CalculateOnDate) then
                                CalcToDateLine := RentLine."Rent End Date";

                            if ("Rent Type" = "Rent Type"::"Open End Date") and (RentLine.CalculatedStatus = RentLine.Status::Returned) and (RentLine."Actual Return Date" < CalcToDateLine) then
                                CalcToDateLine := RentLine."Actual Return Date";

                            if RentLine."Manual Invoicing End Date" <> 0D then
                                if RentLine."Manual Invoicing End Date" < CalculateOnDate then
                                    CalcToDateLine := RentLine."Manual Invoicing End Date";

                            if RentLine."Last Date Invoiced" <> 0D then
                                if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Standard Period" then
                                    CalcFromDateLine := RentLine."Last Date Invoiced"
                                else
                                    CalcFromDateLine := RentLine."Last Date Invoiced" + 1;
                            if CalcFromDateLine = 0D then
                                if RentLine."Manual Invoicing Start Date" <> 0D then
                                    CalcFromDateLine := RentLine."Manual Invoicing Start Date"
                                else
                                    CalcFromDateLine := RentLine."Rent Start Date";

                            If RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Standard Period" then
                                if CalcFromDateLine < CalcToDateLine then
                                    DatesValidToCharge := true;

                            If RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Calendar Period" then
                                if CalcFromDateLine <= CalcToDateLine then
                                    DatesValidToCharge := true;

                            if DatesValidToCharge and not RentLine."Component Line" then begin
                                RentItem.get(RentLine."Rent Item No.");

                                RentWkshtLine.Init();
                                RentWkshtLine.TransferFields(RentLine);
                                RentWkshtLine."VF Run 1 From" := 0;
                                RentWkshtLine."VF Run 2 From" := 0;
                                RentWkshtLine."VF Run 3 From" := 0;
                                RentWkshtLine."Rent Type" := "Rent Type";
                                RentWkshtLine."Entry No." := RentWkshEntryNo;
                                RentWkshtLine."Process Line" := true;
                                RentWkshtLine."To Invoice" := true;

                                RentWkshtLine.Validate(Type, RentWkshtLine.Type::Resource);
                                RentWkshtLine.Validate("No.", RentItem."Resource No.");

                                RentLine.TestField("Rent Period Type");
                                if RentPeriod.Get(RentLine."Rent Period Type") then begin
                                    //DaysInPeriod := CalcDate(RentPeriod.Duration, CalcToDateLine) - CalcToDateLine;   
                                    RentPeriod.Testfield(Duration);
                                    DaysInPeriod := RentLine.CalculatePeriod(CalcDate('<CM>', CalcToDateLine), RentPeriod.Duration, '-');
                                    if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Standard Period" then
                                        RentWkshtLine.Periods := (CalcToDateLine - CalcFromDateLine) / DaysInPeriod
                                    else
                                        RentWkshtLine.Periods := ((CalcToDateLine - CalcFromDateLine) + 1) / DaysInPeriod;

                                    RentWkshtLine."Unit of Measure Code" := RentPeriod."Unit of Measure Code";
                                    RentWkshtLine.Quantity := RentWkshtLine.Periods * RentWkshtLine."Rent Asset Quantity";
                                    RentWkshtLine."Line Amount" := RentWkshtLine.Periods * RentWkshtLine."Unit Price" * RentWkshtLine."Rent Asset Quantity";
                                end;

                                RentWkshtLine."Period Starting Date" := CalcFromDateLine;
                                RentWkshtLine."Period Ending Date" := CalcToDateLine;
                                RentWkshtLine."Rent Type" := "Rent Type";
                                RentWkshtLine."Sell-to Customer Name" := "Sell-to Customer Name";
                                RentWkshtLine."Deal Type" := "Deal Type";
                                RentWkshtLine."Sell-to Customer No." := "Sell-to Customer No.";
                                RentWkshtLine."Bill-to Customer No." := "Bill-to Customer No.";
                                if Customer.get("Sell-to Customer No.") then
                                    RentWkshtLine."Sell-to Customer Name" := Customer.Name;
                                if Customer.get("Bill-to Customer No.") then
                                    RentWkshtLine."Bill-to Customer Name" := Customer.Name;
                                RentWkshtLine."Overtime Calculation" := "Overtime Calculation";
                                RentWkshtLine.Status := RentLine.CalculatedStatus;
                                RentWkshtLine."Vehicle Serial No." := RentLine."Vehicle Serial No.";
                                RentWkshtLine."Rent Line Description" := RentLine.Description;

                                RentWkshtLine.UpdateWrkshtVFRun(RentWkshtLine, RentLine);

                                if "Overtime Calculation" = "Overtime Calculation"::"Current Period" then begin
                                    if RentAsset.get(RentWkshtLine."Rent Asset No.") and (RentAsset."Vehicle Serial No." <> '') then begin
                                        MapViewTelematics.Reset();
                                        MapViewTelematics.SetRange("Vehicle Serial No.", RentAsset."Vehicle Serial No.");
                                        MapViewTelematics.SetFilter("Date Stamp", '..%1', RentWkshtLine."Period Ending Date");
                                        if MapViewTelematics.FindLast() then begin
                                            if MapViewTelematics."Variable Field Run 1" > RentWkshtLine."VF Run 1 From" then begin
                                                if RentWkshtLine."VF Run 1 To" = 0 then
                                                    RentWkshtLine."VF Run 1 To" := MapViewTelematics."Variable Field Run 1";
                                                VF1From := RentWkshtLine."VF Run 1 From";
                                                VF1To := RentWkshtLine."VF Run 1 To";
                                            end;
                                            if MapViewTelematics."Variable Field Run 2" > RentWkshtLine."VF Run 2 From" then begin
                                                if RentWkshtLine."VF Run 2 To" = 0 then
                                                    RentWkshtLine."VF Run 2 To" := MapViewTelematics."Variable Field Run 2";
                                            end;
                                            if MapViewTelematics."Variable Field Run 3" > RentWkshtLine."VF Run 3 From" then begin
                                                if RentWkshtLine."VF Run 3 To" = 0 then
                                                    RentWkshtLine."VF Run 3 To" := MapViewTelematics."Variable Field Run 3";
                                            end;
                                        end
                                    end;
                                end;
                                if RentWkshtLine."Line Amount" = 0 then
                                    RentWkshtLine."To Invoice" := false;
                                RentWkshtLine.Insert(true);
                                RentWkshEntryNo += 1;

                                if "Overtime Calculation" = "Overtime Calculation"::"Current Period" then
                                    RentWkshEntryNo := RentLine.CreateExtraChargeLinesWorksheetCurrentPeriod(RentWkshEntryNo, CalcToDateLine, RentWkshtLine);
                            end;
                            if "Overtime Calculation" = "Overtime Calculation"::"Total Period" then
                                RentWkshEntryNo := RentLine.CreateExtraChargeLinesWorksheetTotalPeriod(RentWkshEntryNo, CalcToDateLine);
                        end;
                    until RentLine.Next() = 0;
                end;

                //Add additional sales lines custome made on rent order, not invoiced yet

                RentSalesLine.Reset();
                RentSalesLine.SetRange("Document Type", "Document Type");
                RentSalesLine.SetRange("Document No.", "No.");
                RentSalesLine.SetRange("To Invoice", true);
                if RentSalesLine.FindFirst() then
                    repeat
                        if not RentSalesLine.Invoiced() and (RentSalesLine.Type <> RentSalesLine.Type::" ") and (RentSalesLine."No." <> '') then begin
                            RentWkshEntryNo := CopySalesLineToWrkshtLine(RentWkshEntryNo, RentHeaderFilter, RentSalesLine);
                            //if RentSalesLine."Attach. to Rent Sales Line No." then

                        end;
                    until RentSalesLine.Next() = 0;
            end;

            trigger OnPreDataItem()
            var
            begin
                if DocumentNo <> '' then
                    SetRange("No.", DocumentNo);
            end;

            trigger OnPostDataItem()
            var
            begin

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

                    field(CalculateOnDate; CalculateOnDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Calculdate On Date:';
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document No.';
                        TableRelation = "Rent Header"."No.";
                    }

                    /*
                    field(PeriodEndingDate; PeriodEndingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';
                    }
                    field(CalcPeriodCode; CalcPeriodCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Calculation Period Code';
                        Visible = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if CalcPeriod.Get(CalcPeriodCode) then;
                            if Page.RunModal(0, CalcPeriod) = Action::LookupOK then begin
                                Text := CalcPeriod.Code;
                                exit(true);
                            end;
                        end;
                    }
                    field(InvoiceGroupCode; InvoiceGroupCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoice Group Code';
                        Visible = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if InvoiceGroup.Get(InvoiceGroupCode) then;
                            if Page.RunModal(0, InvoiceGroup) = Action::LookupOK then begin
                                Text := InvoiceGroup.Code;
                                exit(true);
                            end;
                        end;
                    }
                    field(ContractUsageMethod; ContractUsageMethod)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Contract Usage';
                        OptionCaption = 'All,BLS Contracts Only,DMS Contracts Only,Without contract';
                        Visible = false;
                    }
                    field(ObjectUsageMethod; ObjectUsageMethod)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Object Usage';
                        OptionCaption = 'All,With Object,Without Object';
                    }
                    field(IgnoreLastCalcDate; IgnoreLastCalcDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ignore Last Calculation Date';
                    }
                    field(CalculateLeasingInvoices; CalculateLeasingInvoices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Calculate Leasing Invoices';
                    }
                    field(CalculateServiceInvoices; CalculateServiceInvoices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Calculate Service Invoices';
                    }
                    */
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin

        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if CalculateOnDate = 0D then
            Error('Please set calculation date.');
    end;

    var
        BLSSetup: Record "BLS Setup";
        CalcPeriod: Record "Payment Terms";
        InvoiceGroup: Record "Payment Terms";
        TempCalcBuffer: Record "BLS Calculation Buffer" temporary;
        TempQtyBuffer: Record "BLS Calculation Buffer";
        BLSMgt: Codeunit "BLS Management";
        Window: Dialog;
        CustomerNoFilter: Text;
        ServiceCodeFilter: Text;
        ObjectCodeFilter: Text;
        ContractNoFilter: Text;
        ContractNoDMSFilter: Text;
        CalcPeriodCode: Code[20];
        InvoiceGroupCode: Code[20];
        ContractUsageMethod: Option All,"Contracts Only","DMS Contracts Only","Without contract";
        ObjectUsageMethod: Option All,"With Object","Without Object";
        PeriodStartingDate: Date;
        PeriodEndingDate: Date;
        CalcPeriodEmptyErr: label 'Calculation period is empty.';
        DateIsEmptyErr: label 'Starting or ending date is empty.';
        GenPeriodStartingDate: Date;
        GenPeriodEndingDate: Date;
        CurrPeriodStartingDate: Date;
        CurrPeriodEndingDate: Date;
        NextPeriodStartingDate: Date;
        CurrPeriodDayCountCalendar: Integer;
        CurrPeriodDayCountWorking: Integer;
        GenPeriodDayCountCalendar: Integer;
        GenPeriodDayCountWorking: Integer;
        LastEntryNo: Integer;
        NextEntryNo: Integer;
        NextEntryNoBuf: Integer;
        WindowHeaderTxt: label 'Services calculation';
        WindowCurrPeriodTxt: label 'Current period            #1###################';
        WindowContractTxt: label 'Contracts                 @2@@@@@@@@@@@@@@@@@@@';
        WindowEPSCardsTxt: label 'EPS Cards                 @3@@@@@@@@@@@@@@@@@@@';
        WindowServiceLedgerTxt: label 'Service Ledger            @4@@@@@@@@@@@@@@@@@@@';
        WindowEntryCreationTxt: label 'Worksheet Creation        @5@@@@@@@@@@@@@@@@@@@';
        IgnoreLastCalcDate: Boolean;
        CalculateLeasingInvoices: Boolean;
        CalculateServiceInvoices: Boolean;
        //------------------
        CalculateOnDate: Date;
        DocumentNo: Code[20];
        Txt001: label 'Deal Type is missinig for Rent Order %1. You must specify Deal Type to continue.';

    local procedure InitCalculation()
    begin


    end;


    local procedure CopySalesLineToWrkshtLine(RentWkshEntryNo: Integer; RentHeader: Record "Rent Header"; RentSalesLine: Record "Rent Sales Line"): Integer
    var
        RentWkshtLine: Record "Rent Billing Worksheet Line";
        Customer: Record Customer;
        RentLine: Record "Rent Line";
    begin
        RentWkshtLine.Init();
        RentWkshtLine."Entry No." := RentWkshEntryNo;
        RentWkshtLine."Process Line" := true;
        RentWkshtLine."To Invoice" := true;

        RentWkshtLine."Document Type" := RentHeader."Document Type";
        RentWkshtLine."Document No." := RentHeader."No.";
        RentWkshtLine."Rent Type" := RentHeader."Rent Type";
        RentWkshtLine."Rent Item No." := RentSalesLine."Rent Item No.";
        RentWkshtLine.Validate(Type, RentSalesLine.Type);
        RentWkshtLine.Validate("No.", RentSalesLine."No.");

        RentWkshtLine.Description := RentSalesLine.Description;
        RentWkshtLine."Rent Asset Quantity" := RentSalesLine."Rent Asset Quantity";
        RentWkshtLine.Periods := RentSalesLine.Periods;
        RentWkshtLine."Unit of Measure Code" := RentSalesLine."Unit of Measure Code";
        RentWkshtLine.Quantity := RentSalesLine.Quantity;
        RentWkshtLine."Unit Price" := RentSalesLine."Unit Price";
        RentWkshtLine."Line Amount" := RentSalesLine."Line Amount";
        RentWkshtLine."Line Discount %" := RentSalesLine."Line Discount %";
        RentWkshtLine."Location Code" := RentSalesLine."Location Code";

        RentWkshtLine."Shortcut Dimension 1 Code" := RentSalesLine."Shortcut Dimension 1 Code";
        RentWkshtLine."Shortcut Dimension 2 Code" := RentSalesLine."Shortcut Dimension 2 Code";


        RentWkshtLine."Period Starting Date" := RentSalesLine."Start Date";
        RentWkshtLine."Period Ending Date" := RentSalesLine."End Date";

        RentWkshtLine."Dimension Set ID" := RentSalesLine."Dimension Set ID";

        RentWkshtLine."VF Run 1 From" := RentSalesLine."VF Run 1 From";
        RentWkshtLine."VF Run 2 From" := RentSalesLine."VF Run 2 From";
        RentWkshtLine."VF Run 3 From" := RentSalesLine."VF Run 3 From";
        RentWkshtLine."VF Run 1 To" := RentSalesLine."VF Run 1 To";
        RentWkshtLine."VF Run 2 To" := RentSalesLine."VF Run 2 To";
        RentWkshtLine."VF Run 3 To" := RentSalesLine."VF Run 3 To";

        RentWkshtLine."Rent Sales Line No." := RentSalesLine."Line No.";
        RentWkshtLine."Line No." := RentSalesLine."Attached to Rent Line No.";
        RentWkshtLine."Attached to Line No." := RentSalesLine."Attached to Rent Line No.";
        RentWkshtLine."Attach. to Rent Sales Line No." := RentSalesLine."Attach. to Rent Sales Line No.";

        RentWkshtLine."Sell-to Customer No." := RentHeader."Sell-to Customer No.";
        RentWkshtLine."Sell-to Customer Name" := RentHeader."Sell-to Customer Name";
        RentWkshtLine."Bill-to Customer No." := RentHeader."Bill-to Customer No.";
        if Customer.get(RentWkshtLine."Bill-to Customer No.") then
            RentWkshtLine."Bill-to Customer Name" := Customer.Name;


        RentWkshtLine."Deal Type" := RentHeader."Deal Type";

        if RentLine.get(RentWkshtLine."Document Type", RentWkshtLine."Document No.", RentWkshtLine."Attached to Line No.") then begin
            RentWkshtLine.Status := RentLine.Status;
            RentWkshtLine."Rent Period Type" := RentLine."Rent Period Type";
            //RentWkshtLine."Period Starting Date" := RentLine."Rent Start Date";
            //RentWkshtLine."Period Ending Date" := RentLine."Rent End Date";
            RentWkshtLine."Rent Asset No." := RentLine."Rent Asset No.";
        end;

        RentWkshtLine.Insert(true);
        RentWkshEntryNo += 1;
        exit(RentWkshEntryNo);
    end;


}


