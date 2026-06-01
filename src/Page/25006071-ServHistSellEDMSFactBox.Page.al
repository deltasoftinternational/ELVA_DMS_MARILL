Page 25006071 "Serv. Hist. Sell EDMS FactBox"
{
    Caption = 'Sell-to Customer Service History';
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
            field(Quotes; Rec."No. of Serv. Quotes")
            {
                ApplicationArea = Basic;
                Caption = 'Quotes';
                DrillDownPageID = "Service Quotes EDMS";
            }
            field(Orders; Rec."No. of Serv. Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Orders';
                DrillDownPageID = "Service Orders EDMS";
            }
            field(Invoices; Rec."No. of Serv. Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Invoices';
                DrillDownPageID = "Sales Invoice List (Service)";
            }
            field(ReturnOrders; Rec."No. of Serv. Return Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Return Orders';
                DrillDownPageID = "Service Return Orders EDMS";
            }
            field(CreditMemos; Rec."No. of Serv. Credit Memos")
            {
                ApplicationArea = Basic;
                Caption = 'Credit Memos';
                DrillDownPageID = "Sales Credit Memos (Service)";
            }
            field(PstdShipments; Rec."No. of Serv. Pstd. Shipments")
            {
                ApplicationArea = Basic;
                Caption = 'Pstd. Shipments';
            }
            field(PstdInvoices; Rec."No. of Serv. Pstd. Invoices")
            {
                ApplicationArea = Basic;
                Caption = 'Pstd. Invoices';
                DrillDownPageID = "Posted Sales Invoices (Serv.)";
            }
            field(PstdReturnReceipts; Rec."No. of S.Pstd. Return Receipts")
            {
                ApplicationArea = Basic;
                Caption = 'Pstd. Return Receipts';
                DrillDownPageID = "Posted Return Receipts";
            }
            field(PstdCreditMemos; Rec."No. of Serv. Pstd. Cr. Memos")
            {
                ApplicationArea = Basic;
                Caption = 'Pstd. Credit Memos';
                DrillDownPageID = "Posted Sales Cr.Memos (Serv.)";
            }
            field(ActiveContracts; Rec."No. of Active Contracts")
            {
                ApplicationArea = Basic;
                Caption = 'Active Contracts';
                DrillDownPageID = "Contract List EDMS";
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

