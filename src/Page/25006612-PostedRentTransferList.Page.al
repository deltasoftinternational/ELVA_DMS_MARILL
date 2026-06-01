Page 25006612 "Posted Rent Transfer List"
{
    ApplicationArea = Basic;
    Caption = 'Posted Rent Transfers';
    CardPageID = "Posted Rent Trans. Order";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Posted Rent Transfer Header";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(PaymentDiscount; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
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
                field(PostingNo; Rec."Posting No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingNoSeries; Rec."Posting No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoName; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoName2; Rec."Bill-to Name 2")
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
                field(BilltoCity; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoContact; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoName2; Rec."Ship-to Name 2")
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
                field(ShiptoCity; Rec."Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName2; Rec."Sell-to Customer Name 2")
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
                field(SelltoCity; Rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoContact; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoPostCode; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCounty; Rec."Bill-to County")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCountryRegionCode; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCounty; Rec."Sell-to County")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCountryRegionCode; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoCounty; Rec."Ship-to County")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerTemplateCode; Rec."Sell-to Customer Template Code")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoContactNo; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(DimensionSetID; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCustomerTemplateCode; Rec."Bill-to Customer Template Code")
                {
                    ApplicationArea = Basic;
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(TaxAreaCode; Rec."Tax Area Code")
                {
                    ApplicationArea = Basic;
                }
                field(TaxLiable; Rec."Tax Liable")
                {
                    ApplicationArea = Basic;
                }
                field(VATRegistrationNo; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingAdvice; Rec."Shipping Advice")
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(BankAccountNo; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerPostingGroup; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerPriceGroup; Rec."Customer Price Group")
                {
                    ApplicationArea = Basic;
                }
                field(PricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field(AllowLineDisc; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceDiscCode; Rec."Invoice Disc. Code")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerDiscGroup; Rec."Customer Disc. Group")
                {
                    ApplicationArea = Basic;
                }
                field(LanguageCode; Rec."Language Code")
                {
                    ApplicationArea = Basic;
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
                field(CombineShipments; Rec."Combine Shipments")
                {
                    ApplicationArea = Basic;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Basic;
                }
                field(Prepayment; Rec."Prepayment %")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
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
                field(VATCountryRegionCode; Rec."VAT Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingNo; Rec."Shipping No.")
                {
                    ApplicationArea = Basic;
                }
                field(LastShippingNo; Rec."Last Shipping No.")
                {
                    ApplicationArea = Basic;
                }
                field(LastPostingNo; Rec."Last Posting No.")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingNoSeries; Rec."Shipping No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(ReturnReceiptNo; Rec."Return Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field(ReturnReceiptNoSeries; Rec."Return Receipt No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(PrepaymentNo; Rec."Prepayment No.")
                {
                    ApplicationArea = Basic;
                }
                field(PrepmtCrMemoNo; Rec."Prepmt. Cr. Memo No.")
                {
                    ApplicationArea = Basic;
                }
                field(PrepaymentNoSeries; Rec."Prepayment No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(PrepmtCrMemoNoSeries; Rec."Prepmt. Cr. Memo No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(OpportunityNo; Rec."Opportunity No.")
                {
                    ApplicationArea = Basic;
                }
                field(AssignedUserID; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyFactor; Rec."Currency Factor")
                {
                    ApplicationArea = Basic;
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(VATBaseDiscount; Rec."VAT Base Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(TransportMethod; Rec."Transport Method")
                {
                    ApplicationArea = Basic;
                }
                field(ExitPoint; Rec."Exit Point")
                {
                    ApplicationArea = Basic;
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = Basic;
                }
                field(TransactionSpecification; Rec."Transaction Specification")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingTime; Rec."Shipping Time")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field(PromisedDeliveryDate; Rec."Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field(OutboundWhseHandlingTime; Rec."Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                }
                field(SaleQuoteNo; Rec."Sale Quote No.")
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
                field(InTransitCode; Rec."In-Transit Code")
                {
                    ApplicationArea = Basic;
                }
                field(RentOrderNo; Rec."Rent Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentOrderType; Rec."Rent Order Type")
                {
                    ApplicationArea = Basic;
                }
                field(TransferType; Rec."Transfer Type")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoMobilePhoneNo; Rec."Bill-to Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoMobilePhoneNo; Rec."Ship-to Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(DateReceived; Rec."Date Received")
                {
                    ApplicationArea = Basic;
                }
                field(TimeReceived; Rec."Time Received")
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
                SubPageLink = "Table ID" = CONST(25006627),
                              "No." = FIELD("No.");
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

