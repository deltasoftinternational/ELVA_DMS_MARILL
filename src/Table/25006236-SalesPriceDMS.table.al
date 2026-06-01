table 25006236 "Sales Price DMS"
{
    // 25.11.2015 EB.P7 #T017
    //   Trigger code moved to events
    // 
    // 14.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve. Added key.
    // 
    // 30.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Make Code added to the primary key

    Caption = 'Sales Price DMS';
    // LookupPageID = "Sales Prices";


    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeItemNoOnValidate(Rec, xRec, IsHandled);
                if IsHandled then
                    exit;

                if "Item No." <> xRec."Item No." then begin
                    Item.Get("Item No.");
                    "Unit of Measure Code" := Item."Sales Unit of Measure";
                    "Variant Code" := '';
                end;

                if "Sales Type" = "Sales Type"::"Customer Price Group" then
                    if CustPriceGr.Get("Sales Code") and
                       (CustPriceGr."Allow Invoice Disc." = "Allow Invoice Disc.")
                    then
                        exit;

                UpdateValuesFromItem;
            end;
        }
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF ("Sales Type" = CONST("Customer Price Group")) "Customer Price Group"
            ELSE
            IF ("Sales Type" = CONST(Customer)) Customer
            ELSE
            IF ("Sales Type" = CONST(Campaign)) Campaign;

            trigger OnValidate()
            begin
                if "Sales Code" <> '' then
                    case "Sales Type" of
                        "Sales Type"::"All Customers":
                            Error(Text001, FieldCaption("Sales Code"));
                        "Sales Type"::"Customer Price Group":
                            begin
                                CustPriceGr.Get("Sales Code");
                                OnValidateSalesCodeOnAfterGetCustomerPriceGroup(Rec, CustPriceGr);
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
                                "VAT Bus. Posting Gr. (Price)" := Cust."VAT Bus. Posting Group";
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
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));

                if CurrFieldNo = 0 then
                    exit;

                if "Starting Date" <> 0D then
                    if "Sales Type" = "Sales Type"::Campaign then
                        Error(Text002, "Sales Type");
            end;
        }
        field(5; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(7; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(10; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(11; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(13; "Sales Type"; Enum "Sales Price Type")
        {
            Caption = 'Sales Type';

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then begin
                    Validate("Sales Code", '');
                    UpdateValuesFromItem;
                end;
            end;
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                if CurrFieldNo = 0 then
                    exit;

                Validate("Starting Date");

                if "Ending Date" <> 0D then
                    if "Sales Type" = "Sales Type"::Campaign then
                        Error(Text002, "Sales Type");
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Make;
        }
        field(25006007; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006010; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Description = 'Only for Vehicle Trade';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));
        }
        field(25006120; "Source Type"; Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'User,Contract';
            OptionMembers = User,Contract;
        }
        field(25006130; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
        }
        field(25006140; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(25006373; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Only for Vehicle Trade';
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
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,7002,25006800';
        }
    }

    keys
    {

        key(Key1; "Item No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code", "Location Code", "Document Profile", "Vehicle Serial No.", "Variable Field 25006800", "Make Code")
        {
            Clustered = true;
        }
        key(Key2; "Sales Type", "Sales Code", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
        key(Key3; SystemModifiedAt)
        {
        }
        key(Key4; "Item No.", "Make Code", "Model Code", "Model Version No.", "Vehicle Serial No.", "Document Profile")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Sales Type", "Sales Code", "Item No.", "Starting Date", "Unit Price", "Ending Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sales Type" = "Sales Type"::"All Customers" then
            "Sales Code" := ''
        else
            TestField("Sales Code");
        TestField("Item No.");
    end;

    trigger OnRename()
    begin
        if "Sales Type" <> "Sales Type"::"All Customers" then
            TestField("Sales Code");
        TestField("Item No.");
    end;

    var
        CustPriceGr: Record "Customer Price Group";
        Text000: Label '%1 cannot be after %2';
        Cust: Record Customer;
        Text001: Label '%1 must be blank.';
        Campaign: Record Campaign;
        Item: Record Item;
        Text002: Label 'If Sales Type = %1, then you can only change Starting Date and Ending Date from the Campaign Card.';
        Text100: label 'Don''t forget to set %1';

    local procedure UpdateValuesFromItem()
    begin
        if Item.Get("Item No.") then begin
            "Allow Invoice Disc." := Item."Allow Invoice Disc.";
            if "Sales Type" = "Sales Type"::"All Customers" then begin
                "Price Includes VAT" := Item."Price Includes VAT";
                "VAT Bus. Posting Gr. (Price)" := Item."VAT Bus. Posting Gr. (Price)";
            end;
        end;
    end;

    procedure CopySalesPriceToCustomersSalesPrice(var SalesPrice: Record "Sales Price DMS"; CustNo: Code[20])
    var
        NewSalesPrice: Record "Sales Price DMS";
    begin
        if SalesPrice.FindSet then
            repeat
                NewSalesPrice := SalesPrice;
                NewSalesPrice."Sales Type" := NewSalesPrice."Sales Type"::Customer;
                NewSalesPrice."Sales Code" := CustNo;
                OnBeforeNewSalesPriceInsert(NewSalesPrice, SalesPrice);
                if NewSalesPrice.Insert() then;
            until SalesPrice.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeItemNoOnValidate(var SalesPrice: Record "Sales Price DMS"; var xSalesPrice: Record "Sales Price DMS"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeNewSalesPriceInsert(var NewSalesPrice: Record "Sales Price DMS"; SalesPrice: Record "Sales Price DMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateSalesCodeOnAfterGetCustomerPriceGroup(var Salesprice: Record "Sales Price DMS"; CustPriceGroup: Record "Customer Price Group")
    begin
    end;
}

