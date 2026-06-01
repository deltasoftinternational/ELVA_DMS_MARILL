Page 25006218 "Service Plan Template Stages"
{
    Caption = 'Service Plan Template Stages';
    DataCaptionFields = "Template Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Plan Template Stage";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(TemplateCode; Rec."Template Code")
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
                field(ServiceInterval; Rec."Service Interval")
                {
                    ApplicationArea = Basic;
                }
                field(PackageNo; Rec."Package No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(PlanTemplStage)
            {
                Caption = 'Plan Templ. Stage';
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page "Service Plan Comment Sheet";
                    RunPageLink = Type = const("Plan Template Stage"),
                                  "Plan No." = field("Template Code"),
                                  "Stage Code" = field(Code);
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
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
    end;
}

