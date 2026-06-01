Page 25006248 "Service Plan Comment Sheet"
{
    AutoSplitKey = true;
    Caption = 'Service Plan Comment Sheet';
    PageType = List;
    SourceTable = "Service Plan Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Date := WorkDate;
    end;
}

