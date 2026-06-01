Page 25006093 "Vehicle Service Technician RC"
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
            part("Service Technician Activities"; "Service Technician Activities")
            {
                ApplicationArea = All;
            }
            part("Easy Clocking Part"; "Easy Clocking Part")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            //part("Service Chart"; "Service Chart")
            //{
            //    ApplicationArea = All;
            //}
        }
    }

    actions
    {
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
            action("<Action57>")
            {
                ApplicationArea = Basic;
                Caption = 'Vehicles';
                Image = ItemLines;
                RunObject = Page "Vehicle List";
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
                    RunObject = Page "Service List Archive";
                    RunPageView = where("Document Type" = const(Quote));
                }
            }
        }
        area(processing)
        {
            group(TimeRegistration)
            {
                Caption = 'Time Registration';
                action(EasyClocking)
                {
                    ApplicationArea = Basic;
                    Caption = 'Easy Clocking';
                    Image = Timesheet;
                    RunObject = Page "Easy Clocking";
                }
            }
        }
    }
}

