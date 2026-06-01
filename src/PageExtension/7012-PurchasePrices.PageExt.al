pageextension 25006455 "Purchase Prices" extends "Purchase Prices"//7012
{
    layout
    {
        addafter("Ending Date")
        {
            field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}