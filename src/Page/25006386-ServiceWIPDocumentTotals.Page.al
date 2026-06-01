Page 25006386 "Service WIP Document Totals"
{
    Caption = 'Service Order WIP Document Totals';
    PageType = CardPart;
    SourceTable = "Service Order WIP Header";

    layout
    {
        area(content)
        {
            field(ServiceOrderNo; Rec."Service Order No.")
            {
                ApplicationArea = Basic;
                Editable = false;
                ShowCaption = true;
            }
            field(ItemCostAmt; Rec."Item Cost Amt.")
            {
                ApplicationArea = Basic;
            }
            field(ItemSalesAmt; Rec."Item Sales Amt.")
            {
                ApplicationArea = Basic;
            }
            field(LaborCostAmt; Rec."Labor Cost Amt.")
            {
                ApplicationArea = Basic;
            }
            field(LaborSalesAmt; Rec."Labor Sales Amt.")
            {
                ApplicationArea = Basic;
            }
            field(ExtSCostAmt; Rec."Ext. S. Cost Amt.")
            {
                ApplicationArea = Basic;
            }
            field(ExtSSalesAmt; Rec."Ext. S. Sales Amt.")
            {
                ApplicationArea = Basic;
            }
            field(TotalCostAmt; Rec."Total Cost Amt.")
            {
                ApplicationArea = Basic;
            }
            field(TotalSalesAmt; Rec."Total Sales Amt.")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
    }
}

