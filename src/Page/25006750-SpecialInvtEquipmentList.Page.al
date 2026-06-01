/*
Page 25006750 "Special Invt. Equipment List"
{
    ApplicationArea = Basic;
    Caption = 'Special Invt. Equipment List';
    CardPageID = "Special Invt. Equipment Card";
    Editable = false;
    PageType = List;
    SourceTable = "Special Inventory Equipment";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field(ControlUnit; Rec."Control Unit")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ControlUnitName; Rec."Control Unit Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DSNName; Rec."DSN Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LastTranDate; Rec."Last Tran Date")
                {
                    ApplicationArea = Basic;
                }
                field(LastTranTime; Rec."Last Tran Time")
                {
                    ApplicationArea = Basic;
                }
                field(PostingUnit; Rec."Posting Unit")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Mand1Field; Rec."Mand.1 Field")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Mand2Field; Rec."Mand.2 Field")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Mand3Field; Rec."Mand.3 Field")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Mand4Field; Rec."Mand.4 Field")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Mand5Field; Rec."Mand.5 Field")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SystemCode; Rec.SystemCode)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Check1; Rec."Check 1")
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
            group(SIE)
            {
                Caption = 'SIE';
                Image = Item;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Special Invt. Equipment Card";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(LedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = LedgerEntries;
                    RunObject = Page "SIE Ledger Entries";
                    RunPageLink = "SIE No." = field("No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action(JournalLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Journal Lines';
                    Image = Journal;
                    RunObject = Page "SIE Journal";
                    RunPageLink = "SIE No." = field("No.");
                    RunPageView = sorting("SIE No.", "Date 1", "Time 1")
                                  order(ascending);
                }
                action(Synchronize)
                {
                    ApplicationArea = Basic;
                    Caption = 'Synchronize';
                    Image = Copy;

                    trigger OnAction()
                    begin
                        SIEMgt.SIESinhronize(Rec)
                    end;
                }
                action(Categories)
                {
                    ApplicationArea = Basic;
                    Caption = 'Categories';
                    Image = Category;
                    RunObject = Page "SIE Object Categories";
                    RunPageLink = "SIE No." = field("No.");
                }

            }
        }
    }

    var
        SIEMgt: Codeunit "SIE Management";
}
*/
