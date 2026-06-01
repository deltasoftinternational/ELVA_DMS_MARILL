Codeunit 25006294 "Item Cost Management"
{

    trigger OnRun()
    begin
    end;

    var
        UpdatePriceMsg: label 'Price for Item %1 has been changed from %2 to %3!';


    procedure RefreshCostsService(ServiceHeader: Record "Service Header EDMS")
    var
        ServiceLineToRefresh: Record "Service Line EDMS";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        TempSalesPriceList: Record "Sales Price DMS" temporary;
        InventorySetup: Record "Inventory Setup";
        PrevPrice: Decimal;
        UnitCost: Decimal;
    begin
        //DELTA SALES PRICE

        InventorySetup.Get;

        ServiceLineToRefresh.Reset;
        ServiceLineToRefresh.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLineToRefresh.SetRange("Document No.", ServiceHeader."No.");
        ServiceLineToRefresh.SetRange(Type, ServiceLineToRefresh.Type::Item);
        if ServiceLineToRefresh.FindSet then
            repeat
                if ServiceLineToRefresh.CalcTransferedQuantity = ServiceLineToRefresh.Quantity then begin
                    UnitCost := GetAverageItemCost(ServiceLineToRefresh."No.", ServiceLineToRefresh."Variant Code", ServiceLineToRefresh."Location Code");
                    if ServiceLineToRefresh."Unit Cost (LCY)" <> UnitCost then begin
                        ServiceLineToRefresh.Validate("Unit Cost (LCY)", UnitCost);
                        ServiceLineToRefresh.Modify;
                        //Item.GET(SalesLineToRefresh."No.");
                        //SalesLineToRefresh.UpdateUnitPrice(SalesLineToRefresh.FIELDNO("Unit Cost (LCY)"));
                        if InventorySetup."Updt. Markup Pr. on Refr. Cost" <> InventorySetup."updt. markup pr. on refr. cost"::"No update" then begin
                            SalesPriceCalcMgt.GetDMSServLinePriceList(ServiceHeader, ServiceLineToRefresh, TempSalesPriceList);
                            TempSalesPriceList.Reset;
                            TempSalesPriceList.SetRange("Sales Type", TempSalesPriceList."sales type"::Markup);
                            TempSalesPriceList.SetRange("Currency Code", ServiceHeader."Currency Code");
                            TempSalesPriceList.SetCurrentkey("Unit Price");
                            if TempSalesPriceList.IsEmpty = false then begin
                                PrevPrice := ServiceLineToRefresh."Unit Price";
                                TempSalesPriceList.FindFirst;
                                ServiceLineToRefresh.Validate("Unit Price", TempSalesPriceList."Unit Price");
                                ServiceLineToRefresh.Modify;
                                if (InventorySetup."Updt. Markup Pr. on Refr. Cost" = InventorySetup."updt. markup pr. on refr. cost"::"Update and Show") and GuiAllowed then
                                    Message(UpdatePriceMsg, ServiceLineToRefresh."No.", PrevPrice, ServiceLineToRefresh."Unit Price");
                            end;
                        end;
                    end;
                end;
            until ServiceLineToRefresh.Next = 0;
    end;


    procedure GetAverageItemCost(var ItemNo: Code[20]; var VariantCode: Code[20]; var LocationCode: Code[20]): Decimal
    var
        ValueEntry: Record "Value Entry";
        Item: Record Item;
    begin
        Item.Reset;
        Item.SetRange("No.", ItemNo);
        Item.SetFilter("Location Filter", LocationCode);
        if Item.FindFirst then;
        Item.CalcFields(Inventory);
        ValueEntry.Reset;
        ValueEntry.SetRange("Item No.", ItemNo);
        ValueEntry.SetRange("Variant Code", VariantCode);
        ValueEntry.SetRange("Location Code", LocationCode);
        ValueEntry.CalcSums("Cost Amount (Actual)", "Cost Amount (Expected)");
        Item.SetFilter("Variant Filter", VariantCode);
        Item.SetFilter("Location Filter", LocationCode);
        if Item.Inventory <> 0 then
            exit(ROUND((ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)") / Item.Inventory, 0.00001));
    end;


    procedure RefreshCostsSale(SalesHeader: Record "Sales Header")
    var
        SalesLineToRefresh: Record "Sales Line";
        Item: Record Item;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        TempSalesPriceList: Record "Sales Price DMS" temporary;
        InventorySetup: Record "Inventory Setup";
        PrevPrice: Decimal;
        UnitCost: Decimal;
    begin
        //DELTA SALES PRICE

        InventorySetup.Get;
        SalesLineToRefresh.Reset;
        SalesLineToRefresh.SetRange("Document Type", SalesHeader."Document Type");
        SalesLineToRefresh.SetRange("Document No.", SalesHeader."No.");
        SalesLineToRefresh.SetRange(Type, SalesLineToRefresh.Type::Item);
        if SalesLineToRefresh.FindSet then
            repeat
                TempSalesPriceList.DeleteAll();
                UnitCost := GetAverageItemCost(SalesLineToRefresh."No.", SalesLineToRefresh."Variant Code", SalesLineToRefresh."Location Code");
                if UnitCost <> SalesLineToRefresh."Unit Cost (LCY)" then begin
                    SalesLineToRefresh.Validate("Unit Cost (LCY)", UnitCost);
                    SalesLineToRefresh.Modify;
                    //Item.GET(SalesLineToRefresh."No.");
                    //SalesLineToRefresh.UpdateUnitPrice(SalesLineToRefresh.FIELDNO("Unit Cost (LCY)"));
                    if InventorySetup."Updt. Markup Pr. on Refr. Cost" <> InventorySetup."updt. markup pr. on refr. cost"::"No update" then begin
                        SalesPriceCalcMgt.GetSalesLinePriceList(SalesHeader, SalesLineToRefresh, TempSalesPriceList);
                        TempSalesPriceList.Reset;
                        TempSalesPriceList.SetRange("Sales Type", TempSalesPriceList."sales type"::Markup);
                        TempSalesPriceList.SetRange("Currency Code", SalesLineToRefresh."Currency Code");
                        TempSalesPriceList.SetCurrentkey("Unit Price");
                        if TempSalesPriceList.IsEmpty = false then begin
                            TempSalesPriceList.FindFirst;
                            SalesLineToRefresh.UpdateUnitPrice(SalesLineToRefresh.FieldNo("Unit Cost (LCY)"));
                            SalesLineToRefresh.Modify;
                            if (InventorySetup."Updt. Markup Pr. on Refr. Cost" = InventorySetup."updt. markup pr. on refr. cost"::"Update and Show") and GuiAllowed then
                                Message(UpdatePriceMsg, SalesLineToRefresh."No.", PrevPrice, SalesLineToRefresh."Unit Price");
                        end;
                    end;
                end;
            until SalesLineToRefresh.Next = 0;

    end;
}

