pageextension 25006005 "Customer Ledger Entries" extends "Customer Ledger Entries" //25
{
    layout
    {
        addafter("Dimension Set ID")
        {
            field(RentOrderNo; Rec."Rent Order No.")
            {
                ApplicationArea = Basic;
            }
            field(DealTypeCode; Rec."Deal Type Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}