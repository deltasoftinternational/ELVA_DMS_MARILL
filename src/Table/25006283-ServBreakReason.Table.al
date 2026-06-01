Table 25006283 "Serv. Break Reason"
{
    Caption = 'Serv. Break Reason';
    LookupPageID = "Serv. Break Reasons";

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

