Table 25006036 "Vehicle Warranty"
{
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added field Description, "Ending Date"

    Caption = 'Vehicle Warranty';
    LookupPageID = "Vehicle Warranty List";

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    ServiceSetup.Get;
                    NoSeriesMgt.TestManual(ServiceSetup."Warranty Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(30; "Warranty Type Code"; Code[20])
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
        field(40; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" <> 0D) and (Format("Term Date Formula") <> '') then begin
                    "Ending Date" := CalcDate("Term Date Formula", "Starting Date");
                end;
            end;
        }
        field(60; "Term Date Formula"; DateFormula)
        {
            Caption = 'Term Date Formula';

            trigger OnValidate()
            begin
                if ("Starting Date" <> 0D) and (Format("Term Date Formula") <> '') then begin
                    "Ending Date" := CalcDate("Term Date Formula", "Starting Date");
                end;
            end;
        }
        field(70; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006036,70';
            Description = 'Kilometrage Limit';
        }
        field(71; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006036,71';
        }
        field(72; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006036,72';
        }
        field(80; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Active,Not Active';
            OptionMembers = Active,"Not Active";
        }
        field(140; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(200; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(210; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006036,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
                Vehicle: Record Vehicle;
            begin
                if Vehicle.Get("Vehicle Serial No.") then;
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Vehicle Warranty", FieldNo("Variable Field 25006800"),
                  Vehicle."Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006036,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
                Vehicle: Record Vehicle;
            begin
                if Vehicle.Get("Vehicle Serial No.") then;
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Vehicle Warranty", FieldNo("Variable Field 25006801"),
                  Vehicle."Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006036,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
                Vehicle: Record Vehicle;
            begin
                if Vehicle.Get("Vehicle Serial No.") then;
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Vehicle Warranty", FieldNo("Variable Field 25006802"),
                  Vehicle."Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006803; "Variable Field 25006803"; Code[20])
        {
            CaptionClass = '7,25006036,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
                Vehicle: Record Vehicle;
            begin
                if Vehicle.Get("Vehicle Serial No.") then;
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Vehicle Warranty", FieldNo("Variable Field 25006803"),
                  Vehicle."Make Code", "Variable Field 25006803") then begin
                    Validate("Variable Field 25006803", VFOptions.Code);
                end;
            end;
        }
        field(25006804; "Variable Field 25006804"; Code[20])
        {
            CaptionClass = '7,25006036,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
                Vehicle: Record Vehicle;
            begin
                if Vehicle.Get("Vehicle Serial No.") then;
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Vehicle Warranty", FieldNo("Variable Field 25006804"),
                  Vehicle."Make Code", "Variable Field 25006804") then begin
                    Validate("Variable Field 25006804", VFOptions.Code);
                end;
            end;
        }
        field(25006805; "Variable Field 25006805"; Code[20])
        {
            CaptionClass = '7,25006036,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
                Vehicle: Record Vehicle;
            begin
                if Vehicle.Get("Vehicle Serial No.") then;
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Vehicle Warranty", FieldNo("Variable Field 25006805"),
                  Vehicle."Make Code", "Variable Field 25006805") then begin
                    Validate("Variable Field 25006805", VFOptions.Code);
                end;
            end;
        }
        field(25006806; "Variable Field 25006806"; Code[20])
        {
            CaptionClass = '7,25006036,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
                Vehicle: Record Vehicle;
            begin
                if Vehicle.Get("Vehicle Serial No.") then;
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Vehicle Warranty", FieldNo("Variable Field 25006806"),
                  Vehicle."Make Code", "Variable Field 25006806") then begin
                    Validate("Variable Field 25006806", VFOptions.Code);
                end;
            end;
        }
        field(25006807; "Variable Field 25006807"; Code[20])
        {
            CaptionClass = '7,25006036,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
                Vehicle: Record Vehicle;
            begin
                if Vehicle.Get("Vehicle Serial No.") then;
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Vehicle Warranty", FieldNo("Variable Field 25006807"),
                  Vehicle."Make Code", "Variable Field 25006807") then begin
                    Validate("Variable Field 25006807", VFOptions.Code);
                end;
            end;
        }
        field(25006808; "Variable Field 25006808"; Code[20])
        {
            CaptionClass = '7,25006036,25006808';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
                Vehicle: Record Vehicle;
            begin
                if Vehicle.Get("Vehicle Serial No.") then;
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Vehicle Warranty", FieldNo("Variable Field 25006808"),
                  Vehicle."Make Code", "Variable Field 25006808") then begin
                    Validate("Variable Field 25006808", VFOptions.Code);
                end;
            end;
        }
        field(25006809; "Variable Field 25006809"; Code[20])
        {
            CaptionClass = '7,25006036,25006809';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
                Vehicle: Record Vehicle;
            begin
                if Vehicle.Get("Vehicle Serial No.") then;
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Vehicle Warranty", FieldNo("Variable Field 25006809"),
                  Vehicle."Make Code", "Variable Field 25006809") then begin
                    Validate("Variable Field 25006809", VFOptions.Code);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            ServiceSetup.Get;
            ServiceSetup.TestField("Warranty Nos.");
            "No. Series" := ServiceSetup."Warranty Nos.";
            "No." := NoSeriesMgt.GetNextNo("No. Series", 0D, true);
        end;
    end;

    var
        VFMgt: Codeunit "Variable Field Management";
        LookupMgt: Codeunit LookUpManagement;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        NoSeriesMgt: Codeunit "No. Series";
        VehWarranty: Record "Vehicle Warranty";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Vehicle Warranty", intFieldNo));
    end;


    procedure AssistEdit(OldWarranty: Record "Vehicle Warranty"): Boolean
    begin
        VehWarranty := Rec;
        ServiceSetup.Get;
        ServiceSetup.TestField("Warranty Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(ServiceSetup."Warranty Nos.", OldWarranty."No. Series", VehWarranty."No. Series") then begin
            VehWarranty."No." := NoSeriesMgt.GetNextNo(VehWarranty."No. Series", WorkDate(), true);
            Rec := VehWarranty;
            exit(true);
        end;
    end;
}

