Codeunit 25006018 "Service Document Totals"
{

    trigger OnRun()
    begin
    end;


    procedure CalculateServiceHeaderTotals(var ServiceHeader: Record "Service Header EDMS"; var VATAmount: Decimal; ServiceLine: Record "Service Line EDMS")
    begin
        if ServiceHeader.Get(ServiceLine."Document Type", ServiceLine."Document No.") then begin
            ServiceHeader.CalcFields(Amount, "Amount Including VAT");
            VATAmount := ServiceHeader."Amount Including VAT" - ServiceHeader.Amount;
        end;
    end;

    procedure CalculateServiceSubPageTotals(ServiceLineToCalc: Record "Service Line EDMS"; var TotalServiceLine: Record "Service Line EDMS"; var VATAmount: Decimal; var InvoiceDiscountAmount: Decimal; var InvoiceDiscountPct: Decimal)
    var
        ServiceLine2: Record "Service Line EDMS";
        TotalServiceLine2: Record "Service Line EDMS";
        SalesSetup: Record "Sales & Receivables Setup";
        ServiceHeader: Record "Service Header EDMS";
    begin
        SalesSetup.Get;
        TotalServiceLine2.Copy(TotalServiceLine);
        TotalServiceLine2.Reset;
        TotalServiceLine2.SetRange("Document Type", ServiceLineToCalc."Document Type");
        TotalServiceLine2.SetRange("Document No.", ServiceLineToCalc."Document No.");
        ServiceHeader.Get(ServiceLineToCalc."Document Type", ServiceLineToCalc."Document No.");

        TotalServiceLine2.CalcSums(Amount, "Amount Including VAT", "Line Amount", "Inv. Discount Amount");
        VATAmount := TotalServiceLine2."Amount Including VAT" - TotalServiceLine2.Amount;
        InvoiceDiscountAmount := TotalServiceLine2."Inv. Discount Amount";

        if (InvoiceDiscountAmount = 0) or (TotalServiceLine2."Line Amount" = 0) then
            InvoiceDiscountPct := 0
        else
            case ServiceHeader."Invoice Discount Calculation" of
                ServiceHeader."invoice discount calculation"::"%":
                    InvoiceDiscountPct := ServiceHeader."Invoice Discount Value";
                ServiceHeader."invoice discount calculation"::None,
                ServiceHeader."invoice discount calculation"::Amount:
                    begin
                        ServiceLine2.CopyFilters(TotalServiceLine2);
                        ServiceLine2.SetRange("Allow Invoice Disc.", true);
                        ServiceLine2.CalcSums("Line Amount");
                        InvoiceDiscountPct := ROUND(InvoiceDiscountAmount / ServiceLine2."Line Amount" * 100, 0.00001);
                    end;
            end;


        TotalServiceLine := TotalServiceLine2;
        OnAfterSalesUpdateTotals(ServiceLineToCalc, TotalServiceLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
    end;

    procedure CalcTotalServiceAmountOnlyDiscountAllowed(ServiceLine: Record "Service Line EDMS"): Decimal
    var
        TotalServiceLine: Record "Service Line EDMS";
    begin
        TotalServiceLine.SetRange("Document Type", ServiceLine."Document Type");
        TotalServiceLine.SetRange("Document No.", ServiceLine."Document No.");
        TotalServiceLine.SetRange("Allow Invoice Disc.", true);
        TotalServiceLine.CalcSums("Line Amount");
        exit(TotalServiceLine."Line Amount");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesUpdateTotals(ServiceLineToCalc: Record "Service Line EDMS"; var TotalServiceLine: Record "Service Line EDMS"; var VATAmount: Decimal; var InvoiceDiscountAmount: Decimal; var InvoiceDiscountPct: Decimal)
    begin
    end;
}

