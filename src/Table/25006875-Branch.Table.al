Table 25006875 "Branch"
{

    fields
    {
        field(10; "Code"; Code[20])
        {
        }
        field(20; Description; Text[100])
        {
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

