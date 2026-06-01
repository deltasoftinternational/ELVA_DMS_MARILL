pageextension 25006462 "Sales Order List" extends "Sales Order List"//9305
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