Table 25006705 "SIE Run-Time Params"
{
    Caption = 'SIE Run-Time Params';

    fields
    {
        field(10; "Run Mode"; Option)
        {
            Caption = 'Run Mode';
            OptionCaption = 'Flow,Synchronize,Post,Validate';
            OptionMembers = Flow,Synchronize,Post,Validate;
        }
        field(20; "Run Max. SIE Entry Num."; Integer)
        {
            Caption = 'Run Max. SIE Entry Num.';
        }
        field(30; "DSN Name"; Text[30])
        {
            Caption = 'DSN Name';
        }
        field(40; Direction; Option)
        {
            Caption = 'Direction';
            OptionCaption = 'Import,Export';
            OptionMembers = Import,Export;
        }
        field(50; "SIE No."; Code[10])
        {
            Caption = 'SIE No.';
        }
        field(60; "Max Date"; Date)
        {
            Caption = 'Max Date';
        }
        field(70; "Max Time"; Time)
        {
            Caption = 'Max Time';
        }
        field(120; "Posting Unit"; Integer)
        {
            Caption = 'Posting Unit';
        }
        field(300; "Asignment Unit"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Run Mode")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

