Page 25006102 "Service Techn. Group Tasks"
{
    Caption = 'Group Tasks';
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'aaa,bbb,ccc,ddd,Task,Card';
    SourceTable = "Serv. Labor Allocation Entry";

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
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup25006018)
            {
                action("Start Task")
                {
                    ApplicationArea = Basic;
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.StartNewTaskFromAllocation(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time);
                        CurrPage.Update;
                    end;
                }
                action("Start Travel Task")
                {
                    ApplicationArea = Basic;
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.StartNewTravelTaskFromAllocation(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time);
                        CurrPage.Update;
                    end;
                }
            }
        }
        area(navigation)
        {
            group(Navigation)
            {
                Caption = 'Navigation';
                action(Open)
                {
                    ApplicationArea = Basic;
                    Caption = 'Open';
                    Image = ViewDetails;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServiceOrder: Page "Service Order EDMS";
                        ServiceHeader: Record "Service Header EDMS";
                        Allocation: Page Allocation;
                        ServScheduleMgt: Codeunit "Service Schedule Mgt.";
                        EasyClockingManagement: Codeunit "Easy Clocking Management";
                    begin
                        EasyClockingManagement.ProcessLookupAction(Rec);
                    end;
                }
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
    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        StandardEvent: Record "Serv. Standard Event";
    begin
        ServiceSetup.Get;
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
}

