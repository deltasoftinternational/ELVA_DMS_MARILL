Table 25006215 "BLS Service Price"
{
    Caption = 'Service Price';

    fields
    {
        field(10; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            NotBlank = true;
            TableRelation = "BLS Service";
        }
        field(20; "Service Variant Code"; Code[20])
        {
            Caption = 'Service Variant Code';
        }
        field(30; "Object Code"; Code[20])
        {
            Caption = 'Object Code';
            TableRelation = "BLS Object".Code where("Object Type" = const(Standard));

            trigger OnLookup()
            begin
                BLSObject.Reset;
                if BLSObject.Get("Object Code") then;
                if Page.RunModal(0, BLSObject) = Action::LookupOK then begin
                    Validate("Object Code", BLSObject.Code);
                end;
            end;

            trigger OnValidate()
            begin
                if xRec."Object Code" <> "Object Code" then
                    "Object Name" := '';

                if "Object Code" <> '' then begin
                    BLSObject.Get("Object Code");
                    BLSObject.TestField("Object Type", BLSObject."object type"::Standard);
                    "Object Name" := BLSObject.Name;
                end;
            end;
        }
        field(34; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Price Group,All Customers';
            OptionMembers = Customer,"Customer Price Group","All Customers";

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then begin
                    Validate("Sales Code", '');
                end;
            end;
        }
        field(36; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = if ("Sales Type" = const("Customer Price Group")) "Customer Price Group"
            else
            if ("Sales Type" = const(Customer)) Customer;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if "Sales Code" <> '' then
                    case "Sales Type" of
                        "sales type"::"All Customers":
                            Error(Text001, FieldCaption("Sales Code"));
                        "sales type"::"Customer Price Group":
                            begin
                                CustPriceGroup.Get("Sales Code");
                                "Price Includes VAT" := CustPriceGroup."Price Includes VAT";
                                "VAT Bus. Posting Gr. (Price)" := CustPriceGroup."VAT Bus. Posting Gr. (Price)";
                                "Allow Line Disc." := CustPriceGroup."Allow Line Disc.";
                                "Allow Invoice Disc." := CustPriceGroup."Allow Invoice Disc.";
                            end;
                        "sales type"::Customer:
                            begin
                                Cust.Get("Sales Code");
                                "Currency Code" := Cust."Currency Code";
                                "Price Includes VAT" := Cust."Prices Including VAT";
                                "VAT Bus. Posting Gr. (Price)" := Cust."VAT Bus. Posting Group";
                                "Allow Line Disc." := Cust."Allow Line Disc.";
                            end;
                    end;
            end;
        }
        field(40; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));
            end;
        }
        field(50; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;
        }
        field(60; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';

            trigger OnValidate()
            begin
                if "Minimum Quantity" <> 0 then begin
                    TestField("Service Code");
                    "Minimum Quantity" := BLSMgt.NormalizeServiceQty("Service Code", 0, "Minimum Quantity");
                end;
            end;
        }
        field(90; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                Validate("Starting Date");
            end;
        }
        field(100; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(110; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(200; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(300; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(310; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(400; "Object Name"; Text[50])
        {
            Caption = 'Object Name';
        }
    }

    keys
    {
        key(Key1; "Service Code", "Service Variant Code", "Object Code", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Minimum Quantity")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        BLSObject: Record "BLS Object";
        Cust: Record Customer;
        CustPriceGroup: Record "Customer Price Group";
        BLSMgt: Codeunit "BLS Management";
        ObjCodeMustBeEmptyErr: label 'Object must be empty for object type %1.';
        Text000: label '%1 cannot be after %2';
        Text001: label '%1 must be blank.';
}

