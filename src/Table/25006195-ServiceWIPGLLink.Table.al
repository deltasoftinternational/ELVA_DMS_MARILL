Table 25006195 "Service WIP - G/L Link"
{

    fields
    {
        field(10; "WIP Entry No."; Integer)
        {
        }
        field(20; "G/L Entry No."; Integer)
        {
        }
        field(30; "G/L Register No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "WIP Entry No.", "G/L Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

