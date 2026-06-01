Page 25006783 "Integration Message Params Sub"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Integration Message Param EDMS";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(MessageID; Rec."Message ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(MessageLineNo; Rec."Message Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ParamName; Rec."Param Name")
                {
                    ApplicationArea = Basic;
                }
                field(ParamValue; Rec."Param Value")
                {
                    ApplicationArea = Basic;
                }
                field(Visible; Rec.Visible)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ModifiedByUser; Rec."Modified By User")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(DateTimeStamp; Rec."Date, Time Stamp")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceRefNo; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceBatchName; Rec."Source Batch Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceProdOrderLine; Rec."Source Prod. Order Line")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ItemLedgerEntryNo; Rec."Item Ledger Entry No.")
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

