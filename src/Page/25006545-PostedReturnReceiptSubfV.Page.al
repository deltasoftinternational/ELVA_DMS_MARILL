Page 25006545 "Posted Return Receipt Subf. V"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Return Receipt Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineType; Rec."Line Type")
                {
                    ApplicationArea = Basic;
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
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(ReturnReasonCode; Rec."Return Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(BinCode; Rec."Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
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
                field(QuantityInvoiced; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(ReturnQtyRcdNotInvd; Rec."Return Qty. Rcd. Not Invd.")
                {
                    ApplicationArea = Basic;
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(JobNo; Rec."Job No.")
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
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
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
                action(UndoReturnReceiptAction)
                {
                    ApplicationArea = Basic;
                    Caption = '&Undo Return Receipt';
                    Image = ReturnReceipt;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #6660. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnRcptLines.FORM.*/
                        UndoReturnReceipt;

                    end;
                }
            }
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
                        //This functionality was copied from page #6660. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnRcptLines.FORM.*/
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
                        //This functionality was copied from page #6660. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnRcptLines.FORM.*/
                        _ShowLineComments;

                    end;
                }
                action(ItemTrackingEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #6660. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnRcptLines.FORM.*/
                        _ShowItemTrackingLines;

                    end;
                }
                action(ItemCreditMemoLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Credit Memo &Lines';
                    Image = CreditMemo;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #6660. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnRcptLines.FORM.*/
                        _ShowItemSalesCrMemoLines;

                    end;
                }
            }
        }
    }


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure _ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;


    procedure ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;


    procedure UndoReturnReceipt()
    var
        ReturnRcptLine: Record "Return Receipt Line";
    begin
        ReturnRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(ReturnRcptLine);
        Codeunit.Run(Codeunit::"Undo Return Receipt Line", ReturnRcptLine);
    end;


    procedure _ShowItemSalesCrMemoLines()
    begin
        Rec.TestField(Type, Rec.Type::Item);
        Rec.ShowItemSalesCrMemoLines;
    end;


    procedure ShowItemSalesCrMemoLines()
    begin
        Rec.TestField(Type, Rec.Type::Item);
        Rec.ShowItemSalesCrMemoLines;
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

