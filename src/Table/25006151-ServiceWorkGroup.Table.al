Table 25006151 "Service Work Group"
{
    Caption = 'Service Work Group';
    LookupPageID = "Service Work Groups";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            Description = 'Now that code suppose to store not only shifts but types as well';
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

