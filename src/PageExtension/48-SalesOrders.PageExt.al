pageextension 25006050 "Sales Orders" extends "Sales Orders"//48
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