Page 25006178 "Resource Skills EDMS"
{
    Caption = 'Resource Skills';
    PageType = List;
    SourceTable = "Resource Skill EDMS";

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SkillCode; Rec."Skill Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

