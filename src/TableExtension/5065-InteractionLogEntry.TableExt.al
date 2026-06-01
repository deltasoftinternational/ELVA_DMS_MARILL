tableextension 25006123 "Interaction Log Entry" extends "Interaction Log Entry" //5065
{
    // 30-07-2007 EDMS P3
    //   * New function DrillDownComment
    fields
    {
        field(25006000; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(25006010; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006020; "Make Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006030; "Model Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006040; "Model Version No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Version No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Registration No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key19; "Vehicle Serial No.")
        {
        }
    }
    procedure DrillDownComment()
    var
        Comm: Record "Inter. Log Entry Comment Line";
    begin
        Comm.SetRange("Entry No.", "Entry No.");
        Page.Run(Page::"Inter. Log Entry Comment Sheet", Comm);
    end;
}