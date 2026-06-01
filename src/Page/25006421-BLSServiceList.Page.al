Page 25006421 "BLS Service List"
{
    ApplicationArea = Basic;
    Caption = 'Service List';
    CardPageID = "BLS Service Card";
    Editable = false;
    PageType = List;
    SourceTable = "BLS Service";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                }
                field(BaseUnitofMeasureCode; Rec."Base Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(ObjectMandatory; Rec."Object Mandatory")
                {
                    ApplicationArea = Basic;
                }
                field(CombineObjects; Rec."Combine Objects")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(QuantitySource; Rec."Quantity Source")
                {
                    ApplicationArea = Basic;
                }
                field(QtyCorrForPartialPeriod; Rec."Qty. Corr. For Partial Period")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultQuantity; Rec."Default Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(SeparateEntries; Rec."Separate Entries")
                {
                    ApplicationArea = Basic;
                }
                field(QtyRoundingPrecision; Rec."Qty. Rounding Precision")
                {
                    ApplicationArea = Basic;
                }
                field(QtyRoundingType; Rec."Qty. Rounding Type")
                {
                    ApplicationArea = Basic;
                }
                field(CalculationRoundingPrecision; Rec."Calculation Rounding Precision")
                {
                    ApplicationArea = Basic;
                }
                field(CalculationRoundingType; Rec."Calculation Rounding Type")
                {
                    ApplicationArea = Basic;
                }
                field("<Price Source>"; Rec."Price Source")
                {
                    ApplicationArea = Basic;
                }
                field(PriceIncludingVAT; Rec."Price Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field(PriceCorrForPartialPeriod; Rec."Price Corr. For Partial Period")
                {
                    ApplicationArea = Basic;
                }
                field(CalculateAveragePrice; Rec."Calculate Average Price")
                {
                    ApplicationArea = Basic;
                }
                field(DiscountUsage; Rec."Discount Usage")
                {
                    ApplicationArea = Basic;
                }
                field(PostingType; Rec."Posting Type")
                {
                    ApplicationArea = Basic;
                }
                field(PostingNo; Rec."Posting No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingName; Rec."Posting Name")
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceLineDescription; Rec."Invoice Line Description")
                {
                    ApplicationArea = Basic;
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000005; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1000000004; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Service)
            {
                Caption = 'Service';
                Image = "<DataEntry>";
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action(DimensionsSingle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = const(55001),
                                      "No." = field(Code);
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action(DimensionsMultiple)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;

                        trigger OnAction()
                        var
                            Service: Record "BLS Service";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Service);
                            DefaultDimMultiple.SetMultiBLSService(Service);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Contract;
                action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = JobPrice;
                    Promoted = true;
                    RunObject = Page "BLS Service Prices";
                    RunPageLink = "Service Code" = field(Code);
                }
                action(Discounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Discounts';
                    Image = Discount;
                    Promoted = true;
                    RunObject = Page "BLS Service Discounts";
                    RunPageLink = "Service Code" = field(Code);
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
                    RunPageLink = "Service Code" = field(Code);
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
                    RunPageLink = "Service Code" = field(Code);
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
                    RunPageLink = "Service Code" = field(Code);
                }
            }
        }
    }
}

