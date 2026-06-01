Table 25006065 "Nonstock Item Entry Reference"
{
    Caption = 'Nonstock Item Entry Reference';

    fields
    {
        field(10; "Sortformat Item No."; Code[20])
        {
            Caption = 'Sortformat Item No.';
        }
        field(30; "Entry Format Item No."; Code[24])
        {
            Caption = 'Entry Format Item No.';
        }
    }

    keys
    {
        key(Key1; "Sortformat Item No.")
        {
            Clustered = true;
        }
        key(Key2; "Entry Format Item No.")
        {
        }
    }

    fieldgroups
    {
    }
}

