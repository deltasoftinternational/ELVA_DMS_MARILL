Table 25006733 "SP Sales Disc. Group Items"
{
    Caption = 'SP Sales Disc. Group Items';
    LookupPageID = "Spare Parts Sales Disc. Groups";

    fields
    {
        field(10; "Sales Disc. Group Code"; Code[10])
        {
            Caption = 'Sales Disc. Group Code';
        }
        field(20; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item Category,Labor';
            OptionMembers = "Item Category",Labor;
        }
        field(30; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("Item Category")) "Item Category"
            else
            if (Type = const(Labor)) "Service Labor";
        }
        field(40; "Max. Discount %"; Decimal)
        {
            Caption = 'Max. Discount %';
        }
    }

    keys
    {
        key(Key1; "Sales Disc. Group Code", Type, "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

