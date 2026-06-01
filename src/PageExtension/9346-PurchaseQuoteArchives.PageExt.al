pageextension 25006466 "Purchase Quote Archives" extends "Purchase Quote Archives"//9346
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