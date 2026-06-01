Page 25006101 "Service Techn. Personal Tasks"
{
    Caption = 'My Tasks';
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
            group("Actions")
            {
                Caption = 'Actions';
                action(Start)
                {
                    ApplicationArea = Basic;
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunPageMode = View;

                    trigger OnAction()
                    var
                        CurrentResourceNo: Code[20];
                    begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();

                        //CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Start', Rec, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', Rec, CurrentResourceNo, WorkDate, Time);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Start', Rec, CurrentResourceNo, WorkDate, Time, '');
                        CurrPage.Update;
                    end;
                }
                action(Stop)
                {
                    ApplicationArea = Basic;
                    Image = Stop;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        CurrentResourceNo: Code[20];
                    begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();

                        //CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Stop', Rec, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Stop', Rec, CurrentResourceNo, WorkDate, Time);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Stop', Rec, CurrentResourceNo, WorkDate, Time, '');
                        CurrPage.Update;
                    end;
                }
                action(Hold)
                {
                    ApplicationArea = Basic;
                    Image = Pause;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CurrentResourceNo: Code[20];
                    begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();

                        //CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('OnHold', Rec, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('OnHold', Rec, CurrentResourceNo, WorkDate, Time);
                        ResourceTimeRegMgt.UpdateAllocationStatus('OnHold', Rec, CurrentResourceNo, WorkDate, Time, '');
                        CurrPage.Update;
                    end;
                }
                action(Complete)
                {
                    ApplicationArea = Basic;
                    Image = Completed;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CurrentResourceNo: Code[20];
                    begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();

                        //CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Complete', Rec, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Complete', Rec, CurrentResourceNo, WorkDate, Time);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Complete', Rec, CurrentResourceNo, WorkDate, Time, '');
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
}

