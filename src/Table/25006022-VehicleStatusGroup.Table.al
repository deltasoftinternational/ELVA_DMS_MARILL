Table 25006022 "Vehicle Status Group"
{
    Caption = 'Vehicle Status Group';
    LookupPageID = "Vehicle Status Groups";

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

