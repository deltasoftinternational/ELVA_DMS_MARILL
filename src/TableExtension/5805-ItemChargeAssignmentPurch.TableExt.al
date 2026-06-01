tableextension 25006134 "Item Charge Assignment (Purch)" extends "Item Charge Assignment (Purch)" //5805
{
    // 09.01.2014 EDMS P15
    //   * Type of "Vehicle Accounting Cycle No." changed from FlowField to Normal ones

    fields
    {
        field(25006010; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
                Model: Record Model;
                DocumentMgt: Codeunit DocumentManagementDMS;
                FillCustomer: Boolean;
            begin
                CalcFields(VIN, "Make Code", "Model Code", "Model Version No.");   //09.01.2014 EDMS P15
            end;
        }
        field(25006020; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            FieldClass = Normal;
        }
        field(25006030; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                Vehicle: Record Vehicle;
            begin
            end;

            trigger OnValidate()
            var
                recVehicle: Record Vehicle;
                bFillCustomer: Boolean;
            begin
            end;
        }
        field(25006040; "Make Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006050; "Model Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006060; "Model Version No."; Code[20])
        {
            CalcFormula = lookup(Item."No." where("Item Type" = const("Model Version"),
                                                   "Make Code" = field("Make Code"),
                                                   "Model Code" = field("Model Code")));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }

    }

}