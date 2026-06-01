Page 25006615 "Closed Rent Order"
{
    Caption = 'Closed Rent Order';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Rent Header";
    SourceTableView = where("Document Type" = const(Order),
                            Closed = const(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoContactNo; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoAddress; Rec."Sell-to Address")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoAddress2; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCity; Rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoContact; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(DepositAmount; Rec."Deposit Amount")
                {
                    ApplicationArea = Basic;
                }
                group("Rent Description")
                {
                    Caption = 'Rent Description';
                    field(RentDescription; RentDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Standard;
                        MultiLine = true;
                        ShowCaption = false;

                        trigger OnValidate()
                        begin
                            Rec.SetRentDescription(RentDescription);
                        end;
                    }
                }
            }
            part(Control25006051; "Closed Rent Order Subp.")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
            }
            part(Control25006052; "Closed Rent Sales Order Subp.")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
            }
            group(Invoicing)
            {
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(DimensionSetID; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoName; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoAddress; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoAddress2; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoPostCode; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCity; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoContact; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(BankAccountNo; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentQuoteNo; Rec."Rent Quote No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentDiscount; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Shipping)
            {
                field(ShiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoAddress; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoAddress2; Rec."Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoCity; Rec."Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShipmentMethodCode; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingAgentCode; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Foreign Trade")
            {
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
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
                              "No." = FIELD("No.");
            }
            part(Control25006073; "Customer Details FactBox")
            {
                ApplicationArea = Advanced;
                SubPageLink = "No." = field("Sell-to Customer No.");
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
        area(navigation)
        {
            action(SalesInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoices';
                Image = SalesInvoice;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Sales List";
                RunPageLink = "Applies-to ID" = field("No."),
                              "Document Type" = const(Invoice),
                              "Document Profile" = const(Rent);
            }
            action(CrMemos)
            {
                ApplicationArea = Basic;
                Caption = 'Cr. Memos';
                Image = CreditMemo;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Sales List";
                RunPageLink = "Applies-to ID" = field("No."),
                              "Document Type" = const("Credit Memo"),
                              "Document Profile" = const(Rent);
            }
            action(TransferOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Transfer Orders';
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Rent Transfer List";
                RunPageLink = "Rent Order No." = field("Posting No.");
            }
            action(PostedTransferOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Posted Transfer Orders';
                Image = PostedShipment;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Posted Rent Transfer List";
                RunPageLink = "Rent Order No." = field("No.");
            }
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;

                trigger OnAction()
                begin
                    //ShowDimensions;
                end;
            }
            action(Reopen)
            {
                ApplicationArea = Basic;
                Caption = 'Reopen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Closed := false;
                    Rec.Modify;
                end;
            }
        }
    }
    var
        RentDescription: Text;

    trigger OnAfterGetRecord()
    begin
        RentDescription := Rec.GetRentDescription;
    end;
}

