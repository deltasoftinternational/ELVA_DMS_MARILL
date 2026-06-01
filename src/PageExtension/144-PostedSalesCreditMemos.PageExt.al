pageextension 25006062 "Posted Sales Credit Memos" extends "Posted Sales Credit Memos"   //144
{
    layout
    {
        addlast(Control1)
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}