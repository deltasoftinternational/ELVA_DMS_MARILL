Page 25006194 "Service Order Statistics EDMS"
{
    // 05.12.2012 EDMS P8
    //   * Fixed to have correct behavior in case of discount

    Caption = 'Service Order Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Service Header EDMS";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(TotalServiceLine1LineAmount; TotalServiceLine[1]."Line Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text002, false);
                    Editable = false;
                }
                field(InvDiscountAmount; TotalServiceLine[1]."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';

                    trigger OnValidate()
                    begin
                        ActiveTab := Activetab::General;
                        UpdateInvDiscAmount(1);
                    end;
                }
                field(TotalAmount11; TotalAmount1[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001, false);

                    trigger OnValidate()
                    begin
                        ActiveTab := Activetab::General;
                        UpdateTotalAmount(1);
                    end;
                }
                field(VATAmount; VATAmount[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText[1]);
                    Caption = 'VAT Amount';
                    Editable = false;
                }
                field(TotalAmount21; TotalAmount2[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001, true);
                    Editable = false;

                    trigger OnValidate()
                    begin
                        TotalAmount21OnAfterValidate;
                    end;
                }
                field(SalesLCY; TotalServiceLineLCY[1].Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales (LCY)';
                    Editable = false;
                }
                field(OriginalProfitLCY; ProfitLCY[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Profit (LCY)';
                    Editable = false;
                }
                field(AdjustedProfitLCY; AdjProfitLCY[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit (LCY)';
                    Editable = false;
                }
                field(OriginalProfit; ProfitPct[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1 : 1;
                    Editable = false;
                }
                field(AdjustedProfit; AdjProfitPct[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1 : 1;
                    Editable = false;
                }
                field(Quantity; TotalServiceLine[1].Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field(TotalCostLCY; TotalCostLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Cost (LCY)';
                    Editable = false;
                }
                field(AdjustedCostLCY; TotalAdjCostLCY[1])
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Cost (LCY)';
                    Editable = false;
                }
                field(NoofVATLines; TempVATAmountLine1.Count)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempVATAmountLine1, false);
                        UpdateHeaderInfo(1, TempVATAmountLine1);
                    end;
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                field(PrepmtTotalAmount; PrepmtTotalAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text006, false);

                    trigger OnValidate()
                    begin
                        ActiveTab := Activetab::Prepayment;
                        UpdatePrepmtAmount;
                    end;
                }
                field(PrepmtVATAmount; PrepmtVATAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(PrepmtVATAmountText);
                    Caption = 'Prepayment Amount Invoiced';
                    Editable = false;
                }
                field(PrepmtTotalAmount2; PrepmtTotalAmount2)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text006, true);
                    Editable = false;
                }
                field(TotalServiceLine1PrepmtAmtInv; TotalServiceLine[1]."Prepmt. Amt. Inv.")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text007, false);
                    Editable = false;
                }
                field(PrepmtInvPct; PrepmtInvPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoiced % of Prepayment Amt.';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Invoiced % of Prepayment Amt.';
                }
                field(TotalServiceLine1PrepmtAmtDeducted; TotalServiceLine[1]."Prepmt Amt Deducted")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text008, false);
                    Editable = false;
                }
                field(PrepmtDeductedPct; PrepmtDeductedPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Deducted % of Prepayment Amt. to Deduct';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Deducted % of Prepayment Amt. to Deduct';
                }
                field(TotalServiceLine1PrepmtAmttoDeduct; TotalServiceLine[1]."Prepmt Amt to Deduct")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text009, false);
                    Editable = false;
                }
                field(TempVATAmountLine4COUNT; TempVATAmountLine4.Count)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempVATAmountLine4, true);
                    end;
                }
            }
            group(Customer)
            {
                Caption = 'Customer';
                field(BalanceLCY; Cust."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Balance (LCY)';
                    Editable = false;
                }
                field(CreditLimitLCY; Cust."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Credit Limit (LCY)';
                    Editable = false;
                }
                field(CreditLimitLCYExpendedPct; CreditLimitLCYExpendedPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Expended % of Credit Limit (LCY)';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Expended % of Credit Limit (LCY)';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        ServiceLine: Record "Service Line EDMS";
        TempServiceLine: Record "Service Line EDMS" temporary;
        ServicePostPrepmt: Codeunit "Service-Post Prepayments";
    begin
        CurrPage.Caption(StrSubstNo(Text000, Rec."Document Type"));

        if PrevNo = Rec."No." then
            exit;
        PrevNo := Rec."No.";
        Rec.FilterGroup(2);
        Rec.SetRange("No.", PrevNo);
        Rec.FilterGroup(0);

        Clear(ServiceLine);
        Clear(TotalServiceLine);
        Clear(TotalServiceLineLCY);

        for i := 1 to 3 do begin
            TempServiceLine.DeleteAll;
            Clear(TempServiceLine);
            Clear(ServicePost);
            ServicePost.GetServiceLines(Rec, TempServiceLine, i - 1);
            Clear(ServicePost);
            case i of
                1:
                    ServiceLine.CalcVATAmountLines(0, Rec, TempServiceLine, TempVATAmountLine1);
                2:
                    ServiceLine.CalcVATAmountLines(0, Rec, TempServiceLine, TempVATAmountLine2);
                3:
                    ServiceLine.CalcVATAmountLines(0, Rec, TempServiceLine, TempVATAmountLine3);
                4:
                    ServiceLine.CalcVATAmountLines(0, Rec, TempServiceLine, TempVATAmountLine4);
            end;

            ServicePost.SumServiceLinesTemp(
              Rec, TempServiceLine, i - 1, TotalServiceLine[i], TotalServiceLineLCY[i],
              VATAmount[i], VATAmountText[i], ProfitLCY[i], ProfitPct[i], TotalAdjCostLCY[i]);

            if i = 3 then
                TotalAdjCostLCY[i] := TotalServiceLineLCY[i]."Unit Cost (LCY)";

            AdjProfitLCY[i] := TotalServiceLineLCY[i].Amount - TotalAdjCostLCY[i];
            if TotalServiceLineLCY[i].Amount <> 0 then
                AdjProfitPct[i] := ROUND(AdjProfitLCY[i] / TotalServiceLineLCY[i].Amount * 100, 0.1);

            if Rec."Prices Including VAT" then begin
                TotalAmount2[i] := TotalServiceLine[i].Amount;
                TotalAmount1[i] := TotalAmount2[i] + VATAmount[i];
                TotalServiceLine[i]."Line Amount" := TotalAmount1[i] + TotalServiceLine[i]."Inv. Discount Amount";
            end else begin
                TotalAmount1[i] := TotalServiceLine[i].Amount;
                TotalAmount2[i] := TotalServiceLine[i]."Amount Including VAT";
            end;
        end;
        TempServiceLine.DeleteAll;
        Clear(TempServiceLine);
        ServicePostPrepmt.GetServiceLines(Rec, 0, TempServiceLine);
        ServicePostPrepmt.SumPrepmt(
          Rec, TempServiceLine, TempVATAmountLine4, PrepmtTotalAmount, PrepmtVATAmount, PrepmtVATAmountText);
        PrepmtInvPct :=
          Pct(TotalServiceLine[1]."Prepmt. Amt. Inv.", PrepmtTotalAmount);
        PrepmtDeductedPct :=
          Pct(TotalServiceLine[1]."Prepmt Amt Deducted", TotalServiceLine[1]."Prepmt. Amt. Inv.");
        if Rec."Prices Including VAT" then begin
            PrepmtTotalAmount2 := PrepmtTotalAmount;
            PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
        end else
            PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;

        if Cust.Get(Rec."Bill-to Customer No.") then
            Cust.CalcFields("Balance (LCY)")
        else
            Clear(Cust);

        case true of
            Cust."Credit Limit (LCY)" = 0:
                CreditLimitLCYExpendedPct := 0;
            Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0:
                CreditLimitLCYExpendedPct := 0;
            Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1:
                CreditLimitLCYExpendedPct := 10000;
            else
                CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000, 1);
        end;

        TempVATAmountLine1.ModifyAll(Modified, false);
        TempVATAmountLine2.ModifyAll(Modified, false);
        TempVATAmountLine3.ModifyAll(Modified, false);
        TempVATAmountLine4.ModifyAll(Modified, false);

        PrevTab := -1;

        //05.12.2012 EDMS P8 >>
        UpdateTotals;
        GetVATSpecification2(ActiveTab);
        //05.12.2012 EDMS P8 <<

        CalcCostAndProfitLCY;
    end;

    trigger OnOpenPage()
    begin
        ServiceSetup.Get;
        AllowInvDisc := not (SalesSetup."Calc. Inv. Discount" and CustInvDiscRecExists(Rec."Invoice Disc. Code"));
        AllowVATDifference :=
          SalesSetup."Allow VAT Difference" and
          not (Rec."Document Type" in [Rec."document type"::Quote]);
        VATLinesFormIsEditable := AllowVATDifference or AllowInvDisc;
        CurrPage.Editable := VATLinesFormIsEditable;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        GetVATSpecification(PrevTab);
        if TempVATAmountLine1.GetAnyLineModified or TempVATAmountLine2.GetAnyLineModified then
            UpdateVATOnServiceLines;
        exit(true);
    end;

    var
        Text000: label 'Service %1 Statistics';
        Text001: label 'Total';
        Text002: label 'Amount';
        Text003: label '%1 must not be 0.';
        Text004: label '%1 must not be greater than %2.';
        Text005: label 'You cannot change the invoice discount because there is a %1 record for %2 %3.';
        TotalServiceLine: array[3] of Record "Service Line EDMS";
        TotalServiceLineLCY: array[3] of Record "Service Line EDMS";
        Cust: Record Customer;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        TempVATAmountLine2: Record "VAT Amount Line" temporary;
        TempVATAmountLine3: Record "VAT Amount Line" temporary;
        TempVATAmountLine4: Record "VAT Amount Line" temporary;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        SalesSetup: Record "Sales & Receivables Setup";
        ServicePost: Codeunit "Service-Post EDMS";

        PrepmtTotalAmount: Decimal;
        PrepmtVATAmount: Decimal;
        PrepmtTotalAmount2: Decimal;
        VATAmountText: array[3] of Text[30];
        PrepmtVATAmountText: Text[30];
        ProfitLCY: array[3] of Decimal;
        ProfitPct: array[3] of Decimal;
        AdjProfitLCY: array[3] of Decimal;
        AdjProfitPct: array[3] of Decimal;
        TotalAdjCostLCY: array[3] of Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        PrepmtInvPct: Decimal;
        PrepmtDeductedPct: Decimal;
        i: Integer;
        PrevNo: Code[20];
        ActiveTab: Option General,Invoicing,Shipping,Prepayment;
        PrevTab: Option General,Invoicing,Shipping,Prepayment;
        VATLinesFormIsEditable: Boolean;
        AllowInvDisc: Boolean;
        AllowVATDifference: Boolean;
        Text006: label 'Prepmt. Amount';
        Text007: label 'Prepmt. Amt. Invoiced';
        Text008: label 'Prepmt. Amt. Deducted';
        Text009: label 'Prepmt. Amt. to Deduct';
        TotalCostLCY: Decimal;
        VATLinesForm: Page "VAT Amount Lines";


    protected Var
        TotalAmount1: array[3] of Decimal;
        TotalAmount2: array[3] of Decimal;
        VATAmount: array[3] of Decimal;

    local procedure UpdateHeaderInfo(IndexNo: Integer; var VATAmountLine: Record "VAT Amount Line")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        UseDate: Date;
    begin
        TotalServiceLine[IndexNo]."Inv. Discount Amount" := VATAmountLine.GetTotalInvDiscAmount;
        TotalAmount1[IndexNo] :=
          TotalServiceLine[IndexNo]."Line Amount" - TotalServiceLine[IndexNo]."Inv. Discount Amount";
        VATAmount[IndexNo] := VATAmountLine.GetTotalVATAmount;
        if Rec."Prices Including VAT" then begin
            TotalAmount1[IndexNo] := VATAmountLine.GetTotalAmountInclVAT;
            TotalAmount2[IndexNo] := TotalAmount1[IndexNo] - VATAmount[IndexNo];
            TotalServiceLine[IndexNo]."Line Amount" :=
              TotalAmount1[IndexNo] + TotalServiceLine[IndexNo]."Inv. Discount Amount";
        end else
            TotalAmount2[IndexNo] := TotalAmount1[IndexNo] + VATAmount[IndexNo];

        if Rec."Prices Including VAT" then
            TotalServiceLineLCY[IndexNo].Amount := TotalAmount2[IndexNo]
        else
            TotalServiceLineLCY[IndexNo].Amount := TotalAmount1[IndexNo];
        if Rec."Currency Code" <> '' then
            if (Rec."Document Type" in [Rec."document type"::Quote]) and
               (Rec."Posting Date" = 0D)
            then
                UseDate := WorkDate
            else
                UseDate := Rec."Posting Date";

        TotalServiceLineLCY[IndexNo].Amount :=
          CurrExchRate.ExchangeAmtFCYToLCY(
            UseDate, Rec."Currency Code", TotalServiceLineLCY[IndexNo].Amount, Rec."Currency Factor");

        ProfitLCY[IndexNo] := TotalServiceLineLCY[IndexNo].Amount - TotalServiceLineLCY[IndexNo]."Unit Cost (LCY)";
        if TotalServiceLineLCY[IndexNo].Amount = 0 then
            ProfitPct[IndexNo] := 0
        else
            ProfitPct[IndexNo] := ROUND(100 * ProfitLCY[IndexNo] / TotalServiceLineLCY[IndexNo].Amount, 0.01);

        AdjProfitLCY[IndexNo] := TotalServiceLineLCY[IndexNo].Amount - TotalAdjCostLCY[IndexNo];
        if TotalServiceLineLCY[IndexNo].Amount = 0 then
            AdjProfitPct[IndexNo] := 0
        else
            AdjProfitPct[IndexNo] := ROUND(100 * AdjProfitLCY[IndexNo] / TotalServiceLineLCY[IndexNo].Amount, 0.01);
    end;

    local procedure GetVATSpecification(QtyType: Option General,Invoicing,Shipping)
    begin
        case QtyType of
            Qtytype::General:
                begin
                    VATLinesForm.GetTempVATAmountLine(TempVATAmountLine1);
                    UpdateHeaderInfo(1, TempVATAmountLine1);
                end;
            Qtytype::Invoicing:
                begin
                    VATLinesForm.GetTempVATAmountLine(TempVATAmountLine2);
                    UpdateHeaderInfo(2, TempVATAmountLine2);
                end;
            Qtytype::Shipping:
                VATLinesForm.GetTempVATAmountLine(TempVATAmountLine3);
        end;
    end;

    local procedure UpdateTotalAmount(IndexNo: Integer)
    var
        SaveTotalAmount: Decimal;
    begin
        CheckAllowInvDisc;
        if Rec."Prices Including VAT" then begin
            SaveTotalAmount := TotalAmount1[IndexNo];
            UpdateInvDiscAmount(IndexNo);
            TotalAmount1[IndexNo] := SaveTotalAmount;
        end;

        TotalServiceLine[IndexNo]."Inv. Discount Amount" := TotalServiceLine[IndexNo]."Line Amount" - TotalAmount1[IndexNo];
        UpdateInvDiscAmount(IndexNo);
    end;

    local procedure UpdateInvDiscAmount(ModifiedIndexNo: Integer)
    var
        PartialInvoicing: Boolean;
        MaxIndexNo: Integer;
        IndexNo: array[2] of Integer;
        i: Integer;
        InvDiscBaseAmount: Decimal;
    begin
        CheckAllowInvDisc;
        if not (ModifiedIndexNo in [1, 2]) then
            exit;

        if ModifiedIndexNo = 1 then
            InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(false, Rec."Currency Code")
        else
            InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(false, Rec."Currency Code");

        if InvDiscBaseAmount = 0 then
            Error(Text003, TempVATAmountLine2.FieldCaption("Inv. Disc. Base Amount"));

        if TotalServiceLine[ModifiedIndexNo]."Inv. Discount Amount" / InvDiscBaseAmount > 1 then
            Error(
              Text004,
              TotalServiceLine[ModifiedIndexNo].FieldCaption("Inv. Discount Amount"),
              TempVATAmountLine2.FieldCaption("Inv. Disc. Base Amount"));

        PartialInvoicing := (TotalServiceLine[1]."Line Amount" <> TotalServiceLine[2]."Line Amount");

        IndexNo[1] := ModifiedIndexNo;
        IndexNo[2] := 3 - ModifiedIndexNo;
        if (ModifiedIndexNo = 2) and PartialInvoicing then
            MaxIndexNo := 1
        else
            MaxIndexNo := 2;

        if not PartialInvoicing then
            if ModifiedIndexNo = 1 then
                TotalServiceLine[2]."Inv. Discount Amount" := TotalServiceLine[1]."Inv. Discount Amount"
            else
                TotalServiceLine[1]."Inv. Discount Amount" := TotalServiceLine[2]."Inv. Discount Amount";

        for i := 1 to MaxIndexNo do begin
            if (i = 1) or not PartialInvoicing then
                if IndexNo[i] = 1 then begin
                    TempVATAmountLine1.SetInvoiceDiscountAmount(
                      TotalServiceLine[IndexNo[i]]."Inv. Discount Amount", Rec."Currency Code", Rec."Prices Including VAT", Rec."VAT Base Discount %");
                end else begin
                    TempVATAmountLine2.SetInvoiceDiscountAmount(
                      TotalServiceLine[IndexNo[i]]."Inv. Discount Amount", Rec."Currency Code", Rec."Prices Including VAT", Rec."VAT Base Discount %");
                end;

            if (i = 2) and PartialInvoicing then
                if IndexNo[i] = 1 then begin
                    InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(false, Rec."Currency Code");
                    if InvDiscBaseAmount = 0 then
                        TempVATAmountLine1.SetInvoiceDiscountPercent(
                          0, TotalServiceLine[IndexNo[i]]."Currency Code", Rec."Prices Including VAT", false, Rec."VAT Base Discount %")
                    else
                        TempVATAmountLine1.SetInvoiceDiscountPercent(
                          100 * TempVATAmountLine2.GetTotalInvDiscAmount / InvDiscBaseAmount,
                          TotalServiceLine[IndexNo[i]]."Currency Code", Rec."Prices Including VAT", false, Rec."VAT Base Discount %");
                end else begin
                    InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(false, TotalServiceLine[IndexNo[i]]."Currency Code");
                    if InvDiscBaseAmount = 0 then
                        TempVATAmountLine2.SetInvoiceDiscountPercent(
                          0, TotalServiceLine[IndexNo[i]]."Currency Code", Rec."Prices Including VAT", false, Rec."VAT Base Discount %")
                    else
                        TempVATAmountLine2.SetInvoiceDiscountPercent(
                          100 * TempVATAmountLine1.GetTotalInvDiscAmount / InvDiscBaseAmount,
                          TotalServiceLine[IndexNo[i]]."Currency Code", Rec."Prices Including VAT", false, Rec."VAT Base Discount %");
                end;
        end;

        UpdateHeaderInfo(1, TempVATAmountLine1);
        UpdateHeaderInfo(2, TempVATAmountLine2);

        if ModifiedIndexNo = 1 then
            VATLinesForm.SetTempVATAmountLine(TempVATAmountLine1)
        else
            VATLinesForm.SetTempVATAmountLine(TempVATAmountLine2);

        Rec."Invoice Discount Calculation" := Rec."invoice discount calculation"::Amount;
        Rec."Invoice Discount Value" := TotalServiceLine[1]."Inv. Discount Amount";
        Rec.Modify;

        UpdateVATOnServiceLines;
    end;

    local procedure UpdatePrepmtAmount()
    var
        TempServLine: Record "Service Line EDMS" temporary;
        ServicePostPrepmt: Codeunit "Service-Post Prepayments";
    begin
        ServicePostPrepmt.UpdatePrepmtAmountOnServLines(Rec, PrepmtTotalAmount);
        ServicePostPrepmt.GetServiceLines(Rec, 0, TempServLine);
        ServicePostPrepmt.SumPrepmt(
          Rec, TempServLine, TempVATAmountLine4, PrepmtTotalAmount, PrepmtVATAmount, PrepmtVATAmountText);
        PrepmtInvPct :=
          Pct(TotalServiceLine[1]."Prepmt. Amt. Inv.", PrepmtTotalAmount);
        PrepmtDeductedPct :=
          Pct(TotalServiceLine[1]."Prepmt Amt Deducted", TotalServiceLine[1]."Prepmt. Amt. Inv.");
        if Rec."Prices Including VAT" then begin
            PrepmtTotalAmount2 := PrepmtTotalAmount;
            PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
        end else
            PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;
        Rec.Modify;
    end;

    local procedure GetCaptionClass(FieldCaption: Text[100]; ReverseCaption: Boolean): Text[80]
    begin
        if Rec."Prices Including VAT" xor ReverseCaption then
            exit('2,1,' + FieldCaption);
        exit('2,0,' + FieldCaption);
    end;

    local procedure UpdateVATOnServiceLines()
    var
        ServiceLine: Record "Service Line EDMS";
    begin
        GetVATSpecification(ActiveTab);
        if TempVATAmountLine1.GetAnyLineModified then
            ServiceLine.UpdateVATOnLines(0, Rec, ServiceLine, TempVATAmountLine1);
        if TempVATAmountLine2.GetAnyLineModified then
            ServiceLine.UpdateVATOnLines(1, Rec, ServiceLine, TempVATAmountLine2);
        PrevNo := '';
    end;

    local procedure CustInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        CustInvDisc.SetRange(Code, InvDiscCode);
        exit(CustInvDisc.FindSet);
    end;

    local procedure CheckAllowInvDisc()
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        if not AllowInvDisc then
            Error(
              Text005,
              CustInvDisc.TableCaption, Rec.FieldCaption("Invoice Disc. Code"), Rec."Invoice Disc. Code");
    end;

    local procedure Pct(Numerator: Decimal; Denominator: Decimal): Decimal
    begin
        if Denominator = 0 then
            exit(0);
        exit(ROUND(Numerator / Denominator * 10000, 1));
    end;


    procedure VATLinesDrillDown(var VATLinesToDrillDown: Record "VAT Amount Line"; ThisTabAllowsVATEditing: Boolean)
    begin
        Clear(VATLinesForm);
        VATLinesForm.SetTempVATAmountLine(VATLinesToDrillDown);
        VATLinesForm.InitGlobals(
          Rec."Currency Code", AllowVATDifference, AllowVATDifference and ThisTabAllowsVATEditing,
          Rec."Prices Including VAT", AllowInvDisc, Rec."VAT Base Discount %");
        VATLinesForm.RunModal;
        VATLinesForm.GetTempVATAmountLine(VATLinesToDrillDown);
    end;

    local procedure TotalAmount21OnAfterValidate()
    begin
        if Rec."Prices Including VAT" then
            TotalServiceLine[1]."Inv. Discount Amount" := TotalServiceLine[1]."Line Amount" - TotalServiceLine[1]."Amount Including VAT"
        else
            TotalServiceLine[1]."Inv. Discount Amount" := TotalServiceLine[1]."Line Amount" - TotalServiceLine[1].Amount;
        UpdateInvDiscAmount(1);
    end;

    local procedure GetVATSpecification2(QtyType: Option General,Invoicing,Shipping)
    begin
        case QtyType of
            Qtytype::General:
                begin
                    UpdateHeaderInfo(1, TempVATAmountLine1);
                end;
            Qtytype::Invoicing:
                begin
                    UpdateHeaderInfo(2, TempVATAmountLine2);
                end;
        end;
    end;


    procedure UpdateTotals()
    begin
        TotalAmount1[1] := TotalServiceLine[1]."Line Amount" - TotalServiceLine[1]."Inv. Discount Amount";
    end;

    local procedure CalcCostAndProfitLCY()
    var
        ServAllocationApplication: Record "Serv. Labor Alloc. Application";
    begin
        ServiceSetup.Get;
        if (ServiceSetup."Service Cost Handling" = ServiceSetup."service cost handling"::"Post from Resource Cost")
          or
          (ServiceSetup."Service Cost Handling" = ServiceSetup."service cost handling"::"Show from Resource Cost")
          then begin
            ServAllocationApplication.Reset;
            ServAllocationApplication.SetRange("Document Type", Rec."Document Type");
            ServAllocationApplication.SetRange("Document No.", Rec."No.");
            ServAllocationApplication.CalcSums("Cost Amount");
            TotalCostLCY := ServAllocationApplication."Cost Amount";
        end else
            TotalCostLCY := TotalServiceLineLCY[1]."Unit Cost (LCY)";

        ProfitLCY[1] := TotalServiceLineLCY[1].Amount - TotalCostLCY;
        ProfitPct[1] := 0;
        if TotalServiceLineLCY[1].Amount <> 0 then
            ProfitPct[1] := ROUND(ProfitLCY[1] / TotalServiceLineLCY[1].Amount * 100, 0.01);
    end;
}

