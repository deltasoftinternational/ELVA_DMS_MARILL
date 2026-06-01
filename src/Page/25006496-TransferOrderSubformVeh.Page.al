Page 25006496 "Transfer Order Subform (Veh.)"
{
    AutoSplitKey = true;
    Caption = 'Vehicle Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Transfer Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlanningFlexibility; Rec."Planning Flexibility")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(TransferfromBinCode; Rec."Transfer-from Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(TransferToBinCode; Rec."Transfer-To Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(ReservedQuantityInbnd; Rec."Reserved Quantity Inbnd.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(ReservedQuantityShipped; Rec."Reserved Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(ReservedQuantityOutbnd; Rec."Reserved Quantity Outbnd.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
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
                field(QtytoShip; Rec."Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(QuantityShipped; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        TransShptLine: Record "Transfer Shipment Line";
                    begin
                        Rec.TestField("Document No.");
                        Rec.TestField("Item No.");
                        TransShptLine.SetCurrentkey("Transfer Order No.", "Item No.", "Shipment Date");
                        TransShptLine.SetRange("Transfer Order No.", Rec."Document No.");
                        TransShptLine.SetRange("Item No.", Rec."Item No.");
                        Page.RunModal(0, TransShptLine);
                    end;
                }
                field(QtytoReceive; Rec."Qty. to Receive")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(QuantityReceived; Rec."Quantity Received")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        TransRcptLine: Record "Transfer Receipt Line";
                    begin
                        Rec.TestField("Document No.");
                        Rec.TestField("Item No.");
                        TransRcptLine.SetCurrentkey("Transfer Order No.", "Item No.", "Receipt Date");
                        TransRcptLine.SetRange("Transfer Order No.", Rec."Document No.");
                        TransRcptLine.SetRange("Item No.", Rec."Item No.");
                        Page.RunModal(0, TransRcptLine);
                    end;
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(ReceiptDate; Rec."Receipt Date")
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
                field(OutboundWhseHandlingTime; Rec."Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(InboundWhseHandlingTime; Rec."Inbound Whse. Handling Time")
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
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
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
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Reserve)
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                        /*CurrPage.TransferLines.PAGE.*/
                        _ShowReservation;

                    end;
                }
            }
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                group(ItemAvailabilityby)
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            //_ItemAvailability(0);//30.10.2012 EDMS
                            TransferAvailabilityMgt.ShowItemAvailabilityFromTransLine(Rec, "Item Availability Type"::Period);

                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            //_ItemAvailability(1); //30.10.2012 EDMS
                            TransferAvailabilityMgt.ShowItemAvailabilityFromTransLine(Rec, "Item Availability Type"::Variant);

                        end;
                    }
                    action(Location)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            //_ItemAvailability(2);//30.10.2012 EDMS
                            TransferAvailabilityMgt.ShowItemAvailabilityFromTransLine(Rec, "Item Availability Type"::Location);

                        end;
                    }
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                        /*CurrPage.TransferLines.PAGE.*/
                        _ShowDimensions;

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveTransferLine: Codeunit "Transfer Line-Reserve";
    begin
        Commit;
        if not ReserveTransferLine.DeleteLineConfirm(Rec) then
            exit(false);
        ReserveTransferLine.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array[8] of Code[20];
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        TransferAvailabilityMgt: Codeunit "Transfer Availability Mgt.";

    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure _ShowReservation()
    begin
        Rec.Find;
        Rec.ShowReservation;
    end;


    procedure ShowReservation()
    begin
        Rec.Find;
        Rec.ShowReservation;
    end;


    procedure _OpenItemTrackingLines(Direction: Option Outbound,Inbound)
    begin
        Rec.OpenItemTrackingLines(Direction);
    end;


    procedure OpenItemTrackingLines(Direction: Option Outbound,Inbound)
    begin
        Rec.OpenItemTrackingLines(Direction);
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;
}

