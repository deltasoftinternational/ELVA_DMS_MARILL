pageextension 25006451 "Posted Return Receipts" extends "Posted Return Receipts"//6662
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