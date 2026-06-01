Page 25006181 "Vehicle Service Plan Stages"
{
    Caption = 'Vehicle Service Plan Stages';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Vehicle Service Plan Stage";

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
                field(PlanNo; Rec."Plan No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Recurrence; Rec.Recurrence)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun1Visible;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun2Visible;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun3Visible;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
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
                field(ServiceDate; Rec."Service Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(ExpectedServiceDate; Rec."Expected Service Date")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceInterval; Rec."Service Interval")
                {
                    ApplicationArea = Basic;
                }
                field(PackageNo; Rec."Package No.")
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
            group(Stage)
            {
                Caption = 'Stage';
                action(DocumentLink)
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Link';
                    Image = Document;
                    RunObject = Page "Service Plan Document Link";
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No."),
                                  "Serv. Plan No." = field("Plan No."),
                                  "Serv. Plan Stage Code" = field(Code),
                                  "Plan Stage Recurrence" = field(Recurrence);
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page "Service Plan Comment Sheet";
                    RunPageLink = Type = const("Plan Stage"),
                                  "Plan No." = field("Plan No."),
                                  "Stage Code" = field(Code),
                                  "Vehicle Serial No." = field("Vehicle Serial No.");
                    RunPageView = sorting(Type, "Plan No.", "Stage Code", "Vehicle Serial No.", "Line No.");
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
        InitialVFRun1Visible: Boolean;
        InitialVFRun2Visible: Boolean;
        InitialVFRun3Visible: Boolean;

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

