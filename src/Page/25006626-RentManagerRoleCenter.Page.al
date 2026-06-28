Page 25006626 "Rent Manager Role Center"
{
    Caption = 'Rent Manager Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {

            part(Control25006009; "Rent Manager Activities")
            {
                ApplicationArea = All;
            }
            part(Control25006002; "My Customers")
            {
                ApplicationArea = All;
            }
            part(Control14; "Team Member Activities")
            {
                ApplicationArea = All;
                Visible = false;
            }
            part(Control25006008; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control25006004; "Report Inbox Part")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        area(embedding)
        {
            action(RentQuotes)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Quotes';
                RunObject = Page "Rent Quote List";
            }
            action(RentOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Orders';
                RunObject = Page "Rent Order List";
            }
            action(RentInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Invoices';
                RunObject = Page "Rent Invoices";
            }
            action(RentCreditMemos)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Credit Memos';
                RunObject = Page "Rent Credit Memos";
            }
            action(RentTransferOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Transfer Orders';
                RunObject = Page "Rent Transfer List";
            }
            action(Contacts)
            {
                ApplicationArea = Basic;
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = Page "Contact List";
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(RentJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Journal';
                RunObject = Page "Rent Journal";
            }
            action(RentWksht)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Worksheet';
                RunObject = Page "Rent Billing Worksheet";
                RunPageMode = Edit;

            }
            action("Contracts")
            {
                ApplicationArea = Basic;
                Caption = 'Contracts';
                RunObject = page "Contract List EDMS";
            }
        }
        area(sections)
        {
            group(Catalogues)
            {
                Caption = 'Catalogues';
                Image = ReferenceData;
                action(RentItems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Items';
                    RunObject = Page "Rent Item List";
                }
                action(RentAssets)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Assets';
                    RunObject = Page "Rent Asset List";
                }
                action(RentPackages)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Packages';
                    RunObject = Page "Rent Package List";
                }
            }
            group(PostedDocuments)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action(PostedSalesInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Rent Invoices";
                    RunPageView = where("Document Profile" = const(Rent));
                }
                action(PostedCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Credit Memos';
                    RunObject = Page "Posted Rent Credit Memos";
                    RunPageView = where("Document Profile" = const(Rent));
                }
                action(PostedTransferOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Transfer Orders';
                    RunObject = Page "Posted Rent Transfer List";
                }
                action(ClosedRentOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Rent Orders';
                    RunObject = Page "Closed Rent Order List";
                }
                action(RentLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Ledger Entries';
                    RunObject = Page "Rent Ledger Entries";
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                Image = Setup;
                action(RentSetup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Setup';
                    RunObject = Page "Rent Setup";
                }
                action(RentJournalTemplList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Journal Templates';
                    RunObject = Page "Rent Journal Template List";
                }
                action(RentJournalBatches)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Journal Bathes';
                    RunObject = Page "Rent Jnl. Batches";
                }
                action(RentPeriods)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Periods';
                    RunObject = Page "Rent Period List";
                }
                action(RentCategories)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Categories';
                    RunObject = Page "Rent Item Categories";
                }
                action(RentProductGroups)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Product Groups';
                    RunObject = Page "Rent Product Groups";
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                Image = ResourcePlanning;
                action(RentCapacity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Capacity';
                    Image = Capacity;
                    RunObject = Page "Rent Item Capacity";
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                Image = ResourcePlanning;
                action(RentRevenueByAsset)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Revenue by Assets';
                    Image = Capacity;
                    RunObject = report "Rent Revenue by Assets";
                }
                action(RentRevenueByCustomers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Revenue by Customers';
                    Image = Capacity;
                    RunObject = report "Rent Revenue by Customers";
                }
            }
        }
    }
}