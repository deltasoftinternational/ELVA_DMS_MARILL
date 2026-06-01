pageextension 25006460 "Sales Credit Memos" extends "Sales Credit Memos" //9302
{
    layout
    {
        addafter("Posting Description")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}