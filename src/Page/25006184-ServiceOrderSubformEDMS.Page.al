Page 25006184 "Service Order Subform EDMS"
{
    // 05.07.2016 EB.P7 #PAR28
    //   "No." OnLookup() added code from Service Line EDMS
    //   "No." OnValidate added update code
    // 
    // 30.05.2016 EB.P7 #PAR28
    //   Added field:
    //     25006998Has Replacement
    //   Action added Apply Replacement
    // 
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Res. Cost Amount Finished"
    //     "Res. Cost Amount Remaining"
    //     "Res. Cost Amount Total"
    // 
    // 13.05.2014 Elva Baltic P7 # MMG7.00
    //   * New field added "Amount Enter In Line No."
    // 
    // 30.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Commented code on triggers (don't need autoreserve):
    //     Location Code - OnValidate()
    //     Unit of Measure Code - OnValidate()
    //     Reserve - OnValidate()
    // 
    // 22.04.2014 Elva Baltic P7 # MMG7.00
    //   * New field added "Amount Enter In Line No."
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added Fields ShortcutDimCode[3]..[8]
    //   BlankZero property for field "Transfered Quantity"
    //   Added Code to
    //     OnAfterGetRecord()
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     OnDeleteRecord()
    // 
    // 28.03.2014 Elva baltic P18 #RX032 MMG7.00
    //   Added field "Unit Price Excluding VAT"
    // 
    // 22.03.2014 Elva Baltic P1 #RX MMG7.00
    //   * Visible=TRUE set for fields:
    //    - Standard Time
    //    - Transfered Quantity
    // 
    // 21.03.2014 Elva Baltic P7 #RX018 MMG7.00
    //   * Field "Print Item In Order" added
    // 
    // 18.03.2014 Elva Baltic P8 #S0006 MMG7.00
    //   * Added field: Symptom Code
    // 
    // 11.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed DecimalPlaces property to 0:5 for:
    //     Transfered Quantity
    //     Reserved Qty. on Warehouse
    //   Changed ReservedOnWarehouse Control StyleExpr property
    //   Added code to:
    //     OnAfterGetRecord()
    //   Commented code on trigger (don't need autoreserve):
    //     Quantity - OnValidate()
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 2012.09.14 EDMS P8
    //   * Added fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 2012.04.02 EDMS P8
    //   * Added column Resources

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Service Line EDMS";
    SourceTableView = where("Document Type" = filter(Order));

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

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                        Labor: Record "Service Labor";
                        ExternalService: Record "External Service";
                        GLAccount: Record "G/L Account";
                        ServiceHeader: Record "Service Header EDMS";
                        StandardText: Record "Standard Text";
                        LookUpMgt: Codeunit LookUpManagement;
                        Resource: Record Resource;
                    begin
                        ServiceHeader.Get(Rec."Document Type", Rec."Document No.");

                        case Rec.Type of
                            Rec.Type::Comment:
                                begin
                                    StandardText.Reset;
                                    if LookUpMgt.LookUpStandardText(StandardText, Rec."No.") then
                                        Rec.Validate("No.", StandardText.Code);
                                end;

                            Rec.Type::"G/L Account":
                                begin
                                    GLAccount.Reset;
                                    if LookUpMgt.LookUpGLAccount(GLAccount, Rec."No.") then
                                        Rec.Validate("No.", GLAccount."No.");
                                end;

                            Rec.Type::Item:
                                begin
                                    Item.Reset;
                                    if LookUpMgt.LookUpItemREZ(Item, Rec."No.") then
                                        Rec.Validate("No.", Item."No.");
                                end;

                            Rec.Type::Labor:
                                begin
                                    Labor.Reset;
                                    Labor.SetCurrentkey("Make Code");
                                    Labor.SetFilter("Make Code", '%1|''''', Rec."Make Code");
                                    onbeforelookuplabor(Labor,rec);
                                    if LookUpMgt.LookUpLabor(Labor, Rec."No.") then
                                        Rec.Validate("No.", Labor."No.");
                                end;

                            Rec.Type::"External Service":
                                begin
                                    ExternalService.Reset;
                                    if LookUpMgt.LookUpExternalService(ExternalService, Rec."No.") then
                                        Rec.Validate("No.", ExternalService."No.");
                                end;
                            Rec.Type::Resource:
                                begin
                                    Resource.Reset;
                                    if LookUpMgt.LookUpResource(Resource, Rec."No.") then
                                        Rec.Validate("No.", Resource."No.");
                                end;
                        end;
                        CurrPage.Update;
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(HasReplacement; Rec."Has Replacement")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                field(ExternalServTrackingNo; Rec."External Serv. Tracking No.")
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
                        // LocationCodeOnAfterValidate;                                     // 30.04.2014 Elva Baltic P21
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
                        // ReserveOnAfterValidate;                         // 30.04.2014 Elva Baltic P21
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        //QuantityOnAfterValidate;                        // 11.03.2014 Elva Baltic P21
                        QuantityOnAfterValidate;
                        CurrPage.Update;
                    end;
                }
                field(ReservedQuantity; Rec."Reserved Quantity")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Visible = false;
                }
                field("Transfered Quantity"; Rec.CalcTransferedQuantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Transfered Quantity';
                    DecimalPlaces = 0 : 5;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowTransferedQuantity
                    end;
                }
                field(ReservedOnWarehouse; Rec.CalcOutboundTransferRes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reserved Qty. on Warehouse';
                    DecimalPlaces = 0 : 5;
                    StyleExpr = StyleTxt;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowOutboundTransferRes
                    end;
                }
                field(FullyReservedToInventory; Rec.FullyReservedToInventory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fully Reserved To Inventory';
                    Visible = false;
                }
                field(QtytoReturn; Rec."Qty. to Return")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(StandardTime; Rec."Standard Time")
                {
                    ApplicationArea = Basic;
                }
                field(FinishedQuantityHours; Rec."Finished Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RemainingQuantityHours; Rec."Remaining Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Control1101904000; Resources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        Commit;
                        Rec.RelatedResourcesList(Resources);
                        Resources := Rec.GetResourceTextFieldValue;
                        CurrPage.Update;
                    end;

                    trigger OnValidate()
                    begin
                        Rec.SetResourceTextFieldValue(Resources);
                        Resources := Rec.GetResourceTextFieldValue;
                    end;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        // UnitofMeasureCodeOnAfterValida;                                  // 30.04.2014 Elva Baltic P21
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
                field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitPrice; Rec."Unit Price")
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
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
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
                    Visible = false;
                }
                field(VehicleAxleCode; Rec."Vehicle Axle Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(TirePositionCode; Rec."Tire Position Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = true;
                    DrillDownPageID = "Vehicle Tire Positions";
                    Lookup = true;
                    LookupPageID = "Vehicle Tire Positions";
                    Visible = false;
                }
                field(TireCode; Rec."Tire Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlanNo; Rec."Plan No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlanStageRecurrence; Rec."Plan Stage Recurrence")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlanStageCode; Rec."Plan Stage Code")
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
                field(PurchasingCode; Rec."Purchasing Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Control1101901006; Rec."Special Order")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SymptomCode; Rec."Symptom Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlannedServiceDate; Rec."Planned Service Date")
                {
                    ApplicationArea = Basic;
                }
                field(AttachedtoLineNo; Rec."Attached to Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ResCostAmountFinished; Rec."Res. Cost Amount Finished")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(ResCostAmountRemaining; Rec."Res. Cost Amount Remaining")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(ResCostAmountTotal; Rec."Res. Cost Amount Total")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(TireDescription; Rec."Tire Description")
                {
                    ApplicationArea = Basic;
                }
                field(TransferFromLocationCode; Rec."Transfer From Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(QuoteNo; Rec."Quote No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who created the line.';
                }
            }

            group(Control25)
            {
                ShowCaption = false;
                group(Control23)
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
                group(Control24)
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
                action(Resources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';
                    Image = CalculateRemainingUsage;

                    trigger OnAction()
                    begin
                        Rec.RelatedResourcesList(Resources);
                    end;
                }
                action(ForceBackorder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Force Backorder';

                    trigger OnAction()
                    begin
                        Rec."Planned Service Date" := WorkDate;
                        Rec.Modify;
                        ServTransfMgt.CreateTransferOrderForce(Rec);
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
                action("<Action1101904001>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Register Lost Sale';
                    Image = Register;

                    trigger OnAction()
                    begin
                        Rec.RegLostSales
                    end;
                }
                separator(Action1101904004)
                {
                }
                action("<Action1101904002>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Move Lines';
                    Image = MoveUp;

                    trigger OnAction()
                    var
                        ServiceLine: Record "Service Line EDMS";
                    begin
                        CurrPage.SetSelectionFilter(ServiceLine);
                        Rec.MoveLines(ServiceLine);
                    end;
                }
                action("<Action1101904003>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Split Line';
                    Image = Splitlines;

                    trigger OnAction()
                    var
                        ServiceLine: Record "Service Line EDMS";
                    begin
                        CurrPage.SetSelectionFilter(ServiceLine);
                        Rec.SplitLine(ServiceLine);
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
                group(SpecialOrder)
                {
                    Caption = 'Speci&al Order';
                    Image = SpecialOrder;
                    action(OpenSpecialPurchaseOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase &Order';
                        Image = Document;

                        trigger OnAction()
                        begin
                            OpenSpecialPurchOrderForm;
                        end;
                    }
                }
                group(ExternalService)
                {
                    Caption = 'External Service';
                    Image = SpecialOrder;
                    action(CreatePurchaseOrder)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Purchase &Order';
                        Image = Document;
                        trigger OnAction()
                        var
                            DocumentManagement: Codeunit DocumentManagementDMS;
                        begin
                            DocumentManagement.CreatePurchaseOrderForExternalService(Rec);
                        end;
                    }
                }
            }
            action(ApplyReplacement)
            {
                ApplicationArea = Basic;
                Caption = 'Apply Replacement';
                Image = ItemSubstitution;

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "Item Substitution Sync";
                begin
                    //10.05.2016 EB.P7 #PAR_28 >>
                    ItemSubstSync.ReplaceServiceLineItemNo(Rec);
                    //10.05.2016 EB.P7 #PAR_28 <<
                    CurrPage.Update;
                end;
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
        //ShowShortcutDimCode(ShortcutDimCode); //29.10.2012 EDMS
        Resources := Rec.GetResourceTextFieldValue;

        StyleTxt := Rec.GetReservationColor;                                  // 11.03.2014 Elva Baltic P21

        Rec.ShowShortcutDimCode(ShortcutDimCode); // 31.03.2014 Elva Baltic P18 MMG7.00
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        Rec.CheckReservationCancelation;
        LostSalesMgt.OnServLineDelete(Rec);

        Rec.DeleteAssignedTransfLine;                                         // 28.03.2014 Elva Baltic P21

        DocumentTotals.CalculateServiceSubPageTotals(Rec, TotalServiceLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.SetResourceTextFieldValue(Resources);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := xRec.Type;
        Clear(ShortcutDimCode);

        if Rec."Document No." <> '' then begin
            ServiceHeader.Get(Rec."Document Type", Rec."Document No.");
            Rec."Make Code" := ServiceHeader."Make Code";
        end;
        Clear(Resources);
        Rec.SetResourceTextFieldValue(Resources);
    end;

    trigger OnOpenPage()
    begin
        SalesSetup.Get;
    end;



    var
        ServiceHeader: Record "Service Header EDMS";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        PurchOrder: Page "Purchase Order";
        ShortcutDimCode: array[8] of Code[20];
        Text001: label 'You can not use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        [InDataSet]
        ItemPanelVisible: Boolean;
        LostSalesMgt: Codeunit "Lost Sales Management";
        [InDataSet]
        Resources: Text;
        StyleTxt: Text[30];
        //TotalServiceHeader: Record "Service Header EDMS";
        VATAmount: Decimal;
        //DocumentTotals: Codeunit "Service Document Totals";
        ServTransfMgt: Codeunit "Service Transfer Mgt.";
        //        TotalServiceLine: Record "Service Line EDMS";
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        InvDiscAmountEditable: Boolean;
        ServCalcDiscEDMS: Codeunit "Service-Calc. Discount EDMS";
        AmountWithDiscountAllowed: Decimal;
        CurrPageIsEditable: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";

    Protected Var
        TotalServiceHeader: Record "Service Header EDMS";
        DocumentTotals: Codeunit "Service Document Totals";
        TotalServiceLine: Record "Service Line EDMS";

        Currency: Record Currency;

    procedure ApproveCalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Service-Disc. EDMS (Yes/No)", Rec);
    end;


    procedure CalcInvDisc()
    begin
        Codeunit.Run(Codeunit::"Service-Calc. Discount EDMS", Rec);
    end;


    procedure ExplodeBOM()
    begin
        if Rec."Prepmt. Amt. Inv." <> 0 then
            Error(Text001);
        Codeunit.Run(Codeunit::"Service-Explode BOM EDMS", Rec);
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
        PurchOrder: Page "Purchase Order";
    begin
        Rec.TestField(Rec."Special Order Purchase No.");
        PurchHeader.SetRange("No.", Rec."Special Order Purchase No.");
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


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowNonstockItems()
    begin
        Rec.ShowNonstock;
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
        //* DELTA SALESPRICE
        SalesPriceCalcMgt.GetDMSServLinePrice(ServiceHeader, Rec);
    end;


    procedure ShowLineDisc()
    begin
        ServiceHeader.Get(Rec."Document Type", Rec."Document No.");
        Clear(SalesPriceCalcMgt);
        //* DELTA SALESPRICE
        SalesPriceCalcMgt.GetDMSServLineLineDisc(ServiceHeader, Rec);
    end;


    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
    begin
        OrderPromisingLine.SetRange("Source Type", OrderPromisingLine."source type"::"Service Order EDMS");
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
        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord;
            Rec.AutoReserve;
            CurrPage.Update(false);
        end;
    end;


    procedure SetRecSelectionFilter(var ServLine: Record "Service Line EDMS")
    begin
        ServLine.Reset;
        //CurrPage.SETSELECTIONFILTER(ServLine); it function work differently than in Nav2009
        if Rec.FindFirst then
            repeat
                if Rec.Type = Rec.Type::Item then begin
                    ServLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
                    ServLine.Mark(true);
                end;
            until Rec.Next = 0;
        ServLine.MarkedOnly(true);
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

    [IntegrationEvent(false, false)]
    local procedure onbeforelookuplabor(var labor: Record "Service Labor";"ServiceLineEDMS" :  Record  "Service Line EDMS");
    begin
    end;

}

