
pageextension 25006474 "Item Template Card" extends "Item Templ. Card" //1342
{
    layout
    {
        addafter(Warehouse)
        {
            group(EDMS)
            {
                Caption = 'EDMS';
                field(ItemType; Rec."Item Type")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        modify(Reserve)
        {
            Visible = True;
        }
    }
}