Page 25006414 "Warranty Journal Templates"
{
    ApplicationArea = Basic;
    Caption = 'Warranty Journal Templates';
    PageType = List;
    SourceTable = "Warranty Journal Template";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the journal template you are creating.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a brief description of the journal template you are creating.';
                }
                field(Recurring; Rec.Recurring)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the journal template will be a recurring journal.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series from which entry or record numbers are assigned to new entries or records.';
                }
                field(PostingNoSeries; Rec."Posting No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign document numbers to ledger entries that are posted from journals using this template.';
                }
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                }
                //field(FormID;"Form ID")
                //{   ApplicationArea = Basic;
                //    LookupPageID = Objects;
                //    Visible = false;
                //}
                //field(FormName;"Form Name")
                //{
                //    ApplicationArea = Basic;
                //    DrillDown = false;
                //    Visible = false;
                //}
                field(TestReportID; Rec."Test Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    Visible = false;
                    ToolTip = 'Specifies the test report that is printed when you click Test Report.';
                }
                field(TestReportName; Rec."Test Report Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Visible = false;
                    ToolTip = 'Specifies the name of the test report that is printed when you print a journal under this journal template.';
                }
                field(PostingReportID; Rec."Posting Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    Visible = false;
                    ToolTip = 'Specifies the posting report that is printed when you choose Post and Print.';
                }
                field(PostingReportName; Rec."Posting Report Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Visible = false;
                    ToolTip = 'Specifies the name of the report that is printed when you print the journal.';
                }
                field(ForcePostingReport; Rec."Force Posting Report")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies whether a report is printed automatically when you post.';
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
                    RunObject = Page "Warranty Jnl. Batches";
                    RunPageLink = "Journal Template Name" = field(Name);
                }
            }
        }
    }
}

