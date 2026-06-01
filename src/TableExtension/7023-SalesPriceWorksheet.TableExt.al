tableextension 25006030 "Sales Price Worksheet" extends "Sales Price Worksheet" //7023'
{
    // 07.04.2022 EB.KN 
    //   Added functions
    //      "CalcNewPriceFromMRSP"
    //      "CalcNewPriceFromPurchasePrice"
    //
    // 21.08.2015 EB.P30 #T0053
    //   Modified function CalcNewPrice
    // 
    // 19.08.2015 EB.P30 #T049
    //   Modified Trigger OnValidate for fields:
    //     "New Unit Price"
    //     "Unit Profit % (New)"
    // 
    // 21.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Changed LVI caption for field "Current Unit Price"
    //   * Added functions
    //     CalcProfit, CalcSalesPrice, CalcProfitPercent
    // 
    // 14.04.2014 Elva Baltic P7 #x MMG7.00
    //   * New fields added
    // 
    // 17.02.2009 EDMS P1
    //   *Extension to Nonstock Items
    //   *New field - Type
    //   *Field Item No. renamed to No. and made dependant on type
    //   *Extended primary key
    //   *Modified function CalcCurrentPrice
    fields
    {
        modify("Item No.")
        {
            TableRelation = if (Type = const(Item)) Item
            else
            if (Type = const("Nonstock Item")) "Nonstock Item";

            trigger OnAfterValidate()
            begin
                if rec.Type = rec.Type::"Nonstock Item" then
                    CalcCurrentPriceNonStock(PriceAlreadyExists);
            end;

        }
        modify("Sales Code")
        {
            trigger OnAfterValidate()
            begin
                if rec.Type = rec.Type::"Nonstock Item" then
                    CalcCurrentPriceNonStock(PriceAlreadyExists);
                if ("Sales Code" = '') and ("Sales Type" <> "Sales Type"::"All Customers") then
                    exit;

                if not PriceAlreadyExists and ("Sales Code" <> '') then
                    case "Sales Type" of
                        "Sales Type"::"Customer Price Group":
                            begin
                                CustPriceGr.Get("Sales Code");
                                "Price Includes VAT" := CustPriceGr."Price Includes VAT";
                                "VAT Bus. Posting Gr. (Price)" := CustPriceGr."VAT Bus. Posting Gr. (Price)";
                                "Allow Line Disc." := CustPriceGr."Allow Line Disc.";
                                "Allow Invoice Disc." := CustPriceGr."Allow Invoice Disc.";
                            end;
                        "Sales Type"::Customer:
                            begin
                                Cust.Get("Sales Code");
                                "Currency Code" := Cust."Currency Code";
                                "Price Includes VAT" := Cust."Prices Including VAT";
                                "Allow Line Disc." := Cust."Allow Line Disc.";
                            end;
                        "Sales Type"::Campaign:
                            begin
                                Campaign.Get("Sales Code");
                                "Starting Date" := Campaign."Starting Date";
                                "Ending Date" := Campaign."Ending Date";
                            end;
                    end;
            end;
        }
        modify("Currency Code")
        {
            trigger OnAfterValidate()
            begin
                if rec.Type = rec.Type::"Nonstock Item" then
                    CalcCurrentPriceNonStock(PriceAlreadyExists);
            end;
        }

        modify("Starting Date")
        {
            trigger OnAfterValidate()
            begin
                if rec.Type = rec.Type::"Nonstock Item" then
                    CalcCurrentPriceNonStock(PriceAlreadyExists);
            end;
        }
        modify("Minimum Quantity")
        {
            trigger OnAfterValidate()
            begin
                if rec.Type = rec.Type::"Nonstock Item" then
                    CalcCurrentPriceNonStock(PriceAlreadyExists);
            end;
        }

        modify("Variant Code")
        {
            trigger OnAfterValidate()
            begin
                if rec.Type = rec.Type::"Nonstock Item" then
                    CalcCurrentPriceNonStock(PriceAlreadyExists);
            end;
        }

        modify("New Unit Price")
        {
            trigger onaftervalidate()
            begin
                // 19.08.2015 EB.P30 #T049 >>
                CalcProfit;
                // 19.08.2015 EB.P30 #T049 <<
            end;
        }
        modify("Unit of Measure Code")
        {
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("Item No."))
            else
            if (Type = const("Nonstock Item")) "Unit of Measure";
            trigger OnAfterValidate()
            begin
                if rec.Type = rec.Type::"Nonstock Item" then
                    CalcCurrentPriceNonStock(PriceAlreadyExists);
            end;
        }
        field(25006000; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item,Nonstock Item';
            OptionMembers = Item,"Nonstock Item";
        }
        field(25006010; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(25006020; "Unit Profit (Current)"; Decimal)
        {
            Caption = 'Unit Profit (Current)';
        }
        field(25006030; "Unit Profit % (Current)"; Decimal)
        {
            Caption = 'Unit Profit % (Current)';
        }
        field(25006040; "Unit Profit (New)"; Decimal)
        {
            Caption = 'Unit Profit (New)';

            trigger OnValidate()
            begin
                //21.04.2014 Elva Baltic P1 #RX MMG7.00
                CalcSalesPrice;
                CalcProfit
                //21.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            end;
        }
        field(25006050; "Unit Profit % (New)"; Decimal)
        {
            Caption = 'Unit Profit % (New)';

            trigger OnValidate()
            begin
                //21.04.2014 Elva Baltic P1 #RX MMG7.00
                Validate("New Unit Price", ROUND("Unit Cost" / (1 - "Unit Profit % (New)" / 100), 0.1));
                CalcProfit; // 19.08.2015 EB.P30 #T049
                //21.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            end;
        }
        field(25006679; "Market Recomended Sales Price"; Decimal)
        {
            Caption = 'Market Recomended Sales Price';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(25006680; "MRSP Currency Code"; Code[10])
        {
            AutoFormatType = 1;
            Caption = 'Market Recomended Sales Price Currency Code';
            TableRelation = Currency;
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006770; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
    }

    keys
    {
        /* A verifier 
         key(Key3; "Starting Date", "Ending Date", "Sales Type", "Sales Code", "Currency Code", Type, "Item No.", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code", "Location Code")
        {
            //Clustered = true;
        }
        key(Key4; Type, "Item No.", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Starting Date", "Ending Date", "Sales Type", "Sales Code", "Currency Code")
        {
        }
        */
        key(Key3; Type, "Ordering Price Type Code", "Location Code")
        {
        }

    }

    procedure CalcNewPrice()
    var
        SalesPriceFactor: Record "Item Price Group Setup";
        ItemPriceGroup: Code[10];
        Factor: Decimal;
    begin
        if "Unit Cost" = 0 then
            exit;

        case Type of
            Type::Item:
                if Item.Get("Item No.") then begin
                    ItemPriceGroup := Item."Item Price Group Code";
                end;
            Type::"Nonstock Item":
                if NonstockItem.Get("Item No.") then begin
                    ItemPriceGroup := NonstockItem."Item Price Group Code";
                end;
        end;

        Factor := 0;
        SalesPriceFactor.Reset;
        SalesPriceFactor.SetFilter("Item Price Group Code", '%1|%2', '', ItemPriceGroup);
        SalesPriceFactor.SetRange("Sales Type", "Sales Type");
        SalesPriceFactor.SetFilter("Sales Code", '%1|%2', '', "Sales Code");
        SalesPriceFactor.SetFilter("Cost From", '<=%1', "Unit Cost");
        SalesPriceFactor.SetFilter("Cost To", '>=%1', "Unit Cost");
        if SalesPriceFactor.FindFirst then
            repeat
                if SalesPriceFactor."Sales Price Factor" > Factor then
                    Factor := SalesPriceFactor."Sales Price Factor";
            until SalesPriceFactor.Next = 0;

        if Factor <> 0 then
            Validate("New Unit Price", "Unit Cost" * Factor);                                      // 21.08.2015 EB.P30 #T0053
    end;

    procedure CalcNewPriceFromMRSP()
    var
        SalesPriceFactor: Record "Item Price Group Setup";
        ItemPriceGroup: Code[10];
        Factor: Decimal;
        MRSP: Decimal;
        MRSPcurrency: Code[10];
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        case Type of
            Type::Item:
                if Item.Get("Item No.") then begin
                    if Item."Market Recomended Sales Price" = 0 then
                        exit;
                    ItemPriceGroup := Item."Item Price Group Code";
                    MRSP := Item."Market Recomended Sales Price";
                    MRSPcurrency := Item."MRSP Currency Code";
                end;
            Type::"Nonstock Item":
                if NonstockItem.Get("Item No.") then begin
                    if NonstockItem."Market Recomended Sales Price" = 0 then
                        exit;
                    ItemPriceGroup := NonstockItem."Item Price Group Code";
                    MRSP := NonstockItem."Market Recomended Sales Price";
                    MRSPcurrency := NonstockItem."MRSP Currency Code";
                end;
        end;

        Factor := 0;
        SalesPriceFactor.Reset;
        SalesPriceFactor.SetFilter("Item Price Group Code", '%1|%2', '', ItemPriceGroup);
        SalesPriceFactor.SetRange("Sales Type", "Sales Type");
        SalesPriceFactor.SetFilter("Sales Code", '%1|%2', '', "Sales Code");
        SalesPriceFactor.SetFilter("Cost From", '<=%1|%2', "Unit Cost", 0);
        SalesPriceFactor.SetFilter("Cost To", '>=%1|%2', "Unit Cost", 0);
        if SalesPriceFactor.FindFirst then
            repeat
                if SalesPriceFactor."Sales Price Factor" > Factor then
                    Factor := SalesPriceFactor."Sales Price Factor";
            until SalesPriceFactor.Next = 0;

        if Factor <> 0 then begin
            if MRSPcurrency = "Currency Code" then begin
                Validate("New Unit Price", MRSP * Factor);
            end else begin
                If (MRSPcurrency = '') and ("Currency Code" <> '') then
                    Validate("New Unit Price", CurrencyExchangeRate.ExchangeAmtLCYToFCY("Starting Date", "Currency Code", MRSP * Factor, CurrencyExchangeRate.ExchangeRate("Starting Date", "Currency Code")));
                If (MRSPcurrency <> '') and ("Currency Code" = '') then
                    Validate("New Unit Price", CurrencyExchangeRate.ExchangeAmtFCYToLCY("Starting Date", MRSPcurrency, MRSP * Factor, CurrencyExchangeRate.ExchangeRate("Starting Date", MRSPcurrency)));
                If (MRSPcurrency <> '') and ("Currency Code" <> '') then
                    Validate("New Unit Price", CurrencyExchangeRate.ExchangeAmount(MRSP * Factor, MRSPcurrency, "Currency Code", "Starting Date"));
            end;
            "Market Recomended Sales Price" := MRSP;
            "MRSP Currency Code" := MRSPcurrency;
        end;
    end;

    procedure CalcNewPriceFromPurchasePrice()
    var
        SalesPriceFactor: Record "Item Price Group Setup";
        ItemPriceGroup: Code[10];
        Factor: Decimal;
        UnitCost: Decimal;
        NonstockPurchasePrice: Record "Nonstock Purchase Price";
        ItemPurchasePrice: Record "Purchase Price";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        UnitCost := 0;

        case Type of
            Type::Item:
                if Item.Get("Item No.") then begin
                    ItemPriceGroup := Item."Item Price Group Code";
                    ItemPurchasePrice.Reset();
                    ItemPurchasePrice.SetRange("Item No.", "Item No.");
                    ItemPurchasePrice.SetFilter("Starting Date", '<=%1', "Starting Date");
                    If ItemPurchasePrice.FindLast then begin
                        If ItemPurchasePrice."Currency Code" <> '' then
                            UnitCost := CurrencyExchangeRate.ExchangeAmtFCYToLCY("Starting Date", ItemPurchasePrice."Currency Code", ItemPurchasePrice."Direct Unit Cost", CurrencyExchangeRate.ExchangeRate("Starting Date", ItemPurchasePrice."Currency Code"))
                        else
                            UnitCost := ItemPurchasePrice."Direct Unit Cost";
                    end;
                end;
            Type::"Nonstock Item":
                if NonstockItem.Get("Item No.") then begin
                    ItemPriceGroup := NonstockItem."Item Price Group Code";
                    NonstockPurchasePrice.Reset();
                    NonstockPurchasePrice.SetRange("Nonstock Item Entry No.", "Item No.");
                    NonstockPurchasePrice.SetFilter("Starting Date", '<=%1', "Starting Date");
                    If NonstockPurchasePrice.FindLast then begin
                        If NonstockPurchasePrice."Currency Code" <> '' then
                            UnitCost := CurrencyExchangeRate.ExchangeAmtFCYToLCY("Starting Date", NonstockPurchasePrice."Currency Code", NonstockPurchasePrice."Direct Unit Cost", CurrencyExchangeRate.ExchangeRate("Starting Date", NonstockPurchasePrice."Currency Code"))
                        else
                            UnitCost := NonstockPurchasePrice."Direct Unit Cost";
                    end;
                end;
        end;

        If UnitCost = 0 then
            exit;

        "Unit Cost" := UnitCost;

        Factor := 0;
        SalesPriceFactor.Reset;
        SalesPriceFactor.SetFilter("Item Price Group Code", '%1|%2', '', ItemPriceGroup);
        SalesPriceFactor.SetRange("Sales Type", "Sales Type");
        SalesPriceFactor.SetFilter("Sales Code", '%1|%2', '', "Sales Code");
        SalesPriceFactor.SetFilter("Cost From", '<=%1', UnitCost);
        SalesPriceFactor.SetFilter("Cost To", '>=%1', UnitCost);
        if SalesPriceFactor.FindFirst then
            repeat
                if SalesPriceFactor."Sales Price Factor" > Factor then
                    Factor := SalesPriceFactor."Sales Price Factor";
            until SalesPriceFactor.Next = 0;

        if Factor <> 0 then
            Validate("New Unit Price", UnitCost * Factor);                                      // 21.08.2015 EB.P30 #T0053
    end;


    procedure CalcProfit()
    begin
        "Unit Profit (New)" := "New Unit Price" - "Unit Cost";
        CalcProfitPercent;
    end;


    procedure CalcSalesPrice()
    begin
        "New Unit Price" := "Unit Cost" + "Unit Profit (New)";
    end;

    procedure CalcProfitPercent()
    begin
        if "New Unit Price" <> 0 then
            "Unit Profit % (New)" := ROUND("Unit Profit (New)" / "New Unit Price" * 100, 0.1)
        else
            "Unit Profit % (New)" := 0;
    end;


    //>>Added for table "Sales Price Worksheet" function CalcCurrentPrice /17.02.2009 EDMS P1 
    procedure CalcCurrentPriceNonStock(var PriceAlreadyExists: Boolean)
    var
        NonstockSalesPrice: Record "Nonstock Item Price";
    begin
        if rec."Type" = rec."Type"::Item then begin
            NonstockSalesPrice.SetRange("Nonstock Item Entry No.", "Item No.");
            NonstockSalesPrice.SetRange("Sales Type", "Sales Type");
            NonstockSalesPrice.SetRange("Sales Code", "Sales Code");
            NonstockSalesPrice.SetRange("Currency Code", "Currency Code");
            NonstockSalesPrice.SetRange("Unit of Measure Code", "Unit of Measure Code");
            NonstockSalesPrice.SetRange("Starting Date", 0D, "Starting Date");
            NonstockSalesPrice.SetRange("Minimum Quantity", 0, "Minimum Quantity");
            NonstockSalesPrice.SetRange("Ordering Price Type Code", "Ordering Price Type Code");
            NonstockSalesPrice.SetRange("Location Code", "Location Code");
            if NonstockSalesPrice.Find('+') then begin
                "Current Unit Price" := NonstockSalesPrice."Unit Price";
                "Price Includes VAT" := NonstockSalesPrice."Price Includes VAT";
                "Allow Line Disc." := NonstockSalesPrice."Allow Line Disc.";
                "Allow Invoice Disc." := NonstockSalesPrice."Allow Invoice Disc.";
                "VAT Bus. Posting Gr. (Price)" := NonstockSalesPrice."VAT Bus. Posting Gr. (Price)";
                PriceAlreadyExists := NonstockSalesPrice."Starting Date" = "Starting Date";
            end else begin
                "Current Unit Price" := 0;
                PriceAlreadyExists := false;
            end;
        end;
    end;

    var
        NonstockItem: Record "Nonstock Item";
        PriceAlreadyExists: Boolean;
        CustPriceGr: Record "Customer Price Group";
        Cust: Record Customer;
        Campaign: Record Campaign;




}