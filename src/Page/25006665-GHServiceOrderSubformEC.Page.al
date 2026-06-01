Page 25006665 "GH Service Order Subform EC"
{

    Caption = 'Lines';
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Service Line EDMS";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

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
                }
                field(ReservedOnWarehouse; Rec.CalcOutboundTransferRes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reserved Qty. on Warehouse';
                    DecimalPlaces = 0 : 5;
                    StyleExpr = StyleTxt;
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

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    //Visible = false;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    //Editable = false;
                    //Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    //Editable = false;
                    //Visible = false;
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
        /*
        SetResourceTextFieldValue(Resources);
        */
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*
        Type := xRec.Type;
        Clear(ShortcutDimCode);

        if "Document No." <> '' then begin
            ServiceHeader.Get("Document Type", "Document No.");
            "Make Code" := ServiceHeader."Make Code";
        end;
        Clear(Resources);
        SetResourceTextFieldValue(Resources);
        */
    end;

    trigger OnOpenPage()
    begin
        SalesSetup.Get;
    end;

    var
        ServiceHeader: Record "Service Header EDMS";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
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
        DocumentTotals: Codeunit "Service Document Totals";
        ServTransfMgt: Codeunit "Service Transfer Mgt.";
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


}

