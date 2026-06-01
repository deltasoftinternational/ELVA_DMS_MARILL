Table 25006762 "Item Markup Restriction"
{
    Caption = 'Item Markup Restriction';
    LookupPageID = "Item Markup Restrictions";

    fields
    {
        field(10; "Group Code"; Code[20])
        {
            Caption = 'Group Code';
            TableRelation = "Item Markup Restriction Group";
        }
        field(20; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(30; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(40; "Min. Markup %"; Decimal)
        {
            Caption = 'Min. Markup %';
        }
        field(50; Base; Option)
        {
            Caption = 'Base';
            OptionCaption = 'Unit Cost,Nonstock Item Catalog Price';
            OptionMembers = "Unit Cost","Nonstock Item List Price","Nonstock Item List Urgent Price","Nonstock Item All List Prices";
        }
    }

    keys
    {
        key(Key1; "Group Code", "Customer Price Group", "Item Category Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

