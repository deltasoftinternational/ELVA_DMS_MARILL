Codeunit 25006616 "Rent-Quote to Order (Yes/No)"
{
    TableNo = "Rent Header";

    trigger OnRun()
    var
        OfficeMgt: Codeunit "Office Management";
        OpenPage: Boolean;
        RentOrder: Page "Rent Order";
    begin
        Rec.TestField("Document Type", Rec."document type"::Quote);
        if GuiAllowed then
            if not Confirm(Text000, false) then
                exit;

        if (Rec."Document Type" = Rec."document type"::Quote) then
            if Rec.CheckCustomerCreated(true) then
                Rec.Get(Rec."document type"::Quote, Rec."No.")
            else
                exit;

        RentQuoteToOrder.Run(Rec);
        RentQuoteToOrder.GetRentOrderHeader(RentHeader2);
        Commit;

        if GuiAllowed then
            if OfficeMgt.AttachAvailable then
                OpenPage := true
            else
                OpenPage := Confirm(StrSubstNo(OpenNewInvoiceQst, RentHeader2."No."), true);
        if OpenPage then begin
            Clear(RentOrder);
            RentHeader2.SetRecfilter;
            RentOrder.SetTableview(RentHeader2);
            RentOrder.Run;
        end;
    end;

    var
        Text000: label 'Do you want to convert the quote to an order?';
        Text001: label 'Quote %1 has been changed to order %2.';
        RentHeader2: Record "Rent Header";
        RentQuoteToOrder: Codeunit "Rent-Quote to Order";
        Text002: label 'This quote has not been accepted by the customer.\\Do you still want to convert it to an order?';
        Text003: label 'This quote has been rejected by the customer.\\Do you still want to convert it to an order?';
        OpenNewInvoiceQst: label 'The quote has been converted to order %1. Do you want to open the new order?', Comment = '%1 = No. of the new sales order document.';
}

