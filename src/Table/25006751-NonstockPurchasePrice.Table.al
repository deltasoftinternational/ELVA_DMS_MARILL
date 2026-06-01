Table 25006751 "Nonstock Purchase Price"
{
    Caption = 'Nonstock Item Purchase Price';
    LookupPageID = "Purchase Prices";

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
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"), "Nonstock Item Entry No.");
            end;
        }
        field(5; "Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;
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
                Validate("Starting Date");
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
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
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // DELTA SALESPRICE
        cuPurchPriceCalcMgt.NonstockPurchPriceToItem(Rec, xRec, 3);
    end;

    trigger OnInsert()
    begin
        TestField("Vendor No.");
        TestField("Nonstock Item Entry No.");
        // DELTA SALESPRICE
        cuPurchPriceCalcMgt.NonstockPurchPriceToItem(Rec, xRec, 0);
    end;

    trigger OnModify()
    begin
        // DELTA SALESPRICE
        cuPurchPriceCalcMgt.NonstockPurchPriceToItem(Rec, xRec, 1);
    end;

    trigger OnRename()
    begin
        TestField("Vendor No.");
        TestField("Nonstock Item Entry No.");
        // DELTA SALESPRICE
        cuPurchPriceCalcMgt.NonstockPurchPriceToItem(Rec, xRec, 2);
    end;

    var
        recVend: Record Vendor;
        Text000: label '%1 cannot be after %2 for Nonstock Item %3';
        cuPurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt. EDMS";
}

