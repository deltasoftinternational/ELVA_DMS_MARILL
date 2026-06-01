Page 25006807 "General Stockkeeping Unit Card"
{
    Caption = 'General Stockkeeping Unit Card';
    PageType = Card;
    SourceTable = "General Stockkeeping Unit";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field(SpecialEquipmentCode; Rec."Special Equipment Code")
                {
                    ApplicationArea = Basic;
                }
                field(PutawayTemplateCode; Rec."Put-away Template Code")
                {
                    ApplicationArea = Basic;
                }
                field(PhysInvtCountingPeriodCode; Rec."Phys Invt Counting Period Code")
                {
                    ApplicationArea = Basic;
                }
                field(LastCountingPeriodUpdate; Rec."Last Counting Period Update")
                {
                    ApplicationArea = Basic;
                }
                field(NextCountingPeriod; Rec."Next Counting Period")
                {
                    ApplicationArea = Basic;
                }
                field(UseCrossDocking; Rec."Use Cross-Docking")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                field(ReplenishmentSystem; Rec."Replenishment System")
                {
                    ApplicationArea = Basic;
                }
                field(ReorderingPolicy; Rec."Reordering Policy")
                {
                    ApplicationArea = Basic;
                }
                group(Purchase)
                {
                    Caption = 'Purchase';
                    field(VendorNo; Rec."Vendor No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(LeadTimeCalculation; Rec."Lead Time Calculation")
                    {
                        ApplicationArea = Basic;
                    }
                }
                group(Transfer)
                {
                    Caption = 'Transfer';
                    field(TransferfromCode; Rec."Transfer-from Code")
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
        }
    }

    actions
    {
    }
}

