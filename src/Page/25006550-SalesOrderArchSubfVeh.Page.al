Page 25006550 "Sales Order Arch. Subf. (Veh.)"
{
    // 20.02.2015 EB.P7 #Arch. Return Ord.
    //   Renewed EDMS fields from Sales Line

    Caption = 'Vehicle Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Line Archive";
    SourceTableView = where("Document Type" = const(Order));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LineType; Rec."Line Type")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,G/L Account,,,,,Vehicle,,Charge (Item),Fixed Asset,Resource';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleStatusCode; Rec."Vehicle Status Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleAssemblyID; Rec."Vehicle Assembly ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CrossReferenceNo; Rec."Item Reference No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SubstitutionAvailable; Rec."Substitution Available")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PurchasingCode; Rec."Purchasing Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Nonstock; Rec.Nonstock)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(DropShipment; Rec."Drop Shipment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SpecialOrder; Rec."Special Order")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ReturnReasonCode; Rec."Return Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitCostLCY; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                    Visible = false;
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(InvDiscountAmount; Rec."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(QtytoShip; Rec."Qty. to Ship")
                {
                    ApplicationArea = Basic;
                }
                field(QuantityShipped; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic;
                }
                field(QtytoInvoice; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Basic;
                }
                field(QuantityInvoiced; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                }
                field(AllowItemChargeAssignment; Rec."Allow Item Charge Assignment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RequestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PromisedDeliveryDate; Rec."Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                    Visible = false;
                }
                field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShippingTime; Rec."Shipping Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(JobNo; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(OutboundWhseHandlingTime; Rec."Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BlanketOrderNo; Rec."Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BlanketOrderLineNo; Rec."Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(FAPostingDate; Rec."FA Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DepruntilFAPostingDate; Rec."Depr. until FA Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DepreciationBookCode; Rec."Depreciation Book Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UseDuplicationList; Rec."Use Duplication List")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DuplicateinDepreciationBook; Rec."Duplicate in Depreciation Book")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ApplfromItemEntry; Rec."Appl.-from Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AppltoItemEntry; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
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
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5159. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLinesArchive.PAGE.*/
                        _ShowDimensions;

                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5159. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLinesArchive.PAGE.*/
                        _ShowLineComments;

                    end;
                }
                action(VehicleAssembly)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Assembly';
                    Image = CheckList;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //EDMS >>
        Rec."Line Type" := xRec."Line Type";
        Rec."Document Profile" := Rec."document profile"::"Vehicles Trade";
        //EDMS <<
    end;


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure _ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;


    procedure ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;
}

