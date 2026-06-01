Table 25006607 "Rent Item Sales Discount"
{
    Caption = 'Rent Item Sales Discount';

    fields
    {
        field(10; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Rent Item,Rent Item Category';
            OptionMembers = " ","Rent Item","Rent Item Category";
        }
        field(20; "Code"; Code[30])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = if (Type = const("Rent Item")) "Rent Item"."No."
            else
            if (Type = const("Rent Item Category")) "Rent Item Category".Code;
        }
        field(30; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Customer,Customer Discount Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Discount Group","All Customers",Campaign;
        }
        field(40; "Sales Code"; Code[30])
        {
            Caption = 'Sales Code';
            TableRelation = if ("Sales Type" = const("Customer Discount Group")) "Customer Discount Group"
            else
            if ("Sales Type" = const(Customer)) Customer
            else
            if ("Sales Type" = const(Campaign)) Campaign;
        }
        field(50; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(70; "Line Discount %"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(80; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(90; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(100; "Rent Period Code"; Code[10])
        {
            Caption = 'Rent Period Unit';
            DataClassification = ToBeClassified;
            TableRelation = "Rent Period";
        }
    }

    keys
    {
        key(Key1; Type, "Code", "Sales Type", "Sales Code", "Currency Code", "Starting Date", "Ending Date", "Rent Period Code")
        {
            Clustered = true;
        }
        key(Key2; "Line Discount %")
        {
        }
    }

    fieldgroups
    {
    }

    var
        CustPriceGr: Record "Customer Price Group";
        Text000: label '%1 cannot be after %2';
        Cust: Record Customer;
        Text001: label '%1 must be blank.';
        Campaign: Record Campaign;
        Text003: label 'You can only change the %1 and %2 from the Campaign Card when %3 = %4';
}

