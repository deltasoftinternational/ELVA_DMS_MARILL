Page 25006812 "SP Salesperson Role Center"
{
    // 17.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added "Page Req. Wksh. Names" to the menu
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //         Added Page Action:
    //           Page Contract List EDMS
    // 
    // 27.03.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added "Service Order" to the menu
    // 
    // 17.03.2014 Elva Baltic P8 #S0002 MMG7.00
    //   * Added R250024

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1901851508; "SP Salesperson Activities")
                {
                }
                systempart(Control1901420308; Outlook)
                {
                }
            }
            group(Control1900724708)
            {
                part(Control1907692008; "My Customers")
                {
                }
                part(Control1905989608; "My Items")
                {
                }
                systempart(Control1901377608; MyNotes)
                {
                }
                part(Control25006000; "Report Inbox Part")
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Customer)
            {
                Caption = 'Customer';
                action(CustomerOrderSummary)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - &Order Summary';
                    Image = "Report";
                    RunObject = Report "Customer - Order Summary";
                }
                action(CustomerTop10List)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - &Top 10 List';
                    Image = "Report";
                    RunObject = Report "Customer - Top 10 List";
                }
                action(CustomerItemSales)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer/&Item Sales';
                    Image = "Report";
                    RunObject = Report "Customer/Item Sales";
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                action(SalespersonSalesStatistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salesperson - Sales &Statistics';
                    Image = Statistics;
                    RunObject = Report "Salesperson - Sales Statistics";
                }
                action(PriceList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Price &List';
                    Image = "Report";
                    RunObject = Report "Price List";
                }
            }
            group(Other)
            {
                Caption = 'Other';
                action(InventorySalesBackOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory - Sales &Back Orders';
                    Image = "Report";
                    RunObject = Report "Inventory - Sales Back Orders";
                }
                action("<Action1101904000>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales by Item Categories';
                    Image = "Report";
                    //RunObject = Report UnknownReport25006517;
                }
                action(ItemSalesReport)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Sales Report';
                    //RunObject = Report UnknownReport50024;
                }
            }
        }
        area(embedding)
        {
            action(SalesOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                RunObject = Page "Sales Order List";
            }
            action(ShippedNotInvoiced)
            {
                ApplicationArea = Basic;
                Caption = 'Shipped Not Invoiced';
                RunObject = Page "Sales Order List";
                RunPageView = where("Completely Shipped" = filter(true),
                                    Invoice = filter(false));
            }
            action(SalesQuotes)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Quotes';
                Image = Quote;
                RunObject = Page "Sales Quotes";
            }
            action(SalesBlanketOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Blanket Orders';
                RunObject = Page "Sales Orders";
            }
            action(SalesInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoices';
                RunObject = Page "Sales Invoice List";
            }
            action(SalesReturnOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Return Orders';
                RunObject = Page "Sales Return Order List";
            }
            action(SalesCreditMemos)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Credit Memos';
                RunObject = Page "Sales Credit Memos";
            }
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                RunObject = Page "Item List";
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action(ItemJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Item Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = where("Template Type" = const(Item),
                                    Recurring = const(false));
            }
            action(SalesJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type" = const(Sales),
                                    Recurring = const(false));
            }
            action(CashReceiptJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Cash Receipt Journals';
                Image = Journals;
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type" = const("Cash Receipts"),
                                    Recurring = const(false));
            }
            action(ServiceOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Service Orders';
                RunObject = Page "Service Orders EDMS";
            }
            action(RequisitionWorksheets)
            {
                ApplicationArea = Basic;
                Caption = 'Requisition Worksheets';
                RunObject = Page "Req. Wksh. Names";
                RunPageView = where("Template Type" = const("Req."),
                                    Recurring = const(false),
                                    "Document Profile" = const("Spare Parts Trade"));
            }
            action(Contracts)
            {
                ApplicationArea = Basic;
                Caption = 'Contracts';
                RunObject = Page "Contract List EDMS";
            }
        }
        area(sections)
        {
            group(PostedDocuments)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action(PostedSalesShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Shipments';
                    RunObject = Page "Posted Sales Shipments";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
                action(PostedSalesInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
                action(PostedReturnReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Receipts';
                    RunObject = Page "Posted Return Receipts";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
                action(PostedSalesCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
                action(PostedPurchaseReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
                action(PostedPurchaseInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
            }
            group(reports)
            {
                Caption = 'Reports';
                Image = RegisteredDocs;
                action(R1)
                {
                    ApplicationArea = All;
                    Caption = 'Item Subst. Invent. Overview';
                    Image = Report;
                    RunObject = Report "Item Subst. Invent. Overview";
                }
                action(R2)
                {
                    ApplicationArea = All;
                    Caption = 'ABC Category Update';
                    Image = Report;
                    RunObject = Report "ABC Category Update";
                }
            }
        }
        area(processing)
        {
            group(NewDocument)
            {
                Caption = 'New Document';
                action(SalesQuote)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Quote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Quote";
                    RunPageMode = Create;
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
                action(SalesInvoice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Invoice';
                    Image = Invoice;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Invoice";
                    RunPageMode = Create;
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
                action(SalesOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Order";
                    RunPageMode = Create;
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
                action(SalesReturnOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Return Order';
                    Image = ReturnOrder;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Return Order";
                    RunPageMode = Create;
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
                action(SalesCreditMemo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Credit Memo';
                    Image = CreditMemo;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Credit Memo";
                    RunPageMode = Create;
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
            }
            group(Tasks)
            {
                Caption = 'Tasks';
                action(SalesJournal)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Journal';
                    Image = Journals;
                    RunObject = Page "Sales Journal";
                }
                action(SalesPriceWorksheet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Price &Worksheet';
                    Image = PriceWorksheet;
                    RunObject = Page "Sales Price Worksheet";
                }
            }
            group(Related)
            {
                Caption = 'Related';
                action(SalesPrices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Prices';
                    Image = SalesPrices;
                    RunObject = Page "Sales Prices";
                }
                action(SalesLineDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Line Discounts';
                    Image = SalesLineDisc;
                    RunObject = Page "Sales Line Discounts";
                }
            }
            group(History)
            {
                Caption = 'History';
                action(Navigate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Navi&gate';
                    Image = Navigate;
                    RunObject = Page Navigate;
                }
            }
        }
    }
}

