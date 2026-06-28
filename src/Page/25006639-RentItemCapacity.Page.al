Page 25006639 "Rent Item Capacity"
{
    ApplicationArea = Basic;
    SourceTable = "Service Header EDMS";
    UsageCategory = Lists;
    PageType = List;

    layout
    {
        area(content)
        {
            group(Control25006001)
            {
                ShowCaption = false;
                field(PeriodTypeControl; PeriodType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Type';
                    Importance = Promoted;
                    Visible = ShowFieldPeriodType;

                    trigger OnValidate()
                    var
                        DecStartDT: Decimal;
                        DecEndDT: Decimal;
                    begin
                        ValidatePeriodType;
                        DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                        DecEndDT := CreateEndDateTime(EndDate, EndTime);

                        RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                        RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(StartDate; StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Date';
                    Importance = Promoted;

                    trigger OnValidate()
                    var
                        DecStartDT: Decimal;
                        DecEndDT: Decimal;
                    begin
                        ValidatePeriodStart;
                        DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                        DecEndDT := CreateEndDateTime(EndDate, EndTime);

                        RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                        RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
                    Visible = ShowFieldEndDate;

                    trigger OnValidate()
                    var
                        DecStartDT: Decimal;
                        DecEndDT: Decimal;
                    begin
                        ValidatePeriodEnd;
                        DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                        DecEndDT := CreateEndDateTime(EndDate, EndTime);

                        RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                        RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(StartTime; StartTime)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Time';
                    Visible = ShowFieldStartTime;

                    trigger OnValidate()
                    var
                        DecStartDT: Decimal;
                        DecEndDT: Decimal;
                    begin
                        ValidatePeriodStart;
                        DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                        DecEndDT := CreateEndDateTime(EndDate, EndTime);

                        RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                        RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(EndTime; EndTime)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Time';
                    Visible = ShowFieldEndTime;

                    trigger OnValidate()
                    var
                        DecStartDT: Decimal;
                        DecEndDT: Decimal;
                    begin
                        ValidatePeriodEnd;
                        DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                        DecEndDT := CreateEndDateTime(EndDate, EndTime);

                        RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                        RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
            }
            usercontrol(ScheduleWeb; RentScheduleAddIn)
            {
                ApplicationArea = Basic;

                trigger ControlAddInReady()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                    Index: Integer;
                    Data: Text;
                begin
                    //MESSAGE(FORMAT(StartDate)+' '+FORMAT(EndDate)+' '+FORMAT(StartTime)+' '+FORMAT(EndTime));
                    //MESSAGE(DepartmentCode);
                    //ValidatePeriodType;
                    DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                    DecEndDT := CreateEndDateTime(EndDate, EndTime);

                    RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveInitScheduleData(ScheduleData);
                end;

                trigger RequestScheduleData()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                    Index: Integer;
                    Data: Text;
                begin
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;

                trigger ProcessAllocation(EventType: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
                var
                    QtyToAllocate: Decimal;
                    SplitTracking: Integer;
                    Text001: label 'Standard Event,Service Line,Service Header';
                    Diag: Dialog;
                    Text002: label 'Select allocation type';
                begin
                    EXIT;
                    RentScheduleAddInMgt.ProcessAllocation(EventType, NewResNo, NewStartDT, NewEndDT);
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;

                trigger ProcessReallocation(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
                var
                    LaborAllocEntry: Record "Serv. Labor Allocation Entry";
                    QtyToAllocate: Decimal;
                    SplitTracking: Integer;
                    CurrItemID: Code[100];
                    CurrResGroupCode: Code[20];
                begin
                    EXIT;
                    RentScheduleAddInMgt.ProcessReallocation(EntryNo, NewResNo, NewStartDT, NewEndDT);
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;

                trigger ProcessAllocationEdit(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
                begin
                    EXIT;
                    //Not used
                    RentScheduleAddInMgt.ProcessAllocationEdit(EntryNo, NewResNo, NewStartDT, NewEndDT);
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;

                trigger ProcessCommands(Index: Integer; EntryNo: Integer; ResNo: Code[20]; CommStartDT: Decimal; CommEndDT: Decimal)
                var
                    QtyToAllocate: Decimal;
                    SplitTracking: Integer;
                    Text001: label 'Standard Event,Service Line,Service Header';
                    Diag: Dialog;
                    Text002: label 'Select allocation type';
                begin
                    EXIT;
                    RentScheduleAddInMgt.ProcessCommands(Index, EntryNo, ResNo, CommStartDT, CommEndDT);
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action12>")
            {
                ApplicationArea = Basic;
                Caption = 'Previous Period';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Previous Set';

                trigger OnAction()
                begin
                    PrevPeriod
                end;
            }
            action("<Action112>")
            {
                ApplicationArea = Basic;
                Caption = 'Next Period';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Next Set';

                trigger OnAction()
                begin
                    NextPeriod
                end;
            }
            action(Day)
            {
                ApplicationArea = Basic;
                Caption = 'Day';
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                begin
                    PeriodType := Periodtype::Day;
                    ValidatePeriodType;


                    DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                    DecEndDT := CreateEndDateTime(EndDate, EndTime);

                    RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);

                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101914011>")
            {
                ApplicationArea = Basic;
                Caption = 'Week';
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                begin
                    PeriodType := Periodtype::Week;
                    ValidatePeriodType;

                    DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                    DecEndDT := CreateEndDateTime(EndDate, EndTime);

                    RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101914010>")
            {
                ApplicationArea = Basic;
                Caption = 'Work Week';
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                begin
                    PeriodType := Periodtype::WorkWeek;
                    ValidatePeriodType;

                    DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                    DecEndDT := CreateEndDateTime(EndDate, EndTime);

                    RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101904011>")
            {
                ApplicationArea = Basic;
                Caption = 'Month';
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                begin
                    PeriodType := Periodtype::Month;
                    ValidatePeriodType;

                    DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                    DecEndDT := CreateEndDateTime(EndDate, EndTime);

                    RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101924010>")
            {
                ApplicationArea = Basic;
                Caption = 'Custom';
                Enabled = false;
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                begin
                    PeriodType := Periodtype::Custom;
                    ValidatePeriodType;

                    DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                    DecEndDT := CreateEndDateTime(EndDate, EndTime);

                    RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101904012>")
            {
                ApplicationArea = Basic;
                Caption = 'Refresh Data';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                begin
                    RentScheduleAddInMgt.Refresh(ScheduleData);

                    DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                    DecEndDT := CreateEndDateTime(EndDate, EndTime);

                    RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
                    RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101901000>")
            {
                ApplicationArea = Basic;
                Caption = 'Search';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RentScheduleAddInMgt.Search(ScheduleData);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetServiceHeader(Rec);
        ShowFieldPeriodType := true;
        ShowFieldEndDate := true;
        ShowFieldStartTime := true;
        ShowFieldEndTime := true;

        // ServiceScheduleMgt.CheckUserRightsInit;
        // ServiceScheduleMgt.CheckUserRights(0);

        ServiceScheduleSetup.Get;

        if SetStartDate = 0D then
            SetStartDate := WorkDate;

        StartDate := SetStartDate;
        if StartTime > SetStartTime then
            StartTime := SetStartTime;

        RentMgtSetup.get;
        if RentMgtSetup."Default Capacity Period" = 0 then
            PeriodType := Periodtype::Month
        else
            PeriodType := RentMgtSetup."Default Capacity Period";

        ValidatePeriodStart;
    end;

    var
        ScheduleData: Text;
        PeriodType: Option Custom,Day,WorkWeek,Month,Week;
        StartDate: Date;
        EndDate: Date;
        StartTime: Time;
        EndTime: Time;
        DepartmentCode: Code[20];
        ScheduleViewCode: Code[20];
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        ServiceScheduleSetup: Record "Service Schedule Setup";
        RentMgtSetup: Record "Rent Mgt. Setup";
        UserProfile: Record "Branch Profile Setup";
        ScheduleResourceGrp: Code[10];
        SetStartDate: Date;
        SetStartTime: Time;
        SetResourceNo: Code[20];
        AllocationIsSet: Boolean;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        UserProfileMgt: Codeunit UserProfileManagement;
        "-----------": Boolean;
        DocumentMgtDMS: Codeunit DocumentManagementDMS;
        ServScheduleMgt: Codeunit "Service Schedule Mgt.";
        RentScheduleAddInMgt: Codeunit "Rent Schedule Add-In Mgt.";
        UseScheduleWebAddIn: Boolean;
        UseScheduleClassicAddIn: Boolean;
        ShowFieldPeriodType: Boolean;
        ShowFieldResourceGroup: Boolean;
        ShowFieldEndDate: Boolean;
        ShowFieldStartTime: Boolean;
        ShowFieldEndTime: Boolean;
        RentItems: Record "Rent Item";
        FillByItemOrAsset: Option Item,Asset;

    //>>DELTA XX
    protected var
        //<<DELTA XX
        RentAssets: Record "Rent Asset";

    procedure ValidatePeriodStart()
    var
        DT: DateTime;
    begin
        DT := CalcPeriodStart(PeriodType, CreateDatetime(StartDate, StartTime));
        StartDate := Dt2Date(DT);
        StartTime := Dt2Time(DT);

        DT := CalcPeriodEnd(PeriodType, CreateDatetime(StartDate, StartTime));
        EndDate := Dt2Date(DT);
        EndTime := Dt2Time(DT);

        Clear(ScheduleData);
        //ScheduleData.AddText(StrSubstNo('Command:1010,Header From Date,%1', CreateDatetime(StartDate, StartTime)), 1);
        ScheduleData := ScheduleData + StrSubstNo('Command:1010,Header From Date,%1', CreateDatetime(StartDate, StartTime), 1);
        CurrPage.Update(true);
    end;

    procedure ValidatePeriodEnd()
    var
        DT: DateTime;
    begin
        DT := CalcPeriodEnd(PeriodType, CreateDatetime(EndDate, EndTime));
        EndDate := Dt2Date(DT);
        EndTime := Dt2Time(DT);

        DT := CalcPeriodStart(PeriodType, CreateDatetime(EndDate, EndTime));
        StartDate := Dt2Date(DT);
        StartTime := Dt2Time(DT);

        Clear(ScheduleData);
        //ScheduleData.AddText(StrSubstNo('Command:1010,Header To Date,%1', CreateDatetime(EndDate, EndTime), 1));
        ScheduleData += StrSubstNo('Command:1010,Header To Date,%1', CreateDatetime(EndDate, EndTime), 1);
        CurrPage.Update(false);
    end;


    procedure ValidatePeriodType()
    begin
        ValidatePeriodStart;
    end;


    procedure CalcPeriodEnd(PeriodType: Option Custom,Day,WorkWeek,Month,Week; StartDT: DateTime): DateTime
    var
        Date1: Record Date;
    begin
        case PeriodType of
            Periodtype::Custom:
                begin
                    exit(CreateDatetime(EndDate, EndTime));
                end;
            Periodtype::Day:
                begin
                    exit(CreateDatetime(Dt2Date(StartDT), EndTime));
                end;
            Periodtype::WorkWeek:
                begin
                    exit(CreateDatetime(CalcDate('<CW>', Dt2Date(StartDT)), EndTime));
                end;
            Periodtype::Week:
                begin
                    exit(CreateDatetime(CalcDate('<CW>', Dt2Date(StartDT)), EndTime));
                end;
            Periodtype::Month:
                begin
                    exit(CreateDatetime(CalcDate('<CM>', Dt2Date(StartDT)), EndTime));
                end;
        end;
    end;


    procedure CalcPeriodStart(PeriodType: Option Custom,Day,WorkWeek,Month,Week; EndDT: DateTime): DateTime
    var
        Date1: Record Date;
    begin
        case PeriodType of
            Periodtype::Custom:
                begin
                    exit(CreateDatetime(StartDate, StartTime));
                end;
            Periodtype::Day:
                begin
                    exit(CreateDatetime(Dt2Date(EndDT), StartTime));
                end;
            Periodtype::WorkWeek:
                begin
                    exit(CreateDatetime(CalcDate('<-1W>', CalcDate('<CW>', Dt2Date(EndDT)) + 1), StartTime));
                end;
            Periodtype::Week:
                begin
                    exit(CreateDatetime(CalcDate('<-1W>', CalcDate('<CW>', Dt2Date(EndDT)) + 1), StartTime));
                end;
            Periodtype::Month:
                begin
                    exit(CreateDatetime(CalcDate('<-1M>', CalcDate('<CM>', Dt2Date(EndDT)) + 1), StartTime));
                end;
        end;
    end;

    procedure NextPeriod()
    var
        Date1: Date;
        DayCount: Integer;
        DecStartDT: Decimal;
        DecEndDT: Decimal;
    begin
        case PeriodType of
            Periodtype::Custom:
                begin
                    DayCount := EndDate - StartDate + 1;
                    EndDate := EndDate + DayCount;
                    StartDate := StartDate + DayCount;
                end
            else
                EndDate := EndDate + 1;
        end;
        ValidatePeriodEnd;


        DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
        DecEndDT := CreateEndDateTime(EndDate, EndTime);

        RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);

        RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
    end;

    procedure PrevPeriod()
    var
        Date1: Date;
        DayCount: Integer;
        DecStartDT: Decimal;
        DecEndDT: Decimal;
    begin
        case PeriodType of
            Periodtype::Custom:
                begin
                    DayCount := EndDate - StartDate + 1;
                    EndDate := EndDate - DayCount;
                    StartDate := StartDate - DayCount;
                end
            else
                StartDate := StartDate - 1;
        end;

        ValidatePeriodStart;

        DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
        DecEndDT := CreateEndDateTime(EndDate, EndTime);

        RentScheduleAddInMgt.SetRentParameters(DecStartDT, DecEndDT, RentItems, RentAssets, FillByItemOrAsset, PeriodType);
        RentScheduleAddInMgt.FillTextData(ScheduleData, 0, '', false);
        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
    end;

    procedure SetPeriodStart(SDate: Date; STime: Time)
    begin
        StartDate := SDate;
        StartTime := STime;
    end;

    procedure SetPeriodEnd(EDate: Date; ETime: Time)
    begin
        EndDate := EDate;
        EndTime := ETime;
    end;

    procedure SetServiceHeader(var ServiceHeader: Record "Service Header EDMS")
    var
        AllocationEntry: Record "Serv. Labor Allocation Entry";
    begin
        SingleInstanceMgt.SetServiceHeader(ServiceHeader);
    end;

    procedure SetRentItems(var RentItemsToSet: Record "Rent Item")
    begin

        RentItems := RentItemsToSet;
        RentItems.CopyFilters(RentItemsToSet);

    end;

    procedure SetRentAssets(var RentAssetsToSet: Record "Rent Asset"; MarkedOnly: boolean)
    begin
        RentAssets.CopyFilters(RentAssetsToSet);

        if MarkedOnly then
            RentAssetsToSet.MarkedOnly(True);

        if RentAssetsToSet.FindFirst() then
            repeat
                if RentAssets.get(RentAssetsToSet."No.") then
                    RentAssets.Mark(True);
            until RentAssetsToSet.Next() = 0;
        RentAssets.MarkedOnly(true);

    end;

    procedure SetItemOrAsset(FillByItemOrAssetToSet: Option)
    begin
        FillByItemOrAsset := FillByItemOrAssetToSet;
    end;

    procedure CreateEndDateTime(EndDateForModify: Date; EndTimeForModify: Time): Decimal
    var
        CreatedEndDateTime: Decimal;
    begin
        EndDateForModify := EndDateForModify + 1;
        CreatedEndDateTime := DateTimeMgt.Datetime(EndDateForModify, EndTimeForModify);
        CreatedEndDateTime -= DateTimeMgt.Datetime(0D, 000000.001T); //minus one millisecond
        EXIT(CreatedEndDateTime);
    end;
}

