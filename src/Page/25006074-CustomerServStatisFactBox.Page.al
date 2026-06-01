Page 25006074 "Customer Serv. Statis. FactBox"
{
    Caption = 'Customer Service Statistics - Bill-to Customer';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field(CustomerNo; Rec."No.")
            {
                ApplicationArea = Basic;
                Caption = 'Customer No.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            group(Sales)
            {
                Caption = 'Sales';
                field(OutstandingOrdersSPLCY; Rec."Outstanding Orders SP (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(ShippedNotInvdLCY; Rec."Shipped Not Invoiced SP (LCY)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Shipped Not Invd. (LCY)';
                }
                field(OutstandingInvoicesSPLCY; Rec."Outstanding Invoices SP (LCY)")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field(OutstServOrdersEDMSLCY; Rec."Outst. Serv. Orders EDMS (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(OutstServInvoicesEDMSLCY; Rec."Outst. Serv.Invoices EDMS(LCY)")
                {
                    ApplicationArea = Basic;
                }
            }
            field(CreditLimitLCY; Rec."Credit Limit (LCY)")
            {
                ApplicationArea = Basic;
            }
            field("Balance Due (LCY)"; Rec.CalcOverdueBalance)
            {
                ApplicationArea = Basic;
                CaptionClass = FORMAT(STRSUBSTNO(Text000, FORMAT(WORKDATE)));

                trigger OnDrillDown()
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    DtldCustLedgEntry.SetFilter("Customer No.", Rec."No.");
                    Rec.Copyfilter("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                    Rec.Copyfilter("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                    Rec.Copyfilter("Currency Filter", DtldCustLedgEntry."Currency Code");
                    CustLedgEntry.DrillDownOnOverdueEntries(DtldCustLedgEntry);
                end;
            }
        }
    }

    actions
    {
    }

    var
        Text000: label 'Overdue Amounts (LCY) as of %1';


    procedure ShowDetails()
    begin
        Page.Run(Page::"Customer Card", Rec);
    end;
}

