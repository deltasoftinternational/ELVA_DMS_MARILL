Table 25006059 "Contract Vehicle"
{
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added CaptionML to field:
    //     "Vehicle Serial No."
    // 
    // 07.04.2014 Elva Balticv P15 # MMG7.00
    //   * initial creation

    Caption = 'Contract Vehicle';
    LookupPageID = "Contract Vehicles";

    fields
    {
        field(5; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            OptionCaption = 'Quote,Contract';
            OptionMembers = Quote,Contract;
        }
        field(10; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";
        }
        field(20; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                RentAsset: Record "Rent Asset";
            begin
                RentAsset.Reset();
                RentAsset.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
                if RentAsset.FindFirst then
                    "Rent Asset No." := RentAsset."No.";
            end;
        }
        field(30; "Veh. Make Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Veh. Model Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Veh. Model Version No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Version No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            FieldClass = FlowField;
        }
        field(70; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            TableRelation = "Rent Asset";

            trigger OnValidate()
            var
                RentAsset: Record "Rent Asset";
            begin
                if RentAsset.Get("Rent Asset No.") then
                    if RentAsset."Vehicle Serial No." <> '' then
                        "Vehicle Serial No." := RentAsset."Vehicle Serial No.";
            end;
        }
        field(51300; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }

    keys
    {
        key(Key1; "Contract Type", "Contract No.", "Vehicle Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnRename()
    var
        Contract: Record Contract;
    begin
        Contract.Get("Contract No.");
        Contract.TestField(Status, Contract.Status::Inactive);
    end;

    trigger OnInsert()
    var
        Contract: Record Contract;
    begin
        Contract.Get("Contract No.");
        Contract.TestField(Status, Contract.Status::Inactive);
    end;

    trigger OnModify()
    var
        Contract: Record Contract;
    begin
        Contract.Get("Contract No.");
        Contract.TestField(Status, Contract.Status::Inactive);
    end;

    trigger OnDelete()
    var
        Contract: Record Contract;
    begin
        Contract.Get("Contract No.");
        Contract.TestField(Status, Contract.Status::Inactive);
    end;


    procedure CreateRentAsset()
    var
        Vehicle: Record Vehicle;
        RentAsset: Record "Rent Asset";
        tcAMT001: label 'VIN %1 already exists.';
    begin
        if "Vehicle Serial No." = '' then
            exit
        else
            if not Vehicle.Get("Vehicle Serial No.") then
                exit;

        if "Rent Asset No." <> '' then
            exit;

        RentAsset.Reset;

        RentAsset.Init;
        RentAsset.Validate("Vehicle Serial No.", "Vehicle Serial No.");
        RentAsset.Validate("Make Code", Vehicle."Make Code");
        RentAsset.Validate("Model Code", Vehicle."Model Code");
        RentAsset.Validate("Serial No.", Vehicle.VIN);
        RentAsset.Insert(true);

        "Rent Asset No." := RentAsset."No.";
        Modify();

        Commit;
        Page.RunModal(Page::"Rent Asset Card", RentAsset);
    end;
}
