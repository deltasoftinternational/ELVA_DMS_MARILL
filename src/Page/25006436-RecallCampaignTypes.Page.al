Page 25006436 "Recall Campaign Types"
{
    Caption = 'Recall Campaign Types';
    PageType = List;
    SourceTable = "Recall Campaign Types";

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
    }

    actions
    {
    }
}

