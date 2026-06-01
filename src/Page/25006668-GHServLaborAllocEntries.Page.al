Page 25006668 "GH Serv. Labor Alloc. Entries"
{
    // 23.03.2010 EDMSB P2
    //   * Added menu item Allocation->Serv. Alloc. Application

    Caption = 'Service Resource Allocations';
    DataCaptionFields = "Source Type";
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Serv. Labor Allocation Entry";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
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
                field(GetCellDescriptionCtrl; GetCellDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cell Description';
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
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(QuantityHours; Rec."Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(DetailEntryNo; Rec."Detail Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Travel; Rec.Travel)
                {
                    ApplicationArea = Basic;
                }
                field(TotalTimeSpentTravel; Rec."Total Time Spent Travel")
                {
                    ApplicationArea = Basic;
                }
                field(PlannedStartDateTime; DateTimeMgt.Datetime2Text(Rec."Planned Start Date-Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Planned Start Date-Time';
                }
                field(PlannedEndDateTime; DateTimeMgt.Datetime2Text(Rec."Planned End Date-Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Planned End Date-Time';
                }
                field(PlannedDurationHours; Rec."Planned Duration (Hours)")
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Allocation)
            {
                Caption = 'Allocation';
                action(ShowDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Document';
                    Image = View;

                    trigger OnAction()
                    var
                        ServiceHdr: Record "Service Header EDMS";
                    begin
                        ServiceHdr.Reset;
                        ServiceHdr.SetRange("Document Type", Rec."Source Subtype");
                        ServiceHdr.SetRange("No.", Rec."Source ID");
                        if ServiceHdr.FindFirst then begin
                            if ServiceHdr."Document Type" = ServiceHdr."document type"::Quote then
                                Page.RunModal(Page::"Service Quote EDMS", ServiceHdr);
                            if ServiceHdr."Document Type" = ServiceHdr."document type"::Order then
                                Page.RunModal(Page::"Service Order EDMS", ServiceHdr);
                        end;
                    end;
                }
                action(ShowinSchedule)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show in Schedule';
                    Image = Planning;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "Service Schedule";
                    begin
                        ServiceSchedule.SetAllocation(Rec);
                        ServiceSchedule.RunModal;
                    end;
                }
                action(ServAllocApplication)
                {
                    ApplicationArea = Basic;
                    Caption = 'Serv. Alloc. Application';
                    Image = Resource;
                    RunObject = Page "Serv. Labor Alloc. Application";
                    RunPageLink = "Allocation Entry No." = field("Entry No.");
                    RunPageView = sorting("Allocation Entry No.", "Document Type", "Document No.", "Document Line No.");
                }
            }
            group(Functions)
            {
                Caption = '&Functions';
                action("<Action1190019>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Change End Date/Time';
                    Image = Edit;

                    trigger OnAction()
                    begin
                        ServiceScheduleMgt.ChangeFinishedAllocEnding(Rec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        Rec.SetRange("Resource No.", UserSetup."Resource No.");
    end;

    var
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";


    procedure GetCellDescription(): Text[250]
    begin
        exit(ServiceScheduleMgt.GetAllocRecDescr(Rec));
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

