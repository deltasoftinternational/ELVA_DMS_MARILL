Page 25006527 "Vehicle Option Registers"
{
    // 28.06.2004 EDMS P1
    //    *Opened fields:
    //         - 25006670 "From Item Replmt. Entry No."
    //         - 25006680 "To Item Replmt. Entry No."
    // 
    // 12.07.2004 EDMS P1
    //    *Changed MenuButton "Register"
    //      - added new menu item: "Item replacement ledger"

    Caption = 'Vehicle Option Registers';
    Editable = false;
    PageType = List;
    SourceTable = "Vehicle Option Register";

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
                action(VehicleOptionLedger)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Option Ledger';
                    Image = LedgerEntries;
                    RunObject = Codeunit "Vehicle Opt. Reg.-Show Ledger";
                }
            }
        }
    }
}

