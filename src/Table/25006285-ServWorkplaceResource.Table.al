Table 25006285 "Serv. Workplace Resource"
{
    Caption = 'Serv. Workplace Resource';
    LookupPageID = "Serv. Workplace Resources List";

    fields
    {
        field(10; "Workplace Code"; Code[10])
        {
            Caption = 'Workplace Code';
            TableRelation = "Serv. Workplace";
        }
        field(20; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(30; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(40; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
    }

    keys
    {
        key(Key1; "Workplace Code", "Resource No.", "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

