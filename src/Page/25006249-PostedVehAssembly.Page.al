Page 25006249 "Posted Veh. Assembly"
{
    Caption = 'Posted Vehicle Assembly';
    Editable = false;
    PageType = List;
    SourceTable = "Posted Veh. Assembly Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                }
                field(SourceNo; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(AssemblyID; Rec."Assembly ID")
                {
                    ApplicationArea = Basic;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(OptionType; Rec."Option Type")
                {
                    ApplicationArea = Basic;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalCode; Rec."External Code")
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
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(CostAmount; Rec."Cost Amount")
                {
                    ApplicationArea = Basic;
                }
                field(SalesPrice; Rec."Sales Price")
                {
                    ApplicationArea = Basic;
                }
                field(Standard; Rec.Standard)
                {
                    ApplicationArea = Basic;
                }
                field(OptionSubtype; Rec."Option Subtype")
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
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                }
                field(CampaignNo; Rec."Campaign No.")
                {
                    ApplicationArea = Basic;
                }
                field(AllowLineDisc; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic;
                }
                field(PDICreated; Rec."PDI Created")
                {
                    ApplicationArea = Basic;
                }
                field(DirectPurchaseCost; Rec."Direct Purchase Cost")
                {
                    ApplicationArea = Basic;
                }
                field(PurchaseDiscount; Rec."Purchase Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(PurchaseDiscountAmount; Rec."Purchase Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(PurchaseCostAmount; Rec."Purchase Cost Amount")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

