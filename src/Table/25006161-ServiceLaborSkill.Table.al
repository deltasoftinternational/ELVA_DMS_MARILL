Table 25006161 "Service Labor Skill"
{
    Caption = 'Service Labor Skill';
    LookupPageID = "Service Labor Skills";

    fields
    {
        field(10; "Labor Code"; Code[20])
        {
            Caption = 'Labor Code';
            TableRelation = "Service Labor";
        }
        field(20; "Skill Code"; Code[10])
        {
            Caption = 'Skill Code';
            TableRelation = "Skill Code EDMS";
        }
    }

    keys
    {
        key(Key1; "Labor Code", "Skill Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

