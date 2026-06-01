Table 25006004 "Data Buffer"
{
    // 07.08.2007. EDMS P2
    //   * Added key "Date Field 1,Code Field 3"

    Caption = 'Data Buffer';

    fields
    {
        field(10; "Entry No."; Integer)
        {
        }
        field(20; "Text Field 1"; Text[250])
        {
        }
        field(30; "Text Field 2"; Text[250])
        {
        }
        field(40; "Text Field 3"; Text[250])
        {
        }
        field(50; "Text Field 4"; Text[250])
        {
        }
        field(60; "Text Field 5"; Text[250])
        {
        }
        field(70; "Text Field 6"; Text[250])
        {
        }
        field(80; "Text Field 7"; Text[250])
        {
        }
        field(90; "Text Field 8"; Text[250])
        {
        }
        field(100; "Text Field 9"; Text[250])
        {
        }
        field(110; "Text Field 10"; Text[250])
        {
        }
        field(120; "Code Field 1"; Code[20])
        {
        }
        field(130; "Code Field 2"; Code[20])
        {
        }
        field(140; "Code Field 3"; Code[20])
        {
        }
        field(150; "Code Field 4"; Code[20])
        {
        }
        field(160; "Code Field 5"; Code[20])
        {
        }
        field(170; "Code Field 6"; Code[20])
        {
        }
        field(180; "Code Field 7"; Code[20])
        {
        }
        field(190; "Code Field 8"; Code[20])
        {
        }
        field(200; "Code Field 9"; Code[20])
        {
        }
        field(210; "Code Field 10"; Code[20])
        {
        }
        field(220; "Integer Field 1"; Integer)
        {
        }
        field(230; "Integer Field 2"; Integer)
        {
        }
        field(240; "Integer Field 3"; Integer)
        {
        }
        field(250; "Integer Field 4"; Integer)
        {
        }
        field(260; "Integer Field 5"; Integer)
        {
        }
        field(270; "Integer Field 6"; Integer)
        {
        }
        field(280; "Integer Field 7"; Integer)
        {
        }
        field(290; "Integer Field 8"; Integer)
        {
        }
        field(300; "Integer Field 9"; Integer)
        {
        }
        field(310; "Integer Field 10"; Integer)
        {
        }
        field(320; "Decimal Field 1"; Decimal)
        {
        }
        field(330; "Decimal Field 2"; Decimal)
        {
        }
        field(340; "Decimal Field 3"; Decimal)
        {
        }
        field(350; "Decimal Field 4"; Decimal)
        {
        }
        field(360; "Decimal Field 5"; Decimal)
        {
        }
        field(370; "Decimal Field 6"; Decimal)
        {
        }
        field(380; "Decimal Field 7"; Decimal)
        {
        }
        field(390; "Decimal Field 8"; Decimal)
        {
        }
        field(400; "Decimal Field 9"; Decimal)
        {
        }
        field(410; "Decimal Field 10"; Decimal)
        {
        }
        field(420; "Date Field 1"; Date)
        {
        }
        field(430; "Date Field 2"; Date)
        {
        }
        field(440; "Date Field 3"; Date)
        {
        }
        field(450; "Date Field 4"; Date)
        {
        }
        field(460; "Date Field 5"; Date)
        {
        }
        field(470; "Date Field 6"; Date)
        {
        }
        field(480; "Date Field 7"; Date)
        {
        }
        field(490; "Date Field 8"; Date)
        {
        }
        field(500; "Date Field 9"; Date)
        {
        }
        field(510; "Date Field 10"; Date)
        {
        }
        field(520; "Decimal Field 11"; Decimal)
        {
        }
        field(530; "Decimal Field 12"; Decimal)
        {
        }
        field(540; "Decimal Field 13"; Decimal)
        {
        }
        field(550; "Decimal Field 14"; Decimal)
        {
        }
        field(560; "Decimal Field 15"; Decimal)
        {
        }
        field(570; "Decimal Field 16"; Decimal)
        {
        }
        field(580; "Decimal Field 17"; Decimal)
        {
        }
        field(590; "Decimal Field 18"; Decimal)
        {
        }
        field(600; "Decimal Field 19"; Decimal)
        {
        }
        field(610; "Decimal Field 20"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Code Field 1", "Code Field 2", "Date Field 1", "Code Field 5")
        {
        }
        key(Key3; "Code Field 2", "Code Field 1", "Date Field 1", "Code Field 5")
        {
        }
        key(Key4; "Code Field 1", "Code Field 2", "Code Field 3", "Code Field 4", "Code Field 5")
        {
        }
        key(Key5; "Integer Field 1", "Date Field 1", "Code Field 1")
        {
        }
        key(Key6; "Code Field 3")
        {
        }
        key(Key7; "Code Field 1", "Decimal Field 1", "Date Field 1")
        {
        }
        key(Key8; "Code Field 5", "Integer Field 1", "Date Field 1")
        {
        }
        key(Key9; "Code Field 1", "Code Field 3", "Code Field 2", "Date Field 1", "Code Field 5")
        {
        }
        key(Key10; "Code Field 5", "Code Field 10", "Integer Field 1", "Date Field 1")
        {
        }
        key(Key11; "Date Field 1", "Code Field 3")
        {
        }
        key(Key12; "Code Field 1", "Date Field 1")
        {
        }
    }

    fieldgroups
    {
    }
}

