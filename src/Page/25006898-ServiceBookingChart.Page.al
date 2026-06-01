Page 25006898 "Service Booking Chart"
{
    PageType = ListPart;
    SourceTable = "Business Chart Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            usercontrol(Chart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = All;

                /*   trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                   begin
                   end;

                   trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
                   begin
                   end;

                    trigger AddInReady()
                    begin
                        ChartIsReady := TRUE;
                        UpdateChart;
                    end;*/

                trigger AddInReady()
                begin
                    ChartIsReady := TRUE;
                    UpdateChart;
                end;

                trigger Refresh()
                begin
                    UpdateChart;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        LocationCode := BookingMgt.GetDefaultLocationCode;
        SelectedDate := WorkDate;
    end;

    var
        ChartIsReady: Boolean;
        BusChartBuf: Record "Business Chart Buffer";
        BookingChartMgt: Codeunit "Service Booking Chart Mgt.";
        LocationCode: Code[20];
        SelectedDate: Date;
        BookingMgt: Codeunit "Booking Management";


    procedure UpdateChart()
    begin
        //IF NOT ChartIsReady THEN
        //    EXIT;

        BookingChartMgt.SetSelectedDate(SelectedDate);
        BookingChartMgt.SetLocationCode(LocationCode);
        BookingChartMgt.ResourceCapacity(BusChartBuf);
        //BusChartBuf.Update(CurrPage.Chart);
    end;


    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;


    procedure SetSelectedDate(SelectedDateToSet: Date)
    begin
        SelectedDate := SelectedDateToSet;
    end;
}

