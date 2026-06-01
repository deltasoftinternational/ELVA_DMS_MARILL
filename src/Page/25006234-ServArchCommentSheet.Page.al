Page 25006234 "Serv. Arch. Comment Sheet"
{
    Caption = 'Comment Sheet';
    Editable = false;
    PageType = List;
    SourceTable = "Serv. Comment Line Arch. EDMS";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                }
                field(CommentTypeCode; Rec."Comment Type Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

