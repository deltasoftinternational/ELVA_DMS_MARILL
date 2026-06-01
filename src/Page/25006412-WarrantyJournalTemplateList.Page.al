Page 25006412 "Warranty Journal Template List"
{
    Caption = 'Warranty Journal Template List';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Warranty Journal Template";

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
                    Visible = false;
                    ToolTip = 'Specifies whether the journal template will be a recurring journal.';
                }
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                }
                //field(FormID;"Form ID")
                //{
                //    ApplicationArea = Basic;
                //    LookupPageID = Objects;
                //    Visible = false;
                //}
                field(TestReportID; Rec."Test Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    Visible = false;
                    ToolTip = 'Specifies the test report that is printed when you click Test Report.';
                }
                field(PostingReportID; Rec."Posting Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    Visible = false;
                    ToolTip = 'Specifies the posting report that is printed when you choose Post and Print.';
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
    }
}

