Table 25006023 "Vehicle Type"
{
    Caption = 'Vehicle Type';
    LookupPageID = "Vehicle Types";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(25006310; "Check VF Run 1 on Release"; Boolean)
        {
            CaptionClass = '7,25006023,25006310';
        }
        field(25006311; "Check VF Run 2 on Release"; Boolean)
        {
            CaptionClass = '7,25006023,25006311';
        }
        field(25006312; "Check VF Run 3 on Release"; Boolean)
        {
            CaptionClass = '7,25006023,25006312';
        }
    }
    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        VFMgt: Codeunit "Variable Field Management";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Vehicle Type", intFieldNo));
    end;
}

