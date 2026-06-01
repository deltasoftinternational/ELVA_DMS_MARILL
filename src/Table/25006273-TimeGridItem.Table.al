//Table 25006273 "Time Grid Item"
Table 25006013 "Time Grid Item"
{
    // SPLANNER - SYSTEM TABLE

    Caption = 'Time Grid Item';

    fields
    {
        field(1; "Grid Code"; Code[20])
        {
            Caption = 'Grid Code';
            TableRelation = "Time Grid";
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Time Start"; Time)
        {
            Caption = 'Time Start';
        }
        field(4; "Time End"; Time)
        {
            Caption = 'Time End';
        }
    }

    keys
    {
        key(Key1; "Grid Code", "Time Start")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

