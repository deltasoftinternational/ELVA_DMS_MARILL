Table 25006034 "Vehicle Insurance Type"
{
    Caption = 'Vehicle Insurance Type';
    LookupPageID = "Vehicle Insurance Types";

    fields
    {
        field(10; "Code"; Code[20])
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

