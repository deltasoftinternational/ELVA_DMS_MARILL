Page 25006177 "Skill Codes EDMS"
{
    ApplicationArea = Basic;
    Caption = 'Skill Codes';
    PageType = List;
    SourceTable = "Skill Code EDMS";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the skill.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the skill code.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Skills)
            {
                Caption = 'Skills';
                action(ResourceSkills)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Skills';
                    Image = Skills;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ResourceSkills: Record "Resource Skill EDMS";
                    begin
                        ResourceSkills.Reset;
                        ResourceSkills.SetRange("Skill Code", Rec.Code);

                        Page.RunModal(Page::"Resource Skills EDMS", ResourceSkills);
                    end;
                }
                action(LaborSkills)
                {
                    ApplicationArea = Basic;
                    Caption = 'Labor Skills';
                    Image = Skills;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        LaborSkills: Record "Service Labor Skill";
                    begin
                        LaborSkills.Reset;
                        LaborSkills.SetRange("Skill Code", Rec.Code);

                        Page.RunModal(Page::"Service Labor Skills", LaborSkills);
                    end;
                }
            }
        }
    }
}

