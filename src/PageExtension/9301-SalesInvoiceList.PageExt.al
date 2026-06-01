pageextension 25006031 "Sales Invoice List" extends "Sales Invoice List"//9301
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