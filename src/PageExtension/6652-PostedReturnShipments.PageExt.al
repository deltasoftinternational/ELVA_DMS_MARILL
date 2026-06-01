pageextension 25006109 "Posted Return Shipments" extends "Posted Return Shipments"//6652
{
    layout
    {
        addafter("Applies-to Doc. Type")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}