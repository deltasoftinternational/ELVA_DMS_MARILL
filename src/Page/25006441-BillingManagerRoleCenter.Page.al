Page 25006441 "Billing Manager Role Center"
{
    Caption = 'Billing Manager Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {

            part(Control25006009; "BLS Manager Activities")
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
            part(Control1905989608; "My Items")
            {
                AccessByPermission = TableData "My Item" = R;
                ApplicationArea = Basic, Suite;
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
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action(Contracts)
            {
                ApplicationArea = Basic;
                Caption = 'Contracts';
                RunObject = Page "Contract List EDMS";
            }
            action(BillingService)
            {
                ApplicationArea = Basic;
                Caption = 'Billing Service';
                RunObject = Page "BLS Service List";
            }
            action(BillingObjects)
            {
                ApplicationArea = Basic;
                Caption = 'Billing Objects';
                RunObject = Page "BLS Object List";
            }
            action(BillingSchedule)
            {
                ApplicationArea = Basic;
                Caption = 'BLS Leasing Schedule List';
                RunObject = Page "BLS Leasing Schedule List";
            }
        }
        area(sections)
        {
            group(Tasks)
            {
                Caption = 'Tasks';
                Image = FiledPosted;
                action(BillingServiceJournal)
                {
                    ApplicationArea = Basic;
                    Caption = 'Billing Service Journal';
                    RunObject = Page "BLS Journal DMS";
                }
                action(CalculationWorksheet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculation Worksheet';
                    RunObject = Page "BLS Calculation Worksheet";
                }
                action(SalesInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Invoices';
                    Image = Invoice;
                    RunObject = Page "Sales Invoice List";
                }
                action(SalesCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Credit Memos';
                    Image = CreditMemo;
                    RunObject = Page "Sales Credit Memos";
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                Image = Setup;
                action(BillingSetup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Billing Setup';
                    RunObject = Page "BLS Setup";
                }
                action(ContractCategories)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Categories';
                    RunObject = Page "BLS Contract Categories";
                }
                action(BillingJournalTemplates)
                {
                    ApplicationArea = Basic;
                    Caption = 'Billing Journal Templates';
                    RunObject = Page "BLS Journal Templates";
                }
            }
            group(Archive)
            {
                Caption = 'History';
                Image = ResourcePlanning;
                action(ServiceLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Billing Service Ledger Entries';
                    RunObject = Page "Service Ledger Entries EDMS";
                }
                action(BillingCalculationLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Billing Calculation Ledger Entries';
                    RunObject = Page "BLS Calculation Ledger Entries";
                }
                action(BillingInvoicingLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Billing Invoicing Ledger Entries';
                    RunObject = Page "BLS Invoicing Ledger Entries";
                }
                action("PostedSalesInvoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedPayment;
                    RunObject = Page "Posted Sales Invoices (Serv.)";
                }
                action("PostedSalesCrMemos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedCreditMemo;
                    RunObject = Page "Posted Sales Cr.Memos (Serv.)";
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                Image = RegisteredDocs;
                action(R1)
                {
                    ApplicationArea = All;
                    Caption = 'Contract Report';
                    Image = Report;
                    RunObject = Report "Contract Report";
                }
            }
        }
    }
}

