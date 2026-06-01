Table 25006129 "Service Hour EDMS"
{
    Caption = 'Service Hour';
    LookupPageID = "Service Hours";

    fields
    {
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(20; Day; Option)
        {
            Caption = 'Day';
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(30; "Starting Time"; Time)
        {
            Caption = 'Starting Time';

            trigger OnValidate()
            begin
                if "Ending Time" <> 0T then
                    if "Starting Time" >= "Ending Time" then
                        Error(Text001, FieldCaption("Starting Time"), FieldCaption("Ending Time"));
            end;
        }
        field(40; "Ending Time"; Time)
        {
            Caption = 'Ending Time';

            trigger OnValidate()
            begin
                if "Ending Time" <> 0T then
                    if "Ending Time" <= "Starting Time" then
                        Error(Text000, FieldCaption("Ending Time"), FieldCaption("Starting Time"));
            end;
        }
        field(50; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(60; "Service Work Group Code"; Code[20])
        {
            Caption = 'Service Work Group Code';
            TableRelation = "Service Work Group";
        }
    }

    keys
    {
        key(Key1; "Service Work Group Code", "Starting Date", Day, "Starting Time")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CheckTime;
    end;

    trigger OnModify()
    begin
        CheckTime;
    end;

    var
        Text000: label '%1 must be later than %2.';
        Text001: label '%1 must be earlier than %2.';
        Text002: label 'You must specify %1.';


    procedure CheckTime()
    begin
        if "Starting Time" = 0T then
            Error(Text002, FieldCaption("Starting Time"));
        if "Ending Time" = 0T then
            Error(Text002, FieldCaption("Ending Time"));
    end;
}

