Table 25006278 "Time Grid"
{
    // 28.08.2007. EDMS P2
    //   * Created

    Caption = 'Time Grid';
    LookupPageID = "Time Grids";

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
}

