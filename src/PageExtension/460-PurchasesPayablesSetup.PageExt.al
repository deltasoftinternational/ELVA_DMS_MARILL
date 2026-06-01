pageextension 25006039 "Purchases & Payables Setup" extends "Purchases & Payables Setup" //460
{
    layout
    {
        addafter("Ignore Updated Addresses")
        {
            field(DefOrderingPriceTypeCode; Rec."Def. Ordering Price Type Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies what Ordering Price Type to add by default in purchase lines.';
            }
            field(SplitOrderByPriceType; Rec."Split Order By Price Type")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if purhase orders created from requisition should be split by ordering price type.';
            }
            field(AutoApplyReplacements; Rec."Auto Apply Replacements")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if program should automatically apply item replacements in purchase lines.';
            }
        }
        addafter("Copy Inv. No. To Pmt. Ref.")
        {
            field("Deal Type Mandatory"; Rec."Deal Type Mandatory")
            {
                ToolTip = 'Specifies if it is mandaory to fill Deal Type field in purchase documents before posting.';
                ApplicationArea = All;
            }
        }
        addlast(content)
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                field(VehiclePurchOrderGrouping; Rec."Vehicle Purch. Order Grouping")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if several vehicles should be added on one purchase order from requisition or if it should be one order per vehicle.';
                }
            }
        }
    }
}