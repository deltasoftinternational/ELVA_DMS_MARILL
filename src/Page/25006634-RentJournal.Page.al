Page 25006634 "Rent Journal"
{
    ApplicationArea = Basic;
    Caption = 'Rent Journal';
    PageType = Worksheet;
    SourceTable = "Rent Journal Line";
    UsageCategory = Tasks;
    AutoSplitKey = true;
    DelayedInsert = true;
    SaveValues = true;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Batch Name';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    RentJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    RentJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrPage.SaveRecord;
                    RentJnlManagement.SetName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;
            }
            repeater(Group)
            {
                field(JournalTemplateName; Rec."Journal Template Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(JournalBatchName; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(LineNo; Rec."Line No.")
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
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(RentItemNo; Rec."Rent Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentAssetNo; Rec."Rent Asset No.")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
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
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field(PostingNoSeries; Rec."Posting No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentLineNo; Rec."Document Line No.")
                {
                    ApplicationArea = Basic;
                }
                /*
                field(TransferfromCode;"Transfer-from Code")
                {
                    ApplicationArea = Basic;
                }
                field(TransfertoCode;"Transfer-to Code")
                {
                    ApplicationArea = Basic;
                }
                */
                field(RentOrderNo; Rec."Rent Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentOrderType; Rec."Rent Order Type")
                {
                    ApplicationArea = Basic;
                }
                field(RentOrderLineNo; Rec."Rent Order Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentTransferType; Rec."Rent Transfer Type")
                {
                    ApplicationArea = Basic;
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(DealType; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Discount; Rec."Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmountLCY; Rec."Line Discount Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(InvDiscountAmount; Rec."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(DimensionSetID; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                }
                field(AmountIncludingVATLCY; Rec."Amount Including VAT (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(AmountIncludingVAT; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field(AmountLCY; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun3Visible;
                }
            }
            //group(Control25006059)
            //{

            //field(RentName; RentName)
            //{
            //   ApplicationArea = Basic;
            //   Caption = 'Rent Name';
            //}
            //}
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDimensions;
                    CurrPage.SaveRecord;
                end;
            }
            action(LedgerEntries)
            {
                ApplicationArea = Basic;
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Rent Ledger Entries";
            }
        }
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F11';

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Rent Jnl.-Post", Rec);
                    CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                    CurrPage.Update(false);
                end;
            }
            action(PostAndPrint)
            {
                ApplicationArea = Basic;
                Caption = 'Post and &Print';

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Res. Jnl.-Post+Print", Rec);
                    CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        RentJnlManagement.TemplateSelection(Page::"Rent Journal", false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        RentJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
        //OnAfterGetCurrRecord;
    end;


    var
        RentJnlManagement: Codeunit RentJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        CurrentJnlBatchName: Code[10];
        RentName: Text[50];
        ShortcutDimCode: array[8] of Code[20];
        IsVFRun1Visible: Boolean;
        IsVFRun2Visible: Boolean;
        IsVFRun3Visible: Boolean;
}

