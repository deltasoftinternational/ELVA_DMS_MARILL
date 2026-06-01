pageextension 25006095 "Item Charges" extends "Item Charges"//5800
{
    layout
    {

        addlast(Control1)
        {
            field(InventoryPostingGroup; Rec."Inventory Posting Group")
            {
                ApplicationArea = Basic;
            }
        }
    }
}