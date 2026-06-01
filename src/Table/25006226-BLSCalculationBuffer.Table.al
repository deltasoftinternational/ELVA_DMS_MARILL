Table 25006226 "BLS Calculation Buffer"
{

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(100; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(110; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(120; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(122; "Line type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Services,Lease Schedule';
            OptionMembers = Services,"Lease Schedule";
        }
        field(130; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            NotBlank = true;
        }
        field(140; "Service Variant Code"; Code[20])
        {
            Caption = 'Service Variant Code';
        }
        field(150; "Object Type"; Option)
        {
            Caption = 'Object Type';
            InitValue = "Object";
            OptionCaption = ' ,Object,Object Set';
            OptionMembers = " ","Object","Object Set";
        }
        field(160; "Object Code"; Code[20])
        {
            Caption = 'Object Code';
        }
        field(170; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(180; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(190; "Quantity Source"; Option)
        {
            Caption = 'Quantity Source';
            OptionCaption = ' ,Contract,Price List,Service Ledger,Specific';
            OptionMembers = " ",Contract,"Price List","Service Ledger",Specific;
        }
        field(200; "Price Source"; Option)
        {
            Caption = 'Price Source';
            OptionCaption = ' ,Contract,Price List,Service Ledger,Specific';
            OptionMembers = " ",Contract,"Price List","Service Ledger",Specific;
        }
        field(205; "Price Including VAT"; Boolean)
        {
            Caption = 'Price Including VAT';
        }
        field(210; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(215; "Base Unit Price"; Decimal)
        {
            Caption = 'Base Unit Price';
        }
        field(220; "Discount Source"; Option)
        {
            Caption = 'Discount Source';
            OptionCaption = ' ,Contract,Price List,Service Ledger,Specific';
            OptionMembers = " ",Contract,"Price List","Service Ledger",Specific;
        }
        field(230; "Discount, %"; Decimal)
        {
            Caption = 'Discount, %';
        }
        field(240; "Specific Source"; Integer)
        {
            Caption = 'Specific Source';
        }
        field(250; "Specific No."; Code[20])
        {
            Caption = 'Specific No.';
        }
        field(300; "Period Starting Date"; Date)
        {
            Caption = 'Period Starting Date';
        }
        field(310; "Period Ending Date"; Date)
        {
            Caption = 'Period Ending Date';
        }
        field(400; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(410; "Discount Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Discount Amount';
            DecimalPlaces = 2 : 2;
        }
        field(415; "Base Unit Price Incl. Discount"; Decimal)
        {
            Caption = 'Base Unit Price Incl. Discount';
        }
        field(420; "Total Price Incl. Discount"; Decimal)
        {
            Caption = 'Total Price Incl. Discount';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
        }
        field(430; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(440; "Base Quantity"; Decimal)
        {
            Caption = 'Base Quantity';
        }
        field(500; "Invoice Group Code"; Code[20])
        {
            Caption = 'Invoice Group Code';
        }
        field(510; "Calculation Period Code"; Code[20])
        {
            Caption = 'Calculation Period Code';
        }
        field(600; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(610; "Customer Discount Group"; Code[20])
        {
            Caption = 'Customer Discount Group';
            TableRelation = "Customer Discount Group";
        }
        field(620; "Service Group Code"; Code[20])
        {
            Caption = 'Service Group Code';
        }
        field(630; "Discount Usage"; Option)
        {
            Caption = 'Discount Usage';
            OptionCaption = ' ,Contract,All';
            OptionMembers = " ",Contract,All;
        }
        field(700; "Grouping ID"; Integer)
        {
        }
        field(710; "Service Date"; Date)
        {
            Caption = 'Service Date';
        }
        field(900; "Skip Entry"; Boolean)
        {
            Caption = 'Skip On Calculation';
        }
        field(910; "Calculation Ledger Entry No."; Integer)
        {
            Caption = 'Calculation Ledger Entry No.';
        }
        field(3000; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(4000; "Lease Base Amount"; Decimal)
        {
            Caption = 'Lease Base Amount';
        }
        field(4010; "Lease Interest Amount"; Decimal)
        {
            Caption = 'Lease Interest Amount';
        }
        field(4020; "Lease Total Amount"; Decimal)
        {
            Caption = 'Lease Total Amount';
        }
        field(4030; "Leasing Schedule No."; Code[20])
        {
            Caption = 'Leasing Schedule No.';
            TableRelation = "BLS Leasing Schedule Header";
        }
        field(4040; "Leasing Schedule Line No."; Integer)
        {
            Caption = 'Leasing Schedule Line No.';
        }
        field(4050; "Additional Service Amount"; Decimal)
        {
            Caption = 'Additional Service Amount';
        }
        field(5000; "BLS Service Ledger Entry No."; Integer)
        {
            Caption = 'BLS Service Ledger Entry No.';
            TableRelation = "BLS Ledger Entry";
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

