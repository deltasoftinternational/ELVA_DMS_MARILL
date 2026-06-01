Page 25006099 "Easy Clocking Start Meeting"
{
    Caption = 'Start Meeting';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Integer";

    layout
    {
        area(content)
        {
            field(UserDescription; MeetingDescription)
            {
                ApplicationArea = Basic;
                Caption = 'Meeting Description';
            }
        }
    }

    actions
    {
    }

    var
        MeetingDescription: Text;


    procedure GetMeetingDescription(): Text
    begin
        exit(MeetingDescription);
    end;
}

