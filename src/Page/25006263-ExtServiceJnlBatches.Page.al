Page 25006263 "Ext. Service Jnl. Batches"
{
    Caption = 'Ext. Service Jnl. Batches';
    PageType = List;
    SourceTable = "External Serv. Journal Batch";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
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
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Posting)
            {
                Caption = 'P&osting';
                action("<Action1101901000>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ItemSalesDocMgtEDMS: Codeunit "Item Sales Doc. Mgt. EDMS";
                    begin
                        ItemSalesDocMgtEDMS.PrintExtServJnlBatch(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Ext. Service Jnl.-B.Post";
                    ShortCutKey = 'F11';
                }
                action(PostandPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Ext. Service Jnl.-B.Post+Print";
                    ShortCutKey = 'Shift+F11';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewBatch;
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
}

