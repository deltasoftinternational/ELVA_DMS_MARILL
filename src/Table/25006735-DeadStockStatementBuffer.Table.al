Table 25006735 "Dead Stock Statement Buffer"
{
    // 15.05.2014 Elva Baltic P21 #S0105 MMG7.00
    //   Added fields:
    //     "Dead Stock Rate"
    //     "Dead Stock Rate 2"
    //     "Reserved on Inventory"
    //     "Available Inventory"
    //     "Maximum Inventory"
    //     "Net Change"
    //   Modified TableRelation for field:
    //     "Product Subgroup Code"

    Caption = 'Dead Stock Statement Buffer';

    fields
    {
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(20; Description; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Sales (Qty.)"; Decimal)
        {
            Caption = 'Sales (Qty.)';
            TableRelation = "Item Ledger Entry";
        }
        field(40; "Purchase (Qty.)"; Decimal)
        {
            Caption = 'Purchase (Qty.)';
        }
        field(60; "No Sales"; Boolean)
        {
            Caption = 'No Sales';
        }
        field(70; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(80; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
        }
        field(90; "Product Subgroup Code"; Code[10])
        {
            Caption = 'Product Subgroup Code';
        }
        field(100; Inventory; Decimal)
        {
            Caption = 'Inventory';
            DecimalPlaces = 0 : 2;
        }
        field(110; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DecimalPlaces = 2 : 2;
        }
        field(120; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            DecimalPlaces = 2 : 2;
        }
        field(130; "Reorder Point"; Decimal)
        {
            Caption = 'Reorder Point';
            DecimalPlaces = 0 : 5;
        }
        field(150; "Transferred (Qty.)"; Decimal)
        {
            Caption = 'Transferred (Qty.)';
        }
        field(200; "Dead Stock Rate"; Decimal)
        {
            Caption = 'Dead Stock Rate';
        }
        field(210; "Dead Stock Rate 2"; Decimal)
        {
            Caption = 'Dead Stock Rate 2';
        }
        field(220; "Reserved on Inventory"; Decimal)
        {
            Caption = 'Reserved on Inventory';
            DecimalPlaces = 0 : 2;
        }
        field(230; "Available Inventory"; Decimal)
        {
            Caption = 'Available Inventory';
            DecimalPlaces = 0 : 2;
        }
        field(240; "Maximum Inventory"; Decimal)
        {
            Caption = 'Maximum Inventory';
            DecimalPlaces = 0 : 5;
        }
        field(250; "Net Change"; Decimal)
        {
            Caption = 'Net Change';
            DecimalPlaces = 0 : 2;
        }
    }

    keys
    {
        key(Key1; "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

