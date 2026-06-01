Page 25006808 "General Stockkeeping Unit List"
{
    ApplicationArea = Basic;
    Caption = 'General Stockkeeping Unit List';
    CardPageID = "General Stockkeeping Unit Card";
    Editable = false;
    PageType = List;
    SourceTable = "General Stockkeeping Unit";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(ReplenishmentSystem; Rec."Replenishment System")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(ReorderPoint; Rec."Reorder Point")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ReorderQuantity; Rec."Reorder Quantity")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MaximumInventory; Rec."Maximum Inventory")
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

