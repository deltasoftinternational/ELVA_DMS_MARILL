Page 25006694 "GH Terminal MyTask List"
{
    Caption = 'GH Terminal MyTask List';
    PageType = List;
    SourceTable = "Serv. Labor Allocation Entry";
    SourceTableTemporary = true;
    SourceTableView = sorting("Resource No.", Status, "Start Date-Time");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Description; ServiceScheduleMgt.GetAllocRecDescr(Rec))
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    StyleExpr = RowAttention;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(StartingDateTime; DateTimeMgt.Datetime2Text(Rec."Start Date-Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Starting Date-Time';
                }
                field(EndingDateTime; DateTimeMgt.Datetime2Text(Rec."End Date-Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Ending Date-Time';
                    Visible = false;
                }
                field(QuantityHours; Rec."Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                }
                field(Latitude; GetVehicleLocationLatitude)
                {
                    ApplicationArea = All;
                }
                field(Longitude; GetVehicleLocationLongitude)
                {
                    ApplicationArea = All;
                }
                field(Travel; Rec.Travel)
                {
                    ApplicationArea = All;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Time Reg. Entries")
            {
                ApplicationArea = Basic;
                Image = Entry;
                RunObject = Page "Resource Time Reg. Entries";
                RunPageLink = "Allocation Entry No." = field("Entry No."),
                              "Resource No." = field("Resource No.");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        // -- do not remove (NAV bug)
    end;

    trigger OnAfterGetRecord()
    begin
        /*
        ResourceTimeRegEntry.RESET;
        ResourceTimeRegEntry.SETRANGE("Allocation Entry No.","Entry No.");
        ResourceTimeRegEntry.SETRANGE("Resource No.","Resource No.");
        ResourceTimeRegEntry.SETRANGE(Canceled,FALSE);
        IF ResourceTimeRegEntry.FINDLAST THEN
          TimeRegStatus := ResourceTimeRegEntry."Entry Type"
        ELSE
          TimeRegStatus := ResourceTimeRegEntry."Entry Type"::z;
        
        RowAttention := ResourceTimeRegMgt.GetTaskColor(TimeRegStatus,Rec);
        */

    end;

    trigger OnInit()
    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        DTDayStart: Decimal;
        DTDayEnd: Decimal;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        OnDate: Date;
        OnTime: Time;
        IncludeRecord: Boolean;
    begin
        ManageCurrentTime(OnDate, OnTime);
        ServiceSetup.Get;
        ServLaborAllocationEntry.Reset;
        ServLaborAllocationEntry.SetRange("Resource No.", ResourceTimeRegMgt.GetResourceNoByUserId(UserId));
        DTDayStart := DateTimeMgt.Datetime(OnDate, 0T);
        DTDayEnd := DateTimeMgt.Datetime(OnDate, 235959.999T);
        //ServLaborAllocationEntry.SetFilter("Start Date-Time", '..%1', DTDayEnd);
        //ServLaborAllocationEntry.SetFilter("End Date-Time", '%1..', DTDayStart);
        ServLaborAllocationEntry.SetRange("Applies-to Entry No.", 0); //10/01/2018 GH P1


        if ServLaborAllocationEntry.FindFirst then
            repeat
                IncludeRecord := true;
                if ServLaborAllocationEntry."Source Type" = ServLaborAllocationEntry."source type"::"Standard Event" then begin
                    if ServLaborAllocationEntry."Source ID" = ServiceSetup."Default Idle Event" then
                        IncludeRecord := false;
                end;

                if ServLaborAllocationEntry.Status = ServLaborAllocationEntry.Status::Finished then
                    if ServLaborAllocationEntry."End Date-Time" < DTDayStart then
                        IncludeRecord := false;

                if IncludeRecord then begin
                    Rec.Init;
                    Rec := ServLaborAllocationEntry;
                    Rec.Insert;
                end
            until ServLaborAllocationEntry.Next = 0;
    end;

    var
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        DateTimeMgt: Codeunit "Datetime Mgt.";
        RowAttention: Text[20];
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        UserSetup: Record "User Setup";
        UserResourceSetupErr: label 'There is no Resource No. configured in User Setup.';
        TimeRegisterInProgressMsg: label 'Task status set to "In Progress"';
        TimeRegisterOnHoldMsg: label 'Task status set to "On Hold"';
        TimeRegisterFinishedMsg: label 'Task status set to "Finised"';
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServiceScheduleSetup: Record "Service Schedule Setup";
        TimeRegStatus: Option Pending,"In Progress",Finished,"On Hold";
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
        CustomButtonsVisible: Boolean;

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
            CrDate := WorkDate;
            CrTime := Time;
        end;
    end;

    procedure GetVehicleLocationLatitude(): Decimal
    var
        ServiceHeader: Record "Service Header EDMS";
        VehicleTelematics: Record "Vehicle Telematics";
    begin
        if Rec."Source Type" = Rec."Source type"::"Service Document" then
            if ServiceHeader.Get(Rec."Source Subtype", Rec."Source ID") then begin
                VehicleTelematics.Reset();
                VehicleTelematics.SetRange("Vehicle Serial No.", ServiceHeader."Vehicle Serial No.");
                if VehicleTelematics.FindLast() then
                    exit(VehicleTelematics.Latitude);
            end;
        exit(0);
    end;

    procedure GetVehicleLocationLongitude(): Decimal
    var
        ServiceHeader: Record "Service Header EDMS";
        VehicleTelematics: Record "Vehicle Telematics";
    begin
        if Rec."Source Type" = Rec."Source type"::"Service Document" then
            if ServiceHeader.Get(Rec."Source Subtype", Rec."Source ID") then begin
                VehicleTelematics.Reset();
                VehicleTelematics.SetRange("Vehicle Serial No.", ServiceHeader."Vehicle Serial No.");
                if VehicleTelematics.FindLast() then
                    exit(VehicleTelematics.Longitude);
            end;
        exit(0);
    end;
}

