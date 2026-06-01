Page 25006522 "Vehicle Opt. Jnl. Templ. List"
{
    // 19.06.2004 EDMS P1
    //    * Created

    Caption = 'Vehicle Option Journal Template List';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Vehicle Opt. Jnl. Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(FormID; Rec."Form ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    Visible = false;
                }
                field(FormName; Rec."Form Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Visible = false;
                }
                field(TestReportID; Rec."Test Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    Visible = false;
                }
                field(TestReportName; Rec."Test Report Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Visible = false;
                }
                field(PostingReportID; Rec."Posting Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    Visible = false;
                }
                field(PostingReportName; Rec."Posting Report Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Visible = false;
                }
                field(ForcePostingReport; Rec."Force Posting Report")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

