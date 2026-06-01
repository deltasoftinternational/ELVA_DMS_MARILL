Page 25006367 "Time Grids"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Time Grid";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
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
            group("<Action1101901007>")
            {
                Caption = 'Grid';
                action(GridItems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grid Items';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Time Grid Items";
                    RunPageLink = "Grid Code" = field(Code);
                }
            }
        }
    }
}

