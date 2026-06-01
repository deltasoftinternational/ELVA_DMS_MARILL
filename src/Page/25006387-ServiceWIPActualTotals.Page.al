Page 25006387 "Service WIP Actual Totals"
{
    Caption = 'Service Order WIP Actual Totals';
    PageType = CardPart;
    SourceTable = "Service WIP Total";

    layout
    {
        area(content)
        {
            field(ServiceOrderNo; Rec."Service Order No.")
            {
                ApplicationArea = Basic;
            }
            field(WIPTotals; Rec."WIP Totals")
            {
                ApplicationArea = Basic;
            }
            field(ItemCAmtPosted; Rec."Item C. Amt. (Posted)")
            {
                ApplicationArea = Basic;
            }
            field(ItemSAmtPosted; Rec."Item S. Amt. (Posted)")
            {
                ApplicationArea = Basic;
            }
            field(LaborCAmtPosted; Rec."Labor C. Amt. (Posted)")
            {
                ApplicationArea = Basic;
            }
            field(LaborSAmtPosted; Rec."Labor S. Amt. (Posted)")
            {
                ApplicationArea = Basic;
            }
            field(ExtSCAmtPosted; Rec."Ext.S. C. Amt. (Posted)")
            {
                ApplicationArea = Basic;
            }
            field(ExtSSAmtPosted; Rec."Ext.S. S. Amt. (Posted)")
            {
                ApplicationArea = Basic;
            }
            field(CostAmtPosted; Rec."Cost Amt. (Posted)")
            {
                ApplicationArea = Basic;
            }
            field(SalesAmtPosted; Rec."Sales Amt. (Posted)")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
    }
}

