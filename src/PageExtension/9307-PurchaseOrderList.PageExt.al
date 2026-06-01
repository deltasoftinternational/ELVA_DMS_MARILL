pageextension 25006034 "Purchase Order List" extends "Purchase Order List"//9307
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