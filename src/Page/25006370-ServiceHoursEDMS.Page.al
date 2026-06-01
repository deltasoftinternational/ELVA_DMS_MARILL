Page 25006370 "Service Hours EDMS"
{
    ApplicationArea = Basic;
    Caption = 'Service Hours';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Hour EDMS";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(ServiceWorkGroupCode; Rec."Service Work Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a work group code to which these service hours would be defined. Work groups are assigned also to resources and that defines how mechanic works.';
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a starting date when the line is valid.';
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a day of the week for which working hours are defined.';
                }
                field(StartingTime; Rec."Starting Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies standard starting time of the day.';
                }
                field(EndingTime; Rec."Ending Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies standard ending time of the day.';
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an ending date when the line is valid.';
                }
            }
        }
    }

    actions
    {
    }
}

