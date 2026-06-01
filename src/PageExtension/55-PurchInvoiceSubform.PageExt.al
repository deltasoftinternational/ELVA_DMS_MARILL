pageextension 25006052 "Purch. Invoice Subform" extends "Purch. Invoice Subform" //55
{
    layout
    {
        addafter("VAT Prod. Posting Group")
        {

            field(ExternalServTrackingNo; REC."External Serv. Tracking No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Deferral Code")
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
                    DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
                    DocumentTotals.PurchaseUpdateTotalsControls(
                      Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
                      TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount);
                end;
            }
        }

    }

    trigger OnAfterGetCurrRecord()
    begin
        DeltaInvDiscAmountEditable;
    end;

    procedure DeltaInvDiscAmountEditable()
    begin

        PurchasesPayablesSetup.Get();
        InvDiscAmountEditable :=
            (CurrPage.Editable) and not PurchasesPayablesSetup."Calc. Inv. Discount" and
            (TotalPurchaseHeader.Status = TotalPurchaseHeader.Status::Open);
    end;

    var
        TotalAmountStyle: Text;
        RefreshMessageText: Text;
        RefreshMessageEnabled: Boolean;
        InvDiscAmountEditable: Boolean;
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
}