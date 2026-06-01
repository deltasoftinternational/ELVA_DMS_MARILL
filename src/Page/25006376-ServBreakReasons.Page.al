Page 25006376 "Serv. Break Reasons"
{
    Caption = 'Serv. Break Reasons';
    PageType = List;
    SourceTable = "Serv. Break Reason";

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
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
    }

    actions
    {
    }
}

