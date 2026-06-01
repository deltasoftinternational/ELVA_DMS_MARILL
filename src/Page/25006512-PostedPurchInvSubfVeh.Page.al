Page 25006512 "Posted Purch. Inv. Subf. (Veh)"
{
    AutoSplitKey = true;
    Caption = 'Vehicle Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Purch. Inv. Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LineType; Rec."Line Type")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(No; Rec."No.")
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
                field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleStatusCode; Rec."Vehicle Status Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CrossReferenceNo; Rec."Item Reference No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ICPartnerCode; Rec."IC Partner Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(ReturnReasonCode; Rec."Return Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DirectUnitCost; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(IndirectCost; Rec."Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitCostLCY; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitPriceLCY; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(JobNo; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(InsuranceNo; Rec."Insurance No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BudgetedFANo; Rec."Budgeted FA No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(FAPostingType; Rec."FA Posting Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DepruntilFAPostingDate; Rec."Depr. until FA Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DepreciationBookCode; Rec."Depreciation Book Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DeprAcquisitionCost; Rec."Depr. Acquisition Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AppltoItemEntry; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control15)
            {
                ShowCaption = false;
                group(Control13)
                {
                    ShowCaption = false;
                    field("Invoice Discount Amount"; TotalPurchInvHeader."Invoice Discount Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalPurchInvHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATCaption(TotalPurchInvHeader."Prices Including VAT");
                        Caption = 'Invoice Discount Amount';
                        Editable = false;
                        ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.';
                    }
                }
                group(Control9)
                {
                    ShowCaption = false;
                    field("Total Amount Excl. VAT"; TotalPurchInvHeader.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalPurchInvHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(TotalPurchInvHeader."Currency Code");
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalPurchInvHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(TotalPurchInvHeader."Currency Code");
                        Caption = 'Total VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT"; TotalPurchInvHeader."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalPurchInvHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(TotalPurchInvHeader."Currency Code");
                        Caption = 'Total Amount Incl. VAT';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = true;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #138. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchInvLines.FORM.*/
                        _ShowDimensions;

                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #138. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchInvLines.FORM.*/
                        _ShowLineComments;

                    end;
                }
                action(ItemReceiptLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Receipt &Lines';
                    Image = ReceiptLines;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #138. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchInvLines.FORM.*/
                        _ShowItemReceiptLines;

                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocumentTotals.CalculatePostedPurchInvoiceTotals(TotalPurchInvHeader, VATAmount, Rec);
    end;

    var
        TotalPurchInvHeader: Record "Purch. Inv. Header";
        DocumentTotals: Codeunit "Document Totals";
        IsFoundation: Boolean;
        VATAmount: Decimal;


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure _ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;


    procedure ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;


    procedure _ShowItemReceiptLines()
    begin
        if not (Rec.Type in [Rec.Type::Item, Rec.Type::"Charge (Item)"]) then
            Rec.TestField(Type);
        Rec.ShowItemReceiptLines;
    end;


    procedure ShowItemReceiptLines()
    begin
        if not (Rec.Type in [Rec.Type::Item, Rec.Type::"Charge (Item)"]) then
            Rec.TestField(Type);
        Rec.ShowItemReceiptLines;
    end;


    procedure _ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;


    procedure ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;
}

