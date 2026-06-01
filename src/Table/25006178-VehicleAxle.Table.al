Table 25006178 "Vehicle Axle"
{
    Caption = 'Vehicle Axle';
    LookupPageID = "Vehicle Axles";

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(40; Available; Boolean)
        {
            CalcFormula = exist("Vehicle Tire Position" where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                               "Axle Code" = field(Code),
                                                               Available = const(true)));
            Caption = 'Available';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TireEntry.Reset;
        TireEntry.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        TireEntry.SetRange("Vehicle Axle Code", Code);
        if TireEntry.FindFirst then
            Error(Text001, Rec.TableCaption, "Vehicle Serial No." + ' ' + Code, TireEntry.TableCaption);
        VehicleTirePosition.Reset;
        VehicleTirePosition.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleTirePosition.SetRange("Axle Code", Code);
        VehicleTirePosition.DeleteAll(true);
    end;

    var
        TireEntry: Record "Tire Entry";
        Text001: label 'You cannot delete %1 %2 because there are records in related %3.';
        VehicleTirePosition: Record "Vehicle Tire Position";
}

