Page 25006632 "Rent Jnl. Batches"
{
    ApplicationArea = Basic;
    Caption = 'Rent Journal Batches';
    PageType = List;
    SourceTable = "Rent Journal Batch";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(JournalTemplateName; Rec."Journal Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the journal template name of the journal you are creating.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the journal you are creating.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a brief description of the journal batch you are creating.';
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series from which entry or record numbers are assigned to new entries or records.';
                }
                field(PostingNoSeries; Rec."Posting No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign document numbers to ledger entries that are posted from this journal batch.';
                }
                field(Recurring; Rec.Recurring)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the journal batch will be a recurring journal.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Codeunit "Res. Jnl.-B.Post";
                ShortCutKey = 'F11';
            }
            action(PostAndPrint)
            {
                ApplicationArea = Basic;
                Caption = 'Post and &Print';
                RunObject = Codeunit "Res. Jnl.-B.Post+Print";
                ShortCutKey = 'Shift+F11';
            }
        }
    }
}

