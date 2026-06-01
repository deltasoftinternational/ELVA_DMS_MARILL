Page 25006469 "Sales Order Subform (Veh.)"
{
    // 26.02.2015 EDMS P21
    //   Added Item OptionCaption to "Line Type"
    // 
    // 27.05.2014 Elva Baltic P7 #S0121 MMG7.00
    //   * New action added - CreateVehicle;
    // 
    // 24.05.2013 Elva Baltic P15
    //   * Added handling of Create PDI function in Sales Order Subform(Veh.)

    AutoSplitKey = true;
    Caption = 'Vehicle Lines';
    DelayedInsert = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter(Order));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LineType; Rec."Line Type")
                {
                    ApplicationArea = All;
                    OptionCaption = ' ,G/L Account,Item,,,,Vehicle,,Charge (Item),Fixed Asset,Resource';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                        UpdateEditableOnRow;
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
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;

                        UpdateEditableOnRow;
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

                    trigger OnLookup(var Text: Text): Boolean
                    Var
                        SalesHeader: Record "Sales Header";
                        ItemReferenceMgt: Codeunit "Item Reference Management";
                    begin
                        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                        ItemReferenceMgt.SalesReferenceNoLookup(Rec, SalesHeader);
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

                    trigger OnValidate()
                    begin
                        UpdateEditableOnRow;
                    end;
                }
                field(Control26; Rec."Drop Shipment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Control106; Rec."Special Order")
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
                        CurrPage.Update;
                    end;
                }
                field(Reserved; Rec.Reserved)
                {
                    ApplicationArea = Basic;
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
                field(SalesPriceExist; Rec.PriceExists)
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
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(SalesLineDiscExists; Rec.LineDiscExists)
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
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(IncludeInVehSalesAmt; Rec."Include In Veh. Sales Amt.")
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
                field(QtytoShip; Rec."Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(QuantityShipped; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(QtytoInvoice; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(QuantityInvoiced; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
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
                        CurrPage.Update(false);
                    end;
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

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
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
                field(WorkTypeCode; Rec."Work Type Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(WhseOutstandingQtyBase; Rec."Whse. Outstanding Qty. (Base)")
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
                field("<Variable Field Run 1>"; Rec."Variable Field Run 1")
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
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = All;
                }
            }
            group(Control25)
            {
                ShowCaption = false;
                group(Control23)
                {
                    ShowCaption = false;
                    field(SubtotalExclVAT; TotalSalesLine."Line Amount")
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
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(Rec.FIELDCAPTION("Inv. Discount Amount"), Currency.Code);
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.';

                        trigger OnValidate()
                        begin
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                    field("Invoice Disc. Pct."; InvoiceDiscountPct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0 : 2;
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.';

                        trigger OnValidate()
                        begin
                            InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                }
                group(Control15)
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
                            //This functionality was copied from page #42. Unsupported part was commented. Please check it.
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
                            //This functionality was copied from page #42. Unsupported part was commented. Please check it.
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
                            //This functionality was copied from page #42. Unsupported part was commented. Please check it.
                            /*CurrPage.SalesLines.PAGE.*/
                            //_ItemAvailability(2);//30.10.2012 EDMS
                            SalesAvailabilityMgt.ShowItemAvailabilityFromSalesLine(Rec, "Item Availability Type"::Location)

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
                action(ReservationEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        if Rec."Line Type" = Rec."Line Type"::Vehicle then
                            _ShowReservationEntries
                        else
                            Rec.ShowReservationEntries(true);
                    end;
                }
                action(SelectItemSubstitution)
                {
                    ApplicationArea = Basic;
                    Caption = 'Select Item Substitution';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
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
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
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
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
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
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ItemChargeAssgnt;

                    end;
                }
                action(ItemTrackingLines)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';
                    Enabled = Rec.Type = Rec.Type::Item;
                    ToolTip = 'View or edit serial and lot numbers for the selected item. This action is available only for lines that contain an item.';

                    trigger OnAction()
                    begin
                        Rec.OpenItemTrackingLines();
                    end;
                }
                action(OrderPromising)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Promising';
                    Image = OrderPromising;

                    trigger OnAction()
                    begin
                        VehicleOrderPromising
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("<Action1101914010>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Vehicle';
                    Image = Item;

                    trigger OnAction()
                    begin
                        Rec.CreateVehicle;
                    end;
                }
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
                    Caption = 'Get Price';
                    Ellipsis = true;
                    Image = SalesPrices;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
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
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
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
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
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
                action(ApplyDeal)
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Deal';
                    Image = Confirm;

                    trigger OnAction()
                    begin
                        Rec.ApplyDealDocuments
                    end;
                }
                action(InsertExtTexts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert &Ext. Texts';
                    Image = Text;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        _InsertExtendedText(true);

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
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        _ShowReservation;

                    end;
                }
                action(NonstockItems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonstoc&k Items';
                    Image = Item;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #42. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ShowNonstockItems;

                    end;
                }
                action("PDI Create from Sales")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create &PDI Service Document';
                    Image = ServiceAgreement;

                    trigger OnAction()
                    var
                        VehicleAssembly: Record "Vehicle Assembly Line";
                        VehicleOptionMgt: Codeunit VehicleOptionManagement;
                        MakeSetup: Record "Make Setup";
                        ServicePackageVersion: Record "Service Package Version";
                        VehicleAssemblyTmp: Record "Vehicle Assembly Line" temporary;
                        CreatePDIDoc: Report "Create PDI Service Order";
                        SalesLine: Record "Sales Line";
                    begin
                        SalesLine.Reset;
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        SalesLine.SetRange("Document No.", Rec."Document No.");
                        SalesLine.SetRange("Line No.", Rec."Line No.");
                        CreatePDIDoc.SetTableview(SalesLine);
                        CreatePDIDoc.RunModal;
                        //24.05.2013 Elva Baltic P15 >>

                        //IF "Vehicle Assembly ID" <> '' THEN BEGIN
                        //  VehicleAssembly.RESET;
                        //  VehicleAssembly.SETRANGE("Assembly ID","Vehicle Assembly ID");
                        //  IF VehicleAssembly.FINDFIRST THEN// BEGIN
                        //    VehicleOptionMgt.CreatePDIdocFromAssemblyLine(VehicleAssembly)
                        //  END ELSE
                        //    MESSAGE(Text002,VehicleAssembly.TABLECAPTION);
                        //END ELSE BEGIN
                        //END;

                        //24.05.2013 Elva Baltic P15 <<
                    end;
                }
                action("Apply Vehicle Marginal VAT")
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Vehicle Marginal VAT';
                    Image = VATEntries;

                    trigger OnAction()
                    begin
                        Rec.ApplyVehMarginalVAT
                    end;
                }
                action(ReplacementOverview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Replacement Overview';
                    Image = ItemSubstitution;

                    trigger OnAction()
                    var
                        Item: Record Item;
                        ItemSubstSync: Codeunit "Item Substitution Sync";
                        TypePar: Option Item,"Nonstock Item";
                    begin
                        IF Rec.Type = Rec.Type::Item THEN BEGIN
                            Item.GET(Rec."No.");
                            ItemSubstSync.ShowReplacementOverview(TypePar::"Nonstock Item", Item.GetSourceNonstockEntryNo(), '');
                        END;
                    end;
                }
            }
            group("Order")
            {
                Caption = 'O&rder';
                Image = "Order";
                group(DropShipment)
                {
                    Caption = 'Dr&op Shipment';
                    Image = Delivery;
                    action(PurchaseOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase &Order';
                        Image = Document;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #42. Unsupported part was commented. Please check it.
                            /*CurrPage.SalesLines.PAGE.*/
                            OpenPurchOrderForm;

                        end;
                    }
                }
                group(SpecialOrder)
                {
                    Caption = 'Speci&al Order';
                    Image = SpecialOrder;
                    action(Action1903192904)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase &Order';
                        Image = Document;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #42. Unsupported part was commented. Please check it.
                            /*CurrPage.SalesLines.PAGE.*/
                            OpenSpecialPurchOrderForm;

                        end;
                    }
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
        UpdateEditableOnRow;
        CalculateTotals;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        Clear(DocumentTotals);
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
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesAvailabilityMgt: Codeunit "Sales Availability Mgt.";
        PurchOrder: Page "Purchase Order";
        ShortcutDimCode: array[8] of Code[20];
        Text001: label 'You can not use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        [InDataSet]
        ItemPanelVisible: Boolean;
        Text002: label 'Create records in %1 first.';

        InvoiceDiscountAmount: Decimal;
        InvDiscAmountEditable: Boolean;
        UpdateInvDiscountQst: label 'One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?';
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        InvoiceDiscountPct: Decimal;
        AmountWithDiscountAllowed: Decimal;
        VATAmount: Decimal;
        SalesSetup: Record "Sales & Receivables Setup";
        IsCommentLine: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;

    protected Var
        Currency: Record Currency;
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        DocumentTotals: Codeunit "Document Totals";


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
        if Rec."Prepmt. Amt. Inv." <> 0 then
            Error(Text001);
        Codeunit.Run(Codeunit::"Sales-Explode BOM", Rec);
    end;


    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
    begin
        Rec.TestField("Purchase Order No.");
        PurchHeader.SetRange("No.", Rec."Purchase Order No.");
        PurchOrder.SetTableview(PurchHeader);
        PurchOrder.Editable := false;
        PurchOrder.Run;
    end;


    procedure OpenSpecialPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
    begin
        Rec.TestField("Special Order Purchase No.");
        PurchHeader.SetRange("No.", Rec."Special Order Purchase No.");
        PurchOrder.SetTableview(PurchHeader);
        PurchOrder.Editable := false;
        PurchOrder.Run;
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


    procedure _ShowReservation()
    begin
        Rec.Find;
        Rec.ShowVehReservation;
    end;


    procedure ShowReservation()
    begin
        Rec.Find;
        Rec.ShowVehReservation;
    end;


    procedure _ShowReservationEntries()
    begin
        Rec.ShowVehReservationEntries(true);
    end;


    procedure ShowReservationEntries()
    begin
        Rec.ShowReservationEntries(true);
    end;


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
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


    procedure _OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;


    procedure OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;


    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        // TrackingForm.SetSalesLine(Rec);
        TrackingForm.RunModal;
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


    procedure _OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
    begin
        OrderPromisingLine.SetRange("Source Type", Rec."Document Type");
        OrderPromisingLine.SetRange("Source ID", Rec."Document No.");
        OrderPromisingLine.SetRange("Source Line No.", Rec."Line No.");
        Page.RunModal(page::"Order Promising Lines EDMS", OrderPromisingLine);
    end;


    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
    begin
        OrderPromisingLine.SetRange("Source Type", Rec."Document Type");
        OrderPromisingLine.SetRange("Source ID", Rec."Document No.");
        OrderPromisingLine.SetRange("Source Line No.", Rec."Line No.");
        Page.RunModal(page::"Order Promising Lines EDMS", OrderPromisingLine);
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

        if (Rec.Reserve = Rec.Reserve::Always) and
           (Rec."Outstanding Qty. (Base)" <> 0) and
           (Rec."No." <> xRec."No.")
        then begin
            CurrPage.SaveRecord;
            Rec.AutoReserve;
            CurrPage.Update(false);
        end;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(false);
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
        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord;
            Rec.AutoReserve;
            CurrPage.Update(false);
        end;
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        if (Rec.Reserve = Rec.Reserve::Always) and
           (Rec."Outstanding Qty. (Base)" <> 0) and
           (Rec."Shipment Date" <> xRec."Shipment Date")
        then begin
            CurrPage.SaveRecord;
            Rec.AutoReserve;
            CurrPage.Update(false);
        end;
    end;


    procedure VehicleOrderPromising()
    var
        SalesLine: Record "Sales Line";
    begin
        if Rec."Line Type" <> Rec."line type"::Vehicle then
            exit;
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."Document No.");
        SalesLine.SetRange("Line No.", Rec."Line No.");
        SalesLine.FindFirst;
        if Page.RunModal(Page::"Vehicle Order Promissing", SalesLine) = Action::LookupOK then;
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if SalesHeader.InvoicedLineExists then
            if not Confirm(UpdateInvDiscountQst, false) then
                exit;

        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
        CurrPage.Update(false);
    end;

    local procedure CalculateTotals()
    begin
        GetTotalSalesHeader;
        TotalSalesHeader.CalcFields("Recalculate Invoice Disc.");

        if SalesSetup."Calc. Inv. Discount" and (Rec."Document No." <> '') and (TotalSalesHeader."Customer Posting Group" <> '') and
           TotalSalesHeader."Recalculate Invoice Disc."
        then
            if Rec.Find then
                CalcInvDisc;

        DocumentTotals.CalculateSalesPageTotals(TotalSalesLine, VATAmount, Rec);
        AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
        InvoiceDiscountAmount := TotalSalesLine."Inv. Discount Amount";
        InvoiceDiscountPct := SalesCalcDiscountByType.GetCustInvoiceDiscountPct(Rec);
    end;

    local procedure GetTotalSalesHeader()
    begin
        if not TotalSalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            Clear(TotalSalesHeader);
        if Currency.Code <> TotalSalesHeader."Currency Code" then
            if not Currency.Get(TotalSalesHeader."Currency Code") then begin
                Clear(Currency);
                Currency.InitRoundingPrecision;
            end
    end;

    local procedure UpdateEditableOnRow()
    var
        SalesLine: Record "Sales Line";
    begin
        IsCommentLine := not Rec.HasTypeToFillMandatoryFields;
        if not IsCommentLine then
            UnitofMeasureCodeIsChangeable := Rec.CanEditUnitOfMeasureCode
        else
            UnitofMeasureCodeIsChangeable := false;

        if TotalSalesHeader."No." <> '' then begin
            SalesLine.SetRange("Document No.", TotalSalesHeader."No.");
            SalesLine.SetRange("Document Type", TotalSalesHeader."Document Type");
            if not SalesLine.IsEmpty then
                InvDiscAmountEditable :=
                  SalesCalcDiscountByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") and CurrPage.Editable;
        end;
    end;
}

