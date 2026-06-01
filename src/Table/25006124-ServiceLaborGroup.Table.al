Table 25006124 "Service Labor Group"
{
    Caption = 'Service Labor Group';
    DataCaptionFields = "Code", Description;
    LookupPageID = "Service Labor Groups";

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
        field(30; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(40; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
    }

    keys
    {
        key(Key1; "Make Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

