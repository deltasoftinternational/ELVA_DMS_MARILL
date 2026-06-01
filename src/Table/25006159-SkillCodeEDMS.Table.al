Table 25006159 "Skill Code EDMS"
{
    Caption = 'Skill Code';
    DataCaptionFields = "Code", Description;
    LookupPageID = "Skill Codes EDMS";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
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

