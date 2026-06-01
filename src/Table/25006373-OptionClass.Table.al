Table 25006373 "Option Class"
{
    Caption = 'Option Class';
    DrillDownPageID = "Option Classes";
    LookupPageID = "Option Classes";

    fields
    {
        field(5; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Description 2"; Text[30])
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

