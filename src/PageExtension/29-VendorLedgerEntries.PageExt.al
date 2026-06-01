pageextension 25006007 "Vendor Ledger Entries" extends "Vendor Ledger Entries" //29
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            field(DealTypeCode; Rec."Deal Type Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}