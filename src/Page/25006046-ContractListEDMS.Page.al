Page 25006046 "Contract List EDMS"
{
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added fields:
    //     "Document Profile"
    //     "Contract Location"
    //   Added Page Actions:
    //     <Page Contract Signers>
    //     <Page Contract Sales Line Discount>
    // 
    // 07.04.2014 Elva Baltic P15 # MMG7.00
    //   * Added Page Action: Vehicles

    ApplicationArea = Basic;
    Caption = 'Contract List';
    CardPageID = Contract;
    Editable = false;
    PageType = List;
    SourceTable = Contract;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
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
                field(Status; Rec.Status)
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
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = Basic;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
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
                Caption = 'Contract';
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
                    RunPageLink = "Contract No." = field("Contract No.");
                }
            }
            group(Sale)
            {
                Caption = 'Sale';
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
            }
        }
        area(creation)
        {
            action("BLS Ledger Entries")
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
            action("BLS Calculation Ledger Entries")
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
            action("BLS Invoicing Ledger Entries")
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
        }
    }
}

