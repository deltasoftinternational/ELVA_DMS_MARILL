//Table 25006270 "Serv. Schedule Dim. Buffer"
Table 25006380 "Serv. Schedule Dim. Buffer"
{
    // 09.05.2008. EDMS P2
    //   * Added field "Code 2"

    Caption = 'Serv. Schedule Dim. Buffer';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Allocation On Hold"; Integer)
        {
            CalcFormula = count("Serv. Labor Allocation Entry" where("Source Type" = const("Service Document"),
                                                                      Status = const("On Hold"),
                                                                      "Resource No." = field(Code)));
            Caption = 'Allocation On Hold';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Day Period Start"; Date)
        {
            Caption = 'Day Period Start';
        }
        field(5; "Day Period End"; Date)
        {
            Caption = 'Day Period End';
        }
        field(6; Visible; Boolean)
        {
            Caption = 'Visible';
            InitValue = true;
        }
        field(7; Indentation; Integer)
        {
            Caption = 'Indentation';
        }
        field(8; "Show in Bold"; Boolean)
        {
            Caption = 'Show in Bold';
        }
        field(10; "Time Period Start"; Time)
        {
            Caption = 'Time Period Start';
        }
        field(12; "Time Period End"; Time)
        {
            Caption = 'Time Period End';
        }
        field(200; "Code 2"; Code[10])
        {
            Caption = 'Code 2';
        }
        field(210; Group; Boolean)
        {
            Caption = 'Group';
        }
        field(220; "Applies-to Code"; Code[20])
        {
            Caption = 'Applies-to Code';
        }
    }

    keys
    {
        key(Key1; "Code", "Code 2")
        {
            Clustered = true;
        }
        key(Key2; "Day Period Start")
        {
        }
        key(Key3; "Code 2", "Applies-to Code")
        {
        }
    }

    fieldgroups
    {
    }
}

