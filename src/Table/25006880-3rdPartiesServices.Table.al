Table 25006880 "3rd Parties Services"
{
    Caption = '3rd Parties Services';

    fields
    {
        field(10; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(40; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
        field(50; "End point URL 1"; Text[250])
        {
            Caption = 'End point URL 1';
        }
        field(60; "End point URL 2"; Text[250])
        {
            Caption = 'End point URL 2';
        }
        field(70; "End point URL 3"; Text[250])
        {
            Caption = 'End point URL 3';
        }
        field(80; "API Key"; Text[250])
        {
            Caption = 'API Key';
        }
        field(90; "User Name"; Text[100])
        {
            Caption = 'User Name';
        }
        field(100; Password; Text[100])
        {
            Caption = 'Password';
        }
        field(110; "Tokens Enabled"; Boolean)
        {
            Caption = 'Tokens Enabled';
        }
    }

    keys
    {
        key(Key1; "Service Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

