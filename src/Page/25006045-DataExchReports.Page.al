Page 25006045 "Data Exch. Reports"
{
    ApplicationArea = Basic;
    Caption = 'Data Exch. Reports';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Data Exch. Reports";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(DocumentProfile; Rec."Document Profile")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentFunctionalType; Rec."Document Functional Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Basic;
                }
                field(ReportID; Rec."Report ID")
                {
                    ApplicationArea = Basic;
                }
                field(ReportName; Rec."Report Name")
                {
                    ApplicationArea = Basic;
                }
                field(TakeFromLines; Rec."Take From Lines")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

