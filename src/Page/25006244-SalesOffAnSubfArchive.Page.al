Page 25006244 "Sales Off. An. Subf. Archive"
{
    Editable = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Sales Analysis Line Archive";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field(QuantityinStock; Rec."Quantity in Stock")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(StockAverageUnitCost; Rec."Stock Average Unit Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(VendorStockQuantity; Rec."Vendor Stock Quantity")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(UnitFreightCost; Rec."Unit Freight Cost")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(TotalUnitCost; Rec."Total Unit Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(RetailPrice; Rec."Retail Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(RetailUnitPrice; Rec."Retail Unit Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(MarginRetail; Rec."Margin Retail %")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(RetailTotalPrice; Rec."Retail Total Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(OfferUnitPrice; Rec."Offer Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(OfferLineDiscount; Rec."Offer Line Discount %")
                {
                    ApplicationArea = Basic;
                    MinValue = 0;
                }
                field(Margin; Rec."Margin %")
                {
                    ApplicationArea = Basic;
                    MaxValue = 99.99;
                    MinValue = 0;
                }
                field(MarginAmount; Rec."Margin Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(TotalOfferPrice; Rec."Total Offer Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

