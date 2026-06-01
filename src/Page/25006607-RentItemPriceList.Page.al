Page 25006607 "Rent Item Price List"
{
    Caption = 'Rent Item Prices';
    PageType = List;
    SourceTable = "Rent Item Sales Price";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RentItemNo; Rec."Rent Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the rent item.';
                }
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sales price type, which defines whether the price is for an individual, group, all customers, or a campaign.';
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that belongs to the Sales Type.';
                }
                field(RentPeriodCode; Rec."Rent Period Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the period for which the sales price is valid.';
                }
                field(RentPeriodPrice; Rec."Rent Period Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the price of one unit of the rent item for one rent period.';
                }
                field(ExtraPeriodCode; Rec."Extra Period Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the extra period for which the sales price is valid. Extra periods are used if the a rent item is not returned in time.';
                }
                field(ExtraPeriodPrice; Rec."Extra Period Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the price of one unit of the rent item for one rent extra period.';
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date from which the rent price is valid.';
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date to which the rent price is valid.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the currency of the rent price.';
                }

                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the rent price includes VAT.';
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the VAT business posting group for customers for whom you want the rent price (which includes VAT) to apply.';
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the extra charge of first counter field. For example, overtime motor hours or mileage.';
                    Visible = VFRun1Visible;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the extra charge of second counter field. For example, overtime motor hours or mileage.';
                    Visible = VFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the extra charge of third counter field. For example, overtime motor hours or mileage.';
                    Visible = VFRun3Visible;
                }
                field("Variable Field UOM 1"; Rec."Variable Field UOM 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variable Field UOM 1 field.';
                    Visible = VFRun1UOMVisible;
                }
                field("Variable Field UOM 2"; Rec."Variable Field UOM 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variable Field UOM 2 field.';
                    Visible = VFRun2UOMVisible;
                }
                field("Variable Field UOM 3"; Rec."Variable Field UOM 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variable Field UOM 3 field.';
                    Visible = VFRun3UOMVisible;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the minimum periods required to warrant the rent price.';
                }

            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        VFRun1Visible: Boolean;
        VFRun2Visible: Boolean;
        VFRun3Visible: Boolean;
        VFRun1UOMVisible: Boolean;
        VFRun2UOMVisible: Boolean;
        VFRun3UOMVisible: Boolean;

    procedure SetVariableFields()
    begin
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
        VFRun1UOMVisible := rec.IsVFActive(rec.FieldNo("Variable Field UOM 1"));
        VFRun2UOMVisible := rec.IsVFActive(rec.FieldNo("Variable Field UOM 2"));
        VFRun3UOMVisible := rec.IsVFActive(rec.FieldNo("Variable Field UOM 3"));
    end;
}

