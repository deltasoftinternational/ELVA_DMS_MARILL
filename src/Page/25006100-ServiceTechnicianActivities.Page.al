Page 25006100 "Service Technician Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Service Cue EDMS";

    layout
    {
        area(content)
        {
            cuegroup(Tasks)
            {
                Caption = 'Tasks';
                field(MyTasks; Rec."My Tasks EC")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Tasks';
                    DrillDownPageID = "Service Techn. Personal Tasks";
                }
                field(MyGroupTasks; Rec."My Group Tasks EC")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Group Tasks';
                    DrillDownPageID = "Service Techn. Group Tasks";
                }
                field(MyOrdersEC; Rec."My Orders EC")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Techn. Orders";
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnAfterGetRecord()
    var
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        StandardEvent: Record "Serv. Standard Event";
        ResourceGroupFilter: Text;
        ScheduleResourceLink: Record "Schedule Resource Link";
    begin
        ServiceSetup.Get;
        if ResourceTimeRegMgt.GetCurrentUserResourceNo <> '' then begin
            ServLaborAllocationEntry.Reset;
            ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocationEntry);
            ServLaborAllocationEntry.SetRange("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
            if ServiceSetup."Default Idle Event" <> '' then begin
                StandardEvent.Get(ServiceSetup."Default Idle Event");
                ServLaborAllocationEntry.SetFilter("Source ID", '<>%1', StandardEvent.Code);
            end;
            Rec."My Tasks EC" := ServLaborAllocationEntry.Count;

            ServLaborAllocationEntry.Reset;
            ResourceGroupFilter := '_$_';
            ScheduleResourceLink.Reset;
            ScheduleResourceLink.SetRange("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
            ResourceTimeRegMgt.SetPeriodFilterResourceLink(ScheduleResourceLink);
            if ScheduleResourceLink.FindFirst then begin
                ResourceGroupFilter := '';
                repeat
                    ResourceGroupFilter += ScheduleResourceLink."Group Resource No." + '|';
                until ScheduleResourceLink.Next = 0;
                ResourceGroupFilter := DelChr(ResourceGroupFilter, '>', '|');
            end;
            ServLaborAllocationEntry.SetFilter("Resource No.", ResourceGroupFilter);
            if ServiceSetup."Default Idle Event" <> '' then begin
                StandardEvent.Get(ServiceSetup."Default Idle Event");
                ServLaborAllocationEntry.SetFilter("Source ID", '<>%1', StandardEvent.Code);
            end;
            ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocationEntry);
            Rec."My Group Tasks EC" := ServLaborAllocationEntry.Count;
        end;
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate);
    end;
}

