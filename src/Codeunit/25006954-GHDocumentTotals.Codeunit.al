Codeunit 25006954 "GH Document Totals"
{
    // 22/03/2018 P30 GP1 GH
    //   Added function:
    //     CalculateServiceHeaderTotalsVHC


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


    procedure CalculateServiceHeaderTotalsVHC(var PriceCalcAmount: Decimal; var PriceCalcVATAmount: Decimal; var PriceCalcAmountInclVAT: Decimal; var CustAuthorisedAmount: Decimal; var CustAuthorisedVATAmount: Decimal; var CustAuthorisedAmountInclVAT: Decimal; ServiceLine: Record "Service Line EDMS")
    var
        ServiceLineToCalculate: Record "Service Line EDMS";
    begin
        ServiceLineToCalculate.Reset;
        ServiceLineToCalculate.SetRange("Document Type", ServiceLine."Document Type");
        ServiceLineToCalculate.SetRange("Document No.", ServiceLine."Document No.");
        ServiceLineToCalculate.SetRange("Include in Price Calculation", true);
        ServiceLineToCalculate.CalcSums(Amount, "Amount Including VAT");
        PriceCalcAmount := ServiceLineToCalculate.Amount;
        PriceCalcAmountInclVAT := ServiceLineToCalculate."Amount Including VAT";
        PriceCalcVATAmount := PriceCalcAmountInclVAT - PriceCalcAmount;

        ServiceLineToCalculate.Reset;
        ServiceLineToCalculate.SetRange("Document Type", ServiceLine."Document Type");
        ServiceLineToCalculate.SetRange("Document No.", ServiceLine."Document No.");
        ServiceLineToCalculate.SetRange("Customer Authorised", true);
        ServiceLineToCalculate.CalcSums(Amount, "Amount Including VAT");
        CustAuthorisedAmount := ServiceLineToCalculate.Amount;
        CustAuthorisedAmountInclVAT := ServiceLineToCalculate."Amount Including VAT";
        CustAuthorisedVATAmount := CustAuthorisedAmountInclVAT - CustAuthorisedAmount;
    end;
}

