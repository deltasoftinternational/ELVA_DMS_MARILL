Page 25006374 "Serv. Labor Alloc. Application"
{
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Unit Cost"
    //     "Finished Cost Amount"
    //     "Remaining Cost Amount"
    //     "Total Cost Amount"

    Caption = 'Serv. Labor Alloc. Application';
    PageType = List;
    SourceTable = "Serv. Labor Alloc. Application";

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                Editable = false;
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentLineNo; Rec."Document Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(GetLaborNoCtrl; GetLaborNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Labor No.';
                }
                field(GetLaborDescriptionCtrl; GetLaborDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Labor Description';
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(FinishedQuantityHours; Rec."Finished Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(RemainingQuantityHours; Rec."Remaining Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(TimeLine; Rec."Time Line")
                {
                    ApplicationArea = Basic;
                }
                field(AllocationEntryNo; Rec."Allocation Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(FinishedCostAmount; Rec."Finished Cost Amount")
                {
                    ApplicationArea = Basic;
                }
                field(RemainingCostAmount; Rec."Remaining Cost Amount")
                {
                    ApplicationArea = Basic;
                }
                field(CostAmount; Rec."Cost Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Travel; Rec.Travel)
                {
                    ApplicationArea = Basic;
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
                action(ShowinSchedule)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show in Schedule';
                    Image = Planning;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "Service Schedule";
                        ServLaborAllocation: Record "Serv. Labor Allocation Entry";
                    begin
                        ServLaborAllocation.Get(Rec."Allocation Entry No.");
                        ServiceSchedule.SetAllocation(ServLaborAllocation);
                        ServiceSchedule.RunModal;
                    end;
                }
            }
        }
    }


    procedure GetLaborNo(): Code[20]
    var
        ServiceLine: Record "Service Line EDMS";
        PostedServiceLine: Record "Posted Serv. Order Line";
        ExitValue: Code[20];
    begin
        if ServiceLine.Get(Rec."Document Type", Rec."Document No.", Rec."Document Line No.") then
            exit(ServiceLine."No.");
        if PostedServiceLine.Get(Rec."Document No.", Rec."Document Line No.") then
            exit(PostedServiceLine."No.");
        //>>Delta MGR
        OnBeforeExitLaborNoEmpty(Rec, ExitValue);
        if ExitValue <> '' then
            exit(ExitValue);
        //<<Delta MGR
        exit('');
    end;


    procedure GetLaborDescription(): Text[50]
    var
        ServiceLine: Record "Service Line EDMS";
        PostedServiceLine: Record "Posted Serv. Order Line";
        ExitValue: Code[20];
    begin
        if ServiceLine.Get(Rec."Document Type", Rec."Document No.", Rec."Document Line No.") then
            exit(ServiceLine.Description);
        if PostedServiceLine.Get(Rec."Document No.", Rec."Document Line No.") then
            exit(PostedServiceLine.Description);
        //>>Delta MGR
        OnBeforeExitLaborDescEmpty(Rec, ExitValue);
        if ExitValue <> '' then
            exit(ExitValue);
        //<<Delta MGR
        exit('');
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExitLaborNoEmpty(var ServLaborAllocApp: Record "Serv. Labor Alloc. Application"; var ExitValue: code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExitLaborDescEmpty(var ServLaborAllocApp: Record "Serv. Labor Alloc. Application"; var ExitValue: code[20])
    begin
    end;
}

