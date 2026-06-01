Table 25006763 "Ordering Price Type"
{
    Caption = 'Ordering Price Type';
    LookupPageID = "Ordering Price Types";

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
        field(30; "Inbound Time"; DateFormula)
        {
            Caption = 'Inbound Time';
        }
        field(40; "Outbound Time"; DateFormula)
        {
            Caption = 'Outbound Time';
        }
        field(50; "Def. Purch. Transport Method"; Code[10])
        {
            Caption = 'Default Purchase Transport Method';
            DataClassification = ToBeClassified;
            TableRelation = "Transport Method";
        }
        field(60; "Separate P. Ord. per Vehicle"; Boolean)
        {
            Caption = 'Separate Purchase Order per Vehicle';
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

