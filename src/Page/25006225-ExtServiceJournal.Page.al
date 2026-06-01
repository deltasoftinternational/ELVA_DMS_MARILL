Page 25006225 "Ext. Service Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'External Service Journal';
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "External Serv. Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ExtServiceJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ExtServiceJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1190000)
            {
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(ExtServiceNo; Rec."Ext. Service No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceNo; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Service Order No."; Rec."Service Order No.")
                {

                }
                field("Vehicle Serial No."; Rec."Vehicle Serial No.")
                {

                }
                field("Vehicle Registration No."; Rec."Vehicle Registration No.")
                {

                }
                field(VIN; Rec.VIN)
                {

                }
                field("Model Code"; Rec."Model Code")
                {

                }
                field("Make Code"; Rec."Make Code")
                {

                }
            }
            group(Control1190001)
            {
                field(ExtServiceName; ExtServiceName)
                {
                    ApplicationArea = Basic;
                    Caption = 'External Service Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ExternalService)
            {
                Caption = '&External Service';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "External Service Card";
                    RunPageLink = "No." = field("Ext. Service No.");
                    ShortCutKey = 'Shift+F5';
                }
                action(LedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    RunObject = Page "Ext. Service Ledger Entries";
                    RunPageLink = "External Serv. No." = field("Ext. Service No.");
                    RunPageView = sorting("External Serv. No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F5';
                }
            }
            group(Posting)
            {
                Caption = 'P&osting';
                action(TestReport)
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Image = TestReport;

                    trigger OnAction()
                    var
                        "Item Sales Doc. Mgt. EDMS": codeunit "Item Sales Doc. Mgt. EDMS";
                    begin
                        "Item Sales Doc. Mgt. EDMS".PrintExtServJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    ShortCutKey = 'F11';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Ext. Service Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action(PostandPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Ext. Service Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        ExtServiceJnlManagement.TemplateSelection(Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        ExtServiceJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        ExtServiceJnlManagement: Codeunit "Ext.ServiceJnlManagement";
        CurrentJnlBatchName: Code[10];
        ExtServiceName: Text[50];
        ReportPrint: Codeunit "Test Report-Print";

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ExtServiceJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ExtServiceJnlManagement.GetExtService(Rec."Ext. Service No.", ExtServiceName);
    end;
}

