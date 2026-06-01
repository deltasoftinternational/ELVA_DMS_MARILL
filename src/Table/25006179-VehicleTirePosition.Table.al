Table 25006179 "Vehicle Tire Position"
{
    Caption = 'Vehicle Tire Position';
    LookupPageID = "Vehicle Tire Positions";

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";
        }
        field(20; "Axle Code"; Code[10])
        {
            Caption = 'Axle Code';
            TableRelation = "Vehicle Axle".Code where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(30; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(40; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(50; Available; Boolean)
        {
            CalcFormula = - exist("Tire Entry" where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                     "Vehicle Axle Code" = field("Axle Code"),
                                                     "Tire Position Code" = field(Code),
                                                     Open = const(true)));
            Caption = 'Available';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Axle Code", "Code")
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
        TireEntry.SetRange("Vehicle Axle Code", "Axle Code");
        TireEntry.SetRange("Tire Position Code", Code);
        if TireEntry.FindFirst then
            Error(Text001, Rec.TableCaption, Code, TireEntry.TableCaption);
    end;

    var
        TireEntry: Record "Tire Entry";
        Text001: label 'You cannot delete %1 %2 because there are one or records in %3.';
}

