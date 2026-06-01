/*
Page 25006753 "Special Invt. Equipment Card"
{
    Caption = 'Special Invt. Equipment Card';
    PageType = Card;
    SourceTable = "Special Inventory Equipment";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = Basic;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic;
                }
                field(Check1; Rec."Check 1")
                {
                    ApplicationArea = Basic;
                }
                field(Check1ShowReminder; Rec."Check 1 Show Reminder")
                {
                    ApplicationArea = Basic;
                }
                field(Check1ReminderMsg; Rec."Check 1 Reminder Msg")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Advanced)
            {
                field(SystemCode; Rec.SystemCode)
                {
                    ApplicationArea = Basic;
                }
                field(DSNName; Rec."DSN Name")
                {
                    ApplicationArea = Basic;
                }
                field(ControlUnit; Rec."Control Unit")
                {
                    ApplicationArea = Basic;
                }
                field(ControlUnitName; Rec."Control Unit Name")
                {
                    ApplicationArea = Basic;
                }
                field(PostingUnit; Rec."Posting Unit")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Mandatory F.")
            {
                field(Mand1Field; Rec."Mand.1 Field")
                {
                    ApplicationArea = Basic;
                }
                field(Mand2Field; Rec."Mand.2 Field")
                {
                    ApplicationArea = Basic;
                }
                field(Mand3Field; Rec."Mand.3 Field")
                {
                    ApplicationArea = Basic;
                }
                field(Mand4Field; Rec."Mand.4 Field")
                {
                    ApplicationArea = Basic;
                }
                field(Mand5Field; Rec."Mand.5 Field")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control25; Notes)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(SIE)
            {
                Caption = 'SIE';
                Image = History;
                action(SIELedgerEntries)
                {
                    ApplicationArea = Basic;
                    Image = LedgerEntries;
                    RunObject = Page "SIE Ledger Entries";
                    RunPageLink = "SIE No." = field("No.");
                    RunPageView = sorting("SIE No.", "External Document No.", "No. Series");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
    }
}
*/