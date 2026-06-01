Page 25006214 "Service Ret. Order Subf. EDMS"
{
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to (copy Resource modifications from Page 25006184):
    //     OnAfterGetRecord()
    //     OnNewRecord
    //     OnInsertRecord
    //     Resources - OnValidate()
    //     Resources - OnDrillDown()
    // 
    // 14.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added fields "Sell-to Customer Bill %", "Sell-to Customer Bill Amount"
    // 
    // 09.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added page action:
    //     <Action5> Dimensions
    //   Added fields:
    //     ShortcutDimCode[3]..[8]
    //   Added code to:
    //     OnAfterGetRecord()
    // 
    // 31.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Appl.-from Item Entry
    // 
    // 2012.09.14 EDMS P8
    //   * Added fields: "Minutes Per UoM", "Quantity (Hours)"

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Service Line EDMS";
    SourceTableView = where("Document Type" = filter("Return Order"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                    end;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        Rec.NoAssistEdit
                    end;
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
                field(DropShipment; Rec."Drop Shipment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate;
                    end;
                }
                field(BinCode; Rec."Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Control50; Rec.Reserve)
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReserveOnAfterValidate;
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                    end;
                }
                field(ReservedQuantity; Rec."Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(Resources; Resources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';

                    trigger OnDrillDown()
                    begin
                        // 12.05.2014 Elva Baltic P21 >>
                        // ServiceScheduleMgt.RelatedResourcesList("Document Type", "Document No.", Type, "Line No.", Resources);
                        CurrPage.SaveRecord;
                        Commit;
                        Rec.RelatedResourcesList(Resources);
                        Resources := Rec.getResourceTextFieldValue;
                        CurrPage.Update;
                        // 12.05.2014 Elva Baltic P21 <<
                    end;

                    trigger OnValidate()
                    begin
                        // 12.05.2014 Elva Baltic P21 >>
                        // ServiceScheduleMgt.SetRelatedResources("Document Type", "Document No.", Type, "Line No.", Resources, 0);
                        // Resources := ServiceScheduleMgt.GetRelatedResources("Document Type", "Document No.", Type, "Line No.", 0);

                        Rec.SetResourceTextFieldValue(Resources);
                        Resources := Rec.GetResourceTextFieldValue;
                        // 12.05.2014 Elva Baltic P21 <<
                    end;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida;
                    end;
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
                    BlankZero = true;
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
                field(Prepayment; Rec."Prepayment %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PrepmtLineAmount; Rec."Prepmt. Line Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PrepmtAmtInv; Rec."Prepmt. Amt. Inv.")
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
                field(PrepmtAmttoDeduct; Rec."Prepmt Amt to Deduct")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PrepmtAmtDeducted; Rec."Prepmt Amt Deducted")
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
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(TireOperationType; Rec."Tire Operation Type")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAxleCode; Rec."Vehicle Axle Code")
                {
                    ApplicationArea = Basic;
                }
                field(TirePositionCode; Rec."Tire Position Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = true;
                    DrillDownPageID = "Vehicle Tire Positions";
                    Lookup = true;
                    LookupPageID = "Vehicle Tire Positions";
                }
                field(TireCode; Rec."Tire Code")
                {
                    ApplicationArea = Basic;
                }
                field(NewVehicleAxleCode; Rec."New Vehicle Axle Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(NewTirePositionCode; Rec."New Tire Position Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MinutesPerUoM; Rec."Minutes Per UoM")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(QuantityHours; Rec."Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ApplfromItemEntry; Rec."Appl.-from Item Entry")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control25006004)
            {
                ShowCaption = false;
                group(Control25006008)
                {
                    ShowCaption = false;
                    field(SubtotalExclVAT; TotalServiceLine."Line Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Rec."Currency Code";
                        AutoFormatType = 1;
                        Caption = 'Subtotal Excl. VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.';
                    }
                    field("Invoice Discount Amount"; InvoiceDiscountAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Rec."Currency Code";
                        AutoFormatType = 1;
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.';

                        trigger OnValidate()
                        begin
                            //DocumentTotals.SalesDocTotalsNotUpToDate;
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                    field("Invoice Disc. Pct."; InvoiceDiscountPct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0 : 3;
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.';

                        trigger OnValidate()
                        begin
                            //DocumentTotals.SalesDocTotalsNotUpToDate;
                            AmountWithDiscountAllowed := DocumentTotals.CalcTotalServiceAmountOnlyDiscountAllowed(Rec);
                            InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                }
                group(Control25006003)
                {
                    ShowCaption = false;
                    field("Total Amount Excl. VAT"; TotalServiceLine.Amount)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Total VAT';
                        Editable = false;
                    }
                    field("Total Amount Incl. VAT"; TotalServiceLine."Amount Including VAT")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Total Amount Incl. VAT';
                        DrillDown = false;
                        Editable = false;
                    }
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
                            Rec.ItemAvailability(0);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            Rec.ItemAvailability(1);
                        end;
                    }
                    action(Location)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            Rec.ItemAvailability(2);
                        end;
                    }
                }
                action(ReservationEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        _ShowReservationEntries;
                    end;
                }
                action(ItemTrackingLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        Rec.OpenItemTrackingLines;
                    end;
                }
                action(SelectItemSubstitution)
                {
                    ApplicationArea = Basic;
                    Caption = 'Select Item Substitution';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    begin
                        Rec.ShowItemSub;
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
                        Rec.ShowDimensions;
                    end;
                }
                action(OrderPromising)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Promising';
                    Image = OrderPromising;

                    trigger OnAction()
                    begin
                        OrderPromisingLine;
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(GetPrice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Price';
                    Ellipsis = true;
                    Image = Price;

                    trigger OnAction()
                    begin
                        ShowPrices
                    end;
                }
                action(GetLineDiscount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Li&ne Discount';
                    Ellipsis = true;
                    Image = LineDiscount;

                    trigger OnAction()
                    begin
                        ShowLineDisc
                    end;
                }
                action(ExplodeBOMAction)
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction()
                    begin
                        ExplodeBOM;
                    end;
                }
                action(Reserve)
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve';
                    Ellipsis = true;
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        _ShowReservation;
                    end;
                }
                action(OrderTracking)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        ShowTracking;
                    end;
                }
                action("<Action1905968604>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonstoc&k Items';
                    Image = NonStockItem;

                    trigger OnAction()
                    begin
                        ShowNonstockItems;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocumentTotals.CalculateServiceSubPageTotals(Rec, TotalServiceLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        CurrPageIsEditable := CurrPage.Editable;
        InvDiscAmountEditable := CurrPageIsEditable and not SalesSetup."Calc. Inv. Discount";
    end;

    trigger OnAfterGetRecord()
    begin
        //ShowShortcutDimCode(ShortcutDimCode);//29.10.2012 EDMS
        // Resources := ServiceScheduleMgt.GetRelatedResources("Document Type", "Document No.", Type, "Line No.", 0);   // 12.05.2014 Elva Baltic P21
        Resources := Rec.GetResourceTextFieldValue;                                                                         // 12.05.2014 Elva Baltic P21

        Rec.ShowShortcutDimCode(ShortcutDimCode);                       // 09.04.2014 Elva Baltic P21
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        /*
        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          COMMIT;
          IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
            EXIT(FALSE);
          ReserveSalesLine.DeleteLine(Rec);
        END;
        */
        DocumentTotals.CalculateServiceSubPageTotals(Rec, TotalServiceLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.SetResourceTextFieldValue(Resources);                                                                           // 12.05.2014 Elva Baltic P21
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := xRec.Type;
        Clear(ShortcutDimCode);
        Clear(Resources);

        Rec.SetResourceTextFieldValue(Resources);                                                                           // 12.05.2014 Elva Baltic P21
    end;

    var
        ServiceHeader: Record "Service Header EDMS";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        ShortcutDimCode: array[8] of Code[20];
        Text001: label 'You can not use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        [InDataSet]
        ItemPanelVisible: Boolean;
        [InDataSet]
        Resources: Text[250];
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        TotalServiceHeader: Record "Service Header EDMS";
        VATAmount: Decimal;
        DocumentTotals: Codeunit "Service Document Totals";
        TotalServiceLine: Record "Service Line EDMS";
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        InvDiscAmountEditable: Boolean;
        ServCalcDiscEDMS: Codeunit "Service-Calc. Discount EDMS";
        AmountWithDiscountAllowed: Decimal;
        Currency: Record Currency;
        CurrPageIsEditable: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";


    procedure ApproveCalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Service-Disc. EDMS (Yes/No)", Rec);
    end;


    procedure CalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Service-Calc. Discount EDMS", Rec);
    end;


    procedure ExplodeBOM()
    var
        PurchOrder: Page "Purchase Order";
    begin
        if Rec."Prepmt. Amt. Inv." <> 0 then
            Error(Text001);
        Codeunit.Run(Codeunit::"Service-Explode BOM EDMS", Rec);
    end;


    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
    begin
        Rec.TestField("Purchase Order No.");
        PurchHeader.SetRange("No.", Rec."Purchase Order No.");
        PurchOrder.SetTableview(PurchHeader);
        PurchOrder.Editable := false;
        PurchOrder.Run;
    end;


    procedure _ShowReservation()
    begin
        Rec.Find;
        Rec.ShowReservation;
    end;


    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        Rec.ItemAvailability(AvailabilityType);
    end;


    procedure _ShowReservationEntries()
    begin
        Rec.ShowReservationEntries(true);
    end;


    procedure ShowItemSub()
    begin
        Rec.ShowItemSub;
    end;


    procedure ShowNonstockItems()
    begin
        //Rec.ShowNonstock;
    end;


    procedure OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;


    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetServiceLine(Rec);
        TrackingForm.RunModal;
    end;


    procedure ItemChargeAssgnt()
    begin
        //Rec.ShowItemChargeAssgnt;
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;


    procedure ShowPrices()
    begin
        ServiceHeader.Get(Rec."Document Type", Rec."Document No.");
        Clear(SalesPriceCalcMgt);
        //*DELTA SALESPRICE
        SalesPriceCalcMgt.GetDMSServLinePrice(ServiceHeader, Rec);
    end;


    procedure ShowLineDisc()
    begin
        ServiceHeader.Get(Rec."Document Type", Rec."Document No.");
        Clear(SalesPriceCalcMgt);
        //*DELTA SALESPRICE
        SalesPriceCalcMgt.GetDMSServLineLineDisc(ServiceHeader, Rec);
    end;


    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
    begin
        OrderPromisingLine.SetRange("Source Type", OrderPromisingLine."source type"::Job);
        OrderPromisingLine.SetRange("Source ID", Rec."Document No.");
        OrderPromisingLine.SetRange("Source Line No.", Rec."Line No.");
        Page.RunModal(page::"Order Promising Lines EDMS", OrderPromisingLine);
    end;

    local procedure TypeOnAfterValidate()
    begin
        ItemPanelVisible := Rec.Type = Rec.Type::Item;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        //InsertExtendedText(FALSE);
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        if (Rec.Reserve = Rec.Reserve::Always) and
           (Rec."Outstanding Qty. (Base)" <> 0) and
           (Rec."Location Code" <> xRec."Location Code")
        then begin
            CurrPage.SaveRecord;
            Rec.AutoReserve;
            CurrPage.Update(false);
        end;
    end;

    local procedure ReserveOnAfterValidate()
    begin
        if (Rec.Reserve = Rec.Reserve::Always) and (Rec."Outstanding Qty. (Base)" <> 0) then begin
            CurrPage.SaveRecord;
            Rec.AutoReserve;
            CurrPage.Update(false);
        end;
    end;

    local procedure QuantityOnAfterValidate()
    var
        UpdateIsDone: Boolean;
    begin
        if Rec.Type = Rec.Type::Item then
            case Rec.Reserve of
                Rec.Reserve::Always:
                    begin
                        CurrPage.SaveRecord;
                        Rec.AutoReserve;
                        CurrPage.Update(false);
                        UpdateIsDone := true;
                    end;
                Rec.Reserve::Optional:
                    if (Rec.Quantity < xRec.Quantity) and (xRec.Quantity > 0) then begin
                        CurrPage.SaveRecord;
                        CurrPage.Update(false);
                        UpdateIsDone := true;
                    end;
            end;

        if (Rec.Type = Rec.Type::Item) and
           (Rec.Quantity <> xRec.Quantity) and
           not UpdateIsDone
        then
            CurrPage.Update(true);
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        if rec.Reserve = rec.Reserve::Always then begin
            CurrPage.SaveRecord;
            rec.AutoReserve;
            CurrPage.Update(false);
        end;
    end;


    procedure SetRecSelectionFilter(var ServLine: Record "Service Line EDMS")
    begin
        CurrPage.SetSelectionFilter(ServLine);
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        ServiceHeaderToCalc: Record "Service Header EDMS";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        ServiceHeaderToCalc.Get(Rec."Document Type", Rec."Document No.");

        ServCalcDiscEDMS.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, ServiceHeaderToCalc);
        CurrPage.Update(false);
    end;
}

