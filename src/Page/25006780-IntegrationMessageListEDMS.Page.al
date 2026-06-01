Page 25006780 "Integration Message List EDMS"
{
    ApplicationArea = Basic;
    Caption = 'Integration Message List';
    CardPageID = "Integration Message Card EDMS";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Integration Message EDMS";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = Basic;
                }
                field(MethodCode; Rec."Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(ConnectorCode; Rec."Connector Code")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalID; Rec."External ID")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                }
                field(SourceBatchName; Rec."Source Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field(SourceProdOrderLine; Rec."Source Prod. Order Line")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceRefNo; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(ItemLedgerEntryNo; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EntryCount; Rec."Entry Count")
                {
                    ApplicationArea = Basic;
                }
                field(EntryCount1stLevel; Rec."Entry Count (1st Level)")
                {
                    ApplicationArea = Basic;
                }
                field(ErrorDescription; Rec."Error Description")
                {
                    ApplicationArea = Basic;
                }
                field(StartedAt; Rec."Started At")
                {
                    ApplicationArea = Basic;
                }
                field(WaitingAt; Rec."Waiting At")
                {
                    ApplicationArea = Basic;
                }
                field(FinishedAt; Rec."Finished At")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(InitiatorSide; Rec."Initiator Side")
                {
                    ApplicationArea = Basic;
                }
                field(SingleInstance; Rec."Single Instance")
                {
                    ApplicationArea = Basic;
                }
                field(CallNextMethodCode; Rec."Call Next Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(PreviouseMessageID; Rec."Previouse Message ID")
                {
                    ApplicationArea = Basic;
                }
                field(IterationNo; Rec."Iteration No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

