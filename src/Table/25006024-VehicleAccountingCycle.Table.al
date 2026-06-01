Table 25006024 "Vehicle Accounting Cycle"
{
    Caption = 'Vehicle Accounting Cycle';
    LookupPageID = "Vehicle Accounting Cycles";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(30; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(40; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
        }
        field(50; Default; Boolean)
        {
            Caption = 'Default';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Vehicle Serial No.")
        {
        }
    }

    fieldgroups
    {
    }
}

