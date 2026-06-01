Page 25006212 "Service Registers"
{
    ApplicationArea = Basic;
    Caption = 'Service Registers';
    Editable = false;
    PageType = List;
    SourceTable = "Service Register EDMS";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(CreationDate; Rec."Creation Date")
                {
                    ApplicationArea = Basic;
                }
                field(CreationTime; Rec."Creation Time")
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                }
                field(JournalBatchName; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field(FromEntryNo; Rec."From Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(ToEntryNo; Rec."To Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(FromTireEntryNo; Rec."From Tire Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(ToTireEntryNo; Rec."To Tire Entry No.")
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
            group(Register)
            {
                Caption = '&Register';
                action(ServiceLedger)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger';
                    Image = ServiceLedger;
                    RunObject = Codeunit "Serv. Reg.-Show Ledger";
                }
                action(TireEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tire Entries';
                    Image = ServiceLedger;

                    trigger OnAction()
                    begin
                        TireEntry.SetRange("Entry No.", Rec."From Tire Entry No.", Rec."To Tire Entry No.");
                        Page.Run(Page::"Tire Entries", TireEntry);
                    end;
                }
            }
        }
    }

    var
        TireEntry: Record "Tire Entry";
}

