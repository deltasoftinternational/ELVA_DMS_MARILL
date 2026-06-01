Page 25006239 "Posted Serv. Order Statistics"
{
    Caption = 'Posted Service Order Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SourceTable = "Posted Serv. Order Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Amount; CustAmount + InvDiscAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Amount';
                }
                field(InvDiscAmount; InvDiscAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                }
                field(CustAmount; CustAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total';
                }
                field(VATAmount; VATAmount)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText);
                    Caption = 'VAT Amount';
                }
                field(AmountInclVAT; AmountInclVAT)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec."Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total Incl. VAT';
                }
                field(AmountLCY; AmountLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales (LCY)';
                }
                field(ProfitLCY; ProfitLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Profit (LCY)';
                }
                field(AdjProfitLCY; AdjProfitLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit (LCY)';
                }
                field(ProfitPct; ProfitPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1 : 1;
                }
                field(AdjProfitPct; AdjProfitPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1 : 1;
                }
                field(LineQty; LineQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 5;
                }
                field(CostLCY; CostLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Original Cost (LCY)';
                }
                field(TotalAdjCostLCY; TotalAdjCostLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Adjusted Cost (LCY)';
                }
                field(CostAdjmtAmountLCY; TotalAdjCostLCY - CostLCY)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Cost Adjmt. Amount (LCY)';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupAdjmtValueEntries;
                    end;
                }
            }
            part(Subform; "VAT Specification Subform")
            {
                ApplicationArea = All;
                Editable = false;
            }
            group(Customer)
            {
                Caption = 'Customer';
                field(BalanceLCY; Cust."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Balance (LCY)';
                }
                field(CreditLimitLCY; Cust."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Credit Limit (LCY)';
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
        CostCalcMgt: Codeunit "Cost Calculation Management";
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        ClearAll;

        if Rec."Currency Code" = '' then
            currency.InitRoundingPrecision
        else
            currency.Get(Rec."Currency Code");

        ServOrderLine.SetRange("Document No.", Rec."No.");
        if ServOrderLine.FindSet then
            repeat
                CustAmount := CustAmount + ServOrderLine.Amount;
                AmountInclVAT := AmountInclVAT + ServOrderLine."Amount Including VAT";
                if Rec."Prices Including VAT" then
                    InvDiscAmount := InvDiscAmount + ServOrderLine."Inv. Discount Amount" / (1 + ServOrderLine."VAT %" / 100)
                else
                    InvDiscAmount := InvDiscAmount + ServOrderLine."Inv. Discount Amount";
                CostLCY := CostLCY + (ServOrderLine.Quantity * ServOrderLine."Unit Cost (LCY)");
                LineQty := LineQty + ServOrderLine.Quantity;
                if ServOrderLine."VAT %" <> VATPercentage then
                    if VATPercentage = 0 then
                        VATPercentage := ServOrderLine."VAT %"
                    else
                        VATPercentage := -1;
                TotalAdjCostLCY := TotalAdjCostLCY + ServOrderLine."Unit Cost (LCY)";
            until ServOrderLine.Next = 0;
        VATAmount := AmountInclVAT - CustAmount;
        InvDiscAmount := ROUND(InvDiscAmount, currency."Amount Rounding Precision");

        if VATPercentage <= 0 then
            VATAmountText := Text000
        else
            VATAmountText := StrSubstNo(Text001, VATPercentage);

        if Rec."Currency Code" = '' then
            AmountLCY := CustAmount
        else
            AmountLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                WorkDate, Rec."Currency Code", CustAmount, Rec."Currency Factor");

        CustLedgEntry.SetCurrentkey("Document No.");
        CustLedgEntry.SetRange("Document No.", Rec."No.");
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."document type"::Invoice);
        CustLedgEntry.SetRange("Customer No.", Rec."Bill-to Customer No.");
        if CustLedgEntry.FindFirst then
            AmountLCY := CustLedgEntry."Sales (LCY)";

        ProfitLCY := AmountLCY - CostLCY;
        if AmountLCY <> 0 then
            ProfitPct := ROUND(100 * ProfitLCY / AmountLCY, 0.1);

        AdjProfitLCY := AmountLCY - TotalAdjCostLCY;
        if AmountLCY <> 0 then
            AdjProfitPct := ROUND(100 * AdjProfitLCY / AmountLCY, 0.1);

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

        ServOrderLine.CalcVATAmountLines(Rec, TempVATAmountLine);
        CurrPage.Subform.Page.SetTempVATAmountLine(TempVATAmountLine);
        CurrPage.Subform.Page.InitGlobals(Rec."Currency Code", false, false, false, false, 0);
    end;

    var
        Text000: label 'VAT Amount';
        Text001: label '%1% VAT';
        CurrExchRate: Record "Currency Exchange Rate";
        ServOrderLine: Record "Posted Serv. Order Line";
        Cust: Record Customer;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        currency: Record Currency;
        TotalAdjCostLCY: Decimal;
        CustAmount: Decimal;
        AmountInclVAT: Decimal;
        InvDiscAmount: Decimal;
        VATAmount: Decimal;
        CostLCY: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        LineQty: Decimal;
        AmountLCY: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        VATPercentage: Decimal;
        VATAmountText: Text[30];
}

