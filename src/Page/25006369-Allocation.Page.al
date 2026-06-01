Page 25006369 "Allocation"
{
    // 22.04.2014 Elva Baltic P1 #RX MMG7.00
    //  * Field "SourceID" set EDITABLE=FALSE
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added Code to
    //     SourceID - OnValidate()
    //     SetParam()
    //   Added field "CrUserID"
    // 
    // 28.03.2014 Elva Baltic P18 MMG7.00
    //   Fixed error for field "Description"
    // 
    // 26.03.2014 Elva Baltic P18 #RX026
    //   Added Code to
    //     Trigger : OnQueryClosePage()
    //     Procedure : SetParam()
    // 
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Added LVI captions
    // 
    // 17.03.2014 Elva Baltic P8 #E0003 MMG7.00
    //   * Fix of standard text use
    // 
    // // it supposed to be used/runed by use temp record ONLY !!!
    // 06.12.2013 EDMS P8
    //   * SMALL fix due to multi-language
    // 
    // 24.01.2012 EDMS P8
    //   * unvisible SplitTracking

    Caption = 'Allocation';
    DeleteAllowed = false;
    SourceTable = "Serv. Labor Alloc. Application";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Source)
            {
                Caption = 'Source';
                field(LaborAllocEntryTmpSourceType; LaborAllocEntryTmp."Source Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        SourceType := LaborAllocEntryTmp."Source Type";
                        RefreshVisibles;
                        CurrPage.Update;
                    end;
                }
                field(LaborAllocEntryTmpSourceSubtype; LaborAllocEntryTmp."Source Subtype")
                {
                    ApplicationArea = Basic;
                    Visible = SourceSubTypeVisible;

                    trigger OnValidate()
                    begin
                        SourceSubType := LaborAllocEntryTmp."Source Subtype";  //06.12.2013 EDMS P8
                    end;
                }
                field(SourceID; SourceID)
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
                        if SourceID <> '' then
                            if LaborAllocEntryTmp."Source Type" = LaborAllocEntryTmp."source type"::"Standard Event" then
                                if not StandardEvent.Get(SourceID) then
                                    Error(ERR001);
                        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
                    end;
                }
            }
            group(Allocation)
            {
                Caption = 'Allocation';
                Visible = isAllocationShown;
                field(StartDate; StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Date';

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
                        CalculateDuration(DurationGlob, CurrQtyToAllocate, 1);
                        EndDateTime := ServScheduleMgt.CalculateNewStartDateTime(ResourceNo, StartDateTime, CurrQtyToAllocate);
                        EndDate := DateTimeMgt.Datetime2Date(EndDateTime);
                        EndTime := DateTimeMgt.Datetime2Time(EndDateTime);
                    end;
                }
                field(StartTime; StartTime)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Time';

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
                        CalculateDuration(DurationGlob, CurrQtyToAllocate, 1);
                        EndDateTime := ServScheduleMgt.CalculateNewStartDateTime(ResourceNo, StartDateTime, CurrQtyToAllocate);
                        EndDate := DateTimeMgt.Datetime2Date(EndDateTime);
                        EndTime := DateTimeMgt.Datetime2Time(EndDateTime);
                    end;
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
                        EndDateTime := DateTimeMgt.Datetime(EndDate, EndTime);
                        CurrQtyToAllocate := ServScheduleMgt.CalcWorkHourDifference(ResourceNo, StartDateTime, EndDateTime);
                        CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);
                    end;
                }
                field(EndTime; EndTime)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Time';

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
                        EndDateTime := DateTimeMgt.Datetime(EndDate, EndTime);
                        CurrQtyToAllocate := ServScheduleMgt.CalcWorkHourDifference(ResourceNo, StartDateTime, EndDateTime);
                        CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);
                    end;
                }
                field(DurationGlob; DurationGlob)
                {
                    ApplicationArea = Basic;
                    Caption = 'Duration';

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
                        CalculateDuration(DurationGlob, CurrQtyToAllocate, 1);
                        EndDateTime := ServScheduleMgt.CalculateNewStartDateTime(ResourceNo, StartDateTime, CurrQtyToAllocate);
                        EndDate := DateTimeMgt.Datetime2Date(EndDateTime);
                        EndTime := DateTimeMgt.Datetime2Time(EndDateTime);
                    end;
                }
                field(DetailsText; DetailsText)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                }
                field(CreatedByUserID; CrUserID)
                {
                    ApplicationArea = Basic;
                    Caption = 'User ID';
                    Editable = false;
                }
            }
            group(Resource)
            {
                Caption = 'Resource';
                Editable = isResourceEditable;
                Visible = not isResourcesShown;
                field(ResourceNo; ResourceNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource No.';
                    TableRelation = Resource."No.";
                }
            }
            group(Resources)
            {
                Caption = 'Resources';
                Editable = isResourceEditable;
                Visible = isResourcesShown;
                repeater(Control1101904021)
                {
                    field(Control1101904020; Rec."Resource No.")
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
            group(Options)
            {
                Caption = 'Options';
                Visible = isOptionsShown;
                field(SplitTracking; SplitTracking)
                {
                    ApplicationArea = Basic;
                    Caption = 'Handle Linked Entries';
                    Visible = false;
                }
                field(DivideIntoLines; DivideIntoLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Divide into Serv. Lines';
                }
            }
            group(BreakOptions)
            {
                Caption = 'Break Options';
                Visible = isBreakShown;
                field(DateTime; DateTimeMgt.Datetime2Text(StartDateTime))
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Time';
                    Editable = false;
                }
                field(SchedulePassword; SchedulePassword)
                {
                    ApplicationArea = Basic;
                    Caption = 'Password';
                    ExtendedDatatype = Masked;
                }
                field(ReasonCode; ReasonCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reason';
                    TableRelation = "Serv. Break Reason";
                }
                field(StandardCode; StandardCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Standard Code';
                    TableRelation = "Serv. Standard Event";
                }
                field("<Control1101914027>"; DurationGlob)
                {
                    ApplicationArea = Basic;
                    Caption = 'Duration';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1101904013>")
            {
                Caption = 'F&unctions';
                action("<Action1101904014>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Add Resource';
                    Enabled = not isResourcesShown;
                    Image = Resource;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //AddResources(ResourceNo);  // P8
                        isResourcesShown := true;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DetailsTextChanged := false;
        DetEntryNo := LaborAllocEntry."Detail Entry No.";  //17.03.2014 Elva Baltic P8 #E0003 MMG7.00
        //DetEntryNo := 0;
        if LaborAllocEntry.Get(EntryNo) then
            if ServLaborAllocationDetail.Get(LaborAllocEntry."Detail Entry No.") then begin
                DetEntryNo := LaborAllocEntry."Detail Entry No.";  //17.03.2014 Elva Baltic P8 #E0003 MMG7.00
                DetailsText := ServLaborAllocationDetail.Description;
            end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Allocation Entry No." := GetNextNewAllocEntryNo;
        Rec."Document Type" := SourceSubType;
        Rec."Document No." := SourceID;
        Rec."Document Line No." := LineNo;
        DetailsTextChanged := false;
        DetEntryNo := 0;
    end;

    trigger OnOpenPage()
    var
        ServScheduleMgt: Codeunit "Service Schedule Mgt.";
    begin
        ServScheduleSetup.Get;

        CurrQtyToAllocate := QtyToAllocate;
        DivideIntoLines := false;

        StandardCode := ServScheduleSetup."Break Standard Code";
        ReasonCode := ServScheduleSetup."Break Reason Code";

        CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);

        StartDate := DateTimeMgt.Datetime2Date(StartDateTime);
        StartTime := DateTimeMgt.Datetime2Time(StartDateTime);

        EndDateTime := ServScheduleMgt.CalculateNewStartDateTime(ResourceNo, StartDateTime, CurrQtyToAllocate);
        EndDate := DateTimeMgt.Datetime2Date(EndDateTime);
        EndTime := DateTimeMgt.Datetime2Time(EndDateTime);
        ServScheduleMgt.FillRelatedApplicOfEntry(Rec, EntryNo, LineNo, SourceSubType, SourceID, ResourceNo, GetNextNewAllocEntryNo);
        RefreshVisibles;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        AllocatedEntryNo: Integer;
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then begin
            AllocatedEntryNo := Allocate;
            OnAfterUserAllocated(AllocatedEntryNo);
        end;
    end;

    var
        ServLaborAllocationDetail: Record "Serv. Allocation Description";
        SourceID: Code[20];
        SourceType: Option ,"Service Document","Standard Event";
        SourceSubType: Option Quote,"Order";
        ResourceNo: Code[20];
        StartDate: Date;
        EndDate: Date;
        StartTime: Time;
        EndTime: Time;
        StartDateTime: Decimal;
        EndDateTime: Decimal;
        DurationGlob: Duration;
        QtyToAllocate: Decimal;
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        ServiceLine: Record "Service Line EDMS" temporary;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        CurrQtyToAllocate: Decimal;
        Text001: label 'Duration cannot be negative';
        DivideIntoLines: Boolean;
        ServScheduleSetup: Record "Service Schedule Setup";
        ServScheduleMgt: Codeunit "Service Schedule Mgt.";
        SplitTracking: Boolean;
        EntryNo: Integer;
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        LaborAllocApplication: Record "Serv. Labor Alloc. Application";
        ResourceTmp: Record Resource temporary;
        [InDataSet]
        isResourcesShown: Boolean;
        [InDataSet]
        isOptionsShown: Boolean;
        [InDataSet]
        isBreakShown: Boolean;
        [InDataSet]
        isAllocationShown: Boolean;
        [InDataSet]
        isResourceEditable: Boolean;
        LineNo: Integer;
        NewEntryNoTmp: Integer;
        SchedulePassword: Text[20];
        ReasonCode: Code[10];
        StandardCode: Code[20];
        SourceSubTypeVisible: Boolean;
        DetailsText: Text[250];
        DetailsTextNew: Text[250];
        DetailsTextChanged: Boolean;
        DetEntryNo: Integer;
        IsNewAllocation: Boolean;
        ServHeadEDMS: Record "Service Header EDMS";
        StandardEvent: Record "Serv. Standard Event";
        ERR001: label 'Standard Event Code Not Found';
        CrUserID: Code[50];
        ForceStatus: Option Pending,"In Progress",Finished,"On Hold",Cancelled;
        Travel: Boolean;


    procedure SetParam(EntryNo1: Integer; ResourceNo1: Code[20]; StartingDateTime1: Decimal; QtyToAllocate1: Decimal; SourceType1: Option ,"Service Document","Standard Event"; SourceSubType1: Option Qoute,"Order"; SourceID1: Code[20]; Mode1: Option "New Allocation","Move Existing","Split Existing","Break"; var ServiceLine1: Record "Service Line EDMS"; ForceStatus1: Option Pending,"In Progress",Finished,"On Hold",Cancelled)
    var
        ServiceLineLoc: Record "Service Line EDMS";
        IsServiceHeader: Boolean;
        ishandled: Boolean;
    begin
        EntryNo := EntryNo1;
        ResourceNo := ResourceNo1;
        StartDateTime := StartingDateTime1;
        QtyToAllocate := QtyToAllocate1;
        SourceType := SourceType1;
        SourceSubType := SourceSubType1;
        SourceID := SourceID1;
        Mode := Mode1;
        onBeforelineID(ServiceLine1, LineNo, ishandled);
        if not ishandled then
            LineNo := 0;
        NewEntryNoTmp := 0;
        LaborAllocEntryTmp."Source Type" := SourceType;
        LaborAllocEntryTmp."Source Subtype" := SourceSubType;
        ForceStatus := ForceStatus1;

        // 26.03.2014 Elva Baltic P18 #RX026 >>
        IsNewAllocation := false;
        if (Mode = Mode::"New Allocation") and (SourceSubType = Sourcesubtype::Order) and (SourceID <> '') then
            IsNewAllocation := true;
        // 26.03.2014 Elva Baltic P18 #RX026 <<

        ServScheduleMgt.AllocationSetParam(SourceType, QtyToAllocate, ServiceLine1, ServiceLine, LineNo, Mode, SourceSubType, SourceID);
        if LaborAllocEntry.Get(EntryNo) then begin
            if ServLaborAllocationDetail.Get(LaborAllocEntry."Detail Entry No.") then
                DetailsText := ServLaborAllocationDetail.Description;
            // 31.03.2014 Elva Baltic P18 MMG7.00 >>
            CrUserID := LaborAllocEntry."User ID";
        end else
            CrUserID := UserId;
        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;


    procedure CalculateDuration(var DurationPar: Duration; var QtyToAllocate: Decimal; WhichWay: Option "To Duration","From Duration")
    begin
        if WhichWay = Whichway::"To Duration" then
            DurationPar := ROUND(QtyToAllocate * 3600000, 1);

        if WhichWay = Whichway::"From Duration" then
            QtyToAllocate := ROUND(DurationPar / 3600000, 0.0001);
    end;


    procedure Allocate(): Integer
    var
        ServScheduleMgt: Codeunit "Service Schedule Mgt.";
        SplitTracking1: Integer;
        CurrEntryNo: Integer;
    begin
        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
        CalculateDuration(DurationGlob, CurrQtyToAllocate, 1);
        if CurrQtyToAllocate < 0 then
            Error(Text001);
        Clear(ServScheduleMgt);
        if Rec.Count > 1 then begin
            FillResourcesTmpFromApplic(Rec, ResourceTmp);
        end;
        case Mode of
            Mode::"New Allocation":
                begin
                    if ResourceTmp.FindFirst then begin
                        ServScheduleMgt.ProcessAllocationResources(ResourceTmp, StartDateTime, CurrQtyToAllocate, SourceType, SourceSubType,
                            SourceID, ServiceLine, DivideIntoLines, ForceStatus, Rec.Travel);
                    end else begin
                        ServScheduleMgt.ProcessAllocation(ResourceNo, StartDateTime, CurrQtyToAllocate, SourceType, SourceSubType, SourceID, ServiceLine,
                            DivideIntoLines, ForceStatus, Rec.Travel);
                    end;
                    // find parent
                    CurrEntryNo := ServScheduleMgt.FindFirstAppliedEntryNo;  //17.03.2014 Elva Baltic P8 #E0003 MMG7.00
                    ServScheduleMgt.UpdateAllocDetailsText(CurrEntryNo, DetailsText, DetEntryNo);  //24.10.2013 EDMS P8
                    if ForceStatus = Forcestatus::"In Progress" then
                        ServScheduleMgt.FinishOtherTasks(ResourceNo, CurrEntryNo, StartDateTime);
                end;
            Mode::"Move Existing":
                begin
                    SplitTracking1 := 0;
                    if SplitTracking then
                        SplitTracking1 := 1;
                    if ResourceTmp.FindFirst then begin
                        ServScheduleMgt.ProcessMovementApp(Rec, EntryNo,
                                                   ResourceNo, StartDateTime, CurrQtyToAllocate, SplitTracking1);
                    end else begin
                        if LaborAllocEntry.Get(EntryNo) then;

                        ServScheduleMgt.ProcessMovement(EntryNo,
                                                   ResourceNo, StartDateTime, CurrQtyToAllocate, SplitTracking1, LaborAllocEntry.Status, 300, LaborAllocEntry.Travel);
                    end;
                    ServScheduleMgt.UpdateAllocDetailsText(EntryNo, DetailsText, DetEntryNo);  //24.10.2013 EDMS P8
                end;
            Mode::"Break":
                begin
                    ServScheduleMgt.CompareSchedulePassword(ResourceNo, SchedulePassword);
                    ServScheduleMgt.ProcessBreak(StandardCode, ReasonCode, CurrQtyToAllocate);
                end;
        //Mode::"Split Existing":
        // ServSchedMgt.ProcessSpliting(ResourceNo,StartingDateTime, CurrQtyToAllocate, SplitTracking);
        end;
        exit(CurrEntryNo);
    end;


    procedure AddResourceToAllocEntry(ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry")
    var
        TextNoGenRec: label 'There should be allocation already defined before, so to add to existing entry.';
        Resource: Record Resource;
    begin
        if not ServLaborAllocationEntry.FindSet then
            Error(TextNoGenRec);

        Resource.Get(ServLaborAllocationEntry."Resource No.");
        if Page.RunModal(Page::"Resource List", Resource) = Action::LookupOK then;
    end;


    procedure AddResources(ResourceNo1: Code[20])
    var
        Resource: Record Resource;
        ResourceList: Page "Resource List";
    begin
        Resource.Get(ResourceNo1);
        ResourceTmp.Reset;
        ResourceTmp.DeleteAll;
        ResourceTmp := Resource;
        ResourceTmp.Insert;
        ResourceList.SetTableview(Resource);
        ResourceList.SetRecord(Resource);
        ResourceList.LookupMode(true);
        if ResourceList.RunModal = Action::LookupOK then begin
            ResourceList.SetSelectionFilter(Resource);
            if Resource.FindFirst then begin
                //    ResourceTmp.DELETEALL;
                repeat
                    if not ResourceTmp.Get(Resource."No.") then begin
                        ResourceTmp := Resource;
                        ResourceTmp.Insert;
                    end;
                until Resource.Next = 0;
            end;
        end;
    end;


    procedure FillResourcesTmpFromApplic(var ServAllocApplic: Record "Serv. Labor Alloc. Application"; var ResourceTmpPar: Record Resource temporary)
    var
        Resource: Record Resource;
    begin
        ServAllocApplic.FindFirst;
        ResourceTmpPar.Reset;
        ResourceTmpPar.DeleteAll;
        repeat
            if Resource.Get(ServAllocApplic."Resource No.") then begin
                if not ResourceTmpPar.Get(Resource."No.") then begin
                    ResourceTmpPar := Resource;
                    ResourceTmpPar.Insert;
                end;
            end;
        until ServAllocApplic.Next = 0;
    end;


    procedure GetNextNewAllocEntryNo(): Integer
    var
        ServLaborAllocationEntryL: Record "Serv. Labor Allocation Entry";
    begin
        if NewEntryNoTmp = 0 then begin
            if ServLaborAllocationEntryL.FindLast then
                NewEntryNoTmp := ServLaborAllocationEntryL."Entry No.";
        end;
        NewEntryNoTmp += 1;
        exit(NewEntryNoTmp);
    end;


    procedure RefreshVisibles()
    begin
        SourceSubTypeVisible := (SourceType = Sourcetype::"Service Document");
        isResourcesShown := (Rec.Count > 1);
        if Mode = Mode::"Break" then begin
            isOptionsShown := false;
            isBreakShown := true;
            isAllocationShown := false;
            isResourceEditable := false;
        end else begin
            isOptionsShown := true;
            isBreakShown := false;
            isAllocationShown := true;
            isResourceEditable := true;
        end;
    end;


    procedure SetInvisibles(ForceQtyToAllocate: Decimal)
    var
        SingleInstanceManagment: Codeunit SingleInstanceManagement;
        AskForTimeQty: Page "Service Mechanic Time Qty.";
    begin
        if (ForceQtyToAllocate <> 0) then
            QtyToAllocate := ForceQtyToAllocate;

        StartDate := DateTimeMgt.Datetime2Date(StartDateTime);
        StartTime := DateTimeMgt.Datetime2Time(StartDateTime);

        //CalculateDuration(DurationGlob, CurrQtyToAllocate, 1);
        EndDateTime := ServScheduleMgt.CalculateNewStartDateTime(ResourceNo, StartDateTime, QtyToAllocate);
        EndDate := DateTimeMgt.Datetime2Date(EndDateTime);
        EndTime := DateTimeMgt.Datetime2Time(EndDateTime);

        if QtyToAllocate = 0 then begin
            if GuiAllowed then begin //11.12.2018 EB.P7
                if AskForTimeQty.RunModal = Action::OK then begin
                    QtyToAllocate := AskForTimeQty.GetTimeQty;
                    CurrQtyToAllocate := QtyToAllocate;
                    CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);
                end;
            end else begin
                CurrQtyToAllocate := 1;
                CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);
            end;
        end else begin
            CurrQtyToAllocate := QtyToAllocate;
            CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);
        end;

        CrUserID := SingleInstanceManagment.GetCurrentUserId;
    end;


    procedure SetDescription(DescriptionToSet: Text)
    begin
        DetailsText := DescriptionToSet;
    end;


    procedure SetIsTravel(IsTravel: Boolean)
    begin
        Rec.Travel := IsTravel;
    end;



    [IntegrationEvent(true, false)]
    local procedure OnAfterUserAllocated(AllocatedEntryNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure onBeforelineID(var ServiceLine1: Record "Service Line EDMS"; var LineNo: Integer; var ishandled: Boolean)
    begin
    end;


}

