Page 25006180 "Vehicle Service Plans"
{
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009

    Caption = 'Vehicle Service Plans';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Vehicle Service Plan";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(TemplateCode; Rec."Template Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ServicePlanType; Rec."Service Plan Type")
                {
                    ApplicationArea = Basic;
                }
                field(StartVariableFieldRun1; Rec."Start Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun1Visible;
                }
                field(StartVariableFieldRun2; Rec."Start Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun2Visible;
                }
                field(StartVariableFieldRun3; Rec."Start Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun3Visible;
                }
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CreationDate; Rec."Creation Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Adjust; Rec.Adjust)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Recurring; Rec.Recurring)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AutoOrderByExpDate; Rec."Auto Order By Exp. Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Plan)
            {
                Caption = 'Plan';
                action(Stages)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stages';
                    Ellipsis = true;
                    Image = Stages;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Vehicle Service Plan Stages";
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No."),
                                  "Plan No." = field("No.");
                }
                action(DocumentLink)
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Link';
                    Image = Document;
                    RunObject = Page "Service Plan Document Link";
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No."),
                                  "Serv. Plan No." = field("No.");
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page "Service Plan Comment Sheet";
                    RunPageLink = Type = const(Plan),
                                  "Plan No." = field("No."),
                                  "Vehicle Serial No." = field("Vehicle Serial No.");
                }
                action(ChangeLog)
                {
                    ApplicationArea = Basic;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    RunObject = Page "Common Log Entries";
                    RunPageLink = "Table No." = const(25006132),
                                  "Primary Key Field 1 Value" = field("Vehicle Serial No."),
                                  "Primary Key Field 2 Value" = field("No.");
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(ApplyTemplate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Template';
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ServicePlanMgt: Codeunit "Service Plan Management";
                    begin
                        ServicePlanMgt.ApplyTemplate(Rec);
                    end;
                }
                action(CalcExpectedServiceDates)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calc. Expected Service Dates';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Report.Run(Report::"Calc. Expected Service Dates", true, false, Rec)
                    end;
                }
                action(PlanChange)
                {
                    ApplicationArea = Basic;
                    Caption = 'Plan Change';
                    Image = Change;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        VehicleServicePlan: Record "Vehicle Service Plan";
                    begin
                        if Rec."No." <> '' then begin
                            VehicleServicePlan.SetRange("Vehicle Serial No.", Rec."Vehicle Serial No.");
                            VehicleServicePlan.SetRange("No.", Rec."No.");
                            Report.Run(Report::"Service Plan Change", true, false, VehicleServicePlan);
                            CurrPage.Update;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        VFRun1Visible: Boolean;
        VFRun2Visible: Boolean;
        VFRun3Visible: Boolean;

    procedure SetVariableFields()
    begin
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Start Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Start Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Start Variable Field Run 3"));
    end;
}

