Page 25006224 "Ext. Service Journal Templates"
{
    ApplicationArea = Basic;
    Caption = 'External Service Journal Templates';
    PageType = List;
    SourceTable = "Ext. Service Journal Template";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1190000)
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
                    ToolTip = 'Specifies the code for the number series that will be used to assign document numbers to ledger entries that are posted from journals using this template.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action29>")
            {
                Caption = 'Te&mplate';
                action("<Action30>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "Ext. Service Jnl. Batches";
                    RunPageLink = "Journal Template Name" = field(Name);
                }
            }
        }
    }
}

