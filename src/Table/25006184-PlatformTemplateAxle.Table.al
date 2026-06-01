Table 25006184 "Platform Template Axle"
{
    Caption = 'Platform Template Axle';
    LookupPageID = "Platform Template Axles";

    fields
    {
        field(10; "Template Code"; Code[10])
        {
            Caption = 'Template Code';
            TableRelation = "Platform Template";
        }
        field(20; "Code"; Code[10])
        {
            Caption = 'Code';
        }
    }

    keys
    {
        key(Key1; "Template Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

