Table 25006770 "Integration Setup EDMS"
{
    // #Owner EDMS.Integration

    Caption = 'Integration Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(100; "Integration Is Active"; Boolean)
        {
            Caption = 'Integration Is Active';
        }
        field(110; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
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


    procedure ActivateIntegration()
    begin
        TestField("Integration Is Active", false);
        "Integration Is Active" := true;
        Modify;
    end;


    procedure DeactivateIntegration()
    begin
        TestField("Integration Is Active", true);
        "Integration Is Active" := false;
        Modify;
    end;
}

