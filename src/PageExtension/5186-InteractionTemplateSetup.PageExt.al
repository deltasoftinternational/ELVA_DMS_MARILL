pageextension 25006042 "Interaction Template Setup" extends "Interaction Template Setup"//5186
{
    layout
    {
        addafter("Meeting Invitation")
        {
            field(SMS; Rec.SMS)
            {
                ApplicationArea = Basic;
            }
        }

    }
}