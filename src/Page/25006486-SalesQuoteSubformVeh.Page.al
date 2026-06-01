Page 25006486 "Sales Quote Subform (Veh.)"
{
    // 26.02.2015 EDMS P21
    //   Added Item OptionCaption to "Line Type"

    AutoSplitKey = true;
    Caption = 'Vehicle Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter(Quote));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LineType; Rec."Line Type")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,G/L Account,Item,,,,Vehicle,,Charge (Item),Fixed Asset,Resource';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                    end;
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
                    trigger OnValidate()
                    begin

                        DeltaUpdateTotals();
                    end;
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
                        ItemReferenceMgt.SalesReferenceNoLookup(Rec);
                        InsertExtendedText(false);
                        CurrPage.Update();
                    end;

                    trigger OnValidate()
                    begin
                        CrossReferenceNoOnAfterValidat;
                    end;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
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
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                        DeltaUpdateTotals();
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
                field(PriceExists; Rec.PriceExists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Price Exists';
                    Editable = false;
                    Visible = false;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(LineDiscExists; Rec.LineDiscExists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Line Disc. Exists';
                    Editable = false;
                    Visible = false;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
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
                field(WorkTypeCode; Rec."Work Type Code")
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
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control53)
            {
                ShowCaption = false;
                group(Control49)
                {
                    ShowCaption = false;
                    field("Subtotal Excl. VAT"; TotalSalesLine."Line Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code, TotalSalesHeader."Prices Including VAT");
                        Caption = 'Subtotal Excl. VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.';
                    }
                    field("Invoice Discount Amount"; InvoiceDiscountAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(Rec.FieldCaption("Inv. Discount Amount"), Currency.Code);
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount amount that is deducted from the value of the Total Incl. VAT field, based on sales lines where the Allow Invoice Disc. field is selected. You can enter or change the amount manually.';

                        trigger OnValidate()
                        begin
                            ValidateInvoiceDiscountAmount();
                        end;
                    }
                    field("Invoice Disc. Pct."; InvoiceDiscountPct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0 : 3;
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount percentage that is applied to the invoice, based on sales lines where the Allow Invoice Disc. field is selected. The percentage and criteria are defined in the Customer Invoice Discounts page, but you can enter or change the percentage manually.';

                        trigger OnValidate()
                        begin
                            AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
                            InvoiceDiscountAmount := Round(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
                            ValidateInvoiceDiscountAmount();
                        end;
                    }
                }
                group(Control35)
                {
                    ShowCaption = false;
                    field("Total Amount Excl. VAT"; TotalSalesLine.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                        Caption = 'Total VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                        Caption = 'Total Amount Incl. VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
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
                action(ChangeVehicle)
                {
                    ApplicationArea = Basic;
                    Caption = 'Change Assigned Vehicle';
                    Image = Item;

                    trigger OnAction()
                    begin
                        Rec.ChangeVehicle;
                    end;
                }

                action(GetPrice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get &Price';
                    Ellipsis = true;
                    Image = SalesPrices;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
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
                        //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
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
                        //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ExplodeBOM;

                    end;
                }
                action(ApplyTradeIn)
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Trade-In';
                    Image = Sales;

                    trigger OnAction()
                    begin
                        Rec.VehTradeIn
                    end;
                }
                action(InsertExtTexts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert &Ext. Texts';
                    Image = Text;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        _InsertExtendedText(true);

                    end;
                }
                action(NonstockItems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonstoc&k Items';
                    Image = Item;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ShowNonstockItems;

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
                            //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                            /*CurrPage.SalesLines.PAGE.*/
                            //_ItemAvailability(0);//30.10.2012 EDMS
                            SalesAvailabilityMgt.ShowItemAvailabilityFromSalesLine(Rec, "Item Availability Type"::Period)

                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                            /*CurrPage.SalesLines.PAGE.*/
                            //_ItemAvailability(1);//30.10.2012 EDMS
                            SalesAvailabilityMgt.ShowItemAvailabilityFromSalesLine(Rec, "Item Availability Type"::Variant)

                        end;
                    }
                    action(Location)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                            /*CurrPage.SalesLines.PAGE.*/
                            //_ItemAvailability(2);//30.10.2012 EDMS
                            SalesAvailabilityMgt.ShowItemAvailabilityFromSalesLine(Rec, "Item Availability Type"::Location)

                        end;
                    }
                }
                action(Action1101904010)
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
                action(SelectItemSubstitution)
                {
                    ApplicationArea = Basic;
                    Caption = 'Select Item Substitution';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        _ShowItemSub;

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
                        //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
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
                        //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
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
                        //This functionality was copied from page #41. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ItemChargeAssgnt;

                    end;
                }
            }
            action(VehicleAssembly)
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
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetTotalSalesHeader();
        CalculateTotals();
        // UpdateEditableOnRow();
        //  UpdateTypeText();
        //  SetItemChargeFieldsStyle();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        if (Rec.Quantity <> 0) and Rec.ItemExists(Rec."No.") then begin
            Commit;
            if not ReserveSalesLine.DeleteLineConfirm(Rec) then
                exit(false);
            ReserveSalesLine.DeleteLine(Rec);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := xRec.Type;
        //EDMS >>
        Rec."Line Type" := xRec."Line Type";
        Rec."Document Profile" := Rec."document profile"::"Vehicles Trade";
        //EDMS <<
        Clear(ShortcutDimCode);
    end;

    var
        SalesHeader: Record "Sales Header";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesAvailabilityMgt: Codeunit "Sales Availability Mgt.";
        ShortcutDimCode: array[8] of Code[20];
        [InDataSet]
        ItemPanelVisible: Boolean;

        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";

    protected var
        Currency: Record Currency;
        SuppressTotals: Boolean;
        VATAmount: Decimal;
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        DocumentTotals: Codeunit "Document Totals";
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        InvDiscAmountEditable: Boolean;
        AmountWithDiscountAllowed: Decimal;


    procedure ApproveCalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Sales-Disc. (Yes/No)", Rec);
    end;


    procedure CalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Sales-Calc. Discount", Rec);
    end;


    procedure ExplodeBOM()
    begin
        Codeunit.Run(Codeunit::"Sales-Explode BOM", Rec);
    end;


    procedure _InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord;
            TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
            UpdateForm(true);
    end;


    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord;
            TransferExtendedText.InsertSalesExtText(Rec);
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


    procedure _OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;


    procedure OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;


    procedure _ShowItemSub()
    begin
        Rec.ShowItemSub;
    end;


    procedure ShowItemSub()
    begin
        Rec.ShowItemSub;
    end;


    procedure ShowNonstockItems()
    begin
        Rec.ShowNonstock;
    end;


    procedure ItemChargeAssgnt()
    begin
        Rec.ShowItemChargeAssgnt;
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;


    procedure ShowPrices()
    begin
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader, Rec);
    end;


    procedure ShowLineDisc()
    begin
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader, Rec);
    end;


    procedure _ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;


    procedure ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;

    local procedure TypeOnAfterValidate()
    begin
        ItemPanelVisible := Rec.Type = Rec.Type::Item;
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

    local procedure QuantityOnAfterValidate()
    begin
        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord;
            Rec.AutoReserve;
        end;
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord;
            Rec.AutoReserve;
        end;
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SuppressTotals then
            exit;

        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
        DocumentTotals.SalesDocTotalsNotUpToDate();
        CurrPage.Update(false);
    end;


    local procedure GetTotalSalesHeader()
    begin
        DocumentTotals.GetTotalSalesHeaderAndCurrency(Rec, TotalSalesHeader, Currency);
    end;


    procedure CalculateTotals()
    begin
        //        OnBeforeCalculateTotals(TotalSalesLine, SuppressTotals);

        if SuppressTotals then
            exit;

        DocumentTotals.CalculateSalesPageTotals(TotalSalesLine, VATAmount, Rec);
        DocumentTotals.SalesCheckIfDocumentChanged(Rec, xRec);
        DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        DocumentTotals.RefreshSalesLine(Rec);
    end;

    procedure DeltaUpdateTotals()
    var
        IsHandled: Boolean;
    begin
        if SuppressTotals then
            exit;

        IsHandled := false;
        //OnBeforeDeltaUpdateTotals(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        DocumentTotals.SalesDeltaUpdateTotals(Rec, xRec, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        if Rec."Line Amount" <> xRec."Line Amount" then
            Rec.SendLineInvoiceDiscountResetNotification();
    end;


}

