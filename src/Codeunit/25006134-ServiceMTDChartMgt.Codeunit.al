Codeunit 25006134 "Service MTD Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        MTDChartSetup: Record "Service MTD Chart Setup";
        ActualTxt: label 'Actual';
        TargetTxt: label 'Target';
        MTDPercentTxt: label 'MTD %';
        MTDCaptionTxt: label 'MTD';
        DescriptionTxt: label 'Service Actual vs Target';


    procedure GetMTDChartSetup(var MTDChartSetupPar: Record "Service MTD Chart Setup")
    begin
        if not MTDChartSetupPar.Get(UserId) then begin
            MTDChartSetupPar."User ID" := UserId;
            MTDChartSetupPar."Use Work Date as Base" := true;
            MTDChartSetupPar."Period Length" := MTDChartSetupPar."period length"::Month;
            MTDChartSetupPar."Value to Calculate" := MTDChartSetupPar."value to calculate"::Quantity;
            MTDChartSetupPar."Chart Type" := MTDChartSetupPar."chart type"::Column;
            MTDChartSetupPar.Insert;
        end;
    end;


    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    begin
    end;


    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer"; Period: Option " ",Next,Previous)
    var
        ChartToMap: array[2] of Integer;
        ToDate: Date;
        Value: Decimal;
        TotalValue: Decimal;
        SalesHeaderStatus: Integer;
        n: Integer;
        ServiceSalesBudget: Record "Service Target";
        Location: Record Location;
        ServiceAdvisor: Record "Salesperson/Purchaser";
        Resource: Record Resource;
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get;
        GetMTDChartSetup(MTDChartSetup);
        BusChartBuf.Initialize;
        if MTDChartSetup."Value to Calculate" = MTDChartSetup."value to calculate"::Percent then
            BusChartBuf.AddMeasure(MTDPercentTxt, 1, BusChartBuf."data type"::Decimal, MTDChartSetup.GetChartType)
        else begin
            BusChartBuf.AddMeasure(ActualTxt, 1, BusChartBuf."data type"::Decimal, MTDChartSetup.GetChartType);
            BusChartBuf.AddMeasure(TargetTxt, 2, BusChartBuf."data type"::Decimal, MTDChartSetup.GetChartType);
        end;
        BusChartBuf.SetXAxis(MTDCaptionTxt, BusChartBuf."data type"::String);
        case MTDChartSetup."Group By" of
            MTDChartSetup."group by"::Total:
                begin
                    n := 1;
                    BusChartBuf.AddColumn(CompanyInfo.Name);
                    if MTDChartSetup."Value to Calculate" = MTDChartSetup."value to calculate"::Percent then
                        BusChartBuf.SetValueByIndex(0, n - 1, GetPercentValue('', '', '', Period, ToDate))
                    else begin
                        BusChartBuf.SetValueByIndex(0, n - 1, GetActualValue('', '', '', Period, ToDate));
                        BusChartBuf.SetValueByIndex(1, n - 1, GetTargetValue('', '', '', Period, ToDate));
                    end;
                end;
            MTDChartSetup."group by"::Location:
                begin
                    n := 1;
                    Location.Reset;
                    Location.SetRange("Use As Service Location", true);
                    if Location.Find('-') then
                        repeat
                            BusChartBuf.AddColumn(Location.Name);
                            if MTDChartSetup."Value to Calculate" = MTDChartSetup."value to calculate"::Percent then
                                BusChartBuf.SetValueByIndex(0, n - 1, GetPercentValue(Location.Code, '', '', Period, ToDate))
                            else begin
                                BusChartBuf.SetValueByIndex(0, n - 1, GetActualValue(Location.Code, '', '', Period, ToDate));
                                BusChartBuf.SetValueByIndex(1, n - 1, GetTargetValue(Location.Code, '', '', Period, ToDate));
                            end;
                            n += 1;
                        until Location.Next = 0;
                end;
            MTDChartSetup."group by"::"Service Advisor":
                begin
                    n := 1;
                    ServiceAdvisor.Reset;
                    if ServiceAdvisor.Find('-') then
                        repeat
                            BusChartBuf.AddColumn(ServiceAdvisor.Name);
                            if MTDChartSetup."Value to Calculate" = MTDChartSetup."value to calculate"::Percent then
                                BusChartBuf.SetValueByIndex(0, n - 1, GetPercentValue('', ServiceAdvisor.Code, '', Period, ToDate))
                            else begin
                                BusChartBuf.SetValueByIndex(0, n - 1, GetActualValue('', ServiceAdvisor.Code, '', Period, ToDate));
                                BusChartBuf.SetValueByIndex(1, n - 1, GetTargetValue('', ServiceAdvisor.Code, '', Period, ToDate));
                            end;
                            n += 1;
                        until ServiceAdvisor.Next = 0;
                end;
            MTDChartSetup."group by"::Resource:
                begin
                    n := 1;
                    Resource.Reset;
                    if Resource.Find('-') then
                        repeat
                            BusChartBuf.AddColumn(Resource.Name);
                            if MTDChartSetup."Value to Calculate" = MTDChartSetup."value to calculate"::Percent then
                                BusChartBuf.SetValueByIndex(0, n - 1, GetPercentValue('', '', Resource."No.", Period, ToDate))
                            else begin
                                BusChartBuf.SetValueByIndex(0, n - 1, GetActualValue('', '', Resource."No.", Period, ToDate));
                                BusChartBuf.SetValueByIndex(0, n - 1, GetTargetValue('', '', Resource."No.", Period, ToDate));
                            end;
                            n += 1;
                        until Resource.Next = 0;
                end;
        end;
        MTDChartSetup."Start Date" := ToDate;
        MTDChartSetup.Modify;
    end;

    local procedure GetTargetValue(LocationCode: Code[10]; ServiceAdvisorCode: Code[10]; ResourceNo: Code[20]; Period: Option " ",Next,Previous; var ToDate: Date): Decimal
    var
        ServiceTargetQry: Query "Service Target";
        Amount: Decimal;
        Quantity: Decimal;
        FromDate: Date;
    begin
        if LocationCode <> '' then
            ServiceTargetQry.SetRange(Location, LocationCode);
        if ServiceAdvisorCode <> '' then
            ServiceTargetQry.SetRange(Service_Advisor, ServiceAdvisorCode);
        if ResourceNo <> '' then
            ServiceTargetQry.SetRange(Resource, ResourceNo);

        ToDate := MTDChartSetup.GetStartDate(Period);
        FromDate := MTDChartSetup.GetEndDate(ToDate);

        ServiceTargetQry.SetRange(Date, FromDate, ToDate);
        ServiceTargetQry.Open;
        while ServiceTargetQry.Read do begin
            Amount += ServiceTargetQry.Amount;
            Quantity += ServiceTargetQry.Quantity;
        end;

        if MTDChartSetup."Value to Calculate" = MTDChartSetup."value to calculate"::Quantity then
            exit(Quantity)
        else
            exit(Amount);
    end;

    local procedure GetActualValue(LocationCode: Code[10]; ServiceAdvisorCode: Code[10]; ResourceNo: Code[20]; Period: Option " ",Next,Previous; var ToDate: Date): Decimal
    var
        ServiceActualLaborQry: Query "Service Actual Labor";
        Amount: Decimal;
        Quantity: Decimal;
        FromDate: Date;
        ServiceActualQry: Query "Service Actual";
    begin
        if LocationCode <> '' then begin
            ServiceActualLaborQry.SetRange(Location_Code, LocationCode);
            ServiceActualQry.SetRange(Location_Code, LocationCode);
        end;
        if ServiceAdvisorCode <> '' then begin
            ServiceActualLaborQry.SetRange(Salesperson_Code, ServiceAdvisorCode);
            ServiceActualQry.SetRange(Salesperson_Code, ServiceAdvisorCode);
        end;
        if ResourceNo <> '' then
            ServiceActualLaborQry.SetRange(Resource_No, ResourceNo);

        ToDate := MTDChartSetup.GetStartDate(Period);
        FromDate := MTDChartSetup.GetEndDate(ToDate);

        ServiceActualLaborQry.SetRange(Posting_Date, FromDate, ToDate);
        ServiceActualLaborQry.Open;
        while ServiceActualLaborQry.Read do begin
            //Amount += ServiceActualLaborQry.Amount_LCY;
            Quantity += ServiceActualLaborQry.Quantity;
        end;

        ServiceActualQry.SetRange(Posting_Date, FromDate, ToDate);
        ServiceActualQry.Open;
        while ServiceActualQry.Read do begin
            Amount += ServiceActualQry.Amount_LCY;
        end;

        if MTDChartSetup."Value to Calculate" = MTDChartSetup."value to calculate"::Quantity then
            exit(Quantity)
        else
            exit(Amount);
    end;

    local procedure GetPercentValue(LocationCode: Code[10]; ServiceAdvisorCode: Code[10]; ResourceNo: Code[20]; Period: Option " ",Next,Previous; var ToDate: Date): Decimal
    var
        TargetValue: Decimal;
    begin
        TargetValue := GetTargetValue(LocationCode, ServiceAdvisorCode, ResourceNo, Period, ToDate);
        if TargetValue = 0 then
            exit(TargetValue)
        else
            exit(ROUND((GetActualValue(LocationCode, ServiceAdvisorCode, ResourceNo, Period, ToDate) / TargetValue) * 100, 0.01));
    end;


    procedure Description(): Text
    begin
        exit(DescriptionTxt);
    end;


    procedure StatusText(): Text
    begin
        exit(Description + ' | ' + MTDChartSetup.GetCurrentSelectionText);
    end;


    procedure SetActionsEnabled(var DayEnabled: Boolean; var WeekEnabled: Boolean; var MonthEnabled: Boolean; var QuarterEnabled: Boolean; var YearEnabled: Boolean; var AmountEnabled: Boolean; var QuantityEnabled: Boolean; var PercentEnabled: Boolean; var LineEnabled: Boolean; var StepLineEnabled: Boolean; var ColumnEnabled: Boolean; var StackedColumnEnabled: Boolean; var NoGroupingEnabled: Boolean; var LocationEnabled: Boolean; var ServiceAdvisorEnabled: Boolean; var ResourceEnabled: Boolean; var PreviousEnabled: Boolean; var NextEnabled: Boolean)
    var
        Period: Option " ",Next,Previous;
    begin
        DayEnabled := (MTDChartSetup."Period Length" <> MTDChartSetup."period length"::Day);
        WeekEnabled := (MTDChartSetup."Period Length" <> MTDChartSetup."period length"::Week);
        MonthEnabled := (MTDChartSetup."Period Length" <> MTDChartSetup."period length"::Month);
        QuarterEnabled := (MTDChartSetup."Period Length" <> MTDChartSetup."period length"::Quarter);
        YearEnabled := (MTDChartSetup."Period Length" <> MTDChartSetup."period length"::Year);
        AmountEnabled := (MTDChartSetup."Value to Calculate" <> MTDChartSetup."value to calculate"::Amount);
        QuantityEnabled := (MTDChartSetup."Value to Calculate" <> MTDChartSetup."value to calculate"::Quantity);
        PercentEnabled := (MTDChartSetup."Value to Calculate" <> MTDChartSetup."value to calculate"::Percent);
        LineEnabled := false;
        StepLineEnabled := false;
        ColumnEnabled := (MTDChartSetup."Chart Type" <> MTDChartSetup."chart type"::Column);
        StackedColumnEnabled := false;
        NoGroupingEnabled := (MTDChartSetup."Group By" <> MTDChartSetup."group by"::Total);
        LocationEnabled := (MTDChartSetup."Group By" <> MTDChartSetup."group by"::Location);
        ServiceAdvisorEnabled := (MTDChartSetup."Group By" <> MTDChartSetup."group by"::"Service Advisor");
        ResourceEnabled := (MTDChartSetup."Group By" <> MTDChartSetup."group by"::Resource);
        PreviousEnabled := true;
        NextEnabled := MTDChartSetup."Start Date" < MTDChartSetup.GetStartDate(Period::" ");
    end;


    procedure SetValueType(ValueType: Option Amount,Quantity,Percent)
    begin
        GetMTDChartSetup(MTDChartSetup);
        MTDChartSetup."Value to Calculate" := ValueType;
        MTDChartSetup.Modify;
    end;


    procedure SetChartType(ChartType: Option Line,StepLine,Column)
    begin
        GetMTDChartSetup(MTDChartSetup);
        MTDChartSetup."Chart Type" := ChartType;
        MTDChartSetup.Modify;
    end;


    procedure SetPeriodLenght(PeriodLenght: Option)
    begin
        GetMTDChartSetup(MTDChartSetup);
        MTDChartSetup."Period Length" := PeriodLenght;
        MTDChartSetup.Modify;
    end;


    procedure RunSetupPage()
    begin
        Page.RunModal(Page::"Service MTD Chart Setup");
    end;
}

