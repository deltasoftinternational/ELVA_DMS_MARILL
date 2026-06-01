Page 25006057 "Service Advisor Role Center"
{
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
            part(Control1101904011; "Service Advisor Activities")
            {
                ApplicationArea = All;
            }
            part(Control1907692008; "My Customers")
            {
                ApplicationArea = All;
            }
            part(Control14; "Team Member Activities")
            {
                ApplicationArea = All;
            }
            part(Control25006005; "Service Chart")
            {
                ApplicationArea = All;
            }
            part(Control1905989608; "My Items")
            {
                ApplicationArea = All;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = All;
            }
            part(Control25006007; "Report Inbox Part")
            {
                ApplicationArea = All;
            }
            part(Control13; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
            }

        }
    }

    actions
    {
        area(reporting)
        {
            action(ActTimebyPostServOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Act. Time by Post.Serv. Orders';
                Image = "Report";
                RunObject = Report "Act. Time by Post.Serv. Orders";
            }
            action(ResourceServiceTimes)
            {
                ApplicationArea = Basic;
                Caption = 'Resource Service Times';
                Image = "Report";
                RunObject = Report "Resource Service Times";
            }
            action(FinishedAllocationsbyTypes)
            {
                ApplicationArea = Basic;
                Caption = 'Finished Allocations by Types';
                Image = "Report";
                RunObject = Report "Finished Allocations by Types";
            }
            action(ResourceUsage)
            {
                ApplicationArea = Basic;
                Caption = 'Resource Usage';
                Image = "Report";
                RunObject = Report "Resource Usage EDMS";
            }
            action(ServiceLedgerEntryOverview)
            {
                ApplicationArea = Basic;
                Caption = 'Service Ledger Entry Overview';
                Image = "Report";
                RunObject = Report "Service Ledger Entry Overview";
            }
            action(ServiceOrderOverviewEDMS)
            {
                ApplicationArea = Basic;
                Caption = 'Service Order Overview EDMS';
                Image = "Report";
                RunObject = Report "Service Order Overview EDMS";
            }
            action(ServiceDocuments)
            {
                ApplicationArea = Basic;
                Caption = 'Service Documents';
                Image = "Report";
                RunObject = Report "Service Documents";
            }
            //action(ReportRecallServicesTotal)
            //{
            //    ApplicationArea = Basic;
            //    Caption = 'Report Recall Services (Total)';
            //    Image = "Report";
            //    RunObject = Report "Suggest Sales Price From Prch.";
            //}
        }
        area(embedding)
        {
            action(ServiceQuotes)
            {
                ApplicationArea = Basic;
                Caption = 'Service Quotes';
                Image = Quote;
                RunObject = Page "Service Quotes EDMS";
            }
            action(ServiceOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Service Orders';
                Image = Document;
                RunObject = Page "Service Orders EDMS";
            }
            action("<Action1101904016>")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List (Service)";
            }
            action("<Action15>")
            {
                ApplicationArea = Basic;
                Caption = 'Service Return Orders';
                Image = ReturnOrder;
                RunObject = Page "Service Return Orders EDMS";
            }
            action("<Action1101914016>")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Cr.Memos';
                Image = CreditMemo;
                RunObject = Page "Sales Credit Memos (Service)";
            }
            action("<Action55>")
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
            action("<Action57>")
            {
                ApplicationArea = Basic;
                Caption = 'Vehicles';
                Image = ItemLines;
                RunObject = Page "Vehicle List";
            }
            action("<Action1101904005>")
            {
                ApplicationArea = Basic;
                Caption = 'Service Transfer Orders';
                Image = TransferOrder;
                RunObject = Page "Transfer List (Service)";
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
            action(Contracts)
            {
                ApplicationArea = Basic;
                Caption = 'Contracts';
                RunObject = Page "Contract List EDMS";
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
                action("<Action1101904010>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonstock Items';
                    Image = Item;
                    RunObject = Page "Catalog Item List";
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
                action(Tires)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tires';
                    Image = Item;
                    RunObject = Page Tires;
                }
            }
            group(PostedDocuments)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("<Action60>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Service Orders';
                    Image = PostedServiceOrder;
                    RunObject = Page "Posted Service Orders EDMS";
                }
                action("<Action61>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedPayment;
                    RunObject = Page "Posted Sales Invoices (Serv.)";
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
                action(ArchievedServiceQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archieved Service Quotes';
                    Image = PostedReceipts;
                    RunObject = Page "Service List Archive EDMS";
                    RunPageView = where("Document Type" = const(Quote));
                }
                action(ArchievedServiceorders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archieved Service Orders';
                    Image = PostedReceipts;
                    RunObject = Page "Service List Archive EDMS";
                    RunPageView = where("Document Type" = const("Order"));
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                Image = Setup;

                group(General)
                {
                    Caption = 'General';

                    action(ServiceSetup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Setup';
                        RunObject = Page "Service Mgt. Setup EDMS";
                    }
                    action(SkillCodes)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Skill Codes';
                        RunObject = Page "Skill Codes EDMS";
                    }

                    action(ServiceHours)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Hours';
                        RunObject = Page "Service Hours EDMS";
                    }
                    action(TireMgtSetup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tire Management Setup';
                        RunObject = Page "Tire Management Setup";
                    }
                    action(ServiceWIPSetup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service WIP Setup';
                        RunObject = Page "Service WIP Setup";
                    }
                    action(ServJrnlTempaltes)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Journal Templates';
                        RunObject = Page "Service Journal Templates";
                    }
                    action(ExtServiceJournalTempl)
                    {
                        ApplicationArea = Basic;
                        Caption = 'External Service Journal Templates';
                        RunObject = Page "Ext. Service Journal Templates";
                    }
                    action(EasyClockingMenuItems)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Easy Clocking Menu Items';
                        RunObject = Page "Easy Clocking Menu Items";
                    }
                    action(ThirdPartiesServices)
                    {
                        ApplicationArea = Basic;
                        Caption = '3rd Parties Services';
                        RunObject = Page "3rd Parties Services";
                    }
                    action(ServiceChartList)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Chart List';
                        RunObject = Page "Service Chart List";
                    }
                    action(WarrantySetup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Warranty Setup';
                        RunObject = Page "Warranty Setup";
                    }
                    action(WarrantyJournalTemplates)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Warranty Journal Templates';
                        RunObject = Page "Warranty Journal Templates";
                    }
                    action(ServWorkStatSetupEDMS)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Work Status Setup';
                        RunObject = Page "Service Work Status Setup EDMS";
                    }
                    action(ServDocumentStatSetupEDMS)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document Status Codes';
                        RunObject = Page "Document Status List";
                    }

                    action(ServicePrices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Prices';
                        RunObject = Page "Service Prices";
                    }
                }
                group(PlanningSetup)
                {
                    Caption = 'Planning';
                    action(ServiceScheduleSetup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Schedule Setup';
                        RunObject = Page "Service Schedule Setup";
                    }
                    action(ResourceCalendarChanges)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Resource Calendar Changes';
                        RunObject = Page "Resource Calendar Changes";
                    }
                    action(ScheduleCellConfig)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Schedule Cell Config';
                        RunObject = Page "Schedule Cell Config.";
                    }
                    action(ScheduleColors)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Schedule Colors';
                        RunObject = Page "Schedule Colors";
                    }
                    action(ServiceHoursEDMS)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Hours';
                        RunObject = Page "Service Hours EDMS";
                    }
                    action(ServStandardEvents)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Standard Events';
                        RunObject = Page "Serv. Standard Events";
                    }
                    action(ScheduleResourceGroups)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Schedule Resource Groups';
                        RunObject = Page "Schedule Resource Groups";
                    }
                    action(ScheduleResourceLinks)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Schedule Resource Links';
                        RunObject = Page "Schedule Resource Links";
                    }
                    action(ScheduleViews)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Schedule Views';
                        RunObject = Page "Schedule Views";
                    }
                    action(ServWorkplaces)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Workplaces';
                        RunObject = Page "Serv. Workplaces";
                    }
                }

            }
            group(reports)
            {
                Caption = 'Reports';
                Image = RegisteredDocs;
                action(R1)
                {
                    ApplicationArea = All;
                    Caption = 'Resource Service Times';
                    Image = Report;
                    RunObject = Report "Resource Service Times";
                }
                action(R2)
                {
                    ApplicationArea = All;
                    Caption = 'Act. Time by Post.Serv. Orders';
                    Image = Report;
                    RunObject = Report "Act. Time by Post.Serv. Orders";
                }
                action(R3)
                {
                    ApplicationArea = All;
                    Caption = 'Finished Allocations by Types';
                    Image = Report;
                    RunObject = Report "Finished Allocations by Types";
                }
                action(R4)
                {
                    ApplicationArea = All;
                    Caption = 'Resource Usage EDMS';
                    Image = Report;
                    RunObject = Report "Resource Usage EDMS";
                }
                action(R5)
                {
                    ApplicationArea = All;
                    Caption = 'Service Documents';
                    Image = Report;
                    RunObject = Report "Service Documents";
                }
                action(R6)
                {
                    ApplicationArea = All;
                    Caption = 'Service Ledger Entry Overview';
                    Image = Report;
                    RunObject = Report "Service Ledger Entry Overview";
                }
                action(R7)
                {
                    ApplicationArea = All;
                    Caption = 'Service Order Overview EDMS';
                    Image = Report;
                    RunObject = Report "Service Order Overview EDMS";
                }
                action(R8)
                {
                    ApplicationArea = All;
                    Caption = 'Tire Entries';
                    Image = Report;
                    RunObject = Report "Tire Entries";
                }
            }
        }
        area(processing)
        {
            group(ServiceDocument)
            {
                Caption = 'Service Document';
                action(ServiceQuote)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Q&uote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Quote EDMS";
                    RunPageMode = Create;
                }
                action(ServiceOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Order EDMS";
                    RunPageMode = Create;
                }
                action("<Action18>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Transfer Order";
                    RunPageMode = Create;
                    RunPageView = sorting("Document Profile")
                                  where("Document Profile" = const(Service));
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                action(ServiceBookings)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Bookings';
                    Image = Calendar;
                    RunObject = Page "Service Booking Worksheet";
                }
                action("<TCard Planner>")
                {
                    ApplicationArea = Basic;
                    Caption = 'TCard Planner';
                    Image = ResourcePlanning;
                    RunObject = Page "TCard Planner";
                }
                action(Schedule)
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule';
                    Image = Planning;
                    RunObject = Page "Service Schedule";
                }
            }
            group(TimeRegistration)
            {
                Caption = 'Time Registration';
                action(TimeWorksheet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Time Worksheet';
                    Image = PlanningWorksheet;
                    RunObject = Page "Service Time Worksheet";
                }
                action(EasyClocking)
                {
                    ApplicationArea = Basic;
                    Caption = 'Easy Clocking';
                    Image = Timesheet;
                    RunObject = Page "Easy Clocking";
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                action("<Action33>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Packages';
                    Image = Task;
                    RunObject = Page "Service Package List";
                }
                action("Page Service Target")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Target';
                    Image = Forecast;
                    Promoted = true;
                    RunObject = Page "Service Target";
                    RunPageMode = View;
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
                action(ServiceLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger Entries';
                    RunObject = Page "Service Ledger Entries EDMS";
                }
            }
            group("Warranty")
            {
                Caption = 'Warranty';
                action("Warranty Documents")
                {
                    ApplicationArea = All;
                    Caption = 'Warranty Documents';
                    RunObject = page "Warranty Document List";
                }
                action("Warranty Journal")
                {
                    ApplicationArea = All;
                    Caption = 'Warranty Journal';
                    RunObject = page "Warranty Journal";
                }
                action("Warranty Reimbursement")
                {
                    ApplicationArea = All;
                    Caption = 'Warranty Reimbursement';
                    RunObject = page "Warranty Reimbursement Entries";
                }
            }
            group(PeriodicActivities)
            {
                Caption = 'Periodic Activities';
                action(CreateServDocByPlan)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Service Document by Plan';
                    Image = Navigate;
                    RunObject = Report "Create Service Doc. by Plan";
                }
                action(ServicePlanChange)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Plan Change';
                    Image = Navigate;
                    RunObject = Report "Service Plan Change";
                }
            }
        }
    }
}

