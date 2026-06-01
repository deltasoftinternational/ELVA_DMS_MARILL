Table 25006408 "Warranty Setup"
{
    Caption = 'Warranty Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Warranty Document Nos."; Code[10])
        {
            Caption = 'Warranty Document Nos.';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

