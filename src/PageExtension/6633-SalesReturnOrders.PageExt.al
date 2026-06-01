pageextension 25006103 "Sales Return Orders" extends "Sales Return Orders"//6633
{
    layout
    {
        addafter("Line Discount %")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}