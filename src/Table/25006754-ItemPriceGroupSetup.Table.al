Table 25006754 "Item Price Group Setup"
{
    Caption = 'Item Price Group Setup';
    LookupPageID = "Item Price Group Setup";
    DrillDownPageId = "Item Price Group Setup";

    fields
    {
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = if ("Sales Type" = const("Customer Price Group")) "Customer Price Group"
            else
            if ("Sales Type" = const(Customer)) Customer
            else
            if ("Sales Type" = const(Campaign)) Campaign
            else
            if ("Sales Type" = const(Location)) Location;
        }
        field(10; "Item Price Group Code"; Code[10])
        {
            Caption = 'Item Price Group Code';
        }
        field(13; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,Location,Markup,Assembly,Contract,Serv. Pack,Labor Price Group';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign,Location,Markup,Assembly,Contract,SPackage,"Labor Price Group";

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then
                    Validate("Sales Code", '');
            end;
        }
        field(20; "Sales Price Factor"; Decimal)
        {
            Caption = 'Sales Price Factor';
            DecimalPlaces = 2 : 5;
        }
        field(21; "Cost From"; Decimal)
        {
            Caption = 'Cost From';
            DecimalPlaces = 2 : 5;
        }
        field(22; "Cost To"; Decimal)
        {
            Caption = 'Cost To';
            DecimalPlaces = 2 : 5;
        }
    }

    keys
    {
        key(Key1; "Item Price Group Code", "Sales Type", "Sales Code", "Cost From")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

