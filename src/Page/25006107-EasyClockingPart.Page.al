Page 25006107 "Easy Clocking Part"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Service Cue EDMS";

    layout
    {
        area(content)
        {
            usercontrol(Navigation; NavigationAddIn)
            {
                ApplicationArea = All;

                trigger ControlAddInReady()
                var
                    AddInData: Text;
                begin

                    ServiceNavigationMgt.FillAddInData(AddInData);
                    CurrPage.Navigation.RecieveInitNavigationData(AddInData);
                end;

                trigger RequestNavigationData()
                var
                    AddInData: Text;
                begin
                    ServiceNavigationMgt.FillAddInData(AddInData);
                    CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
                end;

                trigger ProcessControlCommand(ControlNo: Integer)
                var
                    AddInData: Text;
                    CustomCurrDate: Date;
                    CustomCurrTime: Time;
                begin
                    ManageCurrentTime(CurrentDate, CurrentTime);
                    ServiceNavigationMgt.ProcessNavigationControl(ControlNo, ResourceTimeRegMgt.GetCurrentUserResourceNo, CurrentDate, CurrentTime);
                    ServiceNavigationMgt.GetCustomCurrDateTime(CustomCurrDate, CustomCurrTime);
                    ManageCurrentTime(CurrentDate, CurrentTime);
                    SingleInstanceManagement.SetCurrentDate(CurrentDate);

                    ServiceNavigationMgt.FillAddInData(AddInData);
                    CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
                end;

                trigger ProcessTaskCompleteCommand(EntryNo: Integer)
                var
                    AddInData: Text;
                    ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
                    ResourceNo: Code[20];
                begin
                    ManageCurrentTime(CurrentDate, CurrentTime);
                    if ServLaborAllocationEntry.Get(EntryNo) then begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
                        ResourceTimeRegMgt.ValidateTimeRegAction('Complete', ServLaborAllocationEntry, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Complete', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Complete', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime, '');
                    end;
                    ServiceNavigationMgt.FillAddInData(AddInData);
                    CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
                end;

                trigger ProcessTaskPauseCommand(EntryNo: Integer)
                var
                    AddInData: Text;
                    ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
                begin
                    ManageCurrentTime(CurrentDate, CurrentTime);
                    if ServLaborAllocationEntry.Get(EntryNo) then begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
                        ResourceTimeRegMgt.ValidateTimeRegAction('OnHold', ServLaborAllocationEntry, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('OnHold', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
                        ResourceTimeRegMgt.UpdateAllocationStatus('OnHold', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime, '');
                    end;
                    ServiceNavigationMgt.FillAddInData(AddInData);
                    CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
                end;

                trigger ProcessTaskStartCommand(EntryNo: Integer)
                var
                    AddInData: Text;
                    ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
                begin
                    ManageCurrentTime(CurrentDate, CurrentTime);
                    if ServLaborAllocationEntry.Get(EntryNo) then begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
                        ResourceTimeRegMgt.StartWorktimeSilent(CurrentResourceNo, CurrentDate, CurrentTime);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Start', ServLaborAllocationEntry, CurrentResourceNo);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Start', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime, '');
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
                    end;
                    ServiceNavigationMgt.FillAddInData(AddInData);
                    CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
                end;

                trigger ProcessWorktimeCommand()
                var
                    AddInData: Text;
                    ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
                begin
                    ManageCurrentTime(CurrentDate, CurrentTime);
                    ResourceTimeRegMgt.ToggleWorktime(ResourceTimeRegMgt.GetCurrentUserResourceNo, CurrentDate, CurrentTime);
                    ServiceNavigationMgt.FillAddInData(AddInData);
                    CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
                end;

                trigger ProcessLookupCommand(EntryNo: Integer)
                var
                    AddInData: Text;
                    ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
                begin
                    if ServLaborAllocationEntry.Get(EntryNo) then begin
                        ServiceNavigationMgt.ProcessLookupAction(ServLaborAllocationEntry);
                    end;
                end;

            }

        }
    }

    actions
    {
        area(processing)
        {
            action(Refresh)
            {
                ApplicationArea = Basic;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.Update;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        AddInData: Text;
    begin
        ServiceNavigationMgt.FillAddInData(AddInData);
        CurrPage.Navigation.RecieveInitNavigationData(AddInData);
    end;

    trigger OnInit()
    begin
        SingleInstanceManagement.SetCurrentPeriod(1); //Period Day
        SingleInstanceManagement.SetCurrentDate(WorkDate);
        CurrentDate := WorkDate;
        CurrentTime := Time;
    end;

    var
        ServiceNavigationMgt: Codeunit "Easy Clocking Management";
        CurrentResourceNo: Code[20];
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        SingleInstanceManagement: Codeunit SingleInstanceManagement;
        CurrentDate: Date;
        CurrentTime: Time;

    local procedure ManageCurrentTime(var CrDate: Date; var CrTime: Time)
    var
        CustomCurrDate: Date;
        CustomCurrTime: Time;
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

