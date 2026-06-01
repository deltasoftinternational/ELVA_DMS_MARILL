Page 25006179 "Service Labor Skills"
{
    Caption = 'Service Labor Skills';
    PageType = List;
    SourceTable = "Service Labor Skill";

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field(LaborCode; Rec."Labor Code")
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

