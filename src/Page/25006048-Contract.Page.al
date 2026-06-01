Page 25006048 "Contract"
{
    // 23.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "Accepted Amount"
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     "Contract Location"
    //   Set Visible FALSE to:
    //     Field:
    //       "No. of Archived Versions"
    //     Page action:
    //       <Page Contract Sales Prices>
    //       <Action1190012>  Archive Document
    // 
    // 07.04.2014 Elva Baltic P15 # MMG7.00
    //   * Added Page Action: Vehicles
    // 
    // 21.03.2014 Elva Baltic P18 MMG7.00 #RX012
    //   Added fields
    //     "Payment Terms Code"
    //     "Fin. Charge Terms Code"
    // 
    // 05.10.2007. EDMS P2
    //   * Changed property Menu Item Contract -> Signers

    Caption = 'Contract';
    PageType = Card;
    SourceTable = Contract;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalContractNo; Rec."External Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentProfile; Rec."Document Profile")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
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
                field(BilltoAddress; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                }
                field(PostCodeCity; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code/City';
                }
                field(BilltoCity; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(ExpirationDate; Rec."Expiration Date")
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
                field(Suspended; Rec.Suspended)
                {
                    ApplicationArea = Basic;
                }
                field(NoofArchivedVersions; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field(FinChargeTermsCode; Rec."Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(AcceptedAmount; Rec."Accepted Amount")
                {
                    ApplicationArea = Basic;
                }
                field(ContractLocation; Rec."Contract Location")
                {
                    ApplicationArea = Basic;
                }
                field(ContractCategoryCode; Rec."Contract Category Code")
                {
                    ApplicationArea = Basic;
                }
                field(UseForBilling; Rec."Use For Billing")
                {
                    ApplicationArea = Basic;
                }
                field(SeparateInvoicePerVehicle; Rec."Separate Invoice Per Vehicle")
                {
                    ApplicationArea = Basic;
                }
                field(NextReviewDate; Rec."Next Review Date")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocNoForInvoices; Rec."External Doc. No. For Invoices")
                {
                    ApplicationArea = Basic;
                }
                field(DealType; Rec."Deal Type For Invoices")
                {
                    ApplicationArea = Basic;
                }
                group("Contract Description")
                {
                    Caption = 'Contract Description';
                    field(ContractDescription; ContractDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Standard;
                        MultiLine = true;
                        ShowCaption = false;

                        trigger OnValidate()
                        begin
                            Rec.SetContractDescription(ContractDescription);
                        end;
                    }
                }
            }
            part(Control25006002; "DMS Contract Service Subpage")
            {
                SubPageLink = "DMS Contract No." = field("Contract No.");
                ApplicationArea = Basic;
            }
            part(Control25006003; "Contract BLS Leasing Schedule")
            {
                SubPageLink = "Contract No." = field("Contract No.");
                ApplicationArea = Basic;
            }

        }
        area(factboxes)
        {
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
            group(Contract)
            {
                Caption = '&Contract';
                action(Signers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Signers';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Contract Signers";
                    RunPageLink = "Contract Type" = const(Contract),
                                  "Contract No." = field("Contract No.");
                }
                action(Vehicles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicles';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Contract Vehicles";
                    RunPageLink = "Contract Type" = const(Contract),
                                    "Contract No." = field("Contract No.");
                }
            }
            group(Sale)
            {
                Caption = 'Sale';
                action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = SalesPrices;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Contract Sales Prices";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(LineDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Contract Sales Line Discount";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(SalesQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Quotes';
                    Image = Document;
                    RunObject = Page "Sales Quotes";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(SalesOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Orders';
                    Image = Document;
                    RunObject = Page "Sales Orders";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(SalesReturnOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Return Orders';
                    Image = Document;
                    RunObject = Page "Sales Return Orders";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(SalesInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Invoices';
                    Image = Document;
                    RunObject = Page "Sales Invoice List";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(SalesCrMemo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Credit Memos';
                    Image = Document;
                    RunObject = Page "Sales Credit Memos";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
            }
            group(Service)
            {
                Caption = 'Service';
                action(ServiceQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Quotes';
                    Image = Document;
                    RunObject = Page "Service Quotes EDMS";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(ServiceOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Orders';
                    Image = Document;
                    RunObject = Page "Service Orders EDMS";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(ServiceReturnOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Return Orders';
                    Image = Document;
                    RunObject = Page "Service Return Orders EDMS";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(PostedServiceOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Service Orders';
                    Image = Document;
                    RunObject = Page "Posted Service Orders EDMS";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
            }
            group(Rent)
            {
                Caption = 'Rent';
                action(RentQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Quotes';
                    Image = Document;
                    RunObject = Page "Rent Quote List";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(RentOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Orders';
                    Image = Document;
                    RunObject = Page "Rent Order List";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(ClosedRentOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Rent Orders';
                    Image = Document;
                    RunObject = Page "Closed Rent Order List";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
            }

            group(History)
            {
                Caption = 'History';
                action(ServiceLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "BLS Ledger Entries";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(CalculationLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculation Ledger Entries';
                    Image = CalculateLines;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "BLS Calculation Ledger Entries";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(InvoicingLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoicing Ledger Entries';
                    Image = CustomerLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "BLS Invoicing Ledger Entries";
                    RunPageLink = "Contract No." = field("Contract No.");
                }

                action(PostedSalesInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    Image = Document;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Contract No." = field("Contract No.");
                }
                action(PostedSalesCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Credit Memos';
                    Image = Document;
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "Contract No." = field("Contract No.");
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
                var
                    DocMgt: Codeunit DocumentManagementDMS;
                    RepSelect: Record "Document Report";
                begin
                    DocMgt.PrintCurrentDoc(0, 0, 13, RepSelect);
                    DocMgt.SelectContractDocReport(RepSelect, Rec);
                end;
            }
            group("<Action1101904000>")
            {
                Caption = 'F&unctions';
                action("<Action1101907101>")
                {
                    ApplicationArea = Basic;
                    Caption = '&Activate';
                    Image = Status;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.Update;
                        ActivateContract.ActivateContract(Rec);
                        CurrPage.Update;
                    end;
                }
                action("<Action1101907102>")
                {
                    ApplicationArea = Basic;
                    Caption = '&Inactivate';
                    Image = Status;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.Update;
                        ActivateContract.InactivateContract(Rec);
                        CurrPage.Update;
                    end;
                }
                action("<Action1190012>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Archi&ve Document';
                    Image = Status;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        // ArchiveManagement.ArchiveContract(Rec);
                        EDMSMGT.ArchiveContract(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(CreateRentOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Create Rent Order';
                    Image = NewDocument;

                    trigger OnAction()
                    var
                        DocManagementDMS: Codeunit DocumentManagementDMS;
                    begin
                        DocManagementDMS.CreateRentOrderFromContract(Rec);
                        CurrPage.Update;
                    end;
                }
                action(CreateServiceOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Create Service Order';
                    Image = NewDocument;

                    trigger OnAction()
                    var
                        DocManagementDMS: Codeunit DocumentManagementDMS;
                    begin
                        DocManagementDMS.CreateServiceOrderFromContract(Rec);
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        ActivateContract: Codeunit ActivateContract;
        ArchiveManagement: Codeunit ArchiveManagement;
        EDMSMGT: codeunit "Vehicle Proposal Mgt. EDMS";
        ContractDescription: Text;

    trigger OnAfterGetRecord()
    begin
        ContractDescription := Rec.GetContractDescription;
    end;
}

