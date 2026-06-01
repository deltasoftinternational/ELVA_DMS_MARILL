Page 25006368 "Service Schedule Setup"
{
    // 06.01.2015 EB.P7 Schedule.Web
    //   * Field "Use Schedule Web" removed
    // 
    // 13.07.2014 P7 Elva Baltic
    //   * Field "Use Schedule Web" added

    ApplicationArea = Basic;
    Caption = 'Service Schedule Setup';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Service Schedule Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                //field(BaseCalendarCode; "Base Calendar Code")
                //{
                //    ApplicationArea = Basic;
                //}
                field(DefViewCode; Rec."Def. View Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default service schedule view code. It is used when user opens scheduler for the first time. Later system remembers what view was used previously.';
                }
                field(RefreshIntervalms; Rec."Refresh Interval (ms)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies refresh interval in miliseconds for the service schedule. It specifies after how long system should reload data if scheduler is open.';
                }
                field(ResourceNameinSchedule; Rec."Resource Name in Schedule")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how resources used in service scheduler are identified. It is possible to select to use resource codes, resource names or both values.';
                }
                field(WorkingResourceColor; Rec."Working Resource Color")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the color code how to show mechanics that have registered the start of their working day.';
                }
                field(NonWorkingResourceColor; Rec."Non-Working Resource Color")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the color code how to show mechanics that have not registered the start of working day.';
                }
                field(ShowUnavailableTime; Rec."Show Unavailable Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if there should be highlighted time when mechanics are not working. It is time outside working hours and it will be in grey color.';
                }
                field(OnlyPersAffectDocStatus; Rec."Only Pers. Affect Doc. Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if allocation timer registrations of resources that are set to be persons will only cause work status changes in service documents.';
                }
                field(TimeFormat; Rec."Time Format")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time format to use in service scheduler.';
                }

            }
            group(Documents)
            {
                Caption = 'Documents';
                field(ControlDocumentStatuses; Rec."Control Document Statuses")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the work status fileds in service orders are controlled only by time planning and registration process. If the control is enabled then users are not allowed to edit those fields manually.';
                }
                field(PostOnlyWhenFinished; Rec."Post Only When Finished")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system would check that all allocations are in status Finished before service order is posted.';
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                field(PlanningPolicy; Rec."Planning Policy")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time format to use in service scheduler.';
                }
                field(ServDocumentAllocMethod; Rec."Serv. Document Alloc. Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default allocation method used in scheduling process. In Appointment method no changes in previous allocations will automatically change current one. In Que method if the previous allocation is finished earlier or later, then same difference is applied to next allocation. This methd can later be adjusted in service order for specific document.';
                }
                field(ReplanDocument; Rec."Replan Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the replanning of allocations is enabled in service schedule.';
                }
                field(HandleLinkedEntries; Rec."Handle Linked Entries")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should check and handle any linked entries. For example, if allocation does not fit the current day, its remainder can be moved to the next day. Any later change to first part would cause replanning for the remainder allocation.';
                }
                field(MinNotabilityHours; Rec."Min. Notability (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the minimum amount of time that is long enough to start replanning and offer to move remainder to next day.';
                }
                field(ControlSkills; Rec."Control Skills")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the system should control skills in scheduler and how it should be done. Skills can be assigned to labor codes and mechanics and on planning or work registration system can verify that mechanic has the right skills to perform the task.';
                }
                field(ControlLaborSequence; Rec."Control Labor Sequence")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the system should control allocations planned in sequence.';
                }
                field(AllocationTimeStepMinutes; Rec."Allocation Time Step (Minutes)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time step used in planning. For example, if time step is 5 minutes then when adding or replanning allocations system would calculate start time to be rounded to the nearest 5 minutes.';
                }
            }
            group(TimeRegistration)
            {
                Caption = 'Time Registration';
                field(BreakStandardCode; Rec."Break Standard Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the standard event that will be used by default to register breaks in time registration.';
                }
                field(BreakReasonCode; Rec."Break Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code that will be used by default to register breaks in time registration.';
                }
                field(DashboardRefreshinMinutes; Rec."Dashboard Refresh in Minutes")
                {
                    ApplicationArea = Basic;
                }
                field(DashboardDefaultPeriod; Rec."Dashboard Default Period")
                {
                    ApplicationArea = Basic;
                }
                field("Disable On Hold"; Rec."Disable On Hold")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the On-Hold functionality in time registration should be disabled.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;

    var
        [InDataSet]
        NonworkingDayColorEditable: Boolean;
}

