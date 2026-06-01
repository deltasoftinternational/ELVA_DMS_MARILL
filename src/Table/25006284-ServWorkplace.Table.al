Table 25006284 "Serv. Workplace"
{
    Caption = 'Serv. Workplace';
    LookupPageID = "Serv. Workplaces";

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

