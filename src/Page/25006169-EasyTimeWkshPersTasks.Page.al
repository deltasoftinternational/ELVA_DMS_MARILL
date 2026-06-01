Page 25006169 "Easy Time Wksh. Pers. Tasks"
{
    Caption = 'My Tasks';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Serv. Labor Allocation Entry";
    //SourceTableTemporary = true;
    SourceTableView = sorting("Resource No.", Status, "Start Date-Time");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(CellDescription; ServiceScheduleMgt.GetAllocRecDescr(Rec))
                {
                    ApplicationArea = Basic;
                    Caption = 'Cell Description';
                    StyleExpr = RowAttention;
                }
                field(TimeRegStatus; TimeRegStatus)
                {
                    ApplicationArea = Basic;
                    Caption = 'Status';
                    Editable = false;
                }
                field(TotalTimeSpent; Rec."Total Time Spent")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                    Editable = false;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ResourceGroupCode; Rec."Resource Group Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ParentAllocEntryNo; Rec."Parent Alloc. Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ApplicationEntryCount; Rec."Application Entry Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    StyleExpr = RowAttention;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    StyleExpr = RowAttention;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                    StyleExpr = RowAttention;
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Travel; Rec.Travel)
                {
                    ApplicationArea = Basic;
                }
                field(TotalTimeSpentTravel; Rec."Total Time Spent Travel")
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

    /*
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
        SingleInstanceManagment: Codeunit SingleInstanceManagement;
        Period: Option;
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

        //Message(format(OnDate));


        //Rec.DeleteAll();
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
    */

    trigger OnOpenPage()
    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        StandardEvent: Record "Serv. Standard Event";
    begin

        ServiceSetup.Get;

        if ResourceTimeRegMgt.GetCurrentUserResourceNo <> '' then begin
            Rec.Reset;
            Rec.FilterGroup(3);
            Rec.SetRange("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
            if ServiceSetup."Default Idle Event" <> '' then begin
                StandardEvent.Get(ServiceSetup."Default Idle Event");
                Rec.SetFilter("Source ID", '<>%1', StandardEvent.Code);
            end;
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


    procedure PageUpdate()
    begin
        CurrPage.Update(false);
    end;


    procedure CopyRecFilter(var CopyServLaborAllocEntry: Record "Serv. Labor Allocation Entry")
    begin
        CopyServLaborAllocEntry.CopyFilters(Rec);
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
            CrDate := WorkDate;
            CrTime := Time;
        end;
    end;
}

