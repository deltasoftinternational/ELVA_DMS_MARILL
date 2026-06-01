Page 25006291 "Service Mechanic Pers. Tasks"
{
    Caption = 'My Tasks';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Serv. Labor Allocation Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
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
                field(CellDescription; ServiceScheduleMgt.GetAllocRecDescr(Rec))
                {
                    ApplicationArea = Basic;
                    Caption = 'Cell Description';
                    StyleExpr = RowAttention;
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
                field(ResourceNo; Rec."Resource No.")
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
                field(TimeRegStatus; TimeRegStatus)
                {
                    ApplicationArea = Basic;
                    Caption = 'Status';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Caption = 'Entry Status';
                    Visible = false;
                }
                field(TotalTimeSpent; Rec."Total Time Spent")
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
            action("Start Travel Task")
            {
                ApplicationArea = Basic;
                Image = "Action";
                RunPageMode = View;
                Scope = Repeater;

                trigger OnAction()
                begin
                    ResourceTimeRegMgt.StartNewTravelTaskFromAllocation(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time);
                    CurrPage.Update;
                end;
            }
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
        if ResourceTimeRegMgt.GetCurrentUserResourceNo <> '' then begin
            Rec.Reset;
            Rec.FilterGroup(3);
            Rec.SetRange("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
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
        SingleInstanceManagement: Codeunit SingleInstanceManagement;
        TimeRegStatus: Option Pending,"In Progress",Finished,"On Hold";
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";


    procedure PageUpdate()
    begin
        CurrPage.Update(false);
    end;


    procedure CopyRecFilter(var CopyServLaborAllocEntry: Record "Serv. Labor Allocation Entry")
    begin
        CopyServLaborAllocEntry.CopyFilters(Rec);
    end;
}

