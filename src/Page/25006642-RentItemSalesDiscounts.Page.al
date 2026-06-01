Page 25006642 "Rent Item Sales Discounts"
{
    PageType = List;
    SourceTable = "Rent Item Sales Discount";
    PopulateAllFields = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of rent item that the rent discount line is valid for. That is, either a rent item or a rent item category.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies one of two values, depending on the value in the Type field.';
                }
                field(SalesType; Rec."Sales Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sales type of the rent line discount. The sales type defines whether the line discount is for an individual customer, customer discount group, all customers, or for a campaign.';
                }
                field(SalesCode; Rec."Sales Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies one of the following values, depending on the value in the Sales Type field.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the rent line discount.';
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the discount percentage that is granted for the rent item on the line.';
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date from which the rent line discount is valid.';
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date to which the sales line discount is valid.';
                }
                field(RentPeriodCode; Rec."Rent Period Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rent period code for which the rent line discount is valid.';
                }
            }
        }
    }

    actions
    {
    }
}

