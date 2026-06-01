Page 25006824 "Item Price Group Setup"
{
    Caption = 'Item Price Group Setup';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Item Price Group Setup";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ItemPriceGroupCode; Rec."Item Price Group Code")
                {
                    ToolTip = 'Specifies the code of the Item Price Group.';
                    ApplicationArea = All;
                }
                field(SalesType; Rec."Sales Type")
                {
                    ToolTip = 'Specifies the Sales Type for the setup line for Item Price Group, to wich it will apply.';
                    ApplicationArea = All;
                }
                field(SalesCode; Rec."Sales Code")
                {
                    ToolTip = 'Specifies the Sales Code for the setup line for Item Price Group, to wich it will apply.';
                    ApplicationArea = All;
                }
                field(SalesPriceFactor; Rec."Sales Price Factor")
                {
                    ToolTip = 'Specifies the price factor to use for price calculatio using this setup line.';
                    ApplicationArea = All;
                }
                field("Cost From"; Rec."Cost From")
                {
                    ToolTip = 'Specifies the value of the Cost From field.';
                    ApplicationArea = All;
                }
                field("Cost To"; Rec."Cost To")
                {
                    ToolTip = 'Specifies the value of the Cost To field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

