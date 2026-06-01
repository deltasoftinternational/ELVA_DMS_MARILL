Table 25006125 "Service Labor Subgroup"
{
    Caption = 'Service Labor Subgroup';
    LookupPageID = "Service Labor Subgroups";

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(20; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(30; "Group Code"; Code[10])
        {
            Caption = 'Group Code';
            NotBlank = true;
        }
        field(40; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(50; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
    }

    keys
    {
        key(Key1; "Make Code", "Group Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

