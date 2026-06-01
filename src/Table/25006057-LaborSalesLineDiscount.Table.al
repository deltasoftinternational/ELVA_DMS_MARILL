Table 25006057 "Labor Sales Line Discount"
{
    Caption = 'Labor Sales Line Discount';
    LookupPageID = "Labor Sales Line Discounts";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = if (Type = const(Labor)) "Service Labor"
            else
            if (Type = const("Labor Discount Group")) "Service Labor Discount Group";
        }
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = if ("Sales Type" = const("Customer Disc. Group")) "Customer Discount Group"
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
                if "Sales Code" <> '' then
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
                if "Sales Type" = "sales type"::Campaign then
                    Error(Text003, FieldCaption("Starting Date"), FieldCaption("Ending Date"), FieldCaption("Sales Type"), "Sales Type");
            end;
        }
        field(5; "Line Discount %"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(13; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign,Contract,Assembly,SPackage';
            OptionMembers = Customer,"Customer Disc. Group","All Customers",Campaign,Contract,Assembly,SPackage;

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then
                    Validate("Sales Code", '');
            end;
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

                if CurrFieldNo = 0 then
                    exit;
                if "Sales Type" = "sales type"::Campaign then
                    Error(Text003, FieldCaption("Starting Date"), FieldCaption("Ending Date"), FieldCaption("Sales Type"), "Sales Type");
            end;
        }
        field(21; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Labor,Labor Discount Group,All';
            OptionMembers = Labor,"Labor Discount Group",All;

            trigger OnValidate()
            begin
                if xRec.Type <> Type then
                    Validate(Code, '');
                if Type = Type::All then
                    Validate(Code, '');
                if Type = Type::Labor then begin
                    Validate("Labor Group Code", '');
                    Validate("Labor Subgroup Code", '');
                end;
            end;
        }
        field(101; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(102; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(103; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(104; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));
        }
        field(108; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";
        }
        field(120; "Labor Group Code"; Code[10])
        {
            Caption = 'Labor Group Code';
            TableRelation = if (Type = const(All)) "Service Labor Group";

            trigger OnValidate()
            var
                ProductSubgrp: Record "Product Subgroup";
            begin
            end;
        }
        field(121; "Labor Subgroup Code"; Code[10])
        {
            Caption = 'Labor Subgroup Code';
            TableRelation = if (Type = const(All)) "Service Labor Subgroup" where("Group Code" = field("Labor Group Code"));
        }
    }

    keys
    {
        key(Key1; Type, "Code", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Minimum Quantity", "Vehicle Status Code", "Vehicle Serial No.")
        {
            Clustered = true;
        }
        key(Key2; "Sales Type", "Sales Code", Type, "Code", "Starting Date", "Currency Code", "Minimum Quantity")
        {
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
        TestField(Code);
    end;

    trigger OnRename()
    begin
        if "Sales Type" <> "sales type"::"All Customers" then
            TestField("Sales Code");
        TestField(Code);
    end;

    var
        Text000: label '%1 cannot be after %2';
        Text001: label '%1 must be blank.';
        Campaign: Record Campaign;
        Text003: label 'You can only change the %1 and %2 from the Campaign Card when %3 = %4.';
}

