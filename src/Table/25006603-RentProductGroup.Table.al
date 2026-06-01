Table 25006603 "Rent Product Group"
{
    Caption = 'Rent Product Group';
    DrillDownPageID = "Rent Product Groups";
    LookupPageID = "Rent Product Groups";

    fields
    {
        field(10; "Rent Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Rent Item Category".Code;
        }
        field(20; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Rent Item Category Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

