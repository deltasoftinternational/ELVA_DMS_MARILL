Page 25006375 "Schedule Views"
{
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 16.05.2013 EDMS P8
    //   * Added field "Time Grid Item Code"

    ApplicationArea = Basic;
    Caption = 'Schedule Views';
    PageType = List;
    SourceTable = "Schedule View";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the schedule view.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the schedule view.';
                }
                field(ResourceGroup; Rec."Resource Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the list of resources that will be displayed when this schedule view is used.';
                }
                field(PeriodType; Rec."Period Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the period type that will be applied when this schedule view is used.';
                }
                field(StartDateFormula; Rec."Start Date Formula")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the formula how date will be calculated. Enter 0D to show current date.';
                }
                field(StartTime; Rec."Start Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting time to be used in service schedule.';
                }
                field(EndTime; Rec."End Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ending time to be used in service schedule.';
                }
                field(TimeGridCode; Rec."Time Grid Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the time grid code to apply to scheduler.';
                }
                field("Hide Time Reg Entries"; Rec."Hide Time Reg Entries")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if system should not show actual time registration entries as allocations in scheduler.';
                }
            }
        }
    }

    actions
    {
    }
}

