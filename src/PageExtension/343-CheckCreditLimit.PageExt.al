pageextension 25006073 "Check Credit Limit" extends "Check Credit Limit" //343
{
    var
        CurrExchRate: Record "Currency Exchange Rate";
        SalesSetup: Record "Sales & Receivables Setup";
        NotificationId: Guid;


    procedure ServiceHeaderShowWarningEDMS(ServiceHeader: Record "Service Header EDMS"): Boolean
    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
    begin
        ServiceSetup.Get;
        if ServiceSetup."Credit Warnings" =
           ServiceSetup."credit warnings"::"No Warning"
        then
            exit(false);

        if ServiceHeader."Currency Code" = '' then
            NewOrderAmountLCY := ServiceHeader."Amount Including VAT"
        else
            NewOrderAmountLCY :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  WorkDate, ServiceHeader."Currency Code",
                  ServiceHeader."Amount Including VAT", ServiceHeader."Currency Factor"));

        exit(ShowWarning(ServiceHeader."Bill-to Customer No.", NewOrderAmountLCY, 0, true));
    end;

    procedure RentHeaderShowWarningAndGetCause(RentHeader: Record "Rent Header"; var NotificationContextGuidOut: Guid): Boolean
    var
        Result: Boolean;
    begin
        Result := RentHeaderShowWarning(RentHeader);
        NotificationContextGuidOut := NotificationId;
        exit(Result);
    end;


    procedure RentHeaderShowWarning(RentHeader: Record "Rent Header"): Boolean
    var
        OldRentHeader: Record "Rent Header";
        AssignDeltaAmount: Boolean;
    begin
        // Used when additional lines are inserted
        SalesSetup.Get;
        if SalesSetup."Credit Warnings" =
           SalesSetup."credit warnings"::"No Warning"
        then
            exit(false);
        if RentHeader."Currency Code" = '' then
            NewOrderAmountLCY := RentHeader."Amount Including VAT"
        else
            NewOrderAmountLCY :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  WorkDate, RentHeader."Currency Code",
                  RentHeader."Amount Including VAT", RentHeader."Currency Factor"));

        if not (RentHeader."Document Type" in
                [RentHeader."document type"::Quote,
                 RentHeader."document type"::Order,
                 RentHeader."document type"::"Return Order"])
        then
            NewOrderAmountLCY := NewOrderAmountLCY + RentLineAmount(RentHeader."Document Type", RentHeader."No.");
        OldRentHeader := RentHeader;
        if OldRentHeader.Find then
            // If "Bill-To Customer" is the same and Sales Header exists then do not consider amount in credit limit calculation since it's already included in "Outstanding Amount"
            // If "Bill-To Customer" was changed the consider amount in credit limit calculation since changes was not yet commited and not included in "Outstanding Amount"
            AssignDeltaAmount := OldRentHeader."Bill-to Customer No." <> RentHeader."Bill-to Customer No."
        else
            // If Sales Header is not inserted yet then consider the amount in credit limit calculation
            AssignDeltaAmount := true;
        if AssignDeltaAmount then
            DeltaAmount := NewOrderAmountLCY;
        exit(ShowWarning(RentHeader."Bill-to Customer No.", NewOrderAmountLCY, 0, true));
    end;


    procedure RentLineAmount(DocType: Integer; DocNo: Code[20]): Decimal

    var
        RentLine: Record "Rent Line";
    begin
        RentLine.Reset;
        RentLine.SetRange("Document Type", DocType);
        RentLine.SetRange("Document No.", DocNo);
        RentLine.CalcSums("Amount Including VAT");
        exit(RentLine."Amount Including VAT");
    end;



}