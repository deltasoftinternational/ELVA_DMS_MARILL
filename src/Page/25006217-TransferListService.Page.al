Page 25006217 "Transfer List (Service)"
{
    ApplicationArea = Basic;
    Caption = 'Transfer List (Service)';
    CardPageID = "Transfer Order";
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Header";
    SourceTableView = sorting("Document Profile")
                      where("Document Profile" = const(Service));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StatusStyleExpression;
                }
                field(TransferfromCode; Rec."Transfer-from Code")
                {
                    ApplicationArea = Basic;
                }
                field(TransfertoCode; Rec."Transfer-to Code")
                {
                    ApplicationArea = Basic;
                }
                field(InTransitCode; Rec."In-Transit Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(1);
                    end;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(2);
                    end;
                }
                field(AssignedUserID; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic;
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShipmentMethodCode; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShippingAgentCode; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShippingAdvice; Rec."Shipping Advice")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ReceiptDate; Rec."Receipt Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DocumentProfile; Rec."Document Profile")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceNo; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer-to Customer No."; Rec."Transfer-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer-to Customer Name"; Rec."Transfer-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer-to Vehicle Serial No."; Rec."Transfer-to Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer-to Vehicle Make Code"; Rec."Transfer-to Vehicle Make Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer-to Vehicle Model Code"; Rec."Transfer-to Vehicle Model Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer-to Vehicle VIN"; Rec."Transfer-to Vehicle VIN")
                {
                    ApplicationArea = Basic;
                }

            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Order")
            {
                Caption = 'O&rder';
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Transfer Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Inventory Comment Sheet";
                    RunPageLink = "Document Type" = const("Transfer Order"),
                                  "No." = field("No.");
                }
                action(Shipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'S&hipments';
                    Image = Shipment;
                    RunObject = Page "Posted Transfer Shipments";
                    RunPageLink = "Transfer Order No." = field("No.");
                }
                action(Receipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&ceipts';
                    Image = PostedReceipts;
                    RunObject = Page "Posted Transfer Receipts";
                    RunPageLink = "Transfer Order No." = field("No.");
                }
                action(WhseShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Shi&pments';
                    Image = Shipment;
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type" = const(5741),
                                  "Source Subtype" = const(0),
                                  "Source No." = field("No.");
                    RunPageView = sorting("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action(WhseReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = '&Whse. Receipts';
                    Image = Receipt;
                    RunObject = Page "Whse. Receipt Lines";
                    RunPageLink = "Source Type" = const(5741),
                                  "Source Subtype" = const(1),
                                  "Source No." = field("No.");
                    RunPageView = sorting("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action(InvtPutawayPickLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'In&vt. Put-away/Pick Lines';
                    Image = PickLines;
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document" = filter("Inbound Transfer" | "Outbound Transfer"),
                                  "Source No." = field("No.");
                    RunPageView = sorting("Source Document", "Source No.", "Location Code");
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                action(CreateWhseReceipt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create &Whse. Receipt';
                    Image = Receipt;

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetSourceDocInbound.CreateFromInbndTransferOrder(Rec);
                    end;
                }
                action(CreateWhseShipment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Whse. S&hipment';
                    Image = Shipment;

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                    end;
                }
                action(CreateInventoryPutawayPick)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Inventor&y Put-away/Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;

                    trigger OnAction()
                    begin
                        Rec.CreateInvtPutAwayPick;
                    end;
                }
                action(GetBinContent)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Bin Content';
                    Ellipsis = true;
                    Image = GetBinContent;

                    trigger OnAction()
                    var
                        BinContent: Record "Bin Content";
                        GetBinContent: Report "Whse. Get Bin Content";
                    begin
                        BinContent.SetRange("Location Code", Rec."Transfer-from Code");
                        GetBinContent.SetTableview(BinContent);
                        GetBinContent.InitializeTransferHeader(Rec);
                        GetBinContent.RunModal;
                    end;
                }
                action(Release)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Release Transfer Document";
                    ShortCutKey = 'Ctrl+F9';
                }
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reo&pen';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseTransferDoc: Codeunit "Release Transfer Document";
                    begin
                        ReleaseTransferDoc.Reopen(Rec);
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'P&osting';
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "TransferOrder-Post (Yes/No)";
                    ShortCutKey = 'F9';
                }
                action(PostandPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "TransferOrder-Post + Print";
                    ShortCutKey = 'Shift+F9';
                }
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.PrintTransferHeader(Rec);
                end;
            }
        }
        area(reporting)
        {
            action(InventoryInboundTransfer)
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - Inbound Transfer';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Inbound Transfer";
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        StatusStyleExpression := GetReservationColor;
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        StatusStyleExpression: Text[30];

    procedure GetReservationColor(): Text[20]
    var
        ResEntry: Record "Reservation Entry";
        TransferLine: Record "Transfer Line";
        ResEntryNegative: Record "Reservation Entry";
    begin
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", Rec."No.");
        TransferLine.SetRange("Derived From Line No.", 0);
        if TransferLine.FindFirst then
            repeat
                /*if TransferLine.Quantity > TransferLine."Quantity Shipped" then begin
                    ResEntryNegative.Reset;
                    ResEntryNegative.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                    ResEntryNegative.SetRange("Source ID", TransferLine."Document No.");
                    ResEntryNegative.SetRange("Source Ref. No.", TransferLine."Line No.");
                    ResEntryNegative.SetRange("Source Type", Database::"Transfer Line");
                    ResEntryNegative.SetRange("Source Subtype", 0);
                    ResEntryNegative.SetRange("Source Prod. Order Line", TransferLine."Derived From Line No.");
                    ResEntryNegative.SetRange("Reservation Status", ResEntryNegative."reservation status"::Reservation);
                    if ResEntryNegative.IsEmpty then
                        exit('Unfavorable');
                    
                end*/
                TransferLine.CalcFields("Reserved Quantity Outbnd.");
                if TransferLine.Quantity > (TransferLine."Quantity Shipped" + TransferLine."Reserved Quantity Outbnd.") then begin
                    exit('Unfavorable');
                end
            until TransferLine.Next = 0;

        FilterTransferRes(ResEntry);

        if ResEntry.IsEmpty then
            exit('None');

        ResEntry.SetRange("Source Type", 246);
        if ResEntry.FindFirst then
            exit('StrongAccent');

        ResEntry.SetFilter("Source Type", '%1|%2', 39, 5741);
        if ResEntry.FindFirst then
            exit('Ambiguous');

        ResEntry.SetRange("Source Type", 32);
        if ResEntry.FindFirst then
            exit('Favorable');
    end;


    procedure FilterTransferRes(var FilteredResEntry: Record "Reservation Entry")
    var
        ResEntryNegative: Record "Reservation Entry";
        ResEntryTransferOutg: Record "Reservation Entry";
    begin
        //receivment into transfer
        ResEntryNegative.Reset;
        ResEntryNegative.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryNegative.SetRange("Source ID", Rec."No.");
        ResEntryNegative.SetRange("Source Type", Database::"Transfer Line");
        ResEntryNegative.SetRange("Source Subtype", 0);
        //ResEntryNegative.SetRange("Source Prod. Order Line", "Derived From Line No.");
        ResEntryNegative.SetRange("Reservation Status", ResEntryNegative."reservation status"::Reservation);
        if ResEntryNegative.FindFirst then
            repeat
                FilteredResEntry.Get(ResEntryNegative."Entry No.", true);
                FilteredResEntry.Mark(true);
            until ResEntryNegative.Next = 0;
        FilteredResEntry.MarkedOnly(true)
    end;
}

