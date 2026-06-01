Table 25006202 "Service Last Used Chart"
{

    fields
    {
        field(1; UID; Code[50])
        {
            Caption = 'UID';
        }
        field(2; "Codeunit ID"; Integer)
        {
            Caption = 'Codeunit ID';
        }
        field(3; "Chart Name"; Text[60])
        {
            Caption = 'Chart Name';
        }
    }

    keys
    {
        key(Key1; UID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

