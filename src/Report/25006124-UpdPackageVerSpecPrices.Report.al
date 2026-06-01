Report 25006124 "Upd. Package Ver. Spec. Prices"
{
    Caption = 'Upd. Package Ver. Spec. Prices';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Package Version"; "Service Package Version")
        {
            column(ReportForNavId_8356; 8356)
            {
            }
            dataitem("Service Package Version Spec."; "Service Package Version Line")
            {
                DataItemLink = "Package No." = field("Package No."), "Version No." = field("Version No.");
                DataItemTableView = sorting("Package No.", "Version No.", "Line No.");
                column(ReportForNavId_8636; 8636)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Type <> Type::"Comment" then begin
                        UpdateUnitPrice(FieldNo("No."));
                        Modify;
                    end;
                end;
            }
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
}

