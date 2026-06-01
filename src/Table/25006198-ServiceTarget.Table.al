Table 25006198 "Service Target"
{

    fields
    {
        field(10; Location; Code[20])
        {
            Caption = 'Location';
            TableRelation = Location;
        }
        field(20; "Service Advisor"; Code[20])
        {
            Caption = 'Service Advisor';
            TableRelation = "Salesperson/Purchaser";
        }
        field(30; Resource; Code[20])
        {
            Caption = 'Resource';
            TableRelation = Resource;
        }
        field(40; Date; Date)
        {
            Caption = 'Date';
        }
        field(60; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(70; Amount; Decimal)
        {
            Caption = 'Amount';
        }
    }

    keys
    {
        key(Key1; Location, "Service Advisor", Resource, Date)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

