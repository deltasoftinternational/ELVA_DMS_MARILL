Page 25006192 "Posted Transf. Rcpts (Serv.)"
{
    ApplicationArea = Basic;
    Caption = 'Posted Transf. Rcpts (Serv.)';
    CardPageID = "Posted Transfer Receipt";
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Receipt Header";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(TransferfromCode; Rec."Transfer-from Code")
                {
                    ApplicationArea = Basic;
                }
                field(TransfertoCode; Rec."Transfer-to Code")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(ReceiptDate; Rec."Receipt Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
            group(Receipt)
            {
                Caption = '&Receipt';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Transfer Receipt Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Inventory Comment Sheet";
                    RunPageLink = "Document Type" = const("Posted Transfer Receipt"),
                                  "No." = field("No.");
                }
            }
        }
        area(processing)
        {
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(TransRcptHeader);
                    TransRcptHeader.PrintRecords(true);
                end;
            }
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
    }

    var
        TransRcptHeader: Record "Transfer Receipt Header";
}

