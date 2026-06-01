Page 25006264 "Service Comment Line Types"
{
    Caption = 'Service Comment Line Types';
    PageType = List;
    SourceTable = "Service Comment Line Type";

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
                field(Print; Rec.Print)
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

