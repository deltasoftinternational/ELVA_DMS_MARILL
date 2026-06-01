Page 25006823 "Product Subgroups"
{
    Caption = 'Product Subgroups';
    PageType = List;
    SourceTable = "Product Subgroup";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ProductGroupCode; Rec."Product Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
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

