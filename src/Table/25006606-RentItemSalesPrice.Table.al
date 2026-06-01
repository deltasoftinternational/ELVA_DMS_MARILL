Table 25006606 "Rent Item Sales Price"
{
    Caption = 'Rent Item Sales Price';

    fields
    {
        field(10; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';
            TableRelation = "Rent Item";
        }
        field(20; "Rent Period Code"; Code[10])
        {
            Caption = 'Rent Period Unit';
            TableRelation = "Rent Period";
        }
        field(30; "Rent Period Price"; Decimal)
        {
            Caption = 'Rent Period Price';
        }
        field(40; "Extra Period Code"; Code[10])
        {
            Caption = 'Extra Period Unit';
            TableRelation = "Rent Period";
        }
        field(50; "Extra Period Price"; Decimal)
        {
            Caption = 'Extra Period Price';
        }
        field(60; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(70; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(80; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(90; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(100; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(110; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign;

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then begin
                    Validate("Sales Code", '');
                end;
            end;
        }
        field(120; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            DataClassification = ToBeClassified;
            TableRelation = if ("Sales Type" = const("Customer Price Group")) "Customer Price Group"
            else
            if ("Sales Type" = const(Customer)) Customer
            else
            if ("Sales Type" = const(Campaign)) Campaign;

            trigger OnValidate()
            begin
                if "Sales Code" <> '' then
                    case "Sales Type" of
                        "sales type"::"All Customers":
                            Error(Text001, FieldCaption("Sales Code"));
                        "sales type"::"Customer Price Group":
                            begin
                                CustPriceGr.Get("Sales Code");
                                "Price Includes VAT" := CustPriceGr."Price Includes VAT";
                                "VAT Bus. Posting Gr. (Price)" := CustPriceGr."VAT Bus. Posting Gr. (Price)";
                            end;
                        "sales type"::Customer:
                            begin
                                Cust.Get("Sales Code");
                                "Currency Code" := Cust."Currency Code";
                                "Price Includes VAT" := Cust."Prices Including VAT";
                                "VAT Bus. Posting Gr. (Price)" := Cust."VAT Bus. Posting Group";
                            end;
                        "sales type"::Campaign:
                            begin
                                Campaign.Get("Sales Code");
                                "Starting Date" := Campaign."Starting Date";
                                "Ending Date" := Campaign."Ending Date";
                            end;
                    end;
            end;
        }
        field(130; "Variable Field Run 1"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006606,130';
            DataClassification = ToBeClassified;
        }
        field(131; "Variable Field UOM 1"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(140; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006606,140';
            DataClassification = ToBeClassified;
        }
        field(141; "Variable Field UOM 2"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(150; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006606,150';
            DataClassification = ToBeClassified;
        }
        field(151; "Variable Field UOM 3"; Code[10])
        {
            DataClassification = ToBeClassified;
        }

        field(152; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }

    }

    keys
    {
        key(Key1; "Rent Item No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Rent Period Code", "Minimum Quantity")
        {
            Clustered = true;
        }
        key(Key2; "Rent Period Price")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: label '%1 must be blank.';
        CustPriceGr: Record "Customer Price Group";
        Cust: Record Customer;
        Campaign: Record Campaign;
        Item: Record Item;
        VFMgt: Codeunit "Variable Field Management";

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Item Sales Price", FieldNo));
    end;
}

