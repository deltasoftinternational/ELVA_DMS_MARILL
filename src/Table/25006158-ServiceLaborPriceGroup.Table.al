Table 25006158 "Service Labor Price Group"
{
    Caption = 'Service Labor Price Group';
    LookupPageID = "Service Labor Price Groups";

    fields
    {
        field(10; "No."; Code[10])
        {
            Caption = 'No.';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

