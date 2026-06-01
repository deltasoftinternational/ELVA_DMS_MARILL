Report 25006318 "Service WIP Recalculate"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(ServiceOrderWIPHeader; "Service Order WIP Header")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ServWIPMgt);
                ServWIPMgt.ReCalcWIP(ServiceOrderWIPHeader);
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
        ServWIPMgt: Codeunit "Service WIP Management";
}

