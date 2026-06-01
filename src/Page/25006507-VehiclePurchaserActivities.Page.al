Page 25006507 "Vehicle Purchaser Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Vehicle Purchase Cue";

    layout
    {
        area(content)
        {
            cuegroup(PrearrivalFollowuponPurchaseOrders)
            {
                Caption = 'Pre-arrival Follow-up on Purchase Orders';
                field(ToSendorConfirm; Rec."To Send or Confirm")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                }
                field(UpcomingOrders; Rec."Upcoming Orders")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                }

                actions
                {
                    action(NewPurchaseQuote)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Purchase Quote';
                        RunObject = Page "Purchase Quote";
                        RunPageMode = Create;
                        RunPageView = sorting("Document Profile")
                                      where("Document Profile" = const("Vehicles Trade"));
                    }
                    action(NewPurchaseOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Purchase Order';
                        RunObject = Page "Purchase Order";
                        RunPageMode = Create;
                        RunPageView = sorting("Document Profile")
                                      where("Document Profile" = const("Vehicles Trade"));
                    }
                    action(EditPurchaseJournal)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Purchase Journal';
                        RunObject = Page "Purchase Journal";
                    }
                }
            }
            cuegroup(PostArrivalFollowup)
            {
                Caption = 'Post Arrival Follow-up';
                field(OutstandingPurchaseOrders; Rec."Outstanding Purchase Orders")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                }
                field(PurchaseReturnOrdersAll; Rec."Purchase Return Orders - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Return Order List";
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
                    action(NewPurchaseReturnOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Purchase Return Order';
                        RunObject = Page "Purchase Return Order";
                        RunPageMode = Create;
                        RunPageView = sorting("Document Profile")
                                      where("Document Profile" = const("Vehicles Trade"));
                    }
                }
            }
            cuegroup(PurchaseOrdersAuthorizeforPayment)
            {
                Caption = 'Purchase Orders - Authorize for Payment';
                field(NotInvoiced; Rec."Not Invoiced")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                }
                field(PartiallyInvoiced; Rec."Partially Invoiced")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
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

        Rec.SetFilter("Date Filter", '>=%1', WorkDate);
    end;
}

