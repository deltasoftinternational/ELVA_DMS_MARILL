Table 25006174 "Recall Campaign Types"
{
    Caption = 'Recall Campaign Types';
    DrillDownPageID = "Recall Campaign Types";
    LookupPageID = "Recall Campaign Types";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
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

