Table 25006197 "Posted Serv. WIP Order Line"
{
    Caption = 'Posted Service WIP Order Line';

    fields
    {
        field(10; "Document No."; Code[20])
        {
        }
        field(20; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            TableRelation = "Service WIP Entry"."Service Order No.";
            ValidateTableRelation = false;
        }
        field(30; "Service Order Line No."; Integer)
        {
            Caption = 'Service Order Line No.';
            TableRelation = "Service WIP Entry"."Service Order Line No.";
            ValidateTableRelation = false;
        }
        field(50; "WIP Method"; Option)
        {
            Caption = 'WIP Method';
            OptionMembers = "Cost Method","Sales Method";
        }
        field(60; "Service Order Date."; Date)
        {
            Caption = 'Service Order Date.';
        }
        field(70; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(80; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(90; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Item,Labor,"External Service";
        }
        field(100; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(110; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(120; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(130; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(140; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            "Unit of Measure".Code;
        }
        field(150; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(160; "Finished Qty."; Decimal)
        {
            Caption = 'Finished Quantity';
        }
        field(170; Finished; Boolean)
        {
            Caption = 'Finished';
        }
        field(180; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(190; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(200; "Recognized Cost Qty."; Decimal)
        {
            Caption = 'Recognized Cost Quantity';
        }
        field(210; "Recognized Sales Qty."; Decimal)
        {
            Caption = 'Recognized Sales Quantity';
        }
        field(220; "Recognized Cost Amount"; Decimal)
        {
            Caption = 'Recognized Cost Amount';
        }
        field(230; "Recognized Sales Amount"; Decimal)
        {
            Caption = 'Recognized Sales Amount';
        }
        field(240; "External Serv. Tracking No."; Code[10])
        {
            Caption = 'External Serv. Tracking No.';
        }
        field(250; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(260; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(270; "Recognized Cost Qty. (Calc)"; Decimal)
        {
            Caption = 'Recognized Cost Qty. (Calc)';
        }
        field(280; "Recognized Sales Qty. (Calc)"; Decimal)
        {
            Caption = 'Recognized Sales Qty. (Calc)';
        }
        field(290; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(300; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(310; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(320; "Unit Price (LCY)"; Decimal)
        {
            Caption = 'Unit Price (LCY)';
        }
        field(330; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(340; "VAT %"; Decimal)
        {
        }
        field(350; "Line Discount %"; Decimal)
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            TableRelation = "Dimension Set Entry";
        }
    }

    keys
    {
        key(Key1; "Document No.", "Service Order No.", "Service Order Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

