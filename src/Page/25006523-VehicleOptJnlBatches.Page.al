Page 25006523 "Vehicle Opt. Jnl. Batches"
{
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 19.06.2004 EDMS P1
    //    * Created

    Caption = 'Vehicle Option Journal Batches';
    DataCaptionExpression = fDataCaption;
    PageType = List;
    SourceTable = "Vehicle Opt. Jnl. Batch";

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
                field(JournalTemplateName; Rec."Journal Template Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the journal template name of the journal you are creating.';
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
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = Post;
                    RunObject = Codeunit "Vehicle Opt. Jnl.-B.Post";
                    ShortCutKey = 'F11';
                }
                action(PostandPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    RunObject = Codeunit "Vehicle Opt. Jnl.-B.Post+Print";
                    ShortCutKey = 'Shift+F11';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.fSetupNewBatch;
    end;

    local procedure fDataCaption(): Text[250]
    var
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        if not CurrPage.LookupMode then
            if Rec.GetFilter("Journal Template Name") <> '' then
                if Rec.GetRangeMin("Journal Template Name") = Rec.GetRangemax("Journal Template Name") then
                    if ItemJnlTemplate.Get(Rec.GetRangeMin("Journal Template Name")) then
                        exit(ItemJnlTemplate.Name + ' ' + ItemJnlTemplate.Description);
    end;
}

