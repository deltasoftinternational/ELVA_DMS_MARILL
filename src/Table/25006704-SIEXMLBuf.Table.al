Table 25006704 "SIE XML Buf"
{
    Caption = 'SIE XML Buf';

    fields
    {
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'User,Transaction';
            OptionMembers = User,Transaction;
        }
        field(20; "SIE Entry No."; Integer)
        {
            Caption = 'SIE Entry No.';
        }
        field(30; "100Txt1"; Text[100])
        {
        }
        field(40; "100Txt2"; Text[100])
        {
        }
        field(50; "100Txt3"; Text[100])
        {
        }
        field(60; "100Txt4"; Text[100])
        {
        }
        field(70; "200Txt1"; Text[200])
        {
        }
        field(80; Int1; Integer)
        {
        }
        field(90; Int2; Integer)
        {
        }
        field(100; Int3; Integer)
        {
        }
        field(110; Int4; Integer)
        {
        }
        field(120; Int5; Integer)
        {
        }
        field(130; Int6; Integer)
        {
        }
        field(140; Int7; Integer)
        {
        }
        field(150; Date1; Date)
        {
        }
        field(160; Date2; Date)
        {
        }
        field(170; Date3; Date)
        {
        }
        field(180; DateTime1; DateTime)
        {
        }
        field(190; Decimal1; Decimal)
        {
        }
        field(200; Decimal2; Decimal)
        {
        }
        field(210; Decimal3; Decimal)
        {
        }
        field(220; Decimal4; Decimal)
        {
        }
        field(230; Decimal5; Decimal)
        {
        }
        field(240; Decimal6; Decimal)
        {
        }
        field(250; Decimal7; Decimal)
        {
        }
        field(260; Time1; Time)
        {
        }
        field(270; Time2; Time)
        {
        }
        field(280; Time3; Time)
        {
        }
        field(290; "30Txt1"; Text[30])
        {
        }
        field(300; "30Txt2"; Text[30])
        {
        }
        field(310; "10Txt1"; Text[10])
        {
        }
        field(320; "10Txt2"; Text[10])
        {
        }
    }

    keys
    {
        key(Key1; Type, "SIE Entry No.", Int4)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

