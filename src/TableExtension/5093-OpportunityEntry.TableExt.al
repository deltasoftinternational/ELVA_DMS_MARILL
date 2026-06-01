tableextension 25006007 "Opportunity Entry" extends "Opportunity Entry" //5093
{
    // 20.11.2014 EB.P8 MERGE
    //   Added field 25006009
    // 05-09-2007 EDMS P3
    //  * Added 2 fields for foreign currency (ACY)

    fields
    {
        field(25006000; "Estimated Value"; Decimal)
        {
            Caption = 'Estimated Value';

            trigger OnValidate()
            begin
                TestField("Currency Factor");
                if "Currency Code" <> '' then
                    Currency.Get("Currency Code");
                "Estimated Value (LCY)" := ROUND("Estimated Value" / "Currency Factor", Currency."Amount Rounding Precision")
            end;
        }
        field(25006010; "Calcd. Current Value"; Decimal)
        {
            Caption = 'Calcd. Current Value';

            trigger OnValidate()
            begin
                if "Currency Code" <> '' then begin
                    Currency.Get("Currency Code");
                    "Calcd. Current Value (LCY)" := ROUND("Calcd. Current Value" / "Currency Factor", Currency."Amount Rounding Precision")
                end else
                    "Calcd. Current Value (LCY)" := "Calcd. Current Value";
            end;
        }
        field(25006020; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                //IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                UpdateCurrencyFactor;
                Validate("Estimated Value (LCY)");
                Validate("Calcd. Current Value (LCY)");
                //END
            end;
        }
        field(25006030; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Currency Factor" <> xRec."Currency Factor" then
                    Validate("Estimated Value (LCY)")
            end;
        }
    }
    var
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;

    procedure GetSalesDocValue2(SalesHeader: Record "Sales Header"): Decimal
    var
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        VATAmount: Decimal;
        VATAmountText: Text[30];
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
    begin
        SalesPost.SumSalesLines(
          SalesHeader, 0, TotalSalesLine, TotalSalesLineLCY,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);
        exit(TotalSalesLine.Amount);
    end;

    procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
        if "Currency Code" <> '' then begin
            if ("Date of Change" = 0D) then
                CurrencyDate := WorkDate
            else
                CurrencyDate := "Date of Change";

            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    procedure GetServDocValue(ServiceHeaderEDMS: Record "Service Header EDMS"): Decimal
    var
        TotalServLine: Record "Service Line EDMS";
        TotalServLineLCY: Record "Service Line EDMS";
        VATAmount: Decimal;
        VATAmountText: Text[30];
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
        ServicePostEDMS: Codeunit "Service-Post EDMS";
    begin
        ServicePostEDMS.SumServiceLines2(ServiceHeaderEDMS, 0, TotalServLine, TotalServLineLCY, VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

        exit(TotalServLineLCY.Amount);
    end;

    procedure GetServDocValue2(ServiceHeaderEDMS: Record "Service Header EDMS"): Decimal
    var
        TotalServLine: Record "Service Line EDMS";
        TotalServLineLCY: Record "Service Line EDMS";
        VATAmount: Decimal;
        VATAmountText: Text[30];
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
        ServicePostEDMS: Codeunit "Service-Post EDMS";
    begin
        ServicePostEDMS.SumServiceLines2(ServiceHeaderEDMS, 0, TotalServLine, TotalServLineLCY, VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

        exit(TotalServLine.Amount);
    end;

}