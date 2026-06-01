Table 25006409 "Claim Job Type"
{
    Caption = 'Claim Job Type';
    LookupPageID = "Claim Job Type List";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; Comment; Text[100])
        {
            Caption = 'Comment';
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

