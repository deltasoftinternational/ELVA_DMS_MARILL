Codeunit 25006609 "Release Rent Document"
{
    TableNo = "Rent Header";

    trigger OnRun()
    var
        RentSalesLine: Record "Rent Sales Line";
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        NotOnlyDropShipment: Boolean;
        PutInTakeOut: Codeunit "Service Transfer Mgt.";
        Text100: label 'It is impossible to transfer this item because it is used in SIE.';
        BillCustomer: Record Customer;
        CustEntry: Record "Cust. Ledger Entry";
        PositiveAmounts: Decimal;
        NegativeAmounts: Decimal;
        Text101: label 'Customer has overdue amounts and you are not allowed to release document.';
        Text102: label 'Customer has too less open balance to release this document.';
        AmountsOfLines: Decimal;
        Text103: label 'Customer credit limit is exceeded.';
    begin
        if Rec.Status = Rec.Status::Released then
            exit;

        if Rec."Document Type" = Rec."document type"::Quote then
            if Rec.CheckCustomerCreated(true) then
                Rec.Get(Rec."document type"::Quote, Rec."No.")
            else
                exit;

        Rec.TestField("Sell-to Customer No.");


        RentSalesLine.SetRange("Document Type", Rec."Document Type");
        RentSalesLine.SetRange("Document No.", Rec."No.");
        RentSalesLine.SetFilter(Type, '>0');
        RentSalesLine.SetFilter(Quantity, '<>0');
        RentSalesLine.Reset;
        Rec.Status := Rec.Status::Released;

        RentSalesLine.SetRentHeader(Rec);
        RentSalesLine.CalcVATAmountLines(0, Rec, RentSalesLine, TempVATAmountLine0);
        RentSalesLine.UpdateVATOnLines(0, Rec, RentSalesLine, TempVATAmountLine0);

        Rec.Modify(true);
        Commit;
    end;

    var
        Text001: label 'There is nothing to release for %1 %2.';
        SalesSetup: Record "Sales & Receivables Setup";
        InvtSetup: Record "Inventory Setup";
        WhseSalesRelease: Codeunit "Whse.-Sales Release";
        Text002: label 'This document can only be released when the approval process is complete.';
        Text003: label 'The approval process must be cancelled or completed to reopen this document.';
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        EDMSSetup: Record "Make Setup";
        LicensePermission: Record "License Permission";
        ApprAllowed: Boolean;
        Approved: Boolean;
        UserSetup: Record "User Setup";
        Text004: label '';


    procedure Reopen(var RentHeader: Record "Rent Header")
    var
        RentSalesLine: Record "Rent Sales Line";
    begin
        if RentHeader.Status = RentHeader.Status::Open then
            exit;
        RentHeader.Status := RentHeader.Status::Open;
        RentSalesLine.SetRentHeader(RentHeader);
        RentSalesLine.SetRange("Document Type", RentHeader."Document Type");
        RentSalesLine.SetRange("Document No.", RentHeader."No.");
        RentSalesLine.SetFilter(Type, '>0');
        RentSalesLine.SetFilter(Quantity, '<>0');


        if RentHeader.RECORDLEVELLOCKING then
            RentSalesLine.LockTable;
        if RentSalesLine.FindSet then
            repeat
                RentSalesLine.Amount := 0;
                RentSalesLine."Amount Including VAT" := 0;
                RentSalesLine."VAT Base Amount" := 0;
                RentSalesLine.Modify;
            until RentSalesLine.Next = 0;
        RentSalesLine.Reset;
        RentHeader.Modify(true);
    end;


    procedure PerformManualRelease(var RentHeader: Record "Rent Header")
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovedOnly: Boolean;
    begin
        case RentHeader.Status of
            RentHeader.Status::"Pending Approval":
                Codeunit.Run(Codeunit::"Release Rent Document", RentHeader);
            RentHeader.Status::Released:
                Codeunit.Run(Codeunit::"Release Rent Document", RentHeader);
            RentHeader.Status::Open:
                Codeunit.Run(Codeunit::"Release Rent Document", RentHeader);
        end;
    end;


    procedure PerformManualReopen(var RentHeader: Record "Rent Header")
    begin
        case RentHeader.Status of
            RentHeader.Status::Open, RentHeader.Status::Released, RentHeader.Status::"Pending Prepayment":
                Reopen(RentHeader);
        end;
    end;
}

