Page 25006620 "Rent Product Groups"
{
    Caption = 'Rent Product Groups';
    PageType = List;
    SourceTable = "Rent Product Group";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RentItemCategoryCode; Rec."Rent Item Category Code")
                {
                    ApplicationArea = Basic;
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

