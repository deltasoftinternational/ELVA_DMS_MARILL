pageextension 25006063 "Posted Purchase Receipts" extends "Posted Purchase Receipts"   //145
{
    layout
    {
        addlast(Control1)
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}