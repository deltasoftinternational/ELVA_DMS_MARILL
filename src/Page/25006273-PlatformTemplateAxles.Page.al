Page 25006273 "Platform Template Axles"
{
    Caption = 'Platform Template Axles';
    PageType = List;
    SourceTable = "Platform Template Axle";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Functions';
                field("Code"; Rec.Code)
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
            group(PlatformListActionGroup)
            {
                Caption = 'Axle';
                action(OpenTirePositionListAction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tire Positions';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Platform Templ. Tire Positions";
                    RunPageLink = "Template Code" = field("Template Code"),
                                  "Template Axle Code" = field(Code);
                    RunPageView = sorting("Template Code", "Template Axle Code", Code)
                                  order(ascending);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
    }
}

