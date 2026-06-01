Page 25006426 "BLS Journal Templates"
{
    Caption = 'BLS Journal Templates';
    PageType = List;
    SourceTable = "BLS Journal Template";

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
                field(Recurring; Rec.Recurring)
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
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field(PageID; Rec."Page ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    Visible = false;
                }
                field(PageCaption; Rec."Page Caption")
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
                field(TestReportCaption; Rec."Test Report Caption")
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
                field(PostingReportCaption; Rec."Posting Report Caption")
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
                field(DoNotIncreaseBatchName; Rec."Do Not Increase Batch Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
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
                Image = Template;
                action(Batches)
                {
                    ApplicationArea = Basic;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageLink = "Journal Template Name" = field(Name);
                }
            }
        }
    }
}

