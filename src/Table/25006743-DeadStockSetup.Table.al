Table 25006743 "Dead Stock Setup"
{
    // 15.05.2014 Elva Baltic P21 #S0105 MMG7.00
    //   Modified CaptionML property for field:
    //     "Min. Dead Stock Rate"

    Caption = 'Dead Stock Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(30; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(40; "Min. Dead Stock Rate"; Decimal)
        {
            Caption = 'Min. Dead Stock Rate';
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

