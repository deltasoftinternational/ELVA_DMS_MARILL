Codeunit 25006133 "Service Target Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        TargetChartSetup: Record "Service Target Chart Setup";
        DescriptionTxt: label 'Service Target vs Actual';
        MeasureTargetTxt: label 'Target';
        MeasureActualTxt: label 'Actual';


    procedure GetTargetChartSetup(var TargetChartSetupPar: Record "Service Target Chart Setup")
    begin
        if not TargetChartSetupPar.Get(UserId) then begin
            TargetChartSetupPar."User ID" := UserId;
            TargetChartSetupPar."Use Work Date as Base" := true;
            TargetChartSetupPar."Period Length" := TargetChartSetupPar."period length"::Month;
            TargetChartSetupPar."Value to Calculate" := TargetChartSetupPar."value to calculate"::Amount;
            TargetChartSetupPar."Chart Type" := TargetChartSetupPar."chart type"::Line;
            TargetChartSetupPar."Start Date" := WorkDate;
            TargetChartSetupPar.Insert;
        end;
    end;


    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    begin
    end;


    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer"; Period: Option " ",Next,Previous)
    var
        ChartToMap: array[2] of Integer;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        SalesHeaderStatus: Integer;
        n: Integer;
        ServiceSalesBudget: Record "Service Target";
    begin
        GetTargetChartSetup(TargetChartSetup);
        BusChartBuf.Initialize;
        BusChartBuf."Period Length" := TargetChartSetup."Period Length";
        BusChartBuf.SetPeriodXAxis;

        if CalcPeriods(FromDate, ToDate, BusChartBuf, Period) then
            BusChartBuf.AddPeriods(ToDate[1], ToDate[ArrayLen(ToDate)]);

        n := 1;
        BusChartBuf.AddMeasure(MeasureActualTxt, 1, BusChartBuf."data type"::Decimal, TargetChartSetup.GetChartType);
        for ColumnNo := 1 to ArrayLen(ToDate) do begin
            BusChartBuf.SetValueByIndex(n - 1, ColumnNo - 1, GetActualValue(FromDate[ColumnNo], ToDate[ColumnNo]));
        end;
        n := 2;
        BusChartBuf.AddMeasure(MeasureTargetTxt, 2, BusChartBuf."data type"::Decimal, TargetChartSetup.GetChartType);
        for ColumnNo := 1 to ArrayLen(ToDate) do begin
            BusChartBuf.SetValueByIndex(n - 1, ColumnNo - 1, GetTargetValue(FromDate[ColumnNo], ToDate[ColumnNo]));
        end;
    end;

    local procedure CalcPeriods(var FromDate: array[5] of Date; var ToDate: array[5] of Date; var BusChartBuf: Record "Business Chart Buffer"; Period: Option " ",Next,Previous): Boolean
    var
        MaxPeriodNo: Integer;
        i: Integer;
    begin
        MaxPeriodNo := ArrayLen(ToDate);
        ToDate[MaxPeriodNo] := TargetChartSetup.GetStartDate(Period);
        if ToDate[MaxPeriodNo] = 0D then
            exit(false);
        for i := MaxPeriodNo downto 1 do begin
            if i > 1 then begin
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
                ToDate[i - 1] := FromDate[i] - 1;
            end else
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i])
        end;
        TargetChartSetup."Start Date" := ToDate[MaxPeriodNo];
        TargetChartSetup.Modify;
        exit(true);
    end;

    local procedure GetTargetValue(FromDate: Date; ToDate: Date): Decimal
    var
        ServiceTargetQry: Query "Service Target";
        Amount: Decimal;
        LocationCode: Code[10];
        ServicePersonCode: Code[10];
        ResourceNo: Code[20];
        Quantity: Decimal;
    begin
        LocationCode := TargetChartSetup.GetLocation;
        if LocationCode <> '' then
            ServiceTargetQry.SetRange(Service_Advisor, LocationCode);
        ServicePersonCode := TargetChartSetup.GetServicePerson;
        if ServicePersonCode <> '' then
            ServiceTargetQry.SetRange(Location, ServicePersonCode);
        ResourceNo := TargetChartSetup.GetResource;
        if ResourceNo <> '' then
            ServiceTargetQry.SetRange(Resource, ResourceNo);
        ServiceTargetQry.SetRange(Date, FromDate, ToDate);
        ServiceTargetQry.Open;
        while ServiceTargetQry.Read do begin
            Amount += ServiceTargetQry.Amount;
            Quantity += ServiceTargetQry.Quantity;
        end;

        if TargetChartSetup."Value to Calculate" = TargetChartSetup."value to calculate"::Quantity then
            exit(Quantity)
        else
            exit(Amount);
    end;

    local procedure GetActualValue(FromDate: Date; ToDate: Date): Decimal
    var
        ServiceActualQry: Query "Service Actual Labor";
        Amount: Decimal;
        LocationCode: Code[10];
        ServicePersonCode: Code[10];
        ResourceNo: Code[20];
        Quantity: Decimal;
    begin
        LocationCode := TargetChartSetup.GetLocation;
        if LocationCode <> '' then
            ServiceActualQry.SetRange(Location_Code, LocationCode);
        ServicePersonCode := TargetChartSetup.GetServicePerson;
        if ServicePersonCode <> '' then
            ServiceActualQry.SetRange(Salesperson_Code, ServicePersonCode);
        ResourceNo := TargetChartSetup.GetResource;
        if ResourceNo <> '' then
            ServiceActualQry.SetRange(Resource_No, ResourceNo);
        ServiceActualQry.SetRange(Posting_Date, FromDate, ToDate);
        ServiceActualQry.Open;
        while ServiceActualQry.Read do begin
            Amount += ServiceActualQry.Amount_LCY;
            Quantity += ServiceActualQry.Quantity;
        end;

        if TargetChartSetup."Value to Calculate" = TargetChartSetup."value to calculate"::Quantity then
            exit(Quantity)
        else
            exit(Amount);
    end;


    procedure Description(): Text
    begin
        exit(DescriptionTxt);
    end;


    procedure StatusText(): Text
    begin
        exit(Description + ' | ' + TargetChartSetup.GetCurrentSelectionText);
    end;


    procedure SetActionsEnabled(var DayEnabled: Boolean; var WeekEnabled: Boolean; var MonthEnabled: Boolean; var QuarterEnabled: Boolean; var YearEnabled: Boolean; var AmountEnabled: Boolean; var QuantityEnabled: Boolean; var PercentEnabled: Boolean; var LineEnabled: Boolean; var StepLineEnabled: Boolean; var ColumnEnabled: Boolean; var StackedColumnEnabled: Boolean; var NoGroupingEnabled: Boolean; var LocationEnabled: Boolean; var ServiceAdvisorEnabled: Boolean; var ResourceEnabled: Boolean; var PreviousEnabled: Boolean; var NextEnabled: Boolean)
    var
        Period: Option " ",Next,Previous;
    begin
        GetTargetChartSetup(TargetChartSetup);
        DayEnabled := (TargetChartSetup."Period Length" <> TargetChartSetup."period length"::Day);
        WeekEnabled := (TargetChartSetup."Period Length" <> TargetChartSetup."period length"::Week);
        MonthEnabled := (TargetChartSetup."Period Length" <> TargetChartSetup."period length"::Month);
        QuarterEnabled := (TargetChartSetup."Period Length" <> TargetChartSetup."period length"::Quarter);
        YearEnabled := (TargetChartSetup."Period Length" <> TargetChartSetup."period length"::Year);
        AmountEnabled := (TargetChartSetup."Value to Calculate" <> TargetChartSetup."value to calculate"::Amount);
        QuantityEnabled := (TargetChartSetup."Value to Calculate" <> TargetChartSetup."value to calculate"::Quantity);
        PercentEnabled := false;
        LineEnabled := (TargetChartSetup."Chart Type" <> TargetChartSetup."chart type"::Line);
        StepLineEnabled := (TargetChartSetup."Chart Type" <> TargetChartSetup."chart type"::"Step Line");
        ColumnEnabled := (TargetChartSetup."Chart Type" <> TargetChartSetup."chart type"::Column);
        StackedColumnEnabled := false;
        NoGroupingEnabled := false;
        LocationEnabled := false;
        ServiceAdvisorEnabled := false;
        ResourceEnabled := false;
        PreviousEnabled := true;
        NextEnabled := TargetChartSetup."Start Date" < TargetChartSetup.GetStartDate(Period::" ");
    end;


    procedure SetValueType(ValueType: Option Amount,Quantity,Percent)
    begin
        GetTargetChartSetup(TargetChartSetup);
        TargetChartSetup."Value to Calculate" := ValueType;
        TargetChartSetup.Modify;
    end;


    procedure SetChartType(ChartType: Option Line,StepLine,Column)
    begin
        GetTargetChartSetup(TargetChartSetup);
        TargetChartSetup."Chart Type" := ChartType;
        TargetChartSetup.Modify;
    end;


    procedure SetPeriodLenght(PeriodLenght: Option)
    begin
        GetTargetChartSetup(TargetChartSetup);
        TargetChartSetup."Period Length" := PeriodLenght;
        TargetChartSetup.Modify;
    end;


    procedure RunSetupPage()
    begin
        Page.RunModal(Page::"Service Target Chart Setup");
    end;
}

