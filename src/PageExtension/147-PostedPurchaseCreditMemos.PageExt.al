pageextension 25006065 "Posted Purchase Credit Memos" extends "Posted Purchase Credit Memos"   //147
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