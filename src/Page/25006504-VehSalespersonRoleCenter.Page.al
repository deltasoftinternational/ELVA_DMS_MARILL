Page 25006504 "Veh. Salesperson Role Center"
{
    // 19.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * To-Do List added to Menu

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control1901851508; "Veh. Salesperson Activities")
            {
                ApplicationArea = All;
            }

            part(Control1907692008; "My Customers")
            {
                ApplicationArea = All;
            }
            part(Control14; "Team Member Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control1; "Trailing Sales Orders Chart")
            {
                AccessByPermission = TableData "Sales Shipment Header" = R;
                ApplicationArea = Basic, Suite;
            }
            part(MyJobQueue; "My Job Queue")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control1905989608; "My Items")
            {
                ApplicationArea = All;
            }

            part(Control13; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control25006000; "Report Inbox Part")
            {
                ApplicationArea = All;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        area(reporting)
        {
            action(CustomerOrderSummary)
            {
                ApplicationArea = Basic;
                Caption = 'Customer - &Order Summary';
                Image = StatisticsDocument;
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
                Image = SalesPrices;
                RunObject = Report "Price List";
            }
            action(InventorySalesBackOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - Sales &Back Orders';
                Image = MakeOrder;
                RunObject = Report "Inventory - Sales Back Orders";
            }
            action("<Action1101904003>")
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Sales';
                Image = "Report";
                RunObject = Report "Vehicle Sales";
            }
            action(SalespersonInteractions)
            {
                ApplicationArea = Basic;
                Caption = 'Salesperson Interactions';
                Image = "Report";
                //RunObject = Report UnknownReport50012;
            }
            action(VehicleRent)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Rent';
                Image = "Report";
                //RunObject = Report UnknownReport50013;
            }
        }
        area(embedding)
        {
            action(SalesOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            action(SalesQuotes)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Quotes';
                Image = Quote;
                RunObject = Page "Sales Quotes";
            }
            action(SalesInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List";
            }
            action(SalesReturnOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Return Orders';
                Image = ReturnOrder;
                RunObject = Page "Sales Return Order List";
            }
            action(SalesCreditMemos)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Credit Memos';
                Image = CreditMemo;
                RunObject = Page "Sales Credit Memos";
            }
            action(Vehicles)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicles';
                Image = ListPage;
                RunObject = Page "Vehicle List";
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
            action(ItemJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Item Journals';
                Image = Journal;
                RunObject = Page "Item Journal Batches";
                RunPageView = where("Template Type" = const(Item),
                                    Recurring = const(false));
            }
            action(ToDoList)
            {
                ApplicationArea = Basic;
                Caption = 'To-Do List';
                RunObject = Page "Task List";
            }
        }
        area(sections)
        {
            group("<Action1101904009>")
            {
                Caption = 'Catalogues';
                Image = ReferenceData;
                action("<Action1101904014>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Makes';
                    Image = Production;
                    RunObject = Page "Make List";
                }
                action("<Action1101904015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Models';
                    Image = ListPage;
                    RunObject = Page "Model List";
                }
                action(ModelVersions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Model Versions';
                    Image = Versions;
                    RunObject = Page "Model Version List";
                }
            }
            group(PostedDocuments)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action(PostedSalesShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action(PostedSalesInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedReceipt;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action(PostedReturnReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action(PostedSalesCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedCreditMemo;
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action(PostedPurchaseReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    Image = PostedReceipts;
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action(PostedPurchaseInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Invoices';
                    Image = PostedPayment;
                    RunObject = Page "Posted Purchase Invoices";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action("<Action1101904002>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Order Archives';
                    Image = Archive;
                    RunObject = Page "Sales Order Archives";
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                Image = RegisteredDocs;
                action(R1)
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Sales';
                    Image = Report;
                    RunObject = Report "Vehicle Sales";
                }
                action(R2)
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Sales TOP';
                    Image = Report;
                    RunObject = Report "Vehicle Sales TOP";
                }
                action(R3)
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Purch. Overview - 1';
                    Image = Report;
                    RunObject = Report "Vehicle Purch. Overview - 1";
                }
                action(R4)
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Inventory Overview';
                    Image = Report;
                    RunObject = Report "Vehicle Inventory Overview";
                }
                action(R5)
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Stock';
                    Image = Report;
                    RunObject = Report "Vehicle Stock";
                }
                action(R6)
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Document Vehicle';
                    Image = Report;
                    RunObject = Report "Inventory Document Vehicle";
                }
                action(R7)
                {
                    ApplicationArea = All;
                    Caption = 'Salesperson Interactions';
                    Image = Report;
                    RunObject = Report "Salesperson Interactions";
                }
            }
        }
        area(processing)
        {
            separator(Action48)
            {
                Caption = 'New';
                IsHeader = true;
            }
            action("<Action37>")
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
                              where("Document Profile" = const("Vehicles Trade"));
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
                              where("Document Profile" = const("Vehicles Trade"));
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
                              where("Document Profile" = const("Vehicles Trade"));
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
                              where("Document Profile" = const("Vehicles Trade"));
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
                              where("Document Profile" = const("Vehicles Trade"));
            }
            separator(Action35)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
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
                Image = Worksheet;
                RunObject = Page "Sales Price Worksheet";
            }
            separator(Action42)
            {
            }
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
            separator(Action45)
            {
                Caption = 'History';
                IsHeader = true;
            }
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

            action(Schedule)
            {
                ApplicationArea = Basic;
                Caption = 'Schedule';
                Image = Planning;
                RunObject = Page "Service Schedule";
            }
        }
    }
}

