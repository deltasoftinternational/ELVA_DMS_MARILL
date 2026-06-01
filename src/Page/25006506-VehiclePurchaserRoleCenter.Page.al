Page 25006506 "Vehicle Purchaser Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1907662708; "Vehicle Purchaser Activities")
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
                action(VehiclePurchaseOverview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Purchase Overview';
                    Image = "Report";
                    RunObject = Report "Vehicle Purch. Overview - 1";
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
            action(PurchaseQuotes)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Quotes';
                RunObject = Page "Purchase Quotes";
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
            action(Vehicles)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicles';
                RunObject = Page "Vehicle List";
            }
            action(Vendors)
            {
                ApplicationArea = Basic;
                Caption = 'Vendors';
                RunObject = Page "Vendor List";
            }
            action(PurchaseAnalysisReports)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Analysis Reports';
                RunObject = Page "Analysis Report Purchase";
                RunPageView = where("Analysis Area" = filter(Purchase));
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
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action(PostedPurchaseInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action(PostedReturnShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action(PostedPurchaseCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action("<Action1101904001>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Order Archives';
                    RunObject = Page "Purchase Order Archives";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
            }
            group(reports)
            {
                Caption = 'Reports';
                Image = RegisteredDocs;
                action(R1)
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Purch. Overview - 1';
                    Image = Report;
                    RunObject = Report "Vehicle Purch. Overview - 1";
                }
                action(R2)
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Inventory Overview';
                    Image = Report;
                    RunObject = Report "Vehicle Inventory Overview";
                }
                action(R3)
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Stock';
                    Image = Report;
                    RunObject = Report "Vehicle Stock";
                }
                action(R4)
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Document Vehicle';
                    Image = Report;
                    RunObject = Report "Inventory Document Vehicle";
                }
            }
        }
        area(processing)
        {
            group(Document)
            {
                Caption = 'Document';
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
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
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
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
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
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
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
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
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
                action(InteractionLog)
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Log';
                    Image = InteractionLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Interaction Log Entries";
                }
            }
        }
    }
}

