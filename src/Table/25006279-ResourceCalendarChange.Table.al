Table 25006005 "Resource Calendar Change"
//Table 25006279 "Resource Calendar Change"
{
    // 04.01.2008. EDMS P2
    //   * Added fields "Starting Time"
    //                  "Ending Time"

    Caption = 'Resource Calendar Change';

    fields
    {
        field(10; "Resource Code"; Code[20])
        {
            Caption = 'Resource Code';
            TableRelation = Resource;
        }
        field(20; Date; Date)
        {
            Caption = 'Date';
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(40; "Change Type"; Option)
        {
            Caption = 'Nonworking';
            OptionCaption = 'Work Time Change,Nonworking';
            OptionMembers = "Work Time Change",Nonworking;
        }
        field(50; "Starting Time"; Time)
        {
            Caption = 'Starting Time';

            trigger OnValidate()
            begin
                if "Ending Time" <> 0T then
                    if "Starting Time" >= "Ending Time" then
                        Error(Text001, FieldCaption("Starting Time"), FieldCaption("Ending Time"));
            end;
        }
        field(60; "Ending Time"; Time)
        {
            Caption = 'Ending Time';

            trigger OnValidate()
            begin
                if "Ending Time" <> 0T then
                    if "Ending Time" <= "Starting Time" then
                        Error(Text000, FieldCaption("Ending Time"), FieldCaption("Starting Time"));
            end;
        }
    }

    keys
    {
        key(Key1; "Resource Code", Date)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: label '%1 must be later than %2.';
        Text001: label '%1 must be earlier than %2.';
}

