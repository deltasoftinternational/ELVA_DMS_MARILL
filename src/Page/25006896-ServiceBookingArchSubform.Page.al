Page 25006896 "Service Booking Arch. Subform"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Service Line Archive EDMS";
    SourceTableView = where("Document Type" = const(Booking));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(VariantCode; rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Nonstock; rec.Nonstock)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VATProdPostingGroup; rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(DropShipment; rec."Drop Shipment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LocationCode; rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Reserve; rec.Reserve)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasure; rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitCostLCY; rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitPrice; rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineAmount; rec."Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscount; rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmount; rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AllowInvoiceDisc; rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RequestedDeliveryDate; rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PromisedDeliveryDate; rec."Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(JobNo; rec."Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AppltoItemEntry; rec."Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension1Code; rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension2Code; rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    Rec.ShowDimensions;
                end;
            }
        }
    }
}

