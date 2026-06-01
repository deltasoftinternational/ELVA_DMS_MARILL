Table 25006376 "Option Sales Discount"
{
    // 11.04.2013 EDMS P8
    //   * added field 'Option Subtype', to primary as well
    // 
    // 08.02.05 AB
    // *Jauns lauks Payment Method Code

    Caption = 'Option Sales Discount';
    LookupPageID = "Sales Line Discounts";

    fields
    {
        field(10; "Option Code"; Code[50])
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
        field(20; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = if ("Sales Type" = const("Customer Disc. Group")) "Customer Discount Group"
            else
            if ("Sales Type" = const(Customer)) Customer
            else
            if ("Sales Type" = const(Campaign)) Campaign;

            trigger OnValidate()
            begin
                if "Sales Code" <> '' then begin
                    case "Sales Type" of
                        "sales type"::"All Customers":
                            Error(Text001, FieldCaption("Sales Code"));
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
        field(30; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));

                if CurrFieldNo = 0 then
                    exit else
                    if "Sales Type" = "sales type"::Campaign then
                        Error(Text003, FieldCaption("Starting Date"), FieldCaption("Ending Date"), FieldCaption("Sales Type"), ("Sales Type"));
            end;
        }
        field(40; "Line Discount %"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Disc. Group","All Customers",Campaign;

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then
                    Validate("Sales Code", '');
            end;
        }
        field(60; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                Validate("Starting Date");

                if CurrFieldNo = 0 then
                    exit else
                    if "Sales Type" = "sales type"::Campaign then
                        Error(Text003, FieldCaption("Starting Date"), FieldCaption("Ending Date"), FieldCaption("Sales Type"), ("Sales Type"));
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
        field(110; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1; "Make Code", "Model Code", "Model Version No.", "Option Type", "Option Subtype", "Option Code", "Sales Type", "Sales Code", "Starting Date")
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
        TestField("Option Code");
    end;

    trigger OnRename()
    begin
        if "Sales Type" <> "sales type"::"All Customers" then
            TestField("Sales Code");
        TestField("Option Code");
    end;

    var
        Text000: label '%1 cannot be after %2';
        Cust: Record Customer;
        Text001: label '%1 must be blank.';
        Campaign: Record Campaign;
        Text003: label 'You can only change the %1 and %2 from the Campaign Card when %3 = %4';
}

