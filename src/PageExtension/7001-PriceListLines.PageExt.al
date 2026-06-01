pageextension 25006206 "Price List Lines" extends "Price List Lines"//7001
{
    layout
    {
        addafter("Unit Price")
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
            }
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
        }
    }
}
