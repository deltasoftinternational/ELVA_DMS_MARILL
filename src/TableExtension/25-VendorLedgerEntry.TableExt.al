tableextension 25006014 "Vendor Ledger Entry" extends "Vendor Ledger Entry" //25
{
    // 20.08.2018 EB EDMS
    //   Added field:
    //     25006010 "Deal Type"
    fields
    {
        field(25006010; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }

    }

    keys
    {
        key(DMS1; "Document No.", "Posting Date")
        {
        }
        key(DMS2; "Posting Date")
        {
        }
    }

}