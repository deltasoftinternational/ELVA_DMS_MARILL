Report 25006108 "BLS Calculate Services"
{
    Caption = 'Calculate Sold Services';
    Permissions = TableData "BLS Ledger Entry" = imd,
                  TableData "BLS Calculation Ledger Entry" = imd;
    ProcessingOnly = true;

    dataset
    {
        dataitem(CustomerFilter; Customer)
        {
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Customer';
            column(ReportForNavId_50000; 50000)
            {
            }

            trigger OnPreDataItem()
            begin
                CustomerNoFilter := GetFilter("No.");
                FilterGroup(100);
                CurrReport.Break;
            end;
        }
        dataitem(ContractDMSFilter; Contract)
        {
            RequestFilterFields = "Contract No.";
            RequestFilterHeading = 'Contract';


            trigger OnPreDataItem()
            begin
                if ContractUsageMethod = Contractusagemethod::"Without contract" then
                    Reset;

                ContractNoDMSFilter := GetFilter("Contract No.");
                FilterGroup(100);
                CurrReport.Break;
            end;
        }
        dataitem(ServiceFilter; "BLS Service")
        {
            RequestFilterFields = "Code";
            RequestFilterHeading = 'Service';
            column(ReportForNavId_50002; 50002)
            {
            }

            trigger OnPreDataItem()
            begin
                ServiceCodeFilter := GetFilter(Code);
                FilterGroup(100);
                CurrReport.Break;
            end;
        }
        dataitem(ObjectFilter; "BLS Object")
        {
            RequestFilterFields = "Code";
            RequestFilterHeading = 'Object';
            column(ReportForNavId_50003; 50003)
            {
            }

            trigger OnPreDataItem()
            begin
                if ObjectUsageMethod = Objectusagemethod::"Without Object" then
                    Reset;

                ObjectCodeFilter := GetFilter(Code);
                FilterGroup(100);
                CurrReport.Break;
            end;
        }
        dataitem(PeriodCounter; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_50005; 50005)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // Determinate calculation period range
                /*
                IF Number = 1 THEN
                  CurrPeriodStartingDate := PeriodStartingDate
                ELSE
                  CurrPeriodStartingDate := NextPeriodStartingDate;
                
                NextPeriodStartingDate := CALCDATE(CalcPeriod."Period Length", CurrPeriodStartingDate);
                CurrPeriodEndingDate := NextPeriodStartingDate -1;
                // IF CurrPeriodEndingDate > PeriodEndingDate THEN
                //  CurrPeriodEndingDate := PeriodEndingDate;
                GenPeriodStartingDate := CurrPeriodStartingDate;
                GenPeriodEndingDate := CurrPeriodEndingDate;
                */

                CurrPeriodStartingDate := PeriodStartingDate;
                CurrPeriodEndingDate := PeriodEndingDate;

                // Process current period calculation
                Window.Update(1, StrSubstNo('%1..%2', CurrPeriodStartingDate, CurrPeriodEndingDate));
                Window.Update(2, 0);
                Window.Update(3, 0);
                Window.Update(4, 0);
                ProcessCurrentPeriod;

                // Stop if out of general range
                if NextPeriodStartingDate > PeriodEndingDate then
                    CurrReport.Break;

            end;

            trigger OnPostDataItem()
            begin
                FinalizeCalculation;

                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                // SETRANGE(Number, 1, 500);   // 500 is max iteration count for safety
                SetRange(Number, 1);

                Window.Open(StrSubstNo('%1\%2\%3\%4\%5\%6',
                                       WindowHeaderTxt,
                                       WindowCurrPeriodTxt,
                                       WindowContractTxt,
                                       WindowEPSCardsTxt,
                                       WindowServiceLedgerTxt,
                                       WindowEntryCreationTxt));
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
                    field(PeriodStartingDate; PeriodStartingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
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
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IgnoreLastCalcDate := false;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if (PeriodStartingDate = 0D) or (PeriodEndingDate = 0D) then
            Error(DateIsEmptyErr);

        // IF (CalcPeriodCode = '') THEN
        //   ERROR(CalcPeriodEmptyErr);

        InitCalculation;
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

    local procedure InitCalculation()
    begin
        /*
        CalcPeriod.GET(CalcPeriodCode);
        CalcPeriod.TESTFIELD(Blocked, FALSE);
        CalcPeriod.TESTFIELD("Period Length");
        
        GetInvoiceGroup(InvoiceGroupCode);
        */
        BLSSetup.Get;
        BLSSetup.TestField("Base Calendar Code");

        TempCalcBuffer.Reset;
        TempCalcBuffer.DeleteAll;
        TempQtyBuffer.Reset;
        TempQtyBuffer.DeleteAll;

        LastEntryNo := GetLastCalcEntryNo;
        NextEntryNo := LastEntryNo + 1;
        NextEntryNoBuf := 1;

    end;

    local procedure CustomerInFilter(CustomerNo: Code[20]): Boolean
    begin
        if CustomerNo = '' then
            exit(false);

        CustomerFilter.SetRange("No.", CustomerNo);
        exit(not CustomerFilter.IsEmpty);
    end;

    local procedure ContractInFilter(ContractNo: Code[20]): Boolean
    begin
        if ContractNo = '' then
            exit(ContractUsageMethod in [Contractusagemethod::All, Contractusagemethod::"Without contract"])
        else
            exit(ContractUsageMethod in [Contractusagemethod::All]);
    end;

    local procedure ServiceInFilter(ServiceCode: Code[20]): Boolean
    begin
        if ServiceCode = '' then
            exit(false);

        ServiceFilter.SetRange(Code, ServiceCode);
        exit(not ServiceFilter.IsEmpty);
    end;

    local procedure ObjectInFilter(ObjectCode: Code[20]): Boolean
    begin
        if (ObjectCode = '') then
            exit(ObjectUsageMethod in [Objectusagemethod::All, Objectusagemethod::"Without Object"]);

        ObjectFilter.SetRange(Code, ObjectCode);
        exit(not ObjectFilter.IsEmpty);
    end;

    local procedure InvoiceGroupInFilter(InvGrCode: Code[20]): Boolean
    begin
        if InvoiceGroupCode = '' then
            exit(true);

        exit(InvoiceGroupCode = InvGrCode);
    end;

    local procedure GetInvoiceGroup(InvGrCode: Code[20])
    begin
        /*
        IF InvGrCode = '' THEN BEGIN
          CLEAR(InvoiceGroup);
          EXIT;
        END;
        
        IF InvoiceGroup.Code = InvGrCode THEN
          EXIT;
        
        InvoiceGroup.GET(InvGrCode);
        InvoiceGroup.TESTFIELD(Blocked, FALSE);
        */

    end;

    local procedure GetDayCountByCalendar(CalendarCode: Code[10]; FromDate: Date; ToDate: Date; DayType: Option Calendar,Working): Integer
    var
        CalendarMgmt: Codeunit "Calendar Management";
        AnyText: Text;
        DayCount: Integer;
    begin
        if CalendarCode = '' then
            CalendarCode := BLSSetup."Base Calendar Code";

        if (FromDate = 0D) or (ToDate = 0D) or (FromDate > ToDate) then
            exit(0);

        DayCount := 0;

        case DayType of
            Daytype::Calendar:
                DayCount := ToDate - FromDate + 1;

            Daytype::Working:
                begin
                    //FIXME
                    //while (FromDate <= ToDate) do begin
                    //  if not CalendarMgmt.CheckDateStatus(CalendarCode, FromDate, AnyText) then
                    //    DayCount += 1;

                    //  FromDate += 1;
                end;
        end;
        exit(DayCount);
    end;

    local procedure GetQtyPartialPeriodCorrectionCoef(ServiceCode: Code[20]; FromDate: Date; ToDate: Date): Decimal
    var
        Service: Record "BLS Service";
        Coef: Decimal;
        Days: Integer;
    begin
        if (FromDate = CurrPeriodStartingDate) and (ToDate = CurrPeriodEndingDate) then
            exit(1);

        Service.Get(ServiceCode);

        case Service."Qty. Corr. For Partial Period" of
            Service."qty. corr. for partial period"::"By Calendar Days":
                if CurrPeriodDayCountCalendar = 0 then
                    Coef := 1
                else begin
                    Days := GetDayCountByCalendar('', FromDate, ToDate, 0);
                    Coef := Days / CurrPeriodDayCountCalendar;
                end;
            Service."qty. corr. for partial period"::"By Work Days":
                if CurrPeriodDayCountWorking = 0 then
                    Coef := 1
                else begin
                    Days := GetDayCountByCalendar('', FromDate, ToDate, 1);
                    Coef := Days / CurrPeriodDayCountWorking;
                end;
            else
                Coef := 1;
        end;

        exit(Coef);
    end;

    local procedure GetPricePartialPeriodCorrectionCoef(ServiceCode: Code[20]; FromDate: Date; ToDate: Date; PricePeriod: Integer): Decimal
    var
        Service: Record "BLS Service";
        Coef: Decimal;
        Days: Integer;
    begin
        if (FromDate = CurrPeriodStartingDate) and (ToDate = CurrPeriodEndingDate) then
            exit(1);

        Service.Get(ServiceCode);

        case Service."Price Corr. For Partial Period" of
            Service."price corr. for partial period"::"By Calendar Days":
                if CurrPeriodDayCountCalendar = 0 then
                    Coef := 1
                else begin
                    Days := GetDayCountByCalendar('', FromDate, ToDate, 0);
                    if PricePeriod = 0 then
                        Coef := Days / CurrPeriodDayCountCalendar
                    else
                        Coef := Days / PricePeriod;
                end;
            Service."price corr. for partial period"::"By Work Days":
                if CurrPeriodDayCountWorking = 0 then
                    Coef := 1
                else begin
                    Days := GetDayCountByCalendar('', FromDate, ToDate, 1);
                    if PricePeriod = 0 then
                        Coef := Days / CurrPeriodDayCountWorking
                    else
                        Coef := Days / PricePeriod;
                end;
            else
                Coef := 1;
                if PricePeriod <> 0 then begin
                    Days := GetDayCountByCalendar('', FromDate, ToDate, 0);
                    Coef := Days / PricePeriod;
                end;
        end;

        exit(Coef);
    end;

    local procedure GetLastCalcEntryNo(): Integer
    var
        CalcWrkshtLine: Record "BLS Calculation Worksheet Line";
        CalcLedgEntry: Record "BLS Calculation Ledger Entry";
        EntryNo: Integer;
    begin
        EntryNo := 0;

        CalcWrkshtLine.Reset;
        if CalcWrkshtLine.FindLast then
            EntryNo := CalcWrkshtLine."Entry No.";

        CalcLedgEntry.Reset;
        if CalcLedgEntry.FindLast then
            if EntryNo < CalcLedgEntry."Entry No." then
                EntryNo := CalcLedgEntry."Entry No.";

        exit(EntryNo);
    end;

    local procedure ProcessCurrentPeriod()
    begin
        // Determinate values of current period general variables
        ConfigureCurrentPeriod;
        GenPeriodDayCountCalendar := CurrPeriodDayCountCalendar;
        GenPeriodDayCountWorking := CurrPeriodDayCountWorking;

        // Processing
        ProcessContractsDMS;
        ProcessServiceLedger;
    end;

    local procedure ProcessContractsDMS()
    var
        ContractDMS: Record Contract;
        CP: Integer;
        RC: Integer;
    begin
        if not (ContractUsageMethod in [Contractusagemethod::All, Contractusagemethod::"DMS Contracts Only"]) then
            exit;

        ContractDMS.Reset;
        ContractDMS.CopyFilters(ContractDMSFilter);
        ContractDMS.SetRange("Use For Billing", true);
        ContractDMS.SetRange(Status, ContractDMS.Status::Active);

        if not ContractDMS.Find('-') then
            exit;

        RC := ContractDMS.Count;
        CP := 0;
        repeat
            CP += 1;
            Window.Update(2, ROUND(CP / RC * 10000, 1, '<'));

            ProcessContractDMS(ContractDMS);
        until ContractDMS.Next = 0;
    end;

    local procedure ProcessContractDMS(var ContractDMS: Record Contract)
    var
        ContractService: Record "DMS Contract Line";
        InvoicingPeriod: Record "Payment Terms";
        NextInvoicingDate: Date;
        BLSLeasingScheduleLine: Record "BLS Leasing Schedule Line";
        BLSLeasingScheduleHeader: Record "BLS Leasing Schedule Header";
        BLSCalculationWorksheetLine: Record "BLS Calculation Worksheet Line";
        BLSLeasingShedServiceLine: Record "BLS Leasing Sched. Serv. Line";
        SalesLine: Record "Sales Line";
        SalesInvLine: Record "Sales Invoice Line";

    begin
        ContractDMS.TestField("Bill-to Customer No.");
        if not CustomerInFilter(ContractDMS."Bill-to Customer No.") then
            exit;

        if CalculateServiceInvoices then begin
            // Handle contract lines
            ContractService.Reset;
            ContractService.SetRange("DMS Contract No.", ContractDMS."Contract No.");
            ContractService.SetFilter("Service Code", ServiceCodeFilter);
            case ObjectUsageMethod of
                Objectusagemethod::"With Object":
                    ContractService.SetFilter("Object Code", '<>%1', '');
                Objectusagemethod::"Without Object":
                    ContractService.SetRange("Object Code", '');
            end;
            ContractService.SetFilter("Starting Date", '..%1', CurrPeriodEndingDate);
            if not IgnoreLastCalcDate then
                ContractService.SetFilter("Last Calculation Date", '<%1', CurrPeriodEndingDate);
            ContractService.SetFilter("Ending Date", '%1|%2..', 0D, CurrPeriodStartingDate);
            /*
            ContractService.SETRANGE("Calculation Period Code", CalcPeriodCode);
            IF InvoiceGroupCode <> '' THEN
              ContractService.SETRANGE("Invoice Group Code", InvoiceGroupCode);
            */
            if ContractService.Find('-') then
                repeat
                    ProcessContractServiceDMS(ContractDMS, ContractService)
                /*
                IF (CalcPeriodCode = ContractService."Invoicing Period Code") OR
                   (ContractService."Quantity Source" IN [ContractService."Quantity Source"::"1"])
                THEN
                  ProcessContractService(Contract, ContractService)
                ELSE BEGIN
                  InvoicingPeriod.GET(ContractService."Invoicing Period Code");
                  NextInvoicingDate := GenPeriodStartingDate;
                  IF (GenPeriodStartingDate < ContractService."Starting Date") AND
                     (InvoicingPeriod."Starting Period" = InvoicingPeriod."Starting Period"::"1")
                  THEN
                    NextInvoicingDate := CALCDATE(CalcPeriod."Period Length", NextInvoicingDate);
                  NextInvoicingDate := CALCDATE(InvoicingPeriod."Period Length", NextInvoicingDate);
                  IF NextInvoicingDate < GenPeriodStartingDate THEN
                    EXIT;

                  WHILE (CurrPeriodEndingDate < NextInvoicingDate) DO BEGIN
                    ConfigureCurrentPeriod;
                    ProcessContractService(Contract, ContractService);

                    CurrPeriodStartingDate := CurrPeriodEndingDate +1;
                    CurrPeriodEndingDate := CALCDATE(CalcPeriod."Period Length", CurrPeriodStartingDate) -1;
                  END;

                  RestoreCurrentOnGeneral;
                END;
                */
                until ContractService.Next = 0;
        end;
        if CalculateLeasingInvoices then begin
            BLSLeasingScheduleHeader.Reset();
            BLSLeasingScheduleHeader.SetRange("Contract No.", ContractDMS."Contract No.");
            if BLSLeasingScheduleHeader.FindSet() then
                repeat
                    BLSLeasingScheduleLine.Reset();
                    BLSLeasingScheduleLine.SetRange("Leasing Schedule No.", BLSLeasingScheduleHeader."No.");
                    BLSLeasingScheduleLine.SetFilter("Payment Date", '%1..%2', PeriodStartingDate, PeriodEndingDate);
                    if BLSLeasingScheduleLine.FindSet() then
                        repeat
                            BLSLeasingScheduleLine.CalcFields("Sales Invoice No.");
                            if BLSLeasingScheduleLine."Sales Invoice No." = '' then begin
                                //UpdateCalcBuffer(CustomerNo: Code[20]; CurrencyCode: Code[10]; ContractSource: Option " ",DMS; ContractNo: Code[20]; 
                                //ServiceCode: Code[20]; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; 
                                //FromDate: Date; ToDate: Date; 
                                //QtySource: Integer; Qty: Decimal; BaseQty: Decimal; 
                                //PriceSource: Integer; UnitPrice: Decimal; BaseUnitPrice: Decimal; TotalPrice: Decimal; 
                                //DiscountSource: Integer; DiscountPercent: Decimal; DiscountAmount: Decimal; TotalPriceInclDiscount: Decimal; SpecificSource: Integer; SpecificNo: Code[20]; CustomerPriceGroupCode: Code[10]; CustomerDiscountGroupCode: Code[20]; InvGrCode: Code[20]; DiscountUsage: Integer; GroupID: Integer; ServiceDate: Date; 
                                //VehicleNo: Code[20]): Boolean
                                SalesLine.Reset();
                                SalesLine.SetRange("Leasing Schedule No.", BLSLeasingScheduleLine."Leasing Schedule No.");
                                SalesLine.SetRange("Leasing Schedule Line No.", BLSLeasingScheduleLine."Line No.");
                                SalesInvLine.Reset();
                                SalesInvLine.SetRange("Leasing Schedule No.", BLSLeasingScheduleLine."Leasing Schedule No.");
                                SalesInvLine.SetRange("Leasing Schedule Line No.", BLSLeasingScheduleLine."Line No.");
                                if SalesLine.IsEmpty and SalesInvLine.IsEmpty then
                                    UpdateCalcBuffer(BLSLeasingScheduleHeader."Customer No.", BLSLeasingScheduleHeader."Currency Code", 1, ContractDMS."Contract No.",
                                            BLSLeasingScheduleHeader."Leasing Service Code", '', '',
                                            0D, 0D,
                                            1, 1, 1,
                                            1, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, '', '', '', '', 0, 0, 0D,
                                            BLSLeasingScheduleHeader."Vehicle Serial No.", BLSCalculationWorksheetLine."Line type"::"Lease Schedule",
                                            BLSLeasingScheduleLine."Base Amount", BLSLeasingScheduleLine."Interest Amount",
                                            BLSLeasingScheduleLine."Base Amount" + BLSLeasingScheduleLine."Interest Amount", BLSLeasingScheduleHeader."No.", BLSLeasingScheduleLine."Line No.", 0);


                                BLSLeasingShedServiceLine.Reset();
                                BLSLeasingShedServiceLine.SetRange("Leasing Schedule No.", BLSLeasingScheduleHeader."No.");
                                BLSLeasingShedServiceLine.SetFilter("Starting Date", '..%1|%2', BLSLeasingScheduleLine."Payment Date", 0D);
                                BLSLeasingShedServiceLine.SetFilter("Ending Date", '%1..|%2', BLSLeasingScheduleLine."Payment Date", 0D);
                                if BLSLeasingShedServiceLine.FindSet() then
                                    repeat
                                        UpdateCalcBuffer(BLSLeasingScheduleHeader."Customer No.", BLSLeasingScheduleHeader."Currency Code", 1, ContractDMS."Contract No.",
                                                    BLSLeasingScheduleHeader."Leasing Service Code", '', '',
                                                    0D, 0D,
                                                    1, 1, 1,
                                                    1, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, '', '', '', '', 0, 0, 0D,
                                                    BLSLeasingScheduleHeader."Vehicle Serial No.", BLSCalculationWorksheetLine."Line type"::Services,
                                                    0, 0,
                                                    0, BLSLeasingScheduleHeader."No.", 0, BLSLeasingShedServiceLine.Price)
                                    until BLSLeasingShedServiceLine.Next() = 0;
                            end;
                        until BLSLeasingScheduleLine.Next() = 0;
                until BLSLeasingScheduleHeader.Next() = 0;


        end

    end;

    local procedure ProcessContractServiceDMS(var Contract: Record Contract; var ContractService: Record "DMS Contract Line")
    var
        ServiceLedgEntry: Record "BLS Ledger Entry";
        ServiceLedgEntry2: Record "BLS Ledger Entry";
        CalcFromDate: Date;
        CalcToDate: Date;
        CalcPrice: Decimal;
        CalcQty: Decimal;
        BasePrice: Decimal;
        BaseQty: Decimal;
        x: Decimal;
        BLSCalculationWorksheetLine: Record "BLS Calculation Worksheet Line";
        Ishandled: Boolean;
    begin
        if not ServiceInFilter(ContractService."Service Code") then
            exit;
        if not ObjectInFilter(ContractService."Object Code") then
            exit;

        CalcFromDate := CurrPeriodStartingDate;
        CalcToDate := CurrPeriodEndingDate;
        if CalcFromDate < ContractService."Starting Date" then
            CalcFromDate := ContractService."Starting Date";
        if (CalcToDate > ContractService."Ending Date") and (ContractService."Ending Date" <> 0D) then
            CalcToDate := ContractService."Ending Date";
        if (CalcFromDate > CalcToDate) then
            exit;
        OnBeforeProcessContractServiceDMS(Contract, ContractService, CalcFromDate, CalcToDate, Ishandled);
        if Ishandled then
            exit;
        CalcPrice := 0;
        BasePrice := 0;
        if ContractService."Price Source" = ContractService."price source"::Contract then begin
            ContractService.TestField(Price);
            CalcPrice := ContractService.Price * GetPricePartialPeriodCorrectionCoef(ContractService."Service Code", CalcFromDate, CalcToDate, 0);
            BasePrice := ContractService.Price;
        end;

        case ContractService."Quantity Source" of
            ContractService."quantity source"::Contract:
                begin
                    ContractService.TestField(Quantity);
                    if UpdateCalcBuffer(Contract."Bill-to Customer No.", Contract."Currency Code", 1, Contract."Contract No.",
                                        ContractService."Service Code", '', ContractService."Object Code",
                                        CalcFromDate, CalcToDate,
                                        1, ContractService.Quantity * GetQtyPartialPeriodCorrectionCoef(ContractService."Service Code", CalcFromDate, CalcToDate), ContractService.Quantity,
                                        ContractService."Price Source" + 1, CalcPrice, BasePrice, 0, 0, 0, 0, 0,
                                        0, '', '', '', ContractService."Invoice Group Code", ContractService."Discount Usage", 0, 0D, ContractService."Vehicle Serial No.", BLSCalculationWorksheetLine."Line type"::Services,
                                        0, 0, 0, '', 0, 0)
                    then
                        SetLastCalcDateOnContractServiceDMS(ContractService);
                end;

            ContractService."quantity source"::"Service Ledger":
                begin
                    ServiceLedgEntry.Reset;
                    ServiceLedgEntry.SetRange("Posting Date", CalcFromDate, CalcToDate);
                    ServiceLedgEntry.SetRange("Calculation Ledger Entry No.", 0);
                    ServiceLedgEntry.SetRange("Contract No.", Contract."Contract No.");
                    ServiceLedgEntry.SetRange("Customer No.", Contract."Bill-to Customer No.");
                    ServiceLedgEntry.SetRange("Service Code", ContractService."Service Code");
                    ServiceLedgEntry.SetRange("Entry Type", ServiceLedgEntry."entry type"::Sale);
                    ServiceLedgEntry.SetRange(Correction, false);
                    // TESTFIELD("Object Code");
                    ServiceLedgEntry.SetRange("Object Code", ContractService."Object Code");

                    if ServiceLedgEntry.Find('-') then begin
                        if ContractService."Price Source" = ContractService."price source"::"Service Ledger" then begin
                            repeat
                                if UpdateCalcBuffer(Contract."Bill-to Customer No.", Contract."Currency Code", 1, Contract."Contract No.",
                                                    ContractService."Service Code", ServiceLedgEntry."Service Variant Code", ServiceLedgEntry."Object Code",
                                                    CalcFromDate, CalcToDate,
                                                    2, ServiceLedgEntry.Quantity, ServiceLedgEntry.Quantity,
                                                    2, ServiceLedgEntry."Unit Price", ServiceLedgEntry."Unit Price", ServiceLedgEntry."Total Price",
                                                    2, ServiceLedgEntry."Discount, %", ServiceLedgEntry."Discount Amount",
                                                    ServiceLedgEntry."Total Price Incl. Discount",
                                                    0, '',
                                                    ServiceLedgEntry."Customer Price Group", ServiceLedgEntry."Customer Discount Group",
                                                    ContractService."Invoice Group Code", ContractService."Discount Usage", ServiceLedgEntry."Entry No.", ServiceLedgEntry."Posting Date",
                                                    ServiceLedgEntry."Vehicle Serial No.", BLSCalculationWorksheetLine."Line type"::Services,
                                                    0, 0, 0, '', 0, 0)
                                then begin
                                    ServiceLedgEntry2.Get(ServiceLedgEntry."Entry No.");
                                    ServiceLedgEntry2."Calculation Ledger Entry No." := TempCalcBuffer."Calculation Ledger Entry No.";
                                    ServiceLedgEntry2.Modify;
                                end;
                            until ServiceLedgEntry.Next = 0;
                        end else begin
                            repeat
                                if UpdateCalcBuffer(Contract."Bill-to Customer No.", Contract."Currency Code", 1, Contract."Contract No.",
                                                    ContractService."Service Code", ServiceLedgEntry."Service Variant Code", ServiceLedgEntry."Object Code",
                                                    CalcFromDate, CalcToDate,
                                                    2, ServiceLedgEntry.Quantity, ServiceLedgEntry.Quantity,
                                                    1, ServiceLedgEntry."Unit Price", ServiceLedgEntry."Unit Price", 0,
                                                    0, 0, 0,
                                                    0,
                                                    0, '',
                                                    ServiceLedgEntry."Customer Price Group", ServiceLedgEntry."Customer Discount Group",
                                                    ContractService."Invoice Group Code", ContractService."Discount Usage", ServiceLedgEntry."Entry No.", ServiceLedgEntry."Posting Date",
                                                    ServiceLedgEntry."Vehicle Serial No.", BLSCalculationWorksheetLine."Line type"::Services,
                                                    0, 0, 0, '', 0, 0)
                                then begin
                                    ServiceLedgEntry2.Get(ServiceLedgEntry."Entry No.");
                                    ServiceLedgEntry2."Calculation Ledger Entry No." := TempCalcBuffer."Calculation Ledger Entry No.";
                                    ServiceLedgEntry2.Modify;
                                end;
                            until ServiceLedgEntry.Next = 0;
                        end;

                        SetLastCalcDateOnContractServiceDMS(ContractService);
                    end;
                end;

            ContractService."quantity source"::"Service Default":
                begin
                    BLSMgt.GetServiceDefaultQty(ContractService."Service Code", '', ContractService."Object Code", CalcFromDate, BaseQty, x, x);
                    CalcQty := BaseQty * GetPricePartialPeriodCorrectionCoef(ContractService."Service Code", CalcFromDate, CalcToDate, 0);
                    if UpdateCalcBuffer(Contract."Bill-to Customer No.", Contract."Currency Code", 1, Contract."Contract No.",
                                        ContractService."Service Code", '', ContractService."Object Code",
                                        CalcFromDate, CalcToDate,
                                        3, CalcQty, BaseQty,
                                        1, CalcPrice, BasePrice, 0, 0, 0, 0, 0,
                                        0, '', '', '', ContractService."Invoice Group Code", ContractService."Discount Usage", 0, 0D,
                                        ContractService."Vehicle Serial No.", BLSCalculationWorksheetLine."Line type"::Services,
                                        0, 0, 0, '', 0, 0)
                    then
                        SetLastCalcDateOnContractServiceDMS(ContractService);
                end;
        end;
    end;

    local procedure SetLastCalcDateOnContractServiceDMS(ContractService: Record "DMS Contract Line")
    var
        ContractService2: Record "DMS Contract Line";
    begin
        ContractService2.Get(ContractService."DMS Contract No.", ContractService."Service Code",
                             ContractService."Object Code", ContractService."Vehicle Serial No.", ContractService."Starting Date");
        if ContractService2."Last Calculation Date" < CurrPeriodEndingDate then
            ContractService2."Last Calculation Date" := CurrPeriodEndingDate;
        ContractService2.Modify;
    end;

    local procedure ConfigureCurrentPeriod()
    begin
        CurrPeriodDayCountCalendar := GetDayCountByCalendar('', CurrPeriodStartingDate, CurrPeriodEndingDate, 0);
        CurrPeriodDayCountWorking := GetDayCountByCalendar('', CurrPeriodStartingDate, CurrPeriodEndingDate, 1);
    end;

    local procedure RestoreCurrentOnGeneral()
    begin
        CurrPeriodStartingDate := GenPeriodStartingDate;
        CurrPeriodEndingDate := GenPeriodEndingDate;
        CurrPeriodDayCountCalendar := GenPeriodDayCountCalendar;
        CurrPeriodDayCountWorking := GenPeriodDayCountWorking;
    end;

    local procedure ProcessServiceLedger()
    var
        ServiceLedgEntry: Record "BLS Ledger Entry";
        ServiceLedgEntry2: Record "BLS Ledger Entry";
        CP: Integer;
        RC: Integer;
        BLSCalculationWorksheetLine: Record "BLS Calculation Worksheet Line";
    begin
        ServiceLedgEntry.Reset;
        ServiceLedgEntry.SetRange("Posting Date", CurrPeriodStartingDate, CurrPeriodEndingDate);
        ServiceLedgEntry.SetRange("Calculation Ledger Entry No.", 0);
        ServiceLedgEntry.SetRange(Correction, false);

        case ContractUsageMethod of
            Contractusagemethod::"Contracts Only":
                ServiceLedgEntry.SetFilter("Contract No.", '<>%1', '');
            Contractusagemethod::"Without contract":
                ServiceLedgEntry.SetRange("Contract No.", '');
        end;

        case ObjectUsageMethod of
            Objectusagemethod::"With Object":
                ServiceLedgEntry.SetFilter("Object Code", '<>%1', '');
            Objectusagemethod::"Without Object":
                ServiceLedgEntry.SetRange("Object Code", '');
        end;

        if not ServiceLedgEntry.Find('-') then
            exit;

        RC := ServiceLedgEntry.Count;
        CP := 0;

        repeat
            if UpdateCalcBuffer(ServiceLedgEntry."Customer No.", ServiceLedgEntry."Currency Code", 1, ServiceLedgEntry."Contract No.",
                            ServiceLedgEntry."Service Code", ServiceLedgEntry."Service Variant Code", ServiceLedgEntry."Object Code",
                            CurrPeriodStartingDate, CurrPeriodEndingDate,
                            2, ServiceLedgEntry.Quantity, ServiceLedgEntry.Quantity,
                            2, ServiceLedgEntry."Unit Price", ServiceLedgEntry."Unit Price", ServiceLedgEntry."Total Price",
                            2, ServiceLedgEntry."Discount, %", ServiceLedgEntry."Discount Amount", ServiceLedgEntry."Total Price Incl. Discount",
                            0, '', ServiceLedgEntry."Customer Price Group", ServiceLedgEntry."Customer Discount Group", '', 2,
                            ServiceLedgEntry."Entry No.", ServiceLedgEntry."Posting Date",
                            ServiceLedgEntry."Vehicle Serial No.", BLSCalculationWorksheetLine."Line Type"::Services,
                            0, 0, 0, '', 0, 0)
            then begin
                ServiceLedgEntry2.Get(ServiceLedgEntry."Entry No.");
                ServiceLedgEntry2."Calculation Ledger Entry No." := TempCalcBuffer."Calculation Ledger Entry No.";
                ServiceLedgEntry2.Modify;
            end;

            CP += 1;
            Window.Update(4, ROUND(CP / RC * 10000, 1, '<'));
        until ServiceLedgEntry.Next = 0;
    end;

    local procedure UpdateCalcBuffer(CustomerNo: Code[20]; CurrencyCode: Code[10]; ContractSource: Option " ",DMS; ContractNo: Code[20]; ServiceCode: Code[20];
                    ServiceVariantCode: Code[20]; ObjectCode: Code[20]; FromDate: Date; ToDate: Date; QtySource: Integer; Qty: Decimal; BaseQty: Decimal;
                    PriceSource: Integer; UnitPrice: Decimal; BaseUnitPrice: Decimal; TotalPrice: Decimal; DiscountSource: Integer; DiscountPercent: Decimal;
                    DiscountAmount: Decimal; TotalPriceInclDiscount: Decimal; SpecificSource: Integer; SpecificNo: Code[20]; CustomerPriceGroupCode: Code[10];
                    CustomerDiscountGroupCode: Code[20]; InvGrCode: Code[20]; DiscountUsage: Integer; GroupID: Integer; ServiceDate: Date; VehicleNo: Code[20]; LineType: Integer;
                                      LeaseBase: Decimal; LeaseInterest: Decimal; LeaseTotal: Decimal; LeaseScheduleNo: Code[20]; LeaseScheduleLineNo: Integer;
                                      AddServAmt: Decimal): Boolean
    var
        Service: Record "BLS Service";
    begin
        if (ServiceCode = '') or (CustomerNo = '') then
            exit;
        if not ObjectInFilter(ObjectCode) then
            exit(false);

        if Service.Code <> ServiceCode then
            Service.Get(ServiceCode);
        if Service."Without Invoicing" then
            exit;
        // Clear parameter to consolidate records. Example: clear Service Variant Code or Price to compbine in one row
        if Service."Calculate Average Price" = Service."calculate average price"::"On Calculation" then begin
            UnitPrice := 0;
            BaseUnitPrice := 0;
            DiscountPercent := 0;
            CustomerPriceGroupCode := '';
            CustomerDiscountGroupCode := '';
        end;

        if not Service."Separate Entries" then begin
            GroupID := 0;
            ServiceDate := 0D;
        end;

        /*
        IF UnitPrice <> 0 THEN
          CustomerPriceGroupCode := '';
        IF DiscountPercent <> 0 THEN
          CustomerDiscountGroupCode := '';
        */

        if Service."Combine Service Variants" = Service."combine service variants"::"On Calculation" then
            ServiceVariantCode := '';

        if Service."Combine Objects" = Service."combine objects"::"On Calculation" then
            ObjectCode := '';

        /*
        IF (SpecificSource = SourceEPSCard) AND
           (Service."Combine EPS Cards" = Service."Combine EPS Cards"::"1")
        THEN
          SpecificNo := '';
        */
        // Looking for buffer entry to update
        TempCalcBuffer.Reset;
        TempCalcBuffer.SetRange("Customer No.", CustomerNo);
        TempCalcBuffer.SetRange("Currency Code", CurrencyCode);
        TempCalcBuffer.SetRange("Contract No.", ContractNo);
        TempCalcBuffer.SetRange("Calculation Period Code", CalcPeriodCode);
        TempCalcBuffer.SetRange("Period Starting Date", CurrPeriodStartingDate);
        TempCalcBuffer.SetRange("Period Ending Date", CurrPeriodEndingDate);
        TempCalcBuffer.SetRange("Starting Date", FromDate);
        TempCalcBuffer.SetRange("Ending Date", ToDate);

        TempCalcBuffer.SetRange("Service Code", ServiceCode);
        TempCalcBuffer.SetRange("Service Variant Code", ServiceVariantCode);
        TempCalcBuffer.SetRange("Object Code", ObjectCode);

        TempCalcBuffer.SetRange("Quantity Source", QtySource);
        TempCalcBuffer.SetRange("Price Source", PriceSource);
        TempCalcBuffer.SetRange("Discount Source", DiscountSource);

        TempCalcBuffer.SetRange("Unit Price", UnitPrice);
        TempCalcBuffer.SetRange("Base Unit Price", BaseUnitPrice);
        TempCalcBuffer.SetRange("Discount, %", DiscountPercent);

        TempCalcBuffer.SetRange("Specific Source", SpecificSource);
        TempCalcBuffer.SetRange("Specific No.", SpecificNo);

        TempCalcBuffer.SetRange("Customer Price Group", CustomerPriceGroupCode);
        TempCalcBuffer.SetRange("Customer Discount Group", CustomerDiscountGroupCode);
        TempCalcBuffer.SetRange("Discount Usage", DiscountUsage);

        TempCalcBuffer.SetRange("Grouping ID", GroupID);
        TempCalcBuffer.SetRange("Vehicle Serial No.", VehicleNo);

        if not TempCalcBuffer.FindFirst then begin
            TempCalcBuffer.Init;
            TempCalcBuffer."Entry No." := NextEntryNoBuf;
            NextEntryNoBuf += 1;

            TempCalcBuffer."Customer No." := CustomerNo;
            TempCalcBuffer."Currency Code" := CurrencyCode;
            TempCalcBuffer."Contract No." := ContractNo;
            TempCalcBuffer."Calculation Period Code" := CalcPeriodCode;
            TempCalcBuffer."Period Starting Date" := CurrPeriodStartingDate;
            TempCalcBuffer."Period Ending Date" := CurrPeriodEndingDate;
            TempCalcBuffer."Starting Date" := FromDate;
            TempCalcBuffer."Ending Date" := ToDate;

            TempCalcBuffer."Service Group Code" := Service."Service Group Code";
            TempCalcBuffer."Service Code" := ServiceCode;
            TempCalcBuffer."Service Variant Code" := ServiceVariantCode;
            TempCalcBuffer."Object Code" := ObjectCode;

            TempCalcBuffer."Quantity Source" := QtySource;
            TempCalcBuffer."Price Source" := PriceSource;
            TempCalcBuffer."Discount Source" := DiscountSource;

            TempCalcBuffer."Customer Price Group" := CustomerPriceGroupCode;
            TempCalcBuffer."Customer Discount Group" := CustomerDiscountGroupCode;

            TempCalcBuffer."Unit Price" := UnitPrice;
            TempCalcBuffer."Base Unit Price" := BaseUnitPrice;
            TempCalcBuffer."Discount, %" := DiscountPercent;
            TempCalcBuffer."Line Type" := LineType;
            if TempCalcBuffer."Discount, %" = 0 then
                TempCalcBuffer."Base Unit Price Incl. Discount" := TempCalcBuffer."Base Unit Price"
            else
                TempCalcBuffer."Base Unit Price Incl. Discount" := ROUND(TempCalcBuffer."Base Unit Price" * (100 - TempCalcBuffer."Discount, %") / 100);

            TempCalcBuffer."Specific Source" := SpecificSource;
            TempCalcBuffer."Specific No." := SpecificNo;
            TempCalcBuffer."Discount Usage" := DiscountUsage;

            TempCalcBuffer."Grouping ID" := GroupID;
            TempCalcBuffer."BLS Service Ledger Entry No." := GroupID;
            TempCalcBuffer."Service Date" := ServiceDate;
            TempCalcBuffer."Vehicle Serial No." := VehicleNo;
            TempCalcBuffer."Lease Base Amount" := LeaseBase;
            TempCalcBuffer."Lease Interest Amount" := LeaseInterest;
            TempCalcBuffer."Lease Total Amount" := LeaseTotal;
            TempCalcBuffer."Leasing Schedule No." := LeaseScheduleNo;
            TempCalcBuffer."Leasing Schedule Line No." := LeaseScheduleLineNo;
            TempCalcBuffer."Additional Service Amount" := AddServAmt;
            TempCalcBuffer."Skip Entry" := not (ContractInFilter(ContractNo) and CustomerInFilter(CustomerNo) and ServiceInFilter(ServiceCode));
            if not TempCalcBuffer."Skip Entry" then begin
                TempCalcBuffer."Calculation Ledger Entry No." := NextEntryNo;
                NextEntryNo += 1;
            end;

            TempCalcBuffer.Insert;
        end;

        if TempCalcBuffer."Skip Entry" then
            exit(false);

        // Update buffer entry
        if TotalPrice = 0 then begin
            TotalPrice := Qty * UnitPrice;
            if DiscountPercent <> 0 then
                DiscountAmount := ROUND(TotalPrice * DiscountPercent / 100)
            else
                DiscountAmount := 0;
            TotalPriceInclDiscount := TotalPrice - DiscountAmount;
        end;

        TempCalcBuffer.Quantity := Qty;
        TempCalcBuffer."Total Price" += TotalPrice;
        TempCalcBuffer."Discount Amount" += DiscountAmount;
        TempCalcBuffer."Total Price Incl. Discount" += TotalPriceInclDiscount;
        TempCalcBuffer."Additional Service Amount" += AddServAmt;

        if Service."Calculate Average Price" = Service."calculate average price"::"On Calculation" then begin
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

        // Clear parameter to consolidate records. Example: clear Service Variant Code or Price to compbine in one row
        if (SpecificSource = 1) then begin
            SpecificNo := '';
            ServiceVariantCode := '';
        end;

        // Looking for buffer entry to update
        TempQtyBuffer.Reset;
        TempQtyBuffer.SetRange("Customer No.", CustomerNo);
        TempQtyBuffer.SetRange("Currency Code", CurrencyCode);
        TempQtyBuffer.SetRange("Contract No.", ContractNo);
        TempQtyBuffer.SetRange("Calculation Period Code", CalcPeriodCode);
        TempQtyBuffer.SetRange("Period Starting Date", CurrPeriodStartingDate);
        TempQtyBuffer.SetRange("Period Ending Date", CurrPeriodEndingDate);
        // SETRANGE("Starting Date", FromDate);
        // SETRANGE("Ending Date", ToDate);

        TempQtyBuffer.SetRange("Service Code", ServiceCode);
        TempQtyBuffer.SetRange("Service Variant Code", ServiceVariantCode);
        TempQtyBuffer.SetRange("Object Code", ObjectCode);

        TempQtyBuffer.SetRange("Quantity Source", QtySource);
        TempQtyBuffer.SetRange("Price Source", PriceSource);
        TempQtyBuffer.SetRange("Discount Source", DiscountSource);

        TempQtyBuffer.SetRange("Unit Price", UnitPrice);
        TempQtyBuffer.SetRange("Base Unit Price", BaseUnitPrice);
        TempQtyBuffer.SetRange("Discount, %", DiscountPercent);

        TempQtyBuffer.SetRange("Specific Source", SpecificSource);
        TempQtyBuffer.SetRange("Specific No.", SpecificNo);

        TempQtyBuffer.SetRange("Customer Price Group", CustomerPriceGroupCode);
        TempQtyBuffer.SetRange("Customer Discount Group", CustomerDiscountGroupCode);
        TempQtyBuffer.SetRange("Discount Usage", DiscountUsage);

        if not TempQtyBuffer.FindFirst then begin
            TempQtyBuffer.Init;
            TempQtyBuffer."Entry No." := NextEntryNoBuf;
            NextEntryNoBuf += 1;

            TempQtyBuffer."Customer No." := CustomerNo;
            TempQtyBuffer."Currency Code" := CurrencyCode;
            TempQtyBuffer."Contract No." := ContractNo;
            TempQtyBuffer."Calculation Period Code" := CalcPeriodCode;
            TempQtyBuffer."Period Starting Date" := CurrPeriodStartingDate;
            TempQtyBuffer."Period Ending Date" := CurrPeriodEndingDate;
            TempQtyBuffer."Starting Date" := CurrPeriodStartingDate;
            TempQtyBuffer."Ending Date" := CurrPeriodEndingDate;

            TempQtyBuffer."Service Group Code" := Service."Service Group Code";
            TempQtyBuffer."Service Code" := ServiceCode;
            TempQtyBuffer."Service Variant Code" := ServiceVariantCode;
            TempQtyBuffer."Object Code" := ObjectCode;

            TempQtyBuffer."Quantity Source" := QtySource;
            TempQtyBuffer."Price Source" := PriceSource;
            TempQtyBuffer."Discount Source" := DiscountSource;

            TempQtyBuffer."Customer Price Group" := CustomerPriceGroupCode;
            TempQtyBuffer."Customer Discount Group" := CustomerDiscountGroupCode;

            TempQtyBuffer."Unit Price" := UnitPrice;
            TempQtyBuffer."Base Unit Price" := BaseUnitPrice;
            TempQtyBuffer."Discount, %" := DiscountPercent;
            if TempQtyBuffer."Discount, %" = 0 then
                TempQtyBuffer."Base Unit Price Incl. Discount" := TempQtyBuffer."Base Unit Price"
            else
                TempQtyBuffer."Base Unit Price Incl. Discount" := ROUND(TempQtyBuffer."Base Unit Price" * (100 - TempQtyBuffer."Discount, %") / 100);

            TempQtyBuffer."Specific Source" := SpecificSource;
            TempQtyBuffer."Specific No." := SpecificNo;
            TempQtyBuffer."Discount Usage" := DiscountUsage;
            TempQtyBuffer."Lease Base Amount" := LeaseBase;
            TempQtyBuffer."Lease Interest Amount" := LeaseInterest;
            TempQtyBuffer."Lease Total Amount" := LeaseTotal;
            TempQtyBuffer."Additional Service Amount" := AddServAmt;
            TempQtyBuffer.Insert;
        end;

        // Update buffer entry
        TempQtyBuffer.Quantity := Qty;
        TempQtyBuffer.Modify;

        exit(true);

    end;

    local procedure FinalizeCalculation()
    var
        CalcWorkSheetLine: Record "BLS Calculation Worksheet Line";
        Contract: Record Contract;
        Vehicle: Record Vehicle;
        NewPrice: Decimal;
        NewDiscount: Decimal;
        QtyForPD: Decimal;
        FaultReason: Option " ","1","2","3","4","5","6";
        CP: Integer;
        RC: Integer;
        LookingForPrice: Boolean;
        LookingForDiscount: Boolean;
    begin
        TempCalcBuffer.Reset;
        TempCalcBuffer.SetRange("Skip Entry", true);
        TempCalcBuffer.DeleteAll;
        TempCalcBuffer.Reset;

        if TempCalcBuffer.IsEmpty then
            exit;

        RC := TempCalcBuffer.Count;
        CP := 0;
        TempCalcBuffer.Find('-');

        repeat
            CalcWorkSheetLine.Init;
            CalcWorkSheetLine.TransferFields(TempCalcBuffer);
            CalcWorkSheetLine."Entry No." := TempCalcBuffer."Calculation Ledger Entry No.";
            CalcWorkSheetLine.Validate("Customer No.");
            CalcWorkSheetLine.Validate("Service Code");
            CalcWorkSheetLine.Validate("Object Code");

            LookingForPrice := (CalcWorkSheetLine."Unit Price" = 0) and
                               ((CalcWorkSheetLine."Price Source" <> CalcWorkSheetLine."price source"::Specific) or (CalcWorkSheetLine."Discount, %" = 0));
            LookingForDiscount := (CalcWorkSheetLine."Discount, %" = 0) and (CalcWorkSheetLine."Discount Usage" <> CalcWorkSheetLine."discount usage"::" ");

            QtyForPD := 0;
            if LookingForPrice or LookingForDiscount then
                QtyForPD := GetQtyForPriceDiscount(CalcWorkSheetLine."Customer No.", CalcWorkSheetLine."Currency Code", CalcWorkSheetLine."Contract No.",
                                                   CalcWorkSheetLine."Service Code", CalcWorkSheetLine."Service Variant Code", CalcWorkSheetLine."Object Code",
                                                    CalcWorkSheetLine."Starting Date", CalcWorkSheetLine."Ending Date", CalcWorkSheetLine."Period Starting Date", CalcWorkSheetLine."Period Ending Date",
                                                    CalcWorkSheetLine."Quantity Source",
                                                    CalcWorkSheetLine."Price Source", CalcWorkSheetLine."Unit Price",
                                                    CalcWorkSheetLine."Discount Source", CalcWorkSheetLine."Discount, %",
                                                    CalcWorkSheetLine."Specific Source", CalcWorkSheetLine."Specific No.", CalcWorkSheetLine."Customer Price Group", CalcWorkSheetLine."Customer Discount Group",
                                                    CalcWorkSheetLine."Invoice Group Code", CalcWorkSheetLine."Discount Usage");

            if CalcWorkSheetLine."Contract No." <> '' then begin
                if LookingForPrice then begin
                    BLSMgt.GetServiceContractPrice(CalcWorkSheetLine."Contract No.", CalcWorkSheetLine."Service Code", CalcWorkSheetLine."Service Variant Code", CalcWorkSheetLine."Object Code",
                                                   CalcWorkSheetLine."Vehicle Serial No.", CalcWorkSheetLine."Customer Price Group", CalcWorkSheetLine."Starting Date",
                                                   QtyForPD, NewPrice, FaultReason);
                    if FaultReason = Faultreason::" " then begin
                        CalcWorkSheetLine.Validate("Unit Price", NewPrice);
                        LookingForPrice := false;
                    end;
                end;

                if LookingForDiscount then begin
                    if BLSMgt.GetServiceContractDiscount(CalcWorkSheetLine."Contract No.", CalcWorkSheetLine."Service Code", CalcWorkSheetLine."Service Variant Code", CalcWorkSheetLine."Object Code",
                                                         CalcWorkSheetLine."Customer Discount Group", CalcWorkSheetLine."Starting Date",
                                                         QtyForPD, NewDiscount)
                    then begin
                        CalcWorkSheetLine.Validate("Discount, %", NewDiscount);
                        LookingForDiscount := false;
                    end;
                end;
                if Contract.Get(CalcWorkSheetLine."Contract No.") then
                    CalcWorkSheetLine."External Contract No." := Contract."External Contract No.";
            end;

            if LookingForPrice then
                if BLSMgt.GetServiceStandardPrice(CalcWorkSheetLine."Service Code", CalcWorkSheetLine."Service Variant Code", CalcWorkSheetLine."Object Code",
                                                  CalcWorkSheetLine."Customer No.", CalcWorkSheetLine."Customer Price Group", CalcWorkSheetLine."Starting Date",
                                                  CalcWorkSheetLine."Currency Code", QtyForPD, NewPrice)
                then begin
                    CalcWorkSheetLine.Validate("Unit Price", NewPrice * GetPricePartialPeriodCorrectionCoef(CalcWorkSheetLine."Service Code", CalcWorkSheetLine."Starting Date", CalcWorkSheetLine."Ending Date", 0));
                    CalcWorkSheetLine.Validate("Base Unit Price", NewPrice);
                end;

            if LookingForDiscount and (CalcWorkSheetLine."Discount Usage" = CalcWorkSheetLine."discount usage"::All) then
                if BLSMgt.GetServiceStandardDiscount(CalcWorkSheetLine."Service Code", CalcWorkSheetLine."Service Variant Code", CalcWorkSheetLine."Object Code",
                                                     CalcWorkSheetLine."Customer No.", CalcWorkSheetLine."Customer Discount Group", CalcWorkSheetLine."Starting Date",
                                                     CalcWorkSheetLine."Currency Code", QtyForPD, NewDiscount)
                then
                    CalcWorkSheetLine.Validate("Discount, %", NewDiscount);

            if CalcWorkSheetLine."Discount, %" = 0 then
                CalcWorkSheetLine."Base Unit Price Incl. Discount" := CalcWorkSheetLine."Base Unit Price"
            else
                CalcWorkSheetLine."Base Unit Price Incl. Discount" := ROUND(CalcWorkSheetLine."Base Unit Price" * (100 - CalcWorkSheetLine."Discount, %") / 100);

            CalcWorkSheetLine.Insert;

            CP += 1;
            Window.Update(5, ROUND(CP / RC * 10000, 1, '<'));

        until TempCalcBuffer.Next = 0;
    end;

    local procedure GetQtyForPriceDiscount(CustomerNo: Code[20]; CurrencyCode: Code[10]; ContractNo: Code[20]; ServiceCode: Code[20]; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; FromDate: Date; ToDate: Date; PeriodFromDate: Date; PeriodToDate: Date; QtySource: Integer; PriceSource: Integer; UnitPrice: Decimal; DiscountSource: Integer; DiscountPercent: Decimal; SpecificSource: Integer; SpecificNo: Code[20]; CustomerPriceGroupCode: Code[10]; CustomerDiscountGroupCode: Code[20]; InvGrCode: Code[20]; DiscountUsage: Integer): Decimal
    var
        Service: Record "BLS Service";
        CalcLedgEntry: Record "BLS Calculation Ledger Entry";
        CalcWorksheetLine: Record "BLS Calculation Worksheet Line";
    begin
        if (ServiceCode = '') or (CustomerNo = '') then
            exit(0);

        if (SpecificSource = 1) then begin
            FromDate := PeriodFromDate;
            ToDate := PeriodToDate;
        end;

        // Looking for buffer entry to update
        TempQtyBuffer.Reset;
        TempQtyBuffer.SetRange("Customer No.", CustomerNo);
        TempQtyBuffer.SetRange("Currency Code", CurrencyCode);
        TempQtyBuffer.SetRange("Contract No.", ContractNo);
        TempQtyBuffer.SetRange("Calculation Period Code", CalcPeriodCode);
        TempQtyBuffer.SetRange("Period Starting Date", PeriodFromDate);
        TempQtyBuffer.SetRange("Period Ending Date", PeriodToDate);
        // SETRANGE("Starting Date", FromDate);
        // SETRANGE("Ending Date", ToDate);

        TempQtyBuffer.SetRange("Service Code", ServiceCode);
        if (SpecificSource <> 1) then
            TempQtyBuffer.SetRange("Service Variant Code", ServiceVariantCode);
        TempQtyBuffer.SetRange("Object Code", ObjectCode);

        TempQtyBuffer.SetRange("Quantity Source", QtySource);
        TempQtyBuffer.SetRange("Price Source", PriceSource);
        TempQtyBuffer.SetRange("Discount Source", DiscountSource);

        // SETRANGE("Unit Price", UnitPrice);
        // SETRANGE("Discount, %", DiscountPercent);

        TempQtyBuffer.SetRange("Specific Source", SpecificSource);
        if (SpecificSource <> 1) then
            TempQtyBuffer.SetRange("Specific No.", SpecificNo);

        TempQtyBuffer.SetRange("Customer Price Group", CustomerPriceGroupCode);
        TempQtyBuffer.SetRange("Customer Discount Group", CustomerDiscountGroupCode);
        TempQtyBuffer.SetRange("Discount Usage", DiscountUsage);

        TempQtyBuffer.CalcSums(Quantity);

        // Looking for buffer entry to update
        CalcWorksheetLine.Reset;
        CalcWorksheetLine.SetFilter("Entry No.", '..%1', LastEntryNo);
        CalcWorksheetLine.SetRange("Customer No.", CustomerNo);
        CalcWorksheetLine.SetRange("Currency Code", CurrencyCode);
        CalcWorksheetLine.SetRange("Contract No.", ContractNo);
        CalcWorksheetLine.SetRange("Calculation Period Code", CalcPeriodCode);
        CalcWorksheetLine.SetRange("Period Starting Date", PeriodFromDate);
        CalcWorksheetLine.SetRange("Period Ending Date", PeriodToDate);
        // SETRANGE("Starting Date", FromDate);
        // SETRANGE("Ending Date", ToDate);

        CalcWorksheetLine.SetRange("Service Code", ServiceCode);
        if (SpecificSource <> 1) then
            CalcWorksheetLine.SetRange("Service Variant Code", ServiceVariantCode);
        CalcWorksheetLine.SetRange("Object Code", ObjectCode);

        CalcWorksheetLine.SetRange("Quantity Source", QtySource);
        CalcWorksheetLine.SetRange("Price Source", PriceSource);
        CalcWorksheetLine.SetRange("Discount Source", DiscountSource);

        // SETRANGE("Unit Price", UnitPrice);
        // SETRANGE("Discount, %", DiscountPercent);

        CalcWorksheetLine.SetRange("Specific Source", SpecificSource);
        if (SpecificSource <> 1) then
            CalcWorksheetLine.SetRange("Specific No.", SpecificNo);

        CalcWorksheetLine.SetRange("Customer Price Group", CustomerPriceGroupCode);
        CalcWorksheetLine.SetRange("Customer Discount Group", CustomerDiscountGroupCode);
        CalcWorksheetLine.SetRange("Discount Usage", DiscountUsage);

        CalcWorksheetLine.CalcSums(Quantity);

        // Looking for buffer entry to update
        CalcLedgEntry.Reset;
        CalcLedgEntry.SetRange("Customer No.", CustomerNo);
        CalcLedgEntry.SetRange("Currency Code", CurrencyCode);
        CalcLedgEntry.SetRange("Contract No.", ContractNo);
        CalcLedgEntry.SetRange("Calculation Period Code", CalcPeriodCode);
        CalcLedgEntry.SetRange("Period Starting Date", PeriodFromDate);
        CalcLedgEntry.SetRange("Period Ending Date", PeriodToDate);
        // SETRANGE("Starting Date", FromDate);
        // SETRANGE("Ending Date", ToDate);

        CalcLedgEntry.SetRange("Service Code", ServiceCode);
        if (SpecificSource <> 1) then
            CalcLedgEntry.SetRange("Service Variant Code", ServiceVariantCode);
        CalcLedgEntry.SetRange("Object Code", ObjectCode);

        CalcLedgEntry.SetRange("Quantity Source", QtySource);
        CalcLedgEntry.SetRange("Price Source", PriceSource);
        CalcLedgEntry.SetRange("Discount Source", DiscountSource);

        // SETRANGE("Unit Price", UnitPrice);
        // SETRANGE("Discount, %", DiscountPercent);

        CalcLedgEntry.SetRange("Specific Source", SpecificSource);
        if (SpecificSource <> 1) then
            CalcLedgEntry.SetRange("Specific No.", SpecificNo);

        CalcLedgEntry.SetRange("Customer Price Group", CustomerPriceGroupCode);
        CalcLedgEntry.SetRange("Customer Discount Group", CustomerDiscountGroupCode);
        CalcLedgEntry.SetRange("Discount Usage", DiscountUsage);

        CalcLedgEntry.CalcSums(Quantity);

        exit(TempQtyBuffer.Quantity + CalcLedgEntry.Quantity + CalcWorksheetLine.Quantity);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcessContractServiceDMS(var ContractDMS: Record Contract; Var ContractService: Record "DMS Contract Line"; CalcFromDate: Date; CalcToDate: Date; var Ishandled: Boolean)
    begin
    end;
}

