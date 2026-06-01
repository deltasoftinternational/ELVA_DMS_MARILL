Page 25006282 "Platform Tire Positions subf"
{
    Caption = 'Platform Tire Positions subf';
    PageType = ListPart;
    SourceTable = "Platform Templ. Tire Position";

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
                field(TemplateAxleCode; Rec."Template Axle Code")
                {
                    ApplicationArea = Basic;
                }
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
    }

    actions
    {
    }
}

