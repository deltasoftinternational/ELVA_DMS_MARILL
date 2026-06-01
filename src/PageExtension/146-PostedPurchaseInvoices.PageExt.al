pageextension 25006064 "Posted Purchase Invoices" extends "Posted Purchase Invoices"   //146
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