pageextension 25006468 "Sales Quote Archives" extends "Sales Quote Archives"//9348
{
    layout
    {
        addafter("Shipment Date")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}