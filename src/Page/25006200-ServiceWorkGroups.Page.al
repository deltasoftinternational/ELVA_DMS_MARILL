Page 25006200 "Service Work Groups"
{
    Caption = 'Service Work Groups';
    PageType = List;
    SourceTable = "Service Work Group";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
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

