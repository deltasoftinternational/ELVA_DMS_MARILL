Page 25006251 "Choose Service Plan Stages"
{
    Caption = 'Choose Service Plan Stages';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Vehicle Service Plan Stage";
    SourceTableTemporary = true;
    SourceTableView = sorting(Status);

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = VehicleSerialNoVisible;
                }
                field(PlanNo; Rec."Plan No.")
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = VFRun1Visible;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun3Visible;
                }
                field(VFInitialRun1; Rec."VF Initial Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = InitialVFRun1Visible;
                }
                field(VFInitialRun2; Rec."VF Initial Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = InitialVFRun2Visible;
                }
                field(VFInitialRun3; Rec."VF Initial Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = InitialVFRun3Visible;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ServiceDate; Rec."Service Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ExpectedServiceDate; Rec."Expected Service Date")
                {
                    ApplicationArea = Basic;
                }
                field(MaintainStageFld; Rec."Maintain Stage")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        Rec.ProceedMaintainStageCheck(Rec);
                    end;
                }
                field(PackageNo; Rec."Package No.")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceInterval; Rec."Service Interval")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SetColumnVisability;
    end;

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        TempVehServPlanStage: Record "Vehicle Service Plan Stage";
        VehServPlanStage: Record "Vehicle Service Plan Stage";
        EmptyGroup: label '''''';
        Text001: label 'PENDING';
        Text002: label 'SERVICED';
        [InDataSet]
        VehicleSerialNoVisible: Boolean;
        ComponentsView: Boolean;
        VFRun1Visible: Boolean;
        VFRun2Visible: Boolean;
        VFRun3Visible: Boolean;
        InitialVFRun1Visible: Boolean;
        InitialVFRun2Visible: Boolean;
        InitialVFRun3Visible: Boolean;

    local procedure IsFirstLine(VehSerialNo: Code[20]; PlanNo: Code[20]; "Code": Code[20]): Boolean
    var
        SalesShptLine: Record "Sales Shipment Line";
    begin
        TempVehServPlanStage.Reset;
        TempVehServPlanStage.CopyFilters(Rec);
        TempVehServPlanStage.SetRange("Vehicle Serial No.", VehSerialNo);
        TempVehServPlanStage.SetRange("Plan No.", PlanNo);
        if TempVehServPlanStage.IsEmpty then begin
            VehServPlanStage.CopyFilters(Rec);
            VehServPlanStage.SetRange("Vehicle Serial No.", VehSerialNo);
            VehServPlanStage.SetRange("Plan No.", PlanNo);
            VehServPlanStage.FindFirst;
            TempVehServPlanStage := VehServPlanStage;
            TempVehServPlanStage.Insert;
        end;
        if TempVehServPlanStage.Code = Code then
            exit(true);
    end;


    procedure GroupingSymbol() Symbol: Integer
    begin
        if Rec.Group then begin
            if IsGroupExpanded then
                Symbol := 0
            else
                Symbol := 1
        end else
            Symbol := 2;
    end;


    procedure IsGroupExpanded(): Boolean
    var
        "--ETREE1.00--": Integer;
        GroupFilter: Text[1024];
        FullFilter: Text[1024];
        SubStrPosition: Integer;
    begin
        FullFilter := Rec.GetFilter("Applies-to Code");

        if FullFilter = '' then
            exit(true);

        if FullFilter = EmptyGroup then
            exit(false);

        GroupFilter := StrSubstNo('|%1', Rec.Code);
        if StrPos(FullFilter, GroupFilter + '|') > 0 then
            exit(true);

        if StrLen(FullFilter) < StrLen(GroupFilter) then
            exit(false);

        FullFilter := DelStr(FullFilter, 1, StrLen(FullFilter) - StrLen(GroupFilter));
        exit(GroupFilter = FullFilter);
    end;


    procedure ResetGrouping()
    begin
        Rec.SetFilter("Applies-to Code", '');
    end;

    local procedure GroupingSymbolOnPush()
    var
        FullGrpFilter: Text[250];
        GrpFilter: Text[250];
        SubStringPos: Integer;
    begin
        if not Rec.Group then
            exit;

        FullGrpFilter := Rec.GetFilter("Applies-to Code");

        // If group filtering is not set then create fully expanded filter
        if FullGrpFilter = '' then
            FullGrpFilter := EmptyGroup + '|' + Text001 + '|' + Text002;

        Rec.SetRange(Group);
        GrpFilter := StrSubstNo('|%1', Rec.Code);

        if IsGroupExpanded then begin
            SubStringPos := StrPos(FullGrpFilter, GrpFilter + '|');

            if SubStringPos = 0 then
                SubStringPos := StrPos(FullGrpFilter, GrpFilter);
            FullGrpFilter := DelStr(FullGrpFilter, SubStringPos, StrLen(GrpFilter))
        end else
            FullGrpFilter += GrpFilter;

        Rec.SetFilter("Applies-to Code", FullGrpFilter);
    end;


    procedure SetColumnVisability()
    var
        LastVehNo: Code[20];
        VehNoVisible: Boolean;
    begin
        if Rec.Get('', '', 0, 'COMPONENTS') then begin
            SetComponentsView;
            Rec.Delete;
        end;
        VehicleSerialNoVisible := ComponentsView;
    end;


    procedure SetComponentsView()
    begin
        ComponentsView := true;
    end;

    procedure SetVariableFields()
    begin
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
        InitialVFRun1Visible := rec.IsVFActive(rec.FieldNo("VF Initial Run 1"));
        InitialVFRun2Visible := rec.IsVFActive(rec.FieldNo("VF Initial Run 2"));
        InitialVFRun3Visible := rec.IsVFActive(rec.FieldNo("VF Initial Run 3"));
    end;
}

