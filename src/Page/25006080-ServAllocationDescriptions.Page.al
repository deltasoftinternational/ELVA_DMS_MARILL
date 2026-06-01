Page 25006080 "Serv. Allocation Descriptions"
{
    Caption = 'Serv. Allocation Descriptions';
    PageType = List;
    SourceTable = "Serv. Allocation Description";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
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
            action(AllocationEntries)
            {
                ApplicationArea = Basic;
                Caption = 'Allocation Entries';
                Image = CalendarMachine;

                trigger OnAction()
                var
                    AllocEntry: Record "Serv. Labor Allocation Entry";
                    DatetimeMgt: Codeunit "Datetime Mgt.";
                    ResourceNoFilter: Code[1000];
                    ResourceGrpSec: Record "Schedule Resource Group Spec.";
                begin
                    AllocEntry.Reset;
                    AllocEntry.SetRange("Detail Entry No.", Rec."Entry No.");
                    if Page.RunModal(Page::"Serv. Labor Allocation Entries", AllocEntry) = Action::LookupOK then;
                end;
            }
        }
    }
}

