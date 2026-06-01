Table 25006054 "Cust. Ledg. Entry Link"
{
    Caption = 'Cust. Ledg. Entry Link';

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Cust. Ledger Entry No."; Integer)
        {
            Caption = 'Cust. Ledger Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(30; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Vehicle';
            OptionMembers = Vehicle;
        }
        field(40; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(50; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Order,Invoice,Credit Memo,Blanket Order,Return Order,Payment,Refund';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order",Payment,Refund;
        }
        field(60; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(70; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(80; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item),Fixed Asset';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)","Fixed Asset";
        }
        field(90; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(100; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(110; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(120; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
        }
        field(130; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(140; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Cust. Ledger Entry No.")
        {
        }
        key(Key3; "Document Type", "Document No.", "Posting Date", "Document Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EDMSDetCustLedgEntry: Record "Cust. Ledg. Entry Link";


    procedure UpdateCustLedgNo(CustEntryNo: Integer; DocType: Integer; DocNo: Code[20]; PostDate: Date)
    begin
        EDMSDetCustLedgEntry.SetCurrentkey("Document Type", "Document No.", "Posting Date");
        EDMSDetCustLedgEntry.SetRange("Document Type", DocType);
        EDMSDetCustLedgEntry.SetRange("Document No.", DocNo);
        EDMSDetCustLedgEntry.SetRange("Posting Date", PostDate);
        EDMSDetCustLedgEntry.ModifyAll("Cust. Ledger Entry No.", CustEntryNo);
        EDMSDetCustLedgEntry.Reset
    end;
}

