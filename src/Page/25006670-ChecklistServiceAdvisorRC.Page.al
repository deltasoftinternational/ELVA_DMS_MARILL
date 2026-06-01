Page 25006670 "Checklist Service Advisor RC"
{
    // 14/08/2018 EB.P30 GH
    //   Added:
    //     "Power BI Report Spinner Part"
    // 
    // 13/08/2018 EB.P30 GH
    //   Added action group:
    //     "Archived documents"
    //   Added actions:
    //     "Archieved VHC"
    //     "Archieved Checklists"
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added Page Action:
    //     Page Contract List EDMS
    // 
    // 25.03.2014 Elva Baltic P18 #RX021 MMG7.00
    //   Added New Page Action "Archieved Service Quotes"
    // 
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   *Changed LVI captions
    // 
    // 17.03.2014 Elva Baltic P8 #S0002 MMG7.00
    //   * Added R250025

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1101904011; "Checklist Serv. Adv. Activit.")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control2; "Service Chart")
                {
                    Caption = 'Service Chart';
                }
                part(Control1000000003; "Power BI Embedded Report Part")
                {
                    ApplicationArea = Basic, Suite;
                }
                part(Control1905989608; "My Items")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(EndOfDayReport)
            {
                ApplicationArea = Basic;
                Caption = 'End of Day Report';
                Image = "Report";
                //RunObject = Report UnknownReport25006957; //FIXME
            }
            action(JobsheetWIP)
            {
                ApplicationArea = Basic;
                Caption = 'Jobsheets - Work in Progress';
                Image = "Report";
                //RunObject = Report UnknownReport25006958; //FIXME
            }
            action(SummaryReport)
            {
                ApplicationArea = Basic;
                Caption = 'Summary Report';
                Image = "Report";
                //RunObject = Report UnknownReport25006962; //FIXME
            }
        }
        area(embedding)
        {
            action(Orders)
            {
                ApplicationArea = Basic;
                Caption = 'Orders';
                Image = Document;
                RunObject = Page "Service Orders EDMS";
            }
            action(VehicleHealthChecks)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Health Checks';
                RunObject = Page "Vehicle Health Checks";
            }
            action("<Action1101904016>")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List (Service)";
                Visible = false;
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action("<Action57>")
            {
                ApplicationArea = Basic;
                Caption = 'Vehicles';
                Image = ItemLines;
                RunObject = Page "Vehicle List";
            }
            action(Vendors)
            {
                ApplicationArea = Basic;
                Caption = 'Vendors';
                Image = Vendors;
                RunObject = Page "Vendor List";
            }
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                RunObject = Page "Item List";
            }
            action(TransferOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Orders';
                RunObject = Page "Transfer Orders";
            }
            action(Checklists)
            {
                ApplicationArea = Basic;
                Caption = 'Checklists';
                RunObject = Page "Process Checklist List";
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
                action(Models)
                {
                    ApplicationArea = Basic;
                    Caption = 'Models';
                    Image = ListPage;
                    RunObject = Page "Model List";
                }
                action("<Action58>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "Item List";
                }
                action("<Action1101904002>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Labors';
                    Image = Job;
                    RunObject = Page "Service Labor List";
                }
                action("<Action1101904003>")
                {
                    ApplicationArea = Basic;
                    Caption = 'External Services';
                    Image = ServiceItem;
                    RunObject = Page "External Service List";
                }
                action("<Action1101904004>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Packages';
                    Image = ServiceItemGroup;
                    RunObject = Page "Service Package List";
                }
            }
            group(ActionGroup42)
            {
                Caption = 'Checklists';
                action(VehicleInspections)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Inspections';
                    Image = Confirm;
                    RunObject = Page "Process Checklist List";
                    RunPageView = where(Type = const("Vehicle Inspection"));
                }
                action(Action43)
                {
                    ApplicationArea = Basic;
                    Caption = 'Checklists';
                    RunObject = Page "Process Checklist List";
                }
                action(QuestionaryTemplates)
                {
                    ApplicationArea = Basic;
                    Caption = 'Questionary Templates';
                    RunObject = Page "Questionary Templates";
                }
                action(QuestionarySubjectGroup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Questionary Subject Group';
                    RunObject = Page "Questionary Subject Groups";
                }
            }
            group(PostedDocuments)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("<Action61>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedPayment;
                    RunObject = Page "Posted Sales Invoices (Serv.)";
                }
                action(PostedSalesShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Shipments';
                    RunObject = Page "Posted Sales Shipments";
                }
                action("<Action160>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Service Return Orders';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Service Ret.Orders EDMS";
                }
                action("<Action62>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedCreditMemo;
                    RunObject = Page "Posted Sales Cr.Memos (Serv.)";
                }
                action("<Action137>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Transfer Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Transf. Shpmnts (Serv.)";
                }
                action("<Action3>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Transfer Receipts';
                    Image = PostedReceipts;
                    RunObject = Page "Posted Transf. Rcpts (Serv.)";
                }
                action(PostedPurchaseReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action(PostedPurchaseInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action(PostedReturnShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                }
                action(PostedPurchaseCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
            }
            group(ArchivedDocuments)
            {
                Caption = 'Archived Documents';
                action(ArchivedServiceQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archived Service Quotes';
                    Image = PostedReceipts;
                    RunObject = Page "Service List Archive";
                    RunPageView = where("Document Type" = const(Quote));
                }
                action(ArchivedJobsheets)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archived Jobsheets';
                    Image = PostedReceipts;
                    RunObject = Page "Service List Archive";
                    RunPageView = where("Document Type" = const(Order));
                }
                action(ArchivedVHC)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archived VHC';
                    Image = PostedReceipts;
                    RunObject = Page "Service List Archive";
                    //RunPageView = where("Document Type"=const("4")); //FIXME
                }
                action(ArchivedChecklists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archived Checklists';
                    Image = PostedReceipts;
                    RunObject = Page "Checklist List Arch.";
                }
                action(ArchivedPurchaseOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archived Purchase Orders';
                    Image = PostedReceipts;
                    RunObject = Page "Purchase Order Archives";
                }
            }
        }
        area(processing)
        {
            group(New)
            {
                Caption = 'New';
                action(Quote)
                {
                    ApplicationArea = Basic;
                    Caption = 'Q&uote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //RunObject = Page UnknownPage25006978; //FIXME
                    RunPageMode = Create;
                }
                action("Order")
                {
                    ApplicationArea = Basic;
                    Caption = '&Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //RunObject = Page UnknownPage25006973; //FIXME
                    RunPageMode = Create;
                }
            }
            group(Tasks)
            {
                Caption = 'Tasks';
                action("<Action29>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule';
                    Image = Planning;
                    Promoted = true;
                    RunObject = Page "Service Schedule";
                }
                action("<TCard Planner>")
                {
                    ApplicationArea = Basic;
                    Caption = 'TCard Planner';
                    Image = ResourcePlanning;
                    RunObject = Page "TCard Planner";
                }
            }
            group(Procurement)
            {
                Caption = 'Procurement';
                group(Purchase)
                {
                    Caption = 'Purchase';
                    Image = Purchasing;
                    action(Purch1)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase Order';
                        Image = "order";
                        //RunObject = Page UnknownPage25006993; //FIXME
                    }
                    action(Purch2)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase Invoice';
                        Image = "order";
                        RunObject = Page "Purchase Invoices";
                    }
                    action(Purch3)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase Return Order';
                        Image = "order";
                        RunObject = Page "Posted Rent Invoices";
                    }
                    action(PurchaseCrMemos)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase Cr.Memos';
                        Image = "order";
                        RunObject = Page "Purchase Credit Memos";
                    }
                }
                action(SmartCodeLookup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Smart Code Lookup';
                    Image = CreateSKU;
                    RunObject = Codeunit "Smart Code Mgt";
                }
            }
            group(Additional)
            {
                Caption = 'Additional';
                action(EasyClocking)
                {
                    ApplicationArea = Basic;
                    Caption = 'Easy Clocking';
                    Image = Timesheet;
                    RunObject = Page "Easy Clocking";
                }
                group(ServicePlans)
                {
                    Caption = 'Service Plans';
                    Image = Setup;
                    action(ServicePlanTemplates)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Plan Templates';
                        Image = Template;
                        RunObject = Page "Service Plan Templates";
                    }
                    action(GenerateJobsheets)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Generate Jobsheets';
                        Image = CreateDocuments;
                        //RunObject = Report UnknownReport25006959; //FIXME
                    }
                    action(ServicePlanWorksheet)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Plan Worksheet';
                        Image = PlanningWorksheet;
                        //RunObject = Page UnknownPage25006680; //FIXME
                    }
                }
                group(Setup)
                {
                    Caption = 'Setup';
                    Image = setup;
                    action("Service Hours")
                    {
                        ApplicationArea = Basic;
                        Image = ServiceHours;
                        RunObject = Page "Service Hours EDMS";
                    }
                    action("Service Holidays")
                    {
                        ApplicationArea = Basic;
                        Image = Holiday;
                        //RunObject = Page UnknownPage25006998; //FIXME
                    }
                }
            }
        }
    }

    var
        ServiceChartDefined: Boolean;
}

