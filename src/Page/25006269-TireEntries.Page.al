Page 25006269 "Tire Entries"
{
    Caption = 'Tire Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Tire Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAxleCode; Rec."Vehicle Axle Code")
                {
                    ApplicationArea = Basic;
                }
                field(TirePositionCode; Rec."Tire Position Code")
                {
                    ApplicationArea = Basic;
                }
                field(TireCode; Rec."Tire Code")
                {
                    ApplicationArea = Basic;
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceLedgerEntryNo; Rec."Service Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(TireDescription; Rec."Tire Description")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldTireRun; Rec."Variable Field Tire Run")
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
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = 'Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
            action("Print List")
            {
                ApplicationArea = Basic;
                Caption = 'Print List';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
            }
            action(Test)
            {
                ApplicationArea = Basic;
                Caption = 'Test';
                Image = TestFile;
            }
        }
    }
}

