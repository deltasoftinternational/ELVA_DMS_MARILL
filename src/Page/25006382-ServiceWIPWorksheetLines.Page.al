Page 25006382 "Service WIP Worksheet Lines"
{
    PageType = ListPart;
    SourceTable = "Service Order WIP Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field(Finished; Rec.Finished)
                {
                    ApplicationArea = Basic;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(UnitPriceLCY; Rec."Unit Price (LCY)")
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

