Page 25006422 "BLS Service Card"
{
    Caption = 'Service Card';
    Editable = true;
    PageType = Card;
    SourceTable = "BLS Service";

    layout
    {
        area(content)
        {
            group(Group1)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
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
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    ColumnSpan = 2;
                }
            }
            group(Group2)
            {
                Caption = 'Quantity';
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
            }
            group(Group3)
            {
                Caption = 'Price And Discount';
                field(PriceSource; Rec."Price Source")
                {
                    ApplicationArea = Basic;
                }
                field(PriceCorrForPartialPeriod; Rec."Price Corr. For Partial Period")
                {
                    ApplicationArea = Basic;
                }
                field(PriceIncludingVAT; Rec."Price Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field(DiscountUsage; Rec."Discount Usage")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Group4)
            {
                Caption = 'Invoice';
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
                    ToolTip = '%1 Service Code, %2 Service Variant Code, %3 Object Type, %4 Object Code,  %5 Starting Date,  %6 Ending Date,  %7 Period Starting Date, %8 Period Ending Date, %9 Unit Price, %10 Total Price,  %11 Discount %,  %12 Discount Amount,  %13 Total Price Including Discount,  %14 Service Date,  %15 Vehicle Serial No., %16 VIN, %17 Make Code, %18 Model Code, %19 Model Commercial Name, %20 VF Run 1 Start, %21 VF Run 1 End, %22 VF Run 2 Start, %23 VF Run 2 End, %24 VF Run 3 Start, %25 VF Run 3 End';
                }
                field(InvoiceLineAdditDescription; Rec."Invoice Line Addit.Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = '%1 Service Code, %2 Service Variant Code, %3 Object Type, %4 Object Code,  %5 Starting Date,  %6 Ending Date,  %7 Period Starting Date, %8 Period Ending Date, %9 Unit Price, %10 Total Price,  %11 Discount %,  %12 Discount Amount,  %13 Total Price Including Discount,  %14 Service Date,  %15 Vehicle Serial No., %16 VIN, %17 Make Code, %18 Model Code, %19 Model Commercial Name, %20 VF Run 1 Start, %21 VF Run 1 End, %22 VF Run 2 Start, %23 VF Run 2 End, %24 VF Run 3 Start, %25 VF Run 3 End';
                }
                field(InvoiceLineAdditDescriptio2; Rec."Invoice Line Addit.Descriptio2")
                {
                    ApplicationArea = Basic;
                    ToolTip = '%1 Service Code, %2 Service Variant Code, %3 Object Type, %4 Object Code,  %5 Starting Date,  %6 Ending Date,  %7 Period Starting Date, %8 Period Ending Date, %9 Unit Price, %10 Total Price,  %11 Discount %,  %12 Discount Amount,  %13 Total Price Including Discount,  %14 Service Date,  %15 Vehicle Serial No., %16 VIN, %17 Make Code, %18 Model Code, %19 Model Commercial Name, %20 VF Run 1 Start, %21 VF Run 1 End, %22 VF Run 2 Start, %23 VF Run 2 End, %24 VF Run 3 Start, %25 VF Run 3 End';
                }
                field(SeparateEntries; Rec."Separate Entries")
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
                field(NoInvoice; Rec."Without Invoicing")
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
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(25006213),
                                  "No." = field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
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
                Image = History;
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

