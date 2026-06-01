Page 25006635 "Rent Order"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Documents,History,Print';
    SourceTable = "Rent Header";
    SourceTableView = where("Document Type" = const(Order));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the rent order, according to the specified number series.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }

                field(RentType; Rec."Rent Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of rent in the document. It can be with set end date or with open end.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies a description of the rent.';
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer who will rent.';
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the customer who will rent.';
                }
                field(SelltoAddress; Rec."Sell-to Address")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the address where the customer is located.';
                }
                field(SelltoAddress2; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies additional address information.';
                }
                field(SelltoPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the postal code of customer.';
                }
                field(SelltoCity; Rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the city of the customer on the rent document.';
                }
                field(SelltoContactNo; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact that the rent document will be sent to.';
                }
                field(SelltoContact; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person to contact at the customer.';
                }
                field(OutstandingPayments; Rec."Outstanding Payments")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the amount of outstanding payments related to this rent order.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the date when the posting of the rent document will be recorded.';
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the order was created.';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the rent start date.';
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the salesperson who is assigned to the rent document.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies whether the document is open or has been released.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from where inventory of rent assets to the customer on the rent document are to be shipped by default.';
                }
                field(DealType; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the deal type that describes the rent document.';
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the contract number to which the rent document is related to.';
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies a document number that refers to the customer''s numbering system.';
                }
                field(DepositAmount; Rec."Deposit Amount")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                    ToolTip = 'Specifies the amount of deposit on rent order.';
                }
                field("Next Review Date"; Rec."Next Review Date")
                {
                    ToolTip = 'Specifies the Next Review Date of rent order.';
                    ApplicationArea = All;
                }
                field(DocumentStatus; Rec."Document Status")
                {
                    ApplicationArea = All;
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
            part(Control25006057; "Rent Order Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
            }
            part(Control25006058; "Rent Sales Order Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
            }
            group(Invoicing)
            {
                field(BillToOptions; BillToOptions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bill-to';
                    OptionCaption = 'Default (Customer),Another Customer,Custom Address';
                    ToolTip = 'Specifies the customer that the sales invoice will be sent to. Default (Customer): The same as the customer on the sales invoice. Another Customer: Any customer that you specify in the fields below.';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        if BillToOptions = BillToOptions::"Default (Customer)" then begin
                            Rec.Validate("Bill-to Customer No.", Rec."Sell-to Customer No.");
                        end;

                        Rec.CopySellToAddressToBillToAddress;
                    end;
                }
                field(BilltoName; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                    Editable = BillToOptions = BillToOptions::"Another Customer";
                    Enabled = BillToOptions = BillToOptions::"Another Customer";
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Editable = BillToOptions = BillToOptions::"Another Customer";
                    Enabled = BillToOptions = BillToOptions::"Another Customer";
                }
                field(BilltoAddress; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(BilltoAddress2; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(BilltoPostCode; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(BilltoCity; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(BilltoContactNo; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(BilltoContact; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(RentQuoteNo; Rec."Rent Quote No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the rent quote that the rent order was created from.';
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                    ToolTip = 'Specifies description that should be used for posting.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(PaymentDiscount; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(PricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(VATRegistrationNo; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(OvertimeCalculation; Rec."Overtime Calculation")
                {
                    ApplicationArea = Basic;
                }

            }
            group(Shipping)
            {
                field(ShippingOptions; ShipToOptions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ship-to';
                    OptionCaption = 'Default (Sell-to Address),Alternate Shipping Address,Custom Address';
                    ToolTip = 'Specifies the address that the products on the sales document are shipped to. Default (Sell-to Address): The same as the customer''s sell-to address. Alternate Ship-to Address: One of the customer''s alternate ship-to addresses. Custom Address: Any ship-to address that you specify in the fields below.';
                    Importance = Promoted;

                    trigger OnValidate()
                    var
                        ShipToAddress: Record "Ship-to Address";
                        ShipToAddressList: Page "Ship-to Address List";
                    begin

                        case ShipToOptions of
                            ShipToOptions::"Default (Sell-to Address)":
                                begin
                                    Rec.Validate("Ship-to Code", '');
                                    Rec.CopySellToAddressToShipToAddress;
                                end;
                            ShipToOptions::"Alternate Shipping Address":
                                begin
                                    ShipToAddress.SetRange("Customer No.", Rec."Sell-to Customer No.");
                                    ShipToAddressList.LookupMode := true;
                                    ShipToAddressList.SetTableView(ShipToAddress);

                                    if ShipToAddressList.RunModal = ACTION::LookupOK then begin
                                        ShipToAddressList.GetRecord(ShipToAddress);
                                        Rec.Validate("Ship-to Code", ShipToAddress.Code);
                                    end else
                                        ShipToOptions := ShipToOptions::"Custom Address";
                                end;
                            ShipToOptions::"Custom Address":
                                begin
                                    Rec.Validate("Ship-to Code", '');
                                end;
                        end;
                    end;
                }

                field(ShiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Alternate Shipping Address";
                }
                field(ShiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                }
                field(ShiptoAddress; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                }
                field(ShiptoAddress2; Rec."Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                }
                field(ShiptoCity; Rec."Ship-to City")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                }
                field(ShiptoContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
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
            }
            group("Foreign Trade")
            {
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
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
            part(Control25006073; "Customer Details FactBox")
            {
                ApplicationArea = Advanced;
                SubPageLink = "No." = field("Sell-to Customer No.");
            }
            part(Control25006072; "Rent Line Factbox")
            {
                ApplicationArea = All;
                Provider = Control25006057;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
            }
            part(Control25006075; "Rent Sales Line FactBox")
            {
                ApplicationArea = All;
                Provider = Control25006058;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              Type = field(Type),
                              "No." = field("No.");
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
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;

                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                    CurrPage.SaveRecord;
                end;
            }
            action(SalesInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoices';
                Image = SalesInvoice;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesHeaderInvoices: Record "Sales Header";
                begin
                    SalesHeaderInvoices.Reset;
                    SalesHeaderInvoices.SetRange("Rent Order No.", Rec."No.");
                    SalesHeaderInvoices.SetRange("Document Type", SalesHeaderInvoices."document type"::Invoice);

                    //IF COUNT = 1 THEN BEGIN
                    //  FORM.RUNMODAL(FORM::"Sales Invoice (Rent)",SalesHeader1);
                    //END ELSE BEGIN
                    SalesHeaderInvoices.SetRange("Document Profile", SalesHeaderInvoices."document profile"::Rent);
                    Page.RunModal(Page::"Sales List", SalesHeaderInvoices)
                    //END
                end;
            }
            action(CrMemos)
            {
                ApplicationArea = Basic;
                Caption = 'Cr. Memos';
                Image = CreditMemo;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesHeaderCrMemos: Record "Sales Header";
                begin
                    SalesHeaderCrMemos.Reset;
                    SalesHeaderCrMemos.SetRange("Rent Order No.", Rec."No.");
                    SalesHeaderCrMemos.SetRange("Document Type", SalesHeaderCrMemos."document type"::"Credit Memo");

                    //IF COUNT = 1 THEN BEGIN
                    //  FORM.RUNMODAL(FORM::"Posted Sales Cr. Memo (Rent)",SalesHeader1);
                    //END ELSE BEGIN
                    SalesHeaderCrMemos.SetRange("Document Profile", SalesHeaderCrMemos."document profile"::Rent);
                    Page.RunModal(Page::"Sales List", SalesHeaderCrMemos)
                    //END
                end;
            }
            action(TrabsferOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Orders';
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RentTransferHeader: Record "Rent Transfer Header";
                begin
                    RentTransferHeader.Reset;
                    RentTransferHeader.SetRange("Rent Order No.", Rec."No.");
                    RentTransferHeader.SetRange("Rent Order Type", Rec."Document Type");
                    //IF COUNT = 1 THEN BEGIN
                    //FORM.RUNMODAL(FORM::"Rent Transfer Order",RentTransferHeader1);
                    //END ELSE BEGIN
                    Page.RunModal(Page::"Rent Transfer List", RentTransferHeader)
                    //END
                    //END;
                end;
            }
            action(OpenPostedSalesInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Posted Sales Invoices';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Posted Sales Invoices";
                RunPageLink = "Rent Order No." = field("No.");
            }
            action(OpenPostedSalesCrMemos)
            {
                ApplicationArea = Basic;
                Caption = 'Posted Sales Credit Memos';
                Image = PostedCreditMemo;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Posted Sales Credit Memos";
                RunPageLink = "Rent Order No." = field("No.");
            }
            action(PostedTransferOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Posted Transfer Orders';
                Image = PostedShipment;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PostedRentTransferHeader: Record "Posted Rent Transfer Header";
                begin
                    PostedRentTransferHeader.Reset;
                    PostedRentTransferHeader.SetRange("Rent Order No.", Rec."No.");
                    PostedRentTransferHeader.SetRange("Rent Order Type", Rec."Document Type");
                    //IF COUNT = 1 THEN BEGIN
                    // FORM.RUNMODAL(FORM::"Posted Rent Trans. Order",PostedRentTransferHeader1);
                    //END ELSE BEGIN
                    Page.RunModal(Page::"Posted Rent Transfer List", PostedRentTransferHeader)
                    //END
                end;
            }
            action(ProcessChecklists)
            {
                ApplicationArea = Basic;
                Caption = 'Process Checklists';
                Image = CheckList;
                RunObject = Page "Process Checklist List";
                RunPageLink = "Source Type" = const(25006618),
                              "Source Subtype" = field("Document Type"),
                              "Source ID" = field("No.");
            }
        }
        area(processing)
        {
            action(Release)
            {
                ApplicationArea = Basic;
                Caption = 'Re&lease';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+F11';

                trigger OnAction()
                begin
                    ReleaseRentDoc.PerformManualRelease(Rec);
                    Rec.Modify;
                    CurrPage.Update;
                end;
            }
            action(Reopen)
            {
                ApplicationArea = Basic;
                Caption = 'Re&open';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ReleaseRentDoc.PerformManualReopen(Rec);
                end;
            }
            action(CreateRentalSalesLines)
            {
                ApplicationArea = Basic;
                Caption = 'Create Rental Sales Lines';
                Image = CreateLinesFromJob;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RentLine.CreateSalesLines(Rec, Today);
                end;
            }
            action(CreateDepositLines)
            {
                ApplicationArea = Basic;
                Caption = 'Create Deposit Lines';
                Image = DepositLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.CreateDepositLines;
                end;
            }
            action(CreateAdvancePaymentLines)
            {
                ApplicationArea = Basic;
                Caption = 'Create Advance Payment Lines';
                Image = PaymentForecast;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.CreatePrepaymentLines;
                end;
            }
            action(CreateTransferOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Create Transfer Order';
                Image = CreateMovement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RentTransferPost.CreateRentTransferOrder(Rec, 0, false);
                end;
            }
            action(CreateInvoiceCrMemo)
            {
                ApplicationArea = Basic;
                Caption = 'Create Invoice / Cr.Memo';
                Image = CreateCreditMemo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RentPost.CreateInvoices(Rec, true, Today);
                end;
            }
            action(Close)
            {
                ApplicationArea = Basic;
                Caption = 'Close';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.CloseRentOrder;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = ServiceAgreement;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DocMgt: Codeunit DocumentManagementDMS;
                    DocReport: Record "Document Report";
                begin
                    DocMgt.PrintCurrentDoc(4, 4, 1, DocReport);
                    DocMgt.SelectRentHeaderReport(DocReport, Rec, false);
                end;
            }
            action(Email)
            {
                ApplicationArea = Basic;
                Caption = 'Email';
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DocMgt: Codeunit DocumentManagementDMS;
                    DocReport: Record "Document Report";
                begin
                    DocMgt.PrintCurrentDoc(4, 4, 1, DocReport);
                    DocMgt.SelectRentHeaderReport(DocReport, Rec, true);
                end;
            }
            action(PrintSign)
            {
                ApplicationArea = Basic;
                Caption = 'Print & Sign';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SignManagement: Codeunit "Sign Management";
                begin
                    //SignManagement.CallSignAndPrintPageService(Rec);
                end;
            }
            action(EmailSign)
            {
                ApplicationArea = Basic;
                Caption = 'Email & Sign';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SignManagement: Codeunit "Sign Management";
                begin
                    //SignManagement.CallSignAndEmailPageService(Rec);
                end;
            }
            action(CreateServiceTransferOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Create Service Transfer Order';
                Image = CreateMovement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RentTransferPost.CreateRentServiceTransferOrder(Rec, 0, false);
                end;
            }
            action(CreateContract)
            {
                ApplicationArea = All;
                Caption = 'Create Contract';
                Image = AddContacts;

                trigger OnAction()
                var
                    DocManagementDMS: Codeunit DocumentManagementDMS;
                begin
                    DocManagementDMS.CreateContractFromRentOrder(Rec);
                    CurrPage.Update;
                end;
            }
        }
    }

    var
        ReleaseRentDoc: Codeunit "Release Rent Document";
        RentLine: Record "Rent Line";
        RentTransferPost: Codeunit "RentTransfer-Post";
        RentPost: Codeunit "Rent-Post";
        RentDescription: Text;

    protected var
        ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
        BillToOptions: Option "Default (Customer)","Another Customer","Custom Address";

    trigger OnAfterGetRecord()
    begin
        RentDescription := Rec.GetRentDescription;
    end;
}

