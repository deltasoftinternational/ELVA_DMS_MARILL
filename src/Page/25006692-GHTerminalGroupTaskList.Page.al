Page 25006692 "GH Terminal GroupTask List"
{
    Caption = 'GH Terminal GroupTask List';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Serv. Labor Allocation Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    StyleExpr = RowAttention;
                    Visible = false;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    StyleExpr = RowAttention;
                    Visible = false;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                    StyleExpr = RowAttention;
                    Visible = false;
                }
                field(Description; ServiceScheduleMgt.GetAllocRecDescr(Rec))
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
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
        ResourceTimeRegEntry.Reset;
        ResourceTimeRegEntry.SetRange("Allocation Entry No.", Rec."Entry No.");
        ResourceTimeRegEntry.SetRange("Resource No.", Rec."Resource No.");
        ResourceTimeRegEntry.SetRange(Canceled, false);
        if ResourceTimeRegEntry.FindLast then
            TimeRegStatus := ResourceTimeRegEntry."Entry Type"
        else
            TimeRegStatus := ResourceTimeRegEntry."entry type"::Pending;

        RowAttention := ResourceTimeRegMgt.GetTaskColor(TimeRegStatus, Rec);
    end;

    trigger OnOpenPage()
    begin
        //Pool allocation entries
        ResourceGroupFilter := '_$_';
        if ResourceTimeRegMgt.GetCurrentUserResourceNo <> '' then begin
            ScheduleResourceLink.Reset;
            ScheduleResourceLink.SetRange("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
            ResourceTimeRegMgt.SetPeriodFilterResourceLink(ScheduleResourceLink);
            Rec.Reset;
            if ScheduleResourceLink.FindFirst then begin
                ResourceGroupFilter := '';
                repeat
                    ResourceGroupFilter += ScheduleResourceLink."Group Resource No." + '|';
                until ScheduleResourceLink.Next = 0;
                ResourceGroupFilter := DelChr(ResourceGroupFilter, '>', '|');
            end;

            Rec.FilterGroup(3);
            Rec.SetFilter("Resource No.", ResourceGroupFilter);
            Rec.FilterGroup(0);

        end else begin
            Error(UserResourceSetupErr);
        end;
        ResourceTimeRegMgt.SetPeriodFilter(Rec);
        CurrPage.Update;
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
        ResourceGroupFilter: Text;
        ScheduleResourceLink: Record "Schedule Resource Link";


    procedure PageUpdate()
    begin
        CurrPage.Update(false);
    end;


    procedure CopyRecFilter(var CopyServLaborAllocEntry: Record "Serv. Labor Allocation Entry")
    begin
        CopyServLaborAllocEntry.CopyFilters(Rec);
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

