pageextension 25006152 "Price List Line Review" extends "Price List Line Review"//7005
{
    layout
    {
        addafter("Unit Price")
        {

            field("Vehicle Serial No."; Rec."Vehicle Serial No.")
            {
                ApplicationArea = All;
            }
            field("Ordering Price Type Code"; Rec."Ordering Price Type Code")
            {
                ApplicationArea = all;
            }
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = all;
            }
            field("Item Category Code"; rec."Item Category Code")
            {
                ApplicationArea = all;
            }
            field("Location Code"; rec."Location Code")
            {
                ApplicationArea = all;
            }
        }
    }
}