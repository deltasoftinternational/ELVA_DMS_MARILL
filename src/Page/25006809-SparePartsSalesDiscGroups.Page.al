Page 25006809 "Spare Parts Sales Disc. Groups"
{
    Caption = 'Spare Parts Sales Disc. Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Spare Part Sales Disc. Group";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
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
        area(navigation)
        {
            group(DiscGroup)
            {
                Caption = 'Disc. Group';
                action(Items)
                {
                    ApplicationArea = Basic;
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "SP Sales Disc. Group Items";
                    RunPageLink = "Sales Disc. Group Code" = field(Code);
                    RunPageView = sorting("Sales Disc. Group Code", Type, "No.");
                }
            }
        }
    }
}

