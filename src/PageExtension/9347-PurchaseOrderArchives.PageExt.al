pageextension 25006467 "Purchase Order Archives" extends "Purchase Order Archives"//9347
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}