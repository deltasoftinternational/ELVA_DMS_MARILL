Page 25006803 "Item Markup Restrictions"
{
    Caption = 'Item Markup Restrictions';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Item Markup Restriction";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(GroupCode; Rec."Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CustomerPriceGroup; Rec."Customer Price Group")
                {
                    ApplicationArea = Basic;
                }
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;
                }
                field(MinMarkup; Rec."Min. Markup %")
                {
                    ApplicationArea = Basic;
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = Basic;
                    OptionCaption = 'Unit Cost';
                }
            }
        }
    }

    actions
    {
    }
}

