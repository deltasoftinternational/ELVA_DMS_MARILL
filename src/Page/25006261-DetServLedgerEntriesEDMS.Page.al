Page 25006261 "Det. Serv. Ledger Entries EDMS"
{
    // 11.06.2015 EB.P30 #T041
    //   Added fields:
    //     "Finished Quantity (Hours)"
    //     "Unit Cost"
    //     "Cost Amount"

    Caption = 'Det. Serv. Ledger Entries EDMS';
    Editable = false;
    PageType = List;
    SourceTable = "Det. Serv. Ledger Entry EDMS";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ServiceLedgerEntryNo; Rec."Service Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                    Visible = false;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(FinishedQuantityHours; Rec."Finished Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(CostAmount; Rec."Cost Amount")
                {
                    ApplicationArea = Basic;
                }
                field(QuantityHours; Rec."Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(FinishedQtyHoursTravel; Rec."Finished Qty. (Hours) Travel")
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

