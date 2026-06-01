Table 25006732 "Spare Part Sales Disc. Group"
{
    Caption = 'Spare Part Sales Disc. Group';
    LookupPageID = "Spare Parts Sales Disc. Groups";

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

