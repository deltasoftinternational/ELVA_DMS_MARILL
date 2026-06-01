Page 25006548 "Vehicle Whse. Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1906245608; "Vehicle Whse Activities")
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
            action(WarehouseBinList)
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse &Bin List';
                Image = "Report";
                RunObject = Report "Warehouse Bin List";
            }
            action(PhysicalInventoryList)
            {
                ApplicationArea = Basic;
                Caption = 'Physical &Inventory List';
                Image = "Report";
                RunObject = Report "Phys. Inventory List";
            }
            action(CustomerLabels)
            {
                ApplicationArea = Basic;
                Caption = 'Customer &Labels';
                Image = "Report";
                RunObject = Report "Customer - Labels";
            }
            action("<Action1101904001>")
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Inventory Overview';
                Image = "Report";
                RunObject = Report "Vehicle Inventory Overview";
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
            action(Released)
            {
                ApplicationArea = Basic;
                Caption = 'Released';
                RunObject = Page "Sales Order List";
                RunPageView = where(Status = filter(Released));
            }
            action(PartiallyShipped)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Shipped';
                RunObject = Page "Sales Order List";
                RunPageView = where(Status = filter(Released),
                                    "Completely Shipped" = filter(false));
            }
            action(PurchaseReturnOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Return Orders';
                RunObject = Page "Purchase Return Order List";
                RunPageView = where("Document Type" = filter("Return Order"));
            }
            action(TransferOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Orders';
                Image = Document;
                RunObject = Page "Transfer Orders";
            }
            action(PurchaseOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action(Action33)
            {
                ApplicationArea = Basic;
                Caption = 'Released';
                RunObject = Page "Purchase Order List";
                RunPageView = where(Status = filter(Released));
            }
            action(PartiallyReceived)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Received';
                RunObject = Page "Purchase Order List";
                RunPageView = where(Status = filter(Released),
                                    "Completely Received" = filter(false));
            }
            action(SalesReturnOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Return Orders';
                RunObject = Page "Sales Return Order List";
            }
            action(Vehicles)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicles';
                RunObject = Page "Vehicle List";
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action(Vendors)
            {
                ApplicationArea = Basic;
                Caption = 'Vendors';
                RunObject = Page "Vendor List";
            }
            action(ShippingAgents)
            {
                ApplicationArea = Basic;
                Caption = 'Shipping Agents';
                RunObject = Page "Shipping Agents";
            }
            action(ItemReclassificationJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Item Reclassification Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = where("Template Type" = const(Transfer),
                                    Recurring = const(false));
            }
            action(PhysInventoryJournals)
            {
                ApplicationArea = Basic;
                Caption = 'Phys. Inventory Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = where("Template Type" = const("Phys. Inventory"),
                                    Recurring = const(false));
            }
        }
        area(sections)
        {
            group(PostedDocuments)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action(PostedInvtPicks)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Invt. Picks';
                    Image = PostedInventoryPick;
                    RunObject = Page "Posted Invt. Pick List";
                }
                action(PostedSalesShipment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Shipment';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                }
                action(PostedTransferShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Transfer Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Transfer Shipments";
                }
                action(PostedReturnShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Return Shipments";
                }
                action(PostedInvtPutaways)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Invt. Put-aways';
                    Image = PostedPutAway;
                    RunObject = Page "Posted Invt. Put-away List";
                }
                action(PostedTransferReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Transfer Receipts';
                    Image = PostedReceipt;
                    RunObject = Page "Posted Transfer Receipts";
                }
                action(PostedPurchaseReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    Image = PostedReceipt;
                    RunObject = Page "Posted Purchase Receipts";
                }
                action(PostedReturnReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
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
                action(TransferOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'T&ransfer Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Transfer Order";
                    RunPageMode = Create;
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
                action(PurchaseOrder)
                {
                    ApplicationArea = Basic;
                    Caption = '&Purchase Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Purchase Order";
                    RunPageMode = Create;
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const("Vehicles Trade"));
                }
            }
            group(Related)
            {
                Caption = 'Related';
                action(InventoryPick)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory Pi&ck';
                    Image = InventoryPick;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Inventory Pick";
                    RunPageMode = Create;
                }
                action(InventoryPutaway)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory P&ut-away';
                    Image = Warehouse;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Inventory Put-away";
                    RunPageMode = Create;
                }
            }
            group(Tasks)
            {
                Caption = 'Tasks';
                action(EditItemReclassificationJournal)
                {
                    ApplicationArea = Basic;
                    Caption = 'Edit Item Reclassification &Journal';
                    Image = Journal;
                    RunObject = Page "Item Reclass. Journal";
                }
            }
            group(History)
            {
                Caption = 'History';
                action(ItemTracing)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracing';
                    Image = ItemTracing;
                    RunObject = Page "Item Tracing";
                }
            }
        }
    }
}

