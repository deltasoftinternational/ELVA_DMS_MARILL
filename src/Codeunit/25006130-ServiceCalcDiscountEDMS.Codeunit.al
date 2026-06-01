Codeunit 25006130 "Service-Calc. Discount EDMS"
{
    TableNo = "Service Line EDMS";

    trigger OnRun()
    begin
        ServLine.Copy(Rec);

        ServHeaderForDiscCalc.Get(Rec."Document Type", Rec."Document No.");
        TemporaryHeader := false;
        CalculateInvoiceDiscount(ServHeaderForDiscCalc, ServLineForDiscCalc);

        Rec := ServLine;
    end;

    var
        Text000: label 'Service Charge';
        ServHeaderForDiscCalc: Record "Service Header EDMS";
        ServLine: Record "Service Line EDMS";
        ServLineForDiscCalc: Record "Service Line EDMS";
        CustInvDisc: Record "Cust. Invoice Disc.";
        CustPostingGr: Record "Customer Posting Group";
        Currency: Record Currency;
        InvDiscBase: Decimal;
        ChargeBase: Decimal;
        CurrencyDate: Date;
        TemporaryHeader: Boolean;
        AmountInvDiscErr: label 'Manual %1 is not allowed.', Comment = '%1 will be "Invoice Discount Amount"';
        InvDiscBaseAmountIsZeroErr: label 'There is no amount that you can apply an invoice discount to.';

    local procedure CalculateInvoiceDiscount(var ServHeader: Record "Service Header EDMS"; var ServLine2: Record "Service Line EDMS")
    var
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        TempServiceChargeLine: Record "Service Line EDMS" temporary;
    begin
        SalesSetup.Get;
        if ServLine.RECORDLEVELLOCKING then
            ServLine.LockTable;
        ServHeader.TestField("Customer Posting Group");
        CustPostingGr.Get(ServHeader."Customer Posting Group");

        ServLine2.Reset;
        ServLine2.SetRange("Document Type", ServLine."Document Type");
        ServLine2.SetRange("Document No.", ServLine."Document No.");
        ServLine2.SetRange("System-Created Entry", true);
        ServLine2.SetRange(Type, ServLine2.Type::"G/L Account");
        ServLine2.SetRange("No.", CustPostingGr."Service Charge Acc.");
        if ServLine2.FindSet(true, false) then
            repeat
                ServLine2.Validate("Unit Price", 0);
                ServLine2.Modify;
                TempServiceChargeLine := ServLine2;
                TempServiceChargeLine.Insert;
            until ServLine2.Next = 0;

        ServLine2.Reset;
        ServLine2.SetRange("Document Type", ServLine."Document Type");
        ServLine2.SetRange("Document No.", ServLine."Document No.");
        ServLine2.SetFilter(Type, '<>0');
        if ServLine2.FindFirst then;
        ServLine2.CalcVATAmountLines(0, ServHeader, ServLine2, TempVATAmountLine);
        InvDiscBase :=
          TempVATAmountLine.GetTotalInvDiscBaseAmount(
            ServHeader."Prices Including VAT", ServHeader."Currency Code");
        ChargeBase :=
          TempVATAmountLine.GetTotalLineAmount(
            ServHeader."Prices Including VAT", ServHeader."Currency Code");

        if not TemporaryHeader then begin
            if not ServLine.RECORDLEVELLOCKING then
                ServLine2.LockTable(true, true);
            ServHeader.Modify;
        end;

        if (ServLine."Document Type" in [ServLine."document type"::Quote]) and
           (ServHeader."Posting Date" = 0D)
        then
            CurrencyDate := WorkDate
        else
            CurrencyDate := ServHeader."Posting Date";

        CustInvDisc.GetRec(
          ServHeader."Invoice Disc. Code", ServHeader."Currency Code", CurrencyDate, ChargeBase);

        if CustInvDisc."Service Charge" <> 0 then begin
            CustPostingGr.TestField("Service Charge Acc.");
            if ServHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else
                Currency.Get(ServHeader."Currency Code");
            if TemporaryHeader then
                ServLine2.SetServHeader(ServHeader);
            if not TempServiceChargeLine.IsEmpty then begin
                TempServiceChargeLine.FindLast;
                ServLine2.Get(ServLine."Document Type", ServLine."Document No.", TempServiceChargeLine."Line No.");
                if ServHeader."Prices Including VAT" then
                    ServLine2.Validate(
                      "Unit Price",
                      ROUND(
                        (1 + ServLine2."VAT %" / 100) * CustInvDisc."Service Charge",
                        Currency."Unit-Amount Rounding Precision"))
                else
                    ServLine2.Validate("Unit Price", CustInvDisc."Service Charge");
                ServLine2.Modify;
            end else begin
                ServLine2.Reset;
                ServLine2.SetRange("Document Type", ServLine."Document Type");
                ServLine2.SetRange("Document No.", ServLine."Document No.");
                ServLine2.FindLast;
                ServLine2.Init;
                if TemporaryHeader then
                    ServLine2.SetServHeader(ServHeader);
                ServLine2."Line No." := ServLine2."Line No." + 10000;
                ServLine2."System-Created Entry" := true;
                ServLine2.Type := ServLine2.Type::"G/L Account";
                ServLine2.Validate("No.", CustPostingGr."Service Charge Acc.");
                ServLine2.Description := Text000;
                ServLine2.Validate(Quantity, 1);
                if ServHeader."Prices Including VAT" then
                    ServLine2.Validate(
                      "Unit Price",
                      ROUND(
                        (1 + ServLine2."VAT %" / 100) * CustInvDisc."Service Charge",
                        Currency."Unit-Amount Rounding Precision"))
                else
                    ServLine2.Validate("Unit Price", CustInvDisc."Service Charge");
                ServLine2.Insert;
            end;
            ServLine2.CalcVATAmountLines(0, ServHeader, ServLine2, TempVATAmountLine);
        end else
            if TempServiceChargeLine.FindSet(false, false) then
                repeat
                    ServLine2 := TempServiceChargeLine;
                    ServLine2.Delete(true);
                until TempServiceChargeLine.Next = 0;

        if CustInvDiscRecExists(ServHeader."Invoice Disc. Code") then begin
            if InvDiscBase <> ChargeBase then
                CustInvDisc.GetRec(
                  ServHeader."Invoice Disc. Code", ServHeader."Currency Code", CurrencyDate, InvDiscBase);

            ServHeader."Invoice Discount Calculation" := ServHeader."invoice discount calculation"::"%";
            ServHeader."Invoice Discount Value" := CustInvDisc."Discount %";
            if not TemporaryHeader then
                ServHeader.Modify;

            TempVATAmountLine.SetInvoiceDiscountPercent(
              CustInvDisc."Discount %", ServHeader."Currency Code",
              ServHeader."Prices Including VAT", SalesSetup."Calc. Inv. Disc. per VAT ID",
              ServHeader."VAT Base Discount %");

            ServLine2.SetServHeader(ServHeader);
            ServLine2.UpdateVATOnLines(0, ServHeader, ServLine2, TempVATAmountLine);
        end;
    end;

    local procedure CustInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        CustInvDisc.SetRange(Code, InvDiscCode);
        exit(CustInvDisc.FindFirst);
    end;


    procedure CalculateWithServHeader(var ServHeaderToCalc: Record "Service Header EDMS"; var ServLineToCalc: Record "Service Line EDMS")
    var
        FilterServLine: Record "Service Line EDMS";
    begin
        FilterServLine.Copy(ServLineToCalc);
        ServLine := ServLineToCalc;

        TemporaryHeader := true;
        CalculateInvoiceDiscount(ServHeaderToCalc, ServLineToCalc);

        ServLineToCalc.Copy(FilterServLine);
    end;


    procedure CalculateIncDiscForHeader(var ServHeader: Record "Service Header EDMS")
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        if not SalesSetup."Calc. Inv. Discount" then exit;
        ServLine."Document Type" := ServHeader."Document Type";
        ServLine."Document No." := ServHeader."No.";
        CalculateInvoiceDiscount(ServHeader, ServLineForDiscCalc);
    end;

    procedure ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount: Decimal; var ServiceHeaderToApply: Record "Service Header EDMS")
    var
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        ServiceLineToCalc: Record "Service Line EDMS";
        InvDiscBaseAmount: Decimal;
    begin
        if not InvoiceDiscIsAllowed(ServiceHeaderToApply."Invoice Disc. Code") then
            Error(AmountInvDiscErr, ServiceHeaderToApply.FieldCaption("Invoice Discount Amount"));

        ServiceLineToCalc.SetRange("Document No.", ServiceHeaderToApply."No.");
        ServiceLineToCalc.SetRange("Document Type", ServiceHeaderToApply."Document Type");

        ServiceLineToCalc.CalcVATAmountLines(0, ServiceHeaderToApply, ServiceLineToCalc, TempVATAmountLine);

        InvDiscBaseAmount := TempVATAmountLine.GetTotalInvDiscBaseAmount(false, ServiceHeaderToApply."Currency Code");

        if (InvDiscBaseAmount = 0) and (InvoiceDiscountAmount > 0) then
            Error(InvDiscBaseAmountIsZeroErr);

        TempVATAmountLine.SetInvoiceDiscountAmount(InvoiceDiscountAmount, ServiceHeaderToApply."Currency Code",
          ServiceHeaderToApply."Prices Including VAT", ServiceHeaderToApply."VAT Base Discount %");

        ServiceLineToCalc.UpdateVATOnLines(0, ServiceHeaderToApply, ServiceLineToCalc, TempVATAmountLine);

        ServiceHeaderToApply."Invoice Discount Calculation" := ServiceHeaderToApply."invoice discount calculation"::Amount;
        ServiceHeaderToApply."Invoice Discount Value" := InvoiceDiscountAmount;

        ResetRecalculateInvoiceDisc(ServiceHeaderToApply);

        ServiceHeaderToApply.Modify;
    end;

    procedure InvoiceDiscIsAllowed(InvDiscCode: Code[20]): Boolean
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get;
        if not SalesReceivablesSetup."Calc. Inv. Discount" then
            exit(true);

        exit(not CustInvDiscRecExists(InvDiscCode));
    end;

    procedure ResetRecalculateInvoiceDisc(ServiceHeaderToReset: Record "Service Header EDMS")
    var
        ServiceLineToCalc: Record "Service Line EDMS";
    begin
        ServiceLineToCalc.SetRange("Document Type", ServiceHeaderToReset."Document Type");
        ServiceLineToCalc.SetRange("Document No.", ServiceHeaderToReset."No.");
        ServiceLineToCalc.SetRange("Recalculate Invoice Disc.", true);
        ServiceLineToCalc.ModifyAll("Recalculate Invoice Disc.", false);
    end;
}

