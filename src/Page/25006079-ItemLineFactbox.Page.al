Page 25006079 "Item Line Factbox"
{
    // 08.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Inventory
    // 
    // 02.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added Page and some fields CaptionML property

    Caption = 'Item Details - Requisition';
    PageType = CardPart;
    SourceTable = Item;

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
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = Basic;
            }
            field(ReservedQtyonInventory; Rec."Reserved Qty. on Inventory")
            {
                ApplicationArea = Basic;
                Caption = 'Reserved Qty. on Inventory';
            }
            field(QtyonPurchOrder; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = Basic;
                Caption = 'Qty. on Purch. Order';
            }
            field(SalesQuantity6M; Rec.GetSalesQty(-6))
            {
                ApplicationArea = Basic;
                Caption = 'Sales Quantity (-6M)';
            }
            field(SalesQuantity3M; Rec.GetSalesQty(-3))
            {
                ApplicationArea = Basic;
                Caption = 'Sales Quantity (-3M)';
            }
            field(SalesQuantity2M; Rec.GetSalesQty(-2))
            {
                ApplicationArea = Basic;
                Caption = 'Sales Quantity (-2M)';
            }
            field(SalesQuantity1M; Rec.GetSalesQty(-1))
            {
                ApplicationArea = Basic;
                Caption = 'Sales Quantity (-1M)';
            }
            field(SalesQuantitycurrentmonth; Rec.GetSalesQty(0))
            {
                ApplicationArea = Basic;
                Caption = 'Sales Quantity (current month)';
            }
        }
    }

    actions
    {
    }
}

