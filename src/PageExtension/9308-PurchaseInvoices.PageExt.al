pageextension 25006464 "Purchase Invoices" extends "Purchase Invoices" //9308
{
    layout
    {
        addafter(Amount)
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}