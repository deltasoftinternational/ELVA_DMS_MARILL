Page 25006274 "Platform Templ. Tire Positions"
{
    Caption = 'Platform Templ. Tire Positions';
    PageType = List;
    SourceTable = "Platform Templ. Tire Position";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101904005; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

