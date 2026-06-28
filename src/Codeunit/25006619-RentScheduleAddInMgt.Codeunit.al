Codeunit 25006619 "Rent Schedule Add-In Mgt."
{
    // #Include POD.Base
    // 
    // 17.01.2017 EB.RC POD.DMS.Base P439 POD1.19
    //   Added Allocation Type switch
    // 
    // 18.10.2018 EB.RC POD.Base P439.EXTRAWSH09 POD1.07
    //   ?
    // 
    // 02.04.2017 EB.RC POD.Base P439.EXTRAWSH09 POD0.40
    //   Modified function:
    //     FillItemAllocations
    // 
    // 15.06.2016 EB.RC POD.Base P439.HR24
    //   Modified function:
    //     FillItemAllocations
    // 
    // 28.09.2015 EB.P7 #C001
    //   Removed "Transfer Record Count" functionality from "FillItemEntries" function;
    // 
    // 24.08.2014 EDMS P7
    //   * Code Unit created


    trigger OnRun()
    begin
    end;

    var
        ScheduleView: Record "Schedule View";
        ServScheduleSetup: Record "Service Schedule Setup";
        UserSetup: Record "User Setup";
        CollapsedItem: Record "Data Buffer" temporary;
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        ServScheduleMgt: Codeunit "Service Schedule Mgt.";
        ServScheduleAddInMgt: Codeunit "Serv. Schedule Web Add-In Mgt.";
        DocumentMgt: Codeunit DocumentManagementDMS;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ScheduleData: Text;
        StartDT: Decimal;
        EndDT: Decimal;
        Text001: label 'Data transfer error';
        TextUnknownEvent: label 'Unknown Event %1';
        ResourceGroup: Code[10];
        UnavailAllocEntryID: Integer;
        AllocationStatus: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        TextAbsenceLbl: label 'Absence';
        EmployeeDepartmentCode: Code[20];
        AbsenceAllocationType: Option;
        RentItems: Record "Rent Item";
        RentAssets: Record "Rent Asset";
        FillByItemOrAsset: Option Item,Asset;
        PeriodType: Option Custom,Day,WorkWeek,Month,Week;





    procedure StartAllocation(AllocationNo: Integer; ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
    begin
        Clear(ServScheduleMgt);

        if ServLaborAllocationEntry.Get(AllocationNo) then begin
            ResourceTimeRegMgt.AddTimeRegEntries('START', ServLaborAllocationEntry, ServLaborAllocationEntry."Resource No.", WorkDate, Time);
        end;

        SingleInstanceMgt.SetCurrAllocation(AllocationNo);
        ServScheduleMgt.StartEndAllocation(Allocationstatus::"In Process");
    end;


    procedure StartWorkTime(ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
    begin
        Clear(ServiceScheduleMgt);
        ServiceScheduleMgt.StartEndWorktime(ResourceNo, 0);
    end;


    procedure EndAllocation(AllocationNo: Integer; ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
    begin
        Clear(ServScheduleMgt);

        if ServLaborAllocationEntry.Get(AllocationNo) then begin
            ResourceTimeRegMgt.AddTimeRegEntries('COMPLETE', ServLaborAllocationEntry, ServLaborAllocationEntry."Resource No.", WorkDate, Time);
        end;

        SingleInstanceMgt.SetCurrAllocation(AllocationNo);
        ServScheduleMgt.StartEndAllocation(Allocationstatus::"Finish All");
    end;


    procedure EndWorkTime(ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
    begin
        Clear(ServiceScheduleMgt);
        ServiceScheduleMgt.StartEndWorktime(ResourceNo, 1);
    end;


    procedure HoldAllocation(AllocationNo: Integer; ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
    begin
        Clear(ServScheduleMgt);

        if ServLaborAllocationEntry.Get(AllocationNo) then begin
            ResourceTimeRegMgt.AddTimeRegEntries('ONHOLD', ServLaborAllocationEntry, ServLaborAllocationEntry."Resource No.", WorkDate, Time);
        end;

        SingleInstanceMgt.SetCurrAllocation(AllocationNo);
        ServScheduleMgt.StartEndAllocation(Allocationstatus::"On Hold");
    end;


    procedure BreakAllocation(AllocationNo: Integer; ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
    begin
        Clear(ServScheduleMgt);

        if ServLaborAllocationEntry.Get(AllocationNo) then begin
            ResourceTimeRegMgt.AddTimeRegEntries('COMPLETE', ServLaborAllocationEntry, ServLaborAllocationEntry."Resource No.", WorkDate, Time);
        end;

        SingleInstanceMgt.SetCurrAllocation(AllocationNo);
        ServScheduleMgt.BreakAllocation;
    end;


    procedure ProcessAllocation(EventType: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    var
        QtyToAllocate: Decimal;
        SplitTracking: Integer;
        Text001: label 'Standard Event,Service Line,Service Header';
        Diag: Dialog;
        Text002: label 'Select allocation type';
    begin
        case EventType of
            1:
                begin //Standard Event
                    ServScheduleMgt.AllocateStandardEvent(NewResNo, NewStartDT, NewEndDT);
                end;
            2:
                begin //Service Line
                    ServScheduleMgt.AllocateServiceLines(NewResNo, NewStartDT, NewEndDT);
                end;
            3:
                begin //Service Header
                    ServScheduleMgt.AllocateServiceOrder(NewResNo, NewStartDT, NewEndDT);
                end;
        end;
    end;


    procedure ProcessReallocation(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        QtyToAllocate: Decimal;
        SplitTracking: Integer;
        CurrItemID: Code[100];
        CurrResGroupCode: Code[20];
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
    begin
        SingleInstanceMgt.SetCurrAllocation(EntryNo);

        CurrItemID := NewResNo;
        DecodeItemID(CurrItemID, CurrResGroupCode, NewResNo);
        if NewResNo = '' then
            NewResNo := CurrItemID;
        if ServScheduleMgt.AllocationChanged(EntryNo, NewResNo, NewStartDT, NewEndDT) then begin
            //QtyToAllocate := ROUND((NewEndDT - NewStartDT)/3.6,0.1);
            LaborAllocEntry.Get(EntryNo);

            if (ServScheduleMgt.IsDateTimeEqualDateTime(NewStartDT, LaborAllocEntry."Start Date-Time") or
                  ServScheduleMgt.IsDateTimeEqualDateTime(NewEndDT, LaborAllocEntry."End Date-Time")) then begin
                NewEndDT := ServScheduleMgt.CalcEndDTOnlyWorktime(NewStartDT, NewEndDT, NewResNo);
                QtyToAllocate := ServScheduleMgt.CalcHourDifference(NewStartDT, NewEndDT);
            end else begin
                // that means moving so length should be left the same
                QtyToAllocate := ServScheduleMgt.CalcHourDifference(LaborAllocEntry."Start Date-Time", LaborAllocEntry."End Date-Time");
            end;
            if QtyToAllocate <= 0 then
                // ROUND by 20 sec - is taken from C25006201.AllocationChanged
                QtyToAllocate := ROUND((NewEndDT - NewStartDT) / 3.6, 0.01, '>');

            SplitTracking := 0;
            ServScheduleMgt.ProcessMovement(EntryNo, NewResNo, NewStartDT, QtyToAllocate, SplitTracking, LaborAllocEntry.Status, 300, LaborAllocEntry.Travel);
        end else begin
            ServScheduleMgt.MoveAllocation(EntryNo, NewResNo, NewStartDT);
        end;
    end;


    procedure ProcessCommands(Index: Integer; EntryNo: Integer; ResNo: Code[20]; CommStartDT: Decimal; CommEndDT: Decimal)
    var
        QtyToAllocate: Decimal;
        SplitTracking: Integer;
        Text001: label 'Standard Event,Service Line,Service Header';
        Diag: Dialog;
        Text002: label 'Select allocation type';
    begin
        case Index of
            1020:
                begin //Lookup
                    ServScheduleMgt.LookupAllocationRTC(EntryNo);
                end;
            1220:
                begin  //Deallocate
                    ServScheduleMgt.Deallocate(EntryNo);
                end;
            1230:
                begin  //Change
                    ProcessReallocation(EntryNo, ResNo, CommStartDT, CommEndDT);
                end;
            1340:
                begin  //Set Pos - Used For Search
                       //Data.GETSUBTEXT(Str, 1, 1024);
                       //CurrItemID := SELECTSTR(2,Str);
                       //Direction := Direction::Down;
                       //FillTextData(ScheduleData,Direction,CurrItemID,TRUE);
                end;
            2010:
                begin //Start Allocation
                    if EntryNo <> 0 then
                        StartAllocation(
                          EntryNo, //Entry No.
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT) //End DT as decimal
                    else
                        StartWorkTime(
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT); //End DT as decimal
                end;
            2020:
                begin //End Allocation
                    if EntryNo <> 0 then
                        EndAllocation(
                          EntryNo, //Entry No.
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT) //End DT as decimal
                    else
                        EndWorkTime(
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT); //End DT as decimal
                end;
            2130:
                begin //Hold Allocation
                    if EntryNo <> 0 then
                        HoldAllocation(
                          EntryNo, //Entry No.
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT); //End DT as decimal
                end;
            3000:
                begin //Break Allocation
                    if EntryNo <> 0 then
                        BreakAllocation(
                          EntryNo, //Entry No.
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT); //End DT as decimal
                end;
            1210:
                begin //Allocate
                    case Dialog.StrMenu(Text001, 1, Text002) of
                        1:
                            begin //Standard Event
                                ServScheduleMgt.AllocateStandardEvent(ResNo, CommStartDT, CommEndDT);
                            end;
                        2:
                            begin //Service Line
                                ServScheduleMgt.AllocateServiceLines(ResNo, CommStartDT, CommEndDT);
                            end;
                        3:
                            begin //Service Header
                                ServScheduleMgt.AllocateServiceOrder(ResNo, CommStartDT, CommEndDT);
                            end;
                    end;
                end;
            1240:
                begin //New Service Order
                    ServScheduleMgt.AllocateNewVisitOrder(ResNo, CommStartDT, CommEndDT);
                end;
            1241:
                begin //Allocate with create quote - fast way
                    ServScheduleMgt.AllocateNewVisitQuote(ResNo, CommStartDT, CommEndDT);
                end;
            2015:
                begin  // Cancel Start Allocation
                    CancelStartAllocation(EntryNo, ResNo, CommStartDT, CommEndDT, true);
                end;
        end;
    end;


    procedure ProcessAllocationEdit(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    begin
        //Not used
        ServScheduleMgt.MoveAllocation(EntryNo, NewResNo, NewStartDT);
    end;


    procedure FillTextData(var ScheduleData: Text; Direction: Option Down,Up; CurrItemID: Code[100]; PositionCurr: Boolean)
    var
        outStream: OutStream;
        inStream: InStream;
        //TempBlob: Record TempBlob temporary;
        TempBlob: Codeunit "Temp Blob";
        XmlPort1: XmlPort "Export Alloc. Events";
        ScheduleCaption: Record "Schedule Caption" temporary;
        ScheduleItem: Record "Schedule Item" temporary;
        ScheduleAllocation: Record "Schedule Allocation" temporary;
        ScheduleTimeRegEntry: Record "Resource Time Reg. Entry" temporary;
        TimeGridItemTmp: Record "Time Grid Item" temporary;
        BigTextTmp: Text;
    // StreamReader: dotnet StreamReader;
    begin
        //Main data export procedure

        ServScheduleSetup.Get;
        if PeriodType = PeriodType::Week then
            XmlPort1.SetWeekType('week')
        else
            XmlPort1.SetWeekType('workweek');

        XmlPort1.SetParam(StartDT, EndDT, ServScheduleSetup."Refresh Interval (ms)", ServScheduleSetup."Allocation Time Step (Minutes)");



        FillCaptionEntries(ScheduleCaption);
        FillItemEntries(ScheduleItem);
        FillAllocationEntries(ScheduleItem, ScheduleAllocation, StartDT, EndDT);
        FillTimeGridItem(TimeGridItemTmp, StartDT, EndDT);
        FillTimeRegEntries(ScheduleTimeRegEntry, ScheduleAllocation);


        XmlPort1.SetCaptions(ScheduleCaption);
        XmlPort1.SetItems(ScheduleItem);
        XmlPort1.SetItemAllocations(ScheduleAllocation);
        XmlPort1.SetTimeGrid(TimeGridItemTmp);
        XmlPort1.SetTimeRegEntry(ScheduleTimeRegEntry);

        //TempBlob.Init;
        //TempBlob.Insert;  //27.06.2013 EDMS P8
        //TempBlob.Blob.CreateOutstream(outStream);
        TempBlob.CreateOutStream(outStream);
        XmlPort1.SetDestination(outStream);
        if XmlPort1.Export then begin
            //TempBlob.CalcFields(Blob);
            //TempBlob.Blob.CreateInstream(inStream);
            TempBlob.CreateInstream(inStream);
            Clear(ScheduleData);
            Clear(BigTextTmp);

            //BigTextTmp.READ(inStream); that is old way but source code need to store for history
            //UTF8ToHTML(BigTextTmp, ScheduleData);
            // StreamReader := StreamReader.StreamReader(inStream, true);
            // ScheduleData.AddText(StreamReader.ReadToEnd());
            inStream.Read(ScheduleData);
            LogBigText(ScheduleData); //Creates a copy of transmitten XML data
        end
        else
            Error(Text001);
    end;


    procedure DecodeItemID(ItemID: Code[100]; var ResGroupCode: Code[20]; var ResCode: Code[20])
    var
        Pos: Integer;
    begin
        //Extracts Group Code and Resource No. out of ItemID

        ResGroupCode := '';
        ResCode := '';
        Pos := StrPos(ItemID, '/'); //0..1 separators are expected
        if Pos = 0 then
            ResGroupCode := ItemID
        else begin
            ResGroupCode := CopyStr(ItemID, 1, Pos - 1);
            ResCode := CopyStr(ItemID, Pos + 1, StrLen(ItemID) - Pos);
        end;
    end;


    procedure FillCaptionEntries(var ScheduleCaption: Record "Schedule Caption")
    var
        Text1010: label 'Refresh';
        Text1020: label 'Lookup';
        Text1210: label 'Allocate';
        Text1211: label 'New Service Order';
        Text1212: label 'New Service Quote';
        Text1220: label 'Deallocate';
        Text1230: label 'Change';
        Text2010: label 'Start';
        Text2020: label 'End';
        Text2110: label 'Start Allocation';
        Text2120: label 'Finish Allocation';
        Text2130: label 'Hold Allocation';
        Text2140: label 'Break';
        Text3000: label 'Setup Based Function';
        Text3001: label 'Setup Based Function';
        Text3002: label 'Setup Based Function';
        Text3003: label 'Setup Based Function';
        Text99001: label 'Licenced To:';
        Text99010: label '[b]Date:---';
        Text99011: label 'From:---';
        Text99012: label 'To:---';
        Text2015: label 'Cancel Start';
    begin
        //Fills item entries to the buffer
        ScheduleCaption.Reset;
        ScheduleCaption.DeleteAll;
        ScheduleCaption.ID := 1010;
        ScheduleCaption.Caption := Text1010;
        ScheduleCaption.SequenceNo := 7;
        ScheduleCaption.VALIDATE(GroupingCode, '');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1020;
        ScheduleCaption.Caption := Text1020;
        ScheduleCaption.SequenceNo := 1;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1210;
        ScheduleCaption.Caption := Text1210;
        ScheduleCaption.SequenceNo := 4;
        ScheduleCaption.VALIDATE(GroupingCode, 'ENABLED');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1241;
        ScheduleCaption.Caption := Text1212;
        ScheduleCaption.SequenceNo := 8;
        ScheduleCaption.VALIDATE(GroupingCode, 'ENABLED');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1240;
        ScheduleCaption.Caption := Text1211;
        ScheduleCaption.SequenceNo := 9;
        ScheduleCaption.VALIDATE(GroupingCode, 'ENABLED');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1220;
        ScheduleCaption.Caption := Text1220;
        ScheduleCaption.SequenceNo := 6;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1230;
        ScheduleCaption.Caption := Text1230;
        ScheduleCaption.SequenceNo := 5;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 2010;
        ScheduleCaption.Caption := Text2010;
        ScheduleCaption.SequenceNo := 2;
        ScheduleCaption.VALIDATE(GroupingCode, 'ITEM');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 2010;
        ScheduleCaption.Caption := Text2010;
        ScheduleCaption.SequenceNo := 2;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 2020;
        ScheduleCaption.Caption := Text2020;
        ScheduleCaption.SequenceNo := 3;
        ScheduleCaption.VALIDATE(GroupingCode, 'ITEM');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 2015;
        ScheduleCaption.Caption := Text2015;
        ScheduleCaption.SequenceNo := 3;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;   // 16.05.2014 Elva Baltic P21 #S0101 MMG7.00
        ScheduleCaption.ID := 2020;
        ScheduleCaption.Caption := Text2020;
        ScheduleCaption.SequenceNo := 4;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;   // 16.05.2014 Elva Baltic P21 #S0101 MMG7.00  Changed Seq. 3 <- 4
        ScheduleCaption.ID := 2130;
        ScheduleCaption.Caption := Text2130;
        ScheduleCaption.SequenceNo := 91;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 3000;
        ScheduleCaption.Caption := Text2140;
        ScheduleCaption.SequenceNo := 92;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        //captions of tooltip
        ScheduleCaption.ID := 99010;
        ScheduleCaption.Caption := Text99010;
        ScheduleCaption.SequenceNo := 1;
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 99011;
        ScheduleCaption.Caption := Text99011;
        ScheduleCaption.SequenceNo := 2;
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 99012;
        ScheduleCaption.Caption := Text99012;
        ScheduleCaption.SequenceNo := 3;
        ScheduleCaption.INSERT;
        //12; SequenceNo :=3; INSERT;

    end;


    procedure FillItemEntries(var ScheduleItem: Record "Schedule Item")
    var
        ColorR: Integer;
        ColorG: Integer;
        ColorB: Integer;
        ItemID: Code[100];
        TotalItemCount: Integer;
        ResColor: Integer;
        RentAvailabilityMgt: Codeunit "Rent Availability Mgt.";
        RentAvailabilityBufferTmp: Record "Rent Availability Buffer" temporary;
        RentResourceToIncludeTmp: Record "Rent Availability Buffer" temporary;
        RentAsset: Record "Rent Asset";
        OnDateFrom: Date;
        OnDateTo: Date;
        RentItemRelation: Record "Rent Item Relation";
        ResourceItemName: Text;
    begin
        OnDateFrom := DateTimeMgt.Datetime2Date(StartDT);
        OnDateTo := DateTimeMgt.Datetime2Date(EndDT);

        ScheduleItem.Reset;
        ScheduleItem.DeleteAll;
        ServScheduleSetup.Get;

        RentResourceToIncludeTmp.Reset;
        RentResourceToIncludeTmp.DeleteAll;
        RentAsset.Reset;

        if FillByItemOrAsset = Fillbyitemorasset::Item then begin
            if RentItems.GetFilters <> '' then begin
                if RentItems.FindFirst then begin
                    repeat
                        RentItemRelation.Reset;
                        RentItemRelation.SetRange("Rent Item No.", RentItems."No.");
                        if RentItemRelation.FindFirst then
                            repeat
                                if RentAsset.Get(RentItemRelation."Rent Asset No.") then begin
                                    RentAsset.Mark(true);
                                end;
                            until RentItemRelation.Next = 0;
                    until RentItems.Next = 0;
                    RentAsset.MarkedOnly(true);
                end
            end else begin
                if RentItems.Get(RentItems."No.") then begin
                    RentItemRelation.Reset;
                    RentItemRelation.SetRange("Rent Item No.", RentItems."No.");
                    if RentItemRelation.FindFirst then
                        repeat
                            if RentAsset.Get(RentItemRelation."Rent Asset No.") then begin
                                RentAsset.Mark(true);
                            end;
                        until RentItemRelation.Next = 0;
                    RentAsset.MarkedOnly(true);
                end;
            end;
        end else begin
            if RentAssets.FindFirst() then
                repeat
                    if RentAsset.get(RentAssets."No.") then
                        RentAsset.Mark(True);
                until RentAssets.Next() = 0;
            RentAsset.MarkedOnly(true);
        end;
        RentAvailabilityMgt.GetRentAssetAvailabilityEntries(RentAvailabilityBufferTmp, OnDateFrom, OnDateTo, RentAsset);



        RentAvailabilityBufferTmp.Reset;
        if RentAvailabilityBufferTmp.FindFirst then
            repeat
                RentResourceToIncludeTmp.Reset;
                RentResourceToIncludeTmp.SetRange("Rent Asset No.", RentAvailabilityBufferTmp."Rent Asset No.");
                if not RentResourceToIncludeTmp.FindFirst then begin
                    RentResourceToIncludeTmp.Init;
                    RentResourceToIncludeTmp."Entry No." := RentAvailabilityBufferTmp."Entry No.";
                    RentResourceToIncludeTmp."Rent Asset No." := RentAvailabilityBufferTmp."Rent Asset No.";
                    RentResourceToIncludeTmp."Rent Item No." := RentAvailabilityBufferTmp."Rent Item No.";
                    RentResourceToIncludeTmp.Insert;
                end;
            until RentAvailabilityBufferTmp.Next = 0;


        RentResourceToIncludeTmp.Reset;
        if RentResourceToIncludeTmp.FindFirst then
            repeat
                ItemID := GenerateItemID(RentResourceToIncludeTmp."Rent Item No.", RentResourceToIncludeTmp."Rent Asset No.");
                TotalItemCount += 1;

                ServScheduleMgt.SetResourceColor(RentAsset."No.", ResColor);
                ColorR := DocumentMgt.Color2Red(ResColor);
                ColorG := DocumentMgt.Color2Green(ResColor);
                ColorB := DocumentMgt.Color2Blue(ResColor);

                RentAsset.Get(RentResourceToIncludeTmp."Rent Asset No.");
                case ServScheduleSetup."Resource Name in Schedule" of
                    ServScheduleSetup."resource name in schedule"::Description:
                        ResourceItemName := RentAsset.Description;
                    ServScheduleSetup."resource name in schedule"::"No.&Description":
                        ResourceItemName := RentAsset."No." + ', ' + RentAsset.Description;
                    else
                        ResourceItemName := RentAsset."No.";
                end;
                //>>DELTA XX
                OnAfterCreatePlanningResourceDescription(RentAsset, ResourceItemName);
                //<<DELTA XX
                AddItemEntry(ScheduleItem,
                  ItemID, //Item ID
                  RentResourceToIncludeTmp."Rent Asset No.", //Item No.
                  ResourceItemName,
                  TotalItemCount, //Sequence
                  1, //Level
                  false, //Current
                  false, //Parent
                  ColorR, //ColorR
                  ColorG, //ColorG
                  ColorB, //ColorB
                  0, //Position ?
                  TotalItemCount);//Total Count
                                  //FORMAT(RentItemRelation."Relation Type")

            until RentResourceToIncludeTmp.Next = 0;
    end;



    procedure FillAllocationEntries(var ScheduleItem: Record "Schedule Item"; var ScheduleAllocation: Record "Schedule Allocation"; StartDT: Decimal; EndDT: Decimal)
    var
        RentAvailabilityMgt: Codeunit "Rent Availability Mgt.";
        RentAvailabilityBuffer: Record "Rent Availability Buffer" temporary;
        RentAsset: Integer;
    begin
        //Fills allocation entries

        UnavailAllocEntryID := 0;
        //AllocationEntryID := 0;

        ScheduleAllocation.Reset;
        ScheduleAllocation.DeleteAll;
        ScheduleItem.Reset;
        if ScheduleItem.FindFirst then
            repeat
                FillItemAllocations(ScheduleAllocation, ScheduleItem.ItemNo, ScheduleItem.ItemID, StartDT, EndDT)
            until ScheduleItem.Next = 0;
    end;


    procedure FillItemAllocations(var ScheduleAllocation: Record "Schedule Allocation"; ResourceNo: Code[20]; ItemID: Code[200]; StartingDateTimeDec: Decimal; EndingDateTimeDec: Decimal)
    var
        AllocEntryReal: Record "Serv. Labor Allocation Entry";
        ResGroupSpec: Record "Schedule Resource Group Spec.";
        DateRec: Record Date;
        UnavailAllocEntry: Record "Serv. Labor Allocation Entry" temporary;
        ForeColor: Integer;
        BackColor: Integer;
        DatetimeMgt: Codeunit "Datetime Mgt.";
        AllocationEntryID: Integer;
        RentAvailabilityMgt: Codeunit "Rent Availability Mgt.";
        RentAvailabilityBufferTmp: Record "Rent Availability Buffer" temporary;
        RentAsset: Record "Rent Asset";
        OnDateFrom: Date;
        OnDateTo: Date;
        AllocationText: Text;
        RentCapacitySetup: Record "Rent Mgt. Setup";
    begin
        ServiceMgtSetup.Get;
        RentCapacitySetup.Get();
        OnDateFrom := DatetimeMgt.Datetime2Date(StartDT);
        OnDateTo := DatetimeMgt.Datetime2Date(EndDT);

        //Fills item's allocations to the buffer
        ScheduleAllocation.Reset;
        if ScheduleAllocation.FindLast then
            AllocationEntryID := ScheduleAllocation.EntryNo;

        RentAsset.Reset;
        RentAvailabilityBufferTmp.Reset;
        RentAvailabilityBufferTmp.DeleteAll;

        RentAvailabilityMgt.GetRentAssetAvailabilityEntries(RentAvailabilityBufferTmp, OnDateFrom, OnDateTo, RentAsset);

        RentAvailabilityBufferTmp.Reset;
        RentAvailabilityBufferTmp.SetRange("Rent Asset No.", ResourceNo);
        if RentAvailabilityBufferTmp.FindFirst then
            repeat
                if RentAvailabilityBufferTmp."Starting Date" <> 0D then begin
                    AllocationEntryID += 1;
                    ScheduleAllocation.Init;
                    ScheduleAllocation.EntryNo := AllocationEntryID;
                    ScheduleAllocation.OriginalEntryNo := AllocationEntryID; //EmployeeAbsence."Entry No.";
                    ScheduleAllocation.ItemID := ItemID;
                    ScheduleAllocation.ItemNo := ResourceNo;
                    AllocationText := CreateFieldText(RentAvailabilityBufferTmp);
                    if (AllocationText <> '') then
                        ScheduleAllocation.Text := AllocationText
                    else begin
                        if RentAvailabilityBufferTmp."Ending Date" <> 0D then
                            ScheduleAllocation.Text := Format(RentAvailabilityBufferTmp.Quantity) + ' / ' + Format(RentAvailabilityBufferTmp."Starting Date") + ' - ' + Format(RentAvailabilityBufferTmp."Ending Date")
                        else
                            ScheduleAllocation.Text := Format(RentAvailabilityBufferTmp.Quantity) + ' / ' + Format(RentAvailabilityBufferTmp."Starting Date");
                    end;


                    ServScheduleMgt.GetAllocRecDescr(AllocEntryReal);

                    ScheduleAllocation.StartDT := DatetimeMgt.Datetime(RentAvailabilityBufferTmp."Starting Date", RentCapacitySetup."Rent Capacity Start Time");
                    if RentAvailabilityBufferTmp."Ending Date" <> 0D then
                        ScheduleAllocation.EndDT := DatetimeMgt.Datetime(RentAvailabilityBufferTmp."Ending Date", RentCapacitySetup."Rent Capacity End Time");

                    ScheduleAllocation.DisplayStartDT := ScheduleAllocation.StartDT;
                    ScheduleAllocation.DisplayEndDT := ScheduleAllocation.EndDT;


                    ServScheduleMgt.SetCellFormatRTCRent(RentAvailabilityBufferTmp, ForeColor, BackColor);
                    ScheduleAllocation.BackColorR := DocumentMgt.Color2Red(BackColor);
                    ScheduleAllocation.BackColorG := DocumentMgt.Color2Green(BackColor);
                    ScheduleAllocation.BackColorB := DocumentMgt.Color2Blue(BackColor);
                    ScheduleAllocation.ForeColorR := DocumentMgt.Color2Red(ForeColor);
                    ScheduleAllocation.ForeColorG := DocumentMgt.Color2Green(ForeColor);
                    ScheduleAllocation.ForeColorB := DocumentMgt.Color2Blue(ForeColor);

                    ScheduleAllocation.Editable := false;
                    ScheduleAllocation.AllocType := ScheduleAllocation.Alloctype::Normal;
                    ScheduleAllocation.GroupingCode := 'ALLOC';
                    ScheduleAllocation.Insert;
                end;
            until RentAvailabilityBufferTmp.Next = 0;
    end;


    procedure FillTimeGridItem(var TimeGridItemPar: Record "Time Grid Item" temporary; StartDT: Decimal; EndDT: Decimal)
    var
        TimeGridItemLoc: Record "Time Grid Item";
    begin
        //Fills Time Grid Items

        TimeGridItemPar.Reset;
        TimeGridItemPar.DeleteAll;
        if ScheduleView.Code <> '' then begin
            TimeGridItemLoc.SetRange("Grid Code", ScheduleView."Time Grid Code");
            if TimeGridItemLoc.FindFirst then
                repeat
                    TimeGridItemPar := TimeGridItemLoc;
                    TimeGridItemPar.Insert;
                until TimeGridItemLoc.Next = 0;
        end;
    end;


    procedure AddItemEntry(var ScheduleItem: Record "Schedule Item"; ItemID: Code[100]; ItemNo: Code[20]; ItemDesc: Text[250]; Sequence: Integer; Level: Integer; Current: Boolean; Parent: Boolean; ColorR: Integer; ColorG: Integer; ColorB: Integer; ItemPosition: Integer; TotalCnt: Integer)
    var
        Collapsed: Boolean;
    begin
        //Adds item item entry to the buffer

        ScheduleItem.Init;
        ScheduleItem.Sequence := Sequence;
        ScheduleItem.ItemID := ItemID;
        ScheduleItem.ItemNo := ItemNo;
        ScheduleItem.Description := ItemDesc;
        ScheduleItem.Level := Level;
        ScheduleItem.Current := Current;
        ScheduleItem.Parent := Parent;

        Collapsed := false;
        if Parent then
            if IsCollapsed(ItemID) then
                Collapsed := true;

        ScheduleItem.Collapsed := Collapsed;

        ScheduleItem.ForeColorR := ColorR;
        ScheduleItem.ForeColorG := ColorG;
        ScheduleItem.ForeColorB := ColorB;
        ScheduleItem.ScrollBarPosition := ItemPosition;
        ScheduleItem.ScrollBarTotalCount := TotalCnt;
        ScheduleItem.GroupingCode := 'ITEM';
        ScheduleItem.Insert;
    end;


    procedure LogBigText(var TextPar: Text): Boolean
    var
        LogFileName: Text[1024];
        LogFile: File;
        OutStream: OutStream;
        InStream: InStream;
        TextTmp: Text[1024];
        //tempData: Record TempBlob temporary;
        BText: Text;
        CRLF: Text[2];
        CR: Char;

        LF: Char;
        TempBlob: Codeunit "Temp Blob";
    begin
        /* //Does not work on Cloud
        // returns either is logged or not
        if not UserSetup.Get(UserId) then
            exit(false);
        if UserSetup."Schedule Add-In Log Active" then begin
            if UserSetup."Schedule Add-In Log Path" = '' then
                exit(false);
            LogFileName := UserSetup."Schedule Add-In Log Path" + 'rtcxmllog.log';

            TempBlob.CreateInstream(InStream);
            if UploadIntoStream('', '', '', LogFileName, InStream) then begin
                InStream.ReadText(BText); /// Why in RTC it does not work?
                InStream.ReadText(TextTmp);
            end;

            // if LogFile.Open(LogFileName) then begin
            //     LogFile.CreateInstream(InStream);
            //     InStream.ReadText(BText); /// Why in RTC it does not work?
            //     InStream.ReadText(TextTmp);
            //     LogFile.Close;
            // end;
            // if not LogFile.Create(LogFileName) then
            //     exit(false);
            //LogFile.CreateOutstream(OutStream);
            TempBlob.CreateOutstream(OutStream);
            OutStream.WriteText(BText);
            CR := 13;
            CRLF := Format(CR);
            TextTmp := 'Log info at:' + Format(CurrentDatetime) + ':';
            OutStream.WriteText(TextTmp);
            OutStream.WriteText(CRLF);
            OutStream.WriteText(TextPar);
            OutStream.WriteText(CRLF);
            if not DownloadFromStream(InStream, '', '', '', LogFileName) then
                exit(false);
            // LogFile.Close;

        end;
        */
        exit(true);
    end;


    procedure LogBigTextToFile(var TextPar: Text; LogFileName: Text[1024]): Boolean
    var
        LogFile: File;
        OutStream: OutStream;
        InStream: InStream;
        TextTmp: Text[1024];
        //tempData: Record TempBlob temporary;
        BText: Text;
        CRLF: Text[2];
        CR: Char;

        LF: Char;
        TempBlob: Codeunit "Temp Blob";
    begin
        // returns either is logged or not
        if not UserSetup.Get(UserId) then
            exit(false);

        if LogFileName = '' then
            exit(false);

        TempBlob.CreateInstream(InStream);
        if UploadIntoStream('', '', '', LogFileName, InStream) then begin
            InStream.ReadText(BText); /// Why in RTC it does not work?
            InStream.ReadText(TextTmp);
        end;

        // if LogFile.Open(LogFileName) then begin
        //     LogFile.CreateInstream(InStream);
        //     InStream.ReadText(BText); /// Why in RTC it does not work?
        //     InStream.ReadText(TextTmp);
        //     LogFile.Close;
        // end;
        // if not LogFile.Create(LogFileName) then
        //     exit(false);
        // LogFile.CreateOutstream(OutStream);
        TempBlob.CreateOutstream(OutStream);

        OutStream.WriteText(BText);
        CR := 13;
        CRLF := Format(CR);
        TextTmp := 'Log info at:' + Format(CurrentDatetime) + ':';
        OutStream.WriteText(TextTmp);
        OutStream.WriteText(CRLF);
        OutStream.WriteText(TextPar);
        OutStream.WriteText(CRLF);
        if not DownloadFromStream(InStream, '', '', '', LogFileName) then
            exit(false);
        // LogFile.Close;

        exit(true);
    end;


    procedure ItemIDPosition(ItemID: Code[100]): Integer
    var
        GroupCode: Code[20];
        ResNo: Code[20];
        ResGroupSpec: Record "Schedule Resource Group Spec.";
        FromGroupCode: Code[20];
        FromResNo: Code[20];
        ToGroupCode: Code[20];
        ToResNo: Code[20];
        Pos: Integer;
    begin
        //Returns Item's possition

        GroupCode := '';
        ResNo := '';
        DecodeItemID(ItemID, GroupCode, ResNo);

        //Getting Start Possition
        ResGroupSpec.Reset;
        if not ResGroupSpec.FindFirst then
            exit(0);
        FromGroupCode := ResGroupSpec."Group Code";
        FromResNo := ResGroupSpec."Resource No.";

        //Getting End Possition
        ResGroupSpec.Reset;
        ResGroupSpec.SetRange("Group Code", GroupCode);
        if ResNo <> '' then
            ResGroupSpec.SetRange("Resource No.", ResNo);
        if not ResGroupSpec.FindFirst then
            exit(0);
        ToGroupCode := ResGroupSpec."Group Code";
        ToResNo := ResGroupSpec."Resource No.";


        Pos := CountEntries(FromGroupCode, FromResNo, ToGroupCode, ToResNo);
        if ResNo = '' then
            Pos -= 1;
        exit(Pos);
    end;


    procedure GenerateItemID(ResGroupCode: Code[20]; ResCode: Code[20]): Code[100]
    begin
        //Creates an ItemID out of Group Code and Resource No.

        if ResCode = '' then
            exit(ResGroupCode)
        else
            exit(ResGroupCode + '/' + ResCode);
    end;


    procedure IsCollapsed(ItemID: Code[100]): Boolean
    begin
        //Checks if item is collapsed

        CollapsedItem.Reset;
        CollapsedItem.SetCurrentkey("Code Field 1");
        CollapsedItem.SetRange("Code Field 1", ItemID);
        exit(CollapsedItem.FindFirst = true);
    end;


    procedure CountEntries(FromGroupCode: Code[20]; FromResNo: Code[20]; ToGroupCode: Code[20]; ToResNo: Code[20]) RecCount: Integer
    var
        ResGroupSpec: Record "Schedule Resource Group Spec.";
        ResGroupSpec2: Record "Schedule Resource Group Spec.";
    begin
        //Returns the number of items withing a range. Considers collapsed items

        RecCount := 0;

        ResGroupSpec.Reset;
        ResGroupSpec.SetRange("Group Code", FromGroupCode);
        ResGroupSpec.SetRange("Resource No.", FromResNo);
        if not ResGroupSpec.FindFirst then
            exit;

        ResGroupSpec.SetRange("Group Code");
        ResGroupSpec.SetRange("Resource No.");

        repeat



            //Group Counter >>
            RecCount += 1;

            ResGroupSpec.SetRange("Group Code", ResGroupSpec."Group Code");
            ResGroupSpec.FindLast;
            ResGroupSpec.SetRange("Group Code");
            //Group Counter <<

            //Item Counter >>
            if not IsCollapsed(GenerateItemID(ResGroupSpec."Group Code", '')) then begin
                ResGroupSpec2.Reset;
                ResGroupSpec2.SetRange("Group Code", ResGroupSpec."Group Code");
                case true of
                    (ResGroupSpec."Group Code" = FromGroupCode) and (ResGroupSpec."Group Code" = ToGroupCode):
                        ResGroupSpec2.SetFilter("Resource No.", '%1..%2', FromResNo, ToResNo);
                    (ResGroupSpec."Group Code" = FromGroupCode):
                        ResGroupSpec2.SetFilter("Resource No.", '%1..', FromResNo);
                    (ResGroupSpec."Group Code" = ToGroupCode):
                        ResGroupSpec2.SetFilter("Resource No.", '..%1', ToResNo);
                end;
                RecCount += ResGroupSpec2.Count;
            end;
        //Item Counter <<
        until (ResGroupSpec."Group Code" = ToGroupCode) or (ResGroupSpec.Next = 0);
    end;


    procedure SetParameters(StartDT1: Decimal; EndDT1: Decimal; ResourceGroup1: Code[10]; ScheduleViewCode: Code[10])
    begin
        //Sets initial parameters. Gets called from the page where add-in is placed

        StartDT := StartDT1;
        EndDT := EndDT1;
        ResourceGroup := ResourceGroup1;
        if ScheduleView.Get(ScheduleViewCode) then;
    end;


    procedure SetRentParameters(StartDT1: Decimal; EndDT1: Decimal; var RentItemsToSet: Record "Rent Item"; var RentAssetsToSet: Record "Rent Asset"; ItemOrAsset: Option Item,Asset; PeriodTypeToSet: Option Custom,Day,WorkWeek,Month,Week)
    begin
        //Sets initial parameters.
        StartDT := StartDT1;
        EndDT := EndDT1;

        RentItems := RentItemsToSet;
        RentItems.CopyFilters(RentItemsToSet);



        RentAssetsToSet.MarkedOnly(True);
        if RentAssetsToSet.FindFirst() then
            repeat
                if RentAssets.get(RentAssetsToSet."No.") then
                    RentAssets.Mark(True);
            until RentAssetsToSet.Next() = 0;
        RentAssets.MarkedOnly(true);

        //RentAssets := RentAssetsToSet;
        RentAssets.CopyFilters(RentAssetsToSet);
        FillByItemOrAsset := ItemOrAsset;
        PeriodType := PeriodTypeToSet;
    end;


    procedure Refresh(var ScheduleData: Text)
    begin
        Clear(ScheduleData);
        //ScheduleData.AddText(StrSubstNo('Command:1010,1,1'), 1);
        ScheduleData += StrSubstNo('Command:1010,1,1', 1);
    end;


    procedure Search(var ScheduleData: Text)
    var
        SearchPage: Page "Service Schedule Search";
        ResGroupSpec: Record "Schedule Resource Group Spec.";
        Data: Text;
        CurrItemID: Code[100];
        CurrGroupID: Code[100];
    begin
        //Search procedure

        Clear(SearchPage);
        if SearchPage.RunModal = Action::OK then begin
            if SearchPage.TargetResourceNo = '' then
                exit;
            ResGroupSpec.Reset;
            ResGroupSpec.SetRange("Resource No.", SearchPage.TargetResourceNo);
            if ResGroupSpec.FindFirst then begin
                CurrItemID := GenerateItemID(ResGroupSpec."Group Code", ResGroupSpec."Resource No.");
                CurrGroupID := GenerateItemID(ResGroupSpec."Group Code", '');
                if IsCollapsed(CurrGroupID) then
                    OnClickTree(CurrGroupID);
                //Data.AddText(',' + GenerateItemID(ResGroupSpec."Group Code", ResGroupSpec."Resource No."));
                Data += ',' + GenerateItemID(ResGroupSpec."Group Code", ResGroupSpec."Resource No.");

                //ProcessCommands(1340,Data,ScheduleData)
            end else
                Message('Cannot find');
        end;
    end;


    procedure OnClickTree(ItemID: Code[100])
    var
        EntryNo: Integer;
    begin
        //Called when clicked on +/- in the tree. Works like a trigger

        CollapsedItem.Reset;
        CollapsedItem.SetCurrentkey("Code Field 1");
        CollapsedItem.SetRange("Code Field 1", ItemID);
        if CollapsedItem.FindFirst then
            CollapsedItem.Delete
        else begin
            EntryNo := 0;
            CollapsedItem.Reset;
            if CollapsedItem.FindLast then
                EntryNo := CollapsedItem."Entry No.";
            EntryNo += 1;
            CollapsedItem.Init;
            CollapsedItem."Entry No." := EntryNo;
            CollapsedItem."Code Field 1" := ItemID;
            CollapsedItem.Insert;
        end;
    end;


    procedure CancelStartAllocation(AllocationNo: Integer; ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal; ShowDialog: Boolean)
    var
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
    begin
        Clear(ServScheduleMgt);

        if ServLaborAllocationEntry.Get(AllocationNo) then begin
            ResourceTimeRegMgt.AddTimeRegEntries('CANCELSTART', ServLaborAllocationEntry, ServLaborAllocationEntry."Resource No.", WorkDate, Time);
        end;

        SingleInstanceMgt.SetCurrAllocation(AllocationNo);
        //22.12.2014 Elva Baltic P1 - uncommented>>
        ServScheduleMgt.CancelAllocation(Allocationstatus::Pending, StartDT, ShowDialog); //that is commented at 05.09.2014 - function f                                                                                                                                                                    rom EDMS7.10.11
        //22.12.2014 Elva Baltic P1 - uncommented<<
    end;


    procedure FillTimeRegEntries(var ResourceTimeRegEntryTmp: Record "Resource Time Reg. Entry"; var ScheduleAllocation: Record "Schedule Allocation")
    var
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
    begin
        //Fills resource time reg entries

        ResourceTimeRegEntryTmp.Reset;
        ResourceTimeRegEntryTmp.DeleteAll;

        if ScheduleAllocation.FindFirst then
            repeat
                ResourceTimeRegEntry.Reset;
                ResourceTimeRegEntry.SetRange("Worktime Entry", false);
                ResourceTimeRegEntry.SetRange(Canceled, false);
                ResourceTimeRegEntry.SetRange(Idle, false);
                ResourceTimeRegEntry.SetRange("Allocation Entry No.", ScheduleAllocation.OriginalEntryNo);
                if ResourceTimeRegEntry.FindFirst then
                    repeat
                        //ResourceTimeRegEntryTmp.INIT;
                        ResourceTimeRegEntryTmp := ResourceTimeRegEntry;
                        ResourceTimeRegEntryTmp.Insert;
                    until ResourceTimeRegEntry.Next = 0;
            until ScheduleAllocation.Next = 0;
    end;


    procedure CreateFieldText(var RentAvailabilityBufferTmp: Record "Rent Availability Buffer"): Text[250]
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
        ScheduleCellConfig: Record "Serv. Schedule Cell Config.";
        ServHdr: Record "Service Header EDMS";
        ServLine: Record "Service Line EDMS";
        RentHeader: Record "Rent Header";
        RentLine: Record "Rent Line";
        RentAsset: Record "Rent Asset";
        RentItem: Record "Rent Item";
        StandardEvent: Record "Serv. Standard Event";
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
        SourceTypeFilter := Format(Database::"Service Header EDMS") + '|' + Format(Database::"Rent Header") + '|' + Format(Database::"Rent Line") + '|' + Format(Database::"Rent Asset") + '|' + Format(Database::"Rent Item");
        ScheduleCellConfig.SetFilter("Source Type", SourceTypeFilter);
        if ScheduleCellConfig.FindFirst then
            repeat
                case ScheduleCellConfig."Source Type" of
                    Database::"Service Header EDMS":
                        begin
                            if RentAvailabilityBufferTmp."Service Order No." <> '' then
                                if ServHdr.Get(ServHdr."document type"::Order, RentAvailabilityBufferTmp."Service Order No.") then begin
                                    RecordRef.Open(Database::"Service Header EDMS");
                                    RecordRef.GetTable(ServHdr);
                                end;
                        end;
                    Database::"Rent Header":
                        begin
                            if RentAvailabilityBufferTmp."Rent Document No." <> '' then
                                if RentHeader.Get(RentAvailabilityBufferTmp."Rent Document Type", RentAvailabilityBufferTmp."Rent Document No.") then begin
                                    RecordRef.Open(Database::"Rent Header");
                                    RecordRef.GetTable(RentHeader);
                                end;
                        end;
                    Database::"Rent Line":
                        begin
                            if RentAvailabilityBufferTmp."Rent Document Line No." <> 0 then
                                if RentLine.Get(RentAvailabilityBufferTmp."Rent Document Type", RentAvailabilityBufferTmp."Rent Document No.", RentAvailabilityBufferTmp."Rent Document Line No.") then begin
                                    RecordRef.Open(Database::"Rent Line");
                                    RecordRef.GetTable(RentLine);
                                end;
                        end;
                    Database::"Rent Item":
                        begin
                            if RentAvailabilityBufferTmp."Rent Item No." <> '' then
                                if RentItem.Get(RentAvailabilityBufferTmp."Rent Item No.") then begin
                                    RecordRef.Open(Database::"Rent Item");
                                    RecordRef.GetTable(RentItem);
                                end;
                        end;
                    Database::"Rent Asset":
                        begin
                            if RentAvailabilityBufferTmp."Rent Asset No." <> '' then
                                if RentAsset.Get(RentAvailabilityBufferTmp."Rent Asset No.") then begin
                                    RecordRef.Open(Database::"Rent Asset");
                                    RecordRef.GetTable(RentAsset);
                                end;
                        end;
                end;

                if RecordRef.NUMBER <> 0 then begin
                    FieldRef := RecordRef.Field(ScheduleCellConfig."Source Ref. No.");

                    Evaluate(FieldRefClass, Format(FieldRef.CLASS));
                    if FieldRefClass = Fieldrefclass::FlowField then
                        FieldRef.CalcField;

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
                end;
            until ScheduleCellConfig.Next = 0;
        exit(EndText);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePlanningResourceDescription(RentAsset: Record "Rent Asset"; var ResourceItemName: Text)
    begin
    end;
}

