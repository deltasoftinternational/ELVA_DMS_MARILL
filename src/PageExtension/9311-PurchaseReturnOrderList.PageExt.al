pageextension 25006035 "Purchase Return Order List" extends "Purchase Return Order List"//9311
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