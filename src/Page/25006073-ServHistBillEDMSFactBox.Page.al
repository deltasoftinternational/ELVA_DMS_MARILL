Page 25006073 "Serv. Hist. Bill EDMS FactBox"
{
    Caption = 'Bill-to Customer Service History';
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
            field(Quotes; Rec."Bill-To No. of S. Quotes")
            {
                ApplicationArea = Basic;
                Caption = 'Quotes';
                DrillDownPageID = "Service Quotes EDMS";
            }
            field(Orders; Rec."Bill-To No. of S. Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Orders';
                DrillDownPageID = "Service Orders EDMS";
            }
            field(Invoices; Rec."Bill-To No. of S. Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Invoices';
                DrillDownPageID = "Sales Invoice List (Service)";
            }
            field(ReturnOrders; Rec."Bill-To No. of S. Ret. Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Return Orders';
                DrillDownPageID = "Service Return Orders EDMS";
            }
            field(CreditMemos; Rec."Bill-To No. of S. Credit Memos")
            {
                ApplicationArea = Basic;
                Caption = 'Credit Memos';
                DrillDownPageID = "Sales Credit Memos (Service)";
            }
            field(PstdShipments; Rec."Bill-To No. of S. Pstd. Shipm.")
            {
                ApplicationArea = Basic;
                Caption = 'Pstd. Shipments';
            }
            field(PstdInvoices; Rec."Bill-To No. of S. Pstd. Inv.")
            {
                ApplicationArea = Basic;
                Caption = 'Pstd. Invoices';
                DrillDownPageID = "Posted Sales Invoices (Serv.)";
            }
            field(PstdReturnReceipts; Rec."Bill-To No. of S.Pstd. Ret. R.")
            {
                ApplicationArea = Basic;
                Caption = 'Pstd. Return Receipts';
                DrillDownPageID = "Posted Return Receipts";
            }
            field(PstdCreditMemos; Rec."Bill-To No. of S. Pstd. C.Mem.")
            {
                ApplicationArea = Basic;
                Caption = 'Pstd. Credit Memos';
                DrillDownPageID = "Posted Sales Cr.Memos (Serv.)";
            }
        }
    }

    actions
    {
    }


    procedure ShowDetails()
    begin
        Page.Run(Page::"Customer Card", Rec);
    end;
}

