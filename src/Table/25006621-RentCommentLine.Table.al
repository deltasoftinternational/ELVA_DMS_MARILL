Table 25006621 "Rent Comment Line"
{
    Caption = 'Rent Comment Line';

    fields
    {
        field(10; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Contract,Invoice';
            OptionMembers = Contract,Invoice;
        }
        field(20; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(40; Date; Date)
        {
            Caption = 'Date';
        }
        field(50; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(60; Comment; Text[80])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure SetUpNewLine()
    var
        PurchCommentLine: Record "Purch. Comment Line";
    begin
    end;
}

