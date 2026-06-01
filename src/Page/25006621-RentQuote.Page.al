Page 25006621 "Rent Quote"
{
    PageType = Card;
    SourceTable = "Rent Header";
    PromotedActionCategories = 'New,Process,Report,Documents,History,Print';
    SourceTableView = where("Document Type" = filter(Quote));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
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
                field(OpportunityNo; Rec."Opportunity No.")
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
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(DealType; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                }
                field(ContractNo; Rec."Contract No.")
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
                field("Document Status"; Rec."Document Status")
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
            part(Control25006056; "Rent Quote Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
            }
            part(Control25006057; "Rent Sales Quote Subpage")
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
                field(BilltoContactNo; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
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
                field(BilltoContact; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(BankAccountNo; Rec."Bank Account No.")
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
                field(PostingDate; Rec."Posting Date")
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
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
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
            part(Control25006067; "Customer Details FactBox")
            {
                ApplicationArea = Advanced;
                SubPageLink = "No." = field("Sell-to Customer No.");
            }
            part(Control25006068; "Rent Line Factbox")
            {
                ApplicationArea = All;
                Provider = Control25006056;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
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
            action(MakeOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Make Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Rent-Quote to Order (Yes/No)", Rec);
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
                    DocMgt.PrintCurrentDoc(4, 4, 0, DocReport);
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
                    DocMgt.PrintCurrentDoc(4, 4, 0, DocReport);
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
        }
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
    }

    var
        ReleaseRentDoc: Codeunit "Release Rent Document";
        RentLine: Record "Rent Line";
        RentDescription: Text;

    protected var
        ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
        BillToOptions: Option "Default (Customer)","Another Customer","Custom Address";

    trigger OnAfterGetRecord()
    begin
        RentDescription := Rec.GetRentDescription;
    end;

}

