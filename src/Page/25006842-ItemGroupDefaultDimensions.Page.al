Page 25006842 "Item Group Default Dimensions"
{
    ApplicationArea = Basic;
    Caption = 'Item Group Default Dimensions';
    PageType = List;
    SourceTable = "Item Group Default Dimension";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;
                }
                //field(ProductGroupCode;"Product Group Code")
                //{
                //    ApplicationArea = Basic;
                //}
                field(DimensionCode; Rec."Dimension Code")
                {
                    ApplicationArea = Basic;
                }
                field(DimensionValueCode; Rec."Dimension Value Code")
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

