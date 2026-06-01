Table 25006056 "Segment SubLine"
{
    Caption = 'Segment SubLine';
    DrillDownPageID = "Segment Sublines";
    LookupPageID = "Segment Sublines";

    fields
    {
        field(1; "Segment No."; Code[20])
        {
            Caption = 'Segment No.';
            TableRelation = "Segment Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Contact No."; Code[20])
        {
            CalcFormula = lookup("Segment Line"."Contact No." where("Segment No." = field("Segment No."),
                                                                     "Line No." = field("Line No.")));
            Caption = 'Contact No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Vehicle Contact"."Contact No.";

            trigger OnValidate()
            var
                SegInteractLanguage: Record "Segment Interaction Language";
                Attachment: Record Attachment;
                InteractTmpl: Record "Interaction Template";
            begin
            end;
        }
        field(4; "SubLine No."; Integer)
        {
        }
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = "Vehicle Contact"."Vehicle Serial No." where("Contact No." = field("Contact No."));

            trigger OnLookup()
            var
                SegmentLine: Record "Segment Line";
                VehicleContact: Record "Vehicle Contact";
            begin
                if SegmentLine.Get("Segment No.", "Line No.") then begin
                    VehicleContact.Reset;
                    VehicleContact.SetRange("Contact No.", SegmentLine."Contact No.");
                    if Page.RunModal(0, VehicleContact) = Action::LookupOK then
                        Validate("Vehicle Serial No.", VehicleContact."Vehicle Serial No.");
                end;
            end;
        }
        field(20; "Make Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Make Code';
            FieldClass = FlowField;
            NotBlank = true;
            TableRelation = Make;
        }
        field(30; "Model Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Code';
            FieldClass = FlowField;
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(40; "Model Version No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Version No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Version No.';
            FieldClass = FlowField;

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
            end;
        }
        field(50; "Model Commercial Name"; Text[50])
        {
            CalcFormula = lookup(Model."Commercial Name" where("Make Code" = field("Make Code"),
                                                                Code = field("Model Code")));
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Segment No.", "Line No.", "SubLine No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

