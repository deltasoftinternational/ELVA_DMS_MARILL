pageextension 25006465 "Purchase Credit Memos" extends "Purchase Credit Memos" //9309
{
    layout
    {
        addafter("Job Queue Status")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}