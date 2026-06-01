pageextension 25006055 "Sales Cr. Memo Subform" extends "Sales Cr. Memo Subform"//96
{
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field(VehicleSerialNo; Rec."Vehicle Serial No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(VIN; Rec.VIN)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Total Amount Incl. VAT")
        {
            field(RefreshTotals; RefreshMessageText)
            {
                ApplicationArea = Basic;
                DrillDown = true;
                Editable = false;
                Enabled = RefreshMessageEnabled;
                ShowCaption = false;

                trigger OnDrillDown()
                begin
                    DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
                    DocumentTotals.SalesUpdateTotalsControls(Rec, TotalSalesHeader, TotalSalesLine, RefreshMessageEnabled,
                      TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, CurrPage.Editable, VATAmount);
                end;
            }
        }
    }
    var
        DocumentTotals: Codeunit "Document Totals";
        RefreshMessageText: Text;

    protected var
        RefreshMessageEnabled: Boolean;
        TotalAmountStyle: Text;
}