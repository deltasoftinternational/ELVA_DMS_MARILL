Table 25006272 "Serv. Standard Event"
{
    Caption = 'Serv. Standard Event';
    LookupPageID = "Serv. Standard Events";

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
        field(30; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
        }
        field(40; "Group Code"; Code[10])
        {
            Caption = 'Group Code';
            TableRelation = "Service Labor Group".Code;
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

