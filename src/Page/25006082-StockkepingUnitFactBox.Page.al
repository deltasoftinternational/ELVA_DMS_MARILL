Page 25006082 "Stockkeping Unit FactBox"
{
    // 02.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added Page CaptionML property

    Caption = 'Stockkeping Unit Details';
    PageType = CardPart;
    SourceTable = "Stockkeeping Unit";

    layout
    {
        area(content)
        {
            field(ReorderPoint; Rec."Reorder Point")
            {
                ApplicationArea = Basic;
            }
            field(MaximumInventory; Rec."Maximum Inventory")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
    }
}

