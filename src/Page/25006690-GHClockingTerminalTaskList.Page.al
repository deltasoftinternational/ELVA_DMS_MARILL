Page 25006690 "GH ClockingTerminal Task List"
{
    PageType = List;
    SourceTable = "Serv. Labor Allocation Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                }
                field(StartDateTime; Rec."Start Date-Time")
                {
                    ApplicationArea = Basic;
                }
                field(EndDateTime; Rec."End Date-Time")
                {
                    ApplicationArea = Basic;
                }
                field(QuantityHours; Rec."Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoEntryNo; Rec."Applies-to Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field(PlanningPolicy; Rec."Planning Policy")
                {
                    ApplicationArea = Basic;
                }
                field(ParentAllocEntryNo; Rec."Parent Alloc. Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(ParentLinkSynchronize; Rec."Parent Link Synchronize")
                {
                    ApplicationArea = Basic;
                }
                field(DetailEntryNo; Rec."Detail Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(AllocationStatus; Rec."Allocation Status")
                {
                    ApplicationArea = Basic;
                }
                field(ResourceGroupCode; Rec."Resource Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(TotalTimeSpent; Rec."Total Time Spent")
                {
                    ApplicationArea = Basic;
                }
                field(ApplicationEntryCount; Rec."Application Entry Count")
                {
                    ApplicationArea = Basic;
                }
                field(TotalCostAmount; Rec."Total Cost Amount")
                {
                    ApplicationArea = Basic;
                }
                field(LastClocked; Rec."Last Clocked")
                {
                    ApplicationArea = Basic;
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
    }

    trigger OnInit()
    begin
        if ServLaborAllocationEntry.FindFirst then
            repeat
                Rec.Init;
                Rec := ServLaborAllocationEntry;
                Rec.Insert;
            until ServLaborAllocationEntry.Next = 0;
    end;

    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";

    [ServiceEnabled]
    procedure Test(TestParam: Text): Text
    begin
        exit('You passed: ' + TestParam);
    end;
}

