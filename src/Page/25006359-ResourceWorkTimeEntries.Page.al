Page 25006359 "Resource Work Time Entries"
{
    Caption = 'Resource Work Time Entries';
    PageType = List;
    SourceTable = "Resource Work Time Entry";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(ResourceName; Rec."Resource Name")
                {
                    ApplicationArea = Basic;
                }
                field(WorktimeBegin; Rec."Worktime Begin")
                {
                    ApplicationArea = Basic;
                }
                field(TimeBegin; TimeBegin)
                {
                    ApplicationArea = Basic;
                    Caption = 'Worktime Begin Std.';
                }
                field(WorktimeEnd; Rec."Worktime End")
                {
                    ApplicationArea = Basic;
                }
                field(TimeEnd; TimeEnd)
                {
                    ApplicationArea = Basic;
                    Caption = 'Worktime End Std.';
                }
                field(WorkedHours; Rec."Worked Hours")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Worktime Begin" <> 0 then
            TimeBegin := CreateDatetime(DateTimeMgt.Datetime2Date(Rec."Worktime Begin"), DateTimeMgt.Datetime2Time(Rec."Worktime Begin"))
        else
            TimeBegin := 0DT;

        if Rec."Worktime End" <> 0 then
            TimeEnd := CreateDatetime(DateTimeMgt.Datetime2Date(Rec."Worktime End"), DateTimeMgt.Datetime2Time(Rec."Worktime End"))
        else
            TimeEnd := 0DT;
    end;

    var
        TimeBegin: DateTime;
        TimeEnd: DateTime;
        DateTimeMgt: Codeunit "Datetime Mgt.";
}

