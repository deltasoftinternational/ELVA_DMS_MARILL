Page 25006686 "Vehicle Health Check Subform"
{
    // 27/03/2018 GH P30
    //   Added fields:
    //     25006972 "VHC Service Order No."
    //     25006973 "Reminder Date"
    // 
    // 22/03/2018 GH P30
    //   Added fields:
    //     25006970 "Include in Price Calculation"
    //     25006971 "Customer Authorised"
    // 
    //   Modified triggers:
    //     OnAfterGetCurrentRecord
    //     OnValidate "No.", Type, Quantity, "Unit of Measure Code", "Unit Price", "Line Discount %", "Line Discount Amount", "Line Amount"
    //   Added function:
    //     RedistributeTotalsOnAfterValidate
    // 
    // 04/12/2017 EB.P30 GP1
    //   Modified trigger UnitPriceReverseVAT.OnAssistEdit
    //   Added field:
    //     UnitPriceReverseVAT
    //   Added functions:
    //     CalcUnitPriceReversVAT
    //     GetCaptionReversVAT
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
    SourceTableView = where("Document Type" = filter("Order"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,,Item,Labor,External Service';

                    trigger OnValidate()
                    begin
                        if Rec.Type = Rec.Type::Item then
                            TypeOnAfterValidate;

                        if xRec."No." <> '' then
                            RedistributeTotalsOnAfterValidate;                             // 22/03/2018 GH P30
                    end;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Width = 20;

                    trigger OnValidate()
                    begin
                        if xRec."No." <> '' then
                            RedistributeTotalsOnAfterValidate;                            // 22/03/2018 GH P30
                    end;
                }
                field(ExternalServTrackingNo; Rec."External Serv. Tracking No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SmartCode; Rec."Smart Code")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = None;
                    Style = None;
                    StyleExpr = true;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        // LocationCodeOnAfterValidate;                                     // 30.04.2014 Elva Baltic P21
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        // QuantityOnAfterValidate;                        // 11.03.2014 Elva Baltic P21

                        RedistributeTotalsOnAfterValidate;                                  // 22/03/2018 GH P30
                    end;
                }
                field(StandardTime; Rec."Standard Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        // UnitofMeasureCodeOnAfterValida;                                  // 30.04.2014 Elva Baltic P21

                        RedistributeTotalsOnAfterValidate;                                  // 22/03/2018 GH P30
                    end;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Visible = false;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;                                   // 22/03/2018 GH P30
                    end;
                }
                field(UnitPriceReverseVAT; CalcUnitPriceReversVAT)
                {
                    ApplicationArea = Basic;
                    CaptionClass = GetCaptionReversVAT;
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        // 04/12/2017 EB.P30 GP1 >>
                        //PriceCalculatorPage.SetParam(Rec);
                        //IF (PriceCalculatorPage.RUNMODAL = ACTION::OK) THEN
                        //  VALIDATE("Unit Price",PriceCalculatorPage.GetUnitPrice);
                        //CLEAR(PriceCalculatorPage);
                        // 04/12/2017 EB.P30 GP1 <<
                    end;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;                                          // 22/03/2018 GH P30
                    end;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;                                          // 22/03/2018 GH P30
                    end;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;                                          // 22/03/2018 GH P30
                    end;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(IncludeinPriceCalculation; Rec."Include in Price Calculation")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(CustomerAuthorised; Rec."Customer Authorised")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(VHCServiceOrderNo; Rec."VHC Service Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(ReminderDate; Rec."Reminder Date")
                {
                    ApplicationArea = Basic;
                }
                field(InventoryComment; Rec."Inventory Comment")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control19)
            {
                grid(Control30)
                {
                    group(Total)
                    {
                        Caption = 'Total';
                        field("Total Amount Excl. VAT"; TotalServiceHeader.Amount)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Amount Excl. VAT';
                            DrillDown = false;
                            Editable = false;
                        }
                        field("Total VAT Amount"; VATAmount)
                        {
                            ApplicationArea = Basic;
                            Caption = 'VAT';
                            Editable = false;
                        }
                        field("Total Amount Incl. VAT"; TotalServiceHeader."Amount Including VAT")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Amount Incl. VAT';
                            DrillDown = false;
                            Editable = false;
                            Style = Strong;
                            StyleExpr = true;
                        }
                    }
                    group(PriceCalculation)
                    {
                        Caption = 'Price Calculation';
                        field(PriceCalcAmount; PriceCalcAmount)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                        }
                        field(PriceCalcVATAmount; PriceCalcVATAmount)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                        }
                        field(PriceCalcAmountInclVAT; PriceCalcAmountInclVAT)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                            Style = Strong;
                            StyleExpr = true;
                        }
                    }
                    group(Control31)
                    {
                        Caption = 'Customer Authorised';
                        field(CustAuthorisedAmount; CustAuthorisedAmount)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                        }
                        field(CustAuthorisedVATAmount; CustAuthorisedVATAmount)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                        }
                        field(CustAuthorisedAmountInclVAT; CustAuthorisedAmountInclVAT)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                            Style = Strong;
                            StyleExpr = true;
                        }
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
                action(LineDetails)
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Details';
                    Image = ExpandDepositLine;
                    Promoted = false;
                    Visible = false;
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
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
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
                action("<Action1101904001>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Register Lost Sale';
                    Image = Register;
                    Visible = false;

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
                    Visible = false;

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
                    Visible = false;

                    trigger OnAction()
                    var
                        ServiceLine: Record "Service Line EDMS";
                    begin
                        CurrPage.SetSelectionFilter(ServiceLine);
                        Rec.SplitLine(ServiceLine);
                    end;
                }
                action(PriceCalculator)
                {
                    ApplicationArea = Basic;
                    Caption = 'Price Calculator';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // 04/12/2017 EB.P30 GP1 >>
                        //PriceCalculatorPage.SetParam(Rec);
                        //IF (PriceCalculatorPage.RUNMODAL = ACTION::OK) THEN
                        //  VALIDATE("Unit Price",PriceCalculatorPage.GetUnitPrice);
                        //CLEAR(PriceCalculatorPage);
                        // 04/12/2017 EB.P30 GP1 <<
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GHDocumentTotals.CalculateServiceHeaderTotals(TotalServiceHeader, VATAmount, Rec);
        GHDocumentTotals.CalculateServiceHeaderTotalsVHC(PriceCalcAmount, PriceCalcVATAmount, PriceCalcAmountInclVAT, CustAuthorisedAmount, CustAuthorisedVATAmount, CustAuthorisedAmountInclVAT, Rec); // 22/03/2018 GH P30
    end;

    trigger OnAfterGetRecord()
    begin
        //ShowShortcutDimCode(ShortcutDimCode); //29.10.2012 EDMS
        Resources := Rec.GetResourceTextFieldValue;

        StyleTxt := Rec.GetReservationColor;                                  // 11.03.2014 Elva Baltic P21

        Rec.ShowShortcutDimCode(ShortcutDimCode); // 31.03.2014 Elva Baltic P18 MMG7.00

        GHDocumentTotals.CalculateServiceHeaderTotals(TotalServiceHeader, VATAmount, Rec);
        GHDocumentTotals.CalculateServiceHeaderTotalsVHC(PriceCalcAmount, PriceCalcVATAmount, PriceCalcAmountInclVAT, CustAuthorisedAmount, CustAuthorisedVATAmount, CustAuthorisedAmountInclVAT, Rec); // 22/03/2018 GH P30
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        Rec.CheckReservationCancelation;
        LostSalesMgt.OnServLineDelete(Rec);

        Rec.DeleteAssignedTransfLine;                                         // 28.03.2014 Elva Baltic P21
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
        TotalServiceHeader: Record "Service Header EDMS";
        VATAmount: Decimal;
        GHDocumentTotals: Codeunit "GH Document Totals";
        Text002: label 'Unit Price (Calc.)';
        TotalServiceHeaderVHC: Record "Service Header EDMS";
        PriceCalcAmount: Decimal;
        PriceCalcVATAmount: Decimal;
        PriceCalcAmountInclVAT: Decimal;
        CustAuthorisedAmount: Decimal;
        CustAuthorisedVATAmount: Decimal;
        CustAuthorisedAmountInclVAT: Decimal;
        EmptyText: Text;


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
        Rec.TestField("Special Order Purchase No.");
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
        // DELTA SALESPRICE 
        SalesPriceCalcMgt.GetDMSServLinePrice(ServiceHeader, Rec);
    end;


    procedure ShowLineDisc()
    begin
        ServiceHeader.Get(Rec."Document Type", Rec."Document No.");
        Clear(SalesPriceCalcMgt);
        // DELTA SALESPRICE 
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

    local procedure CalcUnitPriceReversVAT(): Decimal
    var
        ServiceHeaderForVAT: Record "Service Header EDMS";
    begin
        ServiceHeaderForVAT.Reset;
        if ServiceHeaderForVAT.Get(Rec."Document Type", Rec."Document No.") then begin
            if ServiceHeaderForVAT."Prices Including VAT" then
                exit(ROUND(Rec."Unit Price" / ((100 + Rec."VAT %") / 100), 0.0001))
            else
                exit(ROUND(Rec."Unit Price" * ((100 + Rec."VAT %") / 100), 0.0001));
        end;
    end;

    local procedure GetCaptionReversVAT(): Text
    var
        ServiceHeaderForVATCaption: Record "Service Header EDMS";
        ServPricesIncVatReverse: Integer;
    begin
        if not ServiceHeaderForVATCaption.Get(Rec."Document Type", Rec."Document No.") then begin
            ServiceHeaderForVATCaption."No." := '';
            ServiceHeaderForVATCaption.Init;
        end;
        if ServiceHeaderForVATCaption."Prices Including VAT" then
            ServPricesIncVatReverse := 0
        else
            ServPricesIncVatReverse := 1;
        Clear(ServiceHeaderForVATCaption);
        exit('2,' + Format(ServPricesIncVatReverse) + ',' + Text002);
    end;

    local procedure ProcessSpecialOrderLines()
    begin
        ProcessSpecialOrderLines
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SaveRecord;

        Clear(GHDocumentTotals);
        GHDocumentTotals.CalculateServiceHeaderTotals(TotalServiceHeader, VATAmount, Rec);
        GHDocumentTotals.CalculateServiceHeaderTotalsVHC(PriceCalcAmount, PriceCalcVATAmount, PriceCalcAmountInclVAT, CustAuthorisedAmount, CustAuthorisedVATAmount, CustAuthorisedAmountInclVAT, Rec); // 22/03/2018 GH P30

        CurrPage.Update;
    end;
}

