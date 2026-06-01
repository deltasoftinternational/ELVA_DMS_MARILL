Page 25006629 "Rent Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Rent Ledger Entries';
    PageType = List;
    Editable = false;
    SourceTable = "Rent Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
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
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(DirectUnitCost; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(TotalPrice; Rec."Total Price")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Discount; Rec."Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(AmountIncludingVAT; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
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
                    Visible = false;
                }
                field(Chargeable; Rec.Chargeable)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(JournalBatchName; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(QtyperUnitofMeasure; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(QuantityBase; Rec."Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RentItemNo; Rec."Rent Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentAssetNo; Rec."Rent Asset No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentLineNo; Rec."Document Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(RentOrderNo; Rec."Rent Order No.")
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
                    Visible = false;
                }
                field(DealType; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineDiscountAmountLCY; Rec."Line Discount Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(InvDiscountAmount; Rec."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(InvDiscountAmountLCY; Rec."Inv. Discount Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AmountIncludingVATLCY; Rec."Amount Including VAT (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AmountLCY; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                }
                field("Available Quantity"; Rec."Available Quantity")
                {
                    ApplicationArea = All;
                }
                field("Variable Field Run 1"; Rec."Variable Field Run 1")
                {
                    ApplicationArea = All;
                    Visible = VFRun1Visible;
                }
                field("Variable Field Run 2"; Rec."Variable Field Run 2")
                {
                    ApplicationArea = All;
                    Visible = VFRun2Visible;
                }
                field("Variable Field Run 3"; Rec."Variable Field Run 3")
                {
                    ApplicationArea = All;
                    Visible = VFRun3Visible;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Suite;
                Caption = 'Dimensions';
                Image = Dimensions;
                Scope = Repeater;
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDimensions;
                end;
            }
            action(Navigate)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        Navigate: Page Navigate;
        VFRun1Visible: Boolean;
        VFRun2Visible: Boolean;
        VFRun3Visible: Boolean;

    procedure SetVariableFields()
    begin
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
    end;
}

