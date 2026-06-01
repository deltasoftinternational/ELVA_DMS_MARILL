Page 25006281 "Platform Axles subf"
{
    Caption = 'Platform Axles subf';
    PageType = ListPart;
    SourceTable = "Platform Template Axle";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TemplateCode; Rec."Template Code")
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
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

