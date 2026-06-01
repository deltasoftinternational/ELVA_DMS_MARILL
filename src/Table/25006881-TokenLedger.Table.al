Table 25006881 "Token Ledger"
{
    Caption = 'Token Ledger';

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; Date; Date)
        {
            Caption = 'Date';
        }
        field(30; Time; Time)
        {
            Caption = 'Time';
        }
        field(40; "Token Qty."; Decimal)
        {
            Caption = 'Token Qty.';
        }
        field(50; "Operation Count"; Integer)
        {
            Caption = 'Operation Count';
        }
        field(60; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
        }
        field(70; "Operation No."; Code[20])
        {
            Caption = 'Operation No.';
        }
        field(80; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(90; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

