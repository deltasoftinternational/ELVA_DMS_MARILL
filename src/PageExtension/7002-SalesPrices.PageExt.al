pageextension 25006453 "Sales Prices" extends "Sales Prices"//7002
{
    layout
    {
        addafter("Variant Code")
        {
            field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
            {
                ApplicationArea = Basic;
                Visible = false;
                ToolTip = 'Specifies the ordering price type code for which the sales price is valid.';
            }
        }
    }
}