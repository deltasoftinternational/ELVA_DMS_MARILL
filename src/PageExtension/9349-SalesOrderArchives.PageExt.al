pageextension 25006469 "Sales Order Archives" extends "Sales Order Archives"//9349
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