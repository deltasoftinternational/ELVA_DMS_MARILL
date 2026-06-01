Table 25006749 "Nonstock Item Price"
{
    // 16.02.2005 EDMS P1
    //  * Added code:
    //   OnInsert()
    //   OnModify()
    //   OnDelete()
    //   OnRename()
    // 
    // 
    // 13.08.2004 EDMS P1
    //  *Created field "Location Code"
    //  *Changed primary key:
    //     "Item No.,Sales Type,Sales Code,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity"
    //   + "Location Code"

    Caption = 'Nonstock Item Sales Price';
    LookupPageID = "Sales Prices";

    fields
    {
        field(1; "Nonstock Item Entry No."; Code[20])
        {
            Caption = 'Nonstock Item Entry No.';
            NotBlank = true;
            TableRelation = "Nonstock Item";

            trigger OnValidate()
            begin
                if "Nonstock Item Entry No." <> xRec."Nonstock Item Entry No." then begin
                    "Unit of Measure Code" := '';
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
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"), "Nonstock Item Entry No.");

                if CurrFieldNo = 0 then
                    exit;
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
        field(8; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = if ("Sales Type" = const("Customer Price Group")) "Customer Price Group"
            else
            if ("Sales Type" = const(Customer)) Customer
            else
            if ("Sales Type" = const(Campaign)) Campaign;

            trigger OnValidate()
            var
                CustPriceGr: Record "Customer Price Group";
                Cust: Record Customer;
                Campaign: Record Campaign;
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
        field(9; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            InitValue = "All Customers";
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign;

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then
                    Validate("Sales Code", '');
            end;
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
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
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
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
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
        field(25006701; "Price List Code"; Code[20])
        {
            TableRelation = "Price List Header";
        }
        field(25006702; "Price List Line No."; integer)
        {


        }
    }

    keys
    {
        key(Key1; "Sales Type", "Sales Code", "Nonstock Item Entry No.", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Location Code", "Ordering Price Type Code", "Document Profile")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //16.02.2005 EDMS P1
        // DELTA SALESPRICE
        cuSalesPriceCalcMgt.NonstockSalesPriceToItem(Rec, xRec, 3);
    end;

    trigger OnInsert()
    begin
        TestField("Nonstock Item Entry No.");

        //16.02.2005 EDMS P1
        // DELTA SALESPRICE
        cuSalesPriceCalcMgt.NonstockSalesPriceToItem(Rec, xRec, 0);
    end;

    trigger OnModify()
    begin
        //16.02.2005 EDMS P1
        // DELTA SALESPRICE
        cuSalesPriceCalcMgt.NonstockSalesPriceToItem(Rec, xRec, 1);
    end;

    trigger OnRename()
    begin
        TestField("Nonstock Item Entry No.");

        //16.02.2005 EDMS P1
        // DELTA SALESPRICE
        cuSalesPriceCalcMgt.NonstockSalesPriceToItem(Rec, xRec, 2);
    end;

    var
        Text000: label '%1 cannot be after %2 for Nonstock Item %3';
        Text001: label '%1 must be blank.';
        cuSalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";


    procedure DefaultPriceLCYIncVAT(EntryNo: Code[20]): Decimal
    var
        SalesSetup: Record "Sales & Receivables Setup";
        VATPostSetup: Record "VAT Posting Setup";
    begin
        SetFilter("Ending Date", '%1|>=%2', 0D, WorkDate);
        SetRange("Starting Date", 0D, WorkDate);
        SetRange("Nonstock Item Entry No.", EntryNo);
        SetRange("Sales Type", "sales type"::"All Customers");
        SetRange("Sales Code", '');
        SetRange("Currency Code", '');
        if FindLast then
            if "Price Includes VAT" then
                exit(ROUND("Unit Price", 0.01))
            else begin
                SalesSetup.Get;
                if (SalesSetup."Def.S.Price VAT Bus.Post.Grp." <> '') and (SalesSetup."Def.S.Price VAT Prod.Post.Grp." <> '') then
                    VATPostSetup.Get(SalesSetup."Def.S.Price VAT Bus.Post.Grp.", SalesSetup."Def.S.Price VAT Prod.Post.Grp.");

                exit(ROUND("Unit Price" * (1 + VATPostSetup."VAT %" / 100), 0.01));
            end;
    end;
}

