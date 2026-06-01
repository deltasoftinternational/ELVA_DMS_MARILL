Table 25006188 "Det. Serv. Ledger Entry EDMS"
{
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Unit Cost"
    //     "Cost Amount"

    Caption = 'Det. Serv. Ledger Entry EDMS';
    DrillDownPageID = "Det. Serv. Ledger Entries EDMS";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Service Ledger Entry No."; Integer)
        {
            Caption = 'Service Ledger Entry No.';
            TableRelation = "Service Ledger Entry EDMS";
        }
        field(30; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(35; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Order,Invoice,Credit Memo,Blanket Order,Return Order,Payment,Refund';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order",Payment,Refund;
        }
        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(50; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(60; "Finished Quantity (Hours)"; Decimal)
        {
            Caption = 'Finished Quantity (Hours)';
        }
        field(70; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(80; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
        }
        field(90; "Quantity (Hours)"; Decimal)
        {
        }
        field(100; "Finished Qty. (Hours) Travel"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Service Ledger Entry No.")
        {
        }
        key(Key3; "Document Type", "Document No.", "Posting Date")
        {
        }
        key(Key4; "Resource No.")
        {
        }
    }

    fieldgroups
    {
    }
}

