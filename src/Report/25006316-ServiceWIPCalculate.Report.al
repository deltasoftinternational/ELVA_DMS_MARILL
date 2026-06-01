Report 25006316 "Service WIP Calculate"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(ServiceHeaderEDMS; "Service Header EDMS")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ServWIPMgt);
                ServWIPMgt.CalcWIP(ServiceHeaderEDMS, '', WIPDate, true);
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Document Type", ServiceHeaderEDMS."document type"::Order);
                if not Confirm(TEXT01, false, ServiceHeaderEDMS.GetFilters) then
                    exit;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(WIPDate; WIPDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'WIP Calculation Date';
                }
            }
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
        WIPDate: Date;
        DocumentNo: Code[20];
        DeleteCalculated: Boolean;
        Confirm: Dialog;
        TEXT01: label 'All WIP Service Order Worksheet Data for Service Orders in filter: \ %1 \ will be deleted. Do You want to continue?';
}

