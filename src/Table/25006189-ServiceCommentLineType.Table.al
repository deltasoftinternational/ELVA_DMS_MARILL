Table 25006189 "Service Comment Line Type"
{
    Caption = 'Service Comment Line Type';
    LookupPageID = "Service Comment Line Types";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(20; Print; Boolean)
        {
            Caption = 'Print';
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

