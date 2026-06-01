Table 25006756 "Purch. Invoice Import Buffer"
{
    Caption = 'Purch. Invoice Import Buffer';

    fields
    {
        field(10; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Purch. Header,Purch. Line';
            OptionMembers = "Purch. Header","Purch. Line";
        }
        field(20; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(30; "Invoice Line No."; Integer)
        {
            Caption = 'Invoice Line No.';
        }
        field(40; "Company Code"; Code[10])
        {
            Caption = 'Company Code';
        }
        field(50; "Supplier Code"; Code[10])
        {
            Caption = 'Supplier Code';
        }
        field(60; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(70; "Type of Invoice"; Code[1])
        {
            Caption = 'Type of Invoice';
        }
        field(80; "DeliveredPart No."; Code[25])
        {
            Caption = 'DeliveredPart No.';
        }
        field(90; "Odered Part No."; Code[25])
        {
            Caption = 'Odered Part No.';
        }
        field(100; "Invoiced Quantity"; Decimal)
        {
            Caption = 'Invoiced Quantity';
        }
        field(110; "Measure Unit"; Code[10])
        {
            Caption = 'Measure Unit';
        }
        field(120; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(130; "Order No."; Code[10])
        {
            Caption = 'Order No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Invoice No.", "Invoice Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

