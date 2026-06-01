Report 25006143 "Service Plan Change"
{
    // 26.04.2013 EDMS P8
    //   * Proceed vehicles only under filter.

    Caption = 'Service Plan Change';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Vehicle; Vehicle)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Make Code", "Model Code", "Status Code", "Type Code";
            column(ReportForNavId_7543; 7543)
            {
            }
            dataitem("Vehicle Service Plan"; "Vehicle Service Plan")
            {
                DataItemLink = "Vehicle Serial No." = field("Serial No.");
                RequestFilterFields = "Vehicle Serial No.", "Template Code";
                column(ReportForNavId_8970; 8970)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ServicePlanTemplate.Get(ServicePlanTemplateCode);
                    DeletePendingStages("Vehicle Service Plan");
                end;
            }
            dataitem(ApplyNewPlanTemplate; "Integer")
            {
                DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));
                column(ReportForNavId_1461; 1461)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    GetLastServicedStageOfVeh(Vehicle."Serial No.", LastServicedStage);
                    NewPlan.Reset;
                    NewPlan.Init;
                    NewPlan."No." := '';
                    NewPlan."Vehicle Serial No." := "Vehicle Service Plan"."Vehicle Serial No.";
                    if NewPlan."Vehicle Serial No." = '' then
                        CurrReport.Skip;
                    ServicePlanMgt.ApplyTemplateToPlan(ServicePlanTemplate, NewPlan);
                    if DeleteInPastStages then begin
                        if not LastServicedStage.FindLast then begin
                            LastServicedStage."Variable Field Run 1" := ServOrdInfoPaneMgt.CalcLastVFRun1(Vehicle."Serial No.");
                            LastServicedStage."Variable Field Run 2" := ServOrdInfoPaneMgt.CalcLastVFRun2(Vehicle."Serial No.");
                            LastServicedStage."Variable Field Run 3" := ServOrdInfoPaneMgt.CalcLastVFRun3(Vehicle."Serial No.");
                            LastServicedStage."Vehicle Serial No." := Vehicle."Serial No.";
                        end;
                        DeletePendingTillOldStage(NewPlan, LastServicedStage);
                    end;
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ServicePlanTemplateCode; ServicePlanTemplateCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Plan Template Code to Apply';
                        TableRelation = "Service Plan Template";
                    }
                    field(DeleteInPastStages; DeleteInPastStages)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Delete stages in past of new plans';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ServicePlanTemplate: Record "Service Plan Template";
        LastServicedStage: Record "Vehicle Service Plan Stage";
        NewPlan: Record "Vehicle Service Plan";
        ServicePlanMgt: Codeunit "Service Plan Management";
        ServicePlanTemplateCode: Code[10];
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        [InDataSet]
        DeleteInPastStages: Boolean;


    procedure DeletePendingStages(VehicleServicePlanPar: Record "Vehicle Service Plan")
    var
        PlanStage: Record "Vehicle Service Plan Stage";
    begin
        PlanStage.Reset;
        PlanStage.SetRange("Vehicle Serial No.", VehicleServicePlanPar."Vehicle Serial No.");
        PlanStage.SetRange("Plan No.", VehicleServicePlanPar."No.");
        PlanStage.SetRange(Status, PlanStage.Status::Pending);
        PlanStage.DeleteAll;
    end;


    procedure GetLastServicedStage(var VehicleServicePlanPar: Record "Vehicle Service Plan"; var VehicleServicePlanStagePar: Record "Vehicle Service Plan Stage")
    var
        FilterStr: Text[30];
    begin

        VehicleServicePlanStagePar.Reset;
        VehicleServicePlanStagePar.SetRange("Vehicle Serial No.", VehicleServicePlanPar."Vehicle Serial No.");
        VehicleServicePlanStagePar.SetRange("Plan No.", VehicleServicePlanPar."No.");
        FilterStr := StrSubstNo('%1|%2', VehicleServicePlanStagePar.Status::Serviced, VehicleServicePlanStagePar.Status::"In Process");
        VehicleServicePlanStagePar.SetFilter(Status, FilterStr);
        if VehicleServicePlanStagePar.FindLast then;

    end;


    procedure GetLastServicedStageOfVeh(VehSerNo: Code[20]; var VehicleServicePlanStagePar: Record "Vehicle Service Plan Stage")
    var
        FilterStr: Text[30];
    begin

        VehicleServicePlanStagePar.Reset;
        VehicleServicePlanStagePar.SetRange("Vehicle Serial No.", VehSerNo);
        FilterStr := StrSubstNo('%1|%2', VehicleServicePlanStagePar.Status::Serviced, VehicleServicePlanStagePar.Status::"In Process");
        VehicleServicePlanStagePar.SetFilter(Status, FilterStr);
        if VehicleServicePlanStagePar.FindLast then;

    end;


    procedure DeletePendingTillOldStage(var VehicleServicePlanPar: Record "Vehicle Service Plan"; var VehicleServicePlanStagePar: Record "Vehicle Service Plan Stage")
    var
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
    begin
        VehicleServicePlanPar.Validate("Start Variable Field Run 1", VehicleServicePlanStagePar."Variable Field Run 1");
        VehicleServicePlanPar.Validate("Start Variable Field Run 2", VehicleServicePlanStagePar."Variable Field Run 2");
        VehicleServicePlanPar.Validate("Start Variable Field Run 3", VehicleServicePlanStagePar."Variable Field Run 3");
        VehicleServicePlanPar.Modify(true);

        VehicleServicePlanStage.Reset;
        VehicleServicePlanStage.SetRange("Vehicle Serial No.", VehicleServicePlanPar."Vehicle Serial No.");
        VehicleServicePlanStage.SetRange("Plan No.", VehicleServicePlanPar."No.");
        if VehicleServicePlanStage.FindFirst then begin
            repeat
                if ((VehicleServicePlanStage."Variable Field Run 1" > 0) or
                    (VehicleServicePlanStage."Variable Field Run 2" > 0) or
                    (VehicleServicePlanStage."Variable Field Run 3" > 0)) then
                    if ((VehicleServicePlanStage."Variable Field Run 1" <= VehicleServicePlanStagePar."Variable Field Run 1") and
                      (VehicleServicePlanStage."Variable Field Run 2" <= VehicleServicePlanStagePar."Variable Field Run 2") and
                      (VehicleServicePlanStage."Variable Field Run 3" <= VehicleServicePlanStagePar."Variable Field Run 3")) then
                        VehicleServicePlanStage.Delete;
            until VehicleServicePlanStage.Next = 0;
        end;

    end;
}

