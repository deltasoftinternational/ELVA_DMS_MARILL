Report 25006133 "Calc. Expected Service Dates"
{
    // 13.06.2013 EDMS P8
    //   * Recreated

    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Vehicle Service Plan"; "Vehicle Service Plan")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ServicePlanMgt);
                ServicePlanMgt.CalcExpectedServiceDate("Vehicle Serial No.", "No.", 1);
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Active);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ServicePlanMgt: Codeunit "Service Plan Management";
}

