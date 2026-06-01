Table 25006038 "Vehicle Warranty Usage"
{
    Caption = 'Vehicle Warranty Usage';

    fields
    {
        field(2; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(4; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(6; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));

            trigger OnLookup()
            var
                Item: Record Item;
            begin
                Item.Reset;
                if LookUpMgt.LookUpModelVersion(Item, "Model Version No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", Item."No.");
            end;
        }
        field(8; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status";
        }
        field(20; "Warranty Type Code"; Code[20])
        {
            Caption = 'Warranty Type Code';
            TableRelation = "Vehicle Warranty Type";

            trigger OnValidate()
            var
                VehicleWarrantyType: Record "Vehicle Warranty Type";
            begin
                if VehicleWarrantyType.Get("Warranty Type Code") then begin
                    "Term Date Formula" := VehicleWarrantyType."Term Date Formula";
                    "Variable Field Run 1" := VehicleWarrantyType."Variable Field Run 1";
                    "Variable Field Run 2" := VehicleWarrantyType."Variable Field Run 2";
                    "Variable Field Run 3" := VehicleWarrantyType."Variable Field Run 3";
                end;
            end;
        }
        field(30; "Term Date Formula"; DateFormula)
        {
            Caption = 'Term Date Formula';
        }
        field(40; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006038,40';
        }
        field(41; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006038,41';
        }
        field(42; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006038,42';
        }
    }

    keys
    {
        key(Key1; "Make Code", "Model Code", "Model Version No.", "Vehicle Status Code", "Warranty Type Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        LookUpMgt: Codeunit LookUpManagement;
        VFMgt: Codeunit "Variable Field Management";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Vehicle Warranty Usage", intFieldNo));
    end;
}

