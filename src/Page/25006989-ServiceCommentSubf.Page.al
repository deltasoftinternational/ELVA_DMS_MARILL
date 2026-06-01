Page 25006989 "Service Comment Subf"
{
    AutoSplitKey = true;
    Caption = 'Comments';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Service Comment Line EDMS";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; rec."No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Date; rec.Date)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Comment; rec.Comment)
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

