Table 25006126 "Vehicle Service Plan"
{
    Caption = 'Vehicle Service Plan';
    LookupPageID = "Vehicle Service Plans";

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "No."; Code[10])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    ServiceSetup.Get;
                    NoSeriesMgt.TestManual(ServiceSetup."Service Plan Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(50; "Service Plan Type"; Code[10])
        {
            Caption = 'Service Plan Type';
            TableRelation = "Service Plan Type";
        }
        field(70; Active; Boolean)
        {
            CalcFormula = exist("Vehicle Service Plan Stage" where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                    "Plan No." = field("No."),
                                                                    Status = const(Pending)));
            Caption = 'Active';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Template Code"; Code[10])
        {
            Caption = 'Template Code';
            Editable = false;
            TableRelation = "Service Plan Template";
        }
        field(140; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(150; "Start Date"; Date)
        {
            Caption = 'Start Date';
            Description = 'date of plan to begin';
        }
        field(160; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Description = 'date of record has been created';
        }
        field(161; "Start Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006126,161';
        }
        field(170; "Start Variable Field Run 2"; Decimal)
        {
            CaptionClass = '7,25006126,170';
        }
        field(180; "Start Variable Field Run 3"; Decimal)
        {
            CaptionClass = '7,25006126,180';
        }
        field(190; Adjust; Boolean)
        {
            Caption = 'Adjust';
        }
        field(200; Recurring; Boolean)
        {
            Caption = 'Recurring';
            Description = 'Auto Assign Tewplate';
        }
        field(210; "Auto Order By Exp. Date"; Boolean)
        {
            Caption = 'Auto Order By Exp. Date';
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

    trigger OnDelete()
    var
        VehServPlanStage: Record "Vehicle Service Plan Stage";
        ServPlanComment: Record "Service Plan Comment Line";
    begin
        VehServPlanStage.Reset;
        VehServPlanStage.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        VehServPlanStage.SetRange("Plan No.", "No.");
        VehServPlanStage.DeleteAll(true);

        ServPlanComment.Reset;
        ServPlanComment.SetRange(Type, ServPlanComment.Type::Plan);
        ServPlanComment.SetRange("Plan No.", "No.");
        ServPlanComment.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        ServPlanComment.DeleteAll;
    end;

    trigger OnInsert()
    var
        Vehicle: Record Vehicle;
    begin
        if not Vehicle.Get("Vehicle Serial No.") then
            Error(StrSubstNo(Text001, "Vehicle Serial No."));

        if "No." = '' then begin
            ServiceSetup.Get;
            ServiceSetup.TestField("Service Plan Nos.");
            "No. Series" := ServiceSetup."Service Plan Nos.";
            "No." := NoSeriesMgt.GetNextNo("No. Series", 0D, true);
        end;
        Validate("Creation Date", WorkDate);
        if "Start Date" = 0D then
            Validate("Start Date", WorkDate);
    end;

    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        NoSeriesMgt: Codeunit "No. Series";
        ServicePlan: Record "Vehicle Service Plan";
        Text001: label 'Vehicle with serial No. %1 does not exist.';
        VFMgt: Codeunit "Variable Field Management";


    procedure AssistEdit(OldPlan: Record "Vehicle Service Plan"): Boolean
    begin
        ServicePlan := Rec;
        ServiceSetup.Get;
        ServiceSetup.TestField("Service Plan Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(ServiceSetup."Service Plan Nos.", OldPlan."No. Series", ServicePlan."No. Series") then begin
            ServicePlan."No." := NoSeriesMgt.GetNextNo(ServicePlan."No. Series", WorkDate(), true);
            Rec := ServicePlan;
            exit(true);
        end;
    end;

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Vehicle Service Plan", FieldNo));
    end;
}

