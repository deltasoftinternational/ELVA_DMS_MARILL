Codeunit 25006135 "Service Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        Period: Option " ",Next,Previous;
        ServiceTargetChartMgt: Codeunit "Service Target Chart Mgt.";
        ServiceMTDChartMgt: Codeunit "Service MTD Chart Mgt.";
        ResPerformanceChartMgt: Codeunit "Res. Performance Chart Mgt.";
        UserProfileMgt: Codeunit UserProfileManagement;


    procedure AddinReady(var ChartDefinition: Record "Service Chart Definition"; var BusinessChartBuffer: Record "Business Chart Buffer")
    var
        LastUsedChart: Record "Service Last Used Chart";
        LastChartRecorded: Boolean;
    begin
        LastChartRecorded := LastUsedChart.Get(UserId);
        ChartDefinition.Reset;
        ChartDefinition.SetRange("Codeunit ID", LastUsedChart."Codeunit ID");
        ChartDefinition.SetFilter("Profile ID", '%1|%2', '', UserProfileMgt.CurrProfileID);
        if not ChartDefinition.FindFirst then begin
            ChartDefinition.Reset;
            ChartDefinition.SetRange(Enabled, true);
            ChartDefinition.SetFilter("Profile ID", '%1|%2', '', UserProfileMgt.CurrProfileID);
            if not ChartDefinition.FindFirst then begin
                ChartDefinition.Reset;
                exit;
            end;
        end;
        UpdateChart(ChartDefinition, BusinessChartBuffer, Period::" ");
        ChartDefinition.Reset;
    end;


    procedure DataPointClicked(var BusinessChartBuffer: Record "Business Chart Buffer"; var ChartDefinition: Record "Service Chart Definition")
    begin
        case ChartDefinition."Codeunit ID" of
            Codeunit::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.DrillDown(BusinessChartBuffer);
            Codeunit::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.DrillDown(BusinessChartBuffer);
        end;
    end;


    procedure SetPeriodLength(ChartDefinition: Record "Service Chart Definition"; var BusChartBuf: Record "Business Chart Buffer"; PeriodLength: Option; IsInitState: Boolean)
    var
        NewStartDate: Date;
    begin
        case ChartDefinition."Codeunit ID" of
            Codeunit::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.SetPeriodLenght(PeriodLength);
            Codeunit::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.SetPeriodLenght(PeriodLength);
            Codeunit::"Res. Performance Chart Mgt.":
                ResPerformanceChartMgt.SetPeriodLenght(PeriodLength);

        end;
    end;


    procedure UpdateChart(var ChartDefinition: Record "Service Chart Definition"; var BusinessChartBuffer: Record "Business Chart Buffer"; Period: Option)
    begin
        case ChartDefinition."Codeunit ID" of
            Codeunit::"Service Target Chart Mgt.":
                begin
                    ServiceTargetChartMgt.UpdateData(BusinessChartBuffer, Period);
                end;
            Codeunit::"Service MTD Chart Mgt.":
                begin
                    ServiceMTDChartMgt.UpdateData(BusinessChartBuffer, Period);
                end;
            Codeunit::"Res. Performance Chart Mgt.":
                begin
                    ResPerformanceChartMgt.UpdateData(BusinessChartBuffer, Period);
                end;

        end;
        UpdateLastUsedChart(ChartDefinition);
    end;


    procedure UpdateStatusText(var ChartDefinition: Record "Service Chart Definition"; var StatusText: Text)
    begin
        case ChartDefinition."Codeunit ID" of
            Codeunit::"Service Target Chart Mgt.":
                StatusText := ServiceTargetChartMgt.StatusText;
            Codeunit::"Service MTD Chart Mgt.":
                StatusText := ServiceMTDChartMgt.StatusText;
            Codeunit::"Res. Performance Chart Mgt.":
                StatusText := ResPerformanceChartMgt.StatusText;
        end;
    end;

    local procedure UpdateLastUsedChart(ChartDefinition: Record "Service Chart Definition")
    var
        ServiceLastUsedChart: Record "Service Last Used Chart";
    begin
        if ServiceLastUsedChart.Get(UserId) then begin
            ServiceLastUsedChart.Validate("Codeunit ID", ChartDefinition."Codeunit ID");
            ServiceLastUsedChart.Validate("Chart Name", ChartDefinition."Chart Name");
            ServiceLastUsedChart.Modify;
        end else begin
            ServiceLastUsedChart.Validate(UID, UserId);
            ServiceLastUsedChart.Validate("Codeunit ID", ChartDefinition."Codeunit ID");
            ServiceLastUsedChart.Validate("Chart Name", ChartDefinition."Chart Name");
            ServiceLastUsedChart.Insert;
        end;
    end;


    procedure ActionsEnabled(var ChartDefinition: Record "Service Chart Definition"; var DayEnabled: Boolean; var WeekEnabled: Boolean; var MonthEnabled: Boolean; var QuarterEnabled: Boolean; var YearEnabled: Boolean; var AmountEnabled: Boolean; var QuantityEnabled: Boolean; var PercentEnabled: Boolean; var LineEnabled: Boolean; var StepLineEnabled: Boolean; var ColumnEnabled: Boolean; var StackedColumnEnabled: Boolean; var NoGroupingEnabled: Boolean; var LocationEnabled: Boolean; var ServiceAdvisorEnabled: Boolean; var ResourceEnabled: Boolean; var PreviousEnabled: Boolean; var NextEnabled: Boolean)
    begin
        case ChartDefinition."Codeunit ID" of
            Codeunit::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.SetActionsEnabled(DayEnabled, WeekEnabled, MonthEnabled, QuarterEnabled, YearEnabled,
                          AmountEnabled, QuantityEnabled, PercentEnabled,
                          LineEnabled, StepLineEnabled, ColumnEnabled, StackedColumnEnabled,
                          NoGroupingEnabled, LocationEnabled, ServiceAdvisorEnabled, ResourceEnabled,
                          PreviousEnabled, NextEnabled);
            Codeunit::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.SetActionsEnabled(DayEnabled, WeekEnabled, MonthEnabled, QuarterEnabled, YearEnabled,
                          AmountEnabled, QuantityEnabled, PercentEnabled,
                          LineEnabled, StepLineEnabled, ColumnEnabled, StackedColumnEnabled,
                          NoGroupingEnabled, LocationEnabled, ServiceAdvisorEnabled, ResourceEnabled,
                          PreviousEnabled, NextEnabled);
            Codeunit::"Res. Performance Chart Mgt.":
                ResPerformanceChartMgt.SetActionsEnabled(DayEnabled, WeekEnabled, MonthEnabled, QuarterEnabled, YearEnabled,
                          AmountEnabled, QuantityEnabled, PercentEnabled,
                          LineEnabled, StepLineEnabled, ColumnEnabled, StackedColumnEnabled,
                          NoGroupingEnabled, LocationEnabled, ServiceAdvisorEnabled, ResourceEnabled,
                          PreviousEnabled, NextEnabled);
        end;
    end;


    procedure SetValueType(ChartDefinition: Record "Service Chart Definition"; ValueType: Option Amount,Quantity,Percent)
    begin
        case ChartDefinition."Codeunit ID" of
            Codeunit::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.SetValueType(ValueType);
            Codeunit::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.SetValueType(ValueType);
            Codeunit::"Res. Performance Chart Mgt.":
                ResPerformanceChartMgt.SetValueType(ValueType);
        end;
    end;


    procedure SetChartType(ChartDefinition: Record "Service Chart Definition"; ChartType: Option Line,StepLine,Column,StackedColumn)
    begin
        case ChartDefinition."Codeunit ID" of
            Codeunit::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.SetChartType(ChartType);
            Codeunit::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.SetChartType(ChartType);
            Codeunit::"Res. Performance Chart Mgt.":
                ResPerformanceChartMgt.SetChartType(ChartType);
        end;
    end;


    procedure Setup(ChartDefinition: Record "Service Chart Definition")
    begin
        case ChartDefinition."Codeunit ID" of
            Codeunit::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.RunSetupPage;
            Codeunit::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.RunSetupPage;
            Codeunit::"Res. Performance Chart Mgt.":
                ResPerformanceChartMgt.RunSetupPage;
        end;
    end;


    procedure IsChartsDefined(): Boolean
    var
        ChartDefinition2: Record "Service Chart Definition";
    begin
        ChartDefinition2.Reset;
        ChartDefinition2.SetRange(Enabled, true);
        ChartDefinition2.SetFilter("Profile ID", '%1|%2', '', UserProfileMgt.CurrProfileID);
        if ChartDefinition2.FindFirst then
            exit(true)
        else
            exit(false);
    end;
}

