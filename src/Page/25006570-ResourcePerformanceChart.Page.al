Page 25006570 "Resource Performance Chart"
{
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            /* usercontrol(Chart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
             {
                 ApplicationArea = Basic;

                 // trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                 // begin
                 // end;

                 // trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
                 // begin
                 // end;

                 trigger AddInReady()
                 begin
                     UpdateChart;
                 end;
             }*/
        }
    }

    actions
    {
    }

    var
        BusChartBuf: Record "Business Chart Buffer";
        PerformanceChartMgt: Codeunit "Res. Performance Chart Mgt.";


    procedure UpdateChart()
    var
        Period: Option " ",Next,Previous;
    begin
        PerformanceChartMgt.UpdateData(BusChartBuf, Period);
        //BusChartBuf.Update(CurrPage.Chart);
    end;
}

