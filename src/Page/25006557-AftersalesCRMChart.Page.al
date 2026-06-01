Page 25006557 "Aftersales CRM Chart"
{
    Caption = 'Sales Campaign Performance';
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
            }
            /* usercontrol(BusinessChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
              {
                  ApplicationArea = Basic;

                  /*trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                  begin
                      Rec.SetDrillDownIndexes(point);
                      AftersalesCampaignChartMgt.DrillDown(Rec);
                  end;*///FIXME

            // trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
            // begin
            // end;
            /*
                            trigger AddInReady()
                            begin
                                IsChartAddInReady := true;
                                AftersalesCampaignChartMgt.OnOpenPage(AftersalesCRMSetup);
                                UpdateStatus;
                                if IsChartDataReady then
                                    UpdateChart;
                            end;
                        }*/
        }
    }

    actions
    {
        area(processing)
        {
            group(Show)
            {
                Caption = 'Show';
                Image = View;
                action(AllOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'All Orders';
                    Enabled = AllOrdersEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetShowOrders(AftersalesCRMSetup."show orders"::"All Orders");
                        UpdateStatus;
                    end;
                }
                action(OrdersUntilToday)
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders Until Today';
                    Enabled = OrdersUntilTodayEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetShowOrders(AftersalesCRMSetup."show orders"::"Orders Until Today");
                        UpdateStatus;
                    end;
                }
                action(DelayedOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delayed Orders';
                    Enabled = DelayedOrdersEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetShowOrders(AftersalesCRMSetup."show orders"::"Delayed Orders");
                        UpdateStatus;
                    end;
                }
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
                        AftersalesCRMSetup.SetPeriodLength(AftersalesCRMSetup."period length"::Day);
                        UpdateStatus;
                    end;
                }
                action(Week)
                {
                    ApplicationArea = Basic;
                    Caption = 'Week';
                    Enabled = WeekEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetPeriodLength(AftersalesCRMSetup."period length"::Week);
                        UpdateStatus;
                    end;
                }
                action(Month)
                {
                    ApplicationArea = Basic;
                    Caption = 'Month';
                    Enabled = MonthEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetPeriodLength(AftersalesCRMSetup."period length"::Month);
                        UpdateStatus;
                    end;
                }
                action(Quarter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quarter';
                    Enabled = QuarterEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetPeriodLength(AftersalesCRMSetup."period length"::Quarter);
                        UpdateStatus;
                    end;
                }
                action(Year)
                {
                    ApplicationArea = Basic;
                    Caption = 'Year';
                    Enabled = YearEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetPeriodLength(AftersalesCRMSetup."period length"::Year);
                        UpdateStatus;
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
                        begin
                            AftersalesCRMSetup.SetValueToCalcuate(AftersalesCRMSetup."value to calculate"::"Amount Excl. VAT");
                            UpdateStatus;
                        end;
                    }
                    action(NoofOrders)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Orders';
                        Enabled = NoOfOrdersEnabled;

                        trigger OnAction()
                        begin
                            AftersalesCRMSetup.SetValueToCalcuate(AftersalesCRMSetup."value to calculate"::"No. of Orders");
                            UpdateStatus;
                        end;
                    }
                }
                group(ChartType)
                {
                    Caption = 'Chart Type';
                    Image = BarChart;
                    action(StackedArea)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Stacked Area';
                        Enabled = StackedAreaEnabled;

                        trigger OnAction()
                        begin
                            AftersalesCRMSetup.SetChartType(AftersalesCRMSetup."chart type"::Line);
                            UpdateStatus;
                        end;
                    }
                    action(StackedAreaPct)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Stacked Area (%)';
                        Enabled = StackedAreaPctEnabled;

                        trigger OnAction()
                        begin
                            AftersalesCRMSetup.SetChartType(AftersalesCRMSetup."chart type"::"Step Line");
                            UpdateStatus;
                        end;
                    }
                    action(StackedColumn)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Stacked Column';
                        Enabled = StackedColumnEnabled;

                        trigger OnAction()
                        begin
                            AftersalesCRMSetup.SetChartType(AftersalesCRMSetup."chart type"::"Stacked Area (%)");
                            UpdateStatus;
                        end;
                    }
                    action(StackedColumnPct)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Stacked Column (%)';
                        Enabled = StackedColumnPctEnabled;

                        trigger OnAction()
                        begin
                            AftersalesCRMSetup.SetChartType(AftersalesCRMSetup."chart type"::"Stacked Column");
                            UpdateStatus;
                        end;
                    }
                }
            }
            separator(Action25)
            {
            }
            action(Refresh)
            {
                ApplicationArea = Basic;
                Caption = 'Refresh';
                Image = Refresh;

                trigger OnAction()
                begin
                    NeedsUpdate := true;
                    UpdateStatus;
                end;
            }
            separator(Action27)
            {
            }
            action(Setup)
            {
                ApplicationArea = Basic;
                Caption = 'Setup';
                Image = Setup;

                trigger OnAction()
                begin
                    RunSetup;
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        Campaign.Reset;
        if Campaign.Count > 0 then begin
            UpdateChart;
            IsChartDataReady := true;
            if not IsChartAddInReady then
                SetActionsEnabled;
        end;
    end;

    trigger OnOpenPage()
    begin
        SetActionsEnabled;
        NeedsUpdate := true;
    end;

    var
        AftersalesCRMSetup: Record "Aftersales CRM Chart Setup";
        OldAftersalesCRMSetup: Record "Aftersales CRM Chart Setup";
        AftersalesCampaignChartMgt: Codeunit "Aftersales Campaign Chart Mgt.";
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        [InDataSet]
        AllOrdersEnabled: Boolean;
        [InDataSet]
        OrdersUntilTodayEnabled: Boolean;
        [InDataSet]
        DelayedOrdersEnabled: Boolean;
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
        NoOfOrdersEnabled: Boolean;
        [InDataSet]
        StackedAreaEnabled: Boolean;
        [InDataSet]
        StackedAreaPctEnabled: Boolean;
        [InDataSet]
        StackedColumnEnabled: Boolean;
        [InDataSet]
        StackedColumnPctEnabled: Boolean;
        IsChartAddInReady: Boolean;
        IsChartDataReady: Boolean;
        Campaign: Record Campaign;

    local procedure UpdateChart()
    begin
        if not NeedsUpdate then
            exit;
        if not IsChartAddInReady then
            exit;
        AftersalesCampaignChartMgt.UpdateData(Rec);
        //Rec.Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := false;
    end;


    procedure UpdateStatus()
    begin
        AftersalesCRMSetup.Get(UserId);
        NeedsUpdate :=
          NeedsUpdate or
          (OldAftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."Period Length") or
          (OldAftersalesCRMSetup."Show Orders" <> AftersalesCRMSetup."Show Orders") or
          (OldAftersalesCRMSetup."Use Work Date as Base" <> AftersalesCRMSetup."Use Work Date as Base") or
          (OldAftersalesCRMSetup."Value to Calculate" <> AftersalesCRMSetup."Value to Calculate") or
          (OldAftersalesCRMSetup."Chart Type" <> AftersalesCRMSetup."Chart Type");

        OldAftersalesCRMSetup := AftersalesCRMSetup;

        if NeedsUpdate then
            StatusText := AftersalesCRMSetup.GetCurrentSelectionText;

        SetActionsEnabled;
    end;


    procedure RunSetup()
    begin
        //PAGE.RUNMODAL(PAGE::"Trailing Sales Orders Setup",AftersalesCRMSetup);
        //AftersalesCRMSetup.GET(USERID);
        //UpdateStatus;
    end;


    procedure SetActionsEnabled()
    begin
        AllOrdersEnabled := (AftersalesCRMSetup."Show Orders" <> AftersalesCRMSetup."show orders"::"All Orders") and
          IsChartAddInReady;
        OrdersUntilTodayEnabled :=
          (AftersalesCRMSetup."Show Orders" <> AftersalesCRMSetup."show orders"::"Orders Until Today") and
          IsChartAddInReady;
        DelayedOrdersEnabled := (AftersalesCRMSetup."Show Orders" <> AftersalesCRMSetup."show orders"::"Delayed Orders") and
          IsChartAddInReady;
        DayEnabled := (AftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."period length"::Day) and
          IsChartAddInReady;
        WeekEnabled := (AftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."period length"::Week) and
          IsChartAddInReady;
        MonthEnabled := (AftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."period length"::Month) and
          IsChartAddInReady;
        QuarterEnabled := (AftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."period length"::Quarter) and
          IsChartAddInReady;
        YearEnabled := (AftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."period length"::Year) and
          IsChartAddInReady;
        AmountEnabled :=
          (AftersalesCRMSetup."Value to Calculate" <> AftersalesCRMSetup."value to calculate"::"Amount Excl. VAT") and
          IsChartAddInReady;
        NoOfOrdersEnabled :=
          (AftersalesCRMSetup."Value to Calculate" <> AftersalesCRMSetup."value to calculate"::"No. of Orders") and
          IsChartAddInReady;
        StackedAreaEnabled := (AftersalesCRMSetup."Chart Type" <> AftersalesCRMSetup."chart type"::Line) and
          IsChartAddInReady;
        StackedAreaPctEnabled := (AftersalesCRMSetup."Chart Type" <> AftersalesCRMSetup."chart type"::"Step Line") and
          IsChartAddInReady;
        StackedColumnEnabled := (AftersalesCRMSetup."Chart Type" <> AftersalesCRMSetup."chart type"::"Stacked Area (%)") and
          IsChartAddInReady;
        StackedColumnPctEnabled :=
          (AftersalesCRMSetup."Chart Type" <> AftersalesCRMSetup."chart type"::"Stacked Column") and
          IsChartAddInReady;
    end;
}

