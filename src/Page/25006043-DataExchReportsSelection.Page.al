Page 25006043 "Data Exch. Reports-Selection"
{
    Caption = 'Data Exch. Reports-Selection';
    Editable = false;
    PageType = List;
    SourceTable = "Data Exch. Reports";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(ReportID; Rec."Report ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShowReportName; Rec.ShowReportName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Name';
                }
            }
        }
    }

    actions
    {
    }
}

