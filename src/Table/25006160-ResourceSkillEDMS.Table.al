Table 25006160 "Resource Skill EDMS"
{
    Caption = 'Resource Skill';
    LookupPageID = "Resource Skills EDMS";

    fields
    {
        field(10; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            NotBlank = true;
            TableRelation = Resource;
        }
        field(20; "Skill Code"; Code[10])
        {
            Caption = 'Skill Code';
            NotBlank = true;
            TableRelation = "Skill Code EDMS";
        }
    }

    keys
    {
        key(Key1; "Resource No.", "Skill Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

