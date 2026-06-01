Table 25006291 "Schedule Resource Link"
{

    fields
    {
        field(10; "Group Resource No."; Code[20])
        {
            TableRelation = Resource."No." where(Type = filter(Machine));
        }
        field(20; "Resource No."; Code[20])
        {
            TableRelation = Resource."No." where(Type = filter(Person));
        }
        field(30; "Starting Date"; Date)
        {
        }
        field(40; "Ending Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Group Resource No.", "Resource No.", "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

