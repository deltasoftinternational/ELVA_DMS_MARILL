Table 25006027 "Questionary Templ. Subj. Group"
{
    // 06/03/2018 GH P1
    //   *Added ENG captions

    Caption = 'Questionary Template Subject Group';
    DrillDownPageID = "Quest. Template Subject Groups";
    LookupPageID = "Quest. Template Subject Groups";

    fields
    {
        field(10; "Questionary Template Code"; Code[20])
        {
            Caption = 'Questionary Template Code';
            NotBlank = true;
            TableRelation = "Questionary Template".Code;
        }
        field(20; "Questionary Subject Group Code"; Code[20])
        {
            Caption = 'Questionary Subject Group Code';
            NotBlank = true;
            TableRelation = "Questionary Subject Group".Code;
        }
        field(100; "Sorting No."; Integer)
        {
            Caption = 'Sorting No.';
        }
    }

    keys
    {
        key(Key1; "Questionary Template Code", "Questionary Subject Group Code")
        {
            Clustered = true;
        }
        key(Key2; "Questionary Template Code", "Sorting No.")
        {
        }
    }

    fieldgroups
    {
    }
}

