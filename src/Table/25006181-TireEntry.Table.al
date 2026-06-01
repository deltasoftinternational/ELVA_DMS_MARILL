Table 25006181 "Tire Entry"
{
    Caption = 'Tire Entry';
    DrillDownPageID = "Tire Entries";
    LookupPageID = "Tire Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";
        }
        field(30; "Vehicle Axle Code"; Code[10])
        {
            Caption = 'Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(40; "Tire Position Code"; Code[10])
        {
            Caption = 'Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                "Axle Code" = field("Vehicle Axle Code"));
        }
        field(50; "Tire Code"; Code[20])
        {
            Caption = 'Tire Code';
            TableRelation = Tire.Code;
        }
        field(60; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Put on,Take off';
            OptionMembers = "Put on","Take off";
        }
        field(70; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(80; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(90; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006181,90';
            Description = 'Supposed to store mileage of a car';
        }
        field(91; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006181,91';
        }
        field(92; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006181,92';
        }
        field(100; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(110; "Service Ledger Entry No."; Integer)
        {
            Caption = 'Service Ledger Entry No.';
            TableRelation = "Service Ledger Entry EDMS"."Entry No.";
        }
        field(120; "Variable Field Tire Run"; Decimal)
        {
            CaptionClass = '7,25006181,120';
            Caption = 'Tire Kilometers';
            Description = 'how many passed by that Tire';
        }
        field(130; "Tire Description"; Text[250])
        {
            CalcFormula = lookup(Tire.Description where(Code = field("Tire Code")));
            Caption = 'Tire Description';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Vehicle Serial No.", "Vehicle Axle Code", "Tire Position Code", "Tire Code")
        {
        }
        key(Key3; "Tire Code")
        {
            SumIndexFields = "Variable Field Tire Run", "Variable Field Run 1";
        }
        key(Key4; "Document No.", "Posting Date")
        {
        }
        key(Key5; "Vehicle Serial No.", "Vehicle Axle Code", "Tire Position Code", Open)
        {
        }
    }

    fieldgroups
    {
    }
}

