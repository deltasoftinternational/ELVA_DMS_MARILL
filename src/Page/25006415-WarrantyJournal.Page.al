Page 25006415 "Warranty Journal"
{
    // 06.10.2017 EB.AKR Warranty
    //   Added fields:
    //     "Labor Type"
    //     "Description"
    //     "No."

    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Warranty Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategories = 'a,b,c,Posting';
    SaveValues = true;
    SourceTable = "Warranty Journal Line";
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
                    WarrantyJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    WarrantyJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(WarrantyDocumentNo; Rec."Warranty Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(WarrantyDocumentLineNo; Rec."Warranty Document Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(LaborType; Rec."Labor Type")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }

                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DebitCode; Rec."Debit Code")
                {
                    ApplicationArea = Basic;
                }
                field(DebitDescription; Rec."Debit Description")
                {
                    ApplicationArea = Basic;
                }
                field(RejectCode; Rec."Reject Code")
                {
                    ApplicationArea = Basic;
                }
                field(RejectDescription; Rec."Reject Description")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(DebitCodeType; Rec."Debit Code Type")
                {
                    ApplicationArea = Basic;
                }
                field(CoverageId; Rec.CoverageId)
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control41)
            {
                Visible = false;
                field(VehName; VehName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = '&Line';
            }
            group(Service)
            {
                Caption = '&Service';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Warranty Document Card";
                    RunPageLink = "No." = field("Document No.");
                    ShortCutKey = 'Shift+F5';
                }
                action(LedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    RunObject = Page "Warranty Reimbursement Entries";
                    RunPageLink = "Warranty Document No." = field("Document No.");
                    ShortCutKey = 'Ctrl+F5';
                }
            }
        }
        area(processing)
        {
            group(Posting)
            {
                Caption = 'P&osting';
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Warranty Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("<Action1101901008>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Warranty Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //ShowShortcutDimCode(ShortcutDimCode);// 29.10.2012 EDMS
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        WarrantyJnlManagement.TemplateSelection(Page::"Warranty Journal", false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        WarrantyJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        WarrantyJnlManagement: Codeunit WarrantyJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        CurrentJnlBatchName: Code[10];
        VehName: Text[30];
        ShortcutDimCode: array[8] of Code[20];

    local procedure SerialNoOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        WarrantyJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        WarrantyJnlManagement.GetVeh(Rec."Debit Description", VehName);
    end;
}

