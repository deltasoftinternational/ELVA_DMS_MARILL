Table 25006760 "Item Discount Group Parameter"
{
    // 10.03.2015 EDMS P21 #T029
    //   Restructured

    Caption = 'Item Discount Group Parameter';
    LookupPageID = "Item Disc. Group Parameters";

    fields
    {
        field(10; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(20; "Item Discount Group Code"; Code[10])
        {
            Caption = 'Item Discount Group Code';
            TableRelation = "Item Discount Group";
        }
        field(30; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(40; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(50; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(100; "Surcharge %"; Decimal)
        {
            Caption = 'Surcharge %';
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Item Discount Group Code", "Ordering Price Type Code", "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        tcREZ001: label '%1 can''t be greater than %2';
}

