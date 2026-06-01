Table 25006404 "SMS Source Code"
{

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
        field(30; "Expiration Time (Min.)"; Integer)
        {
            Caption = 'Expiration Time (Min.)';
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

