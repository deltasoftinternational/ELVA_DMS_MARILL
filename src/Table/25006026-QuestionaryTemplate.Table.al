Table 25006026 "Questionary Template"
{
    // 06/03/2018 GH P1
    //   *Added ENG captions
    //   *Added field Type

    Caption = 'Questionary Template';
    DrillDownPageID = "Questionary Templates";
    LookupPageID = "Questionary Templates";

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
        field(110; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(120; "Checklist Category"; Code[20])
        {
            Caption = 'Checklist Category';
            TableRelation = "Checklist Category";
        }
        field(25006650; Type; Option)
        {
            OptionMembers = " ","Vehicle Inspection";
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

