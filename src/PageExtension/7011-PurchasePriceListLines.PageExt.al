pageextension 25006210 "Purchase Price List Lines" extends "Purchase Price List Lines"//7011
{
    layout
    {
        addafter(DirectUnitCost)
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
        }
    }
}
