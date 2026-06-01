Table 25006010 "Vehicle Component"
{
    Caption = 'Vehicle Component';
    DrillDownPageID = "Vehicle Components";
    LookupPageID = "Vehicle Components";

    fields
    {
        field(10; "Parent Vehicle Serial No."; Code[20])
        {
            Caption = 'Parent Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";
        }
        field(15; "Line No."; Integer)
        {
            Caption = 'Line No.';

            trigger OnValidate()
            begin
                if "Line No." = 0 then begin
                    VehicleComponent.Reset;
                    VehicleComponent.SetRange("Parent Vehicle Serial No.", "Parent Vehicle Serial No.");
                    if VehicleComponent.FindLast then
                        "Line No." := VehicleComponent."Line No.";
                    "Line No." += 10000;
                end;
            end;
        }
        field(20; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = Vehicle."Serial No.";

            trigger OnValidate()
            begin
                if "No." <> '' then begin
                    if Description = '' then begin
                        Vehicle.Get("No.");
                        Description := Vehicle."Make Code" + ' ' + Vehicle."Model Code";
                    end;
                    if "Date Installed" = 0D then
                        "Date Installed" := Today;
                end;
                if "No." = "Parent Vehicle Serial No." then
                    Error(Text001);
            end;
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(40; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(50; "Date Installed"; Date)
        {
            Caption = 'Date Installed';
        }
        field(60; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
        }
    }

    keys
    {
        key(Key1; "Parent Vehicle Serial No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Validate(Active, true);
        Validate("Line No.");
        TestField("Parent Vehicle Serial No.");
    end;

    trigger OnModify()
    begin
        Validate("Last Date Modified", Today);
    end;

    var
        Vehicle: Record Vehicle;
        VehicleComponent: Record "Vehicle Component";
        Text001: label 'Parent and component the same is unpossible.';
}

