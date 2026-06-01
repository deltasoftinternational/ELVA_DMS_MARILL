Page 25006290 "Service Time Worksheet"
{
    Caption = 'Service Time Worksheet';
    DataCaptionExpression = DashboardTitle;
    PageType = Card;
    PromotedActionCategories = 'User,Work Time,Task,Period,Actions';

    layout
    {
        area(content)
        {
            part(ServiceMechanicPersTasks; "Service Mechanic Pers. Tasks")
            {
                ApplicationArea = All;
            }
            part(ServiceMechanicPoolTasks; "Service Mechanic Pool Tasks")
            {
                ApplicationArea = All;
            }
            part(ServiceMechanicHeaderTasks; "Service Mechanic Header Tasks")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            part(ServiceMechanicLineTasks; "Service Mechanic Line Tasks")
            {
                ApplicationArea = All;
                Provider = ServiceMechanicHeaderTasks;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
                SubPageView = where(Type = filter(Labor));
                UpdatePropagation = Both;
            }
            usercontrol(PingPong; PingPongAddIn)
            {
                ApplicationArea = Basic;

                trigger ControlAddInReady()
                begin
                    RefreshInMinutes := ResourceTimeRegMgt.GetDashboardRefreshInMinutes;
                    CurrPage.PingPong.Ping(60000 * RefreshInMinutes); //5min
                end;

                trigger Pong()
                begin
                    RefreshInMinutes := ResourceTimeRegMgt.GetDashboardRefreshInMinutes;
                    CurrPage.Update(false);
                    CurrPage.PingPong.Ping(60000 * RefreshInMinutes); //5min
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(User)
            {
                Caption = 'User';
                action("Switch User")
                {
                    ApplicationArea = Basic;
                    Image = ChangeCustomer;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServiceLineEDMS: Record "Service Line EDMS";
                        ScheduleResourceLink: Record "Schedule Resource Link";
                    begin
                        User.Reset;
                        User.SetCurrentkey("User Name");
                        if Page.RunModal(Page::Users, User) = Action::LookupOK then begin
                            //Check Password
                            Clear(ScheduleResourceAuth);
                            ScheduleResourceAuth.SetParam(ResourceTimeRegMgt.GetResourceNoByUserId(User."User Name"));
                            ScheduleResourceAuth.LookupMode(true);
                            if ScheduleResourceAuth.RunModal = Action::LookupOK then
                                ServiceScheduleMgt.CompareSchedulePassword(ResourceTimeRegMgt.GetResourceNoByUserId(User."User Name"), ScheduleResourceAuth.GetSchedulePassword)
                            else
                                Error(UserSwitchIgnoreErr);

                            SingleInstanceManagement.SetCurrentUserId(User."User Name");
                            DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                            if ResourceTimeRegMgt.GetCurrentUserResourceNo <> '' then begin
                                //Personal tasks
                                ServLaborAllocEntry.Reset;
                                ServLaborAllocEntry.FilterGroup(3);
                                ServLaborAllocEntry.SetRange("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
                                ServLaborAllocEntry.FilterGroup(0);
                                ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                                CurrPage.ServiceMechanicPersTasks.Page.SetTableview(ServLaborAllocEntry);
                                CurrPage.ServiceMechanicPersTasks.Page.PageUpdate;

                                //Pool taks
                                ScheduleResourceLink.Reset;
                                ScheduleResourceLink.SetRange("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
                                ResourceTimeRegMgt.SetPeriodFilterResourceLink(ScheduleResourceLink);
                                ServLaborAllocEntryPool.Reset;
                                ResourceGroupFilter := '';

                                if ScheduleResourceLink.FindFirst then begin
                                    repeat
                                        ResourceGroupFilter += ScheduleResourceLink."Group Resource No." + '|';
                                    until ScheduleResourceLink.Next = 0;
                                    ResourceGroupFilter := DelChr(ResourceGroupFilter, '>', '|');
                                end;
                                ServLaborAllocEntryPool.FilterGroup(3);
                                ServLaborAllocEntryPool.SetRange("Resource No.", ResourceGroupFilter);
                                ServLaborAllocEntryPool.FilterGroup(0);
                                ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntryPool);

                                CurrPage.ServiceMechanicPoolTasks.Page.SetTableview(ServLaborAllocEntryPool);
                                CurrPage.ServiceMechanicPoolTasks.Page.PageUpdate;

                            end else begin
                                Error(UserResourceSetupErr);
                            end;
                        end;

                        ButtonStartWorkingState := not ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                        ButtonEndWorkingState := ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
            }
            group(WorkTime)
            {
                Caption = 'Work Time';
                action("Start Working")
                {
                    ApplicationArea = Basic;
                    Caption = 'Start';
                    Enabled = ButtonStartWorkingState;
                    Image = Default;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.StartWorktime(ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time);
                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);

                        ButtonStartWorkingState := not ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                        ButtonEndWorkingState := ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                action("Finish Working")
                {
                    ApplicationArea = Basic;
                    Caption = 'Finish';
                    Enabled = ButtonEndWorkingState;
                    Image = Error;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.EndWorktime(ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time);
                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);

                        ButtonStartWorkingState := not ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                        ButtonEndWorkingState := ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
            }
            group(Task)
            {
                Caption = 'Task';
                action("Start Standard Event")
                {
                    ApplicationArea = Basic;
                    Image = NewToDo;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.StartNewTaskFromStandard(ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time);
                    end;
                }
                action(Undo)
                {
                    ApplicationArea = Basic;
                    Image = Undo;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.ServiceMechanicPersTasks.Page.GetRecord(ServLaborAllocEntry);
                        ResourceTimeRegMgt.UndoLastAction(ServLaborAllocEntry."Entry No.", ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time);
                        CurrPage.Update;
                    end;
                }
            }
            group(Period)
            {
                Caption = 'Period';
                action(Day)
                {
                    ApplicationArea = Basic;
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DTDayStart: Decimal;
                        DTDayEnd: Decimal;
                    begin
                        SingleInstanceManagement.SetCurrentPeriod(1);
                        CurrPage.ServiceMechanicPersTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.Page.SetTableview(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.Page.PageUpdate;

                        CurrPage.ServiceMechanicPoolTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.Page.SetTableview(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.Page.PageUpdate;
                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                action(Week)
                {
                    ApplicationArea = Basic;
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DTDayStart: Decimal;
                        DTDayEnd: Decimal;
                    begin
                        SingleInstanceManagement.SetCurrentPeriod(2);
                        CurrPage.ServiceMechanicPersTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.Page.SetTableview(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.Page.PageUpdate;

                        CurrPage.ServiceMechanicPoolTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.Page.SetTableview(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.Page.PageUpdate;
                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                action(Previous)
                {
                    ApplicationArea = Basic;
                    Image = PreviousSet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.MovePeriodFilter(-1);

                        CurrPage.ServiceMechanicPersTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.Page.SetTableview(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.Page.PageUpdate;

                        CurrPage.ServiceMechanicPoolTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.Page.SetTableview(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.Page.PageUpdate;

                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                action(Next)
                {
                    ApplicationArea = Basic;
                    Image = NextSet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.MovePeriodFilter(1);

                        CurrPage.ServiceMechanicPersTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.Page.SetTableview(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.Page.PageUpdate;

                        CurrPage.ServiceMechanicPoolTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.Page.SetTableview(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.Page.PageUpdate;

                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                action("All Time")
                {
                    ApplicationArea = Basic;
                    Caption = 'All';
                    Image = "Table";
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ServLaborAllocEntry.Reset;
                        CurrPage.ServiceMechanicPersTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                        ServLaborAllocEntry.SetRange("Start Date-Time");
                        ServLaborAllocEntry.SetRange("End Date-Time");
                        CurrPage.ServiceMechanicPersTasks.Page.SetTableview(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.Page.PageUpdate;

                        ServLaborAllocEntry.Reset;
                        CurrPage.ServiceMechanicPoolTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                        ServLaborAllocEntry.SetRange("Start Date-Time");
                        ServLaborAllocEntry.SetRange("End Date-Time");
                        CurrPage.ServiceMechanicPoolTasks.Page.SetTableview(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.Page.PageUpdate;
                    end;
                }
            }
            group("Filter")
            {
                group(ActionGroup25006015)
                {
                    Caption = 'Filter';
                    Image = FilterLines;
                    action(Pending)
                    {
                        ApplicationArea = Basic;

                        trigger OnAction()
                        begin
                            ServLaborAllocEntry.Reset;
                            CurrPage.ServiceMechanicPersTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SetRange(Status, ServLaborAllocEntry.Status::Pending);
                            CurrPage.ServiceMechanicPersTasks.Page.SetTableview(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPersTasks.Page.PageUpdate;

                            ServLaborAllocEntry.Reset;
                            CurrPage.ServiceMechanicPoolTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SetRange(Status, ServLaborAllocEntry.Status::Pending);
                            CurrPage.ServiceMechanicPoolTasks.Page.SetTableview(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPoolTasks.Page.PageUpdate;
                        end;
                    }
                    action("In Process")
                    {
                        ApplicationArea = Basic;

                        trigger OnAction()
                        begin
                            ServLaborAllocEntry.Reset;
                            CurrPage.ServiceMechanicPersTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SetRange(Status, ServLaborAllocEntry.Status::"In Progress");
                            CurrPage.ServiceMechanicPersTasks.Page.SetTableview(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPersTasks.Page.PageUpdate;

                            ServLaborAllocEntry.Reset;
                            CurrPage.ServiceMechanicPoolTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SetRange(Status, ServLaborAllocEntry.Status::"In Progress");
                            CurrPage.ServiceMechanicPoolTasks.Page.SetTableview(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPoolTasks.Page.PageUpdate;
                        end;
                    }
                    action(Finished)
                    {
                        ApplicationArea = Basic;

                        trigger OnAction()
                        begin
                            ServLaborAllocEntry.Reset;
                            CurrPage.ServiceMechanicPersTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SetRange(Status, ServLaborAllocEntry.Status::Finished);
                            CurrPage.ServiceMechanicPersTasks.Page.SetTableview(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPersTasks.Page.PageUpdate;

                            ServLaborAllocEntry.Reset;
                            CurrPage.ServiceMechanicPoolTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SetRange(Status, ServLaborAllocEntry.Status::Finished);
                            CurrPage.ServiceMechanicPoolTasks.Page.SetTableview(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPoolTasks.Page.PageUpdate;
                        end;
                    }
                    action("All Statuses")
                    {
                        ApplicationArea = Basic;
                        Caption = 'All';

                        trigger OnAction()
                        begin
                            ServLaborAllocEntry.Reset;
                            CurrPage.ServiceMechanicPersTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SetRange(Status);
                            CurrPage.ServiceMechanicPersTasks.Page.SetTableview(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPersTasks.Page.PageUpdate;

                            ServLaborAllocEntry.Reset;
                            CurrPage.ServiceMechanicPoolTasks.Page.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SetRange(Status);
                            CurrPage.ServiceMechanicPoolTasks.Page.SetTableview(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPoolTasks.Page.PageUpdate;
                        end;
                    }
                }
            }
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

                        CurrPage.ServiceMechanicPersTasks.Page.GetRecord(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Start', ServLaborAllocEntry, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocEntry, CurrentResourceNo, WorkDate, Time);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Start', ServLaborAllocEntry, CurrentResourceNo, WorkDate, Time, '');
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

                        CurrPage.ServiceMechanicPersTasks.Page.GetRecord(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Stop', ServLaborAllocEntry, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Stop', ServLaborAllocEntry, CurrentResourceNo, WorkDate, Time);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Stop', ServLaborAllocEntry, CurrentResourceNo, WorkDate, Time, '');
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
                    Visible = OnHoldVisibility;

                    trigger OnAction()
                    var
                        CurrentResourceNo: Code[20];
                    begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();

                        CurrPage.ServiceMechanicPersTasks.Page.GetRecord(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('OnHold', ServLaborAllocEntry, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('OnHold', ServLaborAllocEntry, CurrentResourceNo, WorkDate, Time);
                        ResourceTimeRegMgt.UpdateAllocationStatus('OnHold', ServLaborAllocEntry, CurrentResourceNo, WorkDate, Time, '');
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

                        CurrPage.ServiceMechanicPersTasks.Page.GetRecord(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Complete', ServLaborAllocEntry, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Complete', ServLaborAllocEntry, CurrentResourceNo, WorkDate, Time);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Complete', ServLaborAllocEntry, CurrentResourceNo, WorkDate, Time, '');
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        ServiceScheduleSetup.GET;
        OnHoldVisibility := TRUE;

        IF ServiceScheduleSetup."Disable On Hold" THEN
            OnHoldVisibility := FALSE;
    end;

    trigger OnOpenPage()
    begin

        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);

        ButtonStartWorkingState := not ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
        ButtonEndWorkingState := ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
    end;

    var
        UserProfileManagement: Codeunit UserProfileManagement;
        DashboardTitle: Text[200];
        DashboardTitleTxt: label 'Dashboard';
        UserManagement: Codeunit "User Management";
        User: Record User;
        UserSetup: Record "User Setup";
        UserName: Text[100];
        ServLaborAllocEntry: Record "Serv. Labor Allocation Entry";
        UserResourceSetupErr: label 'There is no Resource No. configured in User Setup.';
        ServLaborAllocEntryPool: Record "Serv. Labor Allocation Entry";
        ServLaborAllocEntryFilter: Record "Serv. Labor Allocation Entry";
        Resource: Record Resource;
        ScheduleResourceGroupSpec: Record "Schedule Resource Group Spec.";
        ResourceGroupFilter: Text;
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        SingleInstanceManagement: Codeunit SingleInstanceManagement;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        RefreshInMinutes: Integer;
        ServiceScheduleSetup: Record "Service Schedule Setup";
        ButtonStartWorkingState: Boolean;
        ButtonEndWorkingState: Boolean;
        ScheduleResourceAuth: Page "Schedule Resource Auth.";
        UserSwitchIgnoreErr: label 'User switch cancelled.';
        OnHoldVisibility: Boolean;
}

