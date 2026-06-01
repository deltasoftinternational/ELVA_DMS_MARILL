Codeunit 25006201 "Service Schedule Mgt."
{
    // 05.10.2018 EB.P7 Bug in email
    //   Modified functions:
    //     AllocateStandardEvent
    //     AllocateServiceLines
    //     AllocateServiceOrder
    //     AllocationSetParam
    // 11.06.2015 EB.P7 #Schedule3.0
    //   GetAllocRecDescr Modified.
    // 
    // 28.05.2015 EB.P30 #T030
    //   Created function:
    //     CopyServLaborAllocApplFromDetServLedg
    // 
    // 12.05.2015 EB.P30 #T030
    //   Modified functions:
    //     InsertAllocApplication
    //     ModifyAllocApplication
    // 
    // 18.12.2014 Elva Baltic P21 #E0003
    //   Modified procedure:
    //     DeleteAllocationFromServLines
    // 
    // 12.12.2014 EB.P8
    //   Small fix.
    // 
    // 19.05.2014 Elva Baltic P21 #S0101 MMG7.00
    //   Modified function:
    //     CancelAllocation
    // 
    // 16.05.2014 Elva Baltic P21 #S0101 MMG7.00
    //   Added function:
    //     CancelAllocation
    // 
    // 14.05.2014 Elva Baltic P21 #S0102 MMG7.00
    //   Modified function:
    //     CreateFieldText
    // 
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     CopyServLaborAllocAppl
    // 
    // 09.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Temporaty=TRUE set for variable ServiceLine in function ServiceMoveAllocation
    // 
    // 22.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Modified AllocateNewVisitOrder function
    // 
    // 14.03.2014 Elva Baltic P8 #S0003 MMG7.00
    //   * Fix: Details Entry No. should be copied into related allocations
    //   * New function FindFirstAppliedEntryNo
    // 
    // 10.12.2013 EDMS P8
    //   * fix when lost "Applies-to Entry No."
    // 
    // 22.11.2013 EDMS P8
    // 20.11.2013 EDMS P8
    //   * small changes in user rights
    //   * add functions ErrorWithRefresh
    // 
    // 24.10.2013 EDMS P8
    //   * Implement use of T25006268. New UpdateAllocDetailsText
    // 
    // 17.10.2013 EDMS P8
    //   * now able to start job with change resource
    //   * now able to start FEW jobs if Resource."Allow Several Jobs AtOnce"
    // 
    // 15.08.2013 EDMS P8
    //   * fix for case: ON HOLD it did finish current allocation with correct end time but did not createhold allocation part...
    //   * CHANGE IN FindSplitEntries
    // 
    // 12.08.2013 EDMS P8
    //   * fix for case: try to Break allocation in process without chosen T25006272.Code, now it will bring error
    //   * fix for case: finished splitten allocation should react on moving the same as it is in other status, like 'Pending'
    // 
    // 20.07.2013 EDMS P8
    //   * fix for case: create new allocation that is going to be splitten in several parts it made unrelated allocations
    //   * fix for case: if once push on finished allocation that is continuous on unavailable time as well it made split
    //   * fix for case: resize allocation in case of split it did split and in new allocation other status than first
    //   * fix for case: at start of split allocation it did increase total time.
    //   * fix for case: at finish of split allocation it did left other allocation in progress, but should delete it.
    //   * fix for case: at Hold Allocation on serv doc allocat. it brought error '' (do not create correct application line for next new allocat.).
    //   * fix for case: at Hold Allocation on SPLITTEN allocation it made one hold allacation and last alloc. part left 'In Process'
    // 
    // 09.07.2013 EDMS P8
    //   * fix to make new allocation line - it was created for wholo header instead...
    // 
    // 28.06.2013 EDMS P8
    //   * fix error message "Not found Alloc Entry,,,"
    //   * add COMMIT before PageVar.RUNMODAL
    // 
    // 04.06.2013 EDMS P8
    //   new function CalcEndDTOnlyWorktime
    // 15.04.2013 EDMS P8
    //   * Fix on-hold part should be separated of finished, influence into behavior of work ClearAllocationEntry in function MovementIncSplit
    // 
    // 09.04.2013 EDMS P8
    //   * fix new created allocation should not create additional AppEntries for Lines
    // 
    // 03.04.2013 P8
    //   * set for page runmodal: ChangeAllocationForm.LOOKUPMODE(TRUE);  //03.04.2013 P8
    //   * removed unnecessary GetScheduleViewCode
    // 
    // 19.03.2013 EDMS P8
    //   fix for split process
    // 
    // 01.03.2013 EDMS P8
    //   * FIX resource insert/remove for order
    // 
    // 2012.05.07 EDMS P8
    //   * As far splited entries became more useful then most routines must be recoded so that it could be runed in modes:
    //   *   to process single entry;
    //   *   to process splited entries by submodes:
    //   *     first run - check all involved records, is it allowed to continue;
    //   *     second loop - main actions;
    //   *     third loop - finalize and adjust with other noninvolved entries
    // 
    // 2012.04.12 EDMS P8
    //   * removed "Service Line"."Resource No." field use.
    // 
    // 18.01.2012 EDMS P8
    //   * fix to be shown lunch unavailable periods
    //   * add functions: SeparateAllocEntry, CreateNewAllocEntry
    //   * do not use SplitTracking for now (added value to that variable)
    //   * terms: splited entries - means entries of one application linked by "Applies-to Entry No.", so splitted due to some breaks...
    //   *       related - means entries that are linked by "Parent Alloc. Entry No.", different application but one line for now
    //   *         it should be synchronized!
    // 
    // 28.01.2010 EDMSB P2
    //   * Added function ShowServiceAllocation, AllocateEventAndStart
    // 
    // Split tracking - handle linked entries


    trigger OnRun()
    begin
    end;

    var
        LaborAllocationEntryPrevTmp: Record "Serv. Labor Allocation Entry" temporary;
        ServiceScheduleSetup: Record "Service Schedule Setup";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        UserSetup: Record "User Setup";
        Resource: Record Resource;
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        CalendarMgt: Codeunit "Calendar Management";
        DocumentMgt: Codeunit DocumentManagementDMS;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
        Text001: label 'X';
        Text100: label 'Do you want to delete all connected entries?';
        Text101: label 'Do you want to move all connected entries?';
        Text102: label 'It was not possible to plan activities.';
        ServLaborApplicationGlobTmp: Record "Serv. Labor Alloc. Application" temporary;
        ServiceLine: Record "Service Line EDMS" temporary;
        ReasonCodeGlobal: Code[20];
        SplitTracking: Option No,Yes,Undef;
        Text103: label 'Replan all entries after this event?';
        AllocationStatus: Option Pending,"In Process",Finished,"On Hold";
        AllocationStatusAction: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        ScheduleAction: Option Planning,"Time Registration";
        DoServiceSpliting: Boolean;
        ChangeAllocationStatus: Boolean;
        Text106: label 'You have to finish labor in progress: %1 %2!';
        Text107: label 'Resource %1 have to start work time first.';
        Text108: label 'You can start only service labors.';
        Text109: label 'This labor allocation entry is already finished.';
        Text110: label 'This labor allocation entry is already in progress.';
        Text111: label 'You can only finish labor that is in progress.';
        Text112: label 'Wrong password.';
        Text113: label 'You are not allowed to work now.';
        Text114: label 'You cannot deallocate. One or more connected entries has status %1.';
        Text115: label 'You can not post Service Line %1. Because there are unfinished Service Shedule entries.';
        Text116: label 'You cannot delete this service, because there is finished service allocation.';
        Text117: label 'Do you want delete service entries in schedule, too?';
        Text118: label 'You cannot delete service, because there are entris in schedule.';
        Text119: label 'Resource %1 has not started worktime.';
        Text120: label 'Resource %1 has already started worktime.';
        Text121: label 'No Serv. Labor Allocation Entries are selected. Please select the entry.';
        Text122: label 'Labor sequence will be wrong. Do you want continue?';
        Text123: label 'You can not split entry which has status : %1!';
        Text124: label 'The process is canceled.';
        Text125: label 'Resource %1 has no such skills: %2! Do you want continue?';
        Text126: label 'Do you want to clear remaining allocation parts?';
        AlreadyAskedAboutSkills: Boolean;
        AlreadyAskedAboutSequence: Boolean;
        StatusChanged: Boolean;
        AskedForAllocationSpliting: Boolean;
        Text127: label 'Scheduled allocation does not fit into today''s (%1) remaining available time. Do you want to move the remaining part (%2 hours) to the next avaiable working time?';
        Text128: label 'You don''t have rights to perform this action.';
        Text129: label 'Do You want finish all started labors?';
        Text130: label 'One or more connected entries has status %1. Do you want continue?';
        Text131: label 'One or more line has already been scheduled for service %1 %2. Are you sure to continue?';
        Text132: label 'Service %1 %2 has already been scheduled as a whole. Are you sure to continue?';
        Text133: label 'You can only select lines from one document.';
        Text134: label 'You cannot spilt this entry. This is whole order entry.';
        Text135: label 'Working on simultaneous tasks is not allowed.';
        Text136: label 'This labor is already planed for other resource.';
        Text137: label 'This labor %1 is already planed for other resource. Do You want to split it?';
        Text138: label 'You can change only finished service allocation entry';
        GlobDontModifyServLine: Boolean;
        Text139: label 'The process is canceled. \Available resources: %1.';
        Text140: label 'No allocation found for this document.';
        Text141: label 'You can not post Service Header %1. Because there are unfinished Service Shedule entries.';
        Text142: label 'You are not allow to plan this service document allocation method.';
        Text143: label 'You can register only Service Line.';
        Text144: label 'Labor %1 is not Call-out labor.';
        DontChangeServiceStatus: Boolean;
        LaborAllocAppType: Option " ","Service Document","Standard Event","Service Line";
        Text145: label 'Would you like to remove resource from lines as well?';
        Text146: label 'Please add/remove resources in Service Schedule.';
        Text147: label 'Would you like to remove document allocations?';
        Text148: label 'Resources for document must be entered via table.';
        SLAEfilterDataset: Record "Serv. Labor Allocation Entry";
        isUserRightsChecked: Boolean;
        isOperAllowedChecked: Boolean;
        OperationMainCode: Integer;
        UserRightsAllowed: Boolean;
        OperAllowed: Boolean;
        Text150: label 'Operation has stoped.';
        Text160: label 'It is not allowed move entry outside from a resource.';
        LaborAllocEntryPrevStatus: Integer;
        ErrorStatus: Option Null,Error,ErrorNeedRefresh;
        ErrorMsgText: Text[1024];
        Text161: label 'Do You want to cancel started labor?';
        Text162: label 'You can only cancel labor that is in progress!';
        Text163: label 'You can''t finish working day while there is labors on hold.';


    procedure FillAllocEntryBuffer(var TempLaborAllocEntry: Record "Serv. Labor Allocation Entry" temporary; ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
    begin
        LaborAllocEntry.Reset;
        LaborAllocEntry.SetCurrentkey("Resource No.", "Start Date-Time", "End Date-Time");
        LaborAllocEntry.SetRange("Resource No.", ResourceNo);
        LaborAllocEntry.SetFilter("Start Date-Time", '<=%1', EndingDateTime);
        LaborAllocEntry.SetFilter("End Date-Time", '>%1', StartingDateTime);
        if LaborAllocEntry.FindFirst then
            repeat
                TempLaborAllocEntry := LaborAllocEntry;
                TempLaborAllocEntry.Insert;
            until LaborAllocEntry.Next = 0;
    end;


    procedure BufferContainsSelectedEntry(var TempLaborAllocEntry: Record "Serv. Labor Allocation Entry" temporary): Boolean
    begin
        if TempLaborAllocEntry.FindFirst then
            repeat
                if TempLaborAllocEntry."Entry No." = SingleInstanceMgt.GetAllocationEntryNo then
                    exit(true);
            until TempLaborAllocEntry.Next = 0;
        exit(false)
    end;


    procedure GetMatrixCellValue(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal; CellType: Option Allocation,Capacity,Availability) CellValueText: Text[250]
    var
        TempLaborAllocEntry: Record "Serv. Labor Allocation Entry" temporary;
        ServiceHour: Record "Service Hour EDMS";
        RecordCount: Integer;
    begin
        ServiceScheduleSetup.Get;

        if CellType in [Celltype::Allocation, Celltype::Availability] then
            FillAllocEntryBuffer(TempLaborAllocEntry, ResourceNo, StartingDateTime, EndingDateTime);

        if CellType = Celltype::Allocation then begin
            RecordCount := TempLaborAllocEntry.Count;
            if RecordCount > 1 then
                CellValueText := '(' + Format(RecordCount) + ') ';

            if BufferContainsSelectedEntry(TempLaborAllocEntry) then
                CellValueText := CopyStr(CellValueText + GetAllocRecDescr(TempLaborAllocEntry), 1, 250)
            else begin
                RecordCount := 0;
                TempLaborAllocEntry.Reset;
                if TempLaborAllocEntry.FindFirst then
                    repeat
                        RecordCount += 1;
                        if RecordCount > 1 then
                            CellValueText := CopyStr(CellValueText + '; ', 1, 250);

                        CellValueText := CopyStr(CellValueText + GetAllocRecDescr(TempLaborAllocEntry), 1, 250);
                    until (TempLaborAllocEntry.Next = 0) or (RecordCount = 3)
                else begin
                    if ServiceScheduleSetup."Show Unavailable Time" then
                        if not GetTimeAvailable(ResourceNo, StartingDateTime, EndingDateTime) then
                            CellValueText := Text001;
                end;
            end;
        end;
        if CellType in [Celltype::Capacity, Celltype::Availability] then begin
            if CellType = Celltype::Capacity then
                CellValueText := Format(ROUND(GetCapacity(ResourceNo, StartingDateTime, EndingDateTime), 0.01)) + ' h'
            else
                CellValueText := Format(ROUND(GetCapacity(ResourceNo, StartingDateTime, EndingDateTime) -
                                        GetNotAvailabilityTime(TempLaborAllocEntry, StartingDateTime, EndingDateTime), 0.01)) + ' h';
        end;

        exit;
    end;


    procedure GetMatrixGroupCellValue(var ResourceCodeBuffer: Record "Serv. Schedule Dim. Buffer" temporary; StartingDateTime: Decimal; EndingDateTime: Decimal; CellType: Option Allocation,Capacity,Availability) CellValueText: Text[250]
    var
        TempLaborAllocEntry: Record "Serv. Labor Allocation Entry" temporary;
        RecordCount: Integer;
        AllocatedHours: Decimal;
        StartingDateTime1: Decimal;
        EndingDateTime1: Decimal;
        GroupCode: Code[20];
        ResourceCodeBufferFilter: Record "Serv. Schedule Dim. Buffer" temporary;
        CapacityHours: Decimal;
    begin
        AllocatedHours := 0;
        GroupCode := ResourceCodeBuffer.Code;

        ResourceCodeBufferFilter.Copy(ResourceCodeBuffer);
        ResourceCodeBuffer.Reset;

        if ResourceCodeBuffer.FindFirst then
            repeat
                if ResourceCodeBuffer."Applies-to Code" = GroupCode then begin
                    TempLaborAllocEntry.DeleteAll;
                    if CellType in [Celltype::Allocation, Celltype::Availability] then begin
                        FillAllocEntryBuffer(TempLaborAllocEntry, ResourceCodeBuffer.Code, StartingDateTime, EndingDateTime);
                        AllocatedHours += GetNotAvailabilityTime(TempLaborAllocEntry, StartingDateTime, EndingDateTime);
                    end;
                    if CellType in [Celltype::Availability, Celltype::Capacity] then
                        CapacityHours += GetCapacity(ResourceCodeBuffer.Code, StartingDateTime, EndingDateTime);
                end;
            until ResourceCodeBuffer.Next = 0;

        ResourceCodeBuffer.Copy(ResourceCodeBufferFilter);

        case CellType of
            Celltype::Allocation:
                begin
                    CellValueText := Format(ROUND(AllocatedHours, 0.01)) + ' h';  //Temporary solution
                    if AllocatedHours = 0 then
                        CellValueText := '';
                end;
            Celltype::Capacity:
                CellValueText := Format(ROUND(CapacityHours, 0.01)) + ' h';
            Celltype::Availability:
                if CapacityHours - AllocatedHours < 0 then
                    CellValueText := Format(0) + ' h'
                else
                    CellValueText := Format(ROUND(CapacityHours - AllocatedHours, 0.01)) + ' h';
        end;
        exit;
    end;


    procedure GetMatrixCellFormat(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal; var Bold: Boolean; var ForeColor: Integer) CellValueText: Text[250]
    var
        TempLaborAllocEntry: Record "Serv. Labor Allocation Entry" temporary;
        RecordCount: Integer;
    begin
        FillAllocEntryBuffer(TempLaborAllocEntry, ResourceNo, StartingDateTime, EndingDateTime);

        SetCellFormat(TempLaborAllocEntry, Bold, ForeColor);
    end;


    procedure SetCellFormat(var TempLaborAllocEntry: Record "Serv. Labor Allocation Entry" temporary; var Bold: Boolean; var ForeColor: Integer)
    var
        ColorConfig: Record "Schedule Color Config.";
        ServiceHdr: Record "Service Header EDMS";
        ServCount: Integer;
        RecCount: Integer;
        StandardCount: Integer;
    begin
        ColorConfig.Reset;
        RecCount := TempLaborAllocEntry.Count;
        if RecCount = 0 then
            exit;
        if BufferContainsSelectedEntry(TempLaborAllocEntry) then
            ColorConfig.SetRange("Active Allocation", true)
        else
            ColorConfig.SetRange("Active Allocation", false);

        if RecCount > 1 then begin
            ColorConfig.SetRange("Mixed Allocation", true);
            if ColorConfig.FindFirst then begin
                Bold := ColorConfig."Font Bold";
                ForeColor := ColorConfig."Font Color";
                exit;
            end;
            ColorConfig.SetRange("Mixed Allocation", false);
        end else
            ColorConfig.SetRange("Mixed Allocation", false);

        if not TempLaborAllocEntry.Get(SingleInstanceMgt.GetAllocationEntryNo) then
            TempLaborAllocEntry.FindFirst;

        ColorConfig.SetRange("Source Type", TempLaborAllocEntry."Source Type");
        ColorConfig.SetRange("Source Subtype", TempLaborAllocEntry."Source Subtype");
        if ServiceHdr.Get(TempLaborAllocEntry."Source Subtype", TempLaborAllocEntry."Source ID") then;
        ColorConfig.SetFilter("Work Status", '%1|''''', ServiceHdr."Work Status Code");
        ColorConfig.SetRange(Status, TempLaborAllocEntry.Status);
        if ColorConfig.FindLast then begin
            Bold := ColorConfig."Font Bold";
            ForeColor := ColorConfig."Font Color";
        end;
    end;


    procedure SetCellFormatRTC(var LaborAllocEntry: Record "Serv. Labor Allocation Entry"; var ForeColor: Integer; var BackColor: Integer)
    var
        ColorConfig: Record "Schedule Color Config.";
        ServiceHeader: Record "Service Header EDMS";
        ServLaborAllocationApplication: Record "Serv. Labor Alloc. Application";
        PostedServiceHeader: Record "Posted Serv. Order Header";
        PostedServRetOrderHeader: Record "Posted Serv. Ret. Order Header";
        CurrDateTime: Decimal;
    begin
        if LaborAllocEntry."Allocation Status" = LaborAllocEntry."allocation status"::Unavailability then begin
            ServiceScheduleSetup.Get;
            ForeColor := 0; //Black
            BackColor := 16777215; //White
            exit;
        end;

        ForeColor := 0; //Black
        BackColor := 16777215; //White

        ColorConfig.Reset;
        //ColorConfig.SETRANGE("Active Allocation", FALSE);
        //ColorConfig.SETRANGE("Mixed Allocation", FALSE);

        ColorConfig.SetRange("Source Type", LaborAllocEntry."Source Type");
        ColorConfig.SetRange("Source Subtype", LaborAllocEntry."Source Subtype");

        if LaborAllocEntry."Source Type" = LaborAllocEntry."source type"::"Service Document" then begin
            if (not ServiceHeader.Get(LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID")) and
               (not PostedServiceHeader.Get(LaborAllocEntry."Source ID")) then
                exit;
            if LaborAllocEntry."Source Subtype" = LaborAllocEntry."source subtype"::Order then begin
                //ServLaborAllocationApplication.RESET;
                //ServLaborAllocationApplication.SETRANGE("Document Type",ServLaborAllocationApplication."Document Type"::Order);
                //ServLaborAllocationApplication.SETRANGE(Posted,TRUE);
                //IF ServLaborAllocationApplication.FINDFIRST THEN
                //  ColorConfig.SETRANGE("Source Subtype", ColorConfig."Source Subtype"::"Posted Order");
                if PostedServiceHeader.Get(LaborAllocEntry."Source ID") then
                    ColorConfig.SetRange("Source Subtype", ColorConfig."source subtype"::"Posted Order");
            end;
            if LaborAllocEntry."Source Subtype" = LaborAllocEntry."source subtype"::"Return Order" then begin
                if PostedServRetOrderHeader.Get(LaborAllocEntry."Source ID") then
                    ColorConfig.SetRange("Source Subtype", ColorConfig."source subtype"::"Posted Return Order");
            end;
        end;



        ColorConfig.SetFilter("Work Status", '%1|''''', ServiceHeader."Work Status Code");



        ColorConfig.SetRange(Status, LaborAllocEntry.Status);

        if ColorConfig.FindLast then begin
            ForeColor := ColorConfig."Font Color";
            BackColor := ColorConfig."Background Color";
        end;

        CurrDateTime := DateTimeMgt.Datetime(WorkDate, Time);
        if (LaborAllocEntry."Start Date-Time" < CurrDateTime) and ((LaborAllocEntry.Status = LaborAllocEntry.Status::Pending) or (LaborAllocEntry.Status = LaborAllocEntry.Status::"On Hold")) then
            if ColorConfig."Allocation Delay Color" <> 0 then
                BackColor := ColorConfig."Allocation Delay Color";

        if (CurrDateTime > LaborAllocEntry."End Date-Time") and (LaborAllocEntry.Status = LaborAllocEntry.Status::"In Progress") then
            if ColorConfig."Allocation Delay Color" <> 0 then
                BackColor := ColorConfig."Allocation Delay Color";
    end;


    procedure SetCellFormatRTCRent(var RentAvailabilityBufferTmp: Record "Rent Availability Buffer"; var ForeColor: Integer; var BackColor: Integer)
    var
        ColorConfig: Record "Schedule Color Config.";
        ServiceHeader: Record "Service Header EDMS";
        ServLaborAllocationApplication: Record "Serv. Labor Alloc. Application";
        PostedServiceHeader: Record "Posted Serv. Order Header";
        PostedServRetOrderHeader: Record "Posted Serv. Ret. Order Header";
        CurrDateTime: Decimal;
    begin
        ServiceScheduleSetup.Get;
        ForeColor := 0; //Black
        BackColor := 16777215; //White
        ColorConfig.Reset;

        ColorConfig.SetRange("Source Type", ColorConfig."source type"::Rent);
        if RentAvailabilityBufferTmp."Rent Document No." <> '' then begin
            case RentAvailabilityBufferTmp."Rent Document Type" of
                RentAvailabilityBufferTmp."rent document type"::Order:
                    begin
                        ColorConfig.SetRange("Source Subtype", ColorConfig."source subtype"::Order);
                        //Add subtype
                        case RentAvailabilityBufferTmp.Type of
                            RentAvailabilityBufferTmp.Type::Reserved:
                                ColorConfig.SetRange("Rent Order Subtype", ColorConfig."rent order subtype"::Planned);
                            RentAvailabilityBufferTmp.Type::Rented:
                                ColorConfig.SetRange("Rent Order Subtype", ColorConfig."rent order subtype"::Shipped);
                            RentAvailabilityBufferTmp.Type::Recieved:
                                ColorConfig.SetRange("Rent Order Subtype", ColorConfig."rent order subtype"::Received);
                        end;
                    end;
                RentAvailabilityBufferTmp."rent document type"::Quote:
                    ColorConfig.SetRange("Source Subtype", ColorConfig."source subtype"::Quote);
                RentAvailabilityBufferTmp."rent document type"::"Return Order":
                    ColorConfig.SetRange("Source Subtype", ColorConfig."source subtype"::"Return Order");
            end;
        end;
        if RentAvailabilityBufferTmp."Service Order No." <> '' then begin
            ColorConfig.SetRange("Source Subtype", ColorConfig."source subtype"::Service);
        end;


        if ColorConfig.FindLast then begin
            ForeColor := ColorConfig."Font Color";
            BackColor := ColorConfig."Background Color";
        end;
    end;


    procedure SetResourceColor(ResourceNo: Code[20]; var ForeColor: Integer)
    var
        WorkTimeEntry: Record "Resource Work Time Entry";
    begin
        ServiceScheduleSetup.Get;

        WorkTimeEntry.Reset;
        WorkTimeEntry.SetCurrentkey("Resource No.", Closed);
        WorkTimeEntry.SetRange("Resource No.", ResourceNo);
        WorkTimeEntry.SetRange(Closed, false);
        if WorkTimeEntry.FindFirst then
            ForeColor := ServiceScheduleSetup."Working Resource Color"
        else
            ForeColor := ServiceScheduleSetup."Non-Working Resource Color";
    end;


    procedure SetDateColor(DateFilter: Date; var ForeColor: Integer; var UpdateBold: Boolean)
    var
        CheckDescription: Text[50];
        Day: Integer;
        ServiceHour: Record "Service Hour EDMS";
    begin
        Day := Date2dwy(DateFilter, 1) - 1;
        ServiceHour.Reset;
        ServiceHour.SetRange(Day, Day);
        if not ServiceHour.FindFirst then begin
            //ForeColor := ServiceScheduleSetup."Nonworking Day Color";
            UpdateBold := true;
        end;
    end;


    procedure GetAllocRecDescr(var LaborAllocEntry: Record "Serv. Labor Allocation Entry") RecordDesr: Text[250]
    begin
        if LaborAllocEntry."Entry No." <> 0 then
            RecordDesr := CopyStr(CreateFieldText(LaborAllocEntry."Entry No."), 1, 250);

        if RecordDesr = '' then
            RecordDesr := LaborAllocEntry."Source ID";
    end;


    procedure SelectAllocation(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        TempLaborAllocEntry: Record "Serv. Labor Allocation Entry" temporary;
        RecordCount: Integer;
    begin
        if not CheckUserRightsAdv(1, TempLaborAllocEntry) then exit;
        ScheduleAction := Scheduleaction::Planning;

        FillAllocEntryBuffer(TempLaborAllocEntry, ResourceNo, StartingDateTime, EndingDateTime);
        RecordCount := TempLaborAllocEntry.Count;

        if RecordCount = 0 then
            exit;

        if RecordCount = 1 then begin
            TempLaborAllocEntry.FindFirst;
            SelectAllocationEntry(TempLaborAllocEntry."Entry No.")
        end else //RecordCount > 1
            if Page.RunModal(Page::"Serv. Labor Allocation Entries", TempLaborAllocEntry) = Action::LookupOK then
                SelectAllocationEntry(TempLaborAllocEntry."Entry No.");
    end;


    procedure Deallocate(EntryNo: Integer)
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        ServiceHeader: Record "Service Header EDMS";
    begin
        ScheduleAction := Scheduleaction::Planning;

        //EntryNo := SingleInstanceMgt.GetAllocationEntryNo;

        if not LaborAllocEntryLoc.Get(EntryNo) then begin
            Message(Text121);
            exit;
        end;
        if not CheckUserRightsAdv(2, LaborAllocEntryLoc) then exit;

        if LaborAllocEntryLoc.Status in [LaborAllocEntryLoc.Status::"In Progress", LaborAllocEntryLoc.Status::Finished] then
            DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, EntryNo, 11111)
        else begin
            if SplitAllocTracking(EntryNo, 1) then
                DeallocateIncSplit(EntryNo, true)
            else
                DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, EntryNo, 11111);

            if LaborAllocEntryLoc.Status = LaborAllocEntryLoc.Status::Pending then begin
                if LaborAllocEntryLoc."Source Type" = LaborAllocEntryLoc."Source Type"::"Service Document" then begin
                    if ServiceHeader.Get(LaborAllocEntryLoc."Source Subtype", LaborAllocEntryLoc."Source ID") then begin
                        ServiceHeader.Validate("Work Status Code", '');
                        ServiceHeader.Modify();
                    end;
                end;
            end;
        end;
    end;


    procedure DeallocateIncSplit(EntryNo: Integer; DeleteAll: Boolean)
    var
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        LaborEntry: Integer;
        ReplanOtherEntries: Boolean;
        ProceedMode: Integer;
    begin
        FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 0);  //15.08.2013 EDMS P8
        LaborAllocEntryTemp.Reset;
        LaborAllocEntryTemp.SetCurrentkey("Resource No.", "End Date-Time");


        if LaborAllocEntryTemp.FindFirst then begin
            repeat
                DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, LaborAllocEntryTemp."Entry No.", 10000)
            until LaborAllocEntryTemp.Next = 0;
            LaborAllocEntryTemp.FindLast;
            repeat
                ProceedMode := 1110;
                if LaborAllocEntryTemp.Count = 1 then
                    ProceedMode := 1111;
                if DeleteAll then begin
                    DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, LaborAllocEntryTemp."Entry No.", ProceedMode)
                end else
                    if LaborAllocEntryTemp."Entry No." <> EntryNo then
                        DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, LaborAllocEntryTemp."Entry No.", ProceedMode);
            until LaborAllocEntryTemp.Next(-1) = 0;
        end;
    end;


    procedure MoveAllocation(EntryNo: Integer; NewResourceNo: Code[20]; NewStartingDateTime: Decimal)
    var
        ServiceLine: Record "Service Line EDMS" temporary;
        ServiceLine2: Record "Service Line EDMS";
        LaborAllocAppTemp: Record "Serv. Labor Alloc. Application" temporary;
        AllocationForm: Page Allocation;
        IsHandled: boolean;
    begin
        Clear(AllocationForm);
        if not LaborAllocEntry.Get(EntryNo) then begin
            Message(Text121);
            exit;
        end;
        if not CheckUserRightsAdv(300, LaborAllocEntry) then exit;
        //>>Delta MGR
        IsHandled := true;
        OnBeforeSetParamAllocationForm(LaborAllocEntry, AllocationForm, IsHandled);
        if IsHandled then
            //<<Delta MGR
            AllocationForm.SetParam(EntryNo, NewResourceNo, NewStartingDateTime, LaborAllocEntry."Quantity (Hours)",
              LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID", 1, ServiceLine, 0);

        AllocationForm.LookupMode(true);  //03.04.2013 P8
        Commit;  //28.06.2013 EDMS P8
        AllocationForm.RunModal;
    end;


    procedure StartEndAllocation(AllocationStatus1: Option Pending,"In Progress","Finish All","Finish Part","On Hold")
    var
        WorkTimeEntry: Record "Resource Work Time Entry";
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        CurrDateTime: Decimal;
        HoldHours: Decimal;
        StartFinishAllocation: Page "Time Registration";
    begin
        Clear(StartFinishAllocation);
        if not LaborAllocEntry.Get(SingleInstanceMgt.GetAllocationEntryNo) then begin
            Message(Text121);
            exit;
        end;
        if not CheckUserRightsAdv(1, LaborAllocEntry) then exit;

        CurrDateTime := DateTimeMgt.Datetime(WorkDate, Time);

        if AllocationStatus1 = Allocationstatus1::"In Progress" then begin
            if LaborAllocEntry.Status = LaborAllocEntry.Status::Finished then
                Error(Text109);
            if LaborAllocEntry.Status = LaborAllocEntry.Status::"In Progress" then
                Error(Text110);
        end;

        if AllocationStatus1 in [Allocationstatus1::"Finish All", Allocationstatus1::"Finish Part", Allocationstatus1::"On Hold"] then begin
            if LaborAllocEntry.Status <> LaborAllocEntry.Status::"In Progress" then
                Error(Text111);
        end;

        StartFinishAllocation.SetParam(LaborAllocEntry."Resource No.", CurrDateTime, LaborAllocEntry."Quantity (Hours)",
                                 LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID",
                                 AllocationStatus1, HoldHours, '');
        StartFinishAllocation.LookupMode(true);  //03.04.2013 P8
        Commit;  //28.06.2013 EDMS P8
        StartFinishAllocation.RunModal;

    end;


    procedure StartEndWorktime(ResourceNo: Code[20]; Status: Option Start,"End")
    var
        CurrDateTime: Decimal;
        WorktimeRegistration: Page "Worktime Registration";
        PageAction: action;
    begin
        if not CheckUserRightsAdv(1, LaborAllocEntry) then exit;

        CurrDateTime := DateTimeMgt.Datetime(WorkDate, Time);
        Clear(WorktimeRegistration);
        WorktimeRegistration.SetParam(ResourceNo, CurrDateTime, Status);
        WorktimeRegistration.LookupMode(true);  //03.04.2013 P8
        Commit;  //28.06.2013 EDMS P8
        WorktimeRegistration.RunModal;
    end;


    procedure CalcEndDTOnlyWorktime(StartDT: Decimal; EndDT: Decimal; NewResNo: Code[20]) RetValue: Decimal
    var
        DateRec: Record Date;
        UnavailAllocEntry: Record "Serv. Labor Allocation Entry" temporary;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        CurrDT: Decimal;
        NewCurrDT: Decimal;
        UnavailAllocEntryCount: Integer;
        CurrRecIndex: Integer;
    begin
        UnavailAllocEntry.Reset;
        UnavailAllocEntry.DeleteAll;
        RetValue := EndDT;
        if ServiceScheduleSetup."Show Unavailable Time" then begin
            DateRec.Reset;
            DateRec.SetRange("Period Type", DateRec."period type"::Date);
            DateRec.SetRange("Period Start", DateTimeMgt.Datetime2Date(StartDT), DateTimeMgt.Datetime2Date(EndDT));
            if DateRec.FindFirst then
                repeat
                    FillUnavailableTimeEntries(UnavailAllocEntry, NewResNo,
                                                                  DateRec."Period Start");
                until DateRec.Next = 0;
            CurrDT := StartDT;
            UnavailAllocEntryCount := UnavailAllocEntry.Count;
            if UnavailAllocEntryCount > 1 then begin
                CurrRecIndex := 1;
                UnavailAllocEntry.FindFirst;
                while ((CurrDT < EndDT) and (CurrRecIndex <= UnavailAllocEntryCount)) do begin
                    if (UnavailAllocEntry."Start Date-Time" <= CurrDT) and (CurrDT <= UnavailAllocEntry."End Date-Time") then begin
                        if (UnavailAllocEntry."End Date-Time" > EndDT) then begin
                            NewCurrDT := EndDT;
                        end else begin
                            NewCurrDT := UnavailAllocEntry."End Date-Time";
                        end;
                        RetValue -= (NewCurrDT - CurrDT);
                        RetValue -= DateTimeMgt.Datetime(0D, 000000.001T); //minus one millisecond
                    end else begin
                        if (UnavailAllocEntry."Start Date-Time" >= CurrDT) and (CurrDT <= UnavailAllocEntry."End Date-Time") then begin
                            if (UnavailAllocEntry."Start Date-Time" >= EndDT) then begin
                                NewCurrDT := EndDT;
                            end else begin
                                CurrDT := UnavailAllocEntry."Start Date-Time";
                                if (UnavailAllocEntry."End Date-Time" > EndDT) then
                                    NewCurrDT := EndDT
                                else
                                    NewCurrDT := UnavailAllocEntry."End Date-Time";
                                RetValue -= (NewCurrDT - CurrDT);
                                RetValue -= DateTimeMgt.Datetime(0D, 000000.001T); //minus one millisecond
                            end;
                        end else begin
                            NewCurrDT := CurrDT;
                            RetValue -= 0;
                        end;
                    end;
                    CurrDT := NewCurrDT;
                    CurrRecIndex += 1;
                    UnavailAllocEntry.Next;
                end;
            end;
        end;

        exit(RetValue);
    end;


    procedure BreakAllocation()
    var
        CurrDateTime: Decimal;
        AllocationForm: Page Allocation;
    begin
        CurrDateTime := DateTimeMgt.Datetime(WorkDate, Time);

        if not LaborAllocEntry.Get(SingleInstanceMgt.GetAllocationEntryNo) then begin
            Message(Text121);
            exit;
        end;

        if not CheckUserRightsAdv(4, LaborAllocEntry) then exit;


        AllocationForm.SetParam(LaborAllocEntry."Entry No.", LaborAllocEntry."Resource No.", CurrDateTime,
          LaborAllocEntry."Quantity (Hours)",
          LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID", 3, ServiceLine, 0);
        AllocationForm.LookupMode(true);  //03.04.2013 P8
        Commit;  //28.06.2013 EDMS P8
        AllocationForm.RunModal;

        //END;//30.10.2012 EDMS
    end;


    procedure ProcessMovement(EntryNo: Integer; NewResourceNo: Code[20]; NewStartingDateTime: Decimal; NewQtyToAllocate: Decimal; SplitTracking1: Option No,Yes; NewStatus: Option Pending,"In Process",Finished,"On Hold"; Operation: Integer; Travel: Boolean)
    var
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        OldResourceNo: Code[20];
        OldStartingDateTime: Decimal;
        OldEndingDateTime: Decimal;
        OldHours: Decimal;
        DoReplan: Boolean;
        MainAllocEntrNo: Integer;
    begin
        // Operation codes:
        // -1 UNDEFINED
        // 0 view; 1 - time registration; 2 - Planning; 3 - Reallocate (manager); 4 - BREAK; 100 - allocate lines; 110 - allocate header; 120 - ALLOCATE standart event
        // 200 - spliting
        // 300 - move; 310 - change end time of finished
        // 400 - delete entry
        ScheduleAction := Scheduleaction::Planning;
        SplitTracking := SplitTracking1;
        LaborAllocEntry.Get(EntryNo);
        if Operation < 0 then
            Operation := 300;
        if not CheckUserRightsAdv(Operation, LaborAllocEntry) then exit;

        OldResourceNo := LaborAllocEntry."Resource No.";
        if not (Resource.Get(NewResourceNo)) then begin
            NewResourceNo := OldResourceNo;
            if not (Resource.Get(NewResourceNo)) then
                Error(Text160);
        end;
        OldStartingDateTime := LaborAllocEntry."Start Date-Time";
        OldEndingDateTime := LaborAllocEntry."End Date-Time";
        OldHours := LaborAllocEntry."Quantity (Hours)";
        DoReplan := true;

        ServiceScheduleSetup.Get;

        if SplitAllocTracking(EntryNo, 0) then begin
            MainAllocEntrNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
            //MESSAGE('msg in processmovement 01');
            MovementIncSplit(EntryNo, NewResourceNo, NewStartingDateTime, NewQtyToAllocate, NewStatus);
            // in routine MovementIncSplit is deleted EntryNo, then need continue with MainAllocEntrNo
            EntryNo := MainAllocEntrNo;
        end else begin
            WriteAllocationEntries(NewResourceNo, NewStartingDateTime, NewQtyToAllocate,
                                   LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                   LaborAllocEntry."Source ID", 1, EntryNo, DoReplan, NewStatus, false, Travel);

            if ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."handle linked entries"::No then
                JoinAllocationEntries(NewResourceNo, NewStartingDateTime);

            if NewResourceNo <> OldResourceNo then begin  //replan old resource entries
                ReplanEntries(OldResourceNo, OldEndingDateTime, -OldHours, false, 0, '');

                if ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."handle linked entries"::No then
                    JoinAllocationEntries(OldResourceNo, OldStartingDateTime);
            end;
        end;
        //Adjust Related entries
        SynchroniseRelatedEntries(EntryNo);
    end;


    procedure ProcessMovementApp(var ServLaborAllocApplicationPar: Record "Serv. Labor Alloc. Application"; EntryNo: Integer; NewResourceNo: Code[20]; NewStartingDateTime: Decimal; NewQtyToAllocate: Decimal; SplitTracking1: Option No,Yes) MainAllocEntrNo: Integer
    var
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        OldResourceNo: Code[20];
        OldStartingDateTime: Decimal;
        OldEndingDateTime: Decimal;
        OldHours: Decimal;
        DoReplan: Boolean;
        ResourceTmp: Record Resource temporary;
        Resource: Record Resource;
        ServLaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        PreviousAllocEntryNo: Integer;
    begin
        // at first create new entries
        LaborAllocEntry.Get(EntryNo);
        ResourceTmp.Reset;
        ResourceTmp.DeleteAll;
        if ServLaborAllocApplicationPar.FindFirst then
            repeat
                //Šeit vai nu ar setrange atrast vai tāds jau existē, vai pirms tam jau padot arī existējošas rindas ar pareizu LineNo.
                LaborAllocApp.Reset;
                LaborAllocApp.SetRange("Allocation Entry No.", ServLaborAllocApplicationPar."Allocation Entry No.");
                LaborAllocApp.SetRange("Document Type", ServLaborAllocApplicationPar."Document Type");
                LaborAllocApp.SetRange("Document No.", ServLaborAllocApplicationPar."Document No.");
                LaborAllocApp.SetRange("Document Line No.", ServLaborAllocApplicationPar."Document Line No.");
                LaborAllocApp.SetRange("Resource No.", ServLaborAllocApplicationPar."Resource No.");
                //IF NOT LaborAllocApp.GET("Allocation Entry No.", "Document Type", "Document No.", "Document Line No.","Line No.") THEN BEGIN
                if not LaborAllocApp.FindFirst then begin
                    if not ResourceTmp.Get(ServLaborAllocApplicationPar."Resource No.") then begin
                        if Resource.Get(ServLaborAllocApplicationPar."Resource No.") then begin
                            ResourceTmp := Resource;
                            ResourceTmp.Insert;
                        end;
                    end;
                end;
            until ServLaborAllocApplicationPar.Next = 0;
        //'NewStartingDateTime:'+FORMAT(NewStartingDateTime)+', NewQtyToAllocate:'+FORMAT(NewQtyToAllocate)); //
        if ResourceTmp.FindFirst then begin
            MainAllocEntrNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
            FindSplitEntries(MainAllocEntrNo, ServLaborAllocEntryTmp, 0, 1111);
            PreviousAllocEntryNo := 0;
            repeat
                ServLaborAllocEntryTmp.FindFirst;
                repeat
                    PreviousAllocEntryNo := AddResourceToAllocEntry(ServLaborAllocEntryTmp, LaborAllocApp,
                      ResourceTmp."No.", PreviousAllocEntryNo, LaborAllocEntry, LaborAllocApp);
                until ServLaborAllocEntryTmp.Next = 0;
            until ResourceTmp.Next = 0;
        end;
        ProcessMovement(EntryNo, NewResourceNo, NewStartingDateTime, NewQtyToAllocate, SplitTracking1, LaborAllocEntry.Status, -1, LaborAllocEntry.Travel);
        exit(MainAllocEntrNo);
    end;


    procedure MovementIncSplit(EntryNo: Integer; NewResourceNo: Code[20]; NewStartingDateTime: Decimal; NewQtyToAllocate: Decimal; NewStatus: Integer)
    var
        ServLaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        ServiceLineLoc: Record "Service Line EDMS" temporary;
        NewSourceID: Code[20];
        NewSourceType: Option ,"Service Document","Standard Event";
        NewSourceSubType: Option Qoute,"Order";
        NewTotalHours: Decimal;
        DoReplan: Boolean;
        RecalcQtyToAllocate: Decimal;
        QtyToMove: Decimal;
        OldStartingDateTime: Decimal;
        MainAllocEntrNo: Integer;
        Travel: Boolean;
    begin
        ServiceScheduleSetup.Get;

        LaborAllocEntry.Get(EntryNo);
        Travel := LaborAllocEntry.Travel;
        NewSourceType := LaborAllocEntry."Source Type";
        NewSourceSubType := LaborAllocEntry."Source Subtype";
        NewSourceID := LaborAllocEntry."Source ID";
        //NewStatus := LaborAllocEntry.Status;
        DoReplan := false;

        ServiceLineLoc.DeleteAll;
        if LaborAllocEntry."Source Type" = LaborAllocEntry."source type"::"Service Document" then begin
            LaborAllocApp.Reset;
            LaborAllocApp.SetRange("Allocation Entry No.", LaborAllocEntry."Entry No.");
            if LaborAllocApp.FindFirst then
                repeat
                    FillServiceLine2(ServiceLineLoc, LaborAllocApp."Document Type", LaborAllocApp."Document No.",
                      LaborAllocApp."Document Line No.");
                until LaborAllocApp.Next = 0;
        end;

        RecalcQtyToAllocate := 0;
        FindSplitEntries(EntryNo, ServLaborAllocEntryTmp, 0, 0);  //15.08.2013 EDMS P8
        if ServLaborAllocEntryTmp.FindFirst then begin
            repeat
                if ServLaborAllocEntryTmp."Entry No." = EntryNo then
                    RecalcQtyToAllocate += NewQtyToAllocate
                else
                    RecalcQtyToAllocate += ServLaborAllocEntryTmp."Quantity (Hours)";
            until ServLaborAllocEntryTmp.Next = 0;
        end;

        OldStartingDateTime := LaborAllocEntry."Start Date-Time";
        QtyToMove := NewStartingDateTime - OldStartingDateTime;
        //lets first split part will be as start point
        MainAllocEntrNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
        EntryNo := MainAllocEntrNo;
        LaborAllocEntry.Get(EntryNo);
        NewStartingDateTime := LaborAllocEntry."Start Date-Time" + QtyToMove;
        //MESSAGE('msg in movement 0');

        DeallocateIncSplit(EntryNo, false);

        //MESSAGE('msg in movement 1');
        ClearAllocationEntry(EntryNo, false);

        //MESSAGE('msg in movement 2');
        ServiceLineLoc.Reset;
        if ServiceLineLoc.FindFirst then
            repeat
                FillServiceLine2(ServiceLine, ServiceLineLoc."Document Type", ServiceLineLoc."Document No.", ServiceLineLoc."Line No.");
            until ServiceLineLoc.Next = 0;


        WriteAllocationEntries(NewResourceNo, NewStartingDateTime, RecalcQtyToAllocate,
                               NewSourceType, NewSourceSubType, NewSourceID, 1, EntryNo, DoReplan, NewStatus, false, Travel);


        if ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."handle linked entries"::No then
            JoinAllocationEntries(NewResourceNo, NewStartingDateTime);
    end;


    procedure AllocateStandardEvent(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        StandardEvents: Page "Serv. Standard Events";
        StandardEvent: Record "Serv. Standard Event";
        ServLine: Record "Service Line EDMS";
        CurrQtyToAllocate: Decimal;
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        RoundMs: Integer;
    begin
        //IF ServiceScheduleSetup."Allocation Time Step (Minutes)" > 0 THEN
        //  RoundMs := ServiceScheduleSetup."Allocation Time Step (Minutes)"
        //ELSE
        RoundMs := 60000;

        if RoundMs > 0 then begin
            StartingDateTime := DateTimeRound(StartingDateTime, RoundMs);
            EndingDateTime := DateTimeRound(EndingDateTime, RoundMs);
        end;

        CurrQtyToAllocate := ServiceScheduleMgt.CalcWorkHourDifference(ResourceNo, StartingDateTime, EndingDateTime);
        CurrQtyToAllocate := ServiceScheduleMgt.RoundQtyHours(CurrQtyToAllocate, 0);
        if not CheckUserRightsAdv(2, LaborAllocEntry) then exit;

        Clear(StandardEvents);

        StandardEvents.LookupMode(true);

        if StandardEvents.RunModal = Action::LookupOK then begin
            StandardEvents.GetRecord(StandardEvent);
            //Allocate(ResourceNo,StartingDateTime,0,2,0,StandardEvent.Code,ServLine,0);
            Allocate(ResourceNo, StartingDateTime, CurrQtyToAllocate, 2, 0, StandardEvent.Code, ServLine, 0);
        end
        else
            exit;
    end;


    procedure AllocateServiceLines(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        ServiceLinesAllocation: Page "Service Lines - Allocation";
        ServiceLine: Record "Service Line EDMS";
        ServiceLine2: Record "Service Line EDMS";
        ServiceHdr: Record "Service Header EDMS";
        WhatAllocation: Option Header,Line;
        NewLineNo: Integer;
        CurrQtyToAllocate: Decimal;
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
    begin
        CurrQtyToAllocate := ServiceScheduleMgt.CalcWorkHourDifference(ResourceNo, StartingDateTime, EndingDateTime);

        if not CheckUserRightsAdv(100, LaborAllocEntry) then exit;

        Clear(ServiceLinesAllocation);

        ServiceLinesAllocation.LookupMode(true);

        if ServiceLinesAllocation.RunModal = Action::LookupOK then begin
            ServiceLinesAllocation.SetSelectionFilter1(ServiceLine);
            CheckForCorrectServHeaderLine(ServiceHdr, ServiceLine, Whatallocation::Line);

            ServiceLine2.ClearMarks;
            if ServiceLine.FindFirst then
                repeat
                    NewLineNo := ServiceLine."Line No.";
                    if not CheckServiceLineResource(ServiceLine."Document Type", ServiceLine."Document No.",
                        ServiceLine.Type, ServiceLine."Line No.", 1, ResourceNo) then begin
                        if Confirm(StrSubstNo(Text137, ServiceLine."No.")) then
                            NewLineNo := SplitServiceLine(ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."Line No.");
                    end;
                    ServiceLine2.Get(ServiceLine."Document Type", ServiceLine."Document No.", NewLineNo);
                    ServiceLine2.Mark(true);
                until ServiceLine.Next = 0;
            Commit;
            ServiceLine2.MarkedOnly(true);

            if ServiceLine2.FindFirst then
                //Allocate(ResourceNo,StartingDateTime,0,1,ServiceLine2."Document Type",ServiceLine2."Document No.",ServiceLine2,0);
                Allocate(ResourceNo, StartingDateTime, CurrQtyToAllocate, 1, ServiceLine2."Document Type", ServiceLine2."Document No.", ServiceLine2, 0);
        end
        else
            exit;
    end;


    procedure AllocateServiceOrder(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        ServiceHdrsAllocation: Page "Service Documents - Allocation";
        ServiceHdr: Record "Service Header EDMS";
        ServiceLineLoc: Record "Service Line EDMS" temporary;
        WhatAllocation: Option Header,Line;
        CurrQtyToAllocate: Decimal;
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
    begin
        CurrQtyToAllocate := ServiceScheduleMgt.CalcWorkHourDifference(ResourceNo, StartingDateTime, EndingDateTime);
        if not CheckUserRightsAdv(110, LaborAllocEntry) then exit;

        Clear(ServiceHdrsAllocation);
        ServiceHdrsAllocation.LookupMode(true);

        if ServiceHdrsAllocation.RunModal = Action::LookupOK then begin
            ServiceHdrsAllocation.GetRecord(ServiceHdr);
            CheckForCorrectServHeaderLine(ServiceHdr, ServiceLine, Whatallocation::Header);
            ServiceLine.SetRange("Document Type", ServiceHdr."Document Type");
            ServiceLine.SetRange("Document No.", ServiceHdr."No.");
            ServiceLine.SetRange("Line No.", 0);
            //Allocate(ResourceNo,StartingDateTime,0,1,ServiceHdr."Document Type",ServiceHdr."No.",ServiceLine,0);
            Allocate(ResourceNo, StartingDateTime, CurrQtyToAllocate, 1, ServiceHdr."Document Type", ServiceHdr."No.", ServiceLine, 0);
        end
        else
            exit;
    end;


    procedure AllocateEventAndStart(ResourceNo: Code[20])
    var
        StandardEvents: Page "Serv. Standard Events";
        AllocationForm: Page "Start Unplanned";
        StandardEvent: Record "Serv. Standard Event";
        ServLine: Record "Service Line EDMS";
        StartingDateTime: Decimal;
    begin
        if not CheckUserRightsAdv(1, LaborAllocEntry) then exit;

        StartingDateTime := DateTimeMgt.Datetime(WorkDate, Time);
        Clear(StandardEvents);

        StandardEvents.LookupMode(true);

        if StandardEvents.RunModal = Action::LookupOK then begin
            StandardEvents.GetRecord(StandardEvent);
            Clear(AllocationForm);
            AllocationForm.SetParam(ResourceNo, StartingDateTime, 2, 0, StandardEvent.Code);
            AllocationForm.LookupMode(true);
            Commit;  //28.06.2013 EDMS P8
            AllocationForm.RunModal;
        end
        else
            exit;
    end;


    procedure Allocate(ResourceNo: Code[20]; StartingDateTime: Decimal; QtyToAllocate: Decimal; SourceType: Option ,"Service Document","Standard Event"; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]; var ServiceLine1: Record "Service Line EDMS"; ForceStatus: Integer): Boolean
    var
        AllocationForm: Page Allocation;
        LaborAllocAppTemp: Record "Serv. Labor Alloc. Application" temporary;
    begin
        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartingDateTime, QtyToAllocate, SourceType, SourceSubType, SourceID, 0, ServiceLine1, ForceStatus);
        AllocationForm.SetTableview := LaborAllocAppTemp;
        AllocationForm.LookupMode(true);  //03.04.2013 P8
        Commit;  //28.06.2013 EDMS P8
        AllocationForm.RunModal;
    end;


    procedure AllocateNewVisitQuote(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        ServiceHdr: Record "Service Header EDMS";
        ServiceLineLoc: Record "Service Line EDMS" temporary;
        WhatAllocation: Option Header,Line;
        DocumentNo: Code[20];
        DocumentType: Option Quote,"Order","Return Order";
    begin
        if not CheckUserRightsAdv(110, LaborAllocEntry) then exit;

        DocumentNo := CreateNewServiceDocument(ServiceHdr."document type"::Quote);
        ServiceHdr.SetRange("Document Type", ServiceHdr."document type"::Quote);
        ServiceHdr.SetRange("No.", DocumentNo);
        if ServiceHdr.FindFirst then begin
            CheckForCorrectServHeaderLine(ServiceHdr, ServiceLine, Whatallocation::Header);
            Allocate(ResourceNo, StartingDateTime, 0, 1, ServiceHdr."Document Type", ServiceHdr."No.", ServiceLine, 0);
        end else
            exit;
    end;


    procedure AllocateNewVisitOrder(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        ServiceHdr: Record "Service Header EDMS";
        ServiceLineLoc: Record "Service Line EDMS";
        WhatAllocation: Option Header,Line;
        DocumentNo: Code[20];
        DocumentType: Option Quote,"Order","Return Order";
    begin
        if not CheckUserRightsAdv(110, LaborAllocEntry) then exit;

        DocumentNo := CreateNewServiceDocument(ServiceHdr."document type"::Order);
        ServiceHdr.SetRange("Document Type", ServiceHdr."document type"::Order);
        ServiceHdr.SetRange("No.", DocumentNo);
        if ServiceHdr.FindFirst then begin
            //22.03.2014 Elva Baltic P1 #X01 MMG7.00 >>
            //CheckForCorrectServHeaderLine(ServiceHdr, ServiceLine, WhatAllocation::Header);
            ServiceLineLoc.Reset;
            ServiceLineLoc.SetRange("Document Type", ServiceLineLoc."document type"::Order);
            ServiceLineLoc.SetRange("Document No.", DocumentNo);
            ServiceLineLoc.SetRange(Type, ServiceLineLoc.Type::Labor); //06.04.2014 Elva Baltic P1 #X01 MMG7.00
                                                                       //CheckForCorrectServHeaderLine(ServiceHdr, ServiceLine, WhatAllocation::Line); //09.04.2014 Elva Baltic P1 #X01 MMG7.00
            CheckForCorrectServHeaderLine(ServiceHdr, ServiceLineLoc, Whatallocation::Line); //09.04.2014 Elva Baltic P1 #X01 MMG7.00
                                                                                             //22.03.2014 Elva Baltic P1 #X01 MMG7.00 <<
            Allocate(ResourceNo, StartingDateTime, 0, 1, ServiceHdr."Document Type", ServiceHdr."No.", ServiceLineLoc, 0);
        end else
            exit;
    end;


    procedure ProcessAllocation(ResourceNo: Code[20]; StartingDateTime: Decimal; QtyToAllocate: Decimal; SourceType: Option " ","Service Document","Standard Event"; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]; var ServiceLine1: Record "Service Line EDMS"; DivideIntoLines: Boolean; ForceStatus1: Option Pending,"In Progress",Finished,"On Hold",Cancelled; TravelPar: Boolean)
    var
        ServiceLine2: Record "Service Line EDMS" temporary;
        ServiceHours: Decimal;
        QtyToAllocate2: Decimal;
        JoinStartingDateTime: Decimal;
        RecCount: Integer;
        EntryNo: Integer;
        DoReplan: Boolean;
    begin
        //21.11.2013 EDMS P8
        case SourceType of
            Sourcetype::"Service Document":
                begin
                    if ServiceLine1."Line No." > 0 then begin
                        if not CheckUserRightsAdv(100, LaborAllocEntry) then exit;
                    end else
                        if not CheckUserRightsAdv(110, LaborAllocEntry) then exit;
                end;
            Sourcetype::"Standard Event":
                if not CheckUserRightsAdv(120, LaborAllocEntry) then
                    exit;
            else
                if not CheckUserRightsAdv(100, LaborAllocEntry) then exit;
        end;

        ServiceScheduleSetup.Get;
        ScheduleAction := Scheduleaction::Planning;
        DoReplan := true;

        JoinStartingDateTime := StartingDateTime;
        if not DivideIntoLines then begin
            FillServiceLine(ServiceLine1);
            WriteAllocationEntries(ResourceNo, StartingDateTime, QtyToAllocate, SourceType, SourceSubType, SourceID, 0, 0, DoReplan, ForceStatus1, false, TravelPar);
        end else begin
            RecCount := ServiceLine1.Count;
            if ServiceLine1.FindFirst then
                repeat
                    ServiceHours += ServiceLine1.GetTimeQty;
                until ServiceLine1.Next = 0;

            EntryNo := 0;
            if ServiceLine1.FindFirst then
                repeat
                    ServiceLine2.Reset;
                    ServiceLine2.DeleteAll;
                    if ServiceLine1.Quantity <> 0 then begin
                        ServiceLine2 := ServiceLine1;
                        ServiceLine2.Insert;
                        FillServiceLine(ServiceLine2);
                        QtyToAllocate2 := ROUND((ServiceLine2.GetTimeQty / ServiceHours) * QtyToAllocate, 0.001);
                        WriteAllocationEntries(ResourceNo, StartingDateTime, QtyToAllocate2, SourceType, ServiceLine2."Document Type",
                                               ServiceLine2."Document No.", 0, 0, DoReplan, ForceStatus1, false, TravelPar);
                        StartingDateTime := LaborAllocEntry."End Date-Time";
                        EntryNo := LaborAllocEntry."Entry No.";
                    end;
                until ServiceLine1.Next = 0;
        end;

        if ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."handle linked entries"::No then
            JoinAllocationEntries(ResourceNo, JoinStartingDateTime);
    end;


    procedure ProcessAllocationResources(var ResourceTmp: Record Resource temporary; StartingDateTime: Decimal; QtyToAllocate: Decimal; SourceType: Option " ","Service Document","Standard Event"; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]; var ServiceLine1: Record "Service Line EDMS"; DivideIntoLines: Boolean; ForceStatus1: Option Pending,"In Progress",Finished,"On Hold",Cancelled; TravelPar: Boolean) MainAllocEntrNo: Integer
    var
        ServLaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        PreviousAllocEntryNo: Integer;
        TextNoRecords: label 'No Resource to process, so no entry is generated.';
    begin
        if ResourceTmp.FindFirst then begin
            ProcessAllocation(ResourceTmp."No.", StartingDateTime, QtyToAllocate, SourceType, SourceSubType,
              SourceID, ServiceLine1, DivideIntoLines, ForceStatus1, TravelPar);
            MainAllocEntrNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
            FindSplitEntries(MainAllocEntrNo, ServLaborAllocEntryTmp, 0, 1111);
            PreviousAllocEntryNo := 0;
            if ResourceTmp.Next <> 0 then
                repeat
                    ServLaborAllocEntryTmp.FindFirst;
                    repeat
                        PreviousAllocEntryNo := AddResourceToAllocEntry(ServLaborAllocEntryTmp, LaborAllocApp,
                          ResourceTmp."No.", PreviousAllocEntryNo, LaborAllocEntry, LaborAllocApp);
                    until ServLaborAllocEntryTmp.Next = 0;
                until ResourceTmp.Next = 0;
        end else
            Error(TextNoRecords);
        exit(MainAllocEntrNo);
    end;


    procedure AllocationSpliting(NewResourceNo: Code[20]; NewStartingDateTime: Decimal)
    var
        AllocationForm: Page Allocation;
        ServiceLine: Record "Service Line EDMS";
    begin
        Clear(AllocationForm);
        if not LaborAllocEntry.Get(SingleInstanceMgt.GetAllocationEntryNo) then begin
            Message(Text121);
            exit;
        end;
        if not CheckUserRightsAdv(200, LaborAllocEntry) then exit;

        AllocationForm.SetIsTravel(LaborAllocEntry.Travel);
        AllocationForm.SetParam(0, NewResourceNo, NewStartingDateTime, LaborAllocEntry."Quantity (Hours)",
          LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID", 2, ServiceLine, 0);
        AllocationForm.LookupMode(true);  //03.04.2013 P8
        Commit;  //28.06.2013 EDMS P8
        AllocationForm.RunModal;
    end;


    procedure ProcessSpliting(NewResourceNo: Code[20]; NewStartingDateTime: Decimal; NewQtyToAllocate: Decimal; SplitTracking1: Option No,Yes)
    var
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        TotalHours: Decimal;
        StartDateTime: Decimal;
        EntryNo: Integer;
        DoReplan: Boolean;
        DifferentStatus: Boolean;
    begin
        if NewQtyToAllocate <= 0 then
            exit;

        if not CheckUserRightsAdv(200, LaborAllocEntry) then exit;

        ServiceScheduleSetup.Get;
        ScheduleAction := Scheduleaction::Planning;
        DoReplan := true;

        SplitTracking := SplitTracking1;
        EntryNo := SingleInstanceMgt.GetAllocationEntryNo;
        LaborAllocEntry.Get(EntryNo);

        AllocationStatus := LaborAllocEntry.Status;
        ChangeAllocationStatus := true;

        TotalHours := CalculateTotalHours(EntryNo);
        FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 1111);
        LaborAllocEntryTemp.SetCurrentkey("Resource No.", "Start Date-Time");
        if LaborAllocEntryTemp.FindFirst then
            StartDateTime := LaborAllocEntryTemp."Start Date-Time";


        if SplitAllocTracking(EntryNo, 0) then begin
            if NewQtyToAllocate >= TotalHours then
                MovementIncSplit(EntryNo, NewResourceNo, NewStartingDateTime, NewQtyToAllocate, LaborAllocEntry.Status) //do only moving
            else begin
                MovementIncSplit(EntryNo, LaborAllocEntry."Resource No.", StartDateTime, TotalHours - NewQtyToAllocate,
                    LaborAllocEntry.Status); //correct old entry
                DoServiceSpliting := (NewResourceNo <> LaborAllocEntry."Resource No.");
                LaborAllocApp.Reset;
                LaborAllocApp.SetRange("Allocation Entry No.", EntryNo);
                if LaborAllocApp.FindFirst then
                    repeat
                        FillServiceLine2(ServiceLine, LaborAllocApp."Document Type", LaborAllocApp."Document No.",
                          LaborAllocApp."Document Line No.");
                    until LaborAllocApp.Next = 0;

                WriteAllocationEntries(NewResourceNo, NewStartingDateTime, NewQtyToAllocate,      //insert new entry
                                       LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                       LaborAllocEntry."Source ID", 0, 0, DoReplan, LaborAllocEntry.Status, false, false);

                if ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."handle linked entries"::No then
                    JoinAllocationEntries(NewResourceNo, NewStartingDateTime);
            end;
        end else begin
            if NewQtyToAllocate >= LaborAllocEntry."Quantity (Hours)" then begin
                DoServiceSpliting := (NewResourceNo <> LaborAllocEntry."Resource No.");
                DifferentStatus := CheckLaborStatus(LaborAllocEntryTemp);
                if DifferentStatus and DoServiceSpliting then begin
                    LaborAllocApp.Reset;
                    LaborAllocApp.SetRange("Allocation Entry No.", EntryNo);
                    if LaborAllocApp.FindFirst then
                        repeat
                            FillServiceLine2(ServiceLine, LaborAllocApp."Document Type", LaborAllocApp."Document No.",
                              LaborAllocApp."Document Line No.");
                        until LaborAllocApp.Next = 0;

                    WriteAllocationEntries(NewResourceNo, NewStartingDateTime, NewQtyToAllocate,
                                           LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                           LaborAllocEntry."Source ID", 0, 0, DoReplan, LaborAllocEntry.Status, false, false);

                    if ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."handle linked entries"::No then
                        JoinAllocationEntries(NewResourceNo, NewStartingDateTime);

                    DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, EntryNo, 11111);

                    if LaborAllocEntryTemp.FindFirst then
                        repeat
                            StatusChanged := false;
                            if LaborAllocEntryTemp."Entry No." <> EntryNo then begin
                                ChangeServiceLineStatus(LaborAllocEntryTemp."Entry No.", false);
                                StatusChanged := true;
                            end;
                        until (LaborAllocEntryTemp.Next = 0) or StatusChanged;

                end else begin
                    WriteAllocationEntries(NewResourceNo, NewStartingDateTime, NewQtyToAllocate,
                                           LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                           LaborAllocEntry."Source ID", 1, EntryNo, DoReplan, LaborAllocEntry.Status, false, false);

                    if ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."handle linked entries"::No then
                        JoinAllocationEntries(NewResourceNo, NewStartingDateTime);
                end;
            end else begin
                WriteAllocationEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."Start Date-Time",
                                     LaborAllocEntry."Quantity (Hours)" - NewQtyToAllocate,
                                     LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                     LaborAllocEntry."Source ID", 1, EntryNo, DoReplan, LaborAllocEntry.Status, false, false);

                if ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."handle linked entries"::No then
                    JoinAllocationEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."Start Date-Time");

                DoServiceSpliting := (NewResourceNo <> LaborAllocEntry."Resource No.");

                LaborAllocApp.Reset;
                LaborAllocApp.SetRange("Allocation Entry No.", EntryNo);
                if LaborAllocApp.FindFirst then
                    repeat
                        FillServiceLine2(ServiceLine, LaborAllocApp."Document Type", LaborAllocApp."Document No.",
                          LaborAllocApp."Document Line No.");
                    until LaborAllocApp.Next = 0;

                WriteAllocationEntries(NewResourceNo, NewStartingDateTime, NewQtyToAllocate,
                                     LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                     LaborAllocEntry."Source ID", 0, 0, DoReplan, LaborAllocEntry.Status, false, false);

                if ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."handle linked entries"::No then
                    JoinAllocationEntries(NewResourceNo, NewStartingDateTime);
            end;
        end;
    end;


    procedure SelectAllocationEntry(EntryNo: Integer)
    begin
        SingleInstanceMgt.SetCurrAllocation(EntryNo);
    end;


    procedure DeleteAllocationEntry(var LaborAllocEntry: Record "Serv. Labor Allocation Entry"; var LaborAllocApp: Record "Serv. Labor Alloc. Application"; EntryNo: Integer; RunModeFlags: Integer)
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        ResourceNo: Code[20];
        SourceID: Code[20];
        SourceSubType: Option Qoute,"Order";
        StartingDateTime: Decimal;
        EndingDateTime: Decimal;
        HourQty: Decimal;
        ApplyToEntryNo: Integer;
        DoOneServiceMoving: Boolean;
        isNeedCheck: Boolean;
        isNeedChangeLineStatus: Boolean;
        isGoingToAct: Boolean;
        isGoingToReplan: Boolean;
        isGoingToJoin: Boolean;
    begin
        // RunModeFlags = 11111, THE first from left is isGoingToJoin
        ServiceScheduleSetup.Get;

        if not LaborAllocEntry.Get(EntryNo) then
            exit;
        isNeedCheck := (CutNextDigit(RunModeFlags) > 0);
        isNeedChangeLineStatus := (CutNextDigit(RunModeFlags) > 0);
        isGoingToAct := (CutNextDigit(RunModeFlags) > 0);
        isGoingToReplan := (CutNextDigit(RunModeFlags) > 0);
        isGoingToJoin := (CutNextDigit(RunModeFlags) > 0);

        if isNeedCheck then begin
            if not CheckUserRightsAdv(400, LaborAllocEntry) then exit;
        end;

        ResourceNo := LaborAllocEntry."Resource No.";
        StartingDateTime := LaborAllocEntry."Start Date-Time";
        EndingDateTime := LaborAllocEntry."End Date-Time";
        HourQty := LaborAllocEntry."Quantity (Hours)";
        SourceSubType := LaborAllocEntry."Source Subtype";
        SourceID := LaborAllocEntry."Source ID";

        //correct service line status >>
        if isNeedChangeLineStatus then
            ChangeServiceLineStatus(LaborAllocEntry."Entry No.", true);
        //correct service line status <<

        if isGoingToAct then begin
            ChangeApplyTo(EntryNo, LaborAllocEntry."Applies-to Entry No.");
            LaborAllocEntry.Delete(true);
        end;

        if isGoingToReplan then
            ReplanEntries(ResourceNo, EndingDateTime, -HourQty, ServiceScheduleSetup."Replan Document", SourceSubType, SourceID);

        if isGoingToJoin then
            if ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."handle linked entries"::No then
                JoinAllocationEntries(ResourceNo, StartingDateTime);
    end;


    procedure InsertAllocationEntry(var LaborAllocEntryPar: Record "Serv. Labor Allocation Entry"; var LaborAllocAppPar: Record "Serv. Labor Alloc. Application"; ResourceNo: Code[20]; StartingDateTime: Decimal; QtyToAllocate: Decimal; SourceType: Option ,"Service Document","Standard Event"; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]; ApplyToEntry: Integer; DoChangeServLineResource: Boolean; TravelPar: Boolean)
    var
        ServiceLine1: Record "Service Line EDMS";
        LaborAllocApp1: Record "Serv. Labor Alloc. Application";
        ServiceHeader: Record "Service Header EDMS";
        RetStartDateTime: Decimal;
        EntryNo: Integer;
        LineNo: Integer;
        SingleInstanceManagment: Codeunit SingleInstanceManagement;
    begin
        ServiceScheduleSetup.Get;

        //LaborAllocEntry.RESET;
        //IF LaborAllocEntry.FINDLAST THEN
        //EntryNo := LaborAllocEntry."Entry No.";
        LaborAllocEntry.Reset;
        if LaborAllocEntry.FindLast then
            EntryNo := LaborAllocEntry."Entry No.";
        if LaborAllocEntryPar.FindLast then
            if LaborAllocEntryPar."Entry No." > EntryNo then
                EntryNo := LaborAllocEntryPar."Entry No.";

        EntryNo += 1;

        //12.12.2014 EB.P8 >>
        LaborAllocEntryPar.Init;
        LaborAllocEntryPar."Entry No." := EntryNo;
        LaborAllocEntryPar."Source Type" := SourceType;
        LaborAllocEntryPar."Source Subtype" := SourceSubType;
        LaborAllocEntryPar."Source ID" := SourceID;
        LaborAllocEntryPar."Start Date-Time" := StartingDateTime;
        LaborAllocEntryPar."End Date-Time" := StartingDateTime + QtyToAllocate * 3.6;
        LaborAllocEntryPar."Quantity (Hours)" := QtyToAllocate;
        LaborAllocEntryPar."Resource No." := ResourceNo;
        LaborAllocEntryPar."User ID" := SingleInstanceManagment.GetCurrentUserId;
        LaborAllocEntryPar.Travel := TravelPar;
        LaborAllocEntryPar.Validate("Applies-to Entry No.", ApplyToEntry);  //14.03.2014 Elva Baltic P8 #S0003 MMG7.00
        case SourceType of
            Sourcetype::"Standard Event":
                LaborAllocEntryPar."Planning Policy" := ServiceScheduleSetup."Planning Policy";
            Sourcetype::"Service Document":
                begin
                    if LaborAllocEntryPar."Source Subtype" = LaborAllocEntryPar."source subtype"::Order then begin
                        ServiceHeader.Get(ServiceHeader."document type"::Order, SourceID);
                        LaborAllocEntryPar."Planning Policy" := ServiceHeader."Planning Policy";
                    end;
                    if LaborAllocEntryPar."Source Subtype" = LaborAllocEntryPar."source subtype"::Quote then begin
                        ServiceHeader.Get(ServiceHeader."document type"::Quote, SourceID);
                        LaborAllocEntryPar."Planning Policy" := ServiceHeader."Planning Policy";
                    end;
                end;
        end;
        LaborAllocEntryPar.Insert;
        //LaborAllocEntryPar := LaborAllocEntry;
        //IF NOT LaborAllocEntryPar.INSERT THEN;  //IT catch situations when LaborAllocEntryPar is temporaral Record
        //12.12.2014 EB.P8 <<

        if (SourceType = Sourcetype::"Service Document") then
            if DoChangeServLineResource then begin  //09.07.2013 EDMS P8
                if ServiceLine.FindFirst and (ApplyToEntry = 0) then begin  //17.04.2008. EDMS P2
                    repeat
                        LineNo := ServiceLine."Line No.";
                        if DoServiceSpliting then
                            LineNo := SplitServiceLine(ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."Line No.");

                        ControlLaborSequence(ServiceLine."Document Type", ServiceLine."Document No.", LineNo, StartingDateTime);
                        ControlSkills(ServiceLine."Document Type", ServiceLine."Document No.", LineNo, ResourceNo);

                        InsertAllocApplication(LaborAllocAppPar, EntryNo, ServiceLine."Document Type", ServiceLine."Document No.",
                                               LineNo, ResourceNo, DoChangeServLineResource, TravelPar);
                    until ServiceLine.Next = 0;
                    DoServiceSpliting := false;
                    ServiceLine.Reset;
                    ServiceLine.DeleteAll;
                end else begin
                    LaborAllocApp1.Reset;
                    LaborAllocApp1.SetRange("Allocation Entry No.", LaborAllocEntryPar."Applies-to Entry No.");
                    if LaborAllocApp1.FindFirst then
                        repeat
                            LineNo := LaborAllocApp1."Document Line No.";

                            ControlLaborSequence(LaborAllocApp1."Document Type", LaborAllocApp1."Document No.", LineNo, StartingDateTime);
                            ControlSkills(LaborAllocApp1."Document Type", LaborAllocApp1."Document No.", LineNo, ResourceNo);

                            InsertAllocApplication(LaborAllocAppPar, EntryNo, LaborAllocApp1."Document Type", LaborAllocApp1."Document No.",
                                                   LineNo, ResourceNo, DoChangeServLineResource, TravelPar);
                        until LaborAllocApp1.Next = 0;
                end;
            end else begin  //09.04.2013 EDMS P8
                            //09.07.2013 EDMS P8 >>
                if ServiceLine.FindFirst and (ApplyToEntry = 0) then begin
                    repeat
                        LineNo := ServiceLine."Line No.";
                        if DoServiceSpliting then
                            LineNo := SplitServiceLine(ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."Line No.");

                        ControlLaborSequence(ServiceLine."Document Type", ServiceLine."Document No.", LineNo, StartingDateTime);
                        ControlSkills(ServiceLine."Document Type", ServiceLine."Document No.", LineNo, ResourceNo);

                        InsertAllocApplication(LaborAllocAppPar, EntryNo, ServiceLine."Document Type", ServiceLine."Document No.",
                                               LineNo, ResourceNo, DoChangeServLineResource, TravelPar);
                    until ServiceLine.Next = 0;
                    DoServiceSpliting := false;
                    ServiceLine.Reset;
                    ServiceLine.DeleteAll;
                end else begin
                    //20.07.2013 EDMS P8 >>
                    if ApplyToEntry = 0 then begin
                        //InsertAllocApplication(LaborAllocApp, EntryNo, ServiceLine."Document Type", ServiceLine."Document No.",
                        //                 LineNo, ResourceNo, DoChangeServLineResource);
                        InsertAllocApplication(LaborAllocAppPar, EntryNo, SourceSubType, SourceID,
                                         LineNo, ResourceNo, DoChangeServLineResource, TravelPar);
                    end else begin
                        LaborAllocApp1.Reset;
                        LaborAllocApp1.SetRange("Allocation Entry No.", LaborAllocEntryPar."Applies-to Entry No.");
                        if LaborAllocApp1.FindFirst then
                            repeat
                                LineNo := LaborAllocApp1."Document Line No.";

                                ControlLaborSequence(LaborAllocApp1."Document Type", LaborAllocApp1."Document No.", LineNo, StartingDateTime);
                                ControlSkills(LaborAllocApp1."Document Type", LaborAllocApp1."Document No.", LineNo, ResourceNo);

                                InsertAllocApplication(LaborAllocAppPar, EntryNo, LaborAllocApp1."Document Type", LaborAllocApp1."Document No.",
                                                       LineNo, ResourceNo, DoChangeServLineResource, TravelPar);
                            until LaborAllocApp1.Next = 0;
                    end;
                    //20.07.2013 EDMS P8 <<

                end;
                //09.07.2013 EDMS P8 <<
            end;
    end;


    procedure ModifyAllocationEntry(var LaborAllocEntry: Record "Serv. Labor Allocation Entry"; var LaborAllocApp: Record "Serv. Labor Alloc. Application"; EntryNo: Integer; NewResourceNo: Code[20]; NewStartingDateTime: Decimal; NewQtyToAllocate: Decimal; DoChangeServLineResource: Boolean; Status: Integer; AppliesToEntryNo: Integer; Travel: Boolean)
    var
        LaborAllocAppLoc: Record "Serv. Labor Alloc. Application";
        OldResourceNo: Code[20];
    begin
        ServiceScheduleSetup.Get;
        LaborAllocEntry.Get(EntryNo);
        OldResourceNo := LaborAllocEntry."Resource No.";
        LaborAllocEntry."Resource No." := NewResourceNo;
        LaborAllocEntry."Start Date-Time" := NewStartingDateTime;
        LaborAllocEntry."End Date-Time" := NewStartingDateTime + NewQtyToAllocate * 3.6;
        LaborAllocEntry."Quantity (Hours)" := NewQtyToAllocate;
        LaborAllocEntry.Travel := Travel;
        if AppliesToEntryNo > 0 then  //10.12.2013 EDMS P8
            LaborAllocEntry.Validate("Applies-to Entry No.", AppliesToEntryNo);  //14.03.2014 Elva Baltic P8 #S0003 MMG7.00
        if Status >= 0 then
            LaborAllocEntry.Status := Status;
        LaborAllocEntry.Modify;


        if (ServiceScheduleSetup."Control Labor Sequence") or
           (ServiceScheduleSetup."Control Skills" <> ServiceScheduleSetup."control skills"::No)
        then begin
            LaborAllocAppLoc.Reset;
            LaborAllocAppLoc.SetRange("Allocation Entry No.", EntryNo);
            if LaborAllocAppLoc.FindFirst then
                repeat
                    ControlLaborSequence(LaborAllocAppLoc."Document Type", LaborAllocAppLoc."Document No.", LaborAllocAppLoc."Document Line No.",
                                         NewStartingDateTime);
                    if OldResourceNo <> NewResourceNo then
                        ControlSkills(LaborAllocAppLoc."Document Type", LaborAllocAppLoc."Document No.", LaborAllocAppLoc."Document Line No.",
                                      NewResourceNo);
                until LaborAllocAppLoc.Next = 0;
        end;

        if LaborAllocEntry."Source Type" = LaborAllocEntry."source type"::"Service Document" then
            ModifyAllocApplication(LaborAllocApp, EntryNo, NewResourceNo, DoChangeServLineResource, Travel);
    end;


    procedure DeleteAllocApplication(var LaborAllocApp: Record "Serv. Labor Alloc. Application"; AllocationEntryNo: Integer)
    var
        LaborAllocAppLoc: Record "Serv. Labor Alloc. Application";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        DocumentNo: Code[20];
        LineNo: Integer;
        ResourceNo: Code[20];
    begin
        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Allocation Entry No.", AllocationEntryNo);
        if LaborAllocApp.FindFirst then
            repeat
                DocumentType := LaborAllocApp."Document Type";
                DocumentNo := LaborAllocApp."Document No.";
                ResourceNo := LaborAllocApp."Resource No.";
                LineNo := LaborAllocApp."Document Line No.";
                LaborAllocApp.Delete(true);

                LaborAllocAppLoc.Reset;
                LaborAllocAppLoc.SetRange("Document Type", DocumentType);
                LaborAllocAppLoc.SetRange("Document No.", DocumentNo);
                LaborAllocAppLoc.SetRange("Document Line No.", LineNo);
            //    IF NOT LaborAllocAppLoc.FINDFIRST THEN BEGIN  // P8
            //    IF LineNo = 0 THEN
            //    IF CONFIRM(Text145) THEN
            //    DocAllocAdjustDocLinesResource(DocumentType, DocumentNo, '');
            //END;

            until LaborAllocApp.Next = 0;
    end;


    procedure InsertAllocApplication(var LaborAllocApp: Record "Serv. Labor Alloc. Application"; AllocationEntry: Integer; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]; LineNo: Integer; ResourceNo: Code[20]; DoChangeServLineResource: Boolean; Travel: Boolean)
    var
        LaborAllocEntryLocal: Record "Serv. Labor Allocation Entry";
        EntryNo: Integer;
        IsTimeLine: Boolean;
        ResourceCost: Record Resource;
    begin
        IsTimeLine := false;
        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Allocation Entry No.", AllocationEntry);
        LaborAllocApp.SetRange("Time Line", true);
        if not LaborAllocApp.FindFirst then
            IsTimeLine := true;

        if not LaborAllocEntryLocal.Get(AllocationEntry) then exit;  //28.06.2013 EDMS P8

        LaborAllocApp.Reset;
        if LaborAllocApp.FindLast then
            EntryNo := LaborAllocApp."Allocation Entry No.";

        EntryNo += 1;
        LaborAllocApp.Init;
        LaborAllocApp."Allocation Entry No." := AllocationEntry;
        LaborAllocApp."Document Type" := DocumentType;
        LaborAllocApp."Document No." := DocumentNo;
        LaborAllocApp."Document Line No." := LineNo;
        LaborAllocApp."Resource No." := ResourceNo;
        LaborAllocApp.Travel := Travel;
        if IsTimeLine then begin
            LaborAllocApp."Time Line" := IsTimeLine;
            LaborAllocApp."Remaining Quantity (Hours)" := LaborAllocEntryLocal."Quantity (Hours)";
        end;
        if ResourceCost.Get(ResourceNo) then                                        //12.05.2015 EB.P30 #T030
            LaborAllocApp.Validate("Unit Cost", ResourceCost."Unit Cost");            //12.05.2015 EB.P30 #T030
        LaborAllocApp.Insert(true);

        if DoChangeServLineResource then begin
            DocAllocAdjustDocLinesResource(DocumentType, DocumentNo, ResourceNo);  // P8
        end;
    end;


    procedure ModifyAllocApplication(var LaborAllocApp: Record "Serv. Labor Alloc. Application"; EntryNo: Integer; ResourceNo: Code[20]; DoChangeServLineResource: Boolean; Travel: Boolean)
    var
        LaborAllocEntryLocal: Record "Serv. Labor Allocation Entry";
        ResourceCost: Record Resource;
        IsResourceChanged: Boolean;
        TotalTimeSpent: Decimal;
    begin
        LaborAllocEntryLocal.Get(EntryNo);
        LaborAllocEntryLocal.CalcFields("Total Time Spent", "Total Time Spent Travel");
        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Allocation Entry No.", EntryNo);
        if LaborAllocApp.FindFirst then
            repeat
                //12.05.2015 EB.P30 #T030 >>
                IsResourceChanged := false;
                if LaborAllocApp."Resource No." <> ResourceNo then
                    IsResourceChanged := true;
                //12.05.2015 EB.P30 #T030 <<
                LaborAllocApp."Resource No." := ResourceNo;
                LaborAllocApp.Travel := Travel;
                if Travel then
                    TotalTimeSpent := LaborAllocEntryLocal."Total Time Spent Travel"
                else
                    TotalTimeSpent := LaborAllocEntryLocal."Total Time Spent";

                LaborAllocApp.Validate("Finished Quantity (Hours)", TotalTimeSpent);
                //LaborAllocApp.Validate("Remaining Quantity (Hours)", LaborAllocEntryLocal."Quantity (Hours)" - TotalTimeSpent);
                IF LaborAllocEntryLocal.Status = LaborAllocEntryLocal.Status::Finished THEN
                    LaborAllocApp.VALIDATE("Remaining Quantity (Hours)", 0)
                ELSE
                    LaborAllocApp.VALIDATE("Remaining Quantity (Hours)", LaborAllocEntryLocal."Quantity (Hours)" - TotalTimeSpent);


                //12.05.2015 EB.P30 #T030 >>
                if IsResourceChanged then begin
                    if ResourceCost.Get(ResourceNo) then
                        LaborAllocApp.Validate("Unit Cost", ResourceCost."Unit Cost");
                end;
                //12.05.2015 EB.P30 #T030
                LaborAllocApp.Modify;
                if DoChangeServLineResource then begin
                    DocAllocAdjustDocLinesResource(LaborAllocApp."Document Type", LaborAllocApp."Document No.", ResourceNo);  // P8
                end;
            until LaborAllocApp.Next = 0;
    end;


    procedure IsTimeAvailable(var ServLaborAlloc: Record "Serv. Labor Allocation Entry"; ResourceNo: Code[20]; CurrentDay: Date; ModifyEntryNo: Integer): Boolean
    var
        ServiceHour: Record "Service Hour EDMS";
        ResourceCalendarChange: Record "Resource Calendar Change";
        ServLaborAlloc2: Record "Serv. Labor Allocation Entry";
        LaborAllocApp: Record "Serv. Labor Alloc. Application" temporary;
        ResourceLoc: Record Resource;
        CheckDescription: Text[50];
        Starting: Decimal;
        Finishing: Decimal;
        QtyToAllocate: Decimal;
        EntryNo: Integer;
        HourEntry: Integer;
        WhichEntry: Integer;
        PeriodStart: Time;
        OwnWorkTime: Boolean;
        DoChangeServLineResource: Boolean;
    begin
        //EDMS P2
        ServiceScheduleSetup.Get;
        DoChangeServLineResource := false;
        //check for busy time in Base Calendar and in Resource Calendar Change >>
        OwnWorkTime := false;
        if ResourceCalendarChange.Get(ResourceNo, CurrentDay) then begin
            if ResourceCalendarChange."Change Type" = ResourceCalendarChange."change type"::Nonworking then
                exit(false)
            else begin
                if not (ResourceCalendarChange."Starting Time" = 000000T) then begin
                    QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, 000000T),
                                                        DateTimeMgt.Datetime(CurrentDay, ResourceCalendarChange."Starting Time"));
                    InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, 000000T), QtyToAllocate,
                                          0, 0, 'Err1', 0, DoChangeServLineResource, false);
                    OwnWorkTime := true;
                end else begin
                    InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, 000000T), 0,
                                          0, 0, 'Err1', 0, DoChangeServLineResource, false);
                    OwnWorkTime := true;
                end;


                if not (ResourceCalendarChange."Ending Time" > 235959T) then begin
                    QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, ResourceCalendarChange."Ending Time"),
                                                        DateTimeMgt.Datetime(CurrentDay, 235959.999T));
                    InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo,
                                          DateTimeMgt.Datetime(CurrentDay, ResourceCalendarChange."Ending Time"), QtyToAllocate, 0, 0, 'Err2', 0,
                                          DoChangeServLineResource, false);
                    OwnWorkTime := true;
                end else begin
                    InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo,
                                          DateTimeMgt.Datetime(CurrentDay, ResourceCalendarChange."Ending Time"), 0, 0, 0, 'Err2', 0,
                                          DoChangeServLineResource, false);
                    OwnWorkTime := true;
                end;
            end;
        end;

        //write busy time from Service Hour EDMS >>
        if not OwnWorkTime then begin
            ServiceHour.Reset;
            //AB >>
            //ResourceLoc.GET(ResourceNo);
            if ResourceLoc.Get(ResourceNo) then begin
                ServiceHour.SetRange("Service Work Group Code", ResourceLoc."Service Work Group Code");
                ServiceHour.SetFilter("Starting Date", '''''|<=%1', CurrentDay);
                ServiceHour.SetFilter("Ending Date", '''''|>=%1', CurrentDay);
                ServiceHour.SetRange(Day, Date2dwy(CurrentDay, 1) - 1);
                //21.02.2010 EDMSB P2 >>
                HourEntry := ServiceHour.Count;
                if ServiceHour.FindFirst then begin
                    PeriodStart := 000000T;
                    repeat
                        WhichEntry += 1;
                        if not (ServiceHour."Starting Time" = PeriodStart) then begin
                            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, PeriodStart),
                                                                DateTimeMgt.Datetime(CurrentDay, ServiceHour."Starting Time"));
                            InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, PeriodStart),
                                                  QtyToAllocate, 0, 0, 'Err4', 0, DoChangeServLineResource, false);
                        end else begin
                            InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, PeriodStart), 0,
                                                  0, 0, 'Err4', 0, DoChangeServLineResource, false);
                        end;
                        PeriodStart := ServiceHour."Ending Time";
                        if HourEntry = WhichEntry then begin
                            if not (ServiceHour."Ending Time" > 235959T) then begin
                                QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, ServiceHour."Ending Time"),
                                                                    DateTimeMgt.Datetime(CurrentDay, 235959.999T));
                                InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo,
                                                      DateTimeMgt.Datetime(CurrentDay, ServiceHour."Ending Time"), QtyToAllocate, 0, 0, 'Err5', 0,
                                                      DoChangeServLineResource, false);
                            end else begin
                                InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo,
                                                      DateTimeMgt.Datetime(CurrentDay, ServiceHour."Ending Time"), 0, 0, 0, 'Err5', 0,
                                                      DoChangeServLineResource, false);
                            end;
                        end;
                    until ServiceHour.Next = 0;
                end else
                    exit(false)
                //21.02.2010 EDMSB P2 <<
            end;
            //AB <<
        end;
        // <<
        exit(true);
    end;


    procedure GetTimeAvailable(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal): Boolean
    var
        ServiceHour: Record "Service Hour EDMS";
        ResourceCalendarChange: Record "Resource Calendar Change";
        ResourceLoc: Record Resource;
        CurrentDay: Date;
    begin
        CurrentDay := DateTimeMgt.Datetime2Date(StartingDateTime);

        if ResourceCalendarChange.Get(ResourceNo, CurrentDay) then begin
            if ResourceCalendarChange."Change Type" = ResourceCalendarChange."change type"::Nonworking then
                exit(false)
            else begin
                if (DateTimeMgt.Datetime2Time(StartingDateTime) <= ResourceCalendarChange."Ending Time") and
                   (DateTimeMgt.Datetime2Time(EndingDateTime) >= ResourceCalendarChange."Starting Time")
                then
                    exit(true)
                else
                    exit(false)
            end;
        end;

        ServiceHour.Reset;
        ServiceHour.SetRange("Service Work Group Code", ResourceLoc."Service Work Group Code");
        ServiceHour.SetFilter("Starting Date", '''''|<=%1', CurrentDay);
        ServiceHour.SetFilter("Ending Date", '''''|>=%1', CurrentDay);
        ServiceHour.SetRange(Day, Date2dwy(CurrentDay, 1) - 1);
        //18.01.2012 EDMS P8 >>
        if ServiceHour.FindFirst then begin
            repeat
                if (DateTimeMgt.Datetime2Time(StartingDateTime) <= ServiceHour."Ending Time") and
                   (DateTimeMgt.Datetime2Time(EndingDateTime) >= ServiceHour."Starting Time")
                then
                    exit(true);
            until ServiceHour.Next = 0;
            exit(false);
            //18.01.2012 EDMS P8 <<
        end;

        exit(false);
    end;


    procedure IsStarttimeAvailable(var ServLaborAllocPar: Record "Serv. Labor Allocation Entry"; ResourceNo: Code[20]; CurrentDay: Date; StartTime: Time)
    var
        QtyToAllocate: Decimal;
    begin
        //busy time from date start till starttime >>
        if not (StartTime = 000000T) then begin
            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, 000000T),
                                               DateTimeMgt.Datetime(CurrentDay, StartTime));
            InsertAllocationEntry(ServLaborAllocPar, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, 000000T), QtyToAllocate,
                                  0, 0, 'Err3', 0, false, false);  //12.12.2014 EB.P8
        end;
        // <<
    end;


    procedure IsStarttimeAvailableBackward(var ServLaborAlloc: Record "Serv. Labor Allocation Entry"; ResourceNo: Code[20]; CurrentDay: Date; StartTime: Time)
    var
        QtyToAllocate: Decimal;
    begin
        //busy time from date start till starttime >>
        if not (StartTime = 000000T) then begin
            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, StartTime),
                                                DateTimeMgt.Datetime(CurrentDay, 235959.999T));
            InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, StartTime), QtyToAllocate,
                                  0, 0, 'Err3', 0, false, false);
        end;
        // <<
    end;


    procedure WriteAllocationEntries(ResourceNo: Code[20]; StartingDateTime: Decimal; QtyToAllocate: Decimal; SourceType: Option "Service Document",,"Standard Event"; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]; FunctionMode: Option Insert,Modify; ModifyEntryNo: Integer; DoReplan: Boolean; Status: Integer; FirstRowMustTakeFromModify: Boolean; Travel: Boolean)
    var
        ServLaborAlloc: Record "Serv. Labor Allocation Entry";
        ServLaborAllocTemp: Record "Serv. Labor Allocation Entry" temporary;
        ServiceHour: Record "Service Hour EDMS";
        RepairStatus: Record "Service Work Status EDMS";
        CurrentDay: Date;
        StartTime: Time;
        RetStartDateTime: Decimal;
        ReplanHours: Decimal;
        QtyToAllocate2: Decimal;
        ApplyToEntry: Integer;
        FirstEntry: Boolean;
        DoChangeServLineResource: Boolean;
        ChangeAllocationStatusLocal: Boolean;
        DoOneServiceMoving: Boolean;
        Allocations: Page "Serv. Labor Allocation Entries";
    begin
        ServiceScheduleSetup.Get;
        CurrentDay := DateTimeMgt.Datetime2Date(StartingDateTime);
        StartTime := DateTimeMgt.Datetime2Time(StartingDateTime);

        ChangeAllocationStatusLocal := ChangeAllocationStatus;
        ChangeAllocationStatus := false;
        QtyToAllocate2 := QtyToAllocate;
        AllocationStatus := Status;  //20.07.2013 EDMS P8

        ReturnAvailableTimes(ServLaborAllocTemp, QtyToAllocate, ResourceNo, CurrentDay, StartTime, ModifyEntryNo);

        DoChangeServLineResource := false;  //09.04.2013 EDMS P8
        //DoChangeServLineResource := TRUE;
        FirstEntry := true;
        ApplyToEntry := ModifyEntryNo;
        ServLaborAllocTemp.Reset;

        //MESSAGE('AllocationStatus:'+FORMAT(AllocationStatus)+' AllocationStatusAction: '+FORMAT(AllocationStatusAction)+' ScheduleAction: '+FORMAT(ScheduleAction));

        if ServLaborAllocTemp.FindFirst then
            repeat
                //MESSAGE('msg in writeAlloc, 1');
                if FirstEntry and (FunctionMode = Functionmode::Modify) then begin
                    if ServLaborAlloc.Get(ModifyEntryNo) then;
                    if LaborAllocEntry.Get(ModifyEntryNo) then;
                    if DoReplan then begin
                        ReplanHours := CheckForTime(ResourceNo, ServLaborAllocTemp."Start Date-Time",
                                                    ServLaborAllocTemp."End Date-Time", ModifyEntryNo, ServiceScheduleSetup."Replan Document",
                                                    SourceSubType, SourceID);
                        if ReplanHours > 0 then
                            ReplanEntries(ResourceNo, ServLaborAllocTemp."Start Date-Time", ReplanHours, ServiceScheduleSetup."Replan Document",
                                         SourceSubType, SourceID)
                        else begin
                            ReplanHours := CalculateReplanHours(QtyToAllocate2, ServLaborAlloc."Quantity (Hours)",
                                                                ServLaborAllocTemp."Start Date-Time", ServLaborAlloc."Start Date-Time",
                                                                ServLaborAllocTemp."Resource No.");
                            if ReplanHours <> 0 then
                                ReplanEntries(ResourceNo, ServLaborAlloc."End Date-Time", ReplanHours, ServiceScheduleSetup."Replan Document",
                                              SourceSubType, SourceID);
                        end;
                    end;
                    ModifyAllocationEntry(LaborAllocEntry, LaborAllocApp, ModifyEntryNo, ServLaborAllocTemp."Resource No.",
                                          ServLaborAllocTemp."Start Date-Time", ServLaborAllocTemp."Quantity (Hours)",
                                          DoChangeServLineResource, Status, ServLaborAllocTemp."Applies-to Entry No.", Travel);
                end else begin
                    if (not FirstEntry) then begin
                        if (ServiceScheduleSetup."Min. Notability (Hours)" > ServLaborAllocTemp."Quantity (Hours)") then
                            exit;
                        if GuiAllowed then begin // 11.12.2018 EB.P7
                            if not Confirm(StrSubstNo(Text127, CurrentDay, ServLaborAllocTemp."Quantity (Hours)")) then
                                exit; //Task: 004 25.09.2018 EB.P7
                        end;
                        //EXIT;
                    end;

                    if not DoReplan then begin
                        ReplanHours := CheckForTime(ResourceNo, ServLaborAllocTemp."Start Date-Time",
                                                    ServLaborAllocTemp."End Date-Time", 0, ServiceScheduleSetup."Replan Document",
                                                    SourceSubType, SourceID);
                        if ReplanHours > 0 then
                            ReplanEntries(ResourceNo, ServLaborAllocTemp."Start Date-Time", ReplanHours, ServiceScheduleSetup."Replan Document",
                                          SourceSubType, SourceID);
                    end;
                    //lll
                    if FirstEntry then begin
                        if FirstRowMustTakeFromModify then
                            ApplyToEntry := ModifyEntryNo
                        else
                            ApplyToEntry := 0
                    end else
                        if ApplyToEntry = 0 then  //20.07.2013 EDMS P8
                            ApplyToEntry := ModifyEntryNo;

                    // THERE COULD BE FOR ONE ALLOCATION both applications: document and lines
                    InsertAllocationEntry(LaborAllocEntry, LaborAllocApp, ServLaborAllocTemp."Resource No.",
                                          ServLaborAllocTemp."Start Date-Time", ServLaborAllocTemp."Quantity (Hours)",
                                          SourceType, SourceSubType, SourceID, ApplyToEntry, DoChangeServLineResource, Travel);

                end;

                if ApplyToEntry <> 0 then
                    ChangeApplyTo(ApplyToEntry, LaborAllocEntry."Entry No.");

                //Update Forced status.
                AllocationStatus := Status;
                ChangeStatus(LaborAllocEntry);

                ChangeServiceLineStatus(LaborAllocEntry."Entry No.", false);

                FirstEntry := false;
                ApplyToEntry := LaborAllocEntry."Entry No.";
            until ServLaborAllocTemp.Next = 0;
    end;


    procedure CalculateReplanHours(NewQty: Decimal; OldQty: Decimal; NewStartDateTime: Decimal; OldStartDateTime: Decimal; ResourceNo: Code[20]): Decimal
    var
        ReplanHours: Decimal;
    begin
        ReplanHours := 0;
        ReplanHours := NewQty - OldQty;
        if NewStartDateTime <> OldStartDateTime then
            ReplanHours += CalcWorkHourDifference(ResourceNo, OldStartDateTime, NewStartDateTime);

        exit(ReplanHours)
    end;


    procedure WriteAllocationEntryEnd(EntryNo: Integer; EndingDateTime: Decimal; DoReplan: Boolean; ReasonCode: Code[10]; Travel: Boolean)
    var
        ReplanHours: Decimal;
        DoOneServiceMoving: Boolean;
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
    begin
        ServiceScheduleSetup.Get;
        LaborAllocEntry.Get(EntryNo);

        if DoReplan then begin
            ReplanHours := CheckForTime(LaborAllocEntry."Resource No.", LaborAllocEntry."Start Date-Time",
                                        EndingDateTime, EntryNo, ServiceScheduleSetup."Replan Document",
                                        LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID");
            if ReplanHours > 0 then
                ReplanEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."End Date-Time", ReplanHours,
                              ServiceScheduleSetup."Replan Document", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID")
            else begin
                ReplanHours := CalcHourDifference(LaborAllocEntry."Start Date-Time", EndingDateTime) - LaborAllocEntry."Quantity (Hours)";
                if ReplanHours < 0 then
                    ReplanEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."End Date-Time", ReplanHours,
                                  ServiceScheduleSetup."Replan Document", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID")
            end;
        end;

        LaborAllocEntry.Get(EntryNo);
        ChangeStatus(LaborAllocEntry);
        ModifyAllocationEntry(LaborAllocEntry, LaborAllocApp, LaborAllocEntry."Entry No.", LaborAllocEntry."Resource No.",
                              LaborAllocEntry."Start Date-Time",
                              CalcHourDifference(LaborAllocEntry."Start Date-Time", EndingDateTime),
                              false, -1, LaborAllocEntry."Applies-to Entry No.", Travel);

        //if ReasonCode <> '' then
        ModifyReason(LaborAllocEntry, ReasonCode);

        ChangeServiceLineStatus(LaborAllocEntry."Entry No.", false);

        SynchroniseRelatedEntries(LaborAllocEntry."Entry No.");
    end;


    procedure ReturnAvailableTimes(var ServLaborAllocTemp: Record "Serv. Labor Allocation Entry"; var QtyToAllocate: Decimal; ResourceNo: Code[20]; CurrentDay: Date; StartTime: Time; ModifyEntryNo: Integer)
    var
        ServLaborAllocTemp2: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocAppTemp: Record "Serv. Labor Alloc. Application" temporary;
        LastTime: Decimal;
        AllocateCurrentQty: Decimal;
        AllocateStartDateTime: Decimal;
        DayQty: Integer;
        DoChangeServLineResource: Boolean;
    begin
        ServiceScheduleSetup.Get;
        //IF ServiceScheduleSetup."Disable Unavail. Time Control" THEN BEGIN
        InsertAllocationEntry(ServLaborAllocTemp, LaborAllocAppTemp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, StartTime), QtyToAllocate,
                                        0, 0, 'Err6', 0, DoChangeServLineResource, false);
        exit;
        //END;
        /*
        DayQty := 0;
        DoChangeServLineResource := FALSE;
        REPEAT
          IF IsTimeAvailable(ServLaborAllocTemp2, ResourceNo, CurrentDay, ModifyEntryNo) THEN BEGIN
            IsStarttimeAvailable(ServLaborAllocTemp2, ResourceNo, CurrentDay, StartTime);
            ServLaborAllocTemp2.RESET;
            ServLaborAllocTemp2.SETCURRENTKEY("Resource No.", "Start Date-Time");
            LastTime := 0;
        
            IF ServLaborAllocTemp2.FINDFIRST THEN
              REPEAT
                IF (LastTime <> 0) AND (LastTime < ServLaborAllocTemp2."Start Date-Time") AND (QtyToAllocate > 0) THEN BEGIN
                  IF QtyToAllocate > CalcHourDifference(LastTime, ServLaborAllocTemp2."Start Date-Time") THEN
                    AllocateCurrentQty := CalcHourDifference(LastTime, ServLaborAllocTemp2."Start Date-Time")
                  ELSE
                    AllocateCurrentQty := QtyToAllocate;
        
                  AllocateStartDateTime := LastTime;
                  InsertAllocationEntry(ServLaborAllocTemp, LaborAllocAppTemp, ResourceNo, AllocateStartDateTime, AllocateCurrentQty,
                                        0, 0, 'Err6', 0, DoChangeServLineResource,FALSE);
                  QtyToAllocate -= AllocateCurrentQty;
                END;
        
                ServLaborAllocTemp2.SETFILTER("End Date-Time", '>%1', ServLaborAllocTemp2."End Date-Time");
                LastTime := ServLaborAllocTemp2."End Date-Time";
              UNTIL ServLaborAllocTemp2.NEXT = 0;
            END;
        
            ServLaborAllocTemp2.RESET;
            ServLaborAllocTemp2.DELETEALL;
            CurrentDay := CurrentDay + 1;
            StartTime := 000000T;
            DayQty += 1;
            QtyToAllocate := ROUND(QtyToAllocate, 0.00001);
        UNTIL (QtyToAllocate <= 0)  OR (DayQty > 1000);  //12.12.2014 EB.P8
        
        IF DayQty > 1000 THEN
          MESSAGE(Text102);
        */

    end;


    procedure ReturnAvailableTimesBackward(var ServLaborAllocTemp: Record "Serv. Labor Allocation Entry" temporary; var QtyToAllocate: Decimal; ResourceNo: Code[20]; CurrentDay: Date; StartTime: Time; ModifyEntryNo: Integer)
    var
        ServLaborAllocTemp2: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocAppTemp: Record "Serv. Labor Alloc. Application" temporary;
        LastTime: Decimal;
        AllocateCurrentQty: Decimal;
        AllocateStartDateTime: Decimal;
        DayQty: Integer;
        DoChangeServLineResource: Boolean;
    begin
        DayQty := 0;
        DoChangeServLineResource := false;
        repeat
            if IsTimeAvailable(ServLaborAllocTemp2, ResourceNo, CurrentDay, ModifyEntryNo) then begin
                IsStarttimeAvailableBackward(ServLaborAllocTemp2, ResourceNo, CurrentDay, StartTime);
                ServLaborAllocTemp2.Reset;
                ServLaborAllocTemp2.SetCurrentkey("Resource No.", "End Date-Time");
                LastTime := 0;

                if ServLaborAllocTemp2.FindLast then
                    repeat
                        if (LastTime <> 0) and (LastTime > ServLaborAllocTemp2."End Date-Time") and (QtyToAllocate > 0) then begin
                            if QtyToAllocate > CalcHourDifference(ServLaborAllocTemp2."End Date-Time", LastTime) then begin
                                AllocateCurrentQty := CalcHourDifference(ServLaborAllocTemp2."End Date-Time", LastTime);
                                AllocateStartDateTime := ServLaborAllocTemp2."End Date-Time";
                            end else begin
                                AllocateCurrentQty := QtyToAllocate;
                                AllocateStartDateTime := LastTime - QtyToAllocate * 3.6;
                            end;

                            InsertAllocationEntry(ServLaborAllocTemp, LaborAllocAppTemp, ResourceNo, AllocateStartDateTime, AllocateCurrentQty,
                                                  0, 0, 'Err7', 0, DoChangeServLineResource, false);
                            QtyToAllocate -= AllocateCurrentQty;
                        end;

                        LastTime := ServLaborAllocTemp2."Start Date-Time";
                        ServLaborAllocTemp2.SetFilter("Start Date-Time", '<%1', ServLaborAllocTemp2."Start Date-Time");
                    until ServLaborAllocTemp2.Next(-1) = 0;
            end;

            ServLaborAllocTemp2.Reset;
            ServLaborAllocTemp2.DeleteAll;
            CurrentDay := CurrentDay - 1;
            StartTime := 000000T;
            DayQty += 1;
        until (QtyToAllocate <= 0) or (DayQty > 1000);  //12.12.2014 EB.P8

        if DayQty > 1000 then
            Message(Text102);
    end;


    procedure CalcHourDifference(StartDateTime: Decimal; EndDateTime: Decimal): Decimal
    begin
        //Returns difference in hours
        exit((EndDateTime - StartDateTime) / 3.6);
    end;


    procedure ChangeApplyTo(ChangeFromEntry: Integer; ChangeToEntry: Integer)
    var
        ServLaborAlloc: Record "Serv. Labor Allocation Entry";
    begin
        ServLaborAlloc.Reset;
        ServLaborAlloc.SetCurrentkey("Applies-to Entry No.");
        ServLaborAlloc.SetRange("Applies-to Entry No.", ChangeFromEntry);
        ServLaborAlloc.SetFilter("Entry No.", '<>%1', ChangeToEntry);
        if ServLaborAlloc.FindFirst then
            repeat
                ServLaborAlloc.Validate("Applies-to Entry No.", ChangeToEntry);  //14.03.2014 Elva Baltic P8 #S0003 MMG7.00
                ServLaborAlloc.Modify;
            until ServLaborAlloc.Next = 0;
    end;


    procedure SplitAllocTracking(EntryNo: Integer; Mode: Option Move,Delete): Boolean
    var
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        QuestionText: Text[200];
    begin
        ServiceScheduleSetup.Get;
        if ServiceScheduleSetup."Handle Linked Entries" = ServiceScheduleSetup."handle linked entries"::No then
            exit(false);

        if ServiceScheduleSetup."Handle Linked Entries" = ServiceScheduleSetup."handle linked entries"::Yes then
            exit(true);

        if Mode = Mode::Delete then
            QuestionText := Text100;

        if ServiceScheduleSetup."Handle Linked Entries" = ServiceScheduleSetup."handle linked entries"::Prompt then begin
            FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 1111);
            LaborAllocEntryTemp.Reset;
            if LaborAllocEntryTemp.Count > 1 then
                if Confirm(QuestionText) then
                    exit(true);
        end;

        exit(false);
    end;


    procedure FillServiceLine(var ServiceLine1: Record "Service Line EDMS")
    begin
        if ServiceLine1.FindFirst then
            repeat
                ServiceLine := ServiceLine1;
                if ServiceLine.Insert then;
            until ServiceLine1.Next = 0;
    end;


    procedure FillServiceLine2(var ServiceLineLoc: Record "Service Line EDMS"; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer)
    begin
        ServiceLineLoc."Document Type" := DocumentType;
        ServiceLineLoc."Document No." := DocumentNo;
        ServiceLineLoc."Line No." := LineNo;
        if ServiceLineLoc.Insert then;
    end;


    procedure CalculateTotalHours(EntryNo: Integer): Decimal
    var
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        TotalHours: Decimal;
    begin
        FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 1111);
        if LaborAllocEntryTemp.FindFirst then
            repeat
                TotalHours += LaborAllocEntryTemp."Quantity (Hours)";
            until LaborAllocEntryTemp.Next = 0;

        exit(TotalHours);
    end;


    procedure CalcLaborRemainHours(EntryNo: Integer): Decimal
    var
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        TotalHours: Decimal;
    begin
        FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 1111);
        LaborAllocEntryTemp.SetFilter(Status, '%1|%2', LaborAllocEntryTemp.Status::Pending, LaborAllocEntryTemp.Status::"On Hold");
        if LaborAllocEntryTemp.FindFirst then
            repeat
                TotalHours += LaborAllocEntryTemp."Quantity (Hours)";
            until LaborAllocEntryTemp.Next = 0;

        exit(TotalHours);
    end;


    procedure ReplanEntries(ResourceNo: Code[20]; StartingDateTime: Decimal; ChangeHours: Decimal; DoOneServiceMoving: Boolean; SourceSubType: Option Qoute,"Order"; SourceID: Code[20])
    var
        LaborAllocEntry2: Record "Serv. Labor Allocation Entry";
        LaborAllocApp2: Record "Serv. Labor Alloc. Application";
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocAppTemp: Record "Serv. Labor Alloc. Application" temporary;
        ServiceLineTemp: Record "Service Line EDMS" temporary;
        CurrentDay: Date;
        StartTime: Time;
        ApplyToEntry: Integer;
        NewStartingDateTime: Decimal;
        NewEndingDateTime: Decimal;
        OldEndingTime: Decimal;
        WorkHours: Decimal;
        DoReplan: Boolean;
    begin
        ServiceScheduleSetup.Get;
        OldEndingTime := 0;
        DoReplan := false;
        LaborAllocEntry2.Reset;
        LaborAllocEntry2.SetRange("Resource No.", ResourceNo);
        LaborAllocEntry2.SetFilter("Start Date-Time", '>=%1', StartingDateTime);
        LaborAllocEntry2.SetFilter(Status, '%1|%2', LaborAllocEntry2.Status::Pending, LaborAllocEntry2.Status::"On Hold");
        LaborAllocEntry2.SetRange("Planning Policy", LaborAllocEntry2."planning policy"::Queue);

        if LaborAllocEntry2.FindFirst then
            repeat
                LaborAllocEntryTemp := LaborAllocEntry2;
                LaborAllocEntryTemp.Insert;
            until LaborAllocEntry2.Next = 0;

        if DoOneServiceMoving then begin
            LaborAllocEntry2.SetRange("Planning Policy");
            LaborAllocEntry2.SetRange("Source Type", LaborAllocEntry2."source type"::"Service Document");
            LaborAllocEntry2.SetRange("Source Subtype", SourceSubType);
            LaborAllocEntry2.SetRange("Source ID", SourceID);
            if LaborAllocEntry2.FindFirst then
                repeat
                    LaborAllocEntryTemp := LaborAllocEntry2;
                    if LaborAllocEntryTemp.Insert then;
                until LaborAllocEntry2.Next = 0;
        end;

        LaborAllocEntryTemp.SetCurrentkey("Resource No.", "Start Date-Time");

        if LaborAllocEntryTemp.FindFirst then
            repeat
                if OldEndingTime <> 0 then begin
                    WorkHours := CalcWorkHourDifference(ResourceNo, OldEndingTime, LaborAllocEntryTemp."Start Date-Time");
                    if WorkHours <> 0 then
                        NewStartingDateTime := CalculateNewStartDateTime(ResourceNo, NewEndingDateTime, WorkHours)
                    else
                        NewStartingDateTime := NewEndingDateTime;
                end else begin
                    NewStartingDateTime := LaborAllocEntryTemp."Start Date-Time" + ChangeHours * 3.6;
                    if ChangeHours < 0 then begin
                        WorkHours := CalcWorkHourDifference(ResourceNo, StartingDateTime, LaborAllocEntryTemp."Start Date-Time");
                        NewStartingDateTime := StartingDateTime + (WorkHours + ChangeHours) * 3.6;
                    end;
                end;

                OldEndingTime := LaborAllocEntryTemp."End Date-Time";
                WriteAllocationEntries(ResourceNo, NewStartingDateTime, LaborAllocEntryTemp."Quantity (Hours)",
                                       LaborAllocEntryTemp."Source Type", LaborAllocEntryTemp."Source Subtype",
                                       LaborAllocEntryTemp."Source ID", 1, LaborAllocEntryTemp."Entry No.", DoReplan,
                                       LaborAllocEntryTemp.Status, false, false);
                NewEndingDateTime := LaborAllocEntry."End Date-Time";
            until LaborAllocEntryTemp.Next = 0;
    end;


    procedure CalcWorkHourDifference(ResourceNo: Code[20]; FromDateTime: Decimal; ToDateTime: Decimal): Decimal
    var
        ServLaborAllocTemp: Record "Serv. Labor Allocation Entry" temporary;
        ServLaborAllocTemp2: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocAppTemp: Record "Serv. Labor Alloc. Application" temporary;
        CurrentDay: Date;
        StartTime: Time;
        LastTime: Decimal;
        AllocateCurrentQty: Decimal;
        AllocateStartDateTime: Decimal;
        AllocateCurrentEndDateTime: Decimal;
        WorkHours: Decimal;
        FromDateTime2: Decimal;
        CycleEnd: Boolean;
        IsReverse: Boolean;
        DoChangeServLineResource: Boolean;
    begin
        IsReverse := false;
        if FromDateTime > ToDateTime then begin
            FromDateTime2 := FromDateTime;
            FromDateTime := ToDateTime;
            ToDateTime := FromDateTime2;
            IsReverse := true;
        end;

        CurrentDay := DateTimeMgt.Datetime2Date(FromDateTime);
        StartTime := DateTimeMgt.Datetime2Time(FromDateTime);
        CycleEnd := false;
        DoChangeServLineResource := false;

        repeat
            if IsTimeAvailable(ServLaborAllocTemp2, ResourceNo, CurrentDay, 0) then begin
                IsStarttimeAvailable(ServLaborAllocTemp2, ResourceNo, CurrentDay, StartTime);
                ServLaborAllocTemp2.Reset;
                ServLaborAllocTemp2.SetCurrentkey("Resource No.", "Start Date-Time");
                LastTime := 0;
                if ServLaborAllocTemp2.FindFirst then
                    repeat
                        if (LastTime <> 0) and (LastTime < ServLaborAllocTemp2."Start Date-Time") then begin
                            if ToDateTime <= ServLaborAllocTemp2."Start Date-Time" then begin
                                AllocateCurrentEndDateTime := ToDateTime;
                                CycleEnd := true;
                            end else
                                AllocateCurrentEndDateTime := ServLaborAllocTemp2."Start Date-Time";
                            AllocateStartDateTime := LastTime;
                            AllocateCurrentQty := CalcHourDifference(AllocateStartDateTime, AllocateCurrentEndDateTime);
                            InsertAllocationEntry(ServLaborAllocTemp, LaborAllocAppTemp, ResourceNo, AllocateStartDateTime, AllocateCurrentQty,
                                                  0, 0, 'Err8', 0, DoChangeServLineResource, false);
                        end;
                        ServLaborAllocTemp2.SetFilter("End Date-Time", '>%1', ServLaborAllocTemp2."End Date-Time");
                        LastTime := ServLaborAllocTemp2."End Date-Time";
                    until (ServLaborAllocTemp2.Next = 0) or CycleEnd;
            end;
            ServLaborAllocTemp2.Reset;
            ServLaborAllocTemp2.DeleteAll;
            CurrentDay := CurrentDay + 1;
            StartTime := 000000T;
        until CycleEnd or (DateTimeMgt.Datetime(CurrentDay, StartTime) > ToDateTime);

        WorkHours := 0;
        ServLaborAllocTemp.Reset;
        if ServLaborAllocTemp.FindFirst then
            repeat
                WorkHours += ServLaborAllocTemp."Quantity (Hours)";
            until ServLaborAllocTemp.Next = 0;

        if IsReverse then
            exit(-WorkHours);

        exit(WorkHours);
    end;


    procedure CalculateNewStartDateTime(ResourceNo: Code[20]; StartingDateTime: Decimal; QtyToAllocate: Decimal): Decimal
    var
        ServLaborAllocTemp: Record "Serv. Labor Allocation Entry" temporary;
        CurrentDay: Date;
        StartTime: Time;
    begin
        CurrentDay := DateTimeMgt.Datetime2Date(StartingDateTime);
        StartTime := DateTimeMgt.Datetime2Time(StartingDateTime);

        if QtyToAllocate > 0 then
            ReturnAvailableTimes(ServLaborAllocTemp, QtyToAllocate, ResourceNo, CurrentDay, StartTime, 0)
        else begin
            QtyToAllocate *= -1;
            ReturnAvailableTimesBackward(ServLaborAllocTemp, QtyToAllocate, ResourceNo, CurrentDay, StartTime, 0);
        end;

        ServLaborAllocTemp.Reset;
        if ServLaborAllocTemp.FindLast then
            exit(ServLaborAllocTemp."End Date-Time")
        else
            exit(0);
    end;


    procedure CheckForTime(ResourceNo: Code[20]; StartingDateTime: Decimal; FinishingDateTime: Decimal; EntryNo: Integer; DoOneServiceMoving: Boolean; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]): Decimal
    var
        ServLaborAlloc: Record "Serv. Labor Allocation Entry";
        ContinueStartingDateTime: Decimal;
    begin
        ContinueStartingDateTime := FinishingDateTime;

        ServLaborAlloc.Reset;
        ServLaborAlloc.SetRange("Resource No.", ResourceNo);
        ServLaborAlloc.SetRange("Start Date-Time", StartingDateTime, FinishingDateTime - 0.00001);
        if EntryNo <> 0 then
            ServLaborAlloc.SetFilter("Entry No.", '<>%1', EntryNo);
        ServLaborAlloc.SetCurrentkey("Resource No.", "Start Date-Time");

        if DoOneServiceMoving then begin
            ServLaborAlloc.SetRange("Source Type", ServLaborAlloc."source type"::"Service Document");
            ServLaborAlloc.SetRange("Source Subtype", SourceSubType);
            ServLaborAlloc.SetRange("Source ID", SourceID);
        end;

        if ServLaborAlloc.FindFirst then
            ContinueStartingDateTime := ServLaborAlloc."Start Date-Time";

        exit(CalcHourDifference(ContinueStartingDateTime, FinishingDateTime));
    end;


    procedure SplitServiceLine(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]; LineNo: Integer): Integer
    var
        ServiceLineLoc: Record "Service Line EDMS";
        NewLineNo: Integer;
    begin
        if ServiceLineLoc.Get(DocumentType, DocumentNo, LineNo) then
            NewLineNo := DocumentMgt.ServiceSplitLine(ServiceLineLoc, 2)
        else
            NewLineNo := LineNo;

        exit(NewLineNo)
    end;


    procedure FindServiceEntries(var LaborAllocEntry: Record "Serv. Labor Allocation Entry"; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]; ResourceNo: Code[20])
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
    begin
        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Document Type", DocumentType);
        LaborAllocApp.SetRange("Document No.", DocumentNo);
        LaborAllocApp.SetRange("Resource No.", ResourceNo);
        if LaborAllocApp.FindFirst then
            repeat
                if (LaborAllocEntryLoc.Get(LaborAllocApp."Allocation Entry No.")) and
                   not (LaborAllocEntry.Get(LaborAllocApp."Allocation Entry No."))
                then begin
                    LaborAllocEntry := LaborAllocEntryLoc;
                    LaborAllocEntry.Insert;
                end;
            until LaborAllocApp.Next = 0;
    end;


    procedure ProcessStartLabor(StartingDateTime: Decimal; ReasonCode: Code[10])
    var
        WorkTimeEntry: Record "Resource Work Time Entry";
        Hours: Decimal;
        EntryNo: Integer;
        DoReplan: Boolean;
        ResourceNo: Code[20];
        OnDate: Date;
        OnTime: Time;
        Travel: Boolean;
    begin
        ServiceScheduleSetup.Get;
        ScheduleAction := Scheduleaction::"Time Registration";
        EntryNo := SingleInstanceMgt.GetAllocationEntryNo;
        LaborAllocEntry.Get(EntryNo);
        Travel := LaborAllocEntry.Travel;
        //P8 >>
        //Hours := CalcLaborRemainHours(LaborAllocEntry."Entry No.");
        //Hours := LaborAllocEntry."Quantity (Hours)";  //20.07.2013 EDMS P8
        //P8 <<

        //Hours := CalcHourDifference(StartingDateTime,LaborAllocEntry."End Date-Time");
        Hours := LaborAllocEntry."Quantity (Hours)";
        //IF Hours <= 0 THEN
        //  Hours := LaborAllocEntry."Quantity (Hours)";

        //ReasonCodeGlobal := LaborAllocEntry."Reason Code";
        ReasonCodeGlobal := ReasonCode;

        ChangeAllocationStatus := true;
        AllocationStatus := Allocationstatus::"In Process";

        AskedForAllocationSpliting := true;
        //DoReplan := FALSE; // P8 old
        DoReplan := true; // P8 new version
        //P8 >>
        if Resource."No." <> '' then
            //THAT COLD BE FILLED IN CompareSchedulePassword from P25006355
            ResourceNo := Resource."No."  //17.10.2013 EDMS P8
        else
            ResourceNo := LaborAllocEntry."Resource No.";

        SingleInstanceMgt.SetDateFilter(DateTimeMgt.Datetime2Date(StartingDateTime));
        OnDate := DateTimeMgt.Datetime2Date(StartingDateTime);
        OnTime := DateTimeMgt.Datetime2Time(StartingDateTime);

        ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);

        if (LaborAllocEntry."Start Date-Time" <> StartingDateTime) or
          (LaborAllocEntry."Quantity (Hours)" <> Hours) then begin
            ProcessMovement(LaborAllocEntry."Entry No.", ResourceNo,
               StartingDateTime, Hours, 1, AllocationStatus, 1, Travel);
        end else begin
            WriteAllocationEntries(ResourceNo, StartingDateTime, Hours,
                                 LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                 LaborAllocEntry."Source ID", 1, EntryNo, DoReplan, AllocationStatus, false, Travel);  //20.07.2013 EDMS P8
        end;
        //P8 <<


        //Check for Hold/Complete other tasks.
        FinishOtherTasks(ResourceNo, EntryNo, StartingDateTime);
    end;


    procedure ProcessFinishLabor(EndingDateTime: Decimal; AllocationStatus1: Option Pending,"In Process","Finish All","Finish Part","On Hold"; HoldHours: Decimal; ReasonCode: Code[10])
    var
        FinishedHours: Decimal;
        EntryNo: Integer;
        DoReplan: Boolean;
        OnDate: Date;
        OnTime: Time;
        Travel: Boolean;
    begin
        ScheduleAction := Scheduleaction::"Time Registration";
        ServiceScheduleSetup.Get;
        AllocationStatusAction := AllocationStatus1;

        EntryNo := SingleInstanceMgt.GetAllocationEntryNo;
        LaborAllocEntry.Get(EntryNo);
        Travel := LaborAllocEntry.Travel;
        case AllocationStatus1 of
            Allocationstatus1::Pending:
                AllocationStatus := Allocationstatus::Pending;
            Allocationstatus1::"In Process":
                AllocationStatus := Allocationstatus::"In Process";
            Allocationstatus1::"Finish All", Allocationstatus1::"Finish Part":
                AllocationStatus := Allocationstatus::Finished;
            Allocationstatus1::"On Hold":
                AllocationStatus := Allocationstatus::"On Hold";
        end;

        //IF AllocationStatus IN [AllocationStatus::Finished] THEN
        //  DoReplan := TRUE
        //ELSE
        DoReplan := false;

        if AllocationStatus1 = Allocationstatus1::"Finish All" then begin
            WriteAllocationEntryEnd(EntryNo, EndingDateTime, DoReplan, ReasonCode, Travel);
            CheckRemainingLinkedAllocation(EntryNo); //Possibly bug inside function.
        end;

        if AllocationStatus1 = Allocationstatus1::"Finish Part" then
            WriteAllocationEntryEnd(EntryNo, EndingDateTime, DoReplan, ReasonCode, Travel);

        if AllocationStatus = Allocationstatus::"On Hold" then begin
            //AllocationStatus := AllocationStatus::Finished;
            //AllocationStatus := AllocationStatus::"On Hold";
            WriteAllocationEntryEnd(EntryNo, EndingDateTime, DoReplan, ReasonCode, Travel);
            HoldHours += CheckRemainingLinkedAllocation(EntryNo);  //15.08.2013 EDMS P8
            LaborAllocEntry.Get(EntryNo);  //20.07.2013 EDMS P8

            ChangeAllocationStatus := true;
            AllocationStatus := Allocationstatus::"On Hold";
            ReasonCodeGlobal := ReasonCode;
            if HoldHours > 0 then
                WriteAllocationEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."End Date-Time", HoldHours,
                                     LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                     //                         LaborAllocEntry."Source ID", 0, 0, DoReplan, AllocationStatus, TRUE);  //20.07.2013 EDMS P8
                                     //                         LaborAllocEntry."Source ID", 0, LaborAllocEntry."Entry No.", DoReplan, AllocationStatus, FALSE);  //20.07.2013 EDMS P8
                                     LaborAllocEntry."Source ID", 0, LaborAllocEntry."Entry No.", DoReplan, AllocationStatus, true, Travel);  //15.08.2013 EDMS P8
        end;

        OnDate := DateTimeMgt.Datetime2Date(EndingDateTime);
        OnTime := DateTimeMgt.Datetime2Time(EndingDateTime);
        if not ResourceTimeRegMgt.HasTasksInProgress(LaborAllocEntry."Resource No.") then
            ResourceTimeRegMgt.StartDefaultIdleTask(LaborAllocEntry."Resource No.", OnDate, OnTime);
    end;


    procedure ProcessBreak(StandardCode: Code[20]; ReasonCode: Code[10]; BreakHours: Decimal)
    var
        LaborAllocEntry2: Record "Serv. Labor Allocation Entry";
        LaborAllocEntry3: Record "Serv. Labor Allocation Entry";
        ServStandardEvent: Record "Serv. Standard Event";
        CurrDateTime: Decimal;
        FinishedHours: Decimal;
        HoldHours: Decimal;
        DoReplan: Boolean;
        Travel: Boolean;
    begin
        ScheduleAction := Scheduleaction::"Time Registration";
        ServiceScheduleSetup.Get;
        ServStandardEvent.Get(StandardCode);  //12.08.2013 EDMS P8

        CurrDateTime := DateTimeMgt.Datetime(WorkDate, Time);
        LaborAllocEntry2.Get(SingleInstanceMgt.GetAllocationEntryNo);
        FinishedHours := CalcHourDifference(LaborAllocEntry2."Start Date-Time", CurrDateTime);
        HoldHours := LaborAllocEntry2."Quantity (Hours)" - FinishedHours;
        DoReplan := true;
        Travel := LaborAllocEntry2.Travel;

        AllocationStatus := Allocationstatus::Finished;
        WriteAllocationEntryEnd(SingleInstanceMgt.GetAllocationEntryNo, CurrDateTime, DoReplan, ReasonCode, Travel);

        AllocationStatus := Allocationstatus::Pending;
        WriteAllocationEntries(LaborAllocEntry2."Resource No.", CurrDateTime, BreakHours, 2, 0, StandardCode, 0, 0, DoReplan, 0, false, Travel);

        ChangeAllocationStatus := true;
        AllocationStatus := Allocationstatus::"On Hold";
        WriteAllocationEntries(LaborAllocEntry2."Resource No.", LaborAllocEntry."End Date-Time", HoldHours,
                               LaborAllocEntry2."Source Type", LaborAllocEntry2."Source Subtype",
                               LaborAllocEntry2."Source ID", 0, SingleInstanceMgt.GetAllocationEntryNo, DoReplan, -1, false, Travel);
    end;


    procedure ProcessHoldLabor(CurrentDateTime: Decimal; ReasonCodeToSet: Code[10])
    var
        WorkTimeEntry: Record "Resource Work Time Entry";
        Hours: Decimal;
        EntryNo: Integer;
        DoReplan: Boolean;
        ResourceNo: Code[20];
        LaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        OnDate: Date;
        OnTime: Time;
        Travel: Boolean;
    begin
        /*
        EntryNo := SingleInstanceMgt.GetAllocationEntryNo;
        FindSplitEntries(EntryNo, LaborAllocEntryTmp, 0, 1111);
        IF LaborAllocEntryTmp.FINDFIRST THEN
          REPEAT
            IF LaborAllocEntry.GET(LaborAllocEntryTmp."Entry No.") THEN BEGIN
              ReasonCodeGlobal := LaborAllocEntry."Reason Code";
              AllocationStatus := AllocationStatus::"On Hold";
              ChangeStatus(LaborAllocEntry);
            END;
          UNTIL LaborAllocEntryTmp.NEXT = 0;
        
        ChangeServiceLineStatus(EntryNo,FALSE);
        
        OnDate := DateTimeMgt.Datetime2Date(CurrentDateTime);
        OnTime := DateTimeMgt.Datetime2Time(CurrentDateTime);
        IF NOT ResourceTimeRegMgt.HasTasksInProgress(LaborAllocEntryTmp."Resource No.") THEN
          ResourceTimeRegMgt.StartDefaultIdleTask(LaborAllocEntryTmp."Resource No.",OnDate,OnTime);
        */

        ServiceScheduleSetup.Get;
        ScheduleAction := Scheduleaction::"Time Registration";
        EntryNo := SingleInstanceMgt.GetAllocationEntryNo;
        LaborAllocEntry.Get(EntryNo);
        Travel := LaborAllocEntry.Travel;

        Hours := CalcHourDifference(CurrentDateTime, LaborAllocEntry."End Date-Time");
        if Hours <= 0 then
            Hours := LaborAllocEntry."Quantity (Hours)";

        ReasonCodeGlobal := ReasonCodeToSet;
        //ReasonCodeGlobal := LaborAllocEntry."Reason Code";

        ChangeAllocationStatus := true;
        AllocationStatus := Allocationstatus::"On Hold";

        AskedForAllocationSpliting := true;
        DoReplan := true;
        if Resource."No." <> '' then
            ResourceNo := Resource."No."
        else
            ResourceNo := LaborAllocEntry."Resource No.";

        SingleInstanceMgt.SetDateFilter(DateTimeMgt.Datetime2Date(CurrentDateTime));
        OnDate := DateTimeMgt.Datetime2Date(CurrentDateTime);
        OnTime := DateTimeMgt.Datetime2Time(CurrentDateTime);

        //ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo,OnDate,OnTime);

        if (LaborAllocEntry."Start Date-Time" <> CurrentDateTime) or
          (LaborAllocEntry."Quantity (Hours)" <> Hours) then begin
            ProcessMovement(LaborAllocEntry."Entry No.", ResourceNo,
               CurrentDateTime, Hours, 1, AllocationStatus, 1, Travel);
        end else begin
            WriteAllocationEntries(ResourceNo, CurrentDateTime, Hours,
                                 LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                 LaborAllocEntry."Source ID", 1, EntryNo, DoReplan, AllocationStatus, false, Travel);
        end;

        if not ResourceTimeRegMgt.HasTasksInProgress(ResourceNo) then
            ResourceTimeRegMgt.StartDefaultIdleTask(ResourceNo, OnDate, OnTime);

    end;


    procedure ChangeStatus(var LaborAllocEntry: Record "Serv. Labor Allocation Entry")
    begin
        LaborAllocEntry.Validate(Status, AllocationStatus);
        LaborAllocEntry.Validate("Reason Code", ReasonCodeGlobal);
        LaborAllocEntry.Modify;
    end;


    procedure ChangeServiceLineStatus(EntryNo: Integer; Remove: Boolean)
    var
        ServiceHdr: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        ServiceLineTemp: Record "Service Line EDMS" temporary;
        PostedServiceHdr: Record "Posted Serv. Order Header";
        PostedServiceLine: Record "Posted Serv. Order Line";
        PostedServRetHdr: Record "Posted Serv. Ret. Order Header";
        PostedServRetLine: Record "Posted Serv. Return Order Line";
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
        LaborAllocApp2: Record "Serv. Labor Alloc. Application";
        LaborAllocApp3: Record "Serv. Labor Alloc. Application";
        WorkStatus: Record "Service Work Status EDMS";
        CurrStatus: Integer;
        WorkStatusCode: Code[10];
        Resource: Record Resource;
    begin
        LaborAllocEntry.Get(EntryNo);
        if LaborAllocEntry."Source Type" <> LaborAllocEntry."source type"::"Service Document" then
            exit;

        if DontChangeServiceStatus then
            exit;


        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Allocation Entry No.", EntryNo);
        if LaborAllocApp.FindFirst then
            repeat
                CurrStatus := 999999;
                WorkStatusCode := '';
                LaborAllocApp2.Reset;
                LaborAllocApp2.SetRange("Document Type", LaborAllocApp."Document Type");
                LaborAllocApp2.SetRange("Document No.", LaborAllocApp."Document No.");
                if LaborAllocApp."Document Line No." <> 0 then begin
                    LaborAllocApp2.SetRange("Document Line No.", LaborAllocApp."Document Line No.");
                    if Remove then
                        LaborAllocApp2.SetFilter("Allocation Entry No.", '<>%1', EntryNo);
                    if LaborAllocApp2.FindFirst then
                        repeat
                            Resource.Get(LaborAllocApp2."Resource No.");
                            if not (ServiceScheduleSetup."Only Pers. Affect Doc. Status" and
                                (Resource.Type = Resource.Type::Machine)) then begin
                                if LaborAllocEntry.Get(LaborAllocApp2."Allocation Entry No.") then begin
                                    WorkStatus.Reset;
                                    WorkStatus.SetRange("Service Order Status", LaborAllocEntry.Status);
                                    if WorkStatus.FindFirst then;

                                    if CurrStatus > WorkStatus.Priority then begin
                                        CurrStatus := WorkStatus.Priority;
                                        WorkStatusCode := WorkStatus.Code;
                                    end;
                                end;
                            end;
                        until LaborAllocApp2.Next = 0;

                    if not LaborAllocApp.Posted then begin
                        //Preparing temp variable to be used as parameter
                        ServiceLineTemp.Reset;
                        ServiceLineTemp.DeleteAll;
                        ServiceLine.Reset;
                        ServiceLine.SetRange("Document Type", LaborAllocApp."Document Type");
                        ServiceLine.SetRange("Document No.", LaborAllocApp."Document No.");
                        if ServiceLine.FindFirst then
                            repeat
                                ServiceLineTemp.Init;
                                ServiceLineTemp := ServiceLine;
                                ServiceLineTemp.Insert;
                            until ServiceLine.Next = 0;

                        //Updating service line status
                        ServiceLine.Reset;
                        ServiceLine.Get(LaborAllocApp."Document Type", LaborAllocApp."Document No.", LaborAllocApp."Document Line No.");
                        ServiceLine.Status := WorkStatusCode;
                        if not GlobDontModifyServLine then
                            ServiceLine.Modify(true);

                        //Updating service line status in temp variable
                        ServiceLineTemp.Get(LaborAllocApp."Document Type", LaborAllocApp."Document No.", LaborAllocApp."Document Line No.");
                        ServiceLineTemp.Status := WorkStatusCode;
                        ServiceLineTemp.Modify(true);

                        ServiceHdr.Get(ServiceLine."Document Type", ServiceLine."Document No.");
                        ChangeServiceHeaderStatus(ServiceHdr, ServiceLineTemp);
                    end;
                end else begin

                    ServiceHdr.Get(LaborAllocApp."Document Type", LaborAllocApp."Document No.");

                    LaborAllocApp3.Reset;
                    LaborAllocApp3.SetRange("Document Type", LaborAllocApp."Document Type");
                    LaborAllocApp3.SetRange("Document No.", LaborAllocApp."Document No.");
                    //LaborAllocApp3.SetRange("Document Line No.", 0);
                    if LaborAllocApp3.FindFirst then
                        repeat
                            Resource.Get(LaborAllocApp."Resource No.");
                            if not (ServiceScheduleSetup."Only Pers. Affect Doc. Status" and (Resource.Type = Resource.Type::Machine)) then begin
                                if LaborAllocEntry.Get(LaborAllocApp3."Allocation Entry No.") then begin
                                    WorkStatus.Reset;
                                    WorkStatus.SetRange("Service Order Status", LaborAllocEntry.Status);
                                    if WorkStatus.FindFirst then begin
                                        if WorkStatus.Priority < CurrStatus then begin
                                            CurrStatus := WorkStatus.Priority;
                                            WorkStatusCode := WorkStatus.Code;
                                        end;
                                    end;
                                end;
                            end;
                        until LaborAllocApp3.Next = 0;

                    ServiceHdr.Validate("Work Status Code", WorkStatusCode);
                    ServiceHdr.Modify(true);
                end;
            until LaborAllocApp.Next = 0;
    end;


    procedure ChangeServiceHeaderStatusOld(ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS")
    var
        ServiceWorkStatus: Record "Service Work Status EDMS";
        LowestStatus: Integer;
        StatusCode: Code[20];
    begin
        LowestStatus := 999999;
        StatusCode := '';

        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", ServiceLine."document type"::Order);
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange(Type, ServiceLine.Type::Labor);
        if ServiceLine.FindFirst then
            repeat
                if ServiceWorkStatus.Get(ServiceLine.Status) then begin
                    if ServiceWorkStatus.Priority < LowestStatus then begin
                        LowestStatus := ServiceWorkStatus.Priority;
                        StatusCode := ServiceWorkStatus.Code;
                    end;
                end;
            until ServiceLine.Next = 0;

        ServiceHeader.Validate("Work Status Code", StatusCode);
        ServiceHeader.Modify(true);
    end;


    procedure ChangeServiceHeaderStatus(ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS")
    var
        ServiceWorkStatus: Record "Service Work Status EDMS";
        LowestStatus: Integer;
        StatusCode: Code[20];
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        Resource: Record Resource;
    begin
        LowestStatus := 999999;
        StatusCode := '';

        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Document Type", ServiceHeader."Document Type");
        LaborAllocApp.SetRange("Document No.", ServiceHeader."No.");
        LaborAllocApp.SetRange("Document Line No.", 0);
        if LaborAllocApp.FindFirst then
            repeat
                Resource.Get(LaborAllocApp."Resource No.");
                if not (ServiceScheduleSetup."Only Pers. Affect Doc. Status" and
                    (Resource.Type = Resource.Type::Machine)) then begin
                    if LaborAllocEntry.Get(LaborAllocApp."Allocation Entry No.") then begin
                        ServiceWorkStatus.Reset;
                        ServiceWorkStatus.SetRange("Service Order Status", LaborAllocEntry.Status);
                        if ServiceWorkStatus.FindFirst then begin
                            if ServiceWorkStatus.Priority < LowestStatus then begin
                                LowestStatus := ServiceWorkStatus.Priority;
                                StatusCode := ServiceWorkStatus.Code;
                            end;
                        end;
                    end;
                end;
            until LaborAllocApp.Next = 0;

        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange(Type, ServiceLine.Type::Labor);
        if ServiceLine.FindFirst then
            repeat
                if ServiceWorkStatus.Get(ServiceLine.Status) then begin
                    if ServiceWorkStatus.Priority < LowestStatus then begin
                        LowestStatus := ServiceWorkStatus.Priority;
                        StatusCode := ServiceWorkStatus.Code;
                    end;
                end;
            until ServiceLine.Next = 0;

        ServiceHeader.Validate("Work Status Code", StatusCode);
        ServiceHeader.Modify(true);
    end;


    procedure ProcessStartWorkday(ResourceNo: Code[20]; StartDateTime: Decimal)
    var
        WorkTimeEntry: Record "Resource Work Time Entry";
        EntryNo: Integer;
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        OnDate: Date;
        OnTime: Time;
    begin
        ScheduleAction := Scheduleaction::"Time Registration";
        WorkTimeEntry.Reset;
        WorkTimeEntry.SetRange("Resource No.", ResourceNo);
        WorkTimeEntry.SetRange(Closed, false);
        if WorkTimeEntry.FindFirst then begin
            Message(StrSubstNo(Text120, ResourceNo));
            exit;
        end;

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

        OnDate := DateTimeMgt.Datetime2Date(StartDateTime);
        OnTime := DateTimeMgt.Datetime2Time(StartDateTime);

        ResourceTimeRegMgt.AddWorkTimeRegEntries('STARTWORKTIME', ResourceNo, OnDate, OnTime);
        ResourceTimeRegMgt.StartDefaultIdleTask(ResourceNo, OnDate, OnTime);
    end;


    procedure ProcessEndWorkday(ResourceNo: Code[20]; EndDateTime: Decimal)
    var
        WorkTimeEntry: Record "Resource Work Time Entry";
        ServLaborAllocationEntryL: Record "Serv. Labor Allocation Entry";
        DoReplan: Boolean;
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ServStandardEvent: Record "Serv. Standard Event";
        OnDate: Date;
        OnTime: Time;
    begin
        ServiceSetup.Get;
        ScheduleAction := Scheduleaction::"Time Registration";
        DoReplan := false;

        OnDate := DateTimeMgt.Datetime2Date(EndDateTime);
        OnTime := DateTimeMgt.Datetime2Time(EndDateTime);

        //Check for holded labors.
        ServLaborAllocationEntryL.Reset;
        ServLaborAllocationEntryL.SetRange("Resource No.", ResourceNo);
        ServLaborAllocationEntryL.SetRange(Status, ServLaborAllocationEntryL.Status::"In Progress");
        ServLaborAllocationEntryL.SetRange(Status, ServLaborAllocationEntryL.Status::"On Hold");
        if ServLaborAllocationEntryL.FindFirst then
            Error(Text163);

        ServLaborAllocationEntryL.Reset;
        ServLaborAllocationEntryL.SetRange("Resource No.", ResourceNo);
        ServLaborAllocationEntryL.SetRange(Status, ServLaborAllocationEntryL.Status::"In Progress");
        //SETFILTER(Status,'%1|%2', Status::"In Progress",Status::"On Hold");
        ServLaborAllocationEntryL.SetFilter("Source ID", '<>%1', ServiceSetup."Default Idle Event");
        if ServLaborAllocationEntryL.FindFirst then begin
            if GuiAllowed then begin //11.12.2018 EB.P7
                if Confirm(Text129) then
                    repeat
                        AllocationStatus := Allocationstatus::Finished;
                        WriteAllocationEntryEnd(ServLaborAllocationEntryL."Entry No.", EndDateTime, DoReplan, '', ServLaborAllocationEntryL.Travel);
                        ResourceTimeRegMgt.AddTimeRegEntries('Complete', ServLaborAllocationEntryL, ServLaborAllocationEntryL."Resource No.", OnDate, OnTime);
                    until ServLaborAllocationEntryL.Next = 0
                else
                    Error(StrSubstNo(Text106, ServLaborAllocationEntryL."Source Subtype", ServLaborAllocationEntryL."Source ID"));
            end else
                Error(StrSubstNo(Text106, ServLaborAllocationEntryL."Source Subtype", ServLaborAllocationEntryL."Source ID"));
        end;

        WorkTimeEntry.SetCurrentkey("Resource No.", Closed);
        WorkTimeEntry.SetRange("Resource No.", ResourceNo);
        WorkTimeEntry.SetRange(Closed, false);
        if not WorkTimeEntry.FindLast then begin
            Message(StrSubstNo(Text119, ResourceNo));
            exit;
        end;

        WorkTimeEntry.Validate("Worktime End", EndDateTime);
        WorkTimeEntry.Validate("Worked Hours", CalcHourDifference(WorkTimeEntry."Worktime Begin", EndDateTime));
        WorkTimeEntry.Validate(Closed, true);
        WorkTimeEntry.Modify(true);

        ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
        ResourceTimeRegMgt.AddWorkTimeRegEntries('FINISHWORKTIME', ResourceNo, OnDate, OnTime);
    end;


    procedure ProcessStartWorkdaySilent(ResourceNo: Code[20]; StartDateTime: Decimal)
    var
        WorkTimeEntry: Record "Resource Work Time Entry";
        EntryNo: Integer;
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        OnDate: Date;
        OnTime: Time;
    begin
        OnDate := DateTimeMgt.Datetime2Date(StartDateTime);
        OnTime := DateTimeMgt.Datetime2Time(StartDateTime);

        ScheduleAction := Scheduleaction::"Time Registration";
        WorkTimeEntry.Reset;
        WorkTimeEntry.SetRange("Resource No.", ResourceNo);
        WorkTimeEntry.SetRange(Closed, false);
        if not WorkTimeEntry.FindFirst then begin
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

        end;
    end;


    procedure CompareSchedulePassword(ResourceNo: Code[20]; SchedulePassword: Text[20])
    begin
        if Resource.Get(ResourceNo) then
            if Resource."Serv. Schedule Password" = SchedulePassword then
                exit;

        Error(Text112);
    end;


    procedure CreateFieldText(EntryNo: Integer): Text[250]
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
        ScheduleCellConfig: Record "Serv. Schedule Cell Config.";
        ServHdr: Record "Service Header EDMS";
        ServLine: Record "Service Line EDMS";
        StandardEvent: Record "Serv. Standard Event";
        PostedServHdr: Record "Posted Serv. Order Header";
        PostedServLine: Record "Posted Serv. Order Line";
        ServLaborAllocationDetailLoc: Record "Serv. Allocation Description";
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        EndText: Text[250];
        FieldValue: Text[250];
        FieldCaption: Text[250];
        FieldOption: Text[250];
        OptionNumber: Integer;
        SourceTypeFilter: Text;
        FieldRefClass: Option Normal,FlowFilter,FlowField;
    begin
        ScheduleCellConfig.SetCurrentkey(Sequence);
        EndText := '';
        LaborAllocEntry.Get(EntryNo);
        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Allocation Entry No.", EntryNo);
        if LaborAllocApp.FindFirst then;
        if LaborAllocEntry."Source Type" = LaborAllocEntry."source type"::"Service Document" then begin
            if ServHdr.Get(LaborAllocApp."Document Type", LaborAllocApp."Document No.") then begin
                if LaborAllocApp."Document Line No." <> 0 then begin
                    ServLine.Get(LaborAllocApp."Document Type", LaborAllocApp."Document No.", LaborAllocApp."Document Line No.");
                    SourceTypeFilter := Format(Database::"Service Header EDMS") + '|' + Format(Database::"Service Line EDMS");
                end else
                    SourceTypeFilter := Format(Database::"Service Header EDMS");
            end else
                if PostedServHdr.Get(LaborAllocApp."Document No.") then begin
                    if LaborAllocApp."Document Line No." <> 0 then begin
                        PostedServLine.Get(LaborAllocApp."Document No.", LaborAllocApp."Document Line No.");
                        SourceTypeFilter := Format(Database::"Posted Serv. Order Header") + '|' + Format(Database::"Posted Serv. Order Line");
                    end else
                        SourceTypeFilter := Format(Database::"Posted Serv. Order Header");
                end else
                    exit(LaborAllocEntry."Source ID");
        end else begin
            StandardEvent.Get(LaborAllocEntry."Source ID");
            SourceTypeFilter := Format(Database::"Serv. Standard Event");
        end;
        //24.10.2013 EDMS P8 >>
        if LaborAllocEntry."Detail Entry No." > 0 then
            if ServLaborAllocationDetailLoc.Get(LaborAllocEntry."Detail Entry No.") then begin
                if SourceTypeFilter <> '' then
                    SourceTypeFilter += '|';
                SourceTypeFilter += Format(Database::"Serv. Allocation Description");
                ;
            end;
        ScheduleCellConfig.SetFilter("Source Type", SourceTypeFilter);
        //24.10.2013 EDMS P8 <<

        if ScheduleCellConfig.FindFirst then
            repeat
                case ScheduleCellConfig."Source Type" of
                    Database::"Service Header EDMS":
                        begin
                            RecordRef.Open(Database::"Service Header EDMS");
                            RecordRef.GetTable(ServHdr);
                        end;
                    Database::"Service Line EDMS":
                        begin
                            RecordRef.Open(Database::"Service Line EDMS");
                            RecordRef.GetTable(ServLine);
                        end;
                    Database::"Posted Serv. Order Header":
                        begin
                            RecordRef.Open(Database::"Service Header EDMS");
                            RecordRef.GetTable(PostedServHdr);
                        end;
                    Database::"Posted Serv. Order Line":
                        begin
                            RecordRef.Open(Database::"Service Line EDMS");
                            RecordRef.GetTable(PostedServLine);
                        end;
                    Database::"Serv. Standard Event":
                        begin
                            RecordRef.Open(Database::"Serv. Standard Event");
                            RecordRef.GetTable(StandardEvent);
                        end;
                    //24.10.2013 EDMS P8 >>
                    Database::"Serv. Allocation Description":
                        begin
                            RecordRef.Open(Database::"Serv. Allocation Description");
                            RecordRef.GetTable(ServLaborAllocationDetailLoc);
                        end;
                //24.10.2013 EDMS P8 <<
                end;

                FieldRef := RecordRef.Field(ScheduleCellConfig."Source Ref. No.");

                // 14.05.2014 Elva Baltic P21 #S0102 MMG7.00 >>
                Evaluate(FieldRefClass, Format(FieldRef.CLASS));
                if FieldRefClass = Fieldrefclass::FlowField then
                    FieldRef.CalcField;
                // 14.05.2014 Elva Baltic P21 #S0102 MMG7.00 <<

                FieldValue := Format(FieldRef.Value);
                FieldOption := FieldRef.OptionCaption;

                if FieldOption <> '' then begin
                    Evaluate(OptionNumber, FieldValue);
                    FieldValue := SelectStr(OptionNumber + 1, FieldOption);
                end;

                if ScheduleCellConfig.Prefix <> '' then
                    FieldCaption := ScheduleCellConfig.Prefix + ': '
                else
                    FieldCaption := '';

                if FieldValue <> '' then begin
                    if EndText = '' then
                        EndText := CopyStr(FieldCaption + FieldValue, 1, 250)
                    else
                        EndText := CopyStr(EndText + '; ' + FieldCaption + FieldValue, 1, 250);
                end;
                RecordRef.Close;
            until ScheduleCellConfig.Next = 0;
        OnBeforeReturnAllocationCellText(LaborAllocEntry, EndText);
        exit(EndText);
    end;


    procedure CreateNewServiceDocument(DocumentType: Option Quote,"Order","Return Order"): Code[20]
    var
        ServHeader: Record "Service Header EDMS";
    begin
        Clear(ServHeader);
        ServHeader.Init;
        ServHeader."Document Type" := DocumentType;
        ServHeader.Insert(true);
        Commit;
        case DocumentType of
            Documenttype::Quote:
                Page.RunModal(Page::"Service Quote EDMS", ServHeader);
            Documenttype::Order:
                Page.RunModal(Page::"Service Order EDMS", ServHeader);
        end;

        exit(ServHeader."No.");
    end;


    procedure DeleteAllocationFromServLines(ServLine: Record "Service Line EDMS")
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
        LaborAllocEntry2: Record "Serv. Labor Allocation Entry";
        LaborAllocApp2: Record "Serv. Labor Alloc. Application";
        LaborAllocAppTemp: Record "Serv. Labor Alloc. Application" temporary;
    begin
        // 18.12.2014 Elva Baltic P21 #E0003 >>
        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Document Type", ServLine."Document Type");
        LaborAllocApp.SetRange("Document No.", ServLine."Document No.");
        LaborAllocApp.SetRange("Document Line No.", ServLine."Line No.");
        if LaborAllocApp.FindSet then
            repeat
                LaborAllocApp.Delete(true);
            until LaborAllocApp.Next = 0;
        // 18.12.2014 Elva Baltic P21 #E0003 <<

        LaborAllocApp.Reset;
        LaborAllocEntry.Reset;
        LaborAllocApp.SetRange("Document Type", ServLine."Document Type");
        LaborAllocApp.SetRange("Document No.", ServLine."Document No.");
        LaborAllocApp.SetRange("Document Line No.", ServLine."Line No.");
        if LaborAllocApp.FindFirst then begin
            if GuiAllowed then
                if not Confirm(Text117) then
                    Error(Text118);
            repeat
                if LaborAllocEntry.Get(LaborAllocApp."Allocation Entry No.") then
                    if LaborAllocEntry.Status = LaborAllocEntry.Status::Finished then
                        Error(Text116);
                LaborAllocAppTemp := LaborAllocApp;
                LaborAllocAppTemp.Insert;
            until LaborAllocApp.Next = 0;
        end;

        if LaborAllocAppTemp.FindFirst then  //tempp2
            repeat
                DeleteAllocationEntry(LaborAllocEntry2, LaborAllocApp2, LaborAllocAppTemp."Allocation Entry No.", 11111);
            until LaborAllocAppTemp.Next = 0;
    end;


    procedure DeleteAllocationFromServHdr(ServHdr: Record "Service Header EDMS")
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
        LaborAllocEntry2: Record "Serv. Labor Allocation Entry";
        LaborAllocApp2: Record "Serv. Labor Alloc. Application";
        LaborAllocAppTemp: Record "Serv. Labor Alloc. Application" temporary;
    begin
        LaborAllocApp.Reset;
        LaborAllocEntry.Reset;
        LaborAllocApp.SetRange("Document Type", ServHdr."Document Type");
        LaborAllocApp.SetRange("Document No.", ServHdr."No.");
        LaborAllocApp.SetRange("Document Line No.", 0);
        if LaborAllocApp.FindFirst then begin
            if not Confirm(Text117) then
                Error(Text118);
            repeat
                if LaborAllocEntry.Get(LaborAllocApp."Allocation Entry No.") then
                    if LaborAllocEntry.Status = LaborAllocEntry.Status::Finished then
                        Error(Text116);
                LaborAllocAppTemp := LaborAllocApp;
                LaborAllocAppTemp.Insert;
            until LaborAllocApp.Next = 0;
        end;

        if LaborAllocAppTemp.FindFirst then  //tempp2
            repeat
                DeleteAllocationEntry(LaborAllocEntry2, LaborAllocApp2, LaborAllocAppTemp."Allocation Entry No.", 11111);
            until LaborAllocAppTemp.Next = 0;
    end;


    procedure ModifyReason(var LaborAllocEntry: Record "Serv. Labor Allocation Entry"; ReasonCode: Code[10])
    begin
        LaborAllocEntry."Reason Code" := ReasonCode;
        LaborAllocEntry.Modify;
    end;


    procedure PostingServLine(ServiceLine: Record "Service Line EDMS"; NewOrderNo: Code[20])
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
        LaborAllocAppRenamed: Record "Serv. Labor Alloc. Application";
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocAppTemp: Record "Serv. Labor Alloc. Application" temporary;
    begin
        IF ServiceLine.Type <> ServiceLine.Type::Labor THEN
            EXIT;

        ServiceScheduleSetup.GET;

        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", ServiceLine."Document Type");
        LaborAllocApp.SETRANGE("Document No.", ServiceLine."Document No.");
        LaborAllocApp.SETRANGE("Document Line No.", ServiceLine."Line No.");
        IF LaborAllocApp.FINDFIRST THEN
            REPEAT
                IF LaborAllocEntry.GET(LaborAllocApp."Allocation Entry No.") THEN BEGIN
                    IF (LaborAllocEntry.Status <> LaborAllocEntry.Status::Finished) AND ServiceScheduleSetup."Post Only When Finished" THEN
                        ERROR(STRSUBSTNO(Text115, ServiceLine."Line No."));
                    LaborAllocEntry."Source ID" := NewOrderNo;
                    LaborAllocEntry.MODIFY();

                    LaborAllocAppRenamed.GET(LaborAllocApp."Allocation Entry No.", LaborAllocApp."Document Type", LaborAllocApp."Document No.", LaborAllocApp."Document Line No.", LaborAllocApp."Line No.");
                    LaborAllocAppRenamed.RENAME(LaborAllocApp."Allocation Entry No.", LaborAllocApp."Document Type", NewOrderNo, LaborAllocApp."Document Line No.", LaborAllocApp."Line No.");
                    LaborAllocAppRenamed.GET(LaborAllocApp."Allocation Entry No.", LaborAllocApp."Document Type", NewOrderNo, LaborAllocApp."Document Line No.", LaborAllocApp."Line No.");
                    LaborAllocAppRenamed.Posted := TRUE;
                    LaborAllocAppRenamed.MODIFY();
                END;
            UNTIL LaborAllocApp.NEXT = 0;
    end;


    procedure PostingServHdr(ServiceHdr: Record "Service Header EDMS"; NewOrderNo: Code[20])
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
        LaborAllocAppRenamed: Record "Serv. Labor Alloc. Application";
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocAppTemp: Record "Serv. Labor Alloc. Application" temporary;
    begin
        ServiceScheduleSetup.GET;
        ServiceSetup.GET;

        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", ServiceHdr."Document Type");
        LaborAllocApp.SETRANGE("Document No.", ServiceHdr."No.");
        LaborAllocApp.SETRANGE("Document Line No.", 0);
        IF LaborAllocApp.FINDFIRST THEN
            REPEAT
                IF LaborAllocEntry.GET(LaborAllocApp."Allocation Entry No.") THEN BEGIN
                    IF (LaborAllocEntry.Status <> LaborAllocEntry.Status::Finished) AND ServiceScheduleSetup."Post Only When Finished" THEN
                        ERROR(STRSUBSTNO(Text141, ServiceHdr."No."));
                    LaborAllocEntry."Source ID" := NewOrderNo;
                    LaborAllocEntry.MODIFY();

                    LaborAllocAppRenamed.GET(LaborAllocApp."Allocation Entry No.", LaborAllocApp."Document Type", LaborAllocApp."Document No.", LaborAllocApp."Document Line No.", LaborAllocApp."Line No.");
                    LaborAllocAppRenamed.RENAME(LaborAllocApp."Allocation Entry No.", LaborAllocApp."Document Type", NewOrderNo, LaborAllocApp."Document Line No.", LaborAllocApp."Line No.");
                    LaborAllocAppRenamed.GET(LaborAllocApp."Allocation Entry No.", LaborAllocApp."Document Type", NewOrderNo, LaborAllocApp."Document Line No.", LaborAllocApp."Line No.");
                    LaborAllocAppRenamed.Posted := TRUE;
                    LaborAllocAppRenamed.MODIFY();
                END;
            UNTIL LaborAllocApp.NEXT = 0;
    end;


    procedure ClearAllocationEntry(EntryNo: Integer; TimeCompensateByMoveOtherAlloc: Boolean)
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        DoOneServiceMoving: Boolean;
    begin
        ServiceScheduleSetup.Get;
        if not LaborAllocEntry.Get(EntryNo) then
            exit;

        if TimeCompensateByMoveOtherAlloc then  //15.04.2013 EDMS P8
            ReplanEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."End Date-Time",
                        -LaborAllocEntry."Quantity (Hours)", ServiceScheduleSetup."Replan Document",
                        LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID");

        LaborAllocEntry."Quantity (Hours)" := 0;
        LaborAllocEntry."End Date-Time" := LaborAllocEntry."Start Date-Time";
        LaborAllocEntry."Resource No." := '';
        LaborAllocEntry."User ID" := UserId;
        LaborAllocEntry.Validate("Applies-to Entry No.", 0);  //14.03.2014 Elva Baltic P8 #S0003 MMG7.00
        LaborAllocEntry.Status := LaborAllocEntry.Status::Pending;
        LaborAllocEntry."Reason Code" := '';
        LaborAllocEntry.Modify;
    end;


    procedure ControlLaborSequence(SourceSubtype: Option Quote,"Order"; SourceID: Code[20]; LineNo: Integer; StartingDateTime: Decimal): Boolean
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        LaborAllocAppLoc: Record "Serv. Labor Alloc. Application";
    begin
        ServiceScheduleSetup.Get;
        if not ServiceScheduleSetup."Control Labor Sequence" then
            exit;
        LaborAllocAppLoc.Reset;
        LaborAllocAppLoc.SetRange("Document Type", SourceSubtype);
        LaborAllocAppLoc.SetRange("Document No.", SourceID);
        LaborAllocAppLoc.SetFilter("Document Line No.", '<%1', LineNo);
        if LaborAllocAppLoc.FindFirst then
            repeat
                if LaborAllocEntryLoc.Get(LaborAllocAppLoc."Allocation Entry No.") then
                    if (StartingDateTime < LaborAllocEntryLoc."Start Date-Time") and not (AlreadyAskedAboutSequence) then begin
                        if Confirm(Text122) then
                            exit(true)
                        else
                            Error(Text124);
                        AlreadyAskedAboutSequence := true;
                    end;
            until LaborAllocAppLoc.Next = 0;

        exit(true);
    end;


    procedure ControlSkills(SourceSubtype: Option Quote,"Order"; SourceID: Code[20]; LineNo: Integer; ResourceNo: Code[20])
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        LaborAllocAppLoc: Record "Serv. Labor Alloc. Application";
        ServiceLineLoc: Record "Service Line EDMS";
        ResourceSkill: Record "Resource Skill EDMS";
        LaborSkill: Record "Service Labor Skill";
        MissedSkills: Text[1000];
        ResourceList: Text[500];
    begin
        ServiceScheduleSetup.Get;

        if ServiceScheduleSetup."Control Skills" = ServiceScheduleSetup."control skills"::No then
            exit;
        if (ServiceScheduleSetup."Control Skills" = ServiceScheduleSetup."control skills"::"Only Planning") and
           (ScheduleAction = Scheduleaction::"Time Registration")
        then
            exit;

        MissedSkills := '';

        if ServiceLineLoc.Get(SourceSubtype, SourceID, LineNo) then begin
            if ServiceLineLoc.Type <> ServiceLineLoc.Type::Labor then
                exit;

            LaborSkill.Reset;
            LaborSkill.SetRange("Labor Code", ServiceLineLoc."No.");
            if LaborSkill.Count = 0 then
                exit;

            ResourceSkill.Reset;
            ResourceSkill.SetRange("Resource No.", ResourceNo);
            if LaborSkill.FindFirst then
                repeat
                    ResourceSkill.SetRange("Skill Code", LaborSkill."Skill Code");
                    if not ResourceSkill.FindFirst then begin
                        if MissedSkills <> '' then
                            MissedSkills += '; ';
                        MissedSkills += LaborSkill."Skill Code";
                    end;
                until LaborSkill.Next = 0;

            if (MissedSkills <> '') and not (AlreadyAskedAboutSkills) then begin
                if not Confirm(StrSubstNo(Text125, ResourceNo, MissedSkills)) then begin
                    ResourceList := '';
                    ResourceList := AvailableResourceWithSkills(ResourceNo, LaborSkill);
                    if ResourceList <> '' then
                        Error(StrSubstNo(Text139, ResourceList))
                    else
                        Error(Text124);
                end;
                AlreadyAskedAboutSkills := true;
            end;
        end;
    end;


    procedure AvailableResourceWithSkills(ResourceNo: Code[20]; var LaborSkill: Record "Service Labor Skill"): Text[500]
    var
        ScheduleResourceGroupSpec: Record "Schedule Resource Group Spec.";
        ScheduleResourceGroupSpec2: Record "Schedule Resource Group Spec.";
        ResourceSkill: Record "Resource Skill EDMS";
        ResourceTemp: Record Resource temporary;
        ResourceList: Text[500];
        ResourceAccepted: Boolean;
        i: Integer;
    begin
        ResourceTemp.Reset;
        ResourceTemp.DeleteAll;
        ResourceList := '';
        ScheduleResourceGroupSpec.Reset;
        ScheduleResourceGroupSpec.SetRange("Resource No.", ResourceNo);
        if ScheduleResourceGroupSpec.FindFirst then
            repeat
                ScheduleResourceGroupSpec2.Reset;
                ScheduleResourceGroupSpec2.SetRange("Group Code", ScheduleResourceGroupSpec."Group Code");
                ScheduleResourceGroupSpec2.SetFilter("Resource No.", '<>%1', ResourceNo);
                if ScheduleResourceGroupSpec2.FindFirst then
                    repeat
                        ResourceAccepted := true;
                        ResourceSkill.Reset;
                        ResourceSkill.SetRange("Resource No.", ScheduleResourceGroupSpec2."Resource No.");
                        if LaborSkill.FindFirst then
                            repeat
                                ResourceSkill.SetRange("Skill Code", LaborSkill."Skill Code");
                                if not ResourceSkill.FindFirst then
                                    ResourceAccepted := false;
                            until LaborSkill.Next = 0;
                        if ResourceAccepted then begin
                            ResourceTemp.Init;
                            ResourceTemp."No." := ScheduleResourceGroupSpec2."Resource No.";
                            if ResourceTemp.Insert then;
                        end;
                    until ScheduleResourceGroupSpec2.Next = 0;
            until ScheduleResourceGroupSpec.Next = 0;

        i := 0;
        if ResourceTemp.FindFirst then
            repeat
                if ResourceList <> '' then
                    ResourceList += ';';
                ResourceList += ResourceTemp."No.";
                i += 1;
            until (ResourceTemp.Next = 0) or (i = 5);

        exit(ResourceList);
    end;


    procedure FromQuoteToOrder(ServiceLine: Record "Service Line EDMS"; NewServiceNo: Code[20])
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        LaborAllocAppLoc: Record "Serv. Labor Alloc. Application";
        LaborAllocAppLocTemp: Record "Serv. Labor Alloc. Application" temporary;
    begin
        LaborAllocAppLoc.Reset;
        LaborAllocAppLoc.SetRange("Document Type", ServiceLine."Document Type");
        LaborAllocAppLoc.SetRange("Document No.", ServiceLine."Document No.");
        LaborAllocAppLoc.SetRange("Document Line No.", ServiceLine."Line No.");
        if LaborAllocAppLoc.FindFirst then
            repeat
                LaborAllocAppLocTemp := LaborAllocAppLoc;
                LaborAllocAppLocTemp."Document Type" := LaborAllocAppLocTemp."document type"::Order;
                LaborAllocAppLocTemp."Document No." := NewServiceNo;
                LaborAllocAppLocTemp.Insert;
                if LaborAllocEntryLoc.Get(LaborAllocAppLoc."Allocation Entry No.") then begin
                    LaborAllocEntryLoc."Source Subtype" := LaborAllocEntryLoc."source subtype"::Order;
                    LaborAllocEntryLoc."Source ID" := NewServiceNo;
                    LaborAllocEntryLoc.Modify;
                end;
            until LaborAllocAppLoc.Next = 0
        else
            exit;

        LaborAllocAppLoc.Reset;
        LaborAllocAppLoc.SetRange("Document Type", ServiceLine."Document Type");
        LaborAllocAppLoc.SetRange("Document No.", ServiceLine."Document No.");
        LaborAllocAppLoc.SetRange("Document Line No.", ServiceLine."Line No.");
        LaborAllocAppLoc.DeleteAll;

        if LaborAllocAppLocTemp.FindFirst then
            repeat
                LaborAllocAppLoc := LaborAllocAppLocTemp;
                LaborAllocAppLoc.Insert(true);
            until LaborAllocAppLocTemp.Next = 0;
    end;


    procedure CheckRemainingLinkedAllocation(EntryNo: Integer) RetValue: Decimal
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        LaborAllocAppLoc: Record "Serv. Labor Alloc. Application";
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
    begin
        //Possibly bug inside function.
        //RetValue - returns deleted hours
        FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 1111);
        LaborAllocEntryTemp.Reset;
        LaborAllocEntryTemp.SetCurrentkey("Resource No.", "End Date-Time");
        LaborAllocEntryTemp.SetFilter(Status, '%1|%2|%3', LaborAllocEntryTemp.Status::Pending, LaborAllocEntryTemp.Status::"On Hold", LaborAllocEntryTemp.Status::"In Progress");

        if LaborAllocEntryTemp.FindFirst then begin
            repeat
                RetValue += LaborAllocEntryTemp."Quantity (Hours)";
                DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, LaborAllocEntryTemp."Entry No.", 11111);
            until LaborAllocEntryTemp.Next = 0;
        end;
        exit(RetValue);
    end;


    procedure CheckLaborStatus(LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry"): Boolean
    var
        StatusFinishProgress: Integer;
        StatusPendingHold: Integer;
    begin
        StatusFinishProgress := 0;
        StatusPendingHold := 0;
        LaborAllocEntryLoc.Reset;
        if LaborAllocEntryLoc.FindFirst then
            repeat
                if LaborAllocEntryLoc.Status in [LaborAllocEntryLoc.Status::Pending, LaborAllocEntryLoc.Status::"On Hold"] then
                    StatusPendingHold += 1;
                if LaborAllocEntryLoc.Status in [LaborAllocEntryLoc.Status::Finished, LaborAllocEntryLoc.Status::"In Progress"] then
                    StatusFinishProgress += 1;
            until LaborAllocEntryLoc.Next = 0;

        if (StatusFinishProgress > 0) and (StatusPendingHold > 0) then
            exit(true)
        else
            exit(false);
    end;


    procedure JoinAllocationEntries(ResourceNo: Code[20]; StartingDateTime: Decimal)
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        LaborAllocEntryLoc2: Record "Serv. Labor Allocation Entry";
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocEntryTemp2: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocEntryTemp3: Record "Serv. Labor Allocation Entry" temporary;
        JoinLaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        AlreadyJoinLaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocAppLoc: Record "Serv. Labor Alloc. Application";
        JoinTotalHours: Decimal;
        EndDateTime: Decimal;
    begin
        LaborAllocEntryTemp2.Reset;
        LaborAllocEntryTemp2.DeleteAll;
        AlreadyJoinLaborAllocEntryTemp.Reset;
        AlreadyJoinLaborAllocEntryTemp.DeleteAll;

        LaborAllocEntryLoc.Reset;
        LaborAllocEntryLoc.SetCurrentkey("Resource No.", "Start Date-Time");
        LaborAllocEntryLoc.SetRange("Resource No.", ResourceNo);
        LaborAllocEntryLoc.SetFilter("Start Date-Time", '>=%1', StartingDateTime);
        //21.07.2015 EB.P7 #Performance issue >>
        if SingleInstanceMgt.GetAllocationEntryNo <> 0 then
            LaborAllocEntryLoc.SetRange("Entry No.", SingleInstanceMgt.GetAllocationEntryNo);
        //21.07.2015 EB.P7 #Performance issue <<

        if LaborAllocEntryLoc.FindFirst then
            repeat
                if not LaborAllocEntryTemp2.Get(LaborAllocEntryLoc."Entry No.") then begin
                    LaborAllocEntryTemp.Reset;
                    LaborAllocEntryTemp.DeleteAll;
                    LaborAllocEntryTemp3.Reset;
                    LaborAllocEntryTemp3.DeleteAll;
                    FindSplitEntries(LaborAllocEntryLoc."Entry No.", LaborAllocEntryTemp, 0, 1111);
                    if LaborAllocEntryTemp.FindFirst then
                        repeat
                            if not LaborAllocEntryTemp2.Get(LaborAllocEntryTemp."Entry No.") then begin
                                LaborAllocEntryTemp2 := LaborAllocEntryTemp;
                                LaborAllocEntryTemp2.Insert;
                            end;
                            if not LaborAllocEntryTemp3.Get(LaborAllocEntryTemp."Entry No.") then begin
                                LaborAllocEntryTemp3 := LaborAllocEntryTemp;
                                LaborAllocEntryTemp3.Insert;
                            end;
                        until LaborAllocEntryTemp.Next = 0;

                    LaborAllocEntryTemp.SetCurrentkey("Resource No.", "Start Date-Time");
                    if LaborAllocEntryTemp.FindFirst then
                        repeat
                            JoinTotalHours := 0;
                            if not AlreadyJoinLaborAllocEntryTemp.Get(LaborAllocEntryTemp."Entry No.") then begin
                                JoinLaborAllocEntryTemp.Reset;
                                JoinLaborAllocEntryTemp.DeleteAll;
                                JoinLaborAllocEntryTemp := LaborAllocEntryTemp;
                                JoinLaborAllocEntryTemp.Insert;

                                FindJoinEntries(JoinLaborAllocEntryTemp."End Date-Time", LaborAllocEntryTemp3, JoinLaborAllocEntryTemp);
                                EndDateTime := 0;
                                if JoinLaborAllocEntryTemp.FindFirst then
                                    repeat
                                        if not AlreadyJoinLaborAllocEntryTemp.Get(JoinLaborAllocEntryTemp."Entry No.") then begin
                                            AlreadyJoinLaborAllocEntryTemp := JoinLaborAllocEntryTemp;
                                            AlreadyJoinLaborAllocEntryTemp.Insert;
                                        end;
                                        JoinTotalHours += JoinLaborAllocEntryTemp."Quantity (Hours)";
                                        if JoinLaborAllocEntryTemp."End Date-Time" > EndDateTime then
                                            EndDateTime := JoinLaborAllocEntryTemp."End Date-Time";
                                    until JoinLaborAllocEntryTemp.Next = 0;

                                JoinLaborAllocEntryTemp.Reset;
                                if JoinLaborAllocEntryTemp.Count > 1 then begin
                                    LaborAllocEntryLoc2.Get(LaborAllocEntryTemp."Entry No.");
                                    LaborAllocEntryLoc2."End Date-Time" := EndDateTime;
                                    LaborAllocEntryLoc2."Quantity (Hours)" := (EndDateTime - LaborAllocEntryLoc2."Start Date-Time") / 3.6;
                                    LaborAllocEntryLoc2.Modify;
                                    if JoinLaborAllocEntryTemp.FindFirst then
                                        repeat
                                            if JoinLaborAllocEntryTemp."Entry No." <> LaborAllocEntryTemp."Entry No." then begin

                                                if LaborAllocEntryLoc2.Get(JoinLaborAllocEntryTemp."Entry No.") then;
                                                ChangeApplyTo(LaborAllocEntryLoc2."Entry No.", LaborAllocEntryLoc2."Applies-to Entry No.");
                                                LaborAllocEntryLoc2.Delete;

                                                LaborAllocAppLoc.Reset;
                                                LaborAllocAppLoc.SetRange("Allocation Entry No.", JoinLaborAllocEntryTemp."Entry No.");
                                                LaborAllocAppLoc.DeleteAll(true);

                                            end;
                                        until JoinLaborAllocEntryTemp.Next = 0;
                                end;
                            end;
                        until LaborAllocEntryTemp.Next = 0;
                end;
            until LaborAllocEntryLoc.Next = 0;
    end;


    procedure FindJoinEntries(StartingDateTime: Decimal; var LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry"; var JoinLaborAllocEntry: Record "Serv. Labor Allocation Entry")
    begin
        if JoinLaborAllocEntry.FindFirst then;
        LaborAllocEntryLoc.SetCurrentkey("Resource No.", "Start Date-Time");
        LaborAllocEntryLoc.SetRange("Start Date-Time", StartingDateTime);
        LaborAllocEntryLoc.SetRange(Status, JoinLaborAllocEntry.Status);

        if LaborAllocEntryLoc.FindFirst then
            repeat
                if not JoinLaborAllocEntry.Get(LaborAllocEntryLoc."Entry No.") then begin
                    JoinLaborAllocEntry.Init;
                    JoinLaborAllocEntry := LaborAllocEntryLoc;
                    JoinLaborAllocEntry.Insert;
                    FindJoinEntries(LaborAllocEntryLoc."End Date-Time", LaborAllocEntryLoc, JoinLaborAllocEntry);
                end;
            until LaborAllocEntryLoc.Next = 0;
    end;


    procedure CheckUserRightsInit()
    begin
        Clear(isOperAllowedChecked);
        Clear(OperationMainCode);
        Clear(OperAllowed);
        Clear(LaborAllocationEntryPrevTmp);
        LaborAllocationEntryPrevTmp.DeleteAll;
        LaborAllocEntryPrevStatus := -1;
    end;


    procedure CheckUserRights(WhatAllow: Option View,Time,Planning,All): Boolean
    begin
        if UserSetup.Get(UserId) then begin
            case WhatAllow of
                Whatallow::View:
                    if UserSetup."Allow Use Service Schedule" in [UserSetup."allow use service schedule"::" "] then begin
                        ErrorWithRefresh(Text128);
                        exit(false);
                    end;
                Whatallow::Time:
                    if UserSetup."Allow Use Service Schedule" in [UserSetup."allow use service schedule"::" ",
                                                                  UserSetup."allow use service schedule"::"View Only"] then begin
                        ErrorWithRefresh(Text128);
                        exit(false);
                    end;
                Whatallow::Planning:
                    if UserSetup."Allow Use Service Schedule" in [UserSetup."allow use service schedule"::" ",
                                                                  UserSetup."allow use service schedule"::"View Only",
                                                                  UserSetup."allow use service schedule"::"Time Registration"] then begin
                        if SingleInstanceMgt.GetTimeJournalFlag then
                            exit(true);

                        ErrorWithRefresh(Text128);
                        exit(false);
                    end;
                Whatallow::All:
                    if UserSetup."Allow Use Service Schedule" in [UserSetup."allow use service schedule"::" ",
                                                                  UserSetup."allow use service schedule"::"View Only",
                                                                  UserSetup."allow use service schedule"::"Time Registration",
                                                                  UserSetup."allow use service schedule"::Planning]
                    then
                        exit(false);
            end;
        end else begin
            ErrorWithRefresh(Text128);
            exit(false);
        end;

        exit(true);
    end;


    procedure CheckUserRightsAdv(Operation: Integer; LaborAllocationEntryPar: Record "Serv. Labor Allocation Entry"): Boolean
    begin
        // it is atvanced version of CheckUserRights
        // Operation codes:
        // 0 view; 1 - time registration; 2 - Planning; 3 - ; 4 - BREAK; 100 - allocate lines; 110 - allocate header; 120 - ALLOCATE standart event
        // 200 - spliting
        // 300 - move; 310 - change end time of finished
        // 400 - delete entry
        // due to last requirements 20.11.2013 is changed a bit operations: 300 and 310 allowed do with rights same to operation=1
        // It is important to understand that function call mostly happenes at operation right before actual write to db, so
        //   variable LaborAllocEntryPrevStatus is important in taking of decision

        if isOperAllowedChecked and (OperationMainCode = Operation) and
            (LaborAllocEntryPrevStatus = LaborAllocationEntryPar.Status) then
            exit(OperAllowed);
        OperationMainCode := Operation;
        OperAllowed := false;
        isOperAllowedChecked := true;
        LaborAllocationEntryPrevTmp.TransferFields(LaborAllocationEntryPar);
        LaborAllocEntryPrevStatus := LaborAllocationEntryPar.Status;
        case Operation of
            0:
                OperAllowed := CheckUserRights(0);
            1:
                OperAllowed := CheckUserRights(1);
            2:
                begin
                    OperAllowed := CheckUserRights(2);
                end;
            3:
                begin
                    OperAllowed := CheckUserRights(3);
                end;
            4:
                begin
                    if LaborAllocationEntryPar."Source Type" <> LaborAllocationEntryPar."source type"::"Service Document" then
                        Error(Text108);
                    if LaborAllocationEntryPar.Status <> LaborAllocationEntryPar.Status::"In Progress" then
                        Error(Text111);
                    OperAllowed := CheckUserRights(1);
                end;
            100:
                begin
                    ServiceScheduleSetup.Get;
                    if ServiceScheduleSetup."Serv. Document Alloc. Method" = ServiceScheduleSetup."serv. document alloc. method"::Header then
                        Error(Text142);
                    OperAllowed := CheckUserRights(2);
                end;
            110:
                begin
                    ServiceScheduleSetup.Get;
                    if ServiceScheduleSetup."Serv. Document Alloc. Method" = ServiceScheduleSetup."serv. document alloc. method"::Line then
                        Error(Text142);
                    OperAllowed := CheckUserRights(2);
                end;
            120:
                begin
                    OperAllowed := CheckUserRights(2);
                end;
            200:
                begin
                    if not ((LaborAllocationEntryPar.Status = LaborAllocationEntryPar.Status::Pending) or
                            (LaborAllocationEntryPar.Status = LaborAllocationEntryPar.Status::"On Hold"))
                    then
                        Error(StrSubstNo(Text123, LaborAllocationEntryPar.Status));

                    LaborAllocApp.Reset;
                    LaborAllocApp.SetRange("Allocation Entry No.", LaborAllocationEntryPar."Entry No.");
                    LaborAllocApp.SetRange("Document Line No.", 0);
                    if LaborAllocApp.FindFirst then
                        Error(Text134);
                    OperAllowed := CheckUserRights(2);
                end;
            300:
                begin
                    OperAllowed := CheckUserRights(2);  //20.11.2013 EDMS P8
                    if OperAllowed then
                        if LaborAllocationEntryPar.Status in [LaborAllocationEntryPar.Status::"In Progress", LaborAllocationEntryPar.Status::Finished] then begin
                            OperAllowed := false;
                            OperAllowed := CheckUserRights(3);
                            if not OperAllowed then begin
                                ErrorWithRefresh(Text128);  //22.11.2013 EDMS P8
                            end;
                        end;
                end;
            310:
                begin
                    if (LaborAllocationEntryPar."Source Type" <> LaborAllocationEntryPar."source type"::"Service Document") or
                       (LaborAllocationEntryPar.Status <> LaborAllocationEntryPar.Status::Finished)
                    then
                        ErrorWithRefresh(Text138);
                    OperAllowed := CheckUserRights(3);
                end;
            400:
                begin
                    OperAllowed := CheckUserRights(2);
                    if (LaborAllocationEntryPar.Status = LaborAllocationEntryPar.Status::Finished) or
                       (LaborAllocationEntryPar.Status = LaborAllocationEntryPar.Status::"In Progress")
                    then
                        if not CheckUserRights(3) then
                            Error(StrSubstNo(Text114, Format(LaborAllocationEntryPar.Status)))
                        else
                            if not Confirm(StrSubstNo(Text130, Format(LaborAllocationEntryPar.Status))) then
                                Error(StrSubstNo(Text114, Format(LaborAllocationEntryPar.Status)));
                end;
        end;
        exit(OperAllowed);
    end;


    procedure FindServAllocAplicationEntries(var LaborAllocAppLoc: Record "Serv. Labor Alloc. Application"; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20])
    begin
        LaborAllocAppLoc.SetRange("Document Type", DocumentType);
        LaborAllocAppLoc.SetRange("Document No.", DocumentNo);
    end;


    procedure FindServAllocationEntries(var LaborAllocLoc: Record "Serv. Labor Allocation Entry"; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20])
    begin
        LaborAllocLoc.SetRange("Source Type", LaborAllocLoc."source type"::"Service Document");
        LaborAllocLoc.SetRange("Source Subtype", DocumentType);
        LaborAllocLoc.SetRange("Source ID", DocumentNo);
    end;


    procedure CheckForCorrectServHeaderLine(ServiceHdr: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS"; WhatAllocate: Option Header,Line)
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        LaborAllocAppLoc: Record "Serv. Labor Alloc. Application";
        DocumentNo: Code[20];
    begin
        // CASE WhatAllocate OF
        //  WhatAllocate::Header:
        //    BEGIN
        //      LaborAllocEntryLoc.RESET;
        //      LaborAllocEntryLoc.SETRANGE("Source Subtype", ServiceHdr."Document Type");
        //      LaborAllocEntryLoc.SETRANGE("Source ID", ServiceHdr."No.");
        //      IF LaborAllocEntryLoc.FINDFIRST THEN
        //        IF GUIALLOWED THEN
        //          IF NOT CONFIRM(STRSUBSTNO(Text131, ServiceHdr."Document Type", ServiceHdr."No.")) THEN
        //            ERROR(Text150);
        //    END;
        //  WhatAllocate::Line:
        //    BEGIN
        //      IF ServiceLine.FINDFIRST THEN BEGIN
        //        DocumentNo := ServiceLine."Document No.";
        //        REPEAT
        //          IF DocumentNo <> ServiceLine."Document No." THEN
        //            ERROR(Text133);
        //        UNTIL ServiceLine.NEXT = 0;
        //      END;
        //      LaborAllocEntryLoc.RESET;
        //      LaborAllocEntryLoc.SETRANGE("Source Subtype", ServiceLine."Document Type");  //12.12.2014 EB.P8
        //      LaborAllocEntryLoc.SETRANGE("Source ID", ServiceLine."Document No.");
        //      IF LaborAllocEntryLoc.FINDFIRST THEN
        //        IF GUIALLOWED THEN
        //          IF NOT CONFIRM(STRSUBSTNO(Text131, ServiceLine."Document Type", ServiceLine."Document No.")) THEN
        //            ERROR(Text150);
        //    END;
        // END;
    end;


    procedure IsResourceWorkingTime(ResourceNo: Code[20]; CheckDate: Date): Boolean
    var
        ServiceHour: Record "Service Hour EDMS";
        ResourceCalendarChange: Record "Resource Calendar Change";
    begin
        if ResourceCalendarChange.Get(ResourceNo, CheckDate) then begin
            if ResourceCalendarChange."Change Type" = ResourceCalendarChange."change type"::Nonworking then
                exit(false)
            else
                exit(true);
        end;

        ServiceHour.Reset;
        ServiceHour.SetFilter("Starting Date", '''''|<=%1', CheckDate);
        ServiceHour.SetFilter("Ending Date", '''''|>=%1', CheckDate);
        ServiceHour.SetRange(Day, Date2dwy(CheckDate, 1) - 1);
        if not ServiceHour.FindLast then
            exit(false);

        exit(true);
    end;


    procedure GetResourceWorkplace(ResourceNo: Code[20]; CheckDate: Date): Code[10]
    var
        WorkplaceResource: Record "Serv. Workplace Resource";
    begin
        WorkplaceResource.Reset;
        WorkplaceResource.SetRange("Resource No.", ResourceNo);
        WorkplaceResource.SetFilter("Starting Date", '''''|<=%1', CheckDate);
        WorkplaceResource.SetFilter("Ending Date", '''''|>=%1', CheckDate);
        if WorkplaceResource.FindLast then
            exit(WorkplaceResource."Workplace Code")
        else
            exit('');
    end;


    procedure GetResourceSkills(ResourceNo: Code[20]; var ResourceSkill: Record "Resource Skill EDMS"): Code[10]
    var
        WorkplaceResource: Record "Serv. Workplace Resource";
    begin
        ResourceSkill.Reset;
        ResourceSkill.SetRange("Resource No.", ResourceNo);
    end;


    procedure GetResourceShift(ResourceNo: Code[20]): Code[10]
    var
        Resource: Record Resource;
    begin
        if Resource.Get(ResourceNo) then
            exit(Resource."Service Work Group Code")
        else
            exit('');
    end;


    procedure GroupResourceCodeBuffer(var ResourceCodeBuffer: Record "Serv. Schedule Dim. Buffer"; CurrDate: Date; GroupBy: Option " ",Workplace,Skill,Shift)
    var
        WorkplaceResource: Record "Serv. Workplace Resource";
        Workplace: Record "Serv. Workplace";
    begin
        case GroupBy of
            Groupby::Workplace:
                GroupResourceByWorkplaces(ResourceCodeBuffer, CurrDate);
            Groupby::Skill:
                begin
                    GroupResourceBySkills(ResourceCodeBuffer, CurrDate);
                end;
            Groupby::Shift:
                begin
                    GroupResourceByShifts(ResourceCodeBuffer, CurrDate);
                end;
            else
                exit;
        end
    end;


    procedure GroupResourceByWorkplaces(var ResourceCodeBuffer: Record "Serv. Schedule Dim. Buffer"; CurrDate: Date)
    var
        WorkplaceResource: Record "Serv. Workplace Resource";
        Workplace: Record "Serv. Workplace";
        codex: Code[10];
        textx: Text[30];
    begin
        if ResourceCodeBuffer.FindFirst then
            repeat
                WorkplaceResource.SetRange("Resource No.", ResourceCodeBuffer.Code);
                if CurrDate <> 0D then begin
                    WorkplaceResource.SetFilter("Starting Date", '''''|<=%1', CurrDate);
                    WorkplaceResource.SetFilter("Ending Date", '''''|>=%1', CurrDate);
                end;

                if WorkplaceResource.FindLast then begin
                    ResourceCodeBuffer."Code 2" := WorkplaceResource."Workplace Code";
                    ResourceCodeBuffer."Applies-to Code" := WorkplaceResource."Workplace Code";
                    ResourceCodeBuffer.Modify;
                    Workplace.Get(WorkplaceResource."Workplace Code");
                    Workplace.Mark(true);
                end;
            until ResourceCodeBuffer.Next = 0;


        Workplace.MarkedOnly(true);
        if Workplace.FindFirst then
            repeat
                ResourceCodeBuffer.Init;
                ResourceCodeBuffer.Code := Workplace.Code;
                ResourceCodeBuffer.Name := Workplace.Description;
                ResourceCodeBuffer."Code 2" := Workplace.Code;
                ResourceCodeBuffer."Show in Bold" := true;
                ResourceCodeBuffer.Group := true;
                ResourceCodeBuffer.Insert;
            until Workplace.Next = 0;
    end;


    procedure GroupResourceBySkills(var ResourceCodeBuffer: Record "Serv. Schedule Dim. Buffer"; CurrDate: Date)
    var
        ResourceSkill: Record "Resource Skill EDMS";
        Skill: Record "Skill Code EDMS";
    begin
        if ResourceCodeBuffer.FindFirst then
            repeat
                ResourceCodeBuffer."Applies-to Code" := ResourceCodeBuffer."Code 2";
                ResourceCodeBuffer.Modify;
                ResourceSkill.SetRange("Resource No.", ResourceCodeBuffer.Code);
                if ResourceSkill.FindFirst then
                    repeat
                        if Skill.Get(ResourceSkill."Skill Code") then
                            Skill.Mark(true);
                    until ResourceSkill.Next = 0;
            until ResourceCodeBuffer.Next = 0;


        Skill.MarkedOnly(true);
        if Skill.FindFirst then
            repeat
                ResourceCodeBuffer.Init;
                ResourceCodeBuffer.Code := Skill.Code;
                ResourceCodeBuffer.Name := Skill.Description;
                ResourceCodeBuffer."Code 2" := Skill.Code;
                ResourceCodeBuffer."Show in Bold" := true;
                ResourceCodeBuffer.Group := true;
                ResourceCodeBuffer.Insert;
            until Skill.Next = 0;
    end;


    procedure GroupResourceByShifts(var ResourceCodeBuffer: Record "Serv. Schedule Dim. Buffer"; CurrDate: Date)
    var
        Resource: Record Resource;
        Shift: Record "Service Work Group";
    begin
        if ResourceCodeBuffer.FindFirst then
            repeat
                if Resource.Get(ResourceCodeBuffer.Code) then begin
                    ResourceCodeBuffer."Code 2" := Resource."Service Work Group Code";
                    ResourceCodeBuffer."Applies-to Code" := Resource."Service Work Group Code";
                    ResourceCodeBuffer.Modify;
                    if Shift.Get(Resource."Service Work Group Code") then
                        Shift.Mark(true);
                end;
            until ResourceCodeBuffer.Next = 0;


        Shift.MarkedOnly(true);
        if Shift.FindFirst then
            repeat
                ResourceCodeBuffer.Init;
                ResourceCodeBuffer.Code := Shift.Code;
                ResourceCodeBuffer.Name := Shift.Description;
                ResourceCodeBuffer."Code 2" := Shift.Code;
                ResourceCodeBuffer."Show in Bold" := true;
                ResourceCodeBuffer.Group := true;
                ResourceCodeBuffer.Insert;
            until Shift.Next = 0;
    end;


    procedure ChangePlanningPolicy(ServiceHdr: Record "Service Header EDMS")
    begin
        LaborAllocEntry.Reset;
        LaborAllocEntry.SetRange("Source Type", LaborAllocEntry."source type"::"Service Document");
        LaborAllocEntry.SetRange("Source Subtype", ServiceHdr."Document Type");
        LaborAllocEntry.SetRange("Source ID", ServiceHdr."No.");
        if LaborAllocEntry.FindFirst then
            repeat
                LaborAllocEntry."Planning Policy" := ServiceHdr."Planning Policy";
                LaborAllocEntry.Modify;
            until LaborAllocEntry.Next = 0;
    end;


    procedure CheckServiceLineResource(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; ReturnType: Option Error,Boolean; ResourceNo: Code[20]): Boolean
    var
        TextLoc: label 'here are params %1';
    begin
        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Document Type", DocType);
        LaborAllocApp.SetRange("Document No.", DocNo);
        LaborAllocApp.SetRange("Document Line No.", LineNo);
        if LaborAllocApp.FindFirst then begin
            //2012.03.19 EDMS P8 >>
            LaborAllocApp.SetRange("Resource No.", ResourceNo);
            if not LaborAllocApp.FindFirst then begin
                if ReturnType = Returntype::Error then
                    Error(Text136)
                //      ERROR(TextLoc, ServiceLine.GETFILTERS)
                else
                    exit(false);
            end else
                exit(false);
        end else begin
            exit(CheckDocAllocResource(DocType, DocNo, LineType, LineNo, ReturnType, ResourceNo));  // P8
        end;
        exit(true);
    end;


    procedure ChangeFinishedAllocEnding(LaborAllocEntry: Record "Serv. Labor Allocation Entry")
    var
        ChangeAllocationForm: Page "Change Alloc.Ending Date/Time";
    begin
        if not CheckUserRightsAdv(310, LaborAllocEntry) then exit;

        Clear(ChangeAllocationForm);
        ChangeAllocationForm.GetServLaborAllocation(LaborAllocEntry);
        ChangeAllocationForm.LookupMode(true);  //03.04.2013 P8
        Commit;  //28.06.2013 EDMS P8
        ChangeAllocationForm.RunModal;
    end;


    procedure DontModifySalesLine(DontModify: Boolean)
    begin
        GlobDontModifyServLine := DontModify;
    end;


    procedure GetCapacity(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal): Decimal
    var
        ServiceHour: Record "Service Hour EDMS";
        ResCalendarChange: Record "Resource Calendar Change";
        Date: Record Date;
        Resource: Record Resource;
        CurrDate: Date;
        CurrStartTime: Time;
        CurrEndTime: Time;
        CurrEndTime2: Time;
        Capacity: Decimal;
    begin
        if not Resource.Get(ResourceNo) then
            exit(0);
        Capacity := 0;
        CurrDate := DateTimeMgt.Datetime2Date(StartingDateTime);
        CurrStartTime := DateTimeMgt.Datetime2Time(StartingDateTime);
        repeat
            CurrEndTime := DateTimeMgt.Datetime2Time(EndingDateTime);
            if ResCalendarChange.Get(ResourceNo, CurrDate) then begin
                if CurrStartTime < ResCalendarChange."Starting Time" then
                    CurrStartTime := ResCalendarChange."Starting Time";
                if (CurrEndTime > ResCalendarChange."Ending Time") or (CurrDate < DateTimeMgt.Datetime2Date(EndingDateTime)) then
                    CurrEndTime := ResCalendarChange."Ending Time";
                if CurrEndTime > CurrStartTime then
                    Capacity := Capacity + (CurrEndTime - CurrStartTime) / (1000 * 60 * 60);
            end else begin
                Date.Reset;
                Date.SetRange("Period Start", CurrDate);
                if Date.FindFirst then begin
                    ServiceHour.Reset;
                    ServiceHour.SetRange("Service Work Group Code", Resource."Service Work Group Code");
                    ServiceHour.SetFilter("Starting Date", '<=%1|%2', CurrDate, 0D);
                    ServiceHour.SetFilter("Ending Date", '>=%1|%2', CurrDate, 0D);
                    ServiceHour.SetRange(Day, Date."Period No." - 1);
                    if ServiceHour.FindFirst then begin
                        CurrEndTime2 := CurrEndTime;
                        repeat
                            CurrEndTime := CurrEndTime2;
                            if CurrStartTime < ServiceHour."Starting Time" then
                                CurrStartTime := ServiceHour."Starting Time";
                            if (CurrEndTime > ServiceHour."Ending Time") or (CurrDate < DateTimeMgt.Datetime2Date(EndingDateTime)) then
                                CurrEndTime := ServiceHour."Ending Time";
                            if CurrEndTime - CurrStartTime > 0 then
                                Capacity := Capacity + (CurrEndTime - CurrStartTime) / (1000 * 60 * 60);
                        until ServiceHour.Next = 0;
                    end;
                end;
            end;
            CurrDate := CurrDate + 1;
            CurrStartTime := 0T;
        until CurrDate > DateTimeMgt.Datetime2Date(EndingDateTime);
        exit(Capacity)
    end;


    procedure GetNotAvailabilityTime(var TempLaborAllocEntry: Record "Serv. Labor Allocation Entry" temporary; StartingDateTime: Decimal; EndingDateTime: Decimal): Decimal
    var
        NotAvailable: Decimal;
        CurrStart: Decimal;
        CurrEnd: Decimal;
    begin
        if TempLaborAllocEntry.FindFirst then
            repeat
                if StartingDateTime > TempLaborAllocEntry."Start Date-Time" then
                    CurrStart := StartingDateTime
                else
                    CurrStart := TempLaborAllocEntry."Start Date-Time";
                if EndingDateTime < TempLaborAllocEntry."End Date-Time" then
                    CurrEnd := EndingDateTime
                else
                    CurrEnd := TempLaborAllocEntry."End Date-Time";
                NotAvailable := NotAvailable + CalcHourDifference(CurrStart, CurrEnd);
            until TempLaborAllocEntry.Next = 0;

        exit(NotAvailable);
    end;


    procedure ShowServiceAllocation(SourceID: Code[20])
    var
        ServLaborAllocation: Record "Serv. Labor Allocation Entry";
    begin
        ServLaborAllocation.Reset;
        ServLaborAllocation.SetCurrentkey("Source Type", "Source Subtype", "Source ID");
        ServLaborAllocation.SetRange("Source Type", ServLaborAllocation."source type"::"Service Document");
        ServLaborAllocation.SetRange("Source ID", SourceID);
        if ServLaborAllocation.Count = 0 then
            Message(Text140)
        else
            Page.RunModal(Page::"Service Labor List", ServLaborAllocation);
    end;


    procedure CheckStartAndPlan(EntryNo: Integer)
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        WorkTimeEntry: Record "Resource Work Time Entry";
        CurrDateTime: Decimal;
    begin
        LaborAllocEntry.Get(EntryNo);
        CurrDateTime := DateTimeMgt.Datetime(WorkDate, Time);

        WorkTimeEntry.Reset;
        WorkTimeEntry.SetCurrentkey("Resource No.", Closed);
        WorkTimeEntry.SetRange("Resource No.", LaborAllocEntry."Resource No.");
        WorkTimeEntry.SetRange(Closed, false);
        if not WorkTimeEntry.FindLast then
            Error(StrSubstNo(Text107, LaborAllocEntry."Resource No."));

        Resource.Get(LaborAllocEntry."Resource No.");
        if not Resource."Allow Simultaneous Work" then begin  //17.10.2013 EDMS P8
            LaborAllocEntryLoc.Reset;
            LaborAllocEntryLoc.SetCurrentkey("Source Type", Status, "Resource No.");
            LaborAllocEntryLoc.SetRange(Status, LaborAllocEntryLoc.Status::"In Progress");
            LaborAllocEntryLoc.SetRange("Resource No.", LaborAllocEntry."Resource No.");
            if LaborAllocEntryLoc.FindFirst then
                Error(Text135);
        end;

        if IsTimeAvailable(LaborAllocEntryTemp, LaborAllocEntry."Resource No.", WorkDate, 0) then begin
            LaborAllocEntryTemp.Reset;
            if LaborAllocEntryTemp.FindFirst then
                repeat
                    if (LaborAllocEntryTemp."Start Date-Time" <= CurrDateTime) and
                       (LaborAllocEntryTemp."End Date-Time" >= CurrDateTime)
                    then
                        Error(Text113);
                until LaborAllocEntryTemp.Next = 0
            else
                Error(Text113);
        end else
            Error(Text113);
    end;


    procedure DoNotChangeServStatus()
    begin
        DontChangeServiceStatus := true;
    end;


    procedure LookupAllocationRTC(EntryNo: Integer)
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        ServiceHeader: Record "Service Header EDMS";
        PostedServOrder: Record "Posted Serv. Order Header";
    begin
        if not LaborAllocEntry.Get(EntryNo) then exit;

        if LaborAllocEntry."Source Type" <> LaborAllocEntry."source type"::"Service Document" then
            exit;

        if ServiceHeader.Get(LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID") then begin
            case ServiceHeader."Document Type" of
                ServiceHeader."document type"::Quote:
                    Page.RunModal(Page::"Service Quote EDMS", ServiceHeader);
                ServiceHeader."document type"::Order:
                    Page.RunModal(Page::"Service Order EDMS", ServiceHeader);
            end;
        end else begin
            if PostedServOrder.Get(LaborAllocEntry."Source ID") then
                Page.RunModal(Page::"Posted Service Order EDMS", PostedServOrder);
        end;
    end;


    procedure AllocationChanged(EntryNo: Integer; NewResourceNo: Code[20]; var NewStartDT: Decimal; var NewEndDT: Decimal) RetValue: Boolean
    var
        LaborAllocEntryL: Record "Serv. Labor Allocation Entry";
        AdjustedTime: Time;
        DateTmeTmp: Decimal;
        RoundMs: Integer;
        OrigNewStartDT: Decimal;
        OrigNewEndDT: Decimal;
    begin
        LaborAllocEntryL.Get(EntryNo);
        OrigNewStartDT := NewStartDT;
        OrigNewEndDT := NewEndDT;

        ServiceScheduleSetup.Get;
        if ServiceScheduleSetup."Allocation Time Step (Minutes)" > 0 then
            RoundMs := ServiceScheduleSetup."Allocation Time Step (Minutes)"
        else
            RoundMs := 36000; // IF NO SETUP THEN min by system is 36 sec.
        if RoundMs > 0 then begin
            // lets do time adjustment

            if LaborAllocEntryL."Start Date-Time" <> NewStartDT then
                NewStartDT := DateTimeRound(NewStartDT, RoundMs);
            if LaborAllocEntryL."End Date-Time" <> NewEndDT then begin
                NewEndDT := DateTimeRound(NewEndDT, RoundMs);
            end;
            AdjustedTime := 000001T - 1000 + RoundMs;
            DateTmeTmp := DateTimeMgt.Datetime(0D, AdjustedTime);
            if ((NewEndDT - NewStartDT) < DateTmeTmp) then begin
                NewEndDT := NewStartDT + DateTmeTmp;
            end;
        end;

        //do define should be shown task-edit form or should not?
        if (LaborAllocEntryL."Resource No." <> NewResourceNo) and (NewResourceNo <> '') then
            RetValue := true;
        // rounding by 1 second
        if not IsDateTimeEqualDateTime(LaborAllocEntryL."Start Date-Time", OrigNewStartDT) then  //20.07.2013 EDMS P8
            RetValue := true;
        if not IsDateTimeEqualDateTime(LaborAllocEntryL."End Date-Time", OrigNewEndDT) then
            RetValue := true;
        exit(RetValue);
    end;


    procedure FillUnavailableTimeEntries(var AllocEntry: Record "Serv. Labor Allocation Entry"; ResourceNo: Code[20]; TargetDate: Date)
    var
        ServiceHour: Record "Service Hour EDMS";
        ResCalendarChange: Record "Resource Calendar Change";
        ServLaborAlloc2: Record "Serv. Labor Allocation Entry";
        ApplicationEntry: Record "Serv. Labor Alloc. Application" temporary;
        ResourceLoc: Record Resource;
        CheckDescription: Text[50];
        Starting: Decimal;
        Finishing: Decimal;
        QtyToAllocate: Decimal;
        EntryNo: Integer;
        DoChangeServLineResource: Boolean;
        Text001: label 'Unavailability';
        ResWorkTimeChange: Boolean;
        PrevRecStartTime: Time;
        PrevRecEndTime: Time;
    begin
        ServiceScheduleSetup.Get;
        DoChangeServLineResource := false;
        ResWorkTimeChange := false;

        //check for busy time in Base Calendar and in Resource Calendar Change >>
        if ResCalendarChange.Get(ResourceNo, TargetDate) then begin
            case ResCalendarChange."change type"::"Work Time Change" of
                ResCalendarChange."change type"::Nonworking:
                    begin
                        QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, 000000T),
                                                            DateTimeMgt.Datetime(TargetDate, 235959.999T));
                        InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo, DateTimeMgt.Datetime(TargetDate, 000000T), QtyToAllocate,
                                              0, 0, Text001, 0, DoChangeServLineResource, AllocEntry.Travel);
                    end;

                ResCalendarChange."change type"::"Work Time Change":
                    begin
                        ResWorkTimeChange := true;
                        if ResCalendarChange."Starting Time" > 0T then begin
                            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, 000000T),
                                                                DateTimeMgt.Datetime(TargetDate, ResCalendarChange."Starting Time"));
                            InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo, DateTimeMgt.Datetime(TargetDate, 000000T), QtyToAllocate,
                                                  0, 0, Text001, 0, DoChangeServLineResource, AllocEntry.Travel);
                        end;

                        if ResCalendarChange."Ending Time" < 235959.999T then begin
                            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, ResCalendarChange."Ending Time"),
                                                                DateTimeMgt.Datetime(TargetDate, 235959.999T));
                            InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo,
                                                  DateTimeMgt.Datetime(TargetDate, ResCalendarChange."Ending Time"), QtyToAllocate, 0, 0, Text001, 0,
                                                  DoChangeServLineResource, AllocEntry.Travel);
                        end;
                    end;
            end;
        end;

        //write busy time from Service Hour EDMS >>
        if not ResWorkTimeChange then begin
            ServiceHour.Reset;
            //AB >>
            if (ResourceLoc.Get(ResourceNo)) then begin
                //ResourceLoc.GET(ResourceNo);
                ServiceHour.SetRange("Service Work Group Code", ResourceLoc."Service Work Group Code");
                ServiceHour.SetFilter("Starting Date", '''''|<=%1', TargetDate);
                ServiceHour.SetFilter("Ending Date", '''''|>=%1', TargetDate);
                ServiceHour.SetRange(Day, Date2dwy(TargetDate, 1) - 1);

                //18.01.2012 EDMS P8 >>
                if ServiceHour.FindFirst then begin
                    PrevRecStartTime := 0T;
                    PrevRecEndTime := 0T;
                    repeat
                        if ServiceHour."Starting Time" > 0T then begin
                            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, PrevRecEndTime),
                                                                DateTimeMgt.Datetime(TargetDate, ServiceHour."Starting Time"));
                            InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo, DateTimeMgt.Datetime(TargetDate, PrevRecEndTime),
                                                  QtyToAllocate, 0, 0, Text001, 0, DoChangeServLineResource, AllocEntry.Travel);
                        end;

                        PrevRecStartTime := ServiceHour."Starting Time";
                        PrevRecEndTime := ServiceHour."Ending Time";
                    until ServiceHour.Next = 0;
                    if ServiceHour."Ending Time" < 235959.999T then begin
                        QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, ServiceHour."Ending Time"),
                                                            DateTimeMgt.Datetime(TargetDate, 235959.999T));
                        InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo,
                                              DateTimeMgt.Datetime(TargetDate, ServiceHour."Ending Time"), QtyToAllocate, 0, 0, Text001, 0,
                                              DoChangeServLineResource, AllocEntry.Travel);
                    end;
                    //18.01.2012 EDMS P8 <<
                end else begin
                    QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, 000000T),
                                                          DateTimeMgt.Datetime(TargetDate, 235959.999T));
                    InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo, DateTimeMgt.Datetime(TargetDate, 000000T), QtyToAllocate,
                                            0, 0, Text001, 0, DoChangeServLineResource, AllocEntry.Travel);
                end;
            end;
            //AB <<
        end;
    end;


    procedure DateTimeRound(DateTime: Decimal; RoundMs: Integer): Decimal
    var
        AdjustedTime: Time;
    begin
        if RoundMs > 0 then begin
            AdjustedTime := 000001T - 1000 + RoundMs;
            exit(ROUND(DateTime, DateTimeMgt.Datetime(0D, AdjustedTime)))
        end else
            exit(DateTime);
    end;


    procedure IsDateTimeEqualDateTime(FirstDT: Decimal; SecondDT: Decimal): Boolean
    begin
        exit(DateTimeRound(FirstDT, 1000) = DateTimeRound(SecondDT, 1000));  //20.07.2013 EDMS P8
    end;


    procedure DocAllocAdjustDocLinesResource(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]; ResourceNo: Code[20])
    var
        ServiceLineLocal: Record "Service Line EDMS";
        Resources: Text[250];
    begin
        //  P8
        if GetSourceType(LaborAllocEntry, LaborAllocApp) <> Laborallocapptype::"Service Document" then
            exit;
        ServiceLineLocal.Reset;
        ServiceLineLocal.SetRange("Document Type", DocumentType);
        ServiceLineLocal.SetRange("Document No.", DocumentNo);
        ServiceLineLocal.SetRange(Type, ServiceLineLocal.Type::Labor);
        FillServiceLine(ServiceLineLocal);
        if ServiceLineLocal.FindFirst then begin
            Resources := GetRelatedResources(DocumentType, DocumentNo, ServiceLineLocal.Type::Labor, ServiceLineLocal."Line No.", 0);
            repeat
                SetRelatedResources(DocumentType, DocumentNo, ServiceLineLocal.Type::Labor, ServiceLineLocal."Line No.",
                  Resources, 11);
            until ServiceLineLocal.Next = 0;
        end;
    end;


    procedure CheckDocAllocResource(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; ReturnType: Option Error,Boolean; ResourceNo: Code[20]): Boolean
    begin
        //  P8
        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Document Type", DocType);
        LaborAllocApp.SetRange("Document No.", DocNo);
        LaborAllocApp.SetRange("Document Line No.", 0);
        if LaborAllocApp.FindFirst then begin
            //2012.03.19 EDMS P8 >>
            LaborAllocApp.SetRange("Resource No.", ResourceNo);
            if not LaborAllocApp.FindFirst then begin
                if ReturnType = Returntype::Error then
                    Error(Text136)
                else
                    exit(false);
            end else
                exit(false);
        end;
        exit(true);
    end;


    procedure GetDocAllocResource(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]) ResourceNo: Code[20]
    begin
        // old version, look at GetDocAllocResources
        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Document Type", DocumentType);
        LaborAllocApp.SetRange("Document No.", DocumentNo);
        LaborAllocApp.SetRange("Document Line No.", 0);
        if LaborAllocApp.FindFirst then
            if (LaborAllocApp."Resource No." <> '') then
                ResourceNo := LaborAllocApp."Resource No.";
        exit(ResourceNo);
    end;


    procedure GetDocAllocResources(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]) ResourceNos: Text[250]
    var
        ServLaborApplicationTmp: Record "Serv. Labor Alloc. Application" temporary;
    begin
        ResourceNos := '';
        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Document Type", DocumentType);
        LaborAllocApp.SetRange("Document No.", DocumentNo);
        LaborAllocApp.SetRange("Document Line No.", 0);
        if LaborAllocApp.FindFirst then begin
            repeat
                ServLaborApplicationTmp.SetRange("Resource No.", LaborAllocApp."Resource No.");
                if not ServLaborApplicationTmp.FindFirst then begin
                    ResourceNos += LaborAllocApp."Resource No." + ',';
                    ServLaborApplicationTmp := LaborAllocApp;
                    ServLaborApplicationTmp.Insert;
                end;
            until LaborAllocApp.Next = 0;
            ResourceNos := CopyStr(ResourceNos, 1, StrLen(ResourceNos) - 1);
        end;
        exit(ResourceNos);
    end;


    procedure GetSourceType(LaborAllocEntryPar: Record "Serv. Labor Allocation Entry"; LaborAllocAppPar: Record "Serv. Labor Alloc. Application"): Integer
    var
        RetValue: Option " ","Service Document","Standard Event","Service Line";
    begin
        if LaborAllocEntryPar."Entry No." > 0 then begin
            RetValue := LaborAllocEntryPar."Source Type";
            if RetValue = Retvalue::"Service Document" then
                if LaborAllocAppPar."Document Line No." > 0 then
                    RetValue := Retvalue::"Service Line";
        end;
        exit(RetValue);
    end;


    procedure SeparateAllocEntry(var ServLaborAllocEntryPar: Record "Serv. Labor Allocation Entry"; var ServAllocAppSourcePar: Record "Serv. Labor Alloc. Application"; var ServLineDestPar: Record "Service Line EDMS"; ShareQtySource: Decimal; ShareQtyDest: Decimal; StartTimeDepends: Boolean; DoCreateServLine: Boolean; ParamStr: Text[30]): Integer
    var
        ServLineSource: Record "Service Line EDMS";
        ServLaborAllocEntryDest: Record "Serv. Labor Allocation Entry";
        ServLaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        AllocAppEntrySource: Record "Serv. Labor Alloc. Application";
        AllocAppEntryDest: Record "Serv. Labor Alloc. Application";
        TextLoc001: label 'Error to proceed allocation split - should be finished or unstarted.';
        AllocAppEntry: Record "Serv. Labor Alloc. Application";
        QtySource: Decimal;
        QtySourceBeforeChange: Decimal;
        QtyDest: Decimal;
        DocMgtDMS: Codeunit DocumentManagementDMS;
        SplitQuantity: Decimal;
        SplitHours: Decimal;
        OldQuantity: Decimal;
        OldHours: Decimal;
        NewQuantity: Decimal;
        NewHours: Decimal;
        NewLineNo: Integer;
        CurrentLineNo: Integer;
        DateStart: Decimal;
        FinishedQty: Decimal;
        RemainingQty: Decimal;
        AllocTimeQty: Decimal;
        NewAllocEntryNo: Integer;
        LineNoSource: Integer;
        ShareOfLineInAlloc: Decimal;
        MainAllocQty: Decimal;
        IsSourceDeallocated: Boolean;
        ResourceNo: Code[20];
        doAvoidSrcChanges: Boolean;
        doAvoidSrcLineQtyChange: Boolean;
        doAvoidDestLineQtyChange: Boolean;
    begin
        // supposed that the function could be runned if allocation not used at all or finished already
        // Proceed only for one Alloc Entry.
        // StartTimeDepends = true - means Start Time for new Allocation Entry should be ending time of source entry.
        // supposed to be used in cases:
        //   of adding allocation to Service Line EDMS that has already allocated to other resource, then need to split line and allocation
        //   of both lines exist but need to adjust qty share for existing first allocation and create new allocation for second line with o
        // parameter ServAllocAppSourcePar - supposed to be temporary record with stored several applications - usefull if source allocation
        //   is deallocated already (in procedure from that is called).
        //   IMPORTANT it should be filtered if real record used, instead of temporary!
        // parameter ServLaborAllocEntryPar - could be temporary or not!
        // note for coding: FINISHED AND REMAINING QUANTITIES are stored only in first AllocAppEntry entry
        // parameter ServLineDestPar should be filtered or temporary in case of ServAllocAppSourcePar.COUNT > 1
        // parameter ShareQtySource - stores quantity share of labor but not entry (so for entry it going to be adjusted)

        // ParamStr: first char is digit-flag, doAvoidSrcChanges("Applies-to Entry No.")
        //  2nd char is digit-flag, doAvoidSrcLineQtyChange
        //  3rd char is digit-flag, doAvoidDestLineQtyChange
        if StrLen(ParamStr) > 0 then
            Evaluate(doAvoidSrcChanges, CopyStr(ParamStr, 1, 1));
        if StrLen(ParamStr) > 1 then
            Evaluate(doAvoidSrcLineQtyChange, CopyStr(ParamStr, 2, 1));
        if StrLen(ParamStr) > 2 then
            Evaluate(doAvoidDestLineQtyChange, CopyStr(ParamStr, 3, 1));

        if not ServAllocAppSourcePar.FindFirst then
            exit;
        LineNoSource := ServAllocAppSourcePar."Document Line No.";
        ResourceNo := ServAllocAppSourcePar."Resource No.";
        repeat
            if (ServAllocAppSourcePar."Finished Quantity (Hours)" > 0) then begin
                FindSplitEntries(ServAllocAppSourcePar."Allocation Entry No.", ServLaborAllocEntryTmp, 0, 1111);
                if ServLaborAllocEntryTmp.FindFirst then begin
                    repeat
                        AllocAppEntry.Reset;
                        AllocAppEntry.SetRange("Allocation Entry No.", ServLaborAllocEntryTmp."Entry No.");
                        if AllocAppEntry.FindFirst then
                            if (AllocAppEntry."Remaining Quantity (Hours)" > 0) then
                                Error(TextLoc001);
                    until ServLaborAllocEntryTmp.Next = 0;
                end;
            end;
        until ServAllocAppSourcePar.Next = 0;
        ServAllocAppSourcePar.FindFirst;

        //At first fix source allocation
        //before run it do check: is it a real record?
        LaborAllocEntry.Get(ServLaborAllocEntryPar."Entry No.");
        if not doAvoidSrcChanges then begin
            QtySourceBeforeChange := ServLaborAllocEntryPar."Quantity (Hours)";
            IsSourceDeallocated := false;
            if (ShareQtySource <> 100) then begin
                // need to update current entry quantity
                with ServLaborAllocEntryPar do begin
                    MainAllocQty := ServLaborAllocEntryPar."Quantity (Hours)";
                    QtySource := MainAllocQty * ShareQtySource / 100;
                    if QtySource = 0 then begin
                        DeallocateIncSplit(ServLaborAllocEntryPar."Entry No.", true);
                        IsSourceDeallocated := true;
                    end else begin
                        if not doAvoidSrcLineQtyChange then
                            if ServLineSource.Get(ServLaborAllocEntryPar."Source Subtype", ServLaborAllocEntryPar."Source ID",
                                LineNoSource) then begin
                                ServLineSource.SetTimeQty(QtySource, true, true);
                                ServLineSource.Modify;
                            end;
                        if FinishedQty = 0 then
                            ProcessMovement(ServLaborAllocEntryPar."Entry No.", ServLaborAllocEntryPar."Resource No.", ServLaborAllocEntryPar."Start Date-Time", QtySource, 1, LaborAllocEntry.Status, -1, LaborAllocEntry.Travel)
                        else begin
                            ProcessMovement(ServLaborAllocEntryPar."Entry No.", ServLaborAllocEntryPar."Resource No.", ServLaborAllocEntryPar."Start Date-Time", QtySource, 1, LaborAllocEntry.Status, -1, LaborAllocEntry.Travel);
                        end;
                    end;
                end;
            end;
        end;

        //add "Service Line EDMS" for destination
        if DoCreateServLine then begin
            ServLineSource.Get(ServLaborAllocEntryPar."Source Subtype", ServLaborAllocEntryPar."Source ID",
              AllocAppEntrySource."Document Line No.");
            ServLineDestPar := ServLineSource;
            NewLineNo := NewLineNo + 1;
            ServLineDestPar."Line No." := NewLineNo;
            ServLineDestPar.Insert;

            //    DocMgtDMS.ServiceCopyDimensions(ServLineSource, NewLineNo);//30.10.2012 EDMS

        end;
        if not doAvoidDestLineQtyChange then begin
            if ShareQtyDest <> 100 then begin
                ServLineDestPar.Validate("Standard Time", ServLineDestPar."Standard Time" * ShareQtyDest / 100);
                ServLineDestPar.SetTimeQty(QtySourceBeforeChange * ShareQtyDest / 100, true, true);
            end;
            ServLineDestPar.Modify;
        end;

        // add allocation for destination service line
        FinishedQty := ServAllocAppSourcePar."Finished Quantity (Hours)";
        RemainingQty := ServAllocAppSourcePar."Remaining Quantity (Hours)";
        FinishedQty := ROUND(FinishedQty * ShareQtyDest / 100, 0.00001);
        RemainingQty := ROUND(RemainingQty * ShareQtyDest / 100, 0.00001);
        if StartTimeDepends and not IsSourceDeallocated then begin
            DateStart := GetEntryEndingTimeFull(ServLaborAllocEntryPar."Entry No.");
            if DateStart <= DateTimeMgt.Datetime(0D, 0T) then // THAT Is in case when source allocation is deallocated
                DateStart := ServLaborAllocEntryPar."Start Date-Time";
        end else
            DateStart := ServLaborAllocEntryPar."Start Date-Time";
        DateStart := ROUND(DateStart, 0.000001, '>');  // it strange, but sometimes datestart stored in database is not able to proceed
                                                       // by DateTime2Time, so need to round-up it before!

        //19.03.2013 EDMS P8 >>
        if ServLaborAllocEntryPar.Status = ServLaborAllocEntryPar.Status::Pending then
            AllocTimeQty := ServLineDestPar.GetTimeQty
        else
            AllocTimeQty := ROUND(ServLaborAllocEntryPar."Quantity (Hours)" * ShareQtyDest / 100, 0.00001);
        //19.03.2013 EDMS P8 <<

        NewAllocEntryNo := CreateNewAllocEntry(DateStart, ResourceNo,
          AllocTimeQty, ServLineDestPar."Document Type",
          ServLineDestPar."Document No.", ServLineDestPar."Line No.", ServLaborAllocEntryPar."Reason Code",
          ServLaborAllocEntryPar."Planning Policy", FinishedQty, RemainingQty, ServLaborAllocEntryPar.Status);
        if ServAllocAppSourcePar.Count > 1 then begin
            ServAllocAppSourcePar.Next; // it should be second line
            repeat
                ServLineDestPar.Next;
                CreateAppEntry(NewAllocEntryNo, ServLineDestPar."Document Type", ServLineDestPar."Document No.",
                  ServLineDestPar."Line No.", ResourceNo, 0, 0, false);
            until ServAllocAppSourcePar.Next = 0;
        end;
        ProcessMovement(NewAllocEntryNo, ResourceNo, DateStart, AllocTimeQty, 1, ServLaborAllocEntryPar.Status, -1, ServLaborAllocEntryPar.Travel);
        exit(NewLineNo);
    end;


    procedure GetQtyShareOfLineInAlloc(DocType: Integer; DocNo: Code[20]; LineNo: Integer; EntryNo: Integer) ShareOfLine: Decimal
    var
        ServAllocApp: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        QtyTotalOfApp: Decimal;
        MainAllocQty: Decimal;
        MainLineQty: Decimal;
    begin
        QtyTotalOfApp := 0;
        ShareOfLine := 1;
        ServAllocApp.Reset;
        ServAllocApp.SetRange("Allocation Entry No.", EntryNo);
        if ServAllocApp.FindFirst then begin
            if ServLaborAllocationEntry.Get(EntryNo) then
                MainAllocQty := ServLaborAllocationEntry."Quantity (Hours)"
            else
                MainAllocQty := 0;
            ServiceLine.Get(DocType, DocNo, LineNo);
            MainLineQty := ServiceLine.GetTimeQty;
            if ServAllocApp.Count > 1 then begin
                repeat
                    if ServiceLine.Get(DocType, DocNo, ServAllocApp."Document Line No.") then
                        QtyTotalOfApp += ServiceLine.GetTimeQty;
                until ServAllocApp.Next = 0;
                ShareOfLine := QtyTotalOfApp / MainLineQty;
            end;
        end;
        exit(ShareOfLine * 100);
    end;


    procedure GetEntryEndingTimeFull(EntryNo: Integer): Decimal
    var
        ServLaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
    begin
        //returns ending time of last allocation part if original is splitted
        FindSplitEntries(EntryNo, ServLaborAllocEntryTmp, 0, 1111);
        ServLaborAllocEntryTmp.Reset;
        if ServLaborAllocEntryTmp.FindLast then
            exit(ServLaborAllocEntryTmp."End Date-Time");
        exit(0);
    end;


    procedure CreateNewAllocEntry(StartingDateTime: Decimal; ResourceNo: Code[20]; Hours: Decimal; SourceType: Integer; SourceID: Code[20]; LineNo: Integer; ReasonCode: Code[10]; PlanningPolicy: Integer; FinishedHours: Decimal; RemainingHours: Decimal; Status: Integer): Integer
    var
        NewServLaborAllocEntry: Record "Serv. Labor Allocation Entry";
        NewAllocAppEntry: Record "Serv. Labor Alloc. Application";
        EntryNo: Integer;
    begin
        //returns new allocation entry no
        NewServLaborAllocEntry.Reset;
        NewServLaborAllocEntry.FindLast;
        EntryNo := NewServLaborAllocEntry."Entry No." + 1;

        NewServLaborAllocEntry.Init;
        NewServLaborAllocEntry."Entry No." := EntryNo;
        NewServLaborAllocEntry."Source Type" := NewServLaborAllocEntry."source type"::"Service Document";
        NewServLaborAllocEntry."Source Subtype" := SourceType;
        NewServLaborAllocEntry."Source ID" := SourceID;
        NewServLaborAllocEntry."Start Date-Time" := ROUND(StartingDateTime, 0.00001);
        NewServLaborAllocEntry."Quantity (Hours)" := Hours;
        NewServLaborAllocEntry."End Date-Time" := ROUND(StartingDateTime + NewServLaborAllocEntry."Quantity (Hours)" * 3.6, 0.00001);
        NewServLaborAllocEntry."Resource No." := ResourceNo;
        NewServLaborAllocEntry."User ID" := UserId;
        NewServLaborAllocEntry.Status := Status;
        NewServLaborAllocEntry."Reason Code" := ReasonCode;
        NewServLaborAllocEntry."Planning Policy" := PlanningPolicy;
        NewServLaborAllocEntry.Insert;

        CreateAppEntry(EntryNo, SourceType, SourceID, LineNo, ResourceNo, FinishedHours, RemainingHours, true);
        exit(EntryNo);
    end;


    procedure CreateAppEntry(EntryNo: Integer; DocType: Integer; DocNo: Code[20]; LineNo: Integer; ResourceNo: Code[20]; FinishedHours: Decimal; RemainingHours: Decimal; TimeLine: Boolean)
    var
        NewAllocAppEntry: Record "Serv. Labor Alloc. Application";
    begin
        NewAllocAppEntry.Init;
        NewAllocAppEntry."Allocation Entry No." := EntryNo;
        NewAllocAppEntry."Document Type" := DocType;
        NewAllocAppEntry."Document No." := DocNo;
        NewAllocAppEntry."Document Line No." := LineNo;
        NewAllocAppEntry."Resource No." := ResourceNo;
        NewAllocAppEntry."Time Line" := TimeLine;
        if TimeLine then begin
            NewAllocAppEntry."Finished Quantity (Hours)" := FinishedHours;
            NewAllocAppEntry."Remaining Quantity (Hours)" := RemainingHours;
        end else begin
            NewAllocAppEntry."Finished Quantity (Hours)" := 0;
            NewAllocAppEntry."Remaining Quantity (Hours)" := 0;
        end;
        NewAllocAppEntry.Insert(true);
    end;


    procedure CreateAppEntryByEntry(var ServLaborAllocationEntryPar: Record "Serv. Labor Allocation Entry"; var ServLaborAllocApplicationPar: Record "Serv. Labor Alloc. Application"; LineNo: Integer; FinishedHours: Decimal; RemainingHours: Decimal; TimeLine: Boolean)
    begin
        ServLaborAllocApplicationPar.Init;
        ServLaborAllocApplicationPar."Allocation Entry No." := ServLaborAllocationEntryPar."Entry No.";
        ServLaborAllocApplicationPar."Document Type" := ServLaborAllocationEntryPar."Source Subtype";
        ServLaborAllocApplicationPar."Document No." := ServLaborAllocationEntryPar."Source ID";
        ServLaborAllocApplicationPar."Document Line No." := LineNo;
        ServLaborAllocApplicationPar."Resource No." := ServLaborAllocationEntryPar."Resource No.";
        ServLaborAllocApplicationPar."Time Line" := TimeLine;
        if TimeLine then begin
            ServLaborAllocApplicationPar."Finished Quantity (Hours)" := FinishedHours;
            ServLaborAllocApplicationPar."Remaining Quantity (Hours)" := RemainingHours;
        end else begin
            ServLaborAllocApplicationPar."Finished Quantity (Hours)" := 0;
            ServLaborAllocApplicationPar."Remaining Quantity (Hours)" := 0;
        end;
        ServLaborAllocApplicationPar.Insert(true);
    end;


    procedure AdjustAllocEntryByShare(ServLinePar: Record "Service Line EDMS"; ShareQty: Decimal)
    var
        ServLaborAllocEntry: Record "Serv. Labor Allocation Entry";
        AllocAppEntry: Record "Serv. Labor Alloc. Application";
    begin
        if (ShareQty <> 100) then begin
            // need to update current entry quantity
            AllocAppEntry.Reset;
            AllocAppEntry.SetRange("Document Type", ServLinePar."Document Type");
            AllocAppEntry.SetRange("Document No.", ServLinePar."Document No.");
            AllocAppEntry.SetRange("Document Line No.", ServLinePar."Line No.");
            if not AllocAppEntry.FindFirst then
                exit;
            if ServLaborAllocEntry.Get(AllocAppEntry."Allocation Entry No.") then begin
                ServLaborAllocEntry."Quantity (Hours)" := ServLaborAllocEntry."Quantity (Hours)" * ShareQty / 100;
                ServLaborAllocEntry."End Date-Time" := ROUND(ServLaborAllocEntry."Start Date-Time" + ServLaborAllocEntry."Quantity (Hours)" * 3.6, 0.00001);

                if ServLaborAllocEntry."Quantity (Hours)" = 0 then
                    ServLaborAllocEntry.Delete(true)
                else
                    ServLaborAllocEntry.Modify(true);
                AllocAppEntry.Reset;
                AllocAppEntry.SetRange("Allocation Entry No.", ServLaborAllocEntry."Entry No.");
                if AllocAppEntry.FindFirst then begin
                    if AllocAppEntry."Finished Quantity (Hours)" > 0 then begin
                        AllocAppEntry."Finished Quantity (Hours)" := AllocAppEntry."Finished Quantity (Hours)" * ShareQty / 100;
                    end;
                    if AllocAppEntry."Remaining Quantity (Hours)" > 0 then begin
                        AllocAppEntry."Remaining Quantity (Hours)" := ServLaborAllocEntry."Quantity (Hours)";
                    end;
                    AllocAppEntry."Time Line" := true;
                    AllocAppEntry.Modify;
                end;
            end else begin
                if AllocAppEntry."Finished Quantity (Hours)" > 0 then begin
                    AllocAppEntry."Finished Quantity (Hours)" := AllocAppEntry."Finished Quantity (Hours)" * ShareQty / 100;
                end;
                AllocAppEntry.Modify;
            end;
        end;
    end;


    procedure LookupResourceToAllocEntry(AllocEntryNo: Code[20])
    var
        ResourceList: Page "Resource List";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        Resource: Record Resource;
        NewLineNo: Integer;
    begin
        if not CheckUserRightsAdv(2, LaborAllocEntry) then exit;

        Clear(ResourceList);

        ResourceList.LookupMode(true);

        if ResourceList.RunModal = Action::LookupOK then begin
            ResourceList.SetSelection(Resource);

            if Resource.FindFirst then begin
                if ServLaborAllocationEntry.Get(AllocEntryNo) then
                    repeat
                        AddResourceToAllocEntry(ServLaborAllocationEntry, LaborAllocApp, Resource."No.", 0, LaborAllocEntry, LaborAllocApp);
                    until Resource.Next = 0;
            end;
        end;
    end;


    procedure AddResourceToAllocEntry(var ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry"; var ServLaborAllocApplication: Record "Serv. Labor Alloc. Application"; ResourceNo: Code[20]; ApplyToEntryNo: Integer; var NewServLaborAllocEntry: Record "Serv. Labor Allocation Entry"; var NewServLaborAllocApplication: Record "Serv. Labor Alloc. Application"): Integer
    var
        TextNotLineFound: label 'For the location is not found service line.';
        EntryNo: Integer;
        LaborAllocEntryL: Record "Serv. Labor Allocation Entry";
    begin
        // actually it is not adding to allocation entry, but creating new entry with same pars and different resource
        ServLaborAllocApplication.SetRange("Resource No.");
        ServLaborAllocApplication.SetRange("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
        if not ServLaborAllocApplication.FindFirst then
            Error(TextNotLineFound);

        LaborAllocEntryL.Reset;
        LaborAllocEntryL.FindLast;
        EntryNo := LaborAllocEntryL."Entry No." + 1;

        NewServLaborAllocEntry.Init;
        NewServLaborAllocEntry."Entry No." := EntryNo;
        NewServLaborAllocEntry."Source Type" := NewServLaborAllocEntry."source type"::"Service Document";
        NewServLaborAllocEntry."Source Subtype" := ServLaborAllocationEntry."Source Subtype";
        NewServLaborAllocEntry."Source ID" := ServLaborAllocationEntry."Source ID";
        NewServLaborAllocEntry."Start Date-Time" := ROUND(ServLaborAllocationEntry."Start Date-Time", 0.00001);
        NewServLaborAllocEntry."Quantity (Hours)" := ServLaborAllocationEntry."Quantity (Hours)";
        NewServLaborAllocEntry."End Date-Time" := ROUND(ServLaborAllocationEntry."Start Date-Time" +
          NewServLaborAllocEntry."Quantity (Hours)" * 3.6, 0.00001);
        NewServLaborAllocEntry."Resource No." := ResourceNo;
        NewServLaborAllocEntry."User ID" := UserId;
        NewServLaborAllocEntry.Status := ServLaborAllocationEntry.Status;
        NewServLaborAllocEntry."Reason Code" := ServLaborAllocationEntry."Reason Code";
        NewServLaborAllocEntry."Planning Policy" := ServLaborAllocationEntry."Planning Policy";
        NewServLaborAllocEntry."Parent Alloc. Entry No." := ServLaborAllocationEntry."Entry No.";
        NewServLaborAllocEntry."Parent Link Synchronize" := true;
        NewServLaborAllocEntry.Insert;

        //ADJUST SOURCE ENTRY sets:
        if not ServLaborAllocationEntry."Parent Link Synchronize" then begin
            ServLaborAllocationEntry."Parent Link Synchronize" := true;
            ServLaborAllocationEntry.Modify;
        end;

        CreateAppEntryByEntry(NewServLaborAllocEntry, NewServLaborAllocApplication,
          ServLaborAllocApplication."Document Line No.", 0, ServLaborAllocationEntry."Quantity (Hours)", false);
        exit(EntryNo);
    end;


    procedure ShowServLineResources(var ServiceLine: Record "Service Line EDMS")
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        ServLaborAllocApplicationTemp: Record "Serv. Labor Alloc. Application" temporary;
    begin
        if not ServiceLine.FindSet then
            exit;
        ServLaborAllocApplicationTemp.Reset;
        ServLaborAllocApplicationTemp.DeleteAll;
        ServLaborAllocApplication.SetRange("Document Type", ServiceLine."Document Type");
        ServLaborAllocApplication.SetRange("Document No.", ServiceLine."Document No.");
        ServLaborAllocApplication.SetRange("Document Line No.", ServiceLine."Line No.");
        if ServLaborAllocApplication.FindFirst then
            repeat
                ServLaborAllocApplicationTemp := ServLaborAllocApplication;
                ServLaborAllocApplicationTemp.Insert;
            until ServLaborAllocApplication.Next = 0;
        Page.RunModal(0, ServLaborAllocApplicationTemp);
    end;


    procedure GetMainAllocEntrNo(EntryNo: Integer; RunModeFlags: Integer) RetEntryNo: Integer
    var
        LaborAllocEntryL: Record "Serv. Labor Allocation Entry";
        StatusArray: array[10] of Integer;
    begin
        // RunModeFlags = 1011, what statuses are taken in account REAden from right to left (On Hold,Finished,In Progress,Pending)
        AdjustFlagsToArray(RunModeFlags, StatusArray);

        RetEntryNo := EntryNo;
        if LaborAllocEntry.Get(EntryNo) then begin
            repeat
                LaborAllocEntry.Get(EntryNo);
                if IsIntInArrayTen(LaborAllocEntry.Status, StatusArray) then
                    RetEntryNo := LaborAllocEntry."Entry No.";
                EntryNo := LaborAllocEntry."Applies-to Entry No.";
            until LaborAllocEntry."Applies-to Entry No." = 0;
        end;
        exit(RetEntryNo);
    end;


    procedure FindSplitEntries(EntryNo: Integer; var LaborAllocEntryPar: Record "Serv. Labor Allocation Entry"; EntryType: Option Original,Next,Previous; RunModeFlags: Integer)
    var
        LaborAllocEntryLookIn: Record "Serv. Labor Allocation Entry";
        LaborAllocEntryCurr: Record "Serv. Labor Allocation Entry";
        StatusArray: array[10] of Integer;
    begin
        // RunModeFlags = 1011, that statuses are taken in account, readen from right to left (On Hold,Finished,In Progress,Pending)
        LaborAllocEntryCurr.Get(EntryNo);
        if RunModeFlags = 0 then begin  //15.08.2013 EDMS P8
                                        // that one is a case that need to take only one status records of source rec.
            case LaborAllocEntryCurr.Status of
                0:
                    RunModeFlags := 1;
                1:
                    RunModeFlags := 10;
                2:
                    RunModeFlags := 100;
                3:
                    RunModeFlags := 1000;
            end;
        end;
        AdjustFlagsToArray(RunModeFlags, StatusArray);

        if EntryType <> Entrytype::Previous then begin
            if not LaborAllocEntryPar.Get(LaborAllocEntryCurr."Entry No.") then begin
                if IsIntInArrayTen(LaborAllocEntryCurr.Status, StatusArray) then begin
                    LaborAllocEntryPar := LaborAllocEntryCurr;
                    LaborAllocEntryPar.Insert;
                end;
            end;
            LaborAllocEntryLookIn.Reset;
            LaborAllocEntryLookIn.SetRange("Applies-to Entry No.", EntryNo);
            if LaborAllocEntryLookIn.FindFirst then
                repeat
                    FindSplitEntries(LaborAllocEntryLookIn."Entry No.", LaborAllocEntryPar, 1, RunModeFlags);  //12.08.2013 EDMS P8
                until LaborAllocEntryLookIn.Next = 0;
        end;

        if EntryType <> Entrytype::Next then begin
            if not LaborAllocEntryPar.Get(LaborAllocEntryCurr."Entry No.") then begin
                if IsIntInArrayTen(LaborAllocEntryCurr.Status, StatusArray) then begin
                    LaborAllocEntryPar := LaborAllocEntryCurr;
                    LaborAllocEntryPar.Insert;
                end;
            end;
            if LaborAllocEntryCurr."Applies-to Entry No." > 0 then
                if LaborAllocEntryLookIn.Get(LaborAllocEntryCurr."Applies-to Entry No.") then
                    FindSplitEntries(LaborAllocEntryLookIn."Entry No.", LaborAllocEntryPar, 2, RunModeFlags);  //12.08.2013 EDMS P8
        end;
    end;


    procedure FindRelatedEntries(EntryNo: Integer; var LaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary; DeleteRecs: Boolean; RunModeFlags: Integer) RetRecCount: Integer
    var
        LaborAllocEntryL: Record "Serv. Labor Allocation Entry";
        StatusArray: array[10] of Integer;
    begin
        // RunModeFlags = 1011, what statuses are taken in account REAden from right to left (On Hold,Finished,In Progress,Pending)
        AdjustFlagsToArray(RunModeFlags, StatusArray);

        // it is supposed that related as child and parent directions
        if DeleteRecs then begin
            //FIND parent part, SO THAT part is to get rid of recursive loop
            if LaborAllocEntry.Get(EntryNo) then
                if LaborAllocEntry."Parent Alloc. Entry No." > 0 then begin
                    FindRelatedEntries(LaborAllocEntry."Parent Alloc. Entry No.", LaborAllocEntryTmp, true, 1011);
                    exit(LaborAllocEntryTmp.Count);
                end;
            LaborAllocEntryTmp.Reset;
            LaborAllocEntryTmp.DeleteAll;
        end;
        if not LaborAllocEntry.Get(EntryNo) then
            exit;
        if not LaborAllocEntryTmp.Get(EntryNo) then begin
            if IsIntInArrayTen(LaborAllocEntry.Status, StatusArray) then begin
                LaborAllocEntryTmp := LaborAllocEntry;
                LaborAllocEntryTmp.Insert;
            end;
        end;
        //FIND child part
        LaborAllocEntryL.SetCurrentkey("Parent Alloc. Entry No.");
        LaborAllocEntryL.SetRange("Parent Alloc. Entry No.", EntryNo);
        if LaborAllocEntryL.FindFirst then
            repeat
                FindRelatedEntries(LaborAllocEntryL."Entry No.", LaborAllocEntryTmp, false, 1011);
            until LaborAllocEntryL.Next = 0;
        exit(LaborAllocEntryTmp.Count);
    end;


    procedure FindFirstAppliedEntryNo() RetValue: Integer
    var
        LaborAllocEntryParent: Record "Serv. Labor Allocation Entry";
    begin
        if LaborAllocEntry."Applies-to Entry No." > 0 then begin
            LaborAllocEntry.Get(LaborAllocEntry."Applies-to Entry No.");
            exit(FindFirstAppliedEntryNo)
        end else
            exit(LaborAllocEntry."Entry No.");
    end;


    procedure FindAllocEntriesOfServLine(ServiceLinePar: Record "Service Line EDMS"; var LaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary; RunModeFlags: Text[30])
    var
        LaborAllocEntryL: Record "Serv. Labor Allocation Entry";
        LaborAllocAppL: Record "Serv. Labor Alloc. Application";
    begin
        LaborAllocAppL.Reset;
    end;


    procedure SynchroniseRelatedEntry(SourceLaborAllocEntryNo: Integer; DestLaborAllocEntryNo: Integer) SynchronisedCount: Integer
    var
        SourceLaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        DestLaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocEntryL: Record "Serv. Labor Allocation Entry";
        EntryNo: Integer;
        DestStatusBefore: Integer;
    begin
        FindSplitEntries(SourceLaborAllocEntryNo, SourceLaborAllocEntryTmp, 0, 1111);
        FindSplitEntries(DestLaborAllocEntryNo, DestLaborAllocEntryTmp, 0, 1011);
        DestLaborAllocEntryTmp.FindFirst;
        LaborAllocEntry.Reset;
        if SourceLaborAllocEntryTmp.Count > DestLaborAllocEntryTmp.Count then begin
            LaborAllocEntry.Reset;
            LaborAllocEntry.FindLast;
            EntryNo := LaborAllocEntry."Entry No.";
            DestLaborAllocEntryTmp.FindLast;
            repeat
                InsertAllocationEntry(LaborAllocEntry, LaborAllocApp, DestLaborAllocEntryTmp."Resource No.",
                                      DestLaborAllocEntryTmp."Start Date-Time", DestLaborAllocEntryTmp."Quantity (Hours)",
                                      DestLaborAllocEntryTmp."Source Type", DestLaborAllocEntryTmp."Source Subtype",
                                      DestLaborAllocEntryTmp."Source ID", DestLaborAllocEntryNo, true, LaborAllocEntry.Travel);
                DestLaborAllocEntryTmp := LaborAllocEntry;
                DestLaborAllocEntryTmp.Insert;
            until SourceLaborAllocEntryTmp.Count = DestLaborAllocEntryTmp.Count;
        end else begin
            if SourceLaborAllocEntryTmp.Count < DestLaborAllocEntryTmp.Count then begin
                repeat
                    DestLaborAllocEntryTmp.FindLast;
                    DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, DestLaborAllocEntryTmp."Entry No.", 11111);
                    DestLaborAllocEntryTmp.Delete;
                until SourceLaborAllocEntryTmp.Count = DestLaborAllocEntryTmp.Count;
            end;
        end;
        // now is going to synchr. times
        SourceLaborAllocEntryTmp.FindFirst;
        DestLaborAllocEntryTmp.FindFirst;
        EntryNo := 0;
        repeat
            LaborAllocEntry.Get(DestLaborAllocEntryTmp."Entry No.");
            DestStatusBefore := LaborAllocEntry.Status;
            if DestLaborAllocEntryTmp."Applies-to Entry No." = 0 then
                DestLaborAllocEntryTmp."Applies-to Entry No." := SourceLaborAllocEntryTmp."Applies-to Entry No.";
            ModifyAllocationEntry(LaborAllocEntry, LaborAllocApp, DestLaborAllocEntryTmp."Entry No.",
                                  DestLaborAllocEntryTmp."Resource No.",
                                  SourceLaborAllocEntryTmp."Start Date-Time", SourceLaborAllocEntryTmp."Quantity (Hours)",
                                  false, SourceLaborAllocEntryTmp.Status, DestLaborAllocEntryTmp."Applies-to Entry No.", LaborAllocEntry.Travel);
            if DestStatusBefore <> SourceLaborAllocEntryTmp.Status then begin
                AllocationStatus := SourceLaborAllocEntryTmp.Status;
                ReasonCodeGlobal := SourceLaborAllocEntryTmp."Reason Code";
                ChangeStatus(LaborAllocEntry);
                ChangeServiceLineStatus(LaborAllocEntry."Entry No.", false);
            end;
            EntryNo := LaborAllocEntry."Entry No.";
            DestLaborAllocEntryTmp.Next;
        until SourceLaborAllocEntryTmp.Next = 0;
        exit(SynchronisedCount);
    end;


    procedure SynchroniseRelatedEntries(EntryNo: Integer)
    var
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
    begin
        EntryNo := GetMainAllocEntrNo(EntryNo, 1011);
        LaborAllocEntry.Get(EntryNo);
        FindRelatedEntries(EntryNo, LaborAllocEntryTemp, true, 1011);
        if LaborAllocEntryTemp.Get(EntryNo) then
            LaborAllocEntryTemp.Delete;
        if LaborAllocEntryTemp.FindFirst then
            repeat
                if LaborAllocEntryTemp."Parent Link Synchronize" or (LaborAllocEntry."Parent Link Synchronize" and
                    (LaborAllocEntry."Entry No." <> LaborAllocEntryTemp."Entry No.")) then begin
                    SynchroniseRelatedEntry(EntryNo, LaborAllocEntryTemp."Entry No.");
                end;
            until LaborAllocEntryTemp.Next = 0;
    end;


    procedure AllocationSetParam(var SourceType: Option ,"Service Document","Standard Event"; var QtyToAllocate: Decimal; var ServiceLineSrcPar: Record "Service Line EDMS"; var ServiceLinePar: Record "Service Line EDMS" temporary; var LineNo: Integer; Mode: Option "New Allocation","Move Existing","Split Existing","Break"; SourceSubType: Option Quote,"Order"; SourceID: Code[20])
    var
        ServiceLineLoc: Record "Service Line EDMS";
        IsServiceHeader: Boolean;
        ishandled : boolean;
    begin
        case SourceType of
            Sourcetype::"Standard Event":
                begin
                    if QtyToAllocate = 0 then
                        QtyToAllocate := 1;

                end;
            Sourcetype::"Service Document":
                begin
                    OnBeforeAllocationSetParam(ServiceLineSrcPar,LineNo,ishandled);
                      if (ServiceLineSrcPar.FindFirst and (ServiceLineSrcPar."Line No." > 0)) or ishandled then begin //Service Line Allocation
                        if ServiceLineSrcPar.Count = 1 then
                            LineNo := ServiceLineSrcPar."Line No.";
                        QtyToAllocate := 0;
                        repeat
                            ServiceLinePar := ServiceLineSrcPar;
                            ServiceLinePar.Insert;
                            if Mode = Mode::"New Allocation" then
                                QtyToAllocate += ServiceLinePar.GetTimeQty;
                        until ServiceLineSrcPar.Next = 0;
                    end else begin //Service Header Allocation
                        if Mode = Mode::"New Allocation" then begin
                            ServiceLineLoc.Reset;
                            ServiceLineLoc.SetRange("Document Type", SourceSubType);
                            ServiceLineLoc.SetRange("Document No.", SourceID);
                            ServiceLineLoc.SetRange(Type, ServiceLineLoc.Type::Labor);
                            if ServiceLineLoc.FindFirst then begin
                                QtyToAllocate := 0;
                                repeat
                                    QtyToAllocate += ServiceLineLoc.GetTimeQty;
                                until ServiceLineLoc.Next = 0;
                            end;
                        end;

                        ServiceLinePar.Reset;
                        ServiceLinePar.SetRange("Document Type", SourceSubType);
                        ServiceLinePar.SetRange("Document No.", SourceID);
                        ServiceLinePar.SetRange("Line No.", 0);
                        if not ServiceLinePar.FindFirst then begin
                            ServiceLinePar.Init;
                            ServiceLinePar."Document Type" := SourceSubType;
                            ServiceLinePar."Document No." := SourceID;
                            ServiceLinePar."Line No." := 0;
                            ServiceLinePar.Insert;
                        end;
                    end;
                end;

        end;

        QtyToAllocate := RoundQtyHours(QtyToAllocate, 0);
    end;


    procedure RoundQtyHours(QtyToRound: Decimal; RunMode: Integer): Decimal
    begin
        exit(ROUND(QtyToRound, 0.1));
    end;


    procedure UpdateAllocDetailsText(EntryNo: Integer; DetailsText: Text[250]; DetEntryNo: Integer)
    var
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationDetailLoc: Record "Serv. Allocation Description";
        Isfound: Boolean;
    begin
        //24.10.2013 EDMS P8
        if EntryNo = 0 then
            EntryNo := LaborAllocEntry."Entry No.";
        if LaborAllocEntryLoc.Get(EntryNo) then begin
            Isfound := false;
            if (DetEntryNo <> LaborAllocEntryLoc."Detail Entry No.") then begin
                if ServLaborAllocationDetailLoc.Get(DetEntryNo) then begin
                    if ServLaborAllocationDetailLoc.Description = DetailsText then begin
                        LaborAllocEntryLoc.Validate("Detail Entry No.", DetEntryNo);
                        LaborAllocEntryLoc.Modify(true);
                        Isfound := true;
                    end;
                end;
            end;
            if not Isfound then begin
                if ServLaborAllocationDetailLoc.Get(LaborAllocEntryLoc."Detail Entry No.") then begin
                    if ServLaborAllocationDetailLoc.Description = DetailsText then begin
                        //NO NEED CHANGE
                        Isfound := true;
                    end;
                end;
            end;
            if not Isfound then begin
                ServLaborAllocationDetailLoc."Entry No." := 0;
                ServLaborAllocationDetailLoc.Description := DetailsText;
                ServLaborAllocationDetailLoc.Insert(true);
                DetEntryNo := ServLaborAllocationDetailLoc."Entry No.";
                LaborAllocEntry.Validate("Detail Entry No.", DetEntryNo);
                LaborAllocEntry.Modify(true);
            end;
        end;
    end;


    procedure ErrorWithRefresh(MsgText: Text[1024])
    begin
        ErrorStatus := 2;
        ErrorMsgText := MsgText;
    end;


    procedure SetErrorStatus(ErrorStatusPar: Integer)
    begin
        ErrorStatus := ErrorStatusPar;
    end;


    procedure GetErrorStatus(): Integer
    begin
        exit(ErrorStatus);
    end;


    procedure GetErrorMsgText(): Text[1024]
    begin
        exit(ErrorMsgText);
    end;


    procedure SetAllocationStatus(AllocationStatus1: Option Pending,"In Process",Finished,"On Hold")
    begin
        AllocationStatus := AllocationStatus1;
    end;


    procedure FinishOtherTasks(ResourceNo: Code[20]; EntryNo: Integer; StartingDateTime: Decimal)
    var
        OnDate: Date;
        OnTime: Time;
        MainAllocEntryNo: Integer;
        MainLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        StartFinishAllocation: Page "Time Registration";
        StatusToSet: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        SingleInstanceManagment: Codeunit SingleInstanceManagement;
        Resource: Record Resource;
    begin
        if SingleInstanceManagment.GetTimeJournalFlag then
            exit;
        OnDate := DateTimeMgt.Datetime2Date(StartingDateTime);
        OnTime := DateTimeMgt.Datetime2Time(StartingDateTime);

        ServiceSetup.Get;
        Resource.Get(ResourceNo);
        case Resource."On Task Start" of
            Resource."on task start"::"Hold Other Tasks":
                begin
                    LaborAllocEntry.Reset;
                    LaborAllocEntry.SetRange("Resource No.", ResourceNo);
                    LaborAllocEntry.SetRange(Status, LaborAllocEntry.Status::"In Progress");
                    LaborAllocEntry.SetFilter(LaborAllocEntry."Entry No.", '<>%1', EntryNo);
                    LaborAllocEntry.SetFilter(LaborAllocEntry."Applies-to Entry No.", '<>%1', EntryNo);
                    LaborAllocEntry.SetFilter("Source ID", '<>%1', ServiceSetup."Default Idle Event");
                    if LaborAllocEntry.FindFirst then begin
                        repeat
                            AllocationStatus := Allocationstatus::"On Hold";
                            MainAllocEntryNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
                            if MainLaborAllocationEntry.Get(MainAllocEntryNo) and
                              (MainLaborAllocationEntry.Status = MainLaborAllocationEntry.Status::"In Progress") then begin
                                StatusToSet := Statustoset::"On Hold";
                                SingleInstanceManagment.SetCurrAllocation(MainLaborAllocationEntry."Entry No.");
                                StartFinishAllocation.SetParam(ResourceNo,
                                  DateTimeMgt.Datetime(OnDate, OnTime),
                                  MainLaborAllocationEntry."Quantity (Hours)",
                                  MainLaborAllocationEntry."Source Type",
                                  MainLaborAllocationEntry."Source Subtype",
                                  MainLaborAllocationEntry."Source ID",
                                  StatusToSet,
                                  0, '');
                                StartFinishAllocation.StartEndWork;
                            end;
                            //WriteAllocationEntryEnd(LaborAllocEntry."Entry No.", StartingDateTime, FALSE, '',LaborAllocEntry.Travel);
                            ResourceTimeRegMgt.AddTimeRegEntries('Onhold', MainLaborAllocationEntry, MainLaborAllocationEntry."Resource No.", OnDate, OnTime);
                        until LaborAllocEntry.Next = 0
                    end;
                end;
            Resource."on task start"::"Complete Other Tasks":
                begin
                    LaborAllocEntry.Reset;
                    LaborAllocEntry.SetRange("Resource No.", ResourceNo);
                    LaborAllocEntry.SetFilter(Status, '%1', LaborAllocEntry.Status::"In Progress");
                    LaborAllocEntry.SetFilter(LaborAllocEntry."Entry No.", '<>%1', EntryNo);
                    LaborAllocEntry.SetFilter(LaborAllocEntry."Applies-to Entry No.", '<>%1', EntryNo);
                    LaborAllocEntry.SetFilter("Source ID", '<>%1', ServiceSetup."Default Idle Event");
                    if LaborAllocEntry.FindFirst then begin
                        repeat
                            AllocationStatus := Allocationstatus::Finished;
                            MainAllocEntryNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
                            if MainLaborAllocationEntry.Get(MainAllocEntryNo) and
                              (MainLaborAllocationEntry.Status = MainLaborAllocationEntry.Status::"In Progress") then begin
                                StatusToSet := Statustoset::"Finish All";
                                SingleInstanceManagment.SetCurrAllocation(MainLaborAllocationEntry."Entry No.");
                                StartFinishAllocation.SetParam(ResourceNo,
                                  DateTimeMgt.Datetime(OnDate, OnTime),
                                  MainLaborAllocationEntry."Quantity (Hours)",
                                  MainLaborAllocationEntry."Source Type",
                                  MainLaborAllocationEntry."Source Subtype",
                                  MainLaborAllocationEntry."Source ID",
                                  StatusToSet,
                                  0, '');
                                StartFinishAllocation.StartEndWork;
                            end;
                            //WriteAllocationEntryEnd(LaborAllocEntry."Entry No.", StartingDateTime, FALSE, '',LaborAllocEntry.Travel);
                            ResourceTimeRegMgt.AddTimeRegEntries('Complete', LaborAllocEntry, LaborAllocEntry."Resource No.", OnDate, OnTime);
                        until LaborAllocEntry.Next = 0
                    end;
                end;
        end;
    end;


    procedure "--SERVICE RESOURCES--"()
    begin
    end;


    procedure GetRelatedResources(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; RunMode: Integer) RetValue: Text[250]
    var
        ServLaborApplication: Record "Serv. Labor Alloc. Application";
        ServLaborApplicationTmp: Record "Serv. Labor Alloc. Application" temporary;
        ServiceLine: Record "Service Line EDMS";
        ServLaborApplicationLoc: Record "Serv. Labor Alloc. Application";
        isItDocAllocation: Boolean;
        StatusArray: array[10] of Integer;
        isTempTableUse: Boolean;
    begin
        //RunMode first digit from right means should it be used temp resource table
        RetValue := '';
        if LineType = ServiceLine.Type::Labor then begin
            ServLaborApplicationTmp.Reset;
            ServLaborApplicationTmp.DeleteAll;

            ServLaborApplication.Reset;
            ServLaborApplication.SetRange("Document Type", DocType);
            ServLaborApplication.SetRange("Document No.", DocNo);
            if LineNo = 0 then begin
                // in case that requested for document:
                ServLaborApplication.SetRange("Document Line No.");
            end else begin
                ServLaborApplication.SetRange("Document Line No.", 0);  // at first try to find document allocation
                if not ServLaborApplication.FindFirst then
                    ServLaborApplication.SetRange("Document Line No.", LineNo);
            end;
            if ServLaborApplication.FindFirst then begin
                repeat
                    ServLaborApplicationTmp.SetRange("Resource No.", ServLaborApplication."Resource No.");
                    if not ServLaborApplicationTmp.FindFirst then begin
                        RetValue += ServLaborApplication."Resource No." + ',';
                        ServLaborApplicationTmp := ServLaborApplication;
                        ServLaborApplicationTmp.Insert;
                    end;
                until ServLaborApplication.Next = 0;
                RetValue := CopyStr(RetValue, 1, StrLen(RetValue) - 1);
            end;
        end;
        exit(RetValue);
    end;


    procedure SetRelatedResources(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; RecourcesTextSource: Text[250]; RunMode: Integer) ResourcesCount: Integer
    var
        ServLaborApplication: Record "Serv. Labor Alloc. Application";
        Posit: Integer;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ResourceToAdd: Text[30];
        Resource: Record Resource;
        RecourcesText: Text[250];
        RecourcesTextToModify: Text[250];
        AllocEntryNo: Integer;
        isItDocAllocation: Boolean;
        divResult: Integer;
        isItAllowedMessage: Boolean;
        ServiceLine: Record "Service Line EDMS";
    begin
        //RunMode = 0 - normal; 1 - no messages; second digit (tens) - is it document allocation
        ServiceSetup.Get;
        isItAllowedMessage := ((RunMode MOD 10) = 0);
        divResult := (RunMode DIV 10);
        isItDocAllocation := ((divResult > 0) and ((divResult MOD 10) > 0));
        if ((LineNo = 0) and not isItDocAllocation) then
            Error(Text148);

        RecourcesText := RecourcesTextSource;
        ResourcesCount := 0;
        if LineType = ServiceLine.Type::Labor then begin
            ServLaborApplication.SetRange("Document Type", DocType);
            ServLaborApplication.SetRange("Document No.", DocNo);
            ServLaborApplication.SetRange("Document Line No.", LineNo);
            if not ServLaborApplication.FindFirst then begin
                ServLaborApplication.SetRange("Document Line No.", 0);
                // actually for nowdays such case is unpossible, but in future...
                if ServLaborApplication.FindFirst then
                    if isItAllowedMessage then begin
                        if not Confirm(Text147, false) then
                            exit;
                    end else
                        exit;
            end;
            ServLaborApplication.SetRange("Document Line No.", LineNo);
            repeat
                Posit := StrPos(RecourcesText, ',');
                if Posit > 0 then begin
                    ResourceToAdd := CopyStr(RecourcesText, 1, Posit - 1);
                    RecourcesText := CopyStr(RecourcesText, Posit + 1, StrLen(RecourcesText) - Posit);
                end else begin
                    ResourceToAdd := RecourcesText;
                    RecourcesText := '';
                end;
                if Resource.Get(ResourceToAdd) then begin
                    ServLaborApplication.SetRange("Resource No.", ResourceToAdd);
                    if not ServLaborApplication.FindLast then begin
                        Resource.TestField(Blocked, false);

                        ServLaborApplication.Init;
                        ServLaborApplication."Allocation Entry No." := 0;
                        ServLaborApplication."Document Type" := DocType;
                        ServLaborApplication."Document No." := DocNo;
                        ServLaborApplication."Document Line No." := LineNo;
                        ServLaborApplication."Resource No." := ResourceToAdd;
                        ServLaborApplication.Insert(true);
                    end;
                end;
            until RecourcesText = '';
            ServLaborApplication.SetRange("Resource No.");
            if isItDocAllocation then
                ServLaborApplication.SetRange("Document Line No.", 0);
            if ServLaborApplication.FindFirst then
                repeat
                    Posit := StrPos(RecourcesTextSource, ServLaborApplication."Resource No.");
                    if not (Posit > 0) then begin
                        ServLaborApplication.Delete(true);
                        ServLaborApplication.FindFirst;
                    end;
                until ServLaborApplication.Next = 0;
            if ServLaborApplication.FindFirst then begin
                Posit := StrPos(RecourcesTextSource, ServLaborApplication."Resource No.");
                if not (Posit > 0) then
                    ServLaborApplication.Delete(true);
            end;
            if ServLaborApplication.FindFirst then
                repeat
                    RecourcesTextToModify += ServLaborApplication."Resource No." + ',';
                until ServLaborApplication.Next = 0;
            if StrLen(RecourcesTextToModify) > 0 then
                RecourcesTextToModify := CopyStr(RecourcesTextToModify, 1, StrLen(RecourcesTextToModify) - 1);

        end;
        exit(ServLaborApplication.Count);
    end;


    procedure RelatedResourcesList(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; var RelatedResources: Text[250])
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
    begin
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Document Type", DocType);
        ServLaborAllocApplication.SetRange("Document No.", DocNo);
        ServLaborAllocApplication.SetRange("Document Line No.", LineNo);
        if LineNo < 0 then
            ServLaborAllocApplication.SetRange("Document Line No.");
        Page.RunModal(Page::"Service Line Resources", ServLaborAllocApplication);
        RelatedResources := GetRelatedResources(DocType, DocNo, LineType, LineNo, 0);
    end;


    procedure ResourcesList(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; var RelatedResources: Text[250])
    var
        ServLaborApplication: Record "Serv. Labor Alloc. Application";
        Resource: Record Resource;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
    begin
        //??? checkstatusopen
        // not used for now, it is supposed to be used for lookup (case then SS unactive and only one resource is set)

        ServiceSetup.Get;
        if ServiceSetup."Service Schedule Active" then
            Error(Text146);

        ServLaborApplication.Reset;
        ServLaborApplication.SetRange("Document Type", DocType);
        ServLaborApplication.SetRange("Document No.", DocNo);
        ServLaborApplication.SetRange("Document Line No.", LineNo);
        if ServLaborApplication.FindFirst then
            if Resource.Get(ServLaborApplication."Resource No.") then;
        if Page.RunModal(0, Resource) = Action::OK then begin
            RelatedResources := Resource."No.";
            if ServLaborApplication.FindFirst then begin
                ServLaborApplication.SetRange("Resource No.", Resource."No.");
                if ServLaborApplication.FindFirst then begin
                    ServLaborApplication.SetRange("Resource No.");
                    ServLaborApplication.SetFilter("Resource No.", '<>%1', Resource."No.");
                    if ServLaborApplication.FindFirst then
                        ServLaborApplication.DeleteAll(true);
                end else begin
                    ServLaborApplication.SetRange("Resource No.");
                    ServLaborApplication.FindFirst;
                    ServLaborApplication."Resource No." := Resource."No.";
                    ServLaborApplication.Modify;
                    ServLaborApplication.FindLast;
                    repeat
                        ServLaborApplication.Delete(true);
                    until ServLaborApplication."Resource No." = Resource."No.";
                end;
            end else begin
                ServLaborApplication.Init;
                ServLaborApplication."Allocation Entry No." := 0;
                ServLaborApplication."Document Type" := DocType;
                ServLaborApplication."Document No." := DocNo;
                ServLaborApplication."Document Line No." := LineNo;
                ServLaborApplication."Resource No." := Resource."No.";
                ServLaborApplication.Insert(true);
            end;
        end;
    end;


    procedure ResourcesCopyLineToLine(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; DocTypeDestin: Integer; DocNoDestin: Code[20]; LineNoDestin: Integer)
    var
        ServiceLineDest: Record "Service Line EDMS";
        ResourcesText: Text[250];
    begin
        //Allocation Entry No.,Document Type,Document No.,Line No.
        ServiceSetup.Get;
        if not ServiceSetup."Service Schedule Active" then begin
            ResourcesText := GetRelatedResources(DocType, DocNo, LineType, LineNo, 0);
            if ServiceLineDest.Get(DocTypeDestin, DocNoDestin, LineNoDestin) then
                SetRelatedResources(DocType, DocNo, LineType, LineNo, ResourcesText, 0);
        end;
        //means that schedule entries we are not going to copy
    end;


    procedure FillRelatedApplicOfEntry(var ServLaborAllocApplicationPar: Record "Serv. Labor Alloc. Application"; EntryNoPar: Integer; var LineNoPar: Integer; DocType: Integer; DocNo: Code[20]; ResourceNoPar: Code[20]; NextNewAllocEntryNo: Integer)
    var
        LaborAllocEntryL: Record "Serv. Labor Allocation Entry";
        LaborAllocApplicationL: Record "Serv. Labor Alloc. Application";
        ServLaborAllocationEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
    begin
        if LaborAllocEntryL.Get(EntryNoPar) then begin
            LaborAllocApplicationL.SetRange("Document Type", LaborAllocEntryL."Source Subtype");
            LaborAllocApplicationL.SetRange("Document No.", LaborAllocEntryL."Source ID");
            LaborAllocApplicationL.SetRange("Allocation Entry No.", LaborAllocEntryL."Entry No.");
            if LaborAllocApplicationL.FindFirst then
                LineNoPar := LaborAllocApplicationL."Document Line No.";

            FindRelatedEntries(EntryNoPar, ServLaborAllocationEntryTmp, true, 1011);
            LaborAllocApplicationL.Reset;
            if ServLaborAllocationEntryTmp.FindFirst then
                repeat
                    LaborAllocApplicationL.SetRange("Document Type", ServLaborAllocationEntryTmp."Source Subtype");
                    LaborAllocApplicationL.SetRange("Document No.", ServLaborAllocationEntryTmp."Source ID");
                    LaborAllocApplicationL.SetRange("Allocation Entry No.", ServLaborAllocationEntryTmp."Entry No.");
                    if LaborAllocApplicationL.FindFirst then
                        if LaborAllocApplicationL.FindFirst then begin
                            ServLaborAllocApplicationPar := LaborAllocApplicationL;
                            ServLaborAllocApplicationPar.Insert(true);
                        end;
                until ServLaborAllocationEntryTmp.Next = 0;
        end else begin
            // means new entry
            ServLaborAllocApplicationPar."Allocation Entry No." := NextNewAllocEntryNo;
            ServLaborAllocApplicationPar."Document Type" := DocType;
            ServLaborAllocApplicationPar."Document No." := DocNo;
            ServLaborAllocApplicationPar."Document Line No." := LineNoPar;
            ServLaborAllocApplicationPar."Resource No." := ResourceNoPar;
            ServLaborAllocApplicationPar.Insert(true);
        end;
    end;


    procedure RemoveDuplicates(var ServLaborApplication: Record "Serv. Labor Alloc. Application")
    var
        ServLaborApplicationLoc: Record "Serv. Labor Alloc. Application";
        ServLaborApplicationLoc2: Record "Serv. Labor Alloc. Application";
    begin
        if ServLaborApplication.FindFirst then begin
            // THAT part to remove duplicates that are not in schedule
            ServLaborApplicationLoc.Reset;
            ServLaborApplicationLoc.SetRange("Document Type", ServLaborApplication."Document Type");
            ServLaborApplicationLoc.SetRange("Document No.", ServLaborApplication."Document No.");
            ServLaborApplicationLoc.SetRange("Document Line No.", ServLaborApplication."Document Line No.");
            ServLaborApplicationLoc.SetRange("Allocation Entry No.", 0);
            repeat
                ServLaborApplicationLoc.SetRange("Resource No.", ServLaborApplication."Resource No.");
                if ServLaborApplicationLoc.FindSet then begin
                    ServLaborApplicationLoc2.CopyFilters(ServLaborApplicationLoc);
                    ServLaborApplicationLoc2.SetFilter("Allocation Entry No.", '>0');
                    if ServLaborApplicationLoc2.FindSet then begin
                        ServLaborApplicationLoc.DeleteAll(true);
                        ServLaborApplication.FindFirst;
                    end else begin
                        if ServLaborApplicationLoc.Count > 1 then begin
                            repeat
                                ServLaborApplicationLoc.FindFirst;
                                ServLaborApplicationLoc.Delete(true);
                            until ServLaborApplicationLoc.Count <= 1;
                            ServLaborApplication.FindFirst;
                        end;
                    end;
                end;
            until ServLaborApplication.Next = 0;
        end;
    end;


    procedure "--SMALL TECHN--"()
    begin
    end;


    procedure CutNextDigit(var Flags: Integer) RetValue: Integer
    begin
        RetValue := Flags MOD 10;
        Flags := Flags DIV 10;
        exit(RetValue);
    end;


    procedure AdjustFlagsToArray(Flags: Integer; var ArrayDMS: array[10] of Integer)
    var
        i: Integer;
    begin
        for i := 1 to 10 do begin
            if (CutNextDigit(Flags) > 0) then
                ArrayDMS[i] := i - 1
            else
                ArrayDMS[i] := -1;
        end;
    end;


    procedure IsIntInArrayTen(CheckValue: Integer; var ArrayDMS: array[10] of Integer) RetValue: Boolean
    var
        i: Integer;
    begin
        for i := 1 to 10 do begin
            if (CheckValue = ArrayDMS[i]) then
                RetValue := true;
        end;

        exit(RetValue);
    end;


    procedure CopyServLaborAllocAppl(FromDocType: Option Quote,"Order","Return Order",Invoice,"Credit Memo","Blanket Order"; FromDocNo: Code[20]; FromLineNo: Integer; IsPosted: Boolean; ToServLine: Record "Service Line EDMS")
    var
        FromServLaborAllocAppl: Record "Serv. Labor Alloc. Application";
        NewServLaborAllocAppl: Record "Serv. Labor Alloc. Application";
    begin
        FromServLaborAllocAppl.Reset;
        FromServLaborAllocAppl.SetRange("Document Type", FromDocType);
        FromServLaborAllocAppl.SetRange("Document No.", FromDocNo);
        FromServLaborAllocAppl.SetRange("Document Line No.", FromLineNo);
        FromServLaborAllocAppl.SetRange(Posted, IsPosted);
        if FromServLaborAllocAppl.FindSet then
            repeat
                if Resource.Get(FromServLaborAllocAppl."Resource No.") then begin
                    Resource.TestField(Blocked, false);
                    NewServLaborAllocAppl.Init;
                    NewServLaborAllocAppl.TransferFields(FromServLaborAllocAppl, false);
                    NewServLaborAllocAppl."Allocation Entry No." := 0;
                    NewServLaborAllocAppl."Document Type" := ToServLine."Document Type";
                    NewServLaborAllocAppl."Document No." := ToServLine."Document No.";
                    NewServLaborAllocAppl."Document Line No." := ToServLine."Line No.";
                    NewServLaborAllocAppl.Posted := false;
                    NewServLaborAllocAppl.Insert(true);
                end;
            until FromServLaborAllocAppl.Next = 0;
    end;


    procedure CancelAllocation(AllocationStatus1: Option Pending,"In Progress","Finish All","Finish Part","On Hold"; StartingDateTime: Decimal; ShowDialog: Boolean)
    var
        DoReplan: Boolean;
        Hours: Decimal;
        LaborAllocEntry2: Record "Serv. Labor Allocation Entry";
        ServSchedAddInMgt: Codeunit "Serv. Schedule Web Add-In Mgt.";
        Travel: Boolean;
    begin
        if ShowDialog then
            if not Confirm(Text161) then
                exit;

        if not LaborAllocEntry.Get(SingleInstanceMgt.GetAllocationEntryNo) then begin
            Message(Text121);
            exit;
        end;

        if not CheckUserRightsAdv(1, LaborAllocEntry) then
            exit;

        if AllocationStatus1 = Allocationstatus1::Pending then begin
            if (LaborAllocEntry.Status = LaborAllocEntry.Status::Pending) and not ShowDialog then
                exit;

            if LaborAllocEntry.Status <> LaborAllocEntry.Status::"In Progress" then
                Error(Text162);

            Hours := LaborAllocEntry."Quantity (Hours)";
            ReasonCodeGlobal := LaborAllocEntry."Reason Code";
            DoReplan := false;
            AllocationStatus := Allocationstatus::Pending;
            ChangeAllocationStatus := true;
            Travel := LaborAllocEntry.Travel;

            WriteAllocationEntries(LaborAllocEntry."Resource No.", StartingDateTime, Hours,
                                   LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                   LaborAllocEntry."Source ID", 1, LaborAllocEntry."Entry No.", DoReplan, AllocationStatus, false, Travel);

            // Cancel Start Allocations for Applied Entries too
            LaborAllocEntry2.Reset;
            LaborAllocEntry2.SetRange("Applies-to Entry No.", LaborAllocEntry."Entry No.");
            if LaborAllocEntry2.FindFirst then
                ServSchedAddInMgt.CancelStartAllocation(LaborAllocEntry2."Entry No.", LaborAllocEntry2."Resource No.", LaborAllocEntry2."Start Date-Time", LaborAllocEntry2."End Date-Time", false);
        end;
    end;


    procedure CopyServLaborAllocApplFromDetServLedg(FromDocType: Option Quote,"Order","Return Order",Invoice,"Credit Memo","Blanket Order"; FromDocNo: Code[20]; FromLineNo: Integer; ToServLine: Record "Service Line EDMS")
    var
        NewServLaborAllocAppl: Record "Serv. Labor Alloc. Application";
        ServLedgEntry: Record "Service Ledger Entry EDMS";
        DetServLedgEntry: Record "Det. Serv. Ledger Entry EDMS";
    begin
        ServLedgEntry.Reset;
        ServLedgEntry.SetRange("Document Type", FromDocType);
        ServLedgEntry.SetRange("Document No.", FromDocNo);
        ServLedgEntry.SetRange("Document Line No.", FromLineNo);
        if ServLedgEntry.FindSet then
            repeat
                DetServLedgEntry.Reset;
                DetServLedgEntry.SetRange("Service Ledger Entry No.", ServLedgEntry."Entry No.");
                if DetServLedgEntry.FindSet then
                    repeat
                        if Resource.Get(DetServLedgEntry."Resource No.") then begin
                            Resource.TestField(Blocked, false);
                            NewServLaborAllocAppl.Init;
                            NewServLaborAllocAppl."Allocation Entry No." := 0;
                            NewServLaborAllocAppl."Document Type" := ToServLine."Document Type";
                            NewServLaborAllocAppl."Document No." := ToServLine."Document No.";
                            NewServLaborAllocAppl."Document Line No." := ToServLine."Line No.";
                            NewServLaborAllocAppl."Line No." += 10000;
                            NewServLaborAllocAppl."Resource No." := DetServLedgEntry."Resource No.";
                            NewServLaborAllocAppl."Finished Quantity (Hours)" := Abs(DetServLedgEntry."Finished Quantity (Hours)");
                            NewServLaborAllocAppl."Time Line" := true;
                            NewServLaborAllocAppl."Unit Cost" := DetServLedgEntry."Unit Cost";
                            NewServLaborAllocAppl."Finished Cost Amount" := Abs(DetServLedgEntry."Cost Amount");
                            NewServLaborAllocAppl."Cost Amount" := Abs(DetServLedgEntry."Cost Amount");
                            NewServLaborAllocAppl.Posted := false;
                            NewServLaborAllocAppl.Insert(true);
                        end;
                    until DetServLedgEntry.Next = 0;
            until ServLedgEntry.Next = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReturnAllocationCellText(var LaborAllocEntry: Record "Serv. Labor Allocation Entry"; var EndText: Text[250]);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetParamAllocationForm(var LaborAllocEntry: Record "Serv. Labor Allocation Entry"; var AllocationForm: Page Allocation;var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeAllocationSetParam(var ServiceLineSrcPar: Record "Service Line EDMS"; lineno: integer; var ishandled : Boolean)
    begin
    end;


}

