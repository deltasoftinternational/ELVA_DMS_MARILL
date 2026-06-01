tableextension 25006151 "Fixed Asset" extends "Fixed Asset" //5600
{
    // 02.08.2018 EB.P30 Rent
    //   Added field:
    //     25006804"Model Commercial Name"
    // 
    // 05.03.2014 Elva Baltic P7 #S0017 MMG7.00
    //   * Added fields:
    //     - "Sales Date"
    //     - "Fuel Type"
    // 
    // 04.03.2014 Elva Baltic P7 #S0017 MMG7.00
    //   * Added fields:
    //     - "Vehicle Serial No."
    //     - "VIN"
    //     - "Make Code"
    //     - "Model Code"
    fields
    {
        field(25006000; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";

            trigger OnValidate()
            begin
                if Vehicle.Get(xRec."Vehicle Serial No.") then begin
                    Vehicle."Fixed Asset No." := '';
                    Vehicle.Modify;
                end;
                if Vehicle.Get("Vehicle Serial No.") then begin
                    Vehicle."Fixed Asset No." := "No.";
                    Vehicle.Modify;
                end;
                CalcFields(VIN, "Make Code", "Model Code", "Sales Date", "Fuel Type");
            end;
        }
        field(25006001; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006002; "Make Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006003; "Model Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Serial No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006004; "Sales Date"; Date)
        {
            CalcFormula = lookup(Vehicle."Sales Date" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Sales Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006005; "Fuel Type"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Variable Field 25006800" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Fuel Type';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006600; "Model Commercial Name"; Text[50])
        {
            CalcFormula = lookup(Model."Commercial Name" where("Make Code" = field("Make Code"),
                                                                Code = field("Model Code")));
            Description = 'RENT1.0';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key11; "FA Location Code", "Responsible Employee")
        {
        }
        key(Key12; "Responsible Employee", "FA Location Code")
        {
        }
    }

    var
        Vehicle: Record Vehicle;
        OKConfirm: Boolean;
        Text26512: label 'Do you want to assign new %1 %2 to Fixed Asset %3?';
        Text26513: label 'Selected Fixed Asset %1 is disposed and FA Location/Responsible Employee cannot be assigned to it.';
        Text26514: label 'Do you want to print FA assignment\discharge report?';

}
