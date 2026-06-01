Page 25006505 "Veh. Salesperson Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Vehicle Sales Cue";

    layout
    {
        area(content)
        {
            cuegroup(ForRelease)
            {
                Caption = 'For Release';
                field(SalesQuotesOpen; Rec."Sales Quotes - Open")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Quotes";
                }
                field(SalesOrdersOpen; Rec."Sales Orders - Open")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Order List";
                }

                actions
                {
                    action(NewSalesQuote)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Sales Quote';
                        Image = Quote;
                        RunObject = Page "Sales Quote";
                        RunPageMode = Create;
                        RunPageView = sorting("Document Profile")
                                      where("Document Profile" = const("Vehicles Trade"));
                    }
                    action(NewSalesOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Sales Order';
                        RunObject = Page "Sales Order";
                        RunPageMode = Create;
                        RunPageView = sorting("Document Profile")
                                      where("Document Profile" = const("Vehicles Trade"));
                    }
                }
            }
            cuegroup(SalesOrdersReleasedNotShipped)
            {
                Caption = 'Sales Orders Released Not Shipped';
                field(ReadytoShip; Rec."Ready to Ship")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Order List";
                }
                field(PartiallyShipped; Rec."Partially Shipped")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Order List";
                }
                field(Delayed; Rec.Delayed)
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Order List";
                }

                actions
                {
                    action(Navigate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Navigate';
                        Image = Navigate;
                        RunObject = Page Navigate;
                    }
                }
            }
            cuegroup(Returns)
            {
                Caption = 'Returns';
                field(SalesReturnOrdersAll; Rec."Sales Return Orders - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Return Order List";
                }
                field(SalesCreditMemosAll; Rec."Sales Credit Memos - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Credit Memos";
                }

                actions
                {
                    action(NewSalesReturnOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Sales Return Order';
                        RunObject = Page "Sales Return Order";
                        RunPageMode = Create;
                        RunPageView = sorting("Document Profile")
                                      where("Document Profile" = const("Vehicles Trade"));
                    }
                    action(NewSalesCreditMemo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Sales Credit Memo';
                        RunObject = Page "Sales Credit Memo";
                        RunPageMode = Create;
                        RunPageView = sorting("Document Profile")
                                      where("Document Profile" = const("Vehicles Trade"));
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate - 1);
        Rec.SetFilter("Date Filter2", '>=%1', WorkDate);
    end;
}

