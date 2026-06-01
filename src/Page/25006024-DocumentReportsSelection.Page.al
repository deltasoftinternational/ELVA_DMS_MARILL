Page 25006024 "Document Reports-Selection"
{
    Caption = 'Document Reports - Selection';
    Editable = false;
    PageType = List;
    SourceTable = "Document Report";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(ReportID; rec."Report ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShowReportName; rec.ShowReportName)
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

