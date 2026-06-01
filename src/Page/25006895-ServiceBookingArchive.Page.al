Page 25006895 "Service Booking Archive"
{
    // 23.02.2015 EDMS P21
    //   Added field:
    //     "Model Version No."
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3

    Caption = 'Service Booking Archive';
    Editable = false;
    PageType = Document;
    SourceTable = "Service Header Archive EDMS";
    SourceTableView = where("Document Type" = const(Booking));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoContactNo; rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoAddress; rec."Sell-to Address")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoAddress2; rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoPostCode; rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCity; rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoContact; rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(OrderDate; rec."Order Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedDeliveryDate; rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field(PromisedDeliveryDate; rec."Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(VIN; rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun1; rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                }
                field(ServiceAdvisor; rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(CampaignNo; rec."Campaign No.")
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibilityCenter; rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(BookingResourceNo; rec."Booking Resource No.")
                {
                    ApplicationArea = Basic;
                }
            }
            part(ServiceLinesArchive; "Service Booking Arch. Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                              "Version No." = field("Version No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(BilltoCustomerNo; rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoContactNo; rec."Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoName; rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoAddress; rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoAddress2; rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoPostCode; rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCity; rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoContact; rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentTermsCode; rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field(DueDate; rec."Due Date")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentDiscount; rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentMethodCode; rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(PricesIncludingVAT; rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                }
            }
            group(ForeignTrade)
            {
                Caption = 'Foreign Trade';
                field(CurrencyCode; rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(EU3PartyTrade; rec."EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionType; rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionSpecification; rec."Transaction Specification")
                {
                    ApplicationArea = Basic;
                }
                field(TransportMethod; rec."Transport Method")
                {
                    ApplicationArea = Basic;
                }
                field(ExitPoint; rec."Exit Point")
                {
                    ApplicationArea = Basic;
                }
                field("Area"; rec.Area)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field(LocationCode; rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control1904291901)
            {
                Caption = 'Version';
                field(VersionNo; rec."Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(ArchivedBy; rec."Archived By")
                {
                    ApplicationArea = Basic;
                }
                field(DateArchived; rec."Date Archived")
                {
                    ApplicationArea = Basic;
                }
                field(TimeArchived; rec."Time Archived")
                {
                    ApplicationArea = Basic;
                }
                field(InteractionExist; rec."Interaction Exist")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';
                field(VariableFieldRun2; rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun2Visible;
                }
                field(VariableFieldRun3; rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun3Visible;
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
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Version)
            {
                Caption = 'Ver&sion';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = field("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        rec.ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Serv. Arch. Comment Sheet";
                    RunPageLink = Type = const("Service Order"),
                                  "No." = field("No."),
                                  "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                  "Version No." = field("Version No.");
                }
            }
        }
    }

    trigger OnInit()
    begin
        IsVFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
    end;

    var
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
}

