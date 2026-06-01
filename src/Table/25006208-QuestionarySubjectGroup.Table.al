Table 25006208 "Questionary Subject Group"
{
    // 06/03/2018 GH P1
    //   *Added ENG captions

    Caption = 'Questionary Subject Group';
    DrillDownPageID = "Questionary Subject Groups";
    LookupPageID = "Questionary Subject Groups";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(100; Description; Text[100])
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
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}

