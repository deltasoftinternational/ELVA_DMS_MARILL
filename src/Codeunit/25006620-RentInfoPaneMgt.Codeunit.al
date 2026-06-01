Codeunit 25006620 "Rent Info-Pane Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        LookUpMgt: Codeunit LookUpManagement;
        Customer: Record Customer;
        Item: Record Item;


    procedure CalcNoOfDocuments(var Cust: Record Customer)
    begin
        Cust.CalcFields(
          "No. of Quotes", "No. of Blanket Orders", "No. of Orders", "No. of Invoices",
          "No. of Return Orders", "No. of Credit Memos", "No. of Pstd. Shipments",
          "No. of Pstd. Invoices", "No. of Pstd. Return Receipts", "No. of Pstd. Credit Memos");
    end;


    procedure CalcTotalNoOfDocuments(CustNo: Code[20]): Integer
    begin
        if Customer."No." <> CustNo then
            Customer.Get(CustNo);
        CalcNoOfDocuments(Customer);
        exit(
          Customer."No. of Quotes" + Customer."No. of Blanket Orders" + Customer."No. of Orders" + Customer."No. of Invoices" +
          Customer."No. of Return Orders" + Customer."No. of Credit Memos" + Customer."No. of Pstd. Shipments" +
          Customer."No. of Pstd. Invoices" + Customer."No. of Pstd. Return Receipts" + Customer."No. of Pstd. Credit Memos");
    end;


    procedure CalcNoOfShipToAddr(CustNo: Code[20]): Integer
    begin
        if Customer."No." <> CustNo then
            Customer.Get(CustNo);
        Customer.CalcFields("No. of Ship-to Addresses");
        exit(Customer."No. of Ship-to Addresses");
    end;


    procedure CalcNoOfContacts(RentHeader: Record "Rent Header"): Integer
    var
        Cont: Record Contact;
        ContBusRelation: Record "Contact Business Relation";
    begin
        Cont.SetCurrentkey("Company No.");
        if RentHeader."Sell-to Customer No." <> '' then begin
            if Cont.Get(RentHeader."Sell-to Contact No.") then
                Cont.SetRange("Company No.", Cont."Company No.")
            else begin
                ContBusRelation.Reset;
                ContBusRelation.SetCurrentkey("Link to Table", "No.");
                ContBusRelation.SetRange("Link to Table", ContBusRelation."link to table"::Customer);
                ContBusRelation.SetRange("No.", RentHeader."Sell-to Customer No.");
                if ContBusRelation.FindFirst then
                    Cont.SetRange("Company No.", ContBusRelation."Contact No.")
                else
                    Cont.SetRange("No.", '');
            end;
            exit(Cont.Count);
        end;
    end;


    procedure CalcAvailableCredit(CustNo: Code[20]): Decimal
    var
        TotalAmountLCY: Decimal;
    begin
        if Customer."No." <> CustNo then
            Customer.Get(CustNo);
        Customer.SetRange("Date Filter", 0D, WorkDate);
        Customer.CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)");
        TotalAmountLCY := Customer."Balance (LCY)" + Customer."Outstanding Orders (LCY)" + Customer."Shipped Not Invoiced (LCY)";

        if Customer."Credit Limit (LCY)" <> 0 then
            exit(Customer."Credit Limit (LCY)" - TotalAmountLCY);
    end;


    procedure CalcAvailability(var RentSalesLine: Record "Rent Sales Line"): Decimal
    var
        UserProfile: Record "Branch Profile Setup";
        AvailableToPromise: Codeunit "Available to Promise";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        LocationCode: Code[20];
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
        UserProfileMgt: Codeunit UserProfileManagement;
    begin
        if GetItem(RentSalesLine) then begin
            if RentSalesLine."Planned Delivery Date" <> 0D then
                AvailabilityDate := RentSalesLine."Planned Delivery Date"
            else
                AvailabilityDate := WorkDate;

            LocationCode := RentSalesLine."Location Code";
            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) and (UserProfile."Def. Spare Part Location Code" <> '') then
                LocationCode := UserProfile."Def. Spare Part Location Code";

            Item.Reset;
            Item.SetRange("Date Filter", 0D, AvailabilityDate);
            Item.SetRange("Variant Filter", RentSalesLine."Variant Code");
            Item.SetRange("Location Filter", LocationCode);
            Item.SetRange("Drop Shipment Filter", false);

            exit(
              AvailableToPromise.CalcQtyAvailableToPromise(
                Item,
                GrossRequirement,
                ScheduledReceipt,
                AvailabilityDate,
                PeriodType,
                LookaheadDateformula));
        end;
    end;


    procedure CalcNoOfSubstitutions(var RentSalesLine: Record "Rent Sales Line"): Integer
    begin
        if GetItem(RentSalesLine) then begin
            Item.CalcFields("No. of Substitutes");
            exit(Item."No. of Substitutes");
        end;
    end;

    //DELTA SALES PRICE

    procedure CalcNoOfSalesPrices(var RentSalesLine: Record "Rent Sales Line"): Integer
    var
        RentHeader: Record "Rent Header";
    begin

        if GetItem(RentSalesLine) then begin
            RentHeader.Get(RentSalesLine."Document Type", RentSalesLine."Document No.");
            exit(SalesPriceCalcMgt.NoOfRentSalesLinePrice(RentHeader, RentSalesLine, true));
        end;
    end;


    procedure CalcNoOfSalesLineDisc(var RentSalesLine: Record "Rent Sales Line"): Integer
    var
        RentHeader: Record "Rent Header";
    begin
        if GetItem(RentSalesLine) then begin
            RentHeader.Get(RentSalesLine."Document Type", RentSalesLine."Document No.");
            exit(SalesPriceCalcMgt.NoOfRentSalesLineLineDisc(RentHeader, RentSalesLine, true));
        end;
    end;


    procedure CustCommentExists(CustNo: Code[20]): Boolean
    begin
        if Customer."No." <> CustNo then
            Customer.Get(CustNo);
        Customer.CalcFields(Comment);
        exit(Customer.Comment);
    end;


    procedure ItemCommentExists(RentSalesLine: Record "Rent Sales Line"): Boolean
    begin
        if GetItem(RentSalesLine) then begin
            Item.CalcFields(Comment);
            exit(Item.Comment);
        end;
    end;


    procedure LookupContacts(var RentHeader: Record "Rent Header")
    var
        Cont: Record Contact;
        ContBusRelation: Record "Contact Business Relation";
    begin
        if (RentHeader."Sell-to Customer No." <> '') and (Cont.Get(RentHeader."Sell-to Contact No.")) then
            Cont.SetRange("Company No.", Cont."Company No.")
        else
            if RentHeader."Sell-to Customer No." <> '' then begin
                ContBusRelation.Reset;
                ContBusRelation.SetCurrentkey("Link to Table", "No.");
                ContBusRelation.SetRange("Link to Table", ContBusRelation."link to table"::Customer);
                ContBusRelation.SetRange("No.", RentHeader."Sell-to Customer No.");
                if ContBusRelation.FindFirst then
                    Cont.SetRange("Company No.", ContBusRelation."Contact No.");
            end else
                Cont.SetFilter("Company No.", '<>''''');

        if RentHeader."Sell-to Contact No." <> '' then
            if Cont.Get(RentHeader."Sell-to Contact No.") then;
        if Page.RunModal(0, Cont) = Action::LookupOK then begin
            RentHeader.Validate("Sell-to Contact No.", Cont."No.");
            RentHeader.Modify(true);
        end;
    end;


    procedure LookupAvailCredit(CustNo: Code[20])
    begin
        if Customer."No." <> CustNo then
            Customer.Get(CustNo);
        Page.RunModal(Page::"Available Credit", Customer);
    end;


    procedure LookupItem(RentSalesLine: Record "Rent Sales Line")
    begin
        RentSalesLine.TestField(Type, RentSalesLine.Type::Item);
        RentSalesLine.TestField("No.");
        GetItem(RentSalesLine);
        Page.RunModal(Page::"Item List", Item);
    end;


    procedure LookupItemComment(RentSalesLine: Record "Rent Sales Line")
    var
        CommentLine: Record "Comment Line";
    begin
        if GetItem(RentSalesLine) then begin
            CommentLine.SetRange("Table Name", CommentLine."table name"::Item);
            CommentLine.SetRange("No.", RentSalesLine."No.");
            Page.RunModal(Page::"Comment Sheet", CommentLine);
        end;
    end;

    local procedure GetItem(var RentSalesLine: Record "Rent Sales Line"): Boolean
    begin
        if (RentSalesLine.Type <> RentSalesLine.Type::Item) or (RentSalesLine."No." = '') then
            exit(false);

        if RentSalesLine."No." <> Item."No." then
            Item.Get(RentSalesLine."No.");
        exit(true);
    end;

    procedure CalcAvailableInventory(RentSalesLine: Record "Rent Sales Line"): Decimal
    var
        AvailabilityDate: Date;
        LocationCode: Code[20];
        UserProfile: Record "Branch Profile Setup";
        UserProfileMgt: Codeunit UserProfileManagement;
        AvailableToPromise: Codeunit "Available to Promise";
    begin
        if GetItem(RentSalesLine) then begin

            if RentSalesLine."Planned Delivery Date" <> 0D then
                AvailabilityDate := RentSalesLine."Planned Delivery Date"
            else
                AvailabilityDate := WorkDate;

            LocationCode := RentSalesLine."Location Code";
            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) and (UserProfile."Def. Spare Part Location Code" <> '') then
                LocationCode := UserProfile."Def. Spare Part Location Code";

            Item.Reset;
            Item.SetRange("Date Filter", 0D, AvailabilityDate);
            Item.SetRange("Variant Filter", RentSalesLine."Variant Code");
            Item.SetRange("Location Filter", LocationCode);
            Item.SetRange("Drop Shipment Filter", false);


            exit(
              ConvertQty(
                AvailableToPromise.CalcAvailableInventory(Item),
                RentSalesLine."Qty. per Unit of Measure"));
        end;
    end;

    local procedure ConvertQty(Qty: Decimal; PerUoMQty: Decimal): Decimal
    begin
        if PerUoMQty = 0 then
            PerUoMQty := 1;
        exit(ROUND(Qty / PerUoMQty, 0.00001));
    end;


    procedure CalcLastVFRun1(RentAssetNo: Code[20]): Decimal
    var
        RentLedgerEntry: Record "Rent Ledger Entry";
    begin
        RentLedgerEntry.Reset;
        RentLedgerEntry.SetRange("Rent Asset No.", RentAssetNo);
        RentLedgerEntry.SetFilter("Entry Type", '%1', RentLedgerEntry."entry type"::Inventory);
        if RentLedgerEntry.FindLast then
            exit(RentLedgerEntry."Variable Field Run 1")
        else
            exit(0);
    end;


    procedure CalcLastVFRun2(RentAssetNo: Code[20]): Decimal
    var
        RentLedgerEntry: Record "Rent Ledger Entry";
    begin
        RentLedgerEntry.Reset;
        RentLedgerEntry.SetRange("Rent Asset No.", RentAssetNo);
        RentLedgerEntry.SetFilter("Entry Type", '%1', RentLedgerEntry."entry type"::Inventory);
        if RentLedgerEntry.FindLast then
            exit(RentLedgerEntry."Variable Field Run 2")
        else
            exit(0);
    end;


    procedure CalcLastVFRun3(RentAssetNo: Code[20]): Decimal
    var
        RentLedgerEntry: Record "Rent Ledger Entry";
    begin
        RentLedgerEntry.Reset;
        RentLedgerEntry.SetRange("Rent Asset No.", RentAssetNo);
        RentLedgerEntry.SetFilter("Entry Type", '%1', RentLedgerEntry."entry type"::Inventory);
        if RentLedgerEntry.FindLast then
            exit(RentLedgerEntry."Variable Field Run 3")
        else
            exit(0);
    end;
}

