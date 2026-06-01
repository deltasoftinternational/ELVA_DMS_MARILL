Table 25006737 "Item Order Overview Setup"
{
    Caption = 'Item Order Overview Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(200; "Highlight Statuses"; Boolean)
        {
            Caption = 'Highlight Statuses';
        }
        field(410; "Item Ledger Entry Color"; Integer)
        {
            Caption = 'Item Ledger Entry Color';
            Description = 'Classic Only';
        }
        field(420; "Transfer Line Color"; Integer)
        {
            Caption = 'Transfer Line Color';
            Description = 'Classic Only';
        }
        field(430; "Purchase Line Color"; Integer)
        {
            Caption = 'Purchase Line Color';
            Description = 'Classic Only';
        }
        field(440; "Requisition Line Color"; Integer)
        {
            Caption = 'Requisition Line Color';
            Description = 'Classic Only';
        }
        field(600; "Mixed Color"; Integer)
        {
            Caption = 'Mixed Color';
            Description = 'Classic Only';
        }
        field(610; "Not Reserved Color"; Integer)
        {
            Caption = 'Not Reserved Color';
            Description = 'Classic Only';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

