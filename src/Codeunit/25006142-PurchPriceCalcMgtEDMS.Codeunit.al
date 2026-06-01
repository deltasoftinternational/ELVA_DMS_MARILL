codeunit 25006142 "Purch. Price Calc. Mgt. EDMS"
{



    procedure NonstockPurchPriceToItem(var recNonstockPurchPrice: Record "Nonstock Purchase Price"; var xrecNonstockPurchPrice: Record "Nonstock Purchase Price"; intActivity: Integer)
    var
        recItem: Record Item;
        recNonstockItem: Record "Nonstock Item";
        recPurchPrice: Record "Price List Line";
        PriceListHeader: Record "Price List Header";
        Vendor: Record Vendor;
        LineNo: Integer;
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */
        if not recNonstockItem.Get(recNonstockPurchPrice."Nonstock Item Entry No.") then
            exit;
        if recNonstockItem."Item No." = '' then
            exit;
        if not recItem.Get(recNonstockItem."Item No.") then
            exit;

        Vendor.get(recNonstockPurchPrice."Vendor No.");
        IF not PriceListHeader.get(Vendor."Non Stock Item Price List Code") then
            Error(Error001);
        recPurchPrice.Setrange("Price List Code", PriceListHeader.Code);
        IF recPurchPrice.FindLast() then
            LineNo := recPurchPrice."Line No." + 1000
        else
            LineNo := 1000;

        case intActivity of
            0: //Insert
                begin

                    recPurchPrice.Init;
                    recPurchPrice."Price List Code" := PriceListHeader.Code;
                    recPurchPrice."Line No." := LineNo;
                    recPurchPrice."Source Type" := recPurchPrice."Source Type"::Vendor;
                    recPurchPrice."Source No." := recNonstockPurchPrice."Vendor No.";
                    recPurchPrice."Asset Type" := recPurchPrice."Asset Type"::Item;
                    recPurchPrice."Asset No." := recItem."No.";
                    recPurchPrice."Starting Date" := recNonstockPurchPrice."Starting Date";
                    recPurchPrice."Currency Code" := recNonstockPurchPrice."Currency Code";
                    recPurchPrice."Unit of Measure Code" := recNonstockPurchPrice."Unit of Measure Code";
                    recPurchPrice."Minimum Quantity" := recNonstockPurchPrice."Minimum Quantity";
                    recPurchPrice."Direct Unit Cost" := recNonstockPurchPrice."Direct Unit Cost";
                    recPurchPrice."Ending Date" := recNonstockPurchPrice."Ending Date";
                    recPurchPrice."Ordering Price Type Code" := recNonstockPurchPrice."Ordering Price Type Code";
                    recPurchPrice.Insert;
                    recNonstockPurchPrice."Price List Code" := recPurchPrice."Price List Code";
                    recNonstockPurchPrice."Price List Line No." := recPurchPrice."Line No.";


                end;
            1, 2: //modify,rename
                begin

                    recPurchPrice.Reset;
                    recPurchPrice.SetRange("Price List Code", recNonstockPurchPrice."Price List Code");
                    recPurchPrice.SetRange("Line No.", recNonstockPurchPrice."Price List Line No.");
                    if recPurchPrice.FindFirst then
                        recPurchPrice.Delete;


                    PriceListHeader.get(recNonstockPurchPrice."Price List Code");
                    recPurchPrice.Init;
                    recPurchPrice."Price List Code" := recNonstockPurchPrice."Price List Code";
                    recPurchPrice."Line No." := recNonstockPurchPrice."Price List Line No.";
                    recPurchPrice."Source Type" := recPurchPrice."Source Type"::Vendor;
                    recPurchPrice."Source No." := recNonstockPurchPrice."Vendor No.";
                    recPurchPrice."Asset Type" := recPurchPrice."Asset Type"::Item;
                    recPurchPrice.Validate("Asset No.", recItem."No.");
                    recPurchPrice."Starting Date" := recNonstockPurchPrice."Starting Date";
                    recPurchPrice."Currency Code" := recNonstockPurchPrice."Currency Code";
                    recPurchPrice."Unit of Measure Code" := recNonstockPurchPrice."Unit of Measure Code";
                    recPurchPrice."Minimum Quantity" := recNonstockPurchPrice."Minimum Quantity";
                    recPurchPrice."Direct Unit Cost" := recNonstockPurchPrice."Direct Unit Cost";
                    recPurchPrice."Ending Date" := recNonstockPurchPrice."Ending Date";
                    recPurchPrice."Ordering Price Type Code" := recNonstockPurchPrice."Ordering Price Type Code";
                    recPurchPrice.Insert;
                    recNonstockPurchPrice."Price List Code" := recPurchPrice."Price List Code";
                    recNonstockPurchPrice."Price List Line No." := recPurchPrice."Line No.";




                end;
            3:  //delete
                begin
                    PriceListHeader.get(recNonstockPurchPrice."Price List Code");
                    recPurchPrice.Reset;
                    recPurchPrice.SetRange("Price List Code", recNonstockPurchPrice."Price List Code");
                    recPurchPrice.SetRange("Line No.", recNonstockPurchPrice."Price List Line No.");
                    if recPurchPrice.FindFirst then
                        recPurchPrice.Delete;
                end;
        end;

        PriceListManagement.ActivateDraftLines(PriceListHeader);

    end;

    //DELTA SALES PRICE A corriger
    //
    procedure ItemPurchPriceToNonstock(var recPurchPrice: Record "Price List Line"; var xrecPurchPrice: Record "Price List Line"; intActivity: Integer)
    var
        recItem: Record Item;
        recNonstockItem: Record "Nonstock Item";
        recNonstockPurchPrice: Record "Nonstock Purchase Price";
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */
        IF recPurchPrice."Price Type" <> recPurchPrice."Price Type"::Purchase then
            exit;

        if not recItem.Get(recPurchPrice."asset No.") then
            exit;
        if not recItem."Created From Nonstock Item" then
            exit;

        recNonstockItem.Reset;
        recNonstockItem.SetCurrentkey("Item No.");
        recNonstockItem.SetRange("Item No.", recItem."No.");
        if not recNonstockItem.FindFirst then                                    // 07.08.2015 EB.P30 #T0047
            exit;

        case intActivity of
            0: //Insert
                begin

                    recNonstockPurchPrice.Init;
                    recNonstockPurchPrice."Nonstock Item Entry No." := recNonstockItem."Entry No.";
                    recNonstockPurchPrice."Vendor No." := recPurchPrice."Source No.";
                    recNonstockPurchPrice."Starting Date" := recPurchPrice."Starting Date";
                    recNonstockPurchPrice."Currency Code" := recPurchPrice."Currency Code";
                    recNonstockPurchPrice."Unit of Measure Code" := recPurchPrice."Unit of Measure Code";
                    recNonstockPurchPrice."Minimum Quantity" := recPurchPrice."Minimum Quantity";
                    recNonstockPurchPrice."Direct Unit Cost" := recPurchPrice."Direct Unit Cost";
                    recNonstockPurchPrice."Ending Date" := recPurchPrice."Ending Date";
                    recNonstockPurchPrice."Ordering Price Type Code" := recPurchPrice."Ordering Price Type Code";
                    recNonstockPurchPrice."Price List Code" := recPurchPrice."Price List Code";
                    recNonstockPurchPrice."Price List Line No." := recPurchPrice."Line No.";
                    recNonstockPurchPrice.Insert;

                end;
            1, 2: //modify,rename
                begin

                    recNonstockPurchPrice.Reset;
                    recNonstockPurchPrice.setrange("Price List Code", recPurchPrice."Price List Code");
                    recNonstockPurchPrice.setrange("Price List Line No.", recPurchPrice."Line No.");
                    if recNonstockPurchPrice.FindFirst then
                        recNonstockPurchPrice.Delete;




                    recNonstockPurchPrice.Init;
                    recNonstockPurchPrice."Nonstock Item Entry No." := recNonstockItem."Entry No.";
                    recNonstockPurchPrice."Vendor No." := recPurchPrice."Source No.";
                    recNonstockPurchPrice."Starting Date" := recPurchPrice."Starting Date";
                    recNonstockPurchPrice."Currency Code" := recPurchPrice."Currency Code";
                    recNonstockPurchPrice."Unit of Measure Code" := recPurchPrice."Unit of Measure Code";
                    recNonstockPurchPrice."Minimum Quantity" := recPurchPrice."Minimum Quantity";
                    recNonstockPurchPrice."Direct Unit Cost" := recPurchPrice."Direct Unit Cost";
                    recNonstockPurchPrice."Ending Date" := recPurchPrice."Ending Date";
                    recNonstockPurchPrice."Ordering Price Type Code" := recPurchPrice."Ordering Price Type Code";
                    recNonstockPurchPrice."Price List Code" := recPurchPrice."Price List Code";
                    recNonstockPurchPrice."Price List Line No." := recPurchPrice."Line No.";
                    recNonstockPurchPrice.Insert;
                end;
            3:  //delete
                begin


                    recNonstockPurchPrice.Reset;
                    recNonstockPurchPrice.setrange("Price List Code", recPurchPrice."Price List Code");
                    recNonstockPurchPrice.setrange("Price List Line No.", recPurchPrice."Line No.");
                    if recNonstockPurchPrice.FindFirst then
                        recNonstockPurchPrice.Delete;


                end;
        end;

    end;

    procedure ItemPurLineDiscToNonstock(var recPurchLineDisc: Record "Price List Line"; var xrecPurchLineDisc: Record "Price List Line"; intActivity: Integer)
    var
        recItem: Record Item;
        recNonstockItem: Record "Nonstock Item";
        recNonstockPurchLineDisc: Record "Nonstock Purchase Line Disc";
        PriceListHeader: Record "Price List Header";
        Vendor: Record Vendor;
        LineNo: Integer;
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */

        if not recItem.Get(recPurchLineDisc."asset No.") then
            exit;
        if not recItem."Created From Nonstock Item" then
            exit;

        recNonstockItem.Reset;
        recNonstockItem.SetCurrentkey("Item No.");
        recNonstockItem.SetRange("Item No.", recItem."No.");

        if not recNonstockItem.FindFirst then                                                 // 07.08.2015 EB.P30 #T0047
            exit;

        case intActivity of
            0: //Insert
                begin
                    recNonstockPurchLineDisc.Init;
                    recNonstockPurchLineDisc."Nonstock Item Entry No." := recNonstockItem."Entry No.";
                    recNonstockPurchLineDisc."Vendor No." := recPurchLineDisc."Source No.";
                    recNonstockPurchLineDisc."Starting Date" := recPurchLineDisc."Starting Date";
                    recNonstockPurchLineDisc."Currency Code" := recPurchLineDisc."Currency Code";
                    recNonstockPurchLineDisc."Unit of Measure Code" := recPurchLineDisc."Unit of Measure Code";
                    recNonstockPurchLineDisc."Minimum Quantity" := recPurchLineDisc."Minimum Quantity";
                    recNonstockPurchLineDisc."Line Discount %" := recPurchLineDisc."Line Discount %";
                    recNonstockPurchLineDisc."Ending Date" := recPurchLineDisc."Ending Date";
                    //recNonstockPurchLineDisc."Item Discount Group Code" := recPurchLineDisc."Item Discount Group Code";
                    recNonstockPurchLineDisc."Ordering Price Type Code" := recPurchLineDisc."Ordering Price Type Code";
                    recNonstockPurchLineDisc."Price List Code" := recPurchLineDisc."Price List Code";
                    recNonstockPurchLineDisc."Price List Line No." := recPurchLineDisc."Line No.";
                    recNonstockPurchLineDisc.Insert;
                end;
            1, 2: //modify,rename
                begin
                    recNonstockPurchLineDisc.Reset;
                    recNonstockPurchLineDisc.setrange("Price List Code", recPurchLineDisc."Price List Code");
                    recNonstockPurchLineDisc.setrange("Price List Line No.", recPurchLineDisc."Line No.");
                    if recNonstockPurchLineDisc.FindFirst then
                        recNonstockPurchLineDisc.Delete;




                    recNonstockPurchLineDisc.Init;
                    recNonstockPurchLineDisc."Nonstock Item Entry No." := recNonstockItem."Entry No.";
                    recNonstockPurchLineDisc."Vendor No." := recPurchLineDisc."Source No.";
                    recNonstockPurchLineDisc."Starting Date" := recPurchLineDisc."Starting Date";
                    recNonstockPurchLineDisc."Currency Code" := recPurchLineDisc."Currency Code";
                    recNonstockPurchLineDisc."Unit of Measure Code" := recPurchLineDisc."Unit of Measure Code";
                    recNonstockPurchLineDisc."Minimum Quantity" := recPurchLineDisc."Minimum Quantity";
                    recNonstockPurchLineDisc."Line Discount %" := recPurchLineDisc."Line Discount %";
                    recNonstockPurchLineDisc."Ending Date" := recPurchLineDisc."Ending Date";
                    //recNonstockPurchLineDisc."Item Discount Group Code" := recPurchLineDisc."Item Discount Group Code";
                    recNonstockPurchLineDisc."Ordering Price Type Code" := recPurchLineDisc."Ordering Price Type Code";
                    recNonstockPurchLineDisc."Price List Code" := recPurchLineDisc."Price List Code";
                    recNonstockPurchLineDisc."Price List Line No." := recPurchLineDisc."Line No.";
                    recNonstockPurchLineDisc.Insert;

                end;
            3:  //delete
                begin
                    recNonstockPurchLineDisc.Reset;
                    recNonstockPurchLineDisc.setrange("Price List Code", recPurchLineDisc."Price List Code");
                    recNonstockPurchLineDisc.setrange("Price List Line No.", recPurchLineDisc."Line No.");
                    if recNonstockPurchLineDisc.FindFirst then
                        recNonstockPurchLineDisc.Delete;

                end;
        end;

    end;


    procedure NonstockPurchLineDiscToItem(var recNonstockPurchLineDisc: Record "Nonstock Purchase Line Disc"; var xrecNonstockPurchLineDisc: Record "Nonstock Purchase Line Disc"; intActivity: Integer)
    var
        recItem: Record Item;
        recNonstockItem: Record "Nonstock Item";
        recPurchLineDisc: Record "Price List Line";
        PriceListHeader: Record "Price List Header";
        Vendor: Record Vendor;
        LineNo: Integer;
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */

        if not recNonstockItem.Get(recNonstockPurchLineDisc."Nonstock Item Entry No.") then
            exit;
        if recNonstockItem."Item No." = '' then
            exit;
        if not recItem.Get(recNonstockItem."Item No.") then
            exit;
        IF not PriceListHeader.get(Vendor."Non Stock Item Price List Code") then
            Error(Error001);

        recPurchLineDisc.Setrange("Price List Code", PriceListHeader.Code);
        IF recPurchLineDisc.FindLast() then
            LineNo := recPurchLineDisc."Line No." + 1000
        else
            LineNo := 1000;


        case intActivity of
            0: //Insert
                begin
                    recPurchLineDisc.Init;
                    recPurchLineDisc."Price List Code" := PriceListHeader.Code;
                    recPurchLineDisc."Line No." := LineNo;
                    recPurchLineDisc."Source Type" := recPurchLineDisc."Source Type"::Vendor;
                    recPurchLineDisc."Source No." := recNonstockPurchLineDisc."Vendor No.";
                    recPurchLineDisc."Asset Type" := recPurchLineDisc."Asset Type"::Item;
                    recPurchLineDisc.Validate("Asset No.", recItem."No.");
                    recPurchLineDisc."Starting Date" := recNonstockPurchLineDisc."Starting Date";
                    recPurchLineDisc."Currency Code" := recNonstockPurchLineDisc."Currency Code";
                    recPurchLineDisc."Unit of Measure Code" := recNonstockPurchLineDisc."Unit of Measure Code";
                    recPurchLineDisc."Minimum Quantity" := recNonstockPurchLineDisc."Minimum Quantity";
                    recPurchLineDisc."Line Discount %" := recNonstockPurchLineDisc."Line Discount %";
                    recPurchLineDisc."Ending Date" := recNonstockPurchLineDisc."Ending Date";
                    // recPurchLineDisc."Item Discount Group Code" := recNonstockPurchLineDisc."Item Discount Group Code";
                    recPurchLineDisc."Ordering Price Type Code" := recNonstockPurchLineDisc."Ordering Price Type Code";
                    recPurchLineDisc.Insert;
                    recNonstockPurchLineDisc."Price List Code" := recPurchLineDisc."Price List Code";
                    recNonstockPurchLineDisc."Price List Line No." := recPurchLineDisc."Line No.";

                end;
            1, 2: //modify,rename
                begin
                    PriceListHeader.get(recNonstockPurchLineDisc."Price List Code");
                    recPurchLineDisc.Reset;
                    recPurchLineDisc.SetRange("Price List Code", recNonstockPurchLineDisc."Price List Code");
                    recPurchLineDisc.SetRange("Line No.", recNonstockPurchLineDisc."Price List Line No.");
                    if recPurchLineDisc.FindFirst then
                        recPurchLineDisc.Delete;


                    recPurchLineDisc.Init;
                    recPurchLineDisc."Price List Code" := recNonstockPurchLineDisc."Price List Code";
                    recPurchLineDisc."Line No." := recNonstockPurchLineDisc."Price List Line No.";
                    recPurchLineDisc."Source Type" := recPurchLineDisc."Source Type"::Vendor;
                    recPurchLineDisc."Source No." := recNonstockPurchLineDisc."Vendor No.";
                    recPurchLineDisc."Asset Type" := recPurchLineDisc."Asset Type"::Item;
                    recPurchLineDisc."Asset No." := recItem."No.";
                    recPurchLineDisc."Starting Date" := recNonstockPurchLineDisc."Starting Date";
                    recPurchLineDisc."Currency Code" := recNonstockPurchLineDisc."Currency Code";
                    recPurchLineDisc."Unit of Measure Code" := recNonstockPurchLineDisc."Unit of Measure Code";
                    recPurchLineDisc."Minimum Quantity" := recNonstockPurchLineDisc."Minimum Quantity";
                    recPurchLineDisc."Line Discount %" := recNonstockPurchLineDisc."Line Discount %";
                    recPurchLineDisc."Ending Date" := recNonstockPurchLineDisc."Ending Date";
                    // recPurchLineDisc."Item Discount Group Code" := recNonstockPurchLineDisc."Item Discount Group Code";
                    recPurchLineDisc."Ordering Price Type Code" := recNonstockPurchLineDisc."Ordering Price Type Code";
                    recPurchLineDisc.Insert;
                    recNonstockPurchLineDisc."Price List Code" := recPurchLineDisc."Price List Code";
                    recNonstockPurchLineDisc."Price List Line No." := recPurchLineDisc."Line No.";



                end;
            3:  //delete
                begin
                    PriceListHeader.get(recNonstockPurchLineDisc."Price List Code");
                    recPurchLineDisc.Reset;
                    recPurchLineDisc.SetRange("Price List Code", recNonstockPurchLineDisc."Price List Code");
                    recPurchLineDisc.SetRange("Line No.", recNonstockPurchLineDisc."Price List Line No.");
                    if recPurchLineDisc.FindFirst then
                        recPurchLineDisc.Delete;

                end;
        end;
        PriceListManagement.ActivateDraftLines(PriceListHeader);

    end;

    procedure FindVehDisc(var ToPurchaseLineDisc: Record "Purchase Line Discount"; ItemNo: Code[20]; ItemDiscGrCode: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; AssemblyID: Code[20]; VehSerialNo: Code[20])
    var
        codNo: Code[20];
        intType: Integer;
        recItem: Record Item;
        decDiscountPercent: Decimal;
        recSalesLine: Record "Purchase Line";
        recVehAssembly: Record "Vehicle Assembly Line";
        VehPriceCalcMgt: Codeunit VehicleSalesPriceDiscountMgt;
    begin
        ToPurchaseLineDisc.Reset;
        ToPurchaseLineDisc.DeleteAll;

        if (AssemblyID <> '') and (VehSerialNo <> '') then
            VehPriceCalcMgt.FindVehiclePurchaseDiscountAW(ToPurchaseLineDisc, VehSerialNo,
              AssemblyID, ItemNo)
        else
            VehPriceCalcMgt.FindVehiclePurchaseDiscount(
              ToPurchaseLineDisc, ItemNo, ItemDiscGrCode,
              CurrencyCode, StartingDate, ShowAll)
    end;


    procedure FindVehPrice(var ToPurchasePrice: Record "Purchase Price"; ItemNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; LocationCode: Code[10]; OrderingPriceType: Code[10]; VehSerialNo: Code[20]; AssemblyID: Code[20])
    var
        VehPriceCalcMgt: Codeunit VehicleSalesPriceDiscountMgt;
    begin
        if (AssemblyID <> '') and (VehSerialNo <> '') then
            VehPriceCalcMgt.FindVehiclePurchasePriceAW(ToPurchasePrice, VehSerialNo,
              AssemblyID, ItemNo)
        else
            VehPriceCalcMgt.FindVehiclePurchasePrice(
              ToPurchasePrice, ItemNo,
              CurrencyCode, StartingDate, ShowAll,
              OrderingPriceType)
    end;

    var
        Error001: Label 'Please create and Assign to the vendor %1 a non StockPrice document';
        PriceListManagement: Codeunit "Price List Management";


}
