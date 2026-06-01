Table 25006194 "Service WIP Entry"
{
    Caption = 'Service WIP Entry';
    DrillDownPageID = "Service WIP Entries";
    LookupPageID = "Service WIP Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(30; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            TableRelation = "Service Order WIP Line"."Service Order No.";
            ValidateTableRelation = false;
        }
        field(35; "Service Order Line No."; Integer)
        {
            Caption = 'Service Order Line No.';
            TableRelation = "Service Order WIP Line"."Service Order Line No.";
            ValidateTableRelation = false;
        }
        field(36; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Item,Labor,"External Service";
        }
        field(37; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(40; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(50; "G/L Bal. Account No."; Code[20])
        {
            Caption = 'G/L Bal. Account No.';
            TableRelation = "G/L Account";
        }
        field(60; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(62; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(63; "Finished Qty."; Decimal)
        {
            Caption = 'Finished Quantity';
        }
        field(70; "WIP Entry Amount"; Decimal)
        {
            Caption = 'WIP Entry Amount';
        }
        field(80; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        field(90; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        field(100; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionMembers = "Accrued Costs","Accrued Sales";
        }
        field(110; "WIP Method"; Option)
        {
            Caption = 'WIP Method';
            OptionMembers = "Cost Method","Sales Method";
        }
        field(120; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(140; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(150; "Reverse Date"; Date)
        {
            Caption = 'Reverse Date';
        }
        field(160; "Reverse Document No."; Code[20])
        {
            Caption = 'Reverse Document No.';
        }
        field(170; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(180; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(190; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(200; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            TableRelation = "Dimension Set Entry";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Service Order No.", "Entry Type")
        {
        }
    }

    fieldgroups
    {
    }
}

