Page 25006389 "Posted Service WIP Lines"
{
    Caption = 'Posted Service WIP Lines';
    PageType = List;
    SourceTable = "Posted Serv. WIP Order Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderNo; Rec."Service Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderLineNo; Rec."Service Order Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(WIPMethod; Rec."WIP Method")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderDate; Rec."Service Order Date.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(FinishedQty; Rec."Finished Qty.")
                {
                    ApplicationArea = Basic;
                }
                field(Finished; Rec.Finished)
                {
                    ApplicationArea = Basic;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(RecognizedCostQty; Rec."Recognized Cost Qty.")
                {
                    ApplicationArea = Basic;
                }
                field(RecognizedSalesQty; Rec."Recognized Sales Qty.")
                {
                    ApplicationArea = Basic;
                }
                field(RecognizedCostAmount; Rec."Recognized Cost Amount")
                {
                    ApplicationArea = Basic;
                }
                field(RecognizedSalesAmount; Rec."Recognized Sales Amount")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalServTrackingNo; Rec."External Serv. Tracking No.")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(RecognizedCostQtyCalc; Rec."Recognized Cost Qty. (Calc)")
                {
                    ApplicationArea = Basic;
                }
                field(RecognizedSalesQtyCalc; Rec."Recognized Sales Qty. (Calc)")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyFactor; Rec."Currency Factor")
                {
                    ApplicationArea = Basic;
                }
                field(UnitPriceLCY; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(AmountLCY; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(VAT; Rec."VAT %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(DimensionSetID; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

