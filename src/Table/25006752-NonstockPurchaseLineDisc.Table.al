Table 25006752 "Nonstock Purchase Line Disc"
{
    // 16.02.2005 EDMS P1
    //  *Added code:
    //   OnInsert()
    //   OnModify()
    //   OnDelete()
    //   OnRename()
    // 
    // 
    // 23.09.2004 EDMS P1
    //   *Added key "Item Discount Group Code"
    //   *Added field "Item Discount Group Code"

    Caption = 'Nonstock Purchase Line Disc';
    LookupPageID = "Purchase Line Discounts";

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
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if recVend.Get("Vendor No.") then
                    "Currency Code" := recVend."Currency Code";
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
            end;
        }
        field(5; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(11; "Minimum Quantity"; Decimal)
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
                Validate("Starting Date");
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(25006670; "Item Discount Group Code"; Code[10])
        {
            Caption = 'Item Discount Group Code';
            TableRelation = "Item Discount Group";
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
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
        key(Key1; "Nonstock Item Entry No.", "Vendor No.", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code")
        {
            Clustered = true;
        }
        key(Key2; "Vendor No.", "Nonstock Item Entry No.", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code")
        {
        }
        key(Key3; "Item Discount Group Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //16.02.2005 EDMS P1
        // DELTA SALESPRICE
        cuPurchPriceCalcMgt.NonstockPurchLineDiscToItem(Rec, xRec, 3)
    end;

    trigger OnInsert()
    begin
        TestField("Vendor No.");
        TestField("Nonstock Item Entry No.");

        //16.02.2005 EDMS P1
        // DELTA SALESPRICE
        cuPurchPriceCalcMgt.NonstockPurchLineDiscToItem(Rec, xRec, 0)
    end;

    trigger OnModify()
    begin
        //16.02.2005 EDMS P1
        cuPurchPriceCalcMgt.NonstockPurchLineDiscToItem(Rec, xRec, 1)
    end;

    trigger OnRename()
    begin
        TestField("Vendor No.");
        TestField("Nonstock Item Entry No.");

        //16.02.2005 EDMS P1
        // DELTA SALESPRICE
        cuPurchPriceCalcMgt.NonstockPurchLineDiscToItem(Rec, xRec, 2)
    end;

    var
        recVend: Record Vendor;
        Text000: label '%1 cannot be after %2';
        cuPurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt. EDMS";
}

