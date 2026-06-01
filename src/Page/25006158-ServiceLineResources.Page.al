Page 25006158 "Service Line Resources"
{
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Unit Cost"
    //     "Finished Cost Amount"
    //     "Remaining Cost Amount"
    //     "Total Cost Amount"

    Caption = 'Service Line Resources';
    PageType = List;
    SourceTable = "Serv. Labor Alloc. Application";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
    }

    trigger OnDeleteRecord(): Boolean
    begin
        if ServLaborAllocationEntry.Get(Rec."Allocation Entry No.") then
            Error(Text001);
    end;

    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        Text001: label 'This is not allowed to delete allocated records.';
}

