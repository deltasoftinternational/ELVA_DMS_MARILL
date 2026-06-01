Table 25006049 "Location Dimension Setup"
{
    // 07.03.2014 Elva Baltic P8 MMG7.00
    //   * Increased lengths of fields

    Caption = 'Location Dimension Setup';

    fields
    {
        field(10; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(20; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(30; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension;
        }
        field(40; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"));
        }
    }

    keys
    {
        key(Key1; "Location Code", "Item Category Code", "Dimension Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

