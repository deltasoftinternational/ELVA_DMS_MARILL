Table 25006571 "Create Next To-Do"
{
    Caption = 'Create Next To-Do';

    fields
    {
        field(20; "Row No."; Integer)
        {
            Caption = 'Row No.';
        }
        field(30; "Next To-Do Interaction Code"; Code[10])
        {
            Caption = 'Next To-Do Interaction Code';
            TableRelation = "Interaction Template";
        }
        field(40; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(41; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(42; "From Time"; Time)
        {
            Caption = 'From Time';
        }
        field(50; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(60; "To Time"; Time)
        {
            Caption = 'To Time';
        }
    }

    keys
    {
        key(Key1; "Row No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

