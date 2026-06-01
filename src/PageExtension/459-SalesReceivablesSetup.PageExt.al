pageextension 25006038 "Sales & Receivables Setup" extends "Sales & Receivables Setup" //459
{
    layout
    {
        addafter("Allow Document Deletion Before")
        {
            field(DefOrderingPriceTypeCode; Rec."Def. Ordering Price Type Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies what Ordering Price Type to add by default in Sales Lines.';
            }
            field(PaymentMethodMandatory; Rec."Payment Method Mandatory")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specify if Payment Method code should be mandatory to post sales documents.';
            }
            field(ItemNoReplacementWarnings; Rec."Item No. Replacement Warnings")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specify if replacement warnings should be displayed to users. It can have two notification types - notification that item has been replaced or notification that an old item is still in stock.';
            }
            field(AutoApplyReplacements; Rec."Auto Apply Replacements")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specify if replacements should be automatically applied in sales lines. Note: automatically can be applied only replacement if an old item is inserted and there is no stock left for it.';
            }
            field("Non Stock Item Price List Code"; Rec."Non Stock Item Price List Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Copy Line Descr. to G/L Entry")
        {
            field("Enable Stock Avail. Selection"; Rec."Enable Stock Avail. Selection")
            {
                ApplicationArea = All;
                ToolTip = 'Specify if system should show Stock Availability Selection screen. It is displayed only if there is insufficient stock in current Location and there is available stock in other Location marked to be used as Parts Location.';
            }
            field("Deal Type Mandatory"; Rec."Deal Type Mandatory")
            {
                ToolTip = 'Specifies if it is mandaory to fill Deal Type field in sales documents before posting.';
                ApplicationArea = All;
            }
        }
        addlast("Number Series")
        {
            field(ContractNos; Rec."Contract Nos.")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers for contracts.';
            }
        }


        addbefore("Background Posting")
        {
            group(PricesDMS)
            {
                Caption = 'Prices';
                field(DefSPriceVATBusPostGrp; Rec."Def.S.Price VAT Bus.Post.Grp.")
                {
                    ApplicationArea = Basic;
                }
                field(DefSPriceVATProdPostGrp; Rec."Def.S.Price VAT Prod.Post.Grp.")
                {
                    ApplicationArea = Basic;
                }
                field(DefSPriceCurrencyCode; Rec."Def.S.Price Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(DefSPriceRoundingPrecision; Rec."Def.S.Price Rounding Precision")
                {
                    ApplicationArea = Basic;
                }
                field(DefSalesPriceIncludeVAT; Rec."Def. Sales Price Include VAT")
                {
                    ApplicationArea = Basic;
                }
                field(DefSalesPriceAllowLineDisc; Rec."Def.Sales Price AllowLineDisc.")
                {
                    ApplicationArea = Basic;
                }
                field(DefSalesPriceIncludeDisc; Rec."Def.Sales Price Include Disc.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Vehicles)
            {
                Caption = 'Vehicles';
                field(TradeInSalesAccountNo; Rec."Trade-In Sales Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'In this field a G/L Account can be selected to use for Trade-In function in Vehicle Sales. This account will be used to create a line for the trade-in vehicle to decrease the amount of sales order to be paid by customer.';
                }
                field(VehMarginalVATAccountNo; Rec."Veh. Marginal VAT Account No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehMargVATItemCharge; Rec."Veh. Marg. VAT Item Charge")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'In this field an Item Charge code can be selected to use with the Marginal VAT function in vehicle sales. With this code a line will be added for the margin made on sales deal that VAT is calculated for.';
                }
                field(VehMargVATGenBusGrp; Rec."Veh. Marg.VAT Gen.Bus.Grp.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'In Marginal VAT function the VAT posting groups are changed on Vehicle line to have it without VAT. In this field you can select what VAT General Business Posting Group to use.';
                }
                field(VehMargVATGenProdGrp; Rec."Veh. Marg.VAT Gen.Prod.Grp.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'In Marginal VAT function the VAT posting groups are changed on Vehicle line to have it without VAT. In this field you can select what VAT General Product Posting Group to use.';
                }
                field(DefVehicleContactRel; Rec."Def.Vehicle-Contact Rel.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies Vehicle and Contact relationship code to use to link Vehicle to Customer on Vehicle sales order posting.';
                }
                field(VehicleSalesItemCharge; Rec."Vehicle Sales Item Charge")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleWarrantyonSales; Rec."Vehicle Warranty on Sales")
                {
                    ApplicationArea = Basic;
                    Tooltip = 'Specify if program should automatically add Warranties for Vehicles when Vehicle sales document is posted.';
                }
                field(CompressPrepayment; Rec."Compress Prepayment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specify if by default on sales documents prepayments should be compressed.';
                }
                field(LinkRelationshipCode; Rec."Link Relationship Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies Vehicle and Contact relationship code to use to link Vehicle to Customer on sales documents when not related Customer and Vehicle is specified in document header.';
                }
                field(VehicleServicePlanonSales; Rec."Vehicle Service Plan on Sales")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specify if program should automatically add Vehicle Service Plans for Vehicles when Vehicle sales document is posted.';
                }
                field("Vehicle Sale Register on"; Rec."Vehicle Sale Register on")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether on Sales Shipment or Sales Invoice system acknowledges Vehicle sale. This option is used to fill Vehicle Sales Date in Vehicle card and used as start date for automatic Vehicle Warranty and Service Plan generated entries.';
                }
            }
        }
    }
}