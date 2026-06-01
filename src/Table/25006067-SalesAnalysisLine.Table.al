Table 25006067 "Sales Analysis Line"
{

    fields
    {
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Service Quote,Service Order';
            OptionMembers = Quote,"Order","Service Quote","Service Order";
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(35; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service,Resource';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service",Resource;

            trigger OnValidate()
            var
                ServiceHeader: Record "Service Header EDMS";
                recMarkup: Record "Sales/Serv. Item Markup";
                recItemDisc: Record "Sales Line Discount";
                recLabTransl: Record "Service Labor Translation";
                recItemTransl: Record "Item Translation";
            begin
            end;
        }
        field(40; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(Labor)) "Service Labor"
            else
            if (Type = const("External Service")) "External Service"
            else
            if (Type = const(Resource)) Resource;

            trigger OnValidate()
            begin
                GetPurchasePrice;
                if Type = Type::Item then
                    if Item.Get("No.") then
                        Weight := Item."Net Weight";
            end;
        }
        field(50; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(60; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(70; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';

            trigger OnValidate()
            begin
                CalcLine(false);
            end;
        }
        field(80; "Unit Freight Cost"; Decimal)
        {
            Caption = 'Unit Freight Cost';

            trigger OnValidate()
            begin
                CalcLine(false);
            end;
        }
        field(90; "Total Unit Cost"; Decimal)
        {
            Caption = 'Total Unit Cost';

            trigger OnValidate()
            begin
                CalcLine(false);
            end;
        }
        field(100; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost';

            trigger OnValidate()
            begin
                CalcLine(false);
            end;
        }
        field(103; "Retail Price"; Decimal)
        {
            Caption = 'Retail Price';
        }
        field(105; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
        }
        field(110; "Retail Unit Price"; Decimal)
        {
            Caption = 'Retail Unit Price';

            trigger OnValidate()
            begin
                CalcLine(false);
                "Margin %" := "Margin Retail %";
                "Offer Unit Price" := "Retail Unit Price";
                "Offer Line Discount %" := "Line Discount %";
                "Total Offer Price" := Quantity * "Offer Unit Price";
                "Margin Amount" := "Offer Unit Price" - "Total Unit Cost";
            end;
        }
        field(120; "Margin Retail %"; Decimal)
        {
            Caption = 'Margin Retail %';
        }
        field(130; "Retail Total Price"; Decimal)
        {
            Caption = 'Retail Total Price';

            trigger OnValidate()
            begin
                CalcLine(false);
            end;
        }
        field(160; "Offer Unit Price"; Decimal)
        {
            Caption = 'Offer Unit Price';

            trigger OnValidate()
            begin
                CalcLine(false);
            end;
        }
        field(161; "Offer Line Discount %"; Decimal)
        {
            Caption = 'Offer Line Discount %';

            trigger OnValidate()
            begin
                CalcLine(false);
            end;
        }
        field(162; "Margin Amount"; Decimal)
        {
            Caption = 'Margin Amount';
        }
        field(170; "Margin %"; Decimal)
        {
            Caption = 'Margin %';

            trigger OnValidate()
            begin
                CalcLine(false);
            end;
        }
        field(180; "Total Offer Price"; Decimal)
        {
            Caption = 'Total Offer Price';

            trigger OnValidate()
            begin
                CalcLine(false);
            end;
        }
        field(190; "Currency Code"; Code[10])
        {
            CalcFormula = lookup("Sales Analysis Header"."Currency Code" where("No." = field("Document No."),
                                                                                "Document Type" = field("Document Type")));
            Caption = 'Currency Code';
            FieldClass = FlowField;
        }
        field(200; "Currency Factor"; Decimal)
        {
            CalcFormula = lookup("Sales Analysis Header"."Currency Factor" where("No." = field("Document No."),
                                                                                  "Document Type" = field("Document Type")));
            Caption = 'Currency Factor';
            FieldClass = FlowField;
        }
        field(220; "Quantity in Stock"; Decimal)
        {
            Caption = 'Quantity in Stock';
        }
        field(230; "Stock Average Unit Cost"; Decimal)
        {
            Caption = 'Stock Average Unit Cost';
        }
        field(240; "Vendor Stock Quantity"; Decimal)
        {
            Caption = 'Vendor Stock Quantity';
        }
        field(250; Weight; Decimal)
        {
            Caption = 'Weight';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Document Type", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ItemCategory: Record "Item Category";
        Item: Record Item;
        Location: Record Location;
        SalesAnalysisHeader: Record "Sales Analysis Header";
        MarginUpdateFromHeader: Boolean;


    procedure CalcLine(IsLineUpdate: Boolean)
    begin
        "Quantity in Stock" := 0;
        Item.Reset;
        Clear(ItemCategory);
        if Item.Get("No.") then begin
            if ItemCategory.Get(Item."Item Category Code") then;
            Location.Reset;
            Location.SetRange("Use As Service Location", false);
            if Location.FindFirst then
                repeat
                    Item.SetRange("Location Filter", Location.Code);
                    Item.CalcFields(Inventory);
                    "Quantity in Stock" += Item.Inventory;
                until Location.Next = 0;
            if "Currency Factor" <> 0 then
                "Stock Average Unit Cost" := Item."Unit Cost" * "Currency Factor"
            else
                "Stock Average Unit Cost" := Item."Unit Cost";
        end;

        "Retail Total Price" := Quantity * "Retail Unit Price";
        if not IsLineUpdate then begin
            if (CurrFieldNo = FieldNo("Unit Cost")) or ((CurrFieldNo = 0) and (not MarginUpdateFromHeader)) then
                "Unit Freight Cost" := "Unit Cost" * ItemCategory."Quote Analysis Freight %" / 100;
        end;
        "Total Unit Cost" := "Unit Cost" + "Unit Freight Cost";
        "Total Cost" := Quantity * "Total Unit Cost";
        if "Retail Unit Price" = 0 then
            "Margin Retail %" := 0
        else
            "Margin Retail %" := (("Retail Unit Price" - "Total Unit Cost") / "Retail Unit Price") * 100;

        if CurrFieldNo in [FieldNo("Margin %"), FieldNo("Offer Unit Price"), FieldNo("Offer Line Discount %"), FieldNo("Unit Cost"), FieldNo("Unit Freight Cost")] then
            CalcPricesAndMargins(0);

        if CurrFieldNo > 0 then
            CalcHeaderMarginPr;

        /*
        IF CurrFieldNo>0 THEN BEGIN
          SalesAnalysisHeader.GET("Document No.","Document Type");
          SalesAnalysisHeader.CALCFIELDS("Total Cost","Total Offer Price");
          IF SalesAnalysisHeader."Total Offer Price" > 0 THEN
            SalesAnalysisHeader."Margin %" :=
                ((SalesAnalysisHeader."Total Offer Price" - SalesAnalysisHeader."Total Cost") / SalesAnalysisHeader."Total Offer Price") * 100
          ELSE
            SalesAnalysisHeader."Margin %" := 0;
          SalesAnalysisHeader.MODIFY;
        END;
        */
        MarginUpdateFromHeader := false;

    end;

    local procedure GetPurchasePrice()
    var
        PurchasePrice: Record "Purchase Price";
        CurrencyRate: Record "Currency Exchange Rate";
        LowestPurchPrice: Decimal;
        CurrFactor: Decimal;
        PurchPriceLCY: Decimal;
        LowestPurchPriceLCY: Decimal;
    begin
        LowestPurchPriceLCY := 0;
        PurchasePrice.Reset;
        PurchasePrice.SetRange("Item No.", "No.");
        PurchasePrice.SetFilter("Starting Date", '..%1|%2', WorkDate, 0D);
        PurchasePrice.SetFilter("Ending Date", '%1..|%2', WorkDate, 0D);
        if PurchasePrice.FindFirst then
            repeat
                if PurchasePrice."Currency Code" <> '' then begin
                    CurrFactor := CurrencyRate.GetCurrentCurrencyFactor(PurchasePrice."Currency Code");
                    if CurrFactor <> 0 then
                        PurchPriceLCY := PurchasePrice."Direct Unit Cost" / CurrFactor
                    else
                        PurchPriceLCY := 0;
                end else
                    PurchPriceLCY := PurchasePrice."Direct Unit Cost";

                if (PurchPriceLCY <> 0) and (((PurchPriceLCY < LowestPurchPriceLCY) and (LowestPurchPriceLCY <> 0)) or (LowestPurchPriceLCY = 0)) then
                    LowestPurchPriceLCY := PurchPriceLCY;
            until PurchasePrice.Next = 0;

        if "Currency Factor" <> 0 then
            "Unit Cost" := LowestPurchPriceLCY * "Currency Factor"
        else
            "Unit Cost" := LowestPurchPriceLCY;
    end;


    procedure CalcPricesAndMargins(FieldN: Integer)
    begin
        if FieldN = 0 then
            FieldN := CurrFieldNo;
        case FieldN of
            FieldNo("Margin %"):
                begin
                    CalcOfferPriceFromMargin;
                    CalcOfferLineDisc;
                end;
            FieldNo("Offer Unit Price"):
                begin
                    CalcMarginPr;
                    CalcOfferLineDisc;
                end;
            FieldNo("Offer Line Discount %"):
                begin
                    CalcOfferPriceFromDiscount;
                    CalcMarginPr;
                end;
            FieldNo("Unit Cost"), FieldNo("Unit Freight Cost"):
                begin
                    CalcOfferPriceFromMargin;
                    CalcMarginPr;
                    CalcOfferLineDisc;
                end;
        end;

        "Total Offer Price" := Quantity * "Offer Unit Price";
        "Margin Amount" := "Offer Unit Price" - "Total Unit Cost";
    end;

    local procedure CalcMarginPr()
    begin
        if "Offer Unit Price" = 0 then
            "Margin %" := 0
        else
            "Margin %" := (("Offer Unit Price" - "Total Unit Cost") / "Offer Unit Price") * 100;
    end;

    local procedure CalcOfferPriceFromMargin()
    begin
        if ("Margin %" <> 100) and ("Total Unit Cost" <> 0) then
            "Offer Unit Price" := "Total Unit Cost" * (100 / (100 - "Margin %"));
    end;

    local procedure CalcOfferLineDisc()
    begin
        if "Retail Price" <> 0 then
            "Offer Line Discount %" := (("Retail Price" - "Offer Unit Price") / "Retail Price") * 100
        else
            "Offer Line Discount %" := 0;
    end;

    local procedure CalcOfferPriceFromDiscount()
    begin
        "Offer Unit Price" := "Retail Price" * (100 - "Offer Line Discount %") / 100;
    end;


    procedure CalcHeaderMarginPr()
    var
        SalesAnalysisLine: Record "Sales Analysis Line";
    begin
        SalesAnalysisLine.Reset;
        SalesAnalysisLine.SetRange("Document No.", "Document No.");
        SalesAnalysisLine.SetRange("Document Type", "Document Type");
        SalesAnalysisLine.SetFilter("Line No.", '<>%1', "Line No.");
        SalesAnalysisLine.CalcSums("Total Cost", "Total Offer Price");

        SalesAnalysisHeader.Get("Document No.", "Document Type");
        if (SalesAnalysisLine."Total Offer Price" > 0) or ("Total Offer Price" > 0) then
            SalesAnalysisHeader."Margin %" :=
                ((SalesAnalysisLine."Total Offer Price" + "Total Offer Price" - SalesAnalysisLine."Total Cost" - "Total Cost")
                 / (SalesAnalysisLine."Total Offer Price" + "Total Offer Price")) * 100
        else
            SalesAnalysisHeader."Margin %" := 0;
        SalesAnalysisHeader.Modify;
    end;


    procedure SetParams(MarginUpdateFromHeaderPar: Boolean)
    begin
        MarginUpdateFromHeader := MarginUpdateFromHeaderPar;
    end;
}

