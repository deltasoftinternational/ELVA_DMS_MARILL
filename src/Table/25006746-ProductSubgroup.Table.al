Table 25006746 "Product Subgroup"
{
    Caption = 'Product Subgroup';
    LookupPageID = "Product Subgroups";

    fields
    {
        field(1; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category".Code;
        }
        field(2; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
        }
        field(3; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(4; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Item Category Code", "Product Group Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

