Table 25006068 "Deal Type"
{
    // 07.09.2018 EB.P30
    //   Added field:
    //     40 "Ordering Price Type Code"

    Caption = 'Deal Type';
    LookupPageID = "Deal Types";

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Vehicle Not Mandatory"; Boolean)
        {
            Caption = 'Vehicle Not Mandatory';
            DataClassification = ToBeClassified;
        }
        field(40; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Ordering Price Type";
        }
        field(100; "Mandatory Checklist Category"; Code[20])
        {
            Caption = 'Mandatory Checklist Category 1';
            TableRelation = "Checklist Category";
        }
        field(110; "Mandatory Checklist Category 2"; Code[20])
        {
            Caption = 'Mandatory Checklist Category 2';
            TableRelation = "Checklist Category";
        }
        field(120; "Mandatory Checklist Category 3"; Code[20])
        {
            Caption = 'Mandatory Checklist Category 3';
            TableRelation = "Checklist Category";
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

