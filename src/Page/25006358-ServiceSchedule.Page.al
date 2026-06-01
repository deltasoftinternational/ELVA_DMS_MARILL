Page 25006358 "Service Schedule"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified OnOpenPage(), Usert Profile Setup to Branch Profile Setup
    // 
    // 06.01.2015 EB.P7 EB.Schedule.Web
    //   * Removed Classic Schedule Add-in
    // 
    // 20.08.2013 EDMS P7
    //   * Added second Add-in - EB.Schedule.Web
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009

    ApplicationArea = Basic;
    Caption = 'Service Schedule';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = "Service Header EDMS";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(View)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                Visible = true;
                field(ScheduleViewCode; ScheduleViewCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'View Code';
                    Importance = Promoted;
                    TableRelation = "Schedule View";
                    Visible = true;

                    trigger OnValidate()
                    begin
                        ValidateViewCode;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(ScheduleResourceGrp; ScheduleResourceGrp)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Group';
                    Importance = Promoted;
                    TableRelation = "Schedule Resource Group";
                    Visible = ShowFieldResourceGroup;

                    trigger OnValidate()
                    begin
                        //ServScheduleWebAddInMgt.SetParameters(DecStartDT,DecEndDT,ScheduleResourceGrp, ScheduleViewCode);

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(PeriodType; PeriodType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Type';
                    Importance = Promoted;
                    Visible = ShowFieldPeriodType;

                    trigger OnValidate()
                    begin
                        ValidatePeriodType;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(StartDate; StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Date';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        ValidatePeriodStart;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
                    Visible = ShowFieldEndDate;

                    trigger OnValidate()
                    begin
                        ValidatePeriodEnd;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(StartTime; StartTime)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Time';
                    Visible = ShowFieldStartTime;

                    trigger OnValidate()
                    begin
                        ValidatePeriodStart;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(EndTime; EndTime)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Time';
                    Visible = ShowFieldEndTime;

                    trigger OnValidate()
                    begin
                        ValidatePeriodEnd;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
            }
            usercontrol(ScheduleWeb; ScheduleAddIn)
            {
                ApplicationArea = Basic;

                trigger ControlAddInReady()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                    Index: Integer;
                    Data: Text;
                begin
                    //ScheduleViewCode := 'DEFAULT';
                    //ScheduleResourceGrp := 'ALL MECH';
                    DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                    DecEndDT := DateTimeMgt.Datetime(EndDate, EndTime);
                    DecEndDT -= DateTimeMgt.Datetime(0D, 000000.001T); //minus one millisecond

                    ServScheduleWebAddInMgt.SetParameters(DecStartDT, DecEndDT, ScheduleResourceGrp, ScheduleViewCode);

                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveInitScheduleData(ScheduleData);
                end;

                trigger RequestScheduleData()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                    Index: Integer;
                    Data: Text;
                begin
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
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
                    ServScheduleWebAddInMgt.ProcessAllocation(EventType, NewResNo, NewStartDT, NewEndDT);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
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
                    ServScheduleWebAddInMgt.ProcessReallocation(EntryNo, NewResNo, NewStartDT, NewEndDT);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;

                trigger ProcessAllocationEdit(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
                begin
                    //Not used

                    ServScheduleWebAddInMgt.ProcessAllocationEdit(EntryNo, NewResNo, NewStartDT, NewEndDT);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
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
                    ServScheduleWebAddInMgt.ProcessCommands(Index, EntryNo, ResNo, CommStartDT, CommEndDT);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("<Action1101931000>")
            {
                ApplicationArea = Basic;
                Caption = 'Resource Calendar Changes';
                Image = Resource;
                RunObject = Page "Resource Calendar Changes";
            }
            action(AllocationEntries)
            {
                ApplicationArea = Basic;
                Caption = 'Allocation Entries';
                Image = CalendarMachine;

                trigger OnAction()
                var
                    AllocEntry: Record "Serv. Labor Allocation Entry";
                    DatetimeMgt: Codeunit "Datetime Mgt.";
                    ResourceNoFilter: Code[1000];
                    ResourceGrpSec: Record "Schedule Resource Group Spec.";
                begin
                    ResourceNoFilter := '';
                    ResourceGrpSec.Reset;
                    ResourceGrpSec.SetRange("Group Code", ScheduleResourceGrp);
                    if not ResourceGrpSec.FindFirst then
                        exit;
                    repeat
                        if ResourceNoFilter <> '' then
                            ResourceNoFilter += '|';
                        ResourceNoFilter += ResourceGrpSec."Resource No.";
                    until ResourceGrpSec.Next = 0;

                    AllocEntry.Reset;
                    AllocEntry.SetCurrentkey("Resource No.", "Start Date-Time", "End Date-Time");
                    AllocEntry.SetFilter("Resource No.", ResourceNoFilter);
                    AllocEntry.SetFilter("Start Date-Time", '<=%1', DatetimeMgt.Datetime(EndDate, EndTime));
                    AllocEntry.SetFilter("End Date-Time", '>%1', DatetimeMgt.Datetime(StartDate, StartTime));
                    if Page.RunModal(Page::"Serv. Labor Allocation Entries", AllocEntry) = Action::LookupOK then;
                end;
            }
        }
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
                begin
                    PeriodType := Periodtype::Day;
                    ValidatePeriodType;

                    SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101914010>")
            {
                ApplicationArea = Basic;
                Caption = 'Week';
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PeriodType := Periodtype::Week;
                    ValidatePeriodType;

                    SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
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
                begin
                    PeriodType := Periodtype::Month;
                    ValidatePeriodType;

                    SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
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
                begin
                    PeriodType := Periodtype::Custom;
                    ValidatePeriodType;

                    SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
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
                begin
                    ServScheduleWebAddInMgt.Refresh(ScheduleData);

                    SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
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
                    ServScheduleWebAddInMgt.Search(ScheduleData);
                end;
            }
        }
    }

    trigger OnInit()
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
    end;

    trigger OnOpenPage()
    begin

        SetServiceHeader(Rec);

        //IF NOT DocumentMgtDMS.IsWebClientSession THEN BEGIN
        ShowFieldPeriodType := true;
        ShowFieldResourceGroup := true;
        ShowFieldEndDate := true;
        ShowFieldStartTime := true;
        ShowFieldEndTime := true;
        //END;
        //MESSAGE(FORMAT(ActiveSession.COUNT) + ' ' + FORMAT(ActiveSession."Client Type"));

        ServiceScheduleMgt.CheckUserRightsInit;
        ServiceScheduleMgt.CheckUserRights(0);

        ServiceScheduleSetup.Get;

        if (ScheduleViewCode = '') then begin
            if ServiceScheduleSetup."Def. View Code" <> '' then
                ScheduleViewCode := ServiceScheduleSetup."Def. View Code";
            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) and (UserProfile."Service Schedule View Code" <> '') then
                ScheduleViewCode := UserProfile."Service Schedule View Code";
        end;

        ValidateViewCode;

        if AllocationIsSet then begin
            ScheduleResourceGrp := GetResourceGroup(ScheduleResourceGrp, SetResourceNo);
            StartDate := SetStartDate;
            if StartTime > SetStartTime then
                StartTime := SetStartTime;
            ValidatePeriodStart;
        end;

        //ServScheduleAddInMgt.Refresh(_xml);
    end;

    var
        ScheduleData: Text;
        PeriodType: Option Custom,Day,Week,Month;
        StartDate: Date;
        EndDate: Date;
        StartTime: Time;
        EndTime: Time;
        ScheduleViewCode: Code[20];
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        ServiceScheduleSetup: Record "Service Schedule Setup";
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
        ServScheduleWebAddInMgt: Codeunit "Serv. Schedule Web Add-In Mgt.";
        UseScheduleWebAddIn: Boolean;
        UseScheduleClassicAddIn: Boolean;
        ShowFieldPeriodType: Boolean;
        ShowFieldResourceGroup: Boolean;
        ShowFieldEndDate: Boolean;
        ShowFieldStartTime: Boolean;
        ShowFieldEndTime: Boolean;


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
        ScheduleData += StrSubstNo('Command:1010,Header From Date,%1', CreateDatetime(StartDate, StartTime), 1);
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

    procedure CalcPeriodEnd(PeriodType: Option Custom,Day,Week,Month; StartDT: DateTime): DateTime
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


    procedure CalcPeriodStart(PeriodType: Option Custom,Day,Week,Month; EndDT: DateTime): DateTime
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

        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
    end;

    procedure PrevPeriod()
    var
        Date1: Date;
        DayCount: Integer;
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

        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', false);
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

    procedure ValidateViewCode()
    var
        ScheduleView: Record "Schedule View";
    begin
        if ScheduleViewCode = '' then
            exit;

        ScheduleView.Get(ScheduleViewCode);
        PeriodType := ScheduleView."Period Type";
        StartDate := CalcDate(ScheduleView."Start Date Formula", WorkDate);
        StartTime := ScheduleView."Start Time";
        EndTime := ScheduleView."End Time";
        ValidatePeriodType;

        ScheduleResourceGrp := ScheduleView."Resource Group";
        //MESSAGE('ScheduleResourceGrp='+ScheduleResourceGrp);
    end;

    procedure SetAllocation(var AllocationEntry: Record "Serv. Labor Allocation Entry")
    begin
        SetStartDate := DateTimeMgt.Datetime2Date(AllocationEntry."Start Date-Time");
        SetStartTime := DateTimeMgt.Datetime2Time(AllocationEntry."Start Date-Time");
        SetResourceNo := AllocationEntry."Resource No.";
        AllocationIsSet := true;
    end;

    procedure GetResourceGroup(CurrGroupCode: Code[20]; ResourceNo: Code[20]): Code[20]
    var
        ScheduleResourceGroupSpec: Record "Schedule Resource Group Spec.";
    begin
        ScheduleResourceGroupSpec.Reset;
        ScheduleResourceGroupSpec.SetRange("Group Code", CurrGroupCode);
        ScheduleResourceGroupSpec.SetRange("Resource No.", ResourceNo);
        if ScheduleResourceGroupSpec.FindFirst then
            exit(CurrGroupCode);

        ScheduleResourceGroupSpec.Reset;
        ScheduleResourceGroupSpec.SetRange("Resource No.", ResourceNo);
        ScheduleResourceGroupSpec.FindFirst;
        exit(ScheduleResourceGroupSpec."Group Code");
    end;

    procedure SetServiceHeader(var ServiceHeader: Record "Service Header EDMS")
    var
        AllocationEntry: Record "Serv. Labor Allocation Entry";
    begin
        AllocationEntry.SetCurrentkey("Source Type", "Source Subtype", "Source ID", "Start Date-Time");
        AllocationEntry.SetRange("Source Type", AllocationEntry."source type"::"Service Document");
        AllocationEntry.SetRange("Source Subtype", ServiceHeader."Document Type");
        AllocationEntry.SetRange("Source ID", ServiceHeader."No.");
        if AllocationEntry.FindFirst then
            SetAllocation(AllocationEntry);
        SingleInstanceMgt.SetServiceHeader(ServiceHeader);
    end;

    procedure SetParams(FormStartDate: Date; FormStartTime: Time; FormEndDate: Date; FormEndTime: Time; FormScheduleResourceGroup: Code[20]; FormScheduleViewCode: Code[20])
    var
        DecStartDT: Decimal;
        DecEndDT: Decimal;
    begin
        DecStartDT := DateTimeMgt.Datetime(FormStartDate, FormStartTime);
        DecEndDT := DateTimeMgt.Datetime(FormEndDate, FormEndTime);
        DecEndDT -= DateTimeMgt.Datetime(0D, 000000.001T); //minus one millisecond
        ServScheduleWebAddInMgt.SetParameters(DecStartDT, DecEndDT, FormScheduleResourceGroup, FormScheduleViewCode);
    end;
}

