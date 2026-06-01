//Table 25006013 "Vehicle Contact"
Table 25006273 "Vehicle Contact"
{
    Caption = 'Vehicle Contact';
    DrillDownPageID = "Vehicle Contacts";
    LookupPageID = "Vehicle Contacts";

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "Relationship Code"; Code[20])
        {
            Caption = 'Relationship Code';
            TableRelation = "Vehicle-Contact Relationship";

            trigger OnValidate()
            begin
                if "Relationship Code" <> '' then begin
                    if VehicleContactRelationship.Get("Relationship Code") then
                        "Do Not Use In Service" := VehicleContactRelationship."Do Not Use In Service";
                end else
                    "Do Not Use In Service" := false;
            end;
        }
        field(30; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;

            trigger OnValidate()
            begin
                CalcFields("Contact Name");
            end;
        }
        field(40; "Contact Name"; Text[100])
        {
            CalcFormula = lookup(Contact.Name where("No." = field("Contact No.")));
            Caption = 'Contact Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Make Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Make;
        }
        field(72; "Model Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(110; "Do Not Use In Service"; Boolean)
        {
            Caption = 'Don''t Use In Service';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Relationship Code", "Contact No.")
        {
            Clustered = true;
        }
        key(Key2; "Contact No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        VehicleContactRelationship: Record "Vehicle-Contact Relationship";
}

