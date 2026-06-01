Codeunit 25006290 "Resource Time Reg. Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        UserResourceSetupErr: label 'There is no Resource No. configured in User Setup.';
        TimeRegisterInProgressMsg: label 'Task status set to "In Progress"';
        TimeRegisterOnHoldMsg: label 'Task status set to "On Hold"';
        TimeRegisterFinishedMsg: label 'Task status set to "Finised"';
        TimeRegisterPendingMsg: label 'Task status set to "Pending"';
        CurrentUserId: Code[50];
        DateTimeMgt: Codeunit "Datetime Mgt.";
        UserSetup: Record "User Setup";
        TimeRegisterCancStartMsg: label 'Task status "In Progress" cancelled';
        SingleInstanceManagment: Codeunit SingleInstanceManagement;
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        ServiceScheduleSetup: Record "Service Schedule Setup";
        TimeModifiedLastEntryMsg: label 'New time succesfully set.';
        TimeModifyNotLastEntryMsg: label 'Time can be modified only for last record.';
        ValidateActionStartErr: label 'You can''t start task, that is already started.';
        ValidateActionPostedDocErr: label 'Can''t process action. Document already posted.';
        ValidateResourceWorktimeErr: label 'Resource %1 have to start work time first.';
        TimeRegisterWorkingTxt: label 'Working';
        TimeRegisterNotWorkingTxt: label 'Not Working';
        ServiceTimeRegFinishMsg: label 'Service time registering finished.';
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ExistingActiveAllocationMsg: label 'This action is already started. Please check your curretn task list.';
        DateOlderDocumentErr: label 'Entry No %1 can not be posted because the date is older than Order Date on document';
        DateGreaterTodayErr: label 'Entry No %1 can not be posted because the date is greater than today''s date';
        DateTimeAlreadyRegErr: label 'It is not possible to register entry No. %1 because there is already registered time on %2 from %3 till %4';
        ModifyNotAllowedErr: label 'Delete or Modify not allowed for posted document resource time entries.';


    procedure GetCurrentUserResourceNo(): Code[20]
    begin
        if UserSetup.Get(SingleInstanceManagment.GetCurrentUserId) then
            exit(UserSetup."Resource No.")
        else
            Error(UserResourceSetupErr);
    end;


    procedure GetResourceNoByUserId(UserID: Code[50]): Code[20]
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserID) then
            exit(UserSetup."Resource No.")
        else
            Error(UserResourceSetupErr);
    end;


    procedure AddTimeRegEntries("Action": Code[20]; ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"; CurrentResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
        Period: Record Date;
        PeriodTime: Time;
        NextPeriodDate: Date;
    begin
        //Add previous entries if needed>>
        if (Action = 'ONHOLD') or (Action = 'STOP') or (Action = 'COMPLETE') then begin
            ResourceTimeRegEntry.Reset;
            ResourceTimeRegEntry.SetRange("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
            ResourceTimeRegEntry.SetRange("Resource No.", CurrentResourceNo);
            ResourceTimeRegEntry.SetRange("Worktime Entry", false);
            ResourceTimeRegEntry.SetRange(Canceled, false);

            if ResourceTimeRegEntry.FindLast and (ResourceTimeRegEntry."Entry Type" = ResourceTimeRegEntry."entry type"::"In Progress") then begin
                Period.Reset;
                Period.SetRange(Period."Period Type", Period."period type"::Date);
                Period.SetRange(Period."Period Start", ResourceTimeRegEntry.Date, OnDate);
                if Period.FindFirst then
                    repeat
                        if Period."Period Start" <> OnDate then begin
                            PeriodTime := 235959T;
                            AddTimeRegEntry('OnHold', ServLaborAllocationEntry, CurrentResourceNo, Period."Period Start", PeriodTime);
                            NextPeriodDate := Period."Period Start" + 1;
                            PeriodTime := 000000T;
                            AddTimeRegEntry('Start', ServLaborAllocationEntry, CurrentResourceNo, NextPeriodDate, PeriodTime);
                        end;
                    until Period.Next = 0;
            end;
        end;
        //Add previous entries if needed<<
        AddTimeRegEntry(Action, ServLaborAllocationEntry, CurrentResourceNo, OnDate, OnTime);
    end;


    procedure AddTimeRegEntry("Action": Code[20]; ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"; CurrentResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
        EntryNo: Integer;
        PresentTime: DateTime;
        ActualWorkSpentTime: Decimal;
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        FirstEntryDate: Date;
        IsIdle: Boolean;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        IsTravel: Boolean;
    begin
        ResourceTimeRegEntry.Reset;
        if ResourceTimeRegEntry.FindLast then
            EntryNo := ResourceTimeRegEntry."Entry No." + 1
        else
            EntryNo := 1;

        //Get First Entry Date
        ResourceTimeRegEntry.Reset;
        ResourceTimeRegEntry.SetRange("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
        ResourceTimeRegEntry.SetRange("Resource No.", CurrentResourceNo);
        ResourceTimeRegEntry.SetRange(Canceled, false);
        if ResourceTimeRegEntry.FindFirst then
            FirstEntryDate := ResourceTimeRegEntry.Date
        else
            FirstEntryDate := OnDate;

        //Calculate actual work spent time
        ResourceTimeRegEntry.Reset;
        ResourceTimeRegEntry.SetRange("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
        ResourceTimeRegEntry.SetRange("Resource No.", CurrentResourceNo);
        ResourceTimeRegEntry.SetRange(Canceled, false);
        PresentTime := CreateDatetime(OnDate, OnTime);
        if ResourceTimeRegEntry.FindLast and (ResourceTimeRegEntry."Entry Type" = ResourceTimeRegEntry."entry type"::"In Progress") then begin
            ActualWorkSpentTime := ROUND((PresentTime - CreateDatetime(ResourceTimeRegEntry.Date, ResourceTimeRegEntry.Time)) / 3600000, 0.0001);
        end;

        //Check if Allocation is Idle
        ServiceSetup.Get;
        IsIdle := ServLaborAllocationEntry."Source ID" = ServiceSetup."Default Idle Event";
        IsTravel := ServLaborAllocationEntry.Travel;
        //Calculate Actual Work Percentage
        //PlanedWorkTime := ServLaborAllocationEntry."End Date-Time" - ServLaborAllocationEntry."Start Date-Time";
        //ActualWorkPercentage := ROUND(ActualWorkTime/PlanedWorkTime,0.01)*100;
        case Action of
            'START':
                begin
                    ResourceTimeRegEntry.Init;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Allocation Entry No." := ServLaborAllocationEntry."Entry No.";
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."entry type"::"In Progress";
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := ActualWorkSpentTime;
                    ResourceTimeRegEntry."Start Entry Date" := FirstEntryDate;
                    ResourceTimeRegEntry.Idle := IsIdle;
                    ResourceTimeRegEntry.Travel := IsTravel;
                    ResourceTimeRegEntry."Source Type" := ServLaborAllocationEntry."Source Type";
                    ResourceTimeRegEntry."Source Subtype" := ServLaborAllocationEntry."Source Subtype";
                    ResourceTimeRegEntry."Source ID" := ServLaborAllocationEntry."Source ID";
                    ResourceTimeRegEntry.Insert;
                end;
            'ONHOLD':
                begin
                    ResourceTimeRegEntry.Init;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Allocation Entry No." := ServLaborAllocationEntry."Entry No.";
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."entry type"::"On Hold";
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := ActualWorkSpentTime;
                    ResourceTimeRegEntry."Start Entry Date" := FirstEntryDate;
                    ResourceTimeRegEntry.Idle := IsIdle;
                    ResourceTimeRegEntry.Travel := IsTravel;
                    ResourceTimeRegEntry."Source Type" := ServLaborAllocationEntry."Source Type";
                    ResourceTimeRegEntry."Source Subtype" := ServLaborAllocationEntry."Source Subtype";
                    ResourceTimeRegEntry."Source ID" := ServLaborAllocationEntry."Source ID";
                    ResourceTimeRegEntry.Insert;
                end;
            'STOP':
                begin
                    ResourceTimeRegEntry.Init;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Allocation Entry No." := ServLaborAllocationEntry."Entry No.";
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."entry type"::Pending;
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := ActualWorkSpentTime;
                    ResourceTimeRegEntry."Start Entry Date" := FirstEntryDate;
                    ResourceTimeRegEntry.Idle := IsIdle;
                    ResourceTimeRegEntry.Travel := IsTravel;
                    ResourceTimeRegEntry."Source Type" := ServLaborAllocationEntry."Source Type";
                    ResourceTimeRegEntry."Source Subtype" := ServLaborAllocationEntry."Source Subtype";
                    ResourceTimeRegEntry."Source ID" := ServLaborAllocationEntry."Source ID";
                    ResourceTimeRegEntry.Insert;
                end;
            'COMPLETE':
                begin
                    ResourceTimeRegEntry.Init;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Allocation Entry No." := ServLaborAllocationEntry."Entry No.";
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."entry type"::Finished;
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := ActualWorkSpentTime;
                    ResourceTimeRegEntry."Start Entry Date" := FirstEntryDate;
                    ResourceTimeRegEntry.Idle := IsIdle;
                    ResourceTimeRegEntry.Travel := IsTravel;
                    ResourceTimeRegEntry."Source Type" := ServLaborAllocationEntry."Source Type";
                    ResourceTimeRegEntry."Source Subtype" := ServLaborAllocationEntry."Source Subtype";
                    ResourceTimeRegEntry."Source ID" := ServLaborAllocationEntry."Source ID";
                    ResourceTimeRegEntry.Insert;

                    //MESSAGE(TimeRegisterFinishedMsg);
                end;
            'CANCELSTART':
                begin
                    if ServLaborAllocationEntry.Status = ServLaborAllocationEntry.Status::"In Progress" then begin
                        ResourceTimeRegEntry.Reset;
                        ResourceTimeRegEntry.SetRange("Resource No.", CurrentResourceNo);
                        ResourceTimeRegEntry.SetRange("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
                        if ResourceTimeRegEntry.FindLast and (ResourceTimeRegEntry."Entry Type" = ResourceTimeRegEntry."entry type"::"In Progress") then begin
                            ResourceTimeRegEntry.Canceled := true;
                            ResourceTimeRegEntry.Modify;
                            //MESSAGE(TimeRegisterCancStartMsg);
                        end;
                    end;
                end;




        end;

        onafterTimeRegEntry(ServLaborAllocationEntry, ResourceTimeRegEntry);

        ServLaborAllocationEntry.CalcFields("Total Time Spent");
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
        if ServLaborAllocApplication.FindFirst then
            repeat
                ServLaborAllocApplication.Validate("Finished Quantity (Hours)", ServLaborAllocationEntry."Total Time Spent");
                ServLaborAllocApplication.Validate("Remaining Quantity (Hours)", ServLaborAllocationEntry."Quantity (Hours)" - ServLaborAllocationEntry."Total Time Spent");
                ServLaborAllocApplication.Modify;
            until ServLaborAllocApplication.Next = 0;
    end;


    procedure AddWorkTimeRegEntries("Action": Code[20]; CurrentResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
        EntryNo: Integer;
        PresentTime: DateTime;
        ActualWorkSpentTime: Decimal;
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        Period: Record Date;
        PeriodTime: Time;
        NextPeriodDate: Date;
    begin
        //Add previous entries if needed>>
        if (Action = 'FINISHWORKTIME') then begin
            ResourceTimeRegEntry.Reset;
            //ResourceTimeRegEntry.SETRANGE("Allocation Entry No.",ServLaborAllocationEntry."Entry No.");
            ResourceTimeRegEntry.SetRange("Resource No.", CurrentResourceNo);
            ResourceTimeRegEntry.SetRange("Worktime Entry", true);
            ResourceTimeRegEntry.SetRange(Canceled, false);

            if ResourceTimeRegEntry.FindLast and (ResourceTimeRegEntry."Entry Type" = ResourceTimeRegEntry."entry type"::"In Progress") then begin
                Period.Reset;
                Period.SetRange(Period."Period Type", Period."period type"::Date);
                Period.SetRange(Period."Period Start", ResourceTimeRegEntry.Date, OnDate);
                if Period.FindFirst then
                    repeat
                        if Period."Period Start" <> OnDate then begin
                            PeriodTime := 235959T;
                            AddWorkTimeRegEntry('FinishWorktime', CurrentResourceNo, Period."Period Start", PeriodTime);
                            NextPeriodDate := Period."Period Start" + 1;
                            PeriodTime := 000000T;
                            AddWorkTimeRegEntry('StartWorktime', CurrentResourceNo, NextPeriodDate, PeriodTime);
                        end;
                    until Period.Next = 0;
            end;
        end;
        //Add previous entries if needed<<

        AddWorkTimeRegEntry(Action, CurrentResourceNo, OnDate, OnTime);
    end;


    procedure AddWorkTimeRegEntry("Action": Code[20]; CurrentResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
        EntryNo: Integer;
        PresentTime: DateTime;
        ActualWorkSpentTime: Decimal;
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        FirstEntryDate: Date;
    begin
        ResourceTimeRegEntry.Reset;
        if ResourceTimeRegEntry.FindLast then
            EntryNo := ResourceTimeRegEntry."Entry No." + 1
        else
            EntryNo := 1;

        //Get First Entry Date
        ResourceTimeRegEntry.Reset;
        ResourceTimeRegEntry.SetRange(ResourceTimeRegEntry."Worktime Entry", true);
        ResourceTimeRegEntry.SetRange("Resource No.", CurrentResourceNo);
        ResourceTimeRegEntry.SetRange(ResourceTimeRegEntry."Entry Type", ResourceTimeRegEntry."entry type"::"In Progress");
        ResourceTimeRegEntry.SetRange(Canceled, false);
        if ResourceTimeRegEntry.FindLast then
            FirstEntryDate := ResourceTimeRegEntry.Date
        else
            FirstEntryDate := OnDate;

        case Action of
            'STARTWORKTIME':
                begin
                    ResourceTimeRegEntry.Init;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."entry type"::"In Progress";
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := 0;
                    ResourceTimeRegEntry."Worktime Entry" := true;
                    ResourceTimeRegEntry."Start Entry Date" := OnDate;
                    ResourceTimeRegEntry.Insert;
                end;
            'FINISHWORKTIME':
                begin

                    //Calculate actual work spent time
                    ResourceTimeRegEntry.Reset;
                    ResourceTimeRegEntry.SetRange("Resource No.", CurrentResourceNo);
                    ResourceTimeRegEntry.SetRange(Canceled, false);
                    ResourceTimeRegEntry.SetRange(ResourceTimeRegEntry."Worktime Entry", true);
                    PresentTime := CreateDatetime(OnDate, OnTime);
                    if ResourceTimeRegEntry.FindLast then begin
                        ActualWorkSpentTime := ROUND((PresentTime - CreateDatetime(ResourceTimeRegEntry.Date, ResourceTimeRegEntry.Time)) / 3600000, 0.0001);
                    end;

                    ResourceTimeRegEntry.Init;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."entry type"::Finished;
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := ActualWorkSpentTime;
                    ResourceTimeRegEntry."Worktime Entry" := true;
                    ResourceTimeRegEntry."Start Entry Date" := FirstEntryDate;
                    ResourceTimeRegEntry.Insert;
                end;
        end;
    end;


    procedure GetTaskColor(TimeRegStatus: Option Pending,"In Progress",Finished,"On Hold"; ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"): Text[20]
    var
        DTWorkTime: Decimal;
        RowAttention: Text[20];
    begin
        if TimeRegStatus <> Timeregstatus::Finished then begin
            DTWorkTime := DateTimeMgt.Datetime(WorkDate, Time);
            if ServLaborAllocationEntry."End Date-Time" < DTWorkTime then
                RowAttention := 'Attention';
        end;

        if TimeRegStatus = Timeregstatus::"In Progress" then
            RowAttention := 'Favorable';

        exit(RowAttention);
    end;


    procedure GetTaskColorPool(ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"): Text[20]
    var
        DTWorkTime: Decimal;
        RowAttention: Text[20];
    begin
        if ServLaborAllocationEntry.Status <> ServLaborAllocationEntry.Status::Finished then begin
            DTWorkTime := DateTimeMgt.Datetime(WorkDate, Time);
            if ServLaborAllocationEntry."End Date-Time" < DTWorkTime then
                RowAttention := 'Attention';
        end;

        if ServLaborAllocationEntry.Status = ServLaborAllocationEntry.Status::"In Progress" then
            RowAttention := 'Favorable';

        exit(RowAttention);
    end;


    procedure GetDashboardCaption(ResourceNo: Code[20]): Text[100]
    var
        DashboardTitle: Text[100];
        UserProfileManagement: Codeunit UserProfileManagement;
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        Resource: Record Resource;
    begin
        //DashboardTitle := UserProfileManagement.GetUserFullName(SingleInstanceManagment.GetCurrentUserId);
        if Resource.Get(ResourceNo) then
            DashboardTitle := Resource.Name;
        DashboardTitle := UpperCase(DashboardTitle);
        DashboardTitle += '  :  ' + GetCurrentPeriodText;

        if ResourceTimeRegMgt.IsResourceWorking(ResourceNo) then
            DashboardTitle += '  :  ' + TimeRegisterWorkingTxt
        else
            DashboardTitle += '  :  ' + TimeRegisterNotWorkingTxt;

        exit(DashboardTitle)
    end;


    procedure GetDashboardRefreshInMinutes(): Integer
    begin
        ServiceScheduleSetup.Get;
        if ServiceScheduleSetup."Dashboard Refresh in Minutes" <> 0 then
            exit(ServiceScheduleSetup."Dashboard Refresh in Minutes")
        else
            exit(5);
    end;


    procedure UndoLastAction(AllocationEntryNo: Integer; ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
        ResourceTimeRegEntryPrev: Record "Resource Time Reg. Entry";
        ResourceTimeRegEntryLast: Record "Resource Time Reg. Entry";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServScheduleMgt: Codeunit "Service Schedule Mgt.";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        AllocationStatus: Option Pending,"In Process","Finish All","Finish Part","On Hold";
    begin
        ResourceTimeRegEntry.Reset;
        ResourceTimeRegEntry.SetRange("Resource No.", ResourceNo);
        ResourceTimeRegEntry.SetRange("Allocation Entry No.", AllocationEntryNo);
        ResourceTimeRegEntry.SetRange(Canceled, false);
        if ResourceTimeRegEntry.FindLast then begin
            ResourceTimeRegEntryLast := ResourceTimeRegEntry;
            if ResourceTimeRegEntry.Next(-1) <> 0 then begin
                ResourceTimeRegEntryPrev := ResourceTimeRegEntry;
                if ServLaborAllocationEntry.Get(ResourceTimeRegEntryPrev."Allocation Entry No.") then begin
                    case ResourceTimeRegEntryPrev."Entry Type" of
                        ResourceTimeRegEntryPrev."entry type"::"In Progress":
                            UpdateAllocationStatus('START', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime, '');
                        ResourceTimeRegEntryPrev."entry type"::Finished:
                            UpdateAllocationStatus('COMPLETE', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime, '');
                        ResourceTimeRegEntryPrev."entry type"::"On Hold":
                            UpdateAllocationStatus('ONHOLD', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime, '');
                        ResourceTimeRegEntryPrev."entry type"::Pending:
                            UpdateAllocationStatus('CANCELSTART', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime, '');
                    end;
                end;
                ResourceTimeRegEntryLast.Canceled := true;
                ResourceTimeRegEntryLast.Modify;
            end else begin
                if ServLaborAllocationEntry.Get(ResourceTimeRegEntryLast."Allocation Entry No.") then begin
                    UpdateAllocationStatus('CANCELSTART', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime, '');
                end;
                ResourceTimeRegEntryLast."Entry Type" := ResourceTimeRegEntryLast."entry type"::Pending;
                ResourceTimeRegEntryLast.Modify;
            end;
        end;
    end;


    procedure SetPeriodFilter(var ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry")
    var
        DTDayStart: Decimal;
        DTDayEnd: Decimal;
        DateToSet: Date;
        Period: Option;
    begin
        ServiceScheduleSetup.Get;
        if SingleInstanceManagment.GetCurrentPeriod = 0 then
            Period := GetDefaultPeriod
        else
            Period := SingleInstanceManagment.GetCurrentPeriod;

        DateToSet := SingleInstanceManagment.GetCurrentDate;
        case Period of
            1: //Day
                begin
                    DTDayStart := DateTimeMgt.Datetime(DateToSet, 0T);
                    DTDayEnd := DateTimeMgt.Datetime(DateToSet, 235959.999T);
                    SingleInstanceManagment.SetCurrentPeriod(1);
                end;
            2: //Week
                begin
                    DTDayStart := DateTimeMgt.Datetime(CalcDate('<-CW>', DateToSet), 0T);
                    DTDayEnd := DateTimeMgt.Datetime(CalcDate('<CW>', DateToSet), 235959.999T);
                    SingleInstanceManagment.SetCurrentPeriod(2);
                end;
        end;
        ServLaborAllocationEntry.SetFilter("Start Date-Time", '..%1', DTDayEnd);
        ServLaborAllocationEntry.SetFilter("End Date-Time", '%1..', DTDayStart);
    end;


    procedure SetPeriodFilterResourceLink(var ScheduleResourceLink: Record "Schedule Resource Link")
    var
        DTDayStart: Date;
        DTDayEnd: Date;
        DateToSet: Date;
        Period: Option;
    begin
        ServiceScheduleSetup.Get;
        if SingleInstanceManagment.GetCurrentPeriod = 0 then
            Period := GetDefaultPeriod
        else
            Period := SingleInstanceManagment.GetCurrentPeriod;

        DateToSet := SingleInstanceManagment.GetCurrentDate;
        case Period of
            1: //Day
                begin
                    DTDayStart := DateToSet;
                    DTDayEnd := DateToSet;
                    SingleInstanceManagment.SetCurrentPeriod(1);
                end;
            2: //Week
                begin
                    DTDayStart := CalcDate('<-CW>', DateToSet);
                    DTDayEnd := CalcDate('<CW>', DateToSet);
                    SingleInstanceManagment.SetCurrentPeriod(2);
                end;
        end;
        ScheduleResourceLink.SetFilter("Starting Date", '..%1|%2', DTDayEnd, 0D);
        ScheduleResourceLink.SetFilter("Ending Date", '%1..|%2', DTDayStart, 0D);

        //ScheduleResourceLink.SETFILTER("Starting Date",'0D',DTDayEnd);
        //ScheduleResourceLink.SETFILTER("Ending Date",'0D',DTDayStart);
    end;


    procedure MovePeriodFilter(Shift: Integer)
    var
        DTDayStart: Decimal;
        DTDayEnd: Decimal;
        DateToSet: Date;
    begin
        case SingleInstanceManagment.GetCurrentPeriod of
            1: //Day
                begin
                    SingleInstanceManagment.SetCurrentDate(SingleInstanceManagment.GetCurrentDate + Shift);
                end;
            2: //Week
                begin
                    SingleInstanceManagment.SetCurrentDate(SingleInstanceManagment.GetCurrentDate + Shift * 7);
                end;
        end;
    end;


    procedure GetCurrentPeriodText(): Text
    var
        DayStart: Date;
        DayEnd: Date;
    begin
        if SingleInstanceManagment.GetCurrentPeriod = 1 then
            exit(Format(SingleInstanceManagment.GetCurrentDate))
        else begin
            DayStart := CalcDate('<-CW>', SingleInstanceManagment.GetCurrentDate);
            DayEnd := CalcDate('<CW>', SingleInstanceManagment.GetCurrentDate);
            exit(Format(DayStart) + ' - ' + Format(DayEnd));
        end;
    end;


    procedure GetDefaultPeriod(): Integer
    begin
        ServiceScheduleSetup.Get;
        case ServiceScheduleSetup."Dashboard Default Period" of
            0: //Day
                begin
                    SingleInstanceManagment.SetCurrentPeriod(1);
                end;
            1: //Week
                begin
                    SingleInstanceManagment.SetCurrentPeriod(2);
                end;
        end;

        exit(SingleInstanceManagment.GetCurrentPeriod);
    end;


    procedure IsResourceWorking(ResourceNo: Code[20]): Boolean
    var
        WorkTimeEntry: Record "Resource Work Time Entry";
    begin
        WorkTimeEntry.SetCurrentkey("Resource No.", Closed);
        WorkTimeEntry.SetRange("Resource No.", ResourceNo);
        WorkTimeEntry.SetRange(Closed, false);
        if not WorkTimeEntry.FindLast then
            exit(false)
        else
            exit(true);
    end;


    procedure StartNewTaskFromHeader(ServiceHeader: Record "Service Header EDMS"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time; IsTravel: Boolean): Integer
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationApp: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS" temporary;
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page Allocation;
        AllocatedEntryNo: Integer;
        WorkTimeEntry: Record "Resource Work Time Entry";
    begin
        ServiceScheduleSetup.Get;
        //ResourceNo := GetCurrentUserResourceNo;
        if not SingleInstanceManagment.GetTimeJournalFlag then begin
            WorkTimeEntry.Reset;
            WorkTimeEntry.SetCurrentkey("Resource No.", Closed);
            WorkTimeEntry.SetRange("Resource No.", ResourceNo);
            WorkTimeEntry.SetRange(Closed, false);
            if not WorkTimeEntry.FindLast then
                Error(StrSubstNo(ValidateResourceWorktimeErr, ResourceNo));
        end;
        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := false;
        SourceType := ServLaborAllocationEntry."source type"::"Service Document";
        Mode := Mode::"New Allocation";
        SourceSubType := ServiceHeader."Document Type";
        SourceID := ServiceHeader."No.";
        Clear(ServiceScheduleMgt);

        //ServiceScheduleMgt.CheckForCorrectServHeaderLine(ServiceHeader, ServiceLine, WhatAllocation::Header);
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange("Line No.", 0);

        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, SourceType, SourceSubType, SourceID, 0, ServiceLine, 1);
        AllocationForm.SetInvisibles(ServiceScheduleSetup."Def. Serv. D. Alloc. Duration");
        AllocationForm.SetIsTravel(IsTravel);
        AllocatedEntryNo := AllocationForm.Allocate;

        if ServLaborAllocationEntry.Get(AllocatedEntryNo) then begin
            FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
        end;
        OnAfterStartNewTaskFromHeader(AllocatedEntryNo);
        exit(AllocatedEntryNo);
    end;


    procedure StartNewTaskFromLine(ServiceLine1: Record "Service Line EDMS"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time; IsTravel: Boolean)
    var
        ServiceHeader: Record "Service Header EDMS";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        StartDateTime: Decimal;
        CurrQtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        ServiceLine: Record "Service Line EDMS";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        WhatAllocation: Option Header,Line;
        AllocationForm: Page Allocation;
        ServiceLine2: Record "Service Line EDMS" temporary;
        AllocatedEntryNo: Integer;
        WorkTimeEntry: Record "Resource Work Time Entry";
    begin
        //ResourceNo := GetCurrentUserResourceNo;

        if not SingleInstanceManagment.GetTimeJournalFlag then begin
            WorkTimeEntry.Reset;
            WorkTimeEntry.SetCurrentkey("Resource No.", Closed);
            WorkTimeEntry.SetRange("Resource No.", ResourceNo);
            WorkTimeEntry.SetRange(Closed, false);
            if not WorkTimeEntry.FindLast then
                Error(StrSubstNo(ValidateResourceWorktimeErr, ResourceNo));
        end;

        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := false;
        Clear(ServiceScheduleMgt);
        LineNo := 0;
        SourceSubType := ServiceLine1."Document Type";
        SourceID := ServiceLine1."Document No.";
        SourceType := ServLaborAllocationEntry."source type"::"Service Document";

        ServiceLine2 := ServiceLine1;
        ServiceLine2.Insert;

        //ServiceScheduleMgt.CheckForCorrectServHeaderLine(ServiceHeader, ServiceLine2, WhatAllocation::Line);

        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, SourceType, SourceSubType, SourceID, 0, ServiceLine2, 1);
        AllocationForm.SetInvisibles(0);
        AllocationForm.SetIsTravel(IsTravel);
        AllocatedEntryNo := AllocationForm.Allocate;

        if ServLaborAllocationEntry.Get(AllocatedEntryNo) then begin
            FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
        end;
    end;


    procedure StartNewTaskFromStandard(ResourceNo: Code[20]; OnDate: Date; OnTime: Time): Integer
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationApp: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS" temporary;
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page Allocation;
        AllocatedEntryNo: Integer;
        StandardEvents: Page "Serv. Standard Events";
        StandardEvent: Record "Serv. Standard Event";
        WorkTimeEntry: Record "Resource Work Time Entry";
        MeetingDescription: Text;
        EasyTimeMeetingDialog: Page "Easy Clocking Start Meeting";
    begin
        ServiceScheduleSetup.Get;
        //ResourceNo := GetCurrentUserResourceNo;

        WorkTimeEntry.Reset;
        WorkTimeEntry.SetCurrentkey("Entry No.");
        WorkTimeEntry.SetRange("Resource No.", ResourceNo);
        WorkTimeEntry.SetRange(Closed, false);
        if not WorkTimeEntry.FindLast then
            Error(StrSubstNo(ValidateResourceWorktimeErr, ResourceNo));

        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := false;
        SourceType := ServLaborAllocationEntry."source type"::"Service Document";
        Mode := Mode::"New Allocation";
        //SourceSubType := ServiceHeader."Document Type";
        //SourceID := ServiceHeader."No.";
        Clear(ServiceScheduleMgt);


        //IF NOT CheckUserRightsAdv(2, LaborAllocEntry) THEN EXIT;
        Clear(StandardEvents);
        StandardEvents.LookupMode(true);
        if StandardEvents.RunModal = Action::LookupOK then begin
            StandardEvents.GetRecord(StandardEvent);
            //Allocate(ResourceNo,StartingDateTime,0,2,0,StandardEvent.Code,ServLine,0);

            if StandardEvent.Code = 'MEETING' then begin
                MeetingDescription := '';
                EasyTimeMeetingDialog.RunModal;
                MeetingDescription := EasyTimeMeetingDialog.GetMeetingDescription;
            end;

            Clear(AllocationForm);
            AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, 2, 0, StandardEvent.Code, 0, ServiceLine, 1);
            AllocationForm.SetDescription(MeetingDescription);
            AllocationForm.SetInvisibles(0);
            AllocatedEntryNo := AllocationForm.Allocate;

            if ServLaborAllocationEntry.Get(AllocatedEntryNo) then begin
                FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
                AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
            end;
        end;

        exit(AllocatedEntryNo);
    end;


    procedure CalculateDuration(var DurationPar: Duration; var QtyToAllocate: Decimal; WhichWay: Option "To Duration","From Duration")
    begin
        if WhichWay = Whichway::"To Duration" then
            DurationPar := ROUND(QtyToAllocate * 3600000, 1);

        if WhichWay = Whichway::"From Duration" then
            QtyToAllocate := ROUND(DurationPar / 3600000, 0.0001);
    end;


    procedure GetNextNewAllocEntryNo(): Integer
    var
        ServLaborAllocationEntryL: Record "Serv. Labor Allocation Entry";
        NewEntryNoTmp: Integer;
    begin
        if NewEntryNoTmp = 0 then begin
            if ServLaborAllocationEntryL.FindLast then
                NewEntryNoTmp := ServLaborAllocationEntryL."Entry No.";
        end;
        NewEntryNoTmp += 1;
        exit(NewEntryNoTmp);
    end;


    procedure UpdateAllocationStatus("Action": Code[20]; ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time; ReasonCode: Code[10])
    var
        StartFinishAllocation: Page "Time Registration";
        StatusToSet: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ServStandardEvent: Record "Serv. Standard Event";
    begin
        ServiceSetup.Get;
        if ServLaborAllocationEntry."Source ID" = ServiceSetup."Default Idle Event" then
            exit;

        case Action of
            'START':
                begin
                    StatusToSet := Statustoset::"In Process";
                    SingleInstanceManagment.SetCurrAllocation(ServLaborAllocationEntry."Entry No.");
                    StartFinishAllocation.SetParam(ResourceNo,
                      DateTimeMgt.Datetime(OnDate, OnTime),
                      ServLaborAllocationEntry."Quantity (Hours)",
                      ServLaborAllocationEntry."Source Type",
                      ServLaborAllocationEntry."Source Subtype",
                      ServLaborAllocationEntry."Source ID",
                      StatusToSet,
                      0,
                      ReasonCode);
                    StartFinishAllocation.StartEndWork;
                    /*
                    ServLaborAllocationEntry.Status := ServLaborAllocationEntry.Status::"In Progress";
                    ServLaborAllocationEntry.MODIFY;
                    ServiceScheduleMgt.ChangeServiceLineStatus(ServLaborAllocationEntry."Entry No.",FALSE);
                    */
                end;
            'ONHOLD':
                begin
                    StatusToSet := Statustoset::"On Hold";
                    SingleInstanceManagment.SetCurrAllocation(ServLaborAllocationEntry."Entry No.");
                    StartFinishAllocation.SetParam(ResourceNo,
                      DateTimeMgt.Datetime(OnDate, OnTime),
                      ServLaborAllocationEntry."Quantity (Hours)",
                      ServLaborAllocationEntry."Source Type",
                      ServLaborAllocationEntry."Source Subtype",
                      ServLaborAllocationEntry."Source ID",
                      StatusToSet,
                      0,
                      ReasonCode);
                    StartFinishAllocation.StartEndWork;
                end;
            'STOP':
                begin
                    StatusToSet := Statustoset::"Finish Part";
                    SingleInstanceManagment.SetCurrAllocation(ServLaborAllocationEntry."Entry No.");
                    StartFinishAllocation.SetParam(ResourceNo,
                      DateTimeMgt.Datetime(OnDate, OnTime),
                      ServLaborAllocationEntry."Quantity (Hours)",
                      ServLaborAllocationEntry."Source Type",
                      ServLaborAllocationEntry."Source Subtype",
                      ServLaborAllocationEntry."Source ID",
                      StatusToSet,
                      0,
                      ReasonCode);
                    StartFinishAllocation.StartEndWork;
                end;
            'COMPLETE':
                begin
                    StatusToSet := Statustoset::"Finish All";
                    SingleInstanceManagment.SetCurrAllocation(ServLaborAllocationEntry."Entry No.");
                    StartFinishAllocation.SetParam(ResourceNo,
                      DateTimeMgt.Datetime(OnDate, OnTime),
                      ServLaborAllocationEntry."Quantity (Hours)",
                      ServLaborAllocationEntry."Source Type",
                      ServLaborAllocationEntry."Source Subtype",
                      ServLaborAllocationEntry."Source ID",
                      StatusToSet,
                      0,
                      ReasonCode);
                    StartFinishAllocation.StartEndWork;
                end;
            'CANCELSTART':
                begin
                    Clear(ServiceScheduleMgt);
                    SingleInstanceManagment.SetCurrAllocation(ServLaborAllocationEntry."Entry No.");
                    ServiceScheduleMgt.CancelAllocation(Statustoset::Pending, DateTimeMgt.Datetime(OnDate, OnTime), false); //that is commented at 05.09.2014 - function from EDMS7.10.11
                end;
        end;
        UpdateParentAllocationStatus(ServLaborAllocationEntry."Entry No.", OnDate, OnTime);

    end;


    procedure ModifyLastTimeRegEntry(var ResourceTimeRegEntry: Record "Resource Time Reg. Entry")
    var
        ModifyResTimeEntry: Page "Modify Res. Time Reg. Entry";
        ResourceTimeRegEntryTmp: Record "Resource Time Reg. Entry" temporary;
        ResourceTimeRegEntryPrev: Record "Resource Time Reg. Entry";
        ResourceTimeRegEntryNext: Record "Resource Time Reg. Entry";
        ResourceTimeRegEntryTotal: Record "Resource Time Reg. Entry";
        ResourceTimeRegEntryLast: Record "Resource Time Reg. Entry";
        ActualWorkSpentTime: Decimal;
    begin
        ResourceTimeRegEntryPrev.CopyFilters(ResourceTimeRegEntry);
        ResourceTimeRegEntryPrev.SetRange("Entry Type", ResourceTimeRegEntryPrev."entry type"::"In Progress");
        ResourceTimeRegEntryPrev.SetFilter("Entry No.", '<%1', ResourceTimeRegEntry."Entry No.");
        ResourceTimeRegEntryPrev.SetRange(Canceled, false);

        ModifyResTimeEntry.SetEntry(ResourceTimeRegEntry);
        ModifyResTimeEntry.LookupMode(true);
        if ModifyResTimeEntry.RunModal = Action::LookupOK then begin
            ModifyResTimeEntry.GetRecord(ResourceTimeRegEntryTmp);
            ResourceTimeRegEntry.Date := ResourceTimeRegEntryTmp.Date;
            ResourceTimeRegEntry.Time := ResourceTimeRegEntryTmp.Time;
            ResourceTimeRegEntry."Time Spent" := ResourceTimeRegEntryTmp."Time Spent";
            ResourceTimeRegEntry.Modify;
            Message(TimeModifiedLastEntryMsg);
        end;
    end;


    procedure ValidateTimeRegAction("Action": Code[20]; ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"; ResourceNo: Code[20])
    var
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
        EntryNo: Integer;
        PresentTime: DateTime;
        ActualWorkSpentTime: Duration;
        TotalWorkSpentTime: Duration;
        ServiceHeader: Record "Service Header EDMS";
    begin
        ResourceTimeRegEntry.Reset;
        ResourceTimeRegEntry.SetRange("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
        ResourceTimeRegEntry.SetRange("Resource No.", ResourceNo);
        ResourceTimeRegEntry.SetRange(Canceled, false);
        case Action of
            'START':
                begin
                    if ResourceTimeRegEntry.FindLast and (ResourceTimeRegEntry."Entry Type" = ResourceTimeRegEntry."entry type"::"In Progress") then begin
                        Error(ValidateActionStartErr);
                    end;
                end;
        end;
        if not ServiceHeader.Get(ServLaborAllocationEntry."Source Subtype", ServLaborAllocationEntry."Source ID") and
          (ServLaborAllocationEntry."Source Type" = ServLaborAllocationEntry."source type"::"Service Document") then
            Error(ValidateActionPostedDocErr);
    end;


    procedure StartNewTaskFromAllocation(PoolServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time): Integer
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationApp: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS" temporary;
        StartDateTime: Decimal;
        EndDateTime: Decimal;
        StartDateTimeDT: DateTime;
        EndDateTimeDT: DateTime;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page Allocation;
        AllocatedEntryNo: Integer;
    begin
        ServiceScheduleSetup.Get;
        EntryNo := PoolServLaborAllocationEntry."Entry No.";
        //ResourceNo := GetCurrentUserResourceNo;
        StartDateTime := PoolServLaborAllocationEntry."Start Date-Time";
        EndDateTime := ServiceScheduleMgt.GetEntryEndingTimeFull(EntryNo);
        StartDateTimeDT := CreateDatetime(DateTimeMgt.Datetime2Date(PoolServLaborAllocationEntry."Start Date-Time"), DateTimeMgt.Datetime2Time(PoolServLaborAllocationEntry."Start Date-Time"));
        EndDateTimeDT := CreateDatetime(DateTimeMgt.Datetime2Date(EndDateTime), DateTimeMgt.Datetime2Time(EndDateTime));
        DivideIntoLines := false;
        SourceType := PoolServLaborAllocationEntry."Source Type";
        Mode := Mode::"New Allocation";
        SourceSubType := PoolServLaborAllocationEntry."Source Subtype";
        SourceID := PoolServLaborAllocationEntry."Source ID";
        Clear(ServiceScheduleMgt);

        Duration := EndDateTimeDT - StartDateTimeDT;
        CalculateDuration(Duration, QtyToAllocate, 1);

        ServiceLine.Reset;

        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, DateTimeMgt.Datetime(OnDate, OnTime), 0, SourceType, SourceSubType, SourceID, 0, ServiceLine, 1);//
        AllocationForm.SetInvisibles(QtyToAllocate);
        AllocatedEntryNo := AllocationForm.Allocate;
        UpdateAllocationParentId(AllocatedEntryNo, EntryNo);
        UpdateParentAllocationStatus(AllocatedEntryNo, OnDate, OnTime);
        if ServLaborAllocationEntry.Get(AllocatedEntryNo) then
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);

        exit(AllocatedEntryNo);
    end;


    procedure StartNewTravelTaskFromAllocation(PoolServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationApp: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS" temporary;
        StartDateTime: Decimal;
        EndDateTime: Decimal;
        StartDateTimeDT: DateTime;
        EndDateTimeDT: DateTime;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page Allocation;
        AllocatedEntryNo: Integer;
    begin
        ServiceScheduleSetup.Get;
        EntryNo := PoolServLaborAllocationEntry."Entry No.";
        //ResourceNo := GetCurrentUserResourceNo;
        StartDateTime := PoolServLaborAllocationEntry."Start Date-Time";
        EndDateTime := ServiceScheduleMgt.GetEntryEndingTimeFull(EntryNo);
        StartDateTimeDT := CreateDatetime(DateTimeMgt.Datetime2Date(PoolServLaborAllocationEntry."Start Date-Time"), DateTimeMgt.Datetime2Time(PoolServLaborAllocationEntry."Start Date-Time"));
        EndDateTimeDT := CreateDatetime(DateTimeMgt.Datetime2Date(EndDateTime), DateTimeMgt.Datetime2Time(EndDateTime));
        DivideIntoLines := false;
        SourceType := PoolServLaborAllocationEntry."Source Type";
        Mode := Mode::"New Allocation";
        SourceSubType := PoolServLaborAllocationEntry."Source Subtype";
        SourceID := PoolServLaborAllocationEntry."Source ID";
        Clear(ServiceScheduleMgt);

        Duration := EndDateTimeDT - StartDateTimeDT;
        CalculateDuration(Duration, QtyToAllocate, 1);

        ServiceLine.Reset;

        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, DateTimeMgt.Datetime(OnDate, OnTime), 0, SourceType, SourceSubType, SourceID, 0, ServiceLine, 1);//
        AllocationForm.SetInvisibles(QtyToAllocate);
        AllocationForm.SetIsTravel(true);
        AllocatedEntryNo := AllocationForm.Allocate;

        if ServLaborAllocationEntry.Get(AllocatedEntryNo) then begin
            FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
        end;
    end;


    procedure UpdateAllocationParentId(EntryNo: Integer; ParentEntryNo: Integer)
    var
        LaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
    begin
        ServiceScheduleMgt.FindSplitEntries(EntryNo, LaborAllocEntryTmp, 0, 1111);
        if LaborAllocEntryTmp.FindFirst then
            repeat
                if LaborAllocEntry.Get(LaborAllocEntryTmp."Entry No.") then begin
                    LaborAllocEntry."Parent Alloc. Entry No." := ParentEntryNo;
                    LaborAllocEntry.Modify;
                end;
            until LaborAllocEntryTmp.Next = 0;
    end;


    procedure UpdateParentAllocationStatus(ChildEntryNo: Integer; OnDate: Date; OnTime: Time)
    var
        LaborAllocEntryChildren: Record "Serv. Labor Allocation Entry";
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocEntryParent: Record "Serv. Labor Allocation Entry";
        ServAllocStatusPriority: Record "Serv. Alloc. Status Priority";
        ParentEntryNo: Integer;
        LowestStatus: Option High,"Medium High","Medium Low",Low;
        AllocStatus: Option Pending,"In Progress",Finished,"On Hold";
        StatusToSet: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        StartFinishAllocation: Page "Time Registration";
    begin
        LowestStatus := 999999;

        LaborAllocEntry.Get(ChildEntryNo);
        ParentEntryNo := LaborAllocEntry."Parent Alloc. Entry No.";
        if ParentEntryNo <> 0 then begin
            LaborAllocEntryChildren.Reset;
            LaborAllocEntryChildren.SetRange("Source ID", LaborAllocEntry."Source ID");
            LaborAllocEntryChildren.SetRange("Parent Alloc. Entry No.", LaborAllocEntry."Parent Alloc. Entry No.");

            if LaborAllocEntryChildren.FindFirst then
                repeat
                    if ServAllocStatusPriority.Get(LaborAllocEntryChildren.Status) then begin
                        if ServAllocStatusPriority.Priority < LowestStatus then begin
                            LowestStatus := ServAllocStatusPriority.Priority;
                            AllocStatus := ServAllocStatusPriority.Status;
                        end;
                    end;
                until LaborAllocEntryChildren.Next = 0;

            if LaborAllocEntryParent.Get(ParentEntryNo) then begin
                case AllocStatus of
                    Allocstatus::"In Progress":
                        begin
                            SingleInstanceManagment.SetCurrAllocation(ParentEntryNo);
                            StartFinishAllocation.SetParam(LaborAllocEntryParent."Resource No.",
                              DateTimeMgt.Datetime(OnDate, OnTime),
                              LaborAllocEntryParent."Quantity (Hours)",
                              LaborAllocEntryParent."Source Type",
                              LaborAllocEntryParent."Source Subtype",
                              LaborAllocEntryParent."Source ID",
                              Statustoset::"In Process",
                              0, '');
                            StartFinishAllocation.StartEndWork;
                        end;
                    Allocstatus::"On Hold":
                        begin
                            SingleInstanceManagment.SetCurrAllocation(ParentEntryNo);
                            StartFinishAllocation.SetParam(LaborAllocEntryParent."Resource No.",
                              DateTimeMgt.Datetime(OnDate, OnTime),
                              LaborAllocEntryParent."Quantity (Hours)",
                              LaborAllocEntryParent."Source Type",
                              LaborAllocEntryParent."Source Subtype",
                              LaborAllocEntryParent."Source ID",
                              Statustoset::"On Hold",
                              0, '');
                            StartFinishAllocation.StartEndWork;
                        end;
                    Allocstatus::Finished:
                        begin
                            SingleInstanceManagment.SetCurrAllocation(ParentEntryNo);
                            StartFinishAllocation.SetParam(LaborAllocEntryParent."Resource No.",
                              DateTimeMgt.Datetime(OnDate, OnTime),
                              LaborAllocEntryParent."Quantity (Hours)",
                              LaborAllocEntryParent."Source Type",
                              LaborAllocEntryParent."Source Subtype",
                              LaborAllocEntryParent."Source ID",
                              Statustoset::"Finish All",
                              0, '');
                            StartFinishAllocation.StartEndWork;
                        end;
                end;
            end;
        end;
    end;


    procedure StartDefaultIdleTask(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationApp: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS" temporary;
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page Allocation;
        AllocatedEntryNo: Integer;
        StandardEvent: Record "Serv. Standard Event";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
    begin
        ServiceSetup.Get;
        if ServiceSetup."Default Idle Event" = '' then
            exit;
        StandardEvent.Get(ServiceSetup."Default Idle Event");
        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := false;
        SourceType := ServLaborAllocationEntry."source type"::"Service Document";
        Mode := Mode::"New Allocation";
        //SourceSubType := ServiceHeader."Document Type";
        //SourceID := ServiceHeader."No.";
        Clear(ServiceScheduleMgt);
        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, 2, 0, StandardEvent.Code, 0, ServiceLine, 1);
        AllocationForm.SetInvisibles(0);
        AllocationForm.SetDescription(StandardEvent.Description);
        AllocatedEntryNo := AllocationForm.Allocate;

        if ServLaborAllocationEntry.Get(AllocatedEntryNo) then
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);

        /*
        ServiceSetup.GET;
        CLEAR(ServiceScheduleMgt);
        StartDateTime := DateTimeMgt.Datetime(OnDate,OnTime);
        StandardEvent.GET(ServiceSetup."Default Idle Event");
        AllocatedEntryNo := ServiceScheduleMgt.CreateNewAllocEntry(StartDateTime,ResourceNo,1,2,StandardEvent.Code,0,'',0,0,0,1);
        IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN
          AddTimeRegEntries('Start',ServLaborAllocationEntry,ResourceNo,OnDate,OnTime);
        */

    end;


    procedure FinishDefaultIdleTask(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        StandardEvent: Record "Serv. Standard Event";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        CurrDateTime: Decimal;
        AllocationStatus: Option Pending,"In Process",Finished,"On Hold";
    begin
        ServiceSetup.Get;
        if ServiceSetup."Default Idle Event" = '' then
            exit;
        StandardEvent.Get(ServiceSetup."Default Idle Event");
        LaborAllocEntry.Reset;
        LaborAllocEntry.SetCurrentkey("Source Type", Status, "Resource No.");
        LaborAllocEntry.SetFilter(Status, '%1|%2', LaborAllocEntry.Status::"In Progress", LaborAllocEntry.Status::"On Hold");
        LaborAllocEntry.SetRange("Resource No.", ResourceNo);
        LaborAllocEntry.SetRange("Source Type", LaborAllocEntry."source type"::"Standard Event");
        LaborAllocEntry.SetRange(LaborAllocEntry."Source ID", StandardEvent.Code);
        if LaborAllocEntry.FindFirst then
            repeat
                CurrDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
                ServiceScheduleMgt.SetAllocationStatus(Allocationstatus::Finished);
                ServiceScheduleMgt.WriteAllocationEntryEnd(LaborAllocEntry."Entry No.", CurrDateTime, false, '', LaborAllocEntry.Travel);
                AddTimeRegEntries('Complete', LaborAllocEntry, LaborAllocEntry."Resource No.", OnDate, OnTime);
            until LaborAllocEntry.Next = 0;
    end;


    procedure StartWorktime(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        CurrDateTime: Decimal;
    begin
        CurrDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        //ResourceNo := GetCurrentUserResourceNo;
        ServiceScheduleMgt.ProcessStartWorkday(ResourceNo, CurrDateTime);
    end;


    procedure EndWorktime(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        CurrDateTime: Decimal;
    begin
        CurrDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        //ResourceNo := GetCurrentUserResourceNo;
        ServiceScheduleMgt.ProcessEndWorkday(ResourceNo, CurrDateTime);
    end;


    procedure StartWorktimeSilent(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        CurrDateTime: Decimal;
    begin
        CurrDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        //ResourceNo := GetCurrentUserResourceNo;
        ServiceScheduleMgt.ProcessStartWorkdaySilent(ResourceNo, CurrDateTime);
    end;


    procedure StartWorktimeJournal(ResourceNo: Code[20]; OnDate: Date; OnTime: Time): Integer
    var
        StartDateTime: Decimal;
        WorkTimeEntry: Record "Resource Work Time Entry";
        EntryNo: Integer;
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
    begin
        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        WorkTimeEntry.Reset;
        if WorkTimeEntry.FindLast then
            EntryNo := WorkTimeEntry."Entry No." + 1
        else
            EntryNo := 1;

        WorkTimeEntry.Init;
        WorkTimeEntry."Entry No." := EntryNo;
        WorkTimeEntry.Validate("Resource No.", ResourceNo);
        WorkTimeEntry.Validate("Worktime Begin", StartDateTime);
        WorkTimeEntry.Insert(true);
        ResourceTimeRegMgt.AddWorkTimeRegEntries('STARTWORKTIME', ResourceNo, OnDate, OnTime);
        exit(EntryNo);
    end;


    procedure EndWorktimeJournal(ResourceNo: Code[20]; OnDate: Date; OnTime: Time; StartEntryNo: Integer)
    var
        EndDateTime: Decimal;
        WorkTimeEntry: Record "Resource Work Time Entry";
        ServLaborAllocationEntryL: Record "Serv. Labor Allocation Entry";
        DoReplan: Boolean;
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServStandardEvent: Record "Serv. Standard Event";
    begin
        if WorkTimeEntry.Get(StartEntryNo) then begin
            EndDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
            WorkTimeEntry.Validate("Worktime End", EndDateTime);
            WorkTimeEntry.Validate("Worked Hours", CalcHourDifference(WorkTimeEntry."Worktime Begin", EndDateTime));
            WorkTimeEntry.Validate(Closed, true);
            WorkTimeEntry.Modify(true);
            ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
            ResourceTimeRegMgt.AddWorkTimeRegEntries('FINISHWORKTIME', ResourceNo, OnDate, OnTime);
        end
    end;


    procedure ToggleWorktime(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    begin
        //ResourceNo := GetCurrentUserResourceNo;
        if IsResourceWorking(ResourceNo) then
            EndWorktime(ResourceNo, OnDate, OnTime)
        else
            StartWorktime(ResourceNo, OnDate, OnTime);
    end;


    procedure HasTasksInProgress(ResourceNo: Code[20]): Boolean
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
    begin
        LaborAllocEntry.Reset;
        LaborAllocEntry.SetCurrentkey("Source Type", Status, "Resource No.");
        LaborAllocEntry.SetRange(Status, LaborAllocEntry.Status::"In Progress");
        LaborAllocEntry.SetRange("Resource No.", ResourceNo);
        exit(LaborAllocEntry.FindFirst)
    end;


    procedure StartNewTaskFromStandardMobileOnline(StandardEvent: Record "Serv. Standard Event")
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationApp: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS" temporary;
        ResourceNo: Code[20];
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page Allocation;
        AllocatedEntryNo: Integer;
    begin
        ResourceNo := GetCurrentUserResourceNo;
        StartDateTime := DateTimeMgt.Datetime(WorkDate, Time);
        DivideIntoLines := false;
        SourceType := ServLaborAllocationEntry."source type"::"Service Document";
        Mode := Mode::"New Allocation";
        //SourceSubType := ServiceHeader."Document Type";
        //SourceID := ServiceHeader."No.";
        Clear(ServiceScheduleMgt);

        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, 2, 0, StandardEvent.Code, 0, ServiceLine, 1);
        AllocationForm.SetInvisibles(0);
        AllocatedEntryNo := AllocationForm.Allocate;
        if ServLaborAllocationEntry.Get(AllocatedEntryNo) then
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, WorkDate, Time);
    end;


    procedure RegisterServiceTimeJournal_OLD(var ServiceTimeJournal: Record "Service Time Journal")
    var
        ServiceHeader: Record "Service Header EDMS";
        AllocationEntryNo: Integer;
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationEntryExisting: Record "Serv. Labor Allocation Entry";
        DateTimeMgt: Codeunit "Datetime Mgt.";
        RegisterDateTimeStart: Decimal;
        RegisterDateTimeEnd: Decimal;
        WorktimeEntryNo: Integer;
        ServiceLine: Record "Service Line EDMS";
    begin
        SingleInstanceManagment.SetTimeJournalFlag(true);
        if ServiceTimeJournal.FindFirst then
            repeat
                //Document time tracking
                if ServiceHeader.Get(ServiceTimeJournal."Source Subtype", ServiceTimeJournal."Source ID") and (ServiceTimeJournal."Source Line No." = 0) then begin
                    ServiceTimeJournal.TestField("Resource No.");
                    ServiceTimeJournal.TestField(Date);
                    ServiceTimeJournal.TestField("Start Time");
                    ServiceTimeJournal.TestField("End Time");


                    StartWorktimeSilent(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time");

                    WorktimeEntryNo := StartWorktimeJournal(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time");
                    if not ServiceTimeJournal.Travel then begin
                        RegisterDateTimeStart := DateTimeMgt.Datetime(ServiceTimeJournal.Date, 0T);
                        RegisterDateTimeEnd := DateTimeMgt.Datetime(ServiceTimeJournal.Date, 235900T);

                        ServLaborAllocationEntryExisting.Reset;
                        ServLaborAllocationEntryExisting.SetRange("Source ID", ServiceTimeJournal."Source ID");
                        ServLaborAllocationEntryExisting.SetRange("Source Type", ServLaborAllocationEntryExisting."source type"::"Service Document");
                        ServLaborAllocationEntryExisting.SetRange("Source Subtype", ServiceTimeJournal."Source Subtype");
                        ServLaborAllocationEntryExisting.SetRange("Resource No.", ServiceTimeJournal."Resource No.");
                        ServLaborAllocationEntryExisting.SetFilter("Start Date-Time", '%1..', RegisterDateTimeStart);
                        ServLaborAllocationEntryExisting.SetFilter("End Date-Time", '..%1', RegisterDateTimeEnd);
                        ServLaborAllocationEntryExisting.SetRange(Travel, ServiceTimeJournal.Travel);
                        //ServLaborAllocationEntryExisting.SETRANGE(Status,ServLaborAllocationEntryExisting.Status::Pending);
                        ServLaborAllocationEntryExisting.SetFilter(Status, '<>%1', ServLaborAllocationEntryExisting.Status::Finished);
                        if ServLaborAllocationEntryExisting.FindFirst then begin
                            AllocationEntryNo := ServLaborAllocationEntryExisting."Entry No.";
                            //Start existing allocation
                            AddTimeRegEntries('Start', ServLaborAllocationEntryExisting,
                              ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time");
                            UpdateAllocationStatus('START', ServLaborAllocationEntryExisting, ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", '');
                        end else begin
                            AllocationEntryNo := StartNewTaskFromHeaderJournal(ServiceHeader, ServiceTimeJournal."Resource No.",
                              ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal.Travel, ServiceTimeJournal."Quantity (Hours)", ServiceTimeJournal."Source Line No.");
                        end;
                    end else begin
                        AllocationEntryNo := StartNewTaskFromHeaderJournal(ServiceHeader, ServiceTimeJournal."Resource No.",
                          ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal.Travel, ServiceTimeJournal."Quantity (Hours)", ServiceTimeJournal."Source Line No.");
                    end;

                    ServLaborAllocationEntry.Get(AllocationEntryNo);
                    AddTimeRegEntries('Complete', ServLaborAllocationEntry,
                      ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time");
                    UpdateAllocationStatus('COMPLETE', ServLaborAllocationEntry,
                      ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time", '');
                    EndWorktimeJournal(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time", WorktimeEntryNo);
                    ServiceTimeJournal.Delete;
                end;

                //Service Line event time tracking
                if ServiceLine.Get(ServiceTimeJournal."Source Subtype", ServiceTimeJournal."Source ID", ServiceTimeJournal."Source Line No.") then begin
                    ServiceTimeJournal.TestField("Resource No.");
                    ServiceTimeJournal.TestField(Date);
                    ServiceTimeJournal.TestField("Start Time");
                    ServiceTimeJournal.TestField("End Time");

                    StartWorktimeSilent(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time");
                    WorktimeEntryNo := StartWorktimeJournal(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time");

                    AllocationEntryNo := StartNewTaskFromLineJournal(ServiceLine, ServiceTimeJournal."Resource No.",
                      ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal.Travel);

                    ServLaborAllocationEntry.Get(AllocationEntryNo);
                    AddTimeRegEntries('Complete', ServLaborAllocationEntry,
                      ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time");
                    UpdateAllocationStatus('COMPLETE', ServLaborAllocationEntry,
                      ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time", '');
                    EndWorktimeJournal(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time", WorktimeEntryNo);
                    ServiceTimeJournal.Delete;

                end;

                //Standard event time tracking
                if ServiceTimeJournal."Source Type" = ServiceTimeJournal."source type"::"Standard Event" then begin
                    WorktimeEntryNo := StartWorktimeJournal(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time");
                    StartWorktimeSilent(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time");
                    AllocationEntryNo := StartNewTaskFromStandardJournal(ServiceTimeJournal."Resource No.",
                      ServiceTimeJournal.Date,
                      ServiceTimeJournal."Start Time",
                      ServiceTimeJournal."Source ID");
                    ServLaborAllocationEntry.Get(AllocationEntryNo);
                    AddTimeRegEntries('Complete', ServLaborAllocationEntry,
                      ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time");
                    UpdateAllocationStatus('COMPLETE', ServLaborAllocationEntry,
                      ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time", '');
                    EndWorktimeJournal(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time", WorktimeEntryNo);
                    ServiceTimeJournal.Delete;
                end;
            until ServiceTimeJournal.Next = 0;


        SingleInstanceManagment.SetTimeJournalFlag(false);
        Message(ServiceTimeRegFinishMsg);
    end;


    procedure RegisterServiceTimeJournal(var ServiceTimeJournal: Record "Service Time Journal")
    var
        ServiceHeader: Record "Service Header EDMS";
        AllocationEntryNo: Integer;
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationEntryExisting: Record "Serv. Labor Allocation Entry";
        DateTimeMgt: Codeunit "Datetime Mgt.";
        RegisterDateTimeStart: Decimal;
        RegisterDateTimeEnd: Decimal;
        ResourceTimeRegEntryExisting: Record "Resource Time Reg. Entry";
        ServiceTimeJournalBuff: Record "Service Time Journal" temporary;
        WorktimeEntryNo: Integer;
        DefaultIdleEvent: Code[20];
        ControlEntry: Boolean;
        Resource: Record Resource;
    begin
        ServiceSetup.Get;
        ServiceScheduleSetup.Get;
        DefaultIdleEvent := ServiceSetup."Default Idle Event";
        ControlEntry := ServiceSetup."Control Mechanic Time Entry";
        SingleInstanceManagment.SetTimeJournalFlag(true);
        if ServiceTimeJournal.FindFirst then begin
            repeat
                if Resource.Get(ServiceTimeJournal."Resource No.") then
                    if Resource."Allow Simultaneous Work" then
                        ControlEntry := false;

                IF ServiceTimeJournal."Source Type" = ServiceTimeJournal."Source Type"::"Service Document" THEN BEGIN
                    ServiceTimeJournal.TESTFIELD("Source Subtype");
                    ServiceTimeJournal.TESTFIELD("Source ID");
                END;

                IF ServiceTimeJournal."Source Type" = ServiceTimeJournal."Source Type"::"Standard Event" THEN BEGIN
                    ServiceTimeJournal.TESTFIELD("Source ID");
                END;

                //Document time tracking
                ServiceTimeJournalBuff.DeleteAll;
                FillOrderTimeBuffer(ServiceTimeJournalBuff, ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date);

                if ServiceHeader.Get(ServiceTimeJournal."Source Subtype", ServiceTimeJournal."Source ID") then begin
                    ServiceTimeJournal.TestField("Resource No.");
                    ServiceTimeJournal.TestField(Date);
                    ServiceTimeJournal.TestField("Start Time");
                    ServiceTimeJournal.TestField("End Time");

                    if ControlEntry then begin
                        //Validate Date
                        if ServiceTimeJournal.Date > Today then
                            Error(DateGreaterTodayErr, ServiceTimeJournal."Entry No.");
                        if ServiceTimeJournal.Date < ServiceHeader."Order Date" then
                            Error(DateOlderDocumentErr, ServiceTimeJournal."Entry No.");

                        //Validate Already registered time
                        ServiceTimeJournalBuff.Reset;
                        ServiceTimeJournalBuff.SetRange("Resource No.", ServiceTimeJournal."Resource No.");
                        //ServiceTimeJournalBuff.SETRANGE("Source Subtype",ServiceTimeJournal."Source Subtype");
                        //ServiceTimeJournalBuff.SETRANGE("Source Type",ServiceTimeJournal."Source Type");
                        //ServiceTimeJournalBuff.SETRANGE("Source ID",ServiceTimeJournal."Source ID");
                        ServiceTimeJournalBuff.SetRange(Date, ServiceTimeJournal.Date);
                        ServiceTimeJournalBuff.SetFilter("Start Time", '..%1', ServiceTimeJournal."Start Time");
                        ServiceTimeJournalBuff.SetFilter("End Time", '%1..', ServiceTimeJournal."End Time");
                        //Doc
                        if ServiceTimeJournalBuff.FindFirst then
                            Error(DateTimeAlreadyRegErr, ServiceTimeJournal."Entry No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal."End Time");
                        //Std
                        //ServiceTimeJournalBuff.SETRANGE("Source Type",ServiceTimeJournalBuff."Source Type"::"Standard Event");
                        //ServiceTimeJournalBuff.SETFILTER("Source ID",'<>%1',DefaultIdleEvent);
                        //ServiceTimeJournalBuff.SETRANGE("Source Subtype");
                        //IF ServiceTimeJournalBuff.FINDFIRST THEN
                        //  ERROR(DateTimeAlreadyRegErr,ServiceTimeJournal."Entry No.",ServiceTimeJournal.Date,ServiceTimeJournal."Start Time",ServiceTimeJournal."End Time");

                        ServiceTimeJournalBuff.Reset;
                        ServiceTimeJournalBuff.SetRange("Resource No.", ServiceTimeJournal."Resource No.");
                        //ServiceTimeJournalBuff.SETRANGE("Source Subtype",ServiceTimeJournal."Source Subtype");
                        //ServiceTimeJournalBuff.SETRANGE("Source Type",ServiceTimeJournal."Source Type");
                        //ServiceTimeJournalBuff.SETRANGE("Source ID",ServiceTimeJournal."Source ID");
                        ServiceTimeJournalBuff.SetRange(Date, ServiceTimeJournal.Date);
                        ServiceTimeJournalBuff.SetFilter("Start Time", '%1..%2', ServiceTimeJournal."Start Time" + 1000, ServiceTimeJournal."End Time" - 1000);
                        //Doc
                        if ServiceTimeJournalBuff.FindFirst then
                            Error(DateTimeAlreadyRegErr, ServiceTimeJournal."Entry No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal."End Time");
                        //Std
                        //ServiceTimeJournalBuff.SETRANGE("Source Type",ServiceTimeJournalBuff."Source Type"::"Standard Event");
                        //ServiceTimeJournalBuff.SETFILTER("Source ID",'<>%1',DefaultIdleEvent);
                        //ServiceTimeJournalBuff.SETRANGE("Source Subtype");
                        //IF ServiceTimeJournalBuff.FINDFIRST THEN
                        //  ERROR(DateTimeAlreadyRegErr,ServiceTimeJournal."Entry No.",ServiceTimeJournal.Date,ServiceTimeJournal."Start Time",ServiceTimeJournal."End Time");

                        ServiceTimeJournalBuff.Reset;
                        ServiceTimeJournalBuff.SetRange("Resource No.", ServiceTimeJournal."Resource No.");
                        //ServiceTimeJournalBuff.SETRANGE("Source Subtype",ServiceTimeJournal."Source Subtype");
                        //ServiceTimeJournalBuff.SETRANGE("Source Type",ServiceTimeJournal."Source Type");
                        //ServiceTimeJournalBuff.SETFILTER("Source ID",'<>%1',DefaultIdleEvent);
                        ServiceTimeJournalBuff.SetRange(Date, ServiceTimeJournal.Date);
                        ServiceTimeJournalBuff.SetFilter("End Time", '%1..%2', ServiceTimeJournal."Start Time" + 1000, ServiceTimeJournal."End Time" - 1000);
                        //Doc
                        if ServiceTimeJournalBuff.FindFirst then
                            Error(DateTimeAlreadyRegErr, ServiceTimeJournal."Entry No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal."End Time");
                        //Std
                        //ServiceTimeJournalBuff.SETRANGE("Source Type",ServiceTimeJournalBuff."Source Type"::"Standard Event");
                        //ServiceTimeJournalBuff.SETRANGE("Source ID");
                        //ServiceTimeJournalBuff.SETRANGE("Source Subtype");
                        //IF ServiceTimeJournalBuff.FINDFIRST THEN
                        //  ERROR(DateTimeAlreadyRegErr,ServiceTimeJournal."Entry No.",ServiceTimeJournal.Date,ServiceTimeJournal."Start Time",ServiceTimeJournal."End Time");
                    end; //Controll Entry
                    WorktimeEntryNo := StartWorktimeJournal(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time");
                    if not ServiceTimeJournal.Travel then begin
                        RegisterDateTimeStart := DateTimeMgt.Datetime(ServiceTimeJournal.Date, 0T);
                        RegisterDateTimeEnd := DateTimeMgt.Datetime(ServiceTimeJournal.Date, 235900T);

                        ServLaborAllocationEntryExisting.Reset;
                        ServLaborAllocationEntryExisting.SetRange("Source ID", ServiceTimeJournal."Source ID");
                        ServLaborAllocationEntryExisting.SetRange("Source Type", ServLaborAllocationEntryExisting."source type"::"Service Document");
                        ServLaborAllocationEntryExisting.SetRange("Source Subtype", ServiceTimeJournal."Source Subtype");
                        ServLaborAllocationEntryExisting.SetRange("Resource No.", ServiceTimeJournal."Resource No.");
                        ServLaborAllocationEntryExisting.SetFilter("Start Date-Time", '%1..', RegisterDateTimeStart);
                        ServLaborAllocationEntryExisting.SetFilter("End Date-Time", '..%1', RegisterDateTimeEnd);
                        ServLaborAllocationEntryExisting.SetRange(Travel, ServiceTimeJournal.Travel);
                        //ServLaborAllocationEntryExisting.SETRANGE(Status,ServLaborAllocationEntryExisting.Status::Pending);
                        ServLaborAllocationEntryExisting.SetFilter(Status, '<>%1', ServLaborAllocationEntryExisting.Status::Finished);
                        if ServLaborAllocationEntryExisting.FindFirst then begin
                            AllocationEntryNo := ServLaborAllocationEntryExisting."Entry No.";
                            //Start existing allocation
                            AddTimeRegEntries('Start', ServLaborAllocationEntryExisting,
                              ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time");
                            UpdateAllocationStatus('START', ServLaborAllocationEntryExisting, ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", '');
                        end else begin
                            AllocationEntryNo := StartNewTaskFromHeaderJournal(ServiceHeader, ServiceTimeJournal."Resource No.",
                              ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal.Travel, ServiceTimeJournal."Quantity (Hours)", ServiceTimeJournal."Source Line No.");
                        end;
                    end else begin
                        AllocationEntryNo := StartNewTaskFromHeaderJournal(ServiceHeader, ServiceTimeJournal."Resource No.",
                          ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal.Travel, ServiceTimeJournal."Quantity (Hours)", ServiceTimeJournal."Source Line No.");
                    end;

                    ServLaborAllocationEntry.Get(AllocationEntryNo);
                    onafterServLaborAllocationEntry(ServLaborAllocationEntry, ServiceTimeJournal);
                    AddTimeRegEntries('Complete', ServLaborAllocationEntry,
                      ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time");
                    UpdateAllocationStatus('COMPLETE', ServLaborAllocationEntry,
                      ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time", '');
                    EndWorktimeJournal(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time", WorktimeEntryNo);
                    ServiceTimeJournal.Delete;
                end;
                //Standard event time tracking
                if ServiceTimeJournal."Source Type" = ServiceTimeJournal."source type"::"Standard Event" then begin
                    if ControlEntry then begin
                        //Validate Already registered time
                        ServiceTimeJournalBuff.Reset;
                        ServiceTimeJournalBuff.SetRange("Resource No.", ServiceTimeJournal."Resource No.");
                        ServiceTimeJournalBuff.SetRange(Date, ServiceTimeJournal.Date);
                        ServiceTimeJournalBuff.SetFilter("Start Time", '..%1', ServiceTimeJournal."Start Time");
                        ServiceTimeJournalBuff.SetFilter("End Time", '%1..', ServiceTimeJournal."End Time");
                        if ServiceTimeJournalBuff.FindFirst then
                            Error(DateTimeAlreadyRegErr, ServiceTimeJournal."Entry No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal."End Time");

                        ServiceTimeJournalBuff.Reset;
                        ServiceTimeJournalBuff.SetRange("Resource No.", ServiceTimeJournal."Resource No.");
                        ServiceTimeJournalBuff.SetRange(Date, ServiceTimeJournal.Date);
                        ServiceTimeJournalBuff.SetFilter("Start Time", '%1..%2', ServiceTimeJournal."Start Time" + 1000, ServiceTimeJournal."End Time" - 1000);
                        if ServiceTimeJournalBuff.FindFirst then
                            Error(DateTimeAlreadyRegErr, ServiceTimeJournal."Entry No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal."End Time");

                        ServiceTimeJournalBuff.Reset;
                        ServiceTimeJournalBuff.SetRange("Resource No.", ServiceTimeJournal."Resource No.");
                        ServiceTimeJournalBuff.SetRange(Date, ServiceTimeJournal.Date);
                        ServiceTimeJournalBuff.SetFilter("End Time", '%1..%2', ServiceTimeJournal."Start Time" + 1000, ServiceTimeJournal."End Time" - 1000);
                        if ServiceTimeJournalBuff.FindFirst then
                            Error(DateTimeAlreadyRegErr, ServiceTimeJournal."Entry No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time", ServiceTimeJournal."End Time");
                    end; //Control entry
                    WorktimeEntryNo := StartWorktimeJournal(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."Start Time");
                    AllocationEntryNo := StartNewTaskFromStandardJournal(ServiceTimeJournal."Resource No.",
                      ServiceTimeJournal.Date,
                      ServiceTimeJournal."Start Time",
                      ServiceTimeJournal."Source ID");
                    ServLaborAllocationEntry.Get(AllocationEntryNo);
                    onafterServLaborAllocationEntry(ServLaborAllocationEntry, ServiceTimeJournal);
                    AddTimeRegEntries('Complete', ServLaborAllocationEntry,
                      ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time");
                    UpdateAllocationStatus('COMPLETE', ServLaborAllocationEntry,
                      ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time", '');
                    EndWorktimeJournal(ServiceTimeJournal."Resource No.", ServiceTimeJournal.Date, ServiceTimeJournal."End Time", WorktimeEntryNo);
                    ServiceTimeJournal.Delete;
                end;
            until ServiceTimeJournal.Next = 0;
        end;
        SingleInstanceManagment.SetTimeJournalFlag(false);
        Message(ServiceTimeRegFinishMsg);
    end;


    procedure StartNewTaskFromHeaderJournal(ServiceHeader: Record "Service Header EDMS"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time; IsTravel: Boolean; ForceQtyToAllocate: Decimal; Plineno: Integer): Integer
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationApp: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS" temporary;
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page Allocation;
        AllocatedEntryNo: Integer;
        WorkTimeEntry: Record "Resource Work Time Entry";
        ishandled: Boolean;
    begin
        ServiceScheduleSetup.Get;
        //ResourceNo := GetCurrentUserResourceNo;

        WorkTimeEntry.Reset;
        WorkTimeEntry.SetCurrentkey("Resource No.", Closed);
        WorkTimeEntry.SetRange("Resource No.", ResourceNo);
        WorkTimeEntry.SetRange(Closed, false);
        if not WorkTimeEntry.FindLast then
            Error(StrSubstNo(ValidateResourceWorktimeErr, ResourceNo));

        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := false;
        SourceType := ServLaborAllocationEntry."source type"::"Service Document";
        Mode := Mode::"New Allocation";
        SourceSubType := ServiceHeader."Document Type";
        SourceID := ServiceHeader."No.";
        Clear(ServiceScheduleMgt);

        //ServiceScheduleMgt.CheckForCorrectServHeaderLine(ServiceHeader, ServiceLine, WhatAllocation::Header);
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");

        onBeforefilterServiceLine(ServiceLine, Plineno, ishandled);
        if not ishandled then
            ServiceLine.SetRange("Line No.", 0);

        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, SourceType, SourceSubType, SourceID, 0, ServiceLine, 1);
        AllocationForm.SetInvisibles(ForceQtyToAllocate);
        AllocationForm.SetIsTravel(IsTravel);
        AllocatedEntryNo := AllocationForm.Allocate;

        if ServLaborAllocationEntry.Get(AllocatedEntryNo) then begin
            FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
        end;

        exit(AllocatedEntryNo);
    end;


    procedure StartNewTaskFromStandardJournal(ResourceNo: Code[20]; OnDate: Date; OnTime: Time; StandardEventCode: Code[20]): Integer
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationApp: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS" temporary;
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page Allocation;
        AllocatedEntryNo: Integer;
        StandardEvents: Page "Serv. Standard Events";
        StandardEvent: Record "Serv. Standard Event";
        WorkTimeEntry: Record "Resource Work Time Entry";
        MeetingDescription: Text;
        EasyTimeMeetingDialog: Page "Easy Clocking Start Meeting";
    begin
        ServiceScheduleSetup.Get;

        WorkTimeEntry.Reset;
        WorkTimeEntry.SetCurrentkey("Entry No.");
        WorkTimeEntry.SetRange("Resource No.", ResourceNo);
        WorkTimeEntry.SetRange(Closed, false);
        if not WorkTimeEntry.FindLast then
            Error(StrSubstNo(ValidateResourceWorktimeErr, ResourceNo));

        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := false;
        SourceType := ServLaborAllocationEntry."source type"::"Service Document";
        Mode := Mode::"New Allocation";
        Clear(ServiceScheduleMgt);

        //MeetingDescription := 'Meeting';
        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, 2, 0, StandardEventCode, 0, ServiceLine, 1);
        //AllocationForm.SetDescription(MeetingDescription);
        AllocationForm.SetInvisibles(0);
        AllocatedEntryNo := AllocationForm.Allocate;

        if ServLaborAllocationEntry.Get(AllocatedEntryNo) then begin
            FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
        end;

        exit(AllocatedEntryNo);
    end;


    procedure StartNewTaskFromLineJournal(ServiceLine1: Record "Service Line EDMS"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time; IsTravel: Boolean): Integer
    var
        ServiceHeader: Record "Service Header EDMS";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        StartDateTime: Decimal;
        CurrQtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        ServiceLine: Record "Service Line EDMS";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        WhatAllocation: Option Header,Line;
        AllocationForm: Page Allocation;
        ServiceLine2: Record "Service Line EDMS" temporary;
        AllocatedEntryNo: Integer;
        WorkTimeEntry: Record "Resource Work Time Entry";
    begin
        //ResourceNo := GetCurrentUserResourceNo;

        if not SingleInstanceManagment.GetTimeJournalFlag then begin
            WorkTimeEntry.Reset;
            WorkTimeEntry.SetCurrentkey("Resource No.", Closed);
            WorkTimeEntry.SetRange("Resource No.", ResourceNo);
            WorkTimeEntry.SetRange(Closed, false);
            if not WorkTimeEntry.FindLast then
                Error(StrSubstNo(ValidateResourceWorktimeErr, ResourceNo));
        end;

        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := false;
        Clear(ServiceScheduleMgt);
        LineNo := 0;
        SourceSubType := ServiceLine1."Document Type";
        SourceID := ServiceLine1."Document No.";
        SourceType := ServLaborAllocationEntry."source type"::"Service Document";

        ServiceLine2 := ServiceLine1;
        ServiceLine2.Insert;

        //ServiceScheduleMgt.CheckForCorrectServHeaderLine(ServiceHeader, ServiceLine2, WhatAllocation::Line);

        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, ServiceLine2.Quantity, SourceType, SourceSubType, SourceID, 0, ServiceLine2, 1);
        AllocationForm.SetInvisibles(0);
        AllocationForm.SetIsTravel(IsTravel);
        AllocatedEntryNo := AllocationForm.Allocate;

        if ServLaborAllocationEntry.Get(AllocatedEntryNo) then begin
            FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
        end;


        exit(AllocatedEntryNo);
    end;


    procedure CalcHourDifference(StartDateTime: Decimal; EndDateTime: Decimal): Decimal
    begin
        //Returns difference in hours
        exit((EndDateTime - StartDateTime) / 3.6);
    end;

    local procedure FillOrderTimeBuffer(var ServiceTimeJournalBuff: Record "Service Time Journal"; ResourceNo: Code[20]; Date: Date)
    var
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
        ResourceTimeRegEntryEnd: Record "Resource Time Reg. Entry";
        EntryNo: Integer;
    begin
        ResourceTimeRegEntry.Reset;
        ResourceTimeRegEntry.SetRange(Date, Date);
        ResourceTimeRegEntry.SetRange("Entry Type", ResourceTimeRegEntry."entry type"::"In Progress");
        ResourceTimeRegEntry.SetRange("Worktime Entry", false);
        //ResourceTimeRegEntry.SETRANGE("Source Type",ResourceTimeRegEntry."Source Type"::"Service Document");
        if ResourceTimeRegEntry.FindFirst then begin
            repeat
                ServiceTimeJournalBuff.Reset;
                ServiceTimeJournalBuff.SetRange("Source Subtype", ResourceTimeRegEntry."Source Subtype");
                ServiceTimeJournalBuff.SetRange("Source Type", ResourceTimeRegEntry."Source Type");
                ServiceTimeJournalBuff.SetRange("Source ID", ResourceTimeRegEntry."Source ID");
                ServiceTimeJournalBuff.SetRange(Date, ResourceTimeRegEntry.Date);
                ServiceTimeJournalBuff.SetRange("Source Line No.", ResourceTimeRegEntry."Allocation Entry No.");
                ServiceTimeJournalBuff.SetRange("Resource No.", ResourceTimeRegEntry."Resource No.");
                if not ServiceTimeJournalBuff.FindFirst then begin
                    ServiceTimeJournalBuff.Reset;
                    ServiceTimeJournalBuff.SetCurrentkey("Entry No.");
                    if ServiceTimeJournalBuff.FindLast then
                        EntryNo := ServiceTimeJournalBuff."Entry No." + 1;

                    ServiceTimeJournalBuff.Init;
                    ServiceTimeJournalBuff."Entry No." := EntryNo;
                    ServiceTimeJournalBuff."Source Subtype" := ResourceTimeRegEntry."Source Subtype";
                    ServiceTimeJournalBuff."Source Type" := ResourceTimeRegEntry."Source Type";
                    ServiceTimeJournalBuff."Source ID" := ResourceTimeRegEntry."Source ID";
                    ServiceTimeJournalBuff.Date := ResourceTimeRegEntry.Date;
                    ServiceTimeJournalBuff."Start Time" := ResourceTimeRegEntry.Time;
                    ServiceTimeJournalBuff."Source Line No." := ResourceTimeRegEntry."Allocation Entry No.";
                    ServiceTimeJournalBuff."Resource No." := ResourceTimeRegEntry."Resource No.";
                    ServiceTimeJournalBuff.Insert;

                    ResourceTimeRegEntryEnd.Reset;
                    ResourceTimeRegEntryEnd.SetRange("Resource No.", ResourceNo);
                    ResourceTimeRegEntryEnd.SetRange(Date, Date);
                    ResourceTimeRegEntryEnd.SetFilter("Entry Type", '<>%1', ResourceTimeRegEntryEnd."entry type"::"In Progress");
                    ResourceTimeRegEntryEnd.SetRange("Worktime Entry", false);
                    ResourceTimeRegEntryEnd.SetRange("Allocation Entry No.", ResourceTimeRegEntry."Allocation Entry No.");
                    if ResourceTimeRegEntryEnd.FindFirst then begin
                        repeat
                            ServiceTimeJournalBuff."End Time" := ResourceTimeRegEntryEnd.Time;
                            ServiceTimeJournalBuff.Modify;
                        until ResourceTimeRegEntryEnd.Next = 0;
                    end;
                end;
            until ResourceTimeRegEntry.Next = 0;
        end;
    end;


    procedure IsPostedDocumentForTimeEntry(var ResourceTimeRegEntry: Record "Resource Time Reg. Entry"): Boolean
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        if ResourceTimeRegEntry."Source Type" = ResourceTimeRegEntry."source type"::"Service Document" then
            if not ServiceHeader.Get(ResourceTimeRegEntry."Source Subtype", ResourceTimeRegEntry."Source ID") then
                exit(true);

        exit(false);
    end;


    procedure CheckPostedDocumentForTimeEntryModify(var ResourceTimeRegEntry: Record "Resource Time Reg. Entry")
    begin
        if IsPostedDocumentForTimeEntry(ResourceTimeRegEntry) then
            Error(ModifyNotAllowedErr);
    end;


    procedure GetDocumentHighestAllocationStatus(var ServiceHeader: Record "Service Header EDMS"): Integer
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        StatusPriority: Record "Service Work Status EDMS";
        HighestStatusPriority: Integer;
        AllocStatus: Integer;
    begin
        LaborAllocEntry.Reset();
        LaborAllocEntry.SetRange("Source Type", LaborAllocEntry."Source Type"::"Service Document");
        LaborAllocEntry.SetRange("Source Subtype", ServiceHeader."Document Type");
        LaborAllocEntry.SetRange("Source ID", ServiceHeader."No.");
        HighestStatusPriority := 100;
        if LaborAllocEntry.FindFirst then
            repeat
                StatusPriority.RESET;
                StatusPriority.SetRange("Service Order Status", LaborAllocEntry.Status);
                if StatusPriority.FindFirst then begin
                    if StatusPriority.Priority < HighestStatusPriority then begin
                        HighestStatusPriority := StatusPriority.Priority;
                        AllocStatus := LaborAllocEntry.Status;
                    end;
                end;
            until LaborAllocEntry.Next = 0;
        exit(AllocStatus);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterStartNewTaskFromHeader(AllocatedEntryNo: Integer)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure onafterServLaborAllocationEntry(var ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"; ServiceTimeJournal: Record "Service Time Journal")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure onafterTimeRegEntry(var ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"; ResourceTimeRegEntry: Record "Resource Time Reg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforefilterServiceLine(var ServiceLine: Record "Service Line EDMS" temporary; var pline: integer; var ishandled: Boolean)
    begin
    end;



}