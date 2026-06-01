Page 25006379 "Start Unplanned"
{

    layout
    {
        area(content)
        {
            field(SourceType; SourceType)
            {
                ApplicationArea = Basic;
                Caption = 'Source Type';
                Enabled = false;
            }
            field(SourceID; SourceID)
            {
                ApplicationArea = Basic;
                Caption = 'Source ID';
                Enabled = false;
            }
            field(ResourceNo; ResourceNo)
            {
                ApplicationArea = Basic;
                Caption = 'Resource No.';
            }
            field(ReasonCode; ReasonCode)
            {
                ApplicationArea = Basic;
                Caption = 'Reason';
            }
            field(SchedulePassword; SchedulePassword)
            {
                ApplicationArea = Basic;
                Caption = 'Pasword';
                ExtendedDatatype = Masked;
            }
            field(StartingDate; StartingDate)
            {
                ApplicationArea = Basic;
                Caption = 'Starting Date';
                Enabled = false;
            }
            field(StartingTime; StartingTime)
            {
                ApplicationArea = Basic;
                Caption = 'Starting Time';
                Enabled = false;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ServiceScheduleSetup.Get;
        ServStandardEvent.Get(SourceID);
        CurrQtyToAllocate := 0.001;
        CalculateDuration(Duration, CurrQtyToAllocate, 0);

        StartingDate := DateTimeMgt.Datetime2Date(StartingDateTime);
        StartingTime := DateTimeMgt.Datetime2Time(StartingDateTime);

        EndingDateTime := ServSchedMgt.CalculateNewStartDateTime(ResourceNo, StartingDateTime, CurrQtyToAllocate);
        EndingDate := DateTimeMgt.Datetime2Date(EndingDateTime);
        EndingTime := DateTimeMgt.Datetime2Time(EndingDateTime);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then begin
            StartAlloc;
        end;
    end;

    var
        ServiceScheduleSetup: Record "Service Schedule Setup";
        ServStandardEvent: Record "Serv. Standard Event";
        ServiceLine: Record "Service Line EDMS" temporary;
        ServLaborAllocEntry: Record "Serv. Labor Allocation Entry";
        ServSchedMgt: Codeunit "Service Schedule Mgt.";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ResourceNo: Code[20];
        SourceID: Code[20];
        ReasonCode: Code[10];
        SchedulePassword: Text[20];
        SourceType: Option ,"Service Document","Standard Event";
        SourceSubType: Option Quote,"Order";
        StartingDate: Date;
        EndingDate: Date;
        StartingTime: Time;
        EndingTime: Time;
        StartingDateTime: Decimal;
        EndingDateTime: Decimal;
        CurrQtyToAllocate: Decimal;
        TotalHours: Decimal;
        Duration: Duration;
        Text001: label 'You can not allocate entry which duration is negative';


    procedure SetParam(ResourceNo1: Code[20]; StartingDateTime1: Decimal; SourceType1: Option ,"Service Document","Standard Event"; SourceSubType1: Option Qoute,"Order"; SourceID1: Code[20])
    var
        ServiceLineLoc: Record "Service Line EDMS";
    begin
        ResourceNo := ResourceNo1;
        StartingDateTime := StartingDateTime1;
        SourceType := SourceType1;
        SourceSubType := SourceSubType1;
        SourceID := SourceID1;
    end;


    procedure CalculateDuration(var Duration: Duration; var QtyToAllocate: Decimal; WhichWay: Option "To Duration","From Duration")
    begin
        if WhichWay = Whichway::"To Duration" then
            Duration := ROUND(QtyToAllocate * 3600000, 1);

        if WhichWay = Whichway::"From Duration" then
            QtyToAllocate := ROUND(Duration / 3600000, 0.0001);
    end;


    procedure StartAlloc()
    begin
        ServSchedMgt.CompareSchedulePassword(ResourceNo, SchedulePassword);

        StartingDateTime := DateTimeMgt.Datetime(StartingDate, StartingTime);
        CalculateDuration(Duration, CurrQtyToAllocate, 1);
        if CurrQtyToAllocate < 0 then
            Error(Text001);
        Clear(ServSchedMgt);
        ServSchedMgt.ProcessAllocation(ResourceNo, StartingDateTime, CurrQtyToAllocate, SourceType, SourceSubType, SourceID, ServiceLine,
                                       false, 0, false);

        ServLaborAllocEntry.Reset;
        ServLaborAllocEntry.SetCurrentkey("Resource No.");
        ServLaborAllocEntry.SetRange("Resource No.", ResourceNo);
        ServLaborAllocEntry.FindLast;
        ServLaborAllocEntry."Reason Code" := ReasonCode;
        ServLaborAllocEntry.Modify;

        SingleInstanceMgt.SetCurrAllocation(ServLaborAllocEntry."Entry No.");

        ServSchedMgt.CheckStartAndPlan(ServLaborAllocEntry."Entry No.");

        ServSchedMgt.ProcessStartLabor(StartingDateTime, ReasonCode);
    end;
}

