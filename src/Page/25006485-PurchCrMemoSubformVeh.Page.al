Page 25006485 "Purch. Cr. Memo Subform (Veh.)"
{
    AutoSplitKey = true;
    Caption = 'Vehicle Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = filter("Credit Memo"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LineType; Rec."Line Type")
                {
                    ApplicationArea = Basic;
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

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;
                    end;
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
                    Visible = false;
                }
                field(VehicleAssemblyID; Rec."Vehicle Assembly ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleStatusCode; Rec."Vehicle Status Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CrossReferenceNo; Rec."Item Reference No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    Var
                        ItemReferenceMgt: Codeunit "Item Reference Management";
                    begin
                        ItemReferenceMgt.PurchaseReferenceNoLookup(Rec);
                        InsertExtendedText(false);
                    end;

                    trigger OnValidate()
                    begin
                        CrossReferenceNoOnAfterValidat;
                    end;
                }
                field(ICPartnerCode; Rec."IC Partner Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ICPartnerRefType; Rec."IC Partner Ref. Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ICPartnerReference; Rec."IC Partner Reference")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariantCode; Rec."Variant Code")
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
                field(ReturnReasonCode; Rec."Return Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(DirectUnitCost; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(IndirectCost; Rec."Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitCostLCY; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitPriceLCY; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
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
                field(AllowItemChargeAssignment; Rec."Allow Item Charge Assignment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(QtytoAssign; Rec."Qty. to Assign")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        Rec.ShowItemChargeAssgnt;
                        UpdateForm(false);
                    end;
                }
                field(QtyAssigned; Rec."Qty. Assigned")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        Rec.ShowItemChargeAssgnt;
                        UpdateForm(false);
                    end;
                }
                field(JobNo; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(JobLineType; Rec."Job Line Type")
                {
                    ApplicationArea = Basic;
                }
                field(JobTaskNo; Rec."Job Task No.")
                {
                    ApplicationArea = Basic;
                }
                field(JobUnitPrice; Rec."Job Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(JobTotalPrice; Rec."Job Total Price")
                {
                    ApplicationArea = Basic;
                }
                field(JobLineAmount; Rec."Job Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field(JobLineDiscountAmount; Rec."Job Line Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(JobLineDiscount; Rec."Job Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(JobUnitPriceLCY; Rec."Job Unit Price (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(JobTotalPriceLCY; Rec."Job Total Price (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(JobLineAmountLCY; Rec."Job Line Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(JobLineDiscAmountLCY; Rec."Job Line Disc. Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(ProdOrderNo; Rec."Prod. Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(InsuranceNo; Rec."Insurance No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BudgetedFANo; Rec."Budgeted FA No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(FAPostingType; Rec."FA Posting Type")
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
                field(DeprAcquisitionCost; Rec."Depr. Acquisition Cost")
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
                action(ExplodeBOMAction)
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #52. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchLines.PAGE.*/
                        ExplodeBOM;

                    end;
                }
                action(InsertExtTexts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert &Ext. Texts';
                    Image = Text;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #52. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchLines.PAGE.*/
                        _InsertExtendedText(true);

                    end;
                }
                action(GetReturnShipmentLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Return &Shipment Lines';
                    Ellipsis = true;
                    Image = ReturnShipment;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #52. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchLines.PAGE.*/
                        GetReturnShipment;

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
                            //This functionality was copied from page #52. Unsupported part was commented. Please check it.
                            /*CurrPage.PurchLines.PAGE.*/
                            //_ItemAvailability(0);//30.10.2012 EDMS
                            PurchAvailabilityMgt.ShowItemAvailabilityFromPurchLine(Rec, "Item Availability Type"::Period)

                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #52. Unsupported part was commented. Please check it.
                            /*CurrPage.PurchLines.PAGE.*/
                            //_ItemAvailability(1);//30.10.2012 EDMS
                            PurchAvailabilityMgt.ShowItemAvailabilityFromPurchLine(Rec, "Item Availability Type"::Variant)

                        end;
                    }
                    action(Location)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #52. Unsupported part was commented. Please check it.
                            /*CurrPage.PurchLines.PAGE.*/
                            //_ItemAvailability(2);//30.10.2012 EDMS
                            PurchAvailabilityMgt.ShowItemAvailabilityFromPurchLine(Rec, "Item Availability Type"::Location)

                        end;
                    }
                }
                action("<Action1101904010>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Assembly';
                    Image = CheckList;

                    trigger OnAction()
                    begin
                        Rec.VehicleAssembly;
                        UpdateForm(false);
                    end;
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #52. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchLines.PAGE.*/
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
                        //This functionality was copied from page #52. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchLines.PAGE.*/
                        _ShowLineComments;

                    end;
                }
                action(ItemChargeAssignment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Charge &Assignment';
                    Image = ItemRegisters;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #52. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchLines.PAGE.*/
                        ItemChargeAssgnt;

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
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
    begin
        if (Rec.Quantity <> 0) and Rec.ItemExists(Rec."No.") then begin
            Commit;
            if not ReservePurchLine.DeleteLineConfirm(Rec) then
                exit(false);
            ReservePurchLine.DeleteLine(Rec);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := xRec.Type;
        Rec."Line Type" := xRec."Line Type";
        Rec."Document Profile" := Rec."document profile"::"Vehicles Trade";
        Clear(ShortcutDimCode);
    end;

    var
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        PurchAvailabilityMgt: Codeunit "Purch. Availability Mgt.";
        ShortcutDimCode: array[8] of Code[20];
        UpdateAllowedVar: Boolean;
        Text000: label 'Unable to execute this function while in view only mode.';


    procedure ApproveCalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Purch.-Disc. (Yes/No)", Rec);
    end;


    procedure CalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Purch.-Calc.Discount", Rec);
    end;


    procedure ExplodeBOM()
    begin
        Codeunit.Run(Codeunit::"Purch.-Explode BOM", Rec);
    end;


    procedure GetReturnShipment()
    begin
        Codeunit.Run(Codeunit::"Purch.-Get Return Shipments", Rec);
    end;


    procedure _InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord;
            TransferExtendedText.InsertPurchExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
            UpdateForm(true);
    end;


    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord;
            TransferExtendedText.InsertPurchExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
            UpdateForm(true);
    end;


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ItemChargeAssgnt()
    begin
        Rec.ShowItemChargeAssgnt;
    end;


    procedure _OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;


    procedure OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;


    procedure SetUpdateAllowed(UpdateAllowed: Boolean)
    begin
        UpdateAllowedVar := UpdateAllowed;
    end;


    procedure UpdateAllowed(): Boolean
    begin
        if UpdateAllowedVar = false then begin
            Message(Text000);
            exit(false);
        end else
            exit(true);
    end;


    procedure _ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;


    procedure ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
        if (Rec.Type = Rec.Type::"Charge (Item)") and (Rec."No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SaveRecord;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(false);
    end;
}

