Table 25006132 "Vehicle Service Plan Stage"
{
    // 22.03.2013 EDMS P8
    //   * Added option to Status field: Skipped
    // 
    // 2012.07.31 EDMS, P8
    //   * changed type of field 36 - now it is decimal
    //   * added fields: VF Initial Run 1,...

    Caption = 'Vehicle Service Plan Stage';
    LookupPageID = "Vehicle Service Plan Stages";

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "Plan No."; Code[10])
        {
            Caption = 'Plan No.';
            TableRelation = "Vehicle Service Plan"."No." where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(25; Recurrence; Integer)
        {
            Caption = 'Recurrence';
        }
        field(30; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(36; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006132,36';

            trigger OnValidate()
            begin
                DoChangeInitValue := false;
                if "Variable Field Run 1" > 0 then
                    if "VF Initial Run 1" = 0 then
                        "VF Initial Run 1" := "Variable Field Run 1"
                    else
                        if Confirm(StrSubstNo(Text001, ApplicationManagement.CaptionClassTranslate_off(GlobalLanguage, '7,25006132,270')), false) then begin
                            "VF Initial Run 1" := "Variable Field Run 1";
                            DoChangeInitValue := true;
                        end;

                if VehicleServicePlan.Get("Vehicle Serial No.", "Plan No.") then
                    if VehicleServicePlan.Adjust then
                        if Confirm(StrSubstNo(Text002, ApplicationManagement.CaptionClassTranslate_off(GlobalLanguage, '7,25006132,36')), true) then
                            ServJnlPostLine.AdjustServPlanStageRuns("Vehicle Serial No.", "Plan No.", Recurrence, Code, "Variable Field Run 1",
                              0, 0, false, DoChangeInitValue);
            end;
        }
        field(50; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,Serviced,In Process,Skipped';
            OptionMembers = Pending,Serviced,"In Process",Skipped;

            trigger OnValidate()
            var
                VehicleServicePlanStage: Record "Vehicle Service Plan Stage" temporary;
            begin
            end;
        }
        field(90; "Expected Service Date"; Date)
        {
            Caption = 'Expected Service Date';
        }
        field(100; "Service Date"; Date)
        {
            Caption = 'Service Date';
        }
        field(200; "Maintain Stage"; Boolean)
        {
            Caption = 'Maintain Stage';

            trigger OnValidate()
            begin
                TestField(Group, false);
                TestField(Status, Status::Pending);
            end;
        }
        field(210; Group; Boolean)
        {
            Caption = 'Group';
        }
        field(220; "Applies-to Code"; Code[10])
        {
            Caption = 'Applies-to Code';
        }
        field(230; "Service Interval"; DateFormula)
        {
            Caption = 'Service Interval';
            Description = 'how to estimate current record starting previous stage';
        }
        field(240; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            TableRelation = "Service Package";

            trigger OnValidate()
            var
                ServicePackage: Record "Service Package";
            begin
            end;
        }
        field(250; "Variable Field Run 2"; Decimal)
        {
            CaptionClass = '7,25006132,250';

            trigger OnValidate()
            begin
                DoChangeInitValue := false;
                if "Variable Field Run 2" > 0 then
                    if "VF Initial Run 2" = 0 then
                        "VF Initial Run 2" := "Variable Field Run 2"
                    else
                        if Confirm(StrSubstNo(Text001, ApplicationManagement.CaptionClassTranslate_off(GlobalLanguage, '7,25006132,280')), false) then begin
                            "VF Initial Run 2" := "Variable Field Run 2";
                            DoChangeInitValue := true;
                        end;

                if VehicleServicePlan.Get("Vehicle Serial No.", "Plan No.") then
                    if VehicleServicePlan.Adjust then
                        if Confirm(StrSubstNo(Text002, ApplicationManagement.CaptionClassTranslate_off(GlobalLanguage, '7,25006132,250')), true) then
                            ServJnlPostLine.AdjustServPlanStageRuns("Vehicle Serial No.", "Plan No.", Recurrence, Code, 0, "Variable Field Run 2",
                              0, false, DoChangeInitValue);
            end;
        }
        field(260; "Variable Field Run 3"; Decimal)
        {
            CaptionClass = '7,25006132,260';

            trigger OnValidate()
            begin
                DoChangeInitValue := false;
                if "Variable Field Run 3" > 0 then
                    if "VF Initial Run 3" = 0 then
                        "VF Initial Run 3" := "Variable Field Run 3"
                    else
                        if Confirm(StrSubstNo(Text001, ApplicationManagement.CaptionClassTranslate_off(GlobalLanguage, '7,25006132,290')), false) then begin
                            "VF Initial Run 3" := "Variable Field Run 3";
                            DoChangeInitValue := true;
                        end;

                if VehicleServicePlan.Get("Vehicle Serial No.", "Plan No.") then
                    if VehicleServicePlan.Adjust then
                        if Confirm(StrSubstNo(Text002, ApplicationManagement.CaptionClassTranslate_off(GlobalLanguage, '7,25006132,260')), true) then
                            ServJnlPostLine.AdjustServPlanStageRuns("Vehicle Serial No.", "Plan No.", Recurrence, Code, 0, 0,
                              "Variable Field Run 3", false, DoChangeInitValue);
            end;
        }
        field(270; "VF Initial Run 1"; Decimal)
        {
            CaptionClass = '7,25006132,270';
            Description = 'Variable Field Initial Run 1';
            Editable = false;
        }
        field(280; "VF Initial Run 2"; Decimal)
        {
            CaptionClass = '7,25006132,280';
            Description = 'Variable Field Initial Run 2';
            Editable = false;
        }
        field(290; "VF Initial Run 3"; Decimal)
        {
            CaptionClass = '7,25006132,290';
            Description = 'Variable Field Initial Run 3';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Plan No.", Recurrence, "Code")
        {
            Clustered = true;
        }
        key(Key2; Status, "Expected Service Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ServPlanDocLink: Record "Service Plan Document Link";
        ServPlanComment: Record "Service Plan Comment Line";
    begin
        ServPlanDocLink.Reset;
        ServPlanDocLink.SetRange("Serv. Plan No.", "Plan No.");
        ServPlanDocLink.SetRange("Plan Stage Recurrence", Recurrence);
        ServPlanDocLink.SetRange("Serv. Plan Stage Code", Code);
        ServPlanDocLink.DeleteAll;

        ServPlanComment.Reset;
        ServPlanComment.SetRange(Type, ServPlanComment.Type::"Plan Stage");
        ServPlanComment.SetRange("Plan No.", "Plan No.");
        ServPlanComment.SetRange("Plan Stage Recurrence", Recurrence);
        ServPlanComment.SetRange("Stage Code", Code);
        ServPlanComment.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        ServPlanComment.DeleteAll;
    end;

    var
        Text001: label 'Would you like to change %1 as well?';
        ApplicationManagement: Codeunit DocumentManagementDMS;
        ServJnlPostLine: Codeunit "Serv. Jnl.-Post Line";
        Text002: label 'Would you like to recalculate %1 in other stages?';
        ServicePlanMgt: Codeunit "Service Plan Management";
        VehicleServicePlan: Record "Vehicle Service Plan";
        DoChangeInitValue: Boolean;
        VFMgt: Codeunit "Variable Field Management";


    procedure ProceedMaintainStageCheck(var VehicleServicePlanStage: Record "Vehicle Service Plan Stage" temporary)
    var
        VehServPlanStageCurr: Record "Vehicle Service Plan Stage";
    begin
        if "Maintain Stage" then begin

            // THIS code is working for trigger onValidate control
            VehServPlanStageCurr := VehicleServicePlanStage;
            if VehicleServicePlanStage.Count > 1 then begin
                VehicleServicePlanStage.FindFirst;
                repeat
                    if not ((VehicleServicePlanStage."Plan No." = VehServPlanStageCurr."Plan No.") and
                      (VehicleServicePlanStage.Recurrence = VehServPlanStageCurr.Recurrence) and
                      (VehicleServicePlanStage.Code = VehServPlanStageCurr.Code)) then begin
                        VehicleServicePlanStage."Maintain Stage" := false;
                        VehicleServicePlanStage.Modify;
                    end else begin
                        VehicleServicePlanStage."Maintain Stage" := true;
                        VehicleServicePlanStage.Modify;
                    end;
                until VehicleServicePlanStage.Next = 0;
                VehicleServicePlanStage.Get(VehServPlanStageCurr."Vehicle Serial No.", VehServPlanStageCurr."Plan No.",
                  VehServPlanStageCurr.Recurrence, VehServPlanStageCurr.Code);
            end;
        end;
    end;


    procedure ValidateMaintainStageCheck()
    var
        VehServPlanStageCurr: Record "Vehicle Service Plan Stage";
    begin
        if "Maintain Stage" then begin
            // it supposed to be redone by use local table rec for changes
            VehServPlanStageCurr := Rec;
            SetRange("Maintain Stage", true);
            if Count > 1 then begin
                FindFirst;
                repeat
                    if not (("Plan No." = VehServPlanStageCurr."Plan No.") and
                        (Recurrence = VehServPlanStageCurr.Recurrence) and
                        (Code = VehServPlanStageCurr.Code)) then begin
                        "Maintain Stage" := false;
                        Modify;
                    end;
                until Next = 0;
                Get(VehServPlanStageCurr."Vehicle Serial No.", VehServPlanStageCurr."Plan No.",
                  VehServPlanStageCurr.Recurrence, VehServPlanStageCurr.Code);
            end;
            SetRange("Maintain Stage");
        end;
    end;

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Vehicle Service Plan Stage", FieldNo));
    end;
}

