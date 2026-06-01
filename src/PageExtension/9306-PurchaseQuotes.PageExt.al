pageextension 25006463 "Purchase Quotes" extends "Purchase Quotes" //9306
{
    layout
    {
        addafter(Status)
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}