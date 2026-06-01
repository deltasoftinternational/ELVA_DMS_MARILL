Page 25006235 "Service Quote Archive EDMS"
{
    // 23.02.2015 EDMS P21
    //   Added field:
    //     "Model Version No."
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3

    Caption = 'Service Quote Archive';
    Editable = false;
    PageType = Document;
    SourceTable = "Service Header Archive EDMS";
    SourceTableView = where("Document Type" = const(Quote));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
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
                field(SelltoCustomerTemplateCode; Rec."Sell-to Customer Template Code")
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
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(CampaignNo; Rec."Campaign No.")
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
            }
            part(ServiceLinesArchive; "Serv. Quote Arch. Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                              "Version No." = field("Version No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoContactNo; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCustomerTemplateCode; Rec."Bill-to Customer Template Code")
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
                field(PricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                }
            }
            group(ForeignTrade)
            {
                Caption = 'Foreign Trade';
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(EU3PartyTrade; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionSpecification; Rec."Transaction Specification")
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
            }
            group(Details)
            {
                Caption = 'Details';
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control1904291901)
            {
                Caption = 'Version';
                field(VersionNo; Rec."Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(ArchivedBy; Rec."Archived By")
                {
                    ApplicationArea = Basic;
                }
                field(DateArchived; Rec."Date Archived")
                {
                    ApplicationArea = Basic;
                }
                field(TimeArchived; Rec."Time Archived")
                {
                    ApplicationArea = Basic;
                }
                field(InteractionExist; Rec."Interaction Exist")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun3Visible;
                }
            }
            group(ServiceAddress)
            {
                Caption = 'Service Address';
                field(ServiceAddressCode; Rec."Service Address Code")
                {
                    ApplicationArea = Basic;
                }
                field(Control25006001; Rec."Service Address")
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
                SubPageLink = "Table ID" = CONST(Database::"Service Header Archive"),
                              "No." = FIELD("No.");
            }
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
                        Rec.ShowDimensions;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Serv. Arch. Comment Sheet";
                    RunPageLink = Type = const("Service Quote"),
                                  "No." = field("No."),
                                  "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                  "Version No." = field("Version No.");
                }
            }
        }
        area(processing)
        {
            action(Restore)
            {
                ApplicationArea = Basic;
                Caption = '&Restore';
                Ellipsis = true;
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ArchiveManagement: Codeunit ArchiveManagement;
                    EDMSMGT: Codeunit "Vehicle Proposal Mgt. EDMS";
                begin
                    //ArchiveManagement.RestoreServiceDocument(Rec);
                    EDMSMGT.RestoreServiceDocument(Rec);

                end;
            }
        }
    }

    trigger OnInit()
    begin
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
    end;

    var
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
}

