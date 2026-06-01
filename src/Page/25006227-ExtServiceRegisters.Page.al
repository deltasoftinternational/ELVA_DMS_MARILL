Page 25006227 "Ext. Service Registers"
{
    ApplicationArea = Basic;
    Caption = 'External Service Registers';
    Editable = false;
    PageType = List;
    SourceTable = "External Service Register";
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
                action(ExternalServiceLedger)
                {
                    ApplicationArea = Basic;
                    Caption = 'External Service Ledger';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Ext. Service Reg.-Show Ledger";
                }
            }
        }
    }
}

