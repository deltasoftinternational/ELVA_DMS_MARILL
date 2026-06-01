Page 25006813 "SP Purchaser Role Center"
{
    // 21.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *'Sales Price Worksheet" added to actions
    // 
    // 10.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Report Import Curr.Exch. Rates
    // 
    // 09.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Report "Internal Invoice" added to the menu
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Visible=False set to the following menu items:
    //     - Pending Confirmation
    //     - Purchase Return Orders
    //     - Purchase Analysis Reports
    //   *Added menu items:
    //     - Transfer Orders
    //     - Service Orders

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1907662708; "SP Purchaser Activities")
                {
                }
                systempart(Control1901420308; Outlook)
                {
                }
            }
            group(Control1900724708)
            {
                part(Control1902476008; "My Vendors")
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
            action(VendorTop10List)
            {
                ApplicationArea = Basic;
                Caption = 'Vendor - T&op 10 List';
                Image = "Report";
                RunObject = Report "Vendor - Top 10 List";
            }
            action(VendorItemPurchases)
            {
                ApplicationArea = Basic;
                Caption = 'Vendor/&Item Purchases';
                Image = "Report";
                RunObject = Report "Vendor/Item Purchases";
            }
            action(ReceivedItemJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Received Item Journal';
                Image = "Report";
                //RunObject = Report UnknownReport50017;
            }
            action(InternalInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Internal Invoice';
                //RunObject = Report UnknownReport50040;
            }
            group(Inventory)
            {
                Caption = 'Inventory';
                action(InventoryAvailabilityPlan)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory - &Availability Plan';
                    Image = "Report";
                    RunObject = Report "Inventory - Availability Plan";
                }
                action(InventoryPurchaseOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory &Purchase Orders';
                    Image = "Report";
                    RunObject = Report "Inventory Purchase Orders";
                }
                action(InventoryVendorPurchases)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory - &Vendor Purchases';
                    Image = "Report";
                    RunObject = Report "Inventory - Vendor Purchases";
                }
                action(InventoryCostandPriceList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory &Cost and Price List';
                    Image = "Report";
                    RunObject = Report "Inventory Cost and Price List";
                }
            }
        }
        area(embedding)
        {
            action(PurchaseOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action(PendingConfirmation)
            {
                ApplicationArea = Basic;
                Caption = 'Pending Confirmation';
                RunObject = Page "Purchase Order List";
                Visible = false;
            }
            action(PartiallyDelivered)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Delivered';
                RunObject = Page "Purchase Order List";
                RunPageView = where(Status = filter(Released),
                                    Receive = filter(true),
                                    "Completely Received" = filter(false));
            }
            action(PurchaseQuotes)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Quotes';
                RunObject = Page "Purchase Quotes";
            }
            action(PurchaseBlanketOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Orders";
            }
            action(PurchaseInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
            }
            action(PurchaseReturnOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Return Orders';
                RunObject = Page "Purchase Return Order List";
                Visible = false;
            }
            action(PurchaseCreditMemos)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Credit Memos';
                RunObject = Page "Purchase Credit Memos";
            }
            action(SalesOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                RunObject = Page "Sales Order List";
            }
            action(Vendors)
            {
                ApplicationArea = Basic;
                Caption = 'Vendors';
                RunObject = Page "Vendor List";
            }
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                RunObject = Page "Item List";
            }
            action(NonstockItems)
            {
                ApplicationArea = Basic;
                Caption = 'Nonstock Items';
                RunObject = Page "Catalog Item List";
            }
            action(StockkeepingUnits)
            {
                ApplicationArea = Basic;
                Caption = 'Stockkeeping Units';
                RunObject = Page "Stockkeeping Unit List";
            }
            action(PurchaseAnalysisReports)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Analysis Reports';
                RunObject = Page "Analysis Report Purchase";
                RunPageView = where("Analysis Area" = filter(Purchase));
                Visible = false;
            }
            action(InventoryAnalysisReports)
            {
                ApplicationArea = Basic;
                Caption = 'Inventory Analysis Reports';
                RunObject = Page "Analysis Report Inventory";
                RunPageView = where("Analysis Area" = filter(Inventory));
            }
            action(ItemJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Item Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = where("Template Type" = const(Item),
                                    Recurring = const(false));
            }
            action(PurchaseJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = where("Template Type" = const(Purchases),
                                    Recurring = const(false));
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
            action(TransferOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Orders';
                RunObject = Page "Transfer Orders";
            }
            action(ServiceOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Service Orders';
                RunObject = Page "Service Orders EDMS";
            }
        }
        area(sections)
        {
            group(PostedDocuments)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
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
                action(PostedReturnShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Spare Parts Trade"));
                }
                action(PostedPurchaseCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
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
                action(PurchaseQuote)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase &Quote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Purchase Quote";
                    RunPageMode = Create;
                    RunPageView = where("Document Profile" = const("Spare Parts Trade"));
                }
                action(PurchaseInvoice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase &Invoice';
                    Image = Invoice;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Purchase Invoice";
                    RunPageMode = Create;
                    RunPageView = where("Document Profile" = const("Spare Parts Trade"));
                }
                action(PurchaseOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Purchase Order";
                    RunPageMode = Create;
                    RunPageView = where("Document Profile" = const("Spare Parts Trade"));
                }
                action(PurchaseReturnOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase &Return Order';
                    Image = ReturnOrder;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Purchase Return Order";
                    RunPageMode = Create;
                    RunPageView = where("Document Profile" = const("Spare Parts Trade"));
                }
            }
            group(Tasks)
            {
                Caption = 'Tasks';
                action(PurchaseJournal)
                {
                    ApplicationArea = Basic;
                    Caption = '&Purchase Journal';
                    Image = Journals;
                    RunObject = Page "Purchase Journal";
                }
                action(ItemJournal)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Journal';
                    Image = Journals;
                    RunObject = Page "Item Journal";
                }
                action(OrderPlanning)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order Plan&ning';
                    Image = "Order";
                    RunObject = Page "Order Planning";
                }
            }
            group(Related)
            {
                Caption = 'Related';
                action(RequisitionWorksheet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requisition &Worksheet';
                    Image = Worksheet;
                    RunObject = Page "Req. Wksh. Names";
                    RunPageView = where("Template Type" = const("Req."),
                                        Recurring = const(false));
                }
                action(PurchasePrices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pur&chase Prices';
                    Image = Price;
                    RunObject = Page "Purchase Prices";
                }
                action(PurchaseLineDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase &Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Purchase Line Discounts";
                }
                action(SalesPriceWorksheet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Price Worksheet';
                    Image = Worksheet;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Price Worksheet";
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

