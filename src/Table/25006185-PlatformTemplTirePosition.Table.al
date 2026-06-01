Table 25006185 "Platform Templ. Tire Position"
{
    Caption = 'Platform Templ. Tire Position';
    LookupPageID = "Platform Templ. Tire Positions";

    fields
    {
        field(10; "Template Code"; Code[10])
        {
            Caption = 'Template Code';
            TableRelation = "Platform Template";
        }
        field(20; "Template Axle Code"; Code[10])
        {
            Caption = 'Template Axle Code';
            TableRelation = "Platform Template Axle".Code where("Template Code" = field("Template Code"));
        }
        field(30; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(40; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Template Code", "Template Axle Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

