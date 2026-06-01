Page 25006193 "Det. Service Journal EDMS"
{
    Caption = 'Det. Service Journal EDMS';
    PageType = List;
    SourceTable = "Det. Serv. Journal Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ResourceNo; Rec."Resource No.")
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

