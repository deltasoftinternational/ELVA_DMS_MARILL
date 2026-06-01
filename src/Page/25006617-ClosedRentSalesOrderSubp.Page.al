Page 25006617 "Closed Rent Sales Order Subp."
{
    Caption = 'Closed Rent Sales Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Rent Sales Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LineNo; Rec."Line No.")
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
                field(Prepayment; Rec."Prepayment %")
                {
                    ApplicationArea = Basic;
                }
                field(PrepmtLineAmount; Rec."Prepmt. Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Nonstock; Rec.Nonstock)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(DropShipment; Rec."Drop Shipment")
                {
                    ApplicationArea = Basic;
                }
                field(SpecialOrder; Rec."Special Order")
                {
                    ApplicationArea = Basic;
                }
                field(BinCode; Rec."Bin Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(UnitCostLCY; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(PrepmtAmtInv; Rec."Prepmt. Amt. Inv.")
                {
                    ApplicationArea = Basic;
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                }
                field(InvDiscountAmount; Rec."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(ReservedQuantity; Rec."Reserved Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(QuantityShipped; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field(PromisedDeliveryDate; Rec."Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field(PlannedDeliveryDate; Rec."Planned Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field(PlannedShipmentDate; Rec."Planned Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingAgentCode; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingTime; Rec."Shipping Time")
                {
                    ApplicationArea = Basic;
                }
                field(OutboundWhseHandlingTime; Rec."Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                }
                field(AttachedtoRentLineNo; Rec."Attached to Rent Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(ToInvoice; Rec."To Invoice")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
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
                field("Extra Charge Line"; Rec."Extra Charge Line")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup25006041)
            {
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';

                    trigger OnAction()
                    begin
                        //ShowDimensions;
                    end;
                }
            }
        }
    }
}

