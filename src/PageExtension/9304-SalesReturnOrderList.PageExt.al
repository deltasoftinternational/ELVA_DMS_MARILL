pageextension 25006461 "Sales Return Order List" extends "Sales Return Order List"//9304
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