Codeunit 25006781 "Item Mgt. EDMS"
{
    // #Owner EDMS.Integration


    trigger OnRun()
    begin
    end;

    local procedure "-- General --"()
    begin
    end;


    procedure GetPriceForItem(ItemNo: Code[20])
    var
        Item: Record Item;
    begin
        Item.Reset;
        Item.SetRange("No.", ItemNo);
        GetPriceForItems(Item);
    end;


    procedure GetPriceForItems(var Item: Record Item)
    var
        UserIntegrationSession: Record "User Integr. Session Header";
        DMSIntegrationMgt: Codeunit "Integration Management EDMS";
    begin
        Item.FindFirst;
        DMSIntegrationMgt.OpenUserSession(Database::Item, Database::Item, 0, '', 0, true, UserIntegrationSession);

        repeat
            UserIntegrationSession.AddLineForItem(Item."No.", '', '', 1,
                                                  Database::Item, 0, Item."No.", 0);
        until Item.Next = 0;
        Commit;
        DMSIntegrationMgt.OpenUserSessionDialog(UserIntegrationSession, 1, true);
    end;


    procedure GetPriceForPurchDoc(PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        UserIntegrationSession: Record "User Integr. Session Header";
        DMSIntegrationMgt: Codeunit "Integration Management EDMS";
    begin
        PurchHeader.TestField("No.");
        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetFilter("No.", '<>%1', '');
        PurchLine.FindFirst;

        DMSIntegrationMgt.OpenUserSession(Database::Vendor,
                                          Database::"Purchase Header", PurchHeader."Document Type", PurchHeader."No.", 0,
                                          false,
                                          UserIntegrationSession);

        repeat
            UserIntegrationSession.AddLineForItem(PurchLine."No.", PurchLine."Variant Code", PurchLine."Location Code", PurchLine."Quantity (Base)",
                                                  Database::"Purchase Line", PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No.");
        until PurchLine.Next = 0;
        Commit;
        DMSIntegrationMgt.OpenUserSessionDialog(UserIntegrationSession, 1, true);
    end;


    procedure GetPriceForSalesDoc(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        UserIntegrationSession: Record "User Integr. Session Header";
        DMSIntegrationMgt: Codeunit "Integration Management EDMS";
    begin
        SalesHeader.TestField("No.");
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<>%1', '');
        SalesLine.FindFirst;

        DMSIntegrationMgt.OpenUserSession(Database::Item,
                                          Database::"Sales Header", SalesHeader."Document Type", SalesHeader."No.", 0,
                                          false,
                                          UserIntegrationSession);

        repeat
            UserIntegrationSession.AddLineForItem(SalesLine."No.", SalesLine."Variant Code", SalesLine."Location Code", SalesLine."Quantity (Base)",
                                                  Database::"Sales Line", SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.");
        until SalesLine.Next = 0;
        Commit;
        DMSIntegrationMgt.OpenUserSessionDialog(UserIntegrationSession, 1, true);
    end;


    procedure GetAvailabilityForItem(ItemNo: Code[20])
    var
        Item: Record Item;
    begin
        Item.Reset;
        Item.SetRange("No.", ItemNo);
        GetAvailabilityForItems(Item);
    end;


    procedure GetAvailabilityForItems(var Item: Record Item)
    begin
    end;

    local procedure "-- Logic --"()
    begin
    end;
}

