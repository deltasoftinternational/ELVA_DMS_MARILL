Page 25006608 "Rent Item Relations"
{
    Caption = 'Rent Item Relations';
    PageType = List;
    SourceTable = "Rent Item Relation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RentItemNo; Rec."Rent Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the rent item, that will be linked to Rent Asset.';
                }
                field(RentItemDescription; Rec."Rent Item Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the rent item.';
                }
                field(RentItemDescription2; Rec."Rent Item Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies an additional description of the rent item.';
                }
                field(RentItemCategoryCode; Rec."Rent Item Category Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the category code of the rent item.';
                }
                field(RentProductGroupCode; Rec."Rent Product Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the product group code of the rent item.';
                }
                field(RentAssetNo; Rec."Rent Asset No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the rent asset, that will be linked to Rent Item.';
                }
                field(RentAssetDescription; Rec."Rent Asset Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the rent asset.';
                }
                field(RentAssetDescription2; Rec."Rent Asset Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies an additional description of the rent asset.';
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(Availability)
            {
                ApplicationArea = Basic;
                Caption = 'Availability';
                Image = AvailableToPromise;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Rent Item Capacity";
                //RunPageLink = "Document Type"=field("Rent Item No."); //FIXME
            }
        }
    }
}

