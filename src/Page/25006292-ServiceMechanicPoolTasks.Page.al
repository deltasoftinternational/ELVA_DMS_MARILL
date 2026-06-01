Page 25006292 "Service Mechanic Pool Tasks"
{
    Caption = 'Group Tasks';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Serv. Labor Allocation Entry";

    layout
    {
        area(content)
        {
            repeater("Repeat")
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
                field(ParentAllocEntryNo; Rec."Parent Alloc. Entry No.")
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
            action("Start Task")
            {
                ApplicationArea = Basic;
                Image = "Action";
                RunPageMode = View;
                Scope = Repeater;

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
                RunPageMode = View;
                Scope = Repeater;

                trigger OnAction()
                begin
                    ResourceTimeRegMgt.StartNewTravelTaskFromAllocation(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time);
                    CurrPage.Update;
                end;
            }
            action(Pause)
            {
                ApplicationArea = Basic;
                Image = Pause;
                Visible = false;

                trigger OnAction()
                begin
                    //ResourceTimeRegMgt.AddTimeRegEntry('OnHold',Rec);
                    //CurrPage.UPDATE;
                end;
            }
            action(Stop)
            {
                ApplicationArea = Basic;
                Image = Stop;
                Visible = false;

                trigger OnAction()
                begin
                    //ResourceTimeRegMgt.AddTimeRegEntry('Stop',Rec);
                    //CurrPage.UPDATE;
                end;
            }
            action(Complete)
            {
                ApplicationArea = Basic;
                Image = Completed;
                Visible = false;

                trigger OnAction()
                begin
                    //ResourceTimeRegMgt.AddTimeRegEntry('Complete',Rec);
                    //CurrPage.UPDATE;
                end;
            }
            separator(Action25006020)
            {
            }
            action("Time Reg. Entries")
            {
                ApplicationArea = Basic;
                Image = Entry;
                RunObject = Page "Resource Time Reg. Entries";
                RunPageLink = "Allocation Entry No." = field("Entry No.");
                Scope = Repeater;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ButtonStartActive := (Rec.Status <> Rec.Status::"In Progress")
    end;

    trigger OnAfterGetRecord()
    begin
        RowAttention := ResourceTimeRegMgt.GetTaskColorPool(Rec);
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
        UserSetup: Record "User Setup";
        Resource: Record Resource;
        ScheduleResourceGroupSpec: Record "Schedule Resource Group Spec.";
        UserResourceSetupErr: label 'There is no Resource No. configured in User Setup.';
        ScheduleResourceLink: Record "Schedule Resource Link";
        ResourceGroupFilter: Text;
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ButtonStartActive: Boolean;
        ServiceScheduleSetup: Record "Service Schedule Setup";
        SingleInstanceManagement: Codeunit SingleInstanceManagement;
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
        TimeRegStatus: Option Pending,"In Progress",Finished,"On Hold";


    procedure GetCustomer()
    begin
    end;


    procedure PageUpdate()
    begin
        CurrPage.Update(false);
    end;


    procedure CopyRecFilter(var CopyServLaborAllocEntry: Record "Serv. Labor Allocation Entry")
    begin
        CopyServLaborAllocEntry.CopyFilters(Rec);
    end;
}

