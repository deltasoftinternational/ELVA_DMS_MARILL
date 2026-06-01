Codeunit 25006969 "GH ClockingTerminal Mgt."
{

    trigger OnRun()
    begin
        //TerminalStartJobsheet('SO000204');
    end;

    var
        TimeRegisterWorkingTxt: label 'Working';
        TimeRegisterNotWorkingTxt: label 'Not Working';
        CurrentDate: Date;
        CurrentTime: Time;


    procedure TerminalStartStopWork(): Text
    var
        CurrentDate: Date;
        CurrentTime: Time;
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
    begin
        ManageCurrentTime(CurrentDate, CurrentTime);
        ResourceTimeRegMgt.ToggleWorktime(ResourceTimeRegMgt.GetCurrentUserResourceNo, CurrentDate, CurrentTime);
        //error ('Task '+FORMAT(CurrentTime));
    end;




    procedure TerminalStartTask(inputJson: Text): Text
    var
        CurrentDate: Date;
        CurrentTime: Time;
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        CurrentResourceNo: Code[20];
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        EntryNo: Integer;
        j: JsonObject;
        t: JsonToken;
    begin
        j.ReadFrom(inputJson);
        j.Get('entryNo', t);
        EntryNo := t.AsValue().AsInteger();
        ManageCurrentTime(CurrentDate, CurrentTime);
        if ServLaborAllocationEntry.Get(EntryNo) then begin
            CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
            ResourceTimeRegMgt.StartWorktimeSilent(CurrentResourceNo, CurrentDate, CurrentTime);
            ResourceTimeRegMgt.ValidateTimeRegAction('Start', ServLaborAllocationEntry, CurrentResourceNo);
            ResourceTimeRegMgt.UpdateAllocationStatus('Start', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime, '');
            ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
            exit('Task ' + Format(ServLaborAllocationEntry."Source ID") + ' started.');
        end;
    end;


    procedure TerminalStopTask(inputJson: Text): Text
    var
        CurrentDate: Date;
        CurrentTime: Time;
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        CurrentResourceNo: Code[20];
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        EntryNo: Integer;
        j: JsonObject;
        t: JsonToken;
    begin
        j.ReadFrom(inputJson);
        j.Get('entryNo', t);
        EntryNo := t.AsValue().AsInteger();
        ManageCurrentTime(CurrentDate, CurrentTime);
        if ServLaborAllocationEntry.Get(EntryNo) then begin
            CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
            ResourceTimeRegMgt.ValidateTimeRegAction('Complete', ServLaborAllocationEntry, CurrentResourceNo);
            ResourceTimeRegMgt.AddTimeRegEntries('Complete', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
            ResourceTimeRegMgt.UpdateAllocationStatus('Complete', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime, '');
            exit('Task ' + Format(ServLaborAllocationEntry."Source ID") + ' finished.');
        end;
    end;


    procedure TerminalPauseTask(inputJson: Text): Text
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ReasonCode: Code[10];
        ServBreakReason: Record "Serv. Break Reason";
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        AllocationStatus: Option Pending,"In Process",Finished,"On Hold";
        CurrentDateTime: Decimal;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        HoursOnHold: Decimal;
        ServLaborAllocationEntry2: Record "Serv. Labor Allocation Entry";
        CurrentResourceNo: Code[20];
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        EntryNo: Integer;

        j: JsonObject;
        t: JsonToken;
    begin
        j.ReadFrom(inputJson);
        j.Get('entryNo', t);
        EntryNo := t.AsValue().AsInteger();

        j.Get('reason', t);
        ReasonCode := t.AsValue().AsText();

        ManageCurrentTime(CurrentDate, CurrentTime);
        if ServLaborAllocationEntry.Get(EntryNo) then begin
            CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
            CurrentDateTime := DateTimeMgt.Datetime(CurrentDate, CurrentTime);
            //ResourceTimeRegMgt.ValidateTimeRegAction('OnHold',ServLaborAllocationEntry,CurrentResourceNo);
            ResourceTimeRegMgt.ValidateTimeRegAction('Complete', ServLaborAllocationEntry, CurrentResourceNo);
            ResourceTimeRegMgt.AddTimeRegEntries('Complete', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
            ResourceTimeRegMgt.UpdateAllocationStatus('Complete', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime, '');


            HoursOnHold := 1;
            AllocationStatus := Allocationstatus::Pending;
            ServiceScheduleMgt.WriteAllocationEntries(ServLaborAllocationEntry."Resource No.", CurrentDateTime, HoursOnHold,
                                 ServLaborAllocationEntry."Source Type", ServLaborAllocationEntry."Source Subtype",
                                 ServLaborAllocationEntry."Source ID", 0, EntryNo, true, AllocationStatus, false, false);

            ServLaborAllocationEntry2.Reset;
            ServLaborAllocationEntry2.SetRange("Resource No.", CurrentResourceNo);
            ServLaborAllocationEntry2.SetFilter("Start Date-Time", '>=%1', CurrentDateTime);
            ServLaborAllocationEntry2.SetRange("Source Type", ServLaborAllocationEntry."Source Type");
            ServLaborAllocationEntry2.SetRange("Source Subtype", ServLaborAllocationEntry."Source Subtype");
            ServLaborAllocationEntry2.SetRange("Source ID", ServLaborAllocationEntry."Source ID");
            ServLaborAllocationEntry2.SetRange(Status, ServLaborAllocationEntry.Status::Pending);
            if ServLaborAllocationEntry2.FindFirst then
                repeat
                    ResourceTimeRegMgt.AddTimeRegEntries('OnHold', ServLaborAllocationEntry2, CurrentResourceNo, CurrentDate, CurrentTime);
                    ResourceTimeRegMgt.UpdateAllocationStatus('OnHold', ServLaborAllocationEntry2, CurrentResourceNo, CurrentDate, CurrentTime, ReasonCode);
                until ServLaborAllocationEntry2.Next = 0;
            exit('Task ' + Format(ServLaborAllocationEntry."Source ID") + ' paused.');
        end;
    end;


    procedure TerminalStartMyTask(inputJson: Text): Text
    var
        OnDate: Date;
        OnTime: Time;
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        CurrentResourceNo: Code[20];
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        EntryNo: Integer;
        j: JsonObject;
        t: JsonToken;
    begin
        j.ReadFrom(inputJson);
        j.Get('entryNo', t);
        EntryNo := t.AsValue().AsInteger();
        ManageCurrentTime(OnDate, OnTime);
        if ServLaborAllocationEntry.Get(EntryNo) then begin
            CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
            ResourceTimeRegMgt.StartWorktimeSilent(CurrentResourceNo, OnDate, OnTime);
            //ResourceTimeRegMgt.FinishAllStandardEventTasks(ResourceNo,OnDate,OnTime,SourceID);
            ResourceTimeRegMgt.ValidateTimeRegAction('Start', ServLaborAllocationEntry, CurrentResourceNo);
            ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, CurrentResourceNo, OnDate, OnTime);
            ResourceTimeRegMgt.UpdateAllocationStatus('Start', ServLaborAllocationEntry, CurrentResourceNo, OnDate, OnTime, '');
            exit('Task ' + Format(ServLaborAllocationEntry."Source ID") + ' started.');
        end;
    end;


    procedure TerminalStartJobsheet(inputJson: Text): Text
    var
        OnDate: Date;
        OnTime: Time;
        CurrentResourceNo: Code[20];
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServiceHeaderEDMS: Record "Service Header EDMS";
        No: Code[20];
        Travel: Boolean;
        TravInt: Integer;
        j: JsonObject;
        t: JsonToken;
    begin
        j.ReadFrom(inputJson);
        j.Get('no', t);
        No := t.AsValue().AsText();
        j.Get('travel', t);
        TravInt := t.AsValue().AsInteger();
        if (TravInt = 1) then
            Travel := true
        else
            Travel := false;

        if ServiceHeaderEDMS.Get(ServiceHeaderEDMS."document type"::Order, No) then begin
            ManageCurrentTime(OnDate, OnTime);
            CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
            ResourceTimeRegMgt.StartWorktimeSilent(CurrentResourceNo, OnDate, OnTime);
            ResourceTimeRegMgt.StartNewTaskFromHeader(ServiceHeaderEDMS, CurrentResourceNo, OnDate, OnTime, Travel);
            if (Travel) then
                exit('Jobsheet No.: ' + No + ' travel task started.')
            else
                exit('Jobsheet No.: ' + No + ' task started.');
        end else
            exit('Could not find Jobsheet No.: ' + No);
    end;

    procedure TerminalStartStdTask(inputJson: Text): Text
    var
        OnDate: Date;
        OnTime: Time;
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        AllocationForm: Page Allocation;
        ServiceLine: Record "Service Line EDMS" temporary;
        AllocatedEntryNo: Integer;
        StartDateTime: Decimal;
        MeetingDescription: Text;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        CurrentResourceNo: Code[20];
        StdEventCode: Code[20];
        j: JsonObject;
        t: JsonToken;
    begin
        j.ReadFrom(inputJson);
        j.Get('StdEventCode', t);
        StdEventCode := t.AsValue().AsText();
        ManageCurrentTime(OnDate, OnTime);
        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);

        Clear(AllocationForm);
        AllocationForm.SetParam(0, CurrentResourceNo, StartDateTime, 0, 2, 0, StdEventCode, 0, ServiceLine, 1);
        AllocationForm.SetDescription(MeetingDescription);
        AllocationForm.SetInvisibles(0);
        AllocatedEntryNo := AllocationForm.Allocate;

        if ServLaborAllocationEntry.Get(AllocatedEntryNo) then begin
            ResourceTimeRegMgt.FinishDefaultIdleTask(CurrentResourceNo, OnDate, OnTime);
            ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, CurrentResourceNo, OnDate, OnTime);
        end;

        exit('Standard task ' + Format(StdEventCode) + ' started.');

    end;



    procedure GetUserFullName(): Text
    var
        User: Record User;
    begin
        User.Reset;
        User.SetRange("User Name", UserId);
        if User.FindFirst then
            exit(User."Full Name");
    end;


    procedure GetResourceName(): Text
    var
        Resource: Record Resource;
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
    begin
        if Resource.Get(ResourceTimeRegMgt.GetResourceNoByUserId(UserId)) then
            exit(Resource.Name);
    end;


    procedure GetResourceWorkStatus(): Text
    var
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
    begin
        if ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo) then
            exit(TimeRegisterWorkingTxt)
        else
            exit(TimeRegisterNotWorkingTxt);
    end;


    procedure GetResourceTime(): Text
    begin
        exit(StrSubstNo('%1 %2', Format(Today), Time));
    end;


    procedure OnMenuItem(inputJson: Text): Text
    var
        MenuItemNo: Integer;
        j: JsonObject;
        t: JsonToken;
    begin
        j.ReadFrom(inputJson);
        j.Get('menuItemNo', t);
        MenuItemNo := t.AsValue().AsInteger();
        exit('On Menu Item No.:' + Format(MenuItemNo));
    end;

    local procedure ManageCurrentTime(var CrDate: Date; var CrTime: Time)
    var
        CustomCurrDate: Date;
        CustomCurrTime: Time;
        ServiceNavigationMgt: Codeunit "Easy Clocking Management";
    begin
        ServiceNavigationMgt.GetCustomCurrDateTime(CustomCurrDate, CustomCurrTime);
        if (CustomCurrDate <> 0D) and (CustomCurrTime <> 0T) then begin
            CrDate := CustomCurrDate;
            CrTime := CustomCurrTime;
        end else begin
            if (CurrentClientType = Clienttype::SOAP) then begin
                CrDate := Today;
                CrTime := Time;
            end else begin
                CrDate := WorkDate;
                CrTime := Time;
            end;
        end;
    end;


    procedure GetCheckListControlAddInData(inputJson: Text): Text
    var
        No: Code[20];
        j: JsonObject;
        t: JsonToken;
        AddInData: Text;
        Buffer: Record "Checklist Buffer" temporary;
        ProcessCheckList: Record "Process Checklist Header";
        GHCheckListAddInManagement: Codeunit "Checklist AddIn Management";
    begin
        j.ReadFrom(inputJson);
        j.Get('no', t);
        No := t.AsValue().AsText();

        ProcessCheckList.Get(No);
        GHCheckListAddInManagement.FillCheckList(ProcessCheckList, Buffer);
        GHCheckListAddInManagement.CheckListControlAddInReady(AddInData);
        exit(AddInData);
    end;

    procedure ProcessCheckListFunction(inputJson: Text): Boolean
    var
        DocNo: Code[20];
        LineNo: Integer;
        Func: Text;
        Val: Text;
        j: JsonObject;
        t: JsonToken;
        AddInData: Text;
        Buffer: Record "Checklist Buffer" temporary;
        ProcessCheckList: Record "Process Checklist Header";
        CheckListAddInManagement: Codeunit "Checklist AddIn Management";
    begin
        j.ReadFrom(inputJson);
        j.Get('function', t);
        Func := t.AsValue().AsText();
        j.Get('param1', t);
        DocNo := t.AsValue().AsText();
        j.Get('param2', t);
        LineNo := t.AsValue().AsInteger();
        j.Get('param3', t);
        Val := t.AsValue().AsText();
        CASE Func OF
            'RequestTextChange':
                CheckListAddInManagement.RequestTextChange(DocNo, LineNo, Val);
            'RequestRadioChange':
                CheckListAddInManagement.RequestRadioChange(DocNo, LineNo, Val);
            'RequestCheckChange':
                CheckListAddInManagement.RequestCheckChange(DocNo, LineNo, Val);
            //'RequestAssistEditButton':
            //CheckListAddInManagement.RequestAssistEditButton(DocNo, LineNo, Val);
            //'RequestButton':
            //CheckListAddInManagement.RequestButton(DocNo, LineNo, Val);
            //'RequestExtendedText':
            //    CheckListAddInManagement.RequestExtendedText(DocNo, LineNo, Val);
            //'RequestLastFocusField':
            //    CheckListAddInManagement.RequestLastFocusField(DocNo, LineNo, Val);
            //'RequestClosePage':
            //    CheckListAddInManagement.RequestClosePage(DocNo, LineNo, Val);

            ELSE
        END;

        exit(true);
    end;

    procedure TerminalPostTransfer(inputJson: Text): Text
    var
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        TransHeader: Record "Transfer Header";
        No: Code[20];
        Direction: Code[10];
        j: JsonObject;
        t: JsonToken;
    begin
        j.ReadFrom(inputJson);
        j.Get('no', t);
        No := t.AsValue().AsText();
        j.Get('direction', t);
        Direction := t.AsValue().AsText();

        if TransHeader.Get(No) then
            CASE Direction OF
                'SHIPMENT':
                    TransferPostShipment.Run(TransHeader);
                'RECEIPT':
                    TransferPostReceipt.Run(TransHeader);
                ELSE
            END;
    end;

    procedure TerminalSaveSignature(inputJson: Text): Text
    var
        ServiceHeader: Record "Service Header EDMS";
        SignatureType: Code[20];
        No: Code[20];
        Signature: Text;
        SignatureName: Text[100];
        OStream: OutStream;
        Img: Text;
        j: JsonObject;
        t: JsonToken;
    begin
        j.ReadFrom(inputJson);
        j.Get('no', t);
        No := t.AsValue().AsText();
        j.Get('signaturetype', t);
        SignatureType := t.AsValue().AsText();
        j.Get('signaturename', t);
        SignatureName := t.AsValue().AsText();
        j.Get('signature', t);
        Signature := t.AsValue().AsText();

        if ServiceHeader.Get(ServiceHeader."document type"::Order, No) then begin
            if SignatureType = 'EMPLOYEE' then begin
                ServiceHeader."Employee Signature Image".CreateOutstream(OStream);
                ServiceHeader."Employee Signature Text" := SignatureName;
            end else begin
                ServiceHeader."Customer Signature Image".CreateOutstream(OStream);
                ServiceHeader."Customer Signature Text" := SignatureName;
            end;
            OStream.WriteText(Signature);
            ServiceHeader.Modify;
            exit('Saved');
        end else
            exit('Could not save signature Jobsheet No.: ' + No);
    end;

    procedure TerminalEmailDocument(inputJson: Text): Text
    var
        ServiceHeader: Record "Service Header EDMS";
        No: Code[20];
        Email: Text[80];
        DocumentMailing: Codeunit 260;
        AttachmentFilePath: Text[250];
        AttachmentFileName: Text[150];
        ReportAsPdfFileNameMsg: label '%1 %2 %3.pdf', Comment = '%1 = Document Type %2 = Invoice No.';
        DocMgt: Codeunit DocumentManagementDMS;
        TimeStampForFileName: Text;
        RepSelect: Record "Document Report";
        RepCount: Integer;
        j: JsonObject;
        t: JsonToken;
        TempBlob: Codeunit "Temp Blob";
        AttachementStream: InStream;
    begin
        TempBlob.CreateInStream(AttachementStream);
        j.ReadFrom(inputJson);
        j.Get('no', t);
        No := t.AsValue().AsText();
        j.Get('email', t);
        Email := t.AsValue().AsText();

        if ServiceHeader.Get(ServiceHeader."document type"::Order, No) then begin
            RepSelect.Reset;
            DocMgt.PrintCurrentDoc(3, 3, 1, RepSelect);
            RepSelect.SetRange("Customer Signature", true);
            RepCount := RepSelect.Count;
            if RepCount = 0 then
                exit('Could not find report.');

            RepSelect.FindFirst;

            TimeStampForFileName := GetTimeStampForFileName;
            ServiceHeader.SetRange("Document Type", ServiceHeader."Document Type");
            ServiceHeader.SetRange("No.", ServiceHeader."No.");
            AttachmentFileName := DocMgt.SaveServiceHeaderReportAsPdf(TempBlob, ServiceHeader, RepSelect."Report ID");
            TempBlob.CreateInStream(AttachementStream);
            DocumentMailing.EmailFile(AttachementStream, AttachmentFileName, '', AttachmentFileName, Email, true, Enum::"Email Scenario"::Default);
            if ServiceHeader.Get(ServiceHeader."Document Type", ServiceHeader."No.") then begin
                Clear(ServiceHeader."Customer Signature Image");
                Clear(ServiceHeader."Customer Signature Text");
                Clear(ServiceHeader."Employee Signature Image");
                Clear(ServiceHeader."Employee Signature Text");
                ServiceHeader.Modify;
            end;
            exit('Sent');
        end else
            exit('Could not find Jobsheet No.: ' + No);
    end;

    local procedure GetTimeStampForFileName(): Text
    begin
        exit(Format(CurrentDatetime, 0, '<Year,2><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2><Thousands,3>'));
    end;

    local procedure SaveToFile(ServerFilePath: Text; ClientFileName: Text) ClientFilePath: Text
    var
        FileManagement: Codeunit "File Management";
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Signed Document Path" <> '' then begin
                ClientFilePath := UserSetup."Signed Document Path" + ClientFileName;
                //FileManagement.DownloadToFile(ServerFilePath,ClientFilePath);
                // FileManagement.CopyServerFile(ServerFilePath, ClientFilePath, true);
            end;
    end;

}

