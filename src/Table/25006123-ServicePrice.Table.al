Table 25006123 "Service Price"
{
    // 30.03.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "Make Code", also added to  the primary key
    //   * Added field "Location Code", also added to  the primary key
    // 
    // 08.02.05 AB

    Caption = 'Service Price';

    fields
    {
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Service Labor,Serv. Labor group,External Service';
            OptionMembers = Labor,"Labor Group","Ext.Serv.";
        }
        field(5; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = if (Type = const(Labor)) "Service Labor"
            else
            if (Type = const("Labor Group")) "Service Labor Price Group"
            else
            if (Type = const("Ext.Serv.")) "External Service";
        }
        field(7; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,Markup,Assembly,Contract,Serv. Pack';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign,Markup,Assembly,Contract,SPackage;

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then
                    Validate("Sales Code", '');
            end;
        }
        field(8; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = if ("Sales Type" = const("Customer Price Group")) "Customer Price Group"
            else
            if ("Sales Type" = const(Customer)) Customer
            else
            if ("Sales Type" = const(Campaign)) Campaign
            else
            if ("Sales Type" = const(SPackage)) "Service Package"
            else
            if ("Sales Type" = const(Contract)) Contract."Contract No.";

            trigger OnValidate()
            begin
                if "Sales Code" <> '' then begin
                    case "Sales Type" of
                        "sales type"::"All Customers":
                            Error(Text001, FieldCaption("Sales Code"));
                        "sales type"::"Customer Price Group":
                            begin
                                CustPriceGr.Get("Sales Code");
                                "Price Includes VAT" := CustPriceGr."Price Includes VAT";
                                "VAT Bus. Posting Gr. (Price)" := CustPriceGr."VAT Bus. Posting Gr. (Price)";
                                "Allow Line Disc." := CustPriceGr."Allow Line Disc.";
                                "Allow Invoice Disc." := CustPriceGr."Allow Invoice Disc.";
                            end;
                        "sales type"::Customer:
                            begin
                                Cust.Get("Sales Code");
                                "Currency Code" := Cust."Currency Code";
                                "Price Includes VAT" := Cust."Prices Including VAT";
                                "Allow Line Disc." := Cust."Allow Line Disc.";
                            end;
                        "sales type"::Campaign:
                            begin
                                Campaign.Get("Sales Code");
                                "Starting Date" := Campaign."Starting Date";
                                "Ending Date" := Campaign."Ending Date";
                            end;
                    end;
                end;
            end;
        }
        field(50; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Ending Date"), FieldCaption("Starting Date"));
            end;
        }
        field(60; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                Validate("Starting Date");
            end;
        }
        field(70; Price; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(80; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(90; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(100; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(110; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(120; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(5410; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006770; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006123,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Price", FieldNo("Variable Field 25006800"),
                  '', "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; Type, "Code", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Unit of Measure Code", "Variable Field 25006800", "Location Code", "Make Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Sales Type" = "sales type"::"All Customers" then
            "Sales Code" := ''
        else
            TestField("Sales Code");
    end;

    trigger OnRename()
    begin
        if "Sales Type" <> "sales type"::"All Customers" then
            TestField("Sales Code");
    end;

    var
        Text000: label '%1 cannot be after %2';
        Text001: label '%1 must be blank.';
        CustPriceGr: Record "Customer Price Group";
        Cust: Record Customer;
        Campaign: Record Campaign;
        LookUpMgt: Codeunit LookUpManagement;
        VFMgt: Codeunit "Variable Field Management";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Service Price", intFieldNo));
    end;
}

