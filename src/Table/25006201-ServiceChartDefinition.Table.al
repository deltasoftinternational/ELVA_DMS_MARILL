Table 25006201 "Service Chart Definition"
{

    fields
    {
        field(10; "Profile ID"; Code[30])
        {
            Caption = 'Profile ID';
            TableRelation = "All Profile";
        }
        field(20; "Codeunit ID"; Integer)
        {
            Caption = 'Codeunit ID';
        }
        field(30; "Chart Name"; Text[60])
        {
            Caption = 'Chart Name';
        }
        field(40; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
    }

    keys
    {
        key(Key1; "Profile ID", "Codeunit ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

