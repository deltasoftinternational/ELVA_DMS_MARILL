Table 25006293 "Vehicle Telematics"
{
    Caption = 'Vehicle Telematics';

    fields
    {
        field(10; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
        }
        field(30; "Make Code"; Code[20])
        {
        }
        field(40; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            begin
                if Vehicle.Get("Vehicle Serial No.") then begin
                    "Make Code" := Vehicle."Make Code";
                    "Model Code" := Vehicle."Model Code";
                end;
            end;
        }
        field(50; "Date Stamp"; Date)
        {
            Caption = 'Date Stamp';
        }
        field(70; Latitude; Decimal)
        {
            Caption = 'Latitude';
            DecimalPlaces = 6 : 6;
        }
        field(80; Longitude; Decimal)
        {
            Caption = 'Longitude';
            DecimalPlaces = 6 : 6;
        }
        field(90; "Fuel Used"; Decimal)
        {
            Caption = 'Fuel Used';
        }
        field(100; "Fuel Used Unit Code"; Text[30])
        {
            Caption = 'Fuel Used Unit Code';
        }
        field(110; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006293,110';
            DecimalPlaces = 0 : 0;
        }
        field(120; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006293,120';
        }
        field(130; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006293,130';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Date Stamp", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vehicle: Record Vehicle;
        VFMgt: Codeunit "Variable Field Management";

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Vehicle Telematics", FieldNo));
    end;
}

