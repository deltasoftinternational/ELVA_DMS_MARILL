Table 25006286 "Service Schedule Setup"
{
    // 06.01.2015 EB.P7 Schedule.Web
    //   * Field "Use Schedule Web" removed
    // 
    // 18.12.2014 EDMS P12
    //   * Renamed fields:
    //      Mark Unavailable Cells -> Show Unavailable Time
    //      Unavailable Cell Color -> Unavailable Time Color
    // 
    // 13.07.2014 P7 Elva Baltic
    //   * Field "Use Schedule Web" added
    // 
    // 21.10.2008. EDMS P2
    //   * Created

    Caption = 'Service Schedule Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
        }
        field(30; "Handle Linked Entries"; Option)
        {
            Caption = 'Handle Linked Entries';
            OptionCaption = 'No,Yes,Prompt';
            OptionMembers = No,Yes,Prompt;
        }
        field(40; "Planning Policy"; Option)
        {
            Caption = 'Planning Policy';
            OptionCaption = 'Appointment,Queue';
            OptionMembers = Appointment,Queue;
        }
        field(50; "Working Resource Color"; Integer)
        {
            Caption = 'Working Resource Color';
        }
        field(60; "Non-Working Resource Color"; Integer)
        {
            Caption = 'Non-Working Resource Color';
        }
        field(70; "Def. View Code"; Code[10])
        {
            Caption = 'Def. View Code';
            TableRelation = "Schedule View";
        }
        field(80; "Break Standard Code"; Code[20])
        {
            Caption = 'Break Standard Code';
            TableRelation = "Serv. Standard Event";
        }
        field(90; "Break Reason Code"; Code[10])
        {
            Caption = 'Break Reason Code';
            TableRelation = "Serv. Break Reason";
        }
        field(100; "Control Labor Sequence"; Boolean)
        {
            Caption = 'Control Labor Sequence';
        }
        field(110; "Control Skills"; Option)
        {
            Caption = 'Control Skills';
            OptionCaption = 'No,Only Planning,All Cases';
            OptionMembers = No,"Only Planning","All Cases";
        }
        field(120; "Control Document Statuses"; Boolean)
        {
            Caption = 'Control Document Statuses';
        }
        field(140; "Min. Notability (Hours)"; Decimal)
        {
        }
        field(160; "Post Only When Finished"; Boolean)
        {
            Caption = 'Post Only When Finished';
        }
        field(190; "Show Unavailable Time"; Boolean)
        {
            Caption = 'Show Unavailable Time';
        }
        field(200; "Replan Document"; Boolean)
        {
            Caption = 'Replan Document';
        }
        field(220; "Serv. Document Alloc. Method"; Option)
        {
            Caption = 'Serv. Document Alloc. Method';
            OptionCaption = 'Line or Header,Header,Line';
            OptionMembers = "Line or Header",Header,Line;
        }
        field(300; "Refresh Interval (ms)"; Integer)
        {
            Caption = 'Refresh Interval (ms)';
            Description = 'RTC only';
        }
        field(310; "Allocation Time Step (Minutes)"; Integer)
        {
            Caption = 'Allocation Time Step (Minutes)';
            InitValue = 5;
        }
        field(370; "Only Pers. Affect Doc. Status"; Boolean)
        {
            Caption = 'Only Pers. Affect Doc. Status';
        }
        field(380; "Resource Name in Schedule"; Option)
        {
            Caption = 'Resource Name in Schedule';
            OptionCaption = 'No.,Description,No.&Description';
            OptionMembers = "No.",Description,"No.&Description";
        }
        field(390; "Dashboard Refresh in Minutes"; Integer)
        {
            Caption = 'Service Dashboard Reffresh in Minutes';
        }
        field(400; "Dashboard Default Period"; Option)
        {
            OptionMembers = Day,Week;
        }
        field(410; "Disable Unavail. Time Control"; Boolean)
        {
            Caption = 'Disable Unavailable Time Control';
        }
        field(420; "Def. Serv. D. Alloc. Duration"; Decimal)
        {
            Caption = 'Default Service Document Allocation Duration (Hours)';
        }
        field(430; "Debug Mode"; Boolean)
        {
            Caption = 'Debug Mode';
        }
        field(440; "Time Format"; Option)
        {
            Caption = 'Time Format';
            OptionMembers = "24H","12H";
        }
        field(450; "Disable On Hold"; Boolean)
        {
            Caption = 'Disable On Hold';
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

    var
        Txt301: label 'Don''t forget to relate this Num. serie with Posted Sales Invoice Num. serie';
        Txt302: label 'Don''t forget to relate this Num. serie with Posted Sales Credit Memo Num. serie';
}

