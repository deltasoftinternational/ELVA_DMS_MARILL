Table 25006389 "Vehicle Opt. Setup"
{
    // 20.07.2004 EDMS P1
    //   * Created

    Caption = 'Vehicle Option Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Functionality Activated"; Boolean)
        {
            Caption = 'Functionality Activated';
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

