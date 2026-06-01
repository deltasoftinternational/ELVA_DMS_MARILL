Table 25006003 "Variable Field Translation"
{
    Caption = 'Variable Field Translation';

    fields
    {
        field(10; "Variable Field Code"; Code[10])
        {
            Caption = 'Variable Field Code';
            TableRelation = "Variable Field";
        }
        field(20; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Variable Field Code", "Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

