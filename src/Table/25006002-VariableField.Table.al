Table 25006002 "Variable Field"
{
    Caption = 'Variable Field';
    LookupPageID = "Variable Fields";

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; Caption; Text[30])
        {
            Caption = 'Caption';
        }
        field(30; "Make Dependent Lookup"; Boolean)
        {
            Caption = 'Make Dependent Lookup';
        }
        field(40; "Variable Field Group Code"; Code[10])
        {
            Caption = 'Variable Field Group Code';
            TableRelation = "Variable Field Group";
        }
        field(50; "Use Translations"; Boolean)
        {
            Caption = 'Use Translations';
        }
        field(60; "Use In Filtering"; Boolean)
        {
            Caption = 'Use In Filtering';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Variable Field Group Code")
        {
        }
    }

    fieldgroups
    {
    }
}

