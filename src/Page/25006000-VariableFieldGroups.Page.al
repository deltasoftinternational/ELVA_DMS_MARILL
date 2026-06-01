Page 25006000 "Variable Field Groups"
{
    Caption = 'Variable Field Groups';
    PageType = List;
    SourceTable = "Variable Field Group";

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; rec.Description)
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

