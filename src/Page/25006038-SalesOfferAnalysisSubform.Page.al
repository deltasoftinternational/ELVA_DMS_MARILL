Page 25006038 "Sales Offer Analysis Subform"
{
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Sales Analysis Line";

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
                field(VendorStockQuantityOld; Rec."Vendor Stock Quantity")
                {
                    ApplicationArea = Basic;
                    Caption = '<Vendor Stock Quantity (Old)>';
                    Editable = false;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(UnitFreightCost; Rec."Unit Freight Cost")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
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

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(OfferLineDiscount; Rec."Offer Line Discount %")
                {
                    ApplicationArea = Basic;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(Margin; Rec."Margin %")
                {
                    ApplicationArea = Basic;
                    MaxValue = 99.99;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
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

