Page 25006188 "Service Comment List EDMS"
{
    Caption = 'Service Comment List EDMS';
    DataCaptionFields = Type, "No.";
    Editable = false;
    PageType = List;
    SourceTable = "Service Comment Line EDMS";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the user who created or modified comment.';
                }
            }
        }
    }

    actions
    {
    }
}

