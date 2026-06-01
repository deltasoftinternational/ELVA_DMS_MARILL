Page 25006831 "Spare Parts Whse Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Spare Part Warehouse Cue";

    layout
    {
        area(content)
        {
            cuegroup(OutboundToday)
            {
                Caption = 'Outbound - Today';
                field(ReleasedSalesOrdersToday; Rec."Released Sales Orders - Today")
                {
                    ApplicationArea = Basic;
                    DrillDown = true;
                    DrillDownPageID = "Sales Order List";
                }
                field(PostedSalesShipmentsToday; Rec."Posted Sales Shipments - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Posted Sales Shipments";
                }

                actions
                {
                    action(NewTransferOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Transfer Order';
                        RunObject = Page "Transfer Order";
                        RunPageMode = Create;
                        RunPageView = sorting("Document Profile")
                                      where("Document Profile" = const("Spare Parts Trade"));
                    }
                }
            }
            cuegroup(InboundToday)
            {
                Caption = 'Inbound - Today';
                field(ExpectedPurchOrdersToday; Rec."Expected Purch. Orders - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                }
                field(PostedPurchReceiptsToday; Rec."Posted Purch. Receipts - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Posted Purchase Receipts";
                }

                actions
                {
                    action(NewPurchaseOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Purchase Order';
                        RunObject = Page "Purchase Order";
                        RunPageMode = Create;
                        RunPageView = sorting("Document Profile")
                                      where("Document Profile" = const("Spare Parts Trade"));
                    }
                }
            }
            cuegroup(Internal)
            {
                Caption = 'Internal';
                field(InventoryPicksToday; Rec."Inventory Picks - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Inventory Picks";
                }
                field(InventoryPutawaysToday; Rec."Inventory Put-aways - Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Inventory Put-aways";
                }

                actions
                {
                    action(NewInventoryPick)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Inventory Pick';
                        RunObject = Page "Inventory Pick";
                        RunPageMode = Create;
                    }
                    action(NewInventoryPutaway)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Inventory Put-away';
                        RunObject = Page "Inventory Put-away";
                        RunPageMode = Create;
                    }
                    action(EditItemReclassificationJournal)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Item Reclassification Journal';
                        RunObject = Page "Item Reclass. Journal";
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

        Rec.SetRange("Date Filter", 0D, WorkDate);
        Rec.SetRange("Date Filter2", WorkDate, WorkDate);
    end;

    var
        WhseWMSCue: Record "Warehouse WMS Cue";
        LocationCode: Text[1024];
}

