pageextension 25006067 "Apply Customer Entries" extends "Apply Customer Entries"   //232
{
    var
        ServHeaderEDMS: Record "Service Header EDMS";
        TotalServLineEDMS: Record "Service Line EDMS";
        TotalServLineLCYEDMS: Record "Service Line EDMS";
        ServicePost: Codeunit "Service-Post EDMS";

    procedure SetServiceEDMS(NewServHeader: Record "Service Header EDMS"; var NewCustLedgEntry: Record "Cust. Ledger Entry"; ApplnTypeSelect: Integer)
    var
        TotalAdjCostLCY: Decimal;
    begin
        ServHeaderEDMS := NewServHeader;
        Rec.CopyFilters(NewCustLedgEntry);

        ServicePost.SumServiceLines2(
          ServHeaderEDMS, 0, TotalServLineEDMS, TotalServLineLCYEDMS,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

        case ServHeaderEDMS."Document Type" of
            ServHeaderEDMS."document type"::"Return Order":
                ApplyingAmount := -TotalServLineEDMS."Amount Including VAT"
            else
                ApplyingAmount := TotalServLineEDMS."Amount Including VAT";
        end;

        ApplnDate := ServHeaderEDMS."Posting Date";
        ApplnCurrencyCode := ServHeaderEDMS."Currency Code";
        CalcType := Calctype::"Service Header EDMS";

        case ApplnTypeSelect of
            ServHeaderEDMS.FieldNo("Applies-to Doc. No."):
                ApplnType := Applntype::"Applies-to Doc. No.";
        end;

        SetApplyingCustLedgEntry;
    end;

}