Table 25006040 "Option Purchase Price"
{
    Caption = 'Option Purchase Price';
    LookupPageID = "Option Purchase Prices";

    fields
    {
        field(1; "Option Code"; Code[50])
        {
            Caption = 'Option Code';
            NotBlank = true;
            TableRelation = if ("Option Type" = const("Manufacturer Option")) "Manufacturer Option"."Option Code" where("Make Code" = field("Make Code"),
                                                                                                                       "Model Code" = field("Model Code"),
                                                                                                                       "Model Version No." = field("Model Version No."))
            else
            if ("Option Type" = const("Own Option")) "Own Option"."Option Code" where("Make Code" = field("Make Code"),
                                                                                                                                                                                                     "Model Code" = field("Model Code"));
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if Vend.Get("Vendor No.") then
                    "Currency Code" := Vend."Currency Code";
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
        field(70; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Manufacturer Option,Own Option';
            OptionMembers = "Manufacturer Option","Own Option";

            trigger OnValidate()
            begin
                if xRec."Option Type" <> "Option Type" then
                    Validate("Option Code", '');
            end;
        }
        field(75; "Option Subtype"; Option)
        {
            Caption = 'Option Subtype';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(80; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(90; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(100; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
    }

    keys
    {
        key(Key1; "Option Code", "Vendor No.", "Starting Date", "Currency Code", "Minimum Quantity", "Ordering Price Type Code", "Make Code", "Model Code", "Model Version No.")
        {
            Clustered = true;
        }
        key(Key2; "Vendor No.", "Option Code", "Starting Date", "Currency Code", "Minimum Quantity")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField("Vendor No.");
        TestField("Option Code");
    end;

    trigger OnRename()
    begin
        TestField("Vendor No.");
        TestField("Option Code");
    end;

    var
        Vend: Record Vendor;
        Text000: label '%1 cannot be after %2';
}

