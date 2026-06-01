Table 25006043 "Vehicle Statistics Buffer"
{
    Caption = 'Vehicle Statistics Buffer';

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(20; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
        }
        field(25; Sequence; Integer)
        {
            Caption = 'Sequence';
        }
        field(30; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
        }
        field(40; "Field Value"; Decimal)
        {
            Caption = 'Field Value';
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Vehicle Accounting Cycle No.", Sequence, "Field Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

