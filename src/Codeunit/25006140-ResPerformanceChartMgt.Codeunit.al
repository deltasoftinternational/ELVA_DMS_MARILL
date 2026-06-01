Codeunit 25006140 "Res. Performance Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        XAxisTxt: label 'Period';
        LocationCode: Code[20];
        SelectedDate: Date;
        ResTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ResPerformanceChartSetup: Record "Res. Performance Chart Setup";
        DescriptionTxt: label 'Resource Performance';
        MeasureProdTxt: label 'Productive';
        MeasureNonProdTxt: label 'Non Productive';
        MeasureAttendedTxt: label 'Attended';


    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer"; Period: Option " ",Next,Previous)
    var
        ToDate: array[7] of Date;
        FromDate: array[7] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        AttendedHours: Decimal;
        ProductiveHours: Decimal;
        NonProductiveHours: Decimal;
        Day: Date;
        MaxPeriodNo: Integer;
    begin
        GetChartSetup(ResPerformanceChartSetup);
        BusChartBuf.Initialize;
        BusChartBuf."Period Length" := ResPerformanceChartSetup."Period Length";
        BusChartBuf.SetPeriodXAxis;

        if ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."chart type"::StackedColumn then
            BusChartBuf.AddMeasure(MeasureAttendedTxt, 1, BusChartBuf."data type"::Decimal, ResPerformanceChartSetup.GetChartType);
        BusChartBuf.AddMeasure(MeasureProdTxt, 1, BusChartBuf."data type"::Decimal, ResPerformanceChartSetup.GetChartType);
        BusChartBuf.AddMeasure(MeasureNonProdTxt, 1, BusChartBuf."data type"::Decimal, ResPerformanceChartSetup.GetChartType);


        if CalcPeriods(FromDate, ToDate, BusChartBuf, Period, MaxPeriodNo) then
            BusChartBuf.AddPeriods(ToDate[1], ToDate[MaxPeriodNo]);

        for ColumnNo := 1 to MaxPeriodNo do begin
            NonProductiveHours := CalcNonProductiveHours(FromDate[ColumnNo], ToDate[ColumnNo], ResTimeRegMgt.GetCurrentUserResourceNo);
            ProductiveHours := CalcProductiveHours(FromDate[ColumnNo], ToDate[ColumnNo], ResTimeRegMgt.GetCurrentUserResourceNo);
            if ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."chart type"::StackedColumn then
                AttendedHours := CalcAttendedHours(FromDate[ColumnNo], ToDate[ColumnNo], ResTimeRegMgt.GetCurrentUserResourceNo);

            //AttendedHours := AttendedHours - (ProductiveHours+NonProductiveHours);

            //AddColumn(Day);
            BusChartBuf.SetValue(MeasureNonProdTxt, ColumnNo - 1, NonProductiveHours);
            BusChartBuf.SetValue(MeasureProdTxt, ColumnNo - 1, ProductiveHours);
            if ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."chart type"::StackedColumn then
                BusChartBuf.SetValue(MeasureAttendedTxt, ColumnNo - 1, AttendedHours);
        end;
    end;


    procedure GetChartSetup(var ResPerformanceChartSetupPar: Record "Res. Performance Chart Setup")
    var
        UserSetup: Record "User Setup";
    begin
        if not ResPerformanceChartSetupPar.Get(UserId) then begin
            ResPerformanceChartSetupPar."User ID" := UserId;
            ResPerformanceChartSetupPar."Use Work Date as Base" := true;
            ResPerformanceChartSetupPar."Period Length" := ResPerformanceChartSetupPar."period length"::Month;
            ResPerformanceChartSetupPar."Value to Calculate" := ResPerformanceChartSetupPar."value to calculate"::Amount;
            ResPerformanceChartSetupPar."Chart Type" := ResPerformanceChartSetupPar."chart type"::StackedColumn;
            ResPerformanceChartSetupPar.Insert;
        end;

        if ResPerformanceChartSetupPar.Get(UserId) and UserSetup.Get(UserId) then begin
            if UserSetup."Resource No." <> ResPerformanceChartSetupPar."Resource No." then begin
                ResPerformanceChartSetupPar."Resource No." := UserSetup."Resource No.";
                ResPerformanceChartSetupPar.Modify;
            end;
        end;
    end;

    local procedure CalcPeriods(var FromDate: array[7] of Date; var ToDate: array[7] of Date; var BusChartBuf: Record "Business Chart Buffer"; Period: Option " ",Next,Previous; var MaxPeriodNo: Integer): Boolean
    var
        i: Integer;
    begin
        if ResPerformanceChartSetup."Period Length" = ResPerformanceChartSetup."period length"::Day then
            MaxPeriodNo := ArrayLen(ToDate)
        else
            MaxPeriodNo := 5;

        ToDate[MaxPeriodNo] := ResPerformanceChartSetup.GetStartDate(Period);
        if ToDate[MaxPeriodNo] = 0D then
            exit(false);
        for i := MaxPeriodNo downto 1 do begin
            if i > 1 then begin
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
                ToDate[i - 1] := FromDate[i] - 1;
            end else
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i])
        end;
        ResPerformanceChartSetup."Start Date" := ToDate[MaxPeriodNo];
        ResPerformanceChartSetup.Modify;
        exit(true);
    end;

    local procedure CalcProductiveHours(DateFrom: Date; DateTo: Date; ResourceNo: Code[20]) ProductiveHours: Decimal
    var
        ResPerformanceSummary: Query "Performance Summary";
    begin
        //Calc Productive hours in period
        Clear(ResPerformanceSummary);
        ResPerformanceSummary.SetRange(Date, DateFrom, DateTo);
        ResPerformanceSummary.SetRange(ResPerformanceSummary.Start_Entry_Date, DateFrom, DateTo);
        ResPerformanceSummary.SetRange(ResPerformanceSummary.Worktime_Entry, false);
        ResPerformanceSummary.SetRange(ResPerformanceSummary.Idle, false);
        ResPerformanceSummary.SetRange(Resource_No, ResourceNo);
        ResPerformanceSummary.Open;
        while ResPerformanceSummary.Read do begin
            ProductiveHours += ResPerformanceSummary.Time_Spent;
        end;
        ResPerformanceSummary.Close;
    end;

    local procedure CalcNonProductiveHours(DateFrom: Date; DateTo: Date; ResourceNo: Code[20]) NonProductiveHours: Decimal
    var
        ResPerformanceSummary: Query "Performance Summary";
    begin
        //Calc Non Productive hours on Day
        Clear(ResPerformanceSummary);
        ResPerformanceSummary.SetRange(Date, DateFrom, DateTo);
        ResPerformanceSummary.SetRange(ResPerformanceSummary.Start_Entry_Date, DateFrom, DateTo);
        ResPerformanceSummary.SetRange(ResPerformanceSummary.Idle, true);
        ResPerformanceSummary.SetRange(Resource_No, ResourceNo);
        ResPerformanceSummary.Open;
        while ResPerformanceSummary.Read do begin
            NonProductiveHours += ResPerformanceSummary.Time_Spent;
        end;
        ResPerformanceSummary.Close;
    end;

    local procedure CalcAttendedHours(DateFrom: Date; DateTo: Date; ResourceNo: Code[20]) AttendedHours: Decimal
    var
        ResPerformanceSummary: Query "Performance Summary";
    begin
        //Calc Attended hours on Day
        Clear(ResPerformanceSummary);
        ResPerformanceSummary.SetRange(Date, DateFrom, DateTo);
        ResPerformanceSummary.SetRange(ResPerformanceSummary.Start_Entry_Date, DateFrom, DateTo);
        ResPerformanceSummary.SetRange(ResPerformanceSummary.Idle, false);
        ResPerformanceSummary.SetRange(ResPerformanceSummary.Worktime_Entry, true);
        ResPerformanceSummary.SetRange(Resource_No, ResourceNo);
        ResPerformanceSummary.Open;
        while ResPerformanceSummary.Read do begin
            AttendedHours += ResPerformanceSummary.Time_Spent;
        end;
        ResPerformanceSummary.Close;
    end;


    procedure SetPeriodLenght(PeriodLenght: Option)
    begin
        GetChartSetup(ResPerformanceChartSetup);
        ResPerformanceChartSetup."Period Length" := PeriodLenght;
        ResPerformanceChartSetup.Modify;
    end;


    procedure Description(): Text
    begin
        exit(DescriptionTxt);
    end;


    procedure StatusText(): Text
    begin
        exit(Description + ' | ' + ResPerformanceChartSetup.GetCurrentSelectionText);
    end;


    procedure SetActionsEnabled(var DayEnabled: Boolean; var WeekEnabled: Boolean; var MonthEnabled: Boolean; var QuarterEnabled: Boolean; var YearEnabled: Boolean; var AmountEnabled: Boolean; var QuantityEnabled: Boolean; var PercentEnabled: Boolean; var LineEnabled: Boolean; var StepLineEnabled: Boolean; var ColumnEnabled: Boolean; var StackedColumnEnabled: Boolean; var NoGroupingEnabled: Boolean; var LocationEnabled: Boolean; var ServiceAdvisorEnabled: Boolean; var ResourceEnabled: Boolean; var PreviousEnabled: Boolean; var NextEnabled: Boolean)
    var
        Period: Option " ",Next,Previous;
    begin
        GetChartSetup(ResPerformanceChartSetup);
        DayEnabled := (ResPerformanceChartSetup."Period Length" <> ResPerformanceChartSetup."period length"::Day);
        WeekEnabled := (ResPerformanceChartSetup."Period Length" <> ResPerformanceChartSetup."period length"::Week);
        MonthEnabled := (ResPerformanceChartSetup."Period Length" <> ResPerformanceChartSetup."period length"::Month);
        QuarterEnabled := (ResPerformanceChartSetup."Period Length" <> ResPerformanceChartSetup."period length"::Quarter);
        YearEnabled := (ResPerformanceChartSetup."Period Length" <> ResPerformanceChartSetup."period length"::Year);
        AmountEnabled := (ResPerformanceChartSetup."Value to Calculate" <> ResPerformanceChartSetup."value to calculate"::Amount);
        QuantityEnabled := (ResPerformanceChartSetup."Value to Calculate" <> ResPerformanceChartSetup."value to calculate"::Quantity);
        PercentEnabled := false;
        LineEnabled := (ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."chart type"::Line);
        StepLineEnabled := (ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."chart type"::"Step Line");
        ColumnEnabled := (ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."chart type"::Column);
        StackedColumnEnabled := (ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."chart type"::StackedColumn);
        NoGroupingEnabled := false;
        LocationEnabled := false;
        ServiceAdvisorEnabled := false;
        ResourceEnabled := false;
        PreviousEnabled := true;
        NextEnabled := ResPerformanceChartSetup."Start Date" < ResPerformanceChartSetup.GetStartDate(Period::" ");
    end;


    procedure SetValueType(ValueType: Option Amount,Quantity,Percent)
    begin
        GetChartSetup(ResPerformanceChartSetup);
        ResPerformanceChartSetup."Value to Calculate" := ValueType;
        ResPerformanceChartSetup.Modify;
    end;


    procedure SetChartType(ChartType: Option Line,StepLine,Column)
    begin
        GetChartSetup(ResPerformanceChartSetup);
        ResPerformanceChartSetup."Chart Type" := ChartType;
        ResPerformanceChartSetup.Modify;
    end;


    procedure RunSetupPage()
    begin
        Page.RunModal(Page::"Res. Performance Chart Setup");
    end;
}

