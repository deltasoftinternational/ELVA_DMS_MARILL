XmlPort 25006201 "Export Easy Clocking Menu"
{
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            textelement(Controls)
            {
                tableelement("Easy Clocking Menu Item"; "Easy Clocking Menu Item")
                {
                    XmlName = 'Control';
                    fieldelement(No; "Easy Clocking Menu Item"."No.")
                    {
                    }
                    fieldelement(Type; "Easy Clocking Menu Item".Type)
                    {
                    }
                    fieldelement(Caption; "Easy Clocking Menu Item".Caption)
                    {
                    }
                    fieldelement(RunActionId; "Easy Clocking Menu Item"."Run Action")
                    {
                    }
                    fieldelement(RunObjectType; "Easy Clocking Menu Item"."Run Object Type")
                    {
                    }
                    fieldelement(RunObjectID; "Easy Clocking Menu Item"."Run Object ID")
                    {
                    }
                    fieldelement(Icon; "Easy Clocking Menu Item".Icon)
                    {
                    }
                }
            }
            textelement(Tasks)
            {
                tableelement("Serv. Labor Allocation Entry"; "Serv. Labor Allocation Entry")
                {
                    XmlName = 'Task';
                    textelement(Description)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            Description := ServiceScheduleMgt.GetAllocRecDescr("Serv. Labor Allocation Entry");
                        end;
                    }
                    fieldelement(EntryNo; "Serv. Labor Allocation Entry"."Entry No.")
                    {
                    }
                    fieldelement(SourceType; "Serv. Labor Allocation Entry"."Source Type")
                    {
                    }
                    fieldelement(SourceSubtype; "Serv. Labor Allocation Entry"."Source Subtype")
                    {
                    }
                    fieldelement(SourceId; "Serv. Labor Allocation Entry"."Source ID")
                    {
                    }
                    fieldelement(ResourceNo; "Serv. Labor Allocation Entry"."Resource No.")
                    {
                    }
                    fieldelement(UserId; "Serv. Labor Allocation Entry"."User ID")
                    {
                    }
                    fieldelement(Status; "Serv. Labor Allocation Entry".Status)
                    {
                    }
                    fieldelement(EntryNo; "Serv. Labor Allocation Entry"."Entry No.")
                    {
                    }
                    textelement(IsIdle)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            IsIdle := 'False';
                            ServiceSetup.Get;
                            if ServStandardEvent.Get(ServiceSetup."Default Idle Event") then
                                if "Serv. Labor Allocation Entry"."Source ID" = ServStandardEvent.Code then
                                    IsIdle := 'True';
                        end;
                    }
                    fieldelement(Travel; "Serv. Labor Allocation Entry".Travel)
                    {
                    }

                    trigger OnPreXmlItem()
                    begin

                        "Serv. Labor Allocation Entry".Reset;
                        "Serv. Labor Allocation Entry".FilterGroup(3);
                        "Serv. Labor Allocation Entry".SetRange("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
                        "Serv. Labor Allocation Entry".SetFilter(Status, '<>%1 & <>%2', "Serv. Labor Allocation Entry".Status::Finished, "Serv. Labor Allocation Entry".Status::Pending);
                        "Serv. Labor Allocation Entry".FilterGroup(0);


                        ResourceTimeRegMgt.SetPeriodFilter("Serv. Labor Allocation Entry");
                    end;
                }
            }
            textelement(Status)
            {
                textelement(ResourceNo)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo;
                    end;
                }
                textelement(ResourceCaption)
                {

                    trigger OnBeforePassVariable()
                    begin
                        if Resource.Get(ResourceTimeRegMgt.GetCurrentUserResourceNo) then
                            ResourceCaption := Resource.Name;
                    end;
                }
                textelement(IsWorking)
                {

                    trigger OnBeforePassVariable()
                    begin
                        IsWorking := Format(ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo));
                    end;
                }
                textelement(IsWorkingCaption)
                {

                    trigger OnBeforePassVariable()
                    begin
                        if ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo) then
                            IsWorkingCaption := TimeRegisterWorkingTxt
                        else
                            IsWorkingCaption := TimeRegisterNotWorkingTxt;
                    end;
                }
                textelement(CurrentPeriodCaption)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CurrentPeriodCaption := ResourceTimeRegMgt.GetCurrentPeriodText;
                    end;
                }
                textelement(DashboardCaption)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DashboardCaption := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                textelement(CustomCurrentDateTxt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CustomCurrentDateTxt := Format(CustomCurrentDate);
                    end;
                }
                textelement(CustomCurrentTimeTxt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CustomCurrentTimeTxt := Format(CustomCurrentTime);
                    end;
                }
                textelement(DisableOnHold)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DisableOnHold := FORMAT(ServiceScheduleSetup."Disable On Hold");
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        UserResourceSetupErr: label 'There is no Resource No. configured in User Setup.';
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        StandardText: Record "Standard Text";
        ServStandardEvent: Record "Serv. Standard Event";
        CustomCurrentDate: Date;
        CustomCurrentTime: Time;
        TimeRegisterWorkingTxt: label 'Working';
        TimeRegisterNotWorkingTxt: label 'Not Working';
        Resource: Record Resource;
        ServiceScheduleSetup: Record "Service Schedule Setup";


    procedure SetCustomCurrentDateTime(CurrentDateToSet: Date; CurrentTimeToSet: Time)
    begin
        CustomCurrentDate := CurrentDateToSet;
        CustomCurrentTime := CurrentTimeToSet;
    end;

    trigger OnInitXmlPort()
    begin
        ServiceScheduleSetup.GET();
    end;
}

