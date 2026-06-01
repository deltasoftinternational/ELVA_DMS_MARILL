Page 25006638 "Rent Order List"
{
    ApplicationArea = Basic;
    Caption = 'Rent Orders';
    CardPageID = "Rent Order";
    Editable = false;
    PageType = List;
    SourceTable = "Rent Header";
    SourceTableView = where("Document Type" = const(Order),
                            Closed = const(false));
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the rent order, according to the specified number series.';
                }
                field("Rent Type"; Rec."Rent Type")
                {
                    ToolTip = 'Specifies the type of rent in the document. It can be with set end date or with open end.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the rent.';
                    Visible = false;
                }
                field("Deal Type"; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the deal type that describes the rent document.';
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Status field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from where inventory of rent assets to the customer on the rent document are to be shipped by default.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the salesperson who is assigned to the rent document.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'Specifies the date when the order was created.';
                    ApplicationArea = All;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ToolTip = 'Specifies the rent start date.';
                    ApplicationArea = All;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who will rent.';
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer who will rent.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contract number to which the rent document is related to.';
                }
                field(ShiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Ship-to Code of customer address where to deliver rent assets.';
                }
                field(ShiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Ship-to name of customer address where to deliver rent assets.';
                }
                field(ShiptoName2; Rec."Ship-to Name 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Ship-to name 2 of customer address where to deliver rent assets.';
                }
                field(ShiptoAddress; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Ship-to address for customer where to deliver rent assets.';
                }
                field(ShiptoAddress2; Rec."Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Ship-to address 2 for customer where to deliver rent assets.';
                }
                field(ShiptoCity; Rec."Ship-to City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Ship-to city for customer where to deliver rent assets.';
                }
                field(ShiptoContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contact for customer where to deliver rent assets.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the posting of the rent document will be recorded.';
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies description that should be used for posting.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the document is open or has been released.';
                }
                field(SelltoContactNo; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact that the rent document will be sent to.';
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ToolTip = 'Specifies the name of the person to contact at the customer.';
                    ApplicationArea = All;
                }
                field("Next Review Date"; Rec."Next Review Date")
                {
                    ToolTip = 'Specifies the Next Review Date of rent order.';
                    ApplicationArea = All;
                }
            }
        }

        area(factboxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(25006618),
                              "No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
    }
}

