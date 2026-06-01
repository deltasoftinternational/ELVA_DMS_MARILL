Table 25006173 "Service Plan Comment Line"
{
    // 12.01.2015 EB.P7 #Username length EDMS
    //   User ID Field length changed to Code(50)

    Caption = 'Service Plan Comment Line';
    DrillDownPageID = "Service Comment List EDMS";
    LookupPageID = "Service Comment List EDMS";

    fields
    {
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Plan Template,Plan Template Stage,Plan,Plan Stage';
            OptionMembers = "Plan Template","Plan Template Stage",Plan,"Plan Stage";
        }
        field(20; "Plan No."; Code[20])
        {
            Caption = 'Plan No.';
        }
        field(22; "Plan Stage Recurrence"; Integer)
        {
            Caption = 'Plan Stage Recurrence';
        }
        field(25; "Stage Code"; Code[20])
        {
            Caption = 'Stage Code';
        }
        field(27; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(40; Date; Date)
        {
            Caption = 'Date';
        }
        field(60; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(70; "User ID"; Code[50])
        {
            Caption = 'User ID';

            trigger OnLookup()
            var
                LoginMgt: Codeunit UserProfileManagement;
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
    }

    keys
    {
        key(Key1; Type, "Vehicle Serial No.", "Plan No.", "Plan Stage Recurrence", "Stage Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin
        "User ID" := UserId;
    end;
}

