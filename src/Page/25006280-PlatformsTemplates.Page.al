Page 25006280 "Platforms Templates"
{
    Caption = 'Platforms Templates';
    PageType = List;
    SourceTable = "Platform Template";

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
            part(Control1101904005; "Platform Tire Positions subf")
            {
                ApplicationArea = All;
                SubPageLink = "Template Code" = field(Code);
            }
            part(Control1101904006; "Put On Tires")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

