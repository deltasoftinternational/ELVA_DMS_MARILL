Page 25006561 "Service Chart"
{
    Caption = 'Service Chart';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            field(StatusText; StatusText)
            {
                ApplicationArea = Basic;
                Caption = 'Status Text';
                ShowCaption = false;
                Style = StrongAccent;
                StyleExpr = true;
            }
            /*   usercontrol(BusinessChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
               {
                   ApplicationArea = Basic;

                    /* trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                     begin
                         Rec.SetDrillDownIndexes(point);
                         ChartManagement.DataPointClicked(Rec, SelectedChartDefinition);
                     end;//FIXME

                     trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
                     begin
                     end;//FIXME

                   trigger AddInReady()
                   begin
                       IsChartAddInReady := true;
                       ChartManagement.AddinReady(SelectedChartDefinition, Rec);
                       InitializeSelectedChart;
                   end;
               }*/
        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Chart")
            {
                ApplicationArea = Basic;
                Caption = 'Previous Chart';
                Image = PreviousSet;

                trigger OnAction()
                begin
                    if ChartManagement.IsChartsDefined then begin
                        SelectedChartDefinition.SetFilter("Profile ID", '%1|%2', '', UserProfileMgt.CurrProfileID);
                        SelectedChartDefinition.SetRange(Enabled, true);
                        if SelectedChartDefinition.Next(-1) = 0 then
                            SelectedChartDefinition.FindLast;
                        InitializeSelectedChart;
                    end;
                end;
            }
            action("Next Chart")
            {
                ApplicationArea = Basic;
                Caption = 'Next Chart';
                Image = NextSet;

                trigger OnAction()
                begin
                    if ChartManagement.IsChartsDefined then begin
                        SelectedChartDefinition.SetFilter("Profile ID", '%1|%2', '', UserProfileMgt.CurrProfileID);
                        SelectedChartDefinition.SetRange(Enabled, true);
                        if SelectedChartDefinition.Next = 0 then
                            SelectedChartDefinition.FindFirst;
                        InitializeSelectedChart;
                    end;
                end;
            }
            group(PeriodLength)
            {
                Caption = 'Period Length';
                Image = Period;
                action(Day)
                {
                    ApplicationArea = Basic;
                    Caption = 'Day';
                    Enabled = DayEnabled;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart(Rec."period length"::Day);
                    end;
                }
                action(Week)
                {
                    ApplicationArea = Basic;
                    Caption = 'Week';
                    Enabled = WeekEnabled;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart(Rec."period length"::Week);
                    end;
                }
                action(Month)
                {
                    ApplicationArea = Basic;
                    Caption = 'Month';
                    Enabled = MonthEnabled;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart(Rec."period length"::Month);
                    end;
                }
                action(Quarter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quarter';
                    Enabled = QuarterEnabled;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart(Rec."period length"::Quarter);
                    end;
                }
                action(Year)
                {
                    ApplicationArea = Basic;
                    Caption = 'Year';
                    Enabled = YearEnabled;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart(Rec."period length"::Year);
                    end;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                Image = SelectChart;
                group(ValueToCalculate)
                {
                    Caption = 'Value to Calculate';
                    Image = Calculate;
                    action(Amount)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount';
                        Enabled = AmountEnabled;

                        trigger OnAction()
                        var
                            ValueType: Option Amount,Quantity,Percent;
                        begin
                            SetValueTypeAndUpdateChart(Valuetype::Amount);
                        end;
                    }
                    action(Quantity)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Quantity';
                        Enabled = QuantityEnabled;

                        trigger OnAction()
                        var
                            ValueType: Option Amount,Quantity,Percent;
                        begin
                            SetValueTypeAndUpdateChart(Valuetype::Quantity);
                        end;
                    }
                    action(Percent)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Percent';
                        Enabled = PercentEnabled;

                        trigger OnAction()
                        var
                            ValueType: Option Amount,Quantity,Percent;
                        begin
                            SetValueTypeAndUpdateChart(Valuetype::Percent);
                        end;
                    }
                }
                group(ChartType)
                {
                    Caption = 'Chart Type';
                    Image = BarChart;
                    action(Line)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Line';
                        Enabled = LineEnabled;

                        trigger OnAction()
                        var
                            ChartType: Option Line,StepLine,Column,StackedColumn;
                        begin
                            SetChartTypeAndUpdateChart(Charttype::Line);
                        end;
                    }
                    action(StepLine)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Step Line';
                        Enabled = StepLineEnabled;

                        trigger OnAction()
                        var
                            ChartType: Option Line,StepLine,Column,StackedColumn;
                        begin
                            SetChartTypeAndUpdateChart(Charttype::StepLine);
                        end;
                    }
                    action(Column)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column';
                        Enabled = ColumnEnabled;

                        trigger OnAction()
                        var
                            ChartType: Option Line,StepLine,Column,StackedColumn;
                        begin
                            SetChartTypeAndUpdateChart(Charttype::Column);
                        end;
                    }
                    action("Stacked Column")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Stacked Column';
                        Enabled = StackedColumnEnabled;

                        trigger OnAction()
                        var
                            ChartType: Option Line,StepLine,Column,StackedColumn;
                        begin
                            SetChartTypeAndUpdateChart(Charttype::StackedColumn);
                        end;
                    }
                }
                group("Group By")
                {
                    Caption = 'Group By';
                    action("No Grouping")
                    {
                        ApplicationArea = Basic;
                        Caption = 'No Grouping';
                        Enabled = NoGroupingEnabled;
                    }
                    action(Location)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Enabled = LocationEnabled;
                    }
                    action("Service Advisor")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Advisor';
                        Enabled = ServiceAdvisorEnabled;
                    }
                    action(Resource)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Resource';
                        Enabled = ResourceEnabled;
                    }
                }
            }
            separator(Action25006009)
            {
            }
            action(PreviousPeriod)
            {
                ApplicationArea = Basic;
                Caption = 'Previous Period';
                Enabled = PreviousEnabled;
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::Previous);
                    ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
                    UpdateChart;
                end;
            }
            action(NextPeriod)
            {
                ApplicationArea = Basic;
                Caption = 'Next Period';
                Enabled = NextEnabled;
                Image = NextRecord;

                trigger OnAction()
                begin
                    ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::Next);
                    ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
                    UpdateChart;
                end;
            }
            separator(Action7)
            {
            }
            action(Refresh)
            {
                ApplicationArea = Basic;
                Caption = 'Refresh';
                Image = Refresh;

                trigger OnAction()
                begin
                    if ChartManagement.IsChartsDefined then begin
                        ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
                        ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
                        UpdateChart;
                    end;
                end;
            }
            separator(Action5)
            {
            }
            action(Setup)
            {
                ApplicationArea = Basic;
                Caption = 'Setup';
                Image = Setup;

                trigger OnAction()
                begin
                    if ChartManagement.IsChartsDefined then begin
                        ChartManagement.Setup(SelectedChartDefinition);
                        ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
                        ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
                        UpdateChart;
                    end;
                end;
            }
        }
    }

    var
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        [InDataSet]
        DayEnabled: Boolean;
        [InDataSet]
        WeekEnabled: Boolean;
        [InDataSet]
        MonthEnabled: Boolean;
        [InDataSet]
        QuarterEnabled: Boolean;
        [InDataSet]
        YearEnabled: Boolean;
        [InDataSet]
        AmountEnabled: Boolean;
        [InDataSet]
        QuantityEnabled: Boolean;
        [InDataSet]
        LineEnabled: Boolean;
        [InDataSet]
        StepLineEnabled: Boolean;
        [InDataSet]
        ColumnEnabled: Boolean;
        StackedColumnEnabled: Boolean;
        PercentEnabled: Boolean;
        NoGroupingEnabled: Boolean;
        LocationEnabled: Boolean;
        ServiceAdvisorEnabled: Boolean;
        ResourceEnabled: Boolean;
        IsChartAddInReady: Boolean;
        IsChartDataReady: Boolean;
        ServiceMTDChartMgt: Codeunit "Service MTD Chart Mgt.";
        ServiceMTDChartSetup: Record "Service MTD Chart Setup";
        SelectedChartDefinition: Record "Service Chart Definition";
        ChartManagement: Codeunit "Service Chart Mgt.";
        Period: Option " ",Next,Previous;
        UserProfileMgt: Codeunit UserProfileManagement;
        [InDataSet]
        PreviousEnabled: Boolean;
        [InDataSet]
        NextEnabled: Boolean;
        NoChartsDefined: label 'No Charts Defined';

    local procedure UpdateChart()
    begin
        if not IsChartAddInReady then
            exit;
        // Rec.Update(CurrPage.BusinessChart);
        ChartManagement.ActionsEnabled(SelectedChartDefinition,
              DayEnabled, WeekEnabled, MonthEnabled, QuarterEnabled, YearEnabled,
              AmountEnabled, QuantityEnabled, PercentEnabled,
              LineEnabled, StepLineEnabled, ColumnEnabled, StackedColumnEnabled,
              NoGroupingEnabled, LocationEnabled, ServiceAdvisorEnabled, ResourceEnabled,
              PreviousEnabled, NextEnabled);
    end;

    local procedure InitializeSelectedChart()
    begin
        if ChartManagement.IsChartsDefined then begin
            ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
            ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
            UpdateChart;
        end else
            StatusText := NoChartsDefined;
    end;

    local procedure SetPeriodAndUpdateChart(PeriodLength: Option)
    begin
        ChartManagement.SetPeriodLength(SelectedChartDefinition, Rec, PeriodLength, false);
        ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
        ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
        UpdateChart;
    end;

    local procedure SetValueTypeAndUpdateChart(ValueType: Option Amount,Quantity,Percent)
    begin
        ChartManagement.SetValueType(SelectedChartDefinition, ValueType);
        ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
        ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
        UpdateChart;
    end;

    local procedure SetChartTypeAndUpdateChart(ChartType: Option Line,StepLine,Column)
    begin
        ChartManagement.SetChartType(SelectedChartDefinition, ChartType);
        ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
        ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
        UpdateChart;
    end;
}

