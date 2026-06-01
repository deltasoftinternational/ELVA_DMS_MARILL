tableextension 25006026 "Cust. Ledger Entry" extends "Cust. Ledger Entry" //21
{
    // 20.08.2018 EB EDMS
    //   Added field:
    //     25006010 "Deal Type"
    // 
    // 03.08.2018 EB.P30 EDMS
    //   Added field:
    //     25006600 "Rent Order No."
    //   Modified function:
    //     CopyFromGenJnlLine
    // 
    // 22.05.2014 EDMS P8
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006010; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006600; "Rent Order No."; Code[20])
        {
            Caption = 'Rent Order No.';
            Description = 'Only for Rent';
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
        key(DMS3; "Document Type", "Document No.")
        {
        }
        key(DMS4; "Document No.", "Posting Date", "Currency Code")
        {
        }
        key(DMS5; "Salesperson Code")
        {
        }
        key(DMS6; "Document No.", "Document Type", "Customer No.")
        {
        }
        key(DMS7; "External Document No.", "Document Type", "Customer No.")
        {
        }
        key(DMS8; "Customer No.", "Posting Date")
        {
            SumIndexFields = "Sales (LCY)", "Profit (LCY)", "Inv. Discount (LCY)";
        }

    }
}
