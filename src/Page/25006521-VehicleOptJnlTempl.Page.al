Page 25006521 "Vehicle Opt. Jnl Templ."
{
    // 19.06.2004 EDMS P1
    //    * Created

    Caption = 'Vehicle Option Journal Templates';
    PageType = List;
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
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(PostingNoSeries; Rec."Posting No. Series")
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
        area(navigation)
        {
            group(Template)
            {
                Caption = 'Te&mplate';
                action(Batches)
                {
                    ApplicationArea = Basic;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "Vehicle Opt. Jnl. Batches";
                    RunPageLink = "Journal Template Name" = field(Name);
                }
            }
        }
    }
}

