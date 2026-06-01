Table 25006172 "Recall Campaign Vehicle"
{
    Caption = 'Recall Campaign Vehicle';

    fields
    {
        field(10; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = "Recall Campaign";
        }
        field(20; VIN; Code[20])
        {
            Caption = 'VIN';

            trigger OnLookup()
            begin
                Vehicle.Reset;
                Vehicle.SetCurrentkey(VIN);
                Vehicle.SetRange(VIN);
                if Vehicle.FindFirst then;
                if LookUpMgt.LookUpVehicleAMT(Vehicle, Vehicle."Serial No.") then
                    Validate(VIN, Vehicle.VIN);
            end;
        }
        field(40; Exists; Boolean)
        {
            CalcFormula = exist(Vehicle where(VIN = field(VIN)));
            Caption = 'Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; Serviced; Boolean)
        {
            Caption = 'Serviced';
        }
        field(60; "Active Campaign"; Boolean)
        {
            CalcFormula = lookup("Recall Campaign".Active where("No." = field("Campaign No.")));
            Caption = 'Active Campaign';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Campaign No.", VIN)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        LookUpMgt: Codeunit LookUpManagement;
        Vehicle: Record Vehicle;
}

