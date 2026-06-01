Page 25006355 "Time Registration"
{
    // 20.07.2015 EB.P7 #Schedule3.0
    //   Hidden "Hold Hours" field.

    Caption = 'Time Registration';
    PageType = Card;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            field(SourceType; SourceType)
            {
                ApplicationArea = Basic;
                Caption = 'Source Type';
                Editable = false;
            }
            field(SourceSubType; SourceSubType)
            {
                ApplicationArea = Basic;
                Caption = 'Source Subtype';
                Editable = false;
            }
            field(SourceID; SourceID)
            {
                ApplicationArea = Basic;
                Caption = 'Source ID';
                Editable = false;
            }
            field(ResourceNo; ResourceNo)
            {
                ApplicationArea = Basic;
                Caption = 'Resource No.';
                Editable = ResourceEditable;
                LookupPageID = "Resource List";
                TableRelation = Resource."No.";

                trigger OnValidate()
                begin
                    if Rec.Get(ResourceNo) then
                        Rec.SetRange("No.", ResourceNo);
                end;
            }
            field(Name; Rec.Name)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(DateTime; DateTimeMgt.Datetime2Text(CurrDateTime))
            {
                ApplicationArea = Basic;
                Caption = 'Date-Time';
            }
            field(SchedulePassword; SchedulePassword)
            {
                ApplicationArea = Basic;
                Caption = 'Password';
                ExtendedDatatype = Masked;
            }
            field(Status; Status)
            {
                ApplicationArea = Basic;
                Caption = 'Operation';
                Editable = false;
            }
            field(ReasonCode; ReasonCode)
            {
                ApplicationArea = Basic;
                Caption = 'Reason';
            }
            field(HoldHours; HoldHours)
            {
                ApplicationArea = Basic;
                Caption = 'Hold Hours';
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then begin
            StartEndWork;
        end;
    end;

    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocEntryTemp: Record "Serv. Labor Allocation Entry" temporary;
        Resource: Record Resource;
        ServSchedMgt: Codeunit "Service Schedule Mgt.";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ResourceNo: Code[20];
        SourceID: Code[20];
        ReasonCode: Code[10];
        SchedulePassword: Text[20];
        SourceType: Option ,"Service Document","Standard Event";
        SourceSubType: Option Quote,"Order";
        Status: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        OriginalStatus: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        FinishStatus: Option Finished,"On Hold";
        CurrDateTime: Decimal;
        QtyToAllocate: Decimal;
        HoldHours: Decimal;
        FinishText: label 'Finish Allocation';
        StartText: label 'Start Allocation';
        HoldText: label 'Hold Allocation';
        Text107: label 'Resource %1 have to start work time first.';
        Text113: label 'You are not allow to work now.';
        Text135: label 'Working on simultaneous tasks is not allowed.';
        ResourceEditable: Boolean;
        ServiceSetup: Record "Service Mgt. Setup EDMS";


    procedure SetParam(ResourceNo1: Code[20]; StartingDateTime1: Decimal; QtyToAllocate1: Decimal; SourceType1: Option ,"Service Document","Standard Event"; SourceSubType1: Option Qoute,"Order"; SourceID1: Code[20]; Status1: Option Pending,"In Process","Finish All","Finish Part","On Hold"; HoldHours1: Decimal; ReasonCodeToSet: Code[10])
    begin
        ResourceNo := ResourceNo1;
        Rec.SetRange("No.", ResourceNo);
        CurrDateTime := StartingDateTime1;
        QtyToAllocate := QtyToAllocate1;
        SourceType := SourceType1;
        SourceSubType := SourceSubType1;
        SourceID := SourceID1;
        Status := Status1;
        OriginalStatus := Status1;
        HoldHours := HoldHours1;

        if Status = Status::"On Hold" then
            FinishStatus := Finishstatus::"On Hold";

        //if ReasonCodeToSet <> '' then
        ReasonCode := ReasonCodeToSet;
        //else
        //    if ServLaborAllocationEntry.Get(SingleInstanceMgt.GetAllocationEntryNo) then
        //        ReasonCode := ServLaborAllocationEntry."Reason Code";


        if Status = Status::"Finish All" then
            ResourceEditable := false
        else
            ResourceEditable := true;
    end;


    procedure StartEndWork()
    var
        WorkTimeEntry: Record "Resource Work Time Entry";
        LaborAllocEntryLoc: Record "Serv. Labor Allocation Entry";
        SingleInstanceManagement: Codeunit SingleInstanceManagement;
    begin
        ServiceSetup.Get;
        ServSchedMgt.CompareSchedulePassword(ResourceNo, SchedulePassword);

        //20.11.2013 EDMS P8 >>
        if Status = Status::"In Process" then begin
            if not SingleInstanceManagement.GetTimeJournalFlag then begin
                WorkTimeEntry.Reset;
                WorkTimeEntry.SetCurrentkey("Resource No.", Closed);
                WorkTimeEntry.SetRange("Resource No.", ResourceNo);
                WorkTimeEntry.SetRange(Closed, false);
                if not WorkTimeEntry.FindLast then
                    Error(StrSubstNo(Text107, ResourceNo));
            end;

            Resource.Get(ResourceNo);
            if not Resource."Allow Simultaneous Work" then begin
                LaborAllocEntryLoc.Reset;
                LaborAllocEntryLoc.SetCurrentkey("Source Type", Status, "Resource No.");
                LaborAllocEntryLoc.SetRange(Status, LaborAllocEntryLoc.Status::"In Progress");
                LaborAllocEntryLoc.SetRange("Resource No.", ResourceNo);
                if ServiceSetup."Default Idle Event" <> '' then
                    LaborAllocEntryLoc.SetFilter("Source ID", '<>%1', ServiceSetup."Default Idle Event");

                if LaborAllocEntryLoc.FindFirst then
                    Error(Text135);
            end;

            /*
            //CurrDateTime := DateTimeMgt.Datetime(WORKDATE, TIME);
            IF ServSchedMgt.IsTimeAvailable(LaborAllocEntryTemp, ResourceNo, DateTimeMgt.Datetime2Date(CurrDateTime), 0) THEN BEGIN
              LaborAllocEntryTemp.RESET;
              IF LaborAllocEntryTemp.FINDFIRST THEN
                REPEAT
                  IF (LaborAllocEntryTemp."Start Date-Time" <= CurrDateTime) AND
                     (LaborAllocEntryTemp."End Date-Time" >= CurrDateTime)
                  THEN
                    ERROR(Text113);
                UNTIL LaborAllocEntryTemp.NEXT = 0
               ELSE
                 ERROR(Text113);
            END ELSE
              ERROR(Text113);

            */

        end;

        case Status of
            Status::"In Process":
                ServSchedMgt.ProcessStartLabor(CurrDateTime, ReasonCode);
            Status::"Finish All":
                ServSchedMgt.ProcessFinishLabor(CurrDateTime, Status, HoldHours, ReasonCode);
            Status::"Finish Part":
                ServSchedMgt.ProcessFinishLabor(CurrDateTime, Status, HoldHours, ReasonCode);
            Status::"On Hold":
                ServSchedMgt.ProcessHoldLabor(CurrDateTime, ReasonCode);
        end;

        //Rise event to catch alloc start finish
        ServLaborAllocationEntry.Get(SingleInstanceMgt.GetAllocationEntryNo);
        OnAllocationChangeStatus(Status, ServLaborAllocationEntry."Entry No.");

    end;


    procedure SetHeader(): Text[30]
    begin
        case Status of
            Status::"Finish All":
                exit(FinishText);
            Status::"Finish Part":
                exit(FinishText);
            Status::"In Process":
                exit(StartText);
            Status::"On Hold":
                exit(HoldText);
        end;
    end;

    [BusinessEvent(false)]

    procedure OnAllocationChangeStatus(Status: Option Pending,"In Process","Finish All","Finish Part","On Hold"; AllocEntryNo: Integer)
    begin
    end;
}

