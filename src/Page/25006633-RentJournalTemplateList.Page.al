Page 25006633 "Rent Journal Template List"
{
    ApplicationArea = Basic;
    Caption = 'Rent Journal Template List';
    PageType = List;
    SourceTable = "Rent Journal Template";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field(TestReportID; Rec."Test Report ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the test report that is printed when you click Test Report.';
                }
                field(PageID; Rec."Page ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the page that is used to show the journal or worksheet that uses the template.';
                }
                field(PostingReportID; Rec."Posting Report ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting report that is printed when you choose Post and Print.';
                }
                field(ForcePostingReport; Rec."Force Posting Report")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether a report is printed automatically when you post.';
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
                field(Recurring; Rec.Recurring)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the journal template will be a recurring journal.';
                }
                field(TestReportName; Rec."Test Report Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the test report that is printed when you print a journal under this journal template.';
                }
                //field(FormName;"Form Name")
                //{
                //    ApplicationArea = Basic;
                //}
                field(PostingReportName; Rec."Posting Report Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the posting report that is used in this journal template.';
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
            }
        }
    }

    actions
    {
    }
}

