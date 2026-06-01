Table 25006274 "Schedule Resource Group"
{
    Caption = 'Schedule Resource Group';
    DrillDownPageID = "Schedule Resource Groups";
    LookupPageID = "Schedule Resource Groups";

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Location Code"; Code[20])
        {
            TableRelation = Location;
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

    var
        GroupLine: Record "Schedule Resource Group Spec.";
}

