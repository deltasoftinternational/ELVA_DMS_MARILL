Codeunit 25006017 "Easy Clocking Management"
{
    // 07.06.2016 EB.RC POD.Base P439.CU7bug
    //   Bugfix.


    trigger OnRun()
    begin
    end;

    var
        ObjectTypeErr: label 'Object Type not supported';
        UnknownActionErr: label 'Unknown Action Id';
        CustomCurrentDate: Date;
        CustomCurrentTime: Time;
        Text000: label 'Start Travel on:';
        Text001: label 'My Task,Group Task,Order Document,Order Line';


    procedure FillAddInData(var AddInDataToFill: Text)
    var
        OutStreamData: OutStream;
        InStreamData: InStream;
        ExportXmlPort: XmlPort "Export Easy Clocking Menu";
        //TempBlob: Record TempBlob temporary;
        TempBlob: Codeunit "Temp Blob";
    //StreamReader: dotnet StreamReader;
    begin
        Clear(AddInDataToFill);
        //TempBlob.Init;
        //TempBlob.Insert;
        //TempBlob.Blob.CreateOutstream(OutStreamData);
        TempBlob.CreateOutStream(OutStreamData);
        ExportXmlPort.SetCustomCurrentDateTime(CustomCurrentDate, CustomCurrentTime);
        ExportXmlPort.SetDestination(OutStreamData);
        if ExportXmlPort.Export then begin
            //TempBlob.CalcFields(Blob);
            //TempBlob.Blob.CreateInstream(InStreamData);
            TempBlob.CreateInstream(InStreamData);
            InStreamData.Read(AddInDataToFill);
            // StreamReader := StreamReader.StreamReader(InStreamData, true);
            // AddInDataToFill.AddText(StreamReader.ReadToEnd());
        end;
    end;


    procedure ProcessNavigationControl(ControlNo: Integer; ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ServiceNavigationControl: Record "Easy Clocking Menu Item";
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
    begin
        if ServiceNavigationControl.Get(ControlNo) then begin
            if ServiceNavigationControl."Run Action" <> ServiceNavigationControl."run action"::" " then begin
                ProcessNavigationAction(ServiceNavigationControl, ResourceNo, OnDate, OnTime);
            end;
            if ServiceNavigationControl."Run Object ID" <> 0 then begin
                case ServiceNavigationControl."Run Object Type" of
                    ServiceNavigationControl."run object type"::Codeunit:
                        begin
                            Codeunit.Run(ServiceNavigationControl."Run Object ID");
                        end;
                    ServiceNavigationControl."run object type"::Page:
                        begin
                            Page.Run(ServiceNavigationControl."Run Object ID");
                        end;
                    ServiceNavigationControl."run object type"::Report:
                        begin
                            Report.Run(ServiceNavigationControl."Run Object ID");
                        end;
                    ServiceNavigationControl."run object type"::XMLPort:
                        begin
                            Xmlport.Run(ServiceNavigationControl."Run Object ID");
                        end;
                    else
                        Message(ObjectTypeErr);
                end;
            end;
        end;
    end;

    local procedure ProcessNavigationAction(EasyTimeMenuItem: Record "Easy Clocking Menu Item"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        ServiceHeaderEDMS: Record "Service Header EDMS";
        ServiceLineEDMS: Record "Service Line EDMS";
        ServScheduleMgt: Codeunit "Service Schedule Mgt.";
        StartDateTime: Decimal;
        DivideIntoLines: Boolean;
        SourceType: Option ,"Service Document","Standard Event";
        SourceSubType: Option Qoute,"Order";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ServiceLine: Record "Service Line EDMS" temporary;
        ForceStatus: Option Pending,"In Progress",Finished,"On Hold",Cancelled;
        SourceID: Code[20];
        AllocatedEntryNo: Integer;
        MeetingDescription: Text;
        EasyTimeMeetingDialog: Page "Easy Clocking Start Meeting";
        EasyTimeCustomDateTimeDialog: Page "Easy Clocking Set Time";
        EasyTimeWkshPersTasks: Page "Easy Time Wksh. Pers. Tasks";
        EasyTimeWkshPoolTasks: Page "Easy Time Wksh. Pool Tasks";
        SelectedTravelSource: Integer;
    begin
        case EasyTimeMenuItem."Run Action" of
            EasyTimeMenuItem."run action"::"Start Worktime":
                begin
                    ResourceTimeRegMgt.StartWorktime(ResourceNo, OnDate, OnTime);
                end;
            EasyTimeMenuItem."run action"::"End Worktime":
                begin
                    ResourceTimeRegMgt.EndWorktime(ResourceNo, OnDate, OnTime);
                end;
            EasyTimeMenuItem."run action"::"Start My Task":
                begin
                    if Page.RunModal(Page::"Easy Time Wksh. Pers. Tasks", ServLaborAllocationEntry) = Action::LookupOK then begin
                        ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Start', ServLaborAllocationEntry, ResourceNo);
                        //ResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime, '');
                    end;

                end;
            EasyTimeMenuItem."run action"::"Start Group Task":
                begin
                    if Page.RunModal(Page::"Easy Time Wksh. Pool Tasks", ServLaborAllocationEntry) = Action::LookupOK then begin
                        ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Start', ServLaborAllocationEntry, ResourceNo);
                        //ResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime, '');
                    end;
                end;
            EasyTimeMenuItem."run action"::"Start Standard Task":
                begin
                    ResourceTimeRegMgt.StartNewTaskFromStandard(ResourceNo, OnDate, OnTime);
                end;
            EasyTimeMenuItem."run action"::"Start Break":
                begin
                    ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                    //ResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo;
                    StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
                    DivideIntoLines := false;
                    SourceType := ServLaborAllocationEntry."source type"::"Standard Event";
                    Mode := Mode::"New Allocation";
                    SourceID := 'BREAK';
                    ServScheduleMgt.ProcessAllocation(ResourceNo, StartDateTime, 1, SourceType, SourceSubType, SourceID, ServiceLine,
                      DivideIntoLines, Forcestatus::"In Progress", false);
                    AllocatedEntryNo := ServScheduleMgt.FindFirstAppliedEntryNo;
                    if ServLaborAllocationEntry.Get(AllocatedEntryNo) then begin
                        ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                    end;
                end;
            EasyTimeMenuItem."run action"::"Start Meeting":
                begin
                    MeetingDescription := '';
                    EasyTimeMeetingDialog.RunModal;
                    MeetingDescription := EasyTimeMeetingDialog.GetMeetingDescription;
                    ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                    //ResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo;
                    StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
                    DivideIntoLines := false;
                    SourceType := ServLaborAllocationEntry."source type"::"Standard Event";
                    Mode := Mode::"New Allocation";
                    SourceID := 'MEETING';
                    ServScheduleMgt.ProcessAllocation(ResourceNo, StartDateTime, 1, SourceType, SourceSubType, SourceID, ServiceLine,
                      DivideIntoLines, Forcestatus::"In Progress", false);
                    AllocatedEntryNo := ServScheduleMgt.FindFirstAppliedEntryNo;
                    if ServLaborAllocationEntry.Get(AllocatedEntryNo) then begin
                        ServScheduleMgt.UpdateAllocDetailsText(AllocatedEntryNo, MeetingDescription, ServLaborAllocationEntry."Detail Entry No.");
                        ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                    end;
                end;
            EasyTimeMenuItem."run action"::"Start Task From Order":
                begin
                    if Page.RunModal(Page::"Easy Time Wksh. Doc. Tasks", ServiceHeaderEDMS) = Action::LookupOK then begin
                        ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.StartNewTaskFromHeader(ServiceHeaderEDMS, ResourceNo, OnDate, OnTime, false);
                    end;
                end;
            EasyTimeMenuItem."run action"::"Start Task From Line":
                begin
                    if Page.RunModal(Page::"Easy Time Wksh. Doc. Tasks", ServiceHeaderEDMS) = Action::LookupOK then begin
                        ServiceLineEDMS.SetRange("Document No.", ServiceHeaderEDMS."No.");
                        ServiceLineEDMS.SetRange("Document Type", ServiceHeaderEDMS."Document Type");
                        if Page.RunModal(Page::"Easy Time Wksh. Line Tasks", ServiceLineEDMS) = Action::LookupOK then begin
                            ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                            ResourceTimeRegMgt.StartNewTaskFromLine(ServiceLineEDMS, ResourceNo, OnDate, OnTime, false);
                        end;
                    end;
                end;
            EasyTimeMenuItem."run action"::"Set Current Time":
                begin
                    EasyTimeCustomDateTimeDialog.SetCustomDateTime(CustomCurrentDate, CustomCurrentTime);
                    if EasyTimeCustomDateTimeDialog.RunModal = Action::OK then begin
                        EasyTimeCustomDateTimeDialog.GetCustomDateTime(CustomCurrentDate, CustomCurrentTime);
                    end;
                end;
            EasyTimeMenuItem."run action"::"Start Travel Task":
                begin
                    SelectedTravelSource := Dialog.StrMenu(Text001, 0, Text000);
                    case SelectedTravelSource of
                        1:
                            begin
                                if Page.RunModal(Page::"Easy Time Wksh. Pers. Tasks", ServLaborAllocationEntry) = Action::LookupOK then begin
                                    ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                                    //ResourceTimeRegMgt.ValidateTimeRegAction('Start',ServLaborAllocationEntry,ResourceNo);
                                    //ResourceTimeRegMgt.AddTimeRegEntries('Start',ServLaborAllocationEntry,ResourceNo,OnDate,OnTime);
                                    ResourceTimeRegMgt.StartNewTravelTaskFromAllocation(ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                                end;
                            end;
                        2:
                            begin
                                if Page.RunModal(Page::"Easy Time Wksh. Pool Tasks", ServLaborAllocationEntry) = Action::LookupOK then begin
                                    ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                                    //ResourceTimeRegMgt.ValidateTimeRegAction('Start',ServLaborAllocationEntry,ResourceNo);
                                    //ResourceTimeRegMgt.AddTimeRegEntries('Start',ServLaborAllocationEntry,ResourceNo,OnDate,OnTime);
                                    ResourceTimeRegMgt.StartNewTravelTaskFromAllocation(ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                                end;
                            end;
                        3:
                            begin
                                if Page.RunModal(Page::"Easy Time Wksh. Doc. Tasks", ServiceHeaderEDMS) = Action::LookupOK then begin
                                    ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                                    ResourceTimeRegMgt.StartNewTaskFromHeader(ServiceHeaderEDMS, ResourceNo, OnDate, OnTime, true);
                                end;
                            end;
                        4:
                            begin
                                if Page.RunModal(Page::"Easy Time Wksh. Doc. Tasks", ServiceHeaderEDMS) = Action::LookupOK then begin
                                    ServiceLineEDMS.SetRange("Document No.", ServiceHeaderEDMS."No.");
                                    ServiceLineEDMS.SetRange("Document Type", ServiceHeaderEDMS."Document Type");
                                    if Page.RunModal(Page::"Easy Time Wksh. Line Tasks", ServiceLineEDMS) = Action::LookupOK then begin
                                        ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                                        ResourceTimeRegMgt.StartNewTaskFromLine(ServiceLineEDMS, ResourceNo, OnDate, OnTime, true);
                                    end;
                                end;
                            end;
                    end;
                end;
            else
                Message(UnknownActionErr);
        end;
    end;


    procedure ProcessLookupAction(var ServLaborAllocEntry: Record "Serv. Labor Allocation Entry")
    var
        ServiceOrder: Page "Service Order EDMS";
        ServiceHeader: Record "Service Header EDMS";
        Allocation: Page Allocation;
        ServScheduleMgt: Codeunit "Service Schedule Mgt.";
    begin
        if ServLaborAllocEntry."Source Type" = ServLaborAllocEntry."source type"::"Service Document" then begin
            ServiceHeader.SetRange("Document Type", ServLaborAllocEntry."Source Subtype");
            ServiceHeader.SetRange("No.", ServLaborAllocEntry."Source ID");
            ServiceOrder.SetTableview(ServiceHeader);
            ServiceOrder.Run;
        end else begin
            ServScheduleMgt.MoveAllocation(ServLaborAllocEntry."Entry No.", ServLaborAllocEntry."Resource No.", ServLaborAllocEntry."Start Date-Time");
        end;
    end;


    procedure GetCustomCurrDateTime(var CurrDate: Date; var CurrTime: Time)
    begin
        CurrDate := CustomCurrentDate;
        CurrTime := CustomCurrentTime;
    end;


    procedure SetCurrentTaskListFilter(var ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry")
    var
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
    begin
        ServLaborAllocationEntry.Reset;
        ServLaborAllocationEntry.FilterGroup(3);
        ServLaborAllocationEntry.SetRange("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
        ServLaborAllocationEntry.SetFilter(Status, '<>%1 & <>%2', ServLaborAllocationEntry.Status::Finished, ServLaborAllocationEntry.Status::Pending);
        ServLaborAllocationEntry.SetRange(ServLaborAllocationEntry."Applies-to Entry No.", 0);
        ServLaborAllocationEntry.FilterGroup(0);
    end;
}

