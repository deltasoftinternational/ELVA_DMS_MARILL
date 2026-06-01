Table 25006294 "Item Location Qty. Buffer"
{
    // #Owner POD.DMS.Parts
    // 
    // 02.04.2017 EB.RC POD.DMS.Parts P439.WH24 POD0.40
    //   Added fields:
    //     60"InventoryDecimal"
    //     70"Reserved Qty. on Inventory"
    //     80"Qty. on Purch. Binning Lists"
    // 
    // 30.01.2017 EB.RC POD.DMS.Parts P439.WH24
    //   Bugfix
    // 
    // 20.12.2016 EB.RC POD.DMS.Parts P439.WH24 POD0.39
    //   Added field:
    //     50 "Item No."
    // 
    // 18.07.2016 EB.RC POD.DMS.Parts P439.PAR90 POD0.16
    //   Created


    fields
    {
        field(10; "Location Code"; Code[20])
        {
        }
        field(20; "Location Description"; Text[50])
        {
        }
        field(30; "Available Quantity"; Decimal)
        {
        }
        field(40; "Selected Quantity"; Decimal)
        {
        }
        field(50; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(60; Inventory; Decimal)
        {
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(70; "Reserved Qty. on Inventory"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Reserved Qty. on Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(80; "Qty. on Purch. Binning Lists"; Decimal)
        {
            Caption = 'Qty. on Purch. Binning Lists';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Location Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

