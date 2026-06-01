Page 25006272 "Platform Templates"
{
    ApplicationArea = Basic;
    Caption = 'Platform Templates';
    PageType = List;
    SourceTable = "Platform Template";
    UsageCategory = Lists;

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
            group(group2)
            {
                Caption = '&Platform';
                action(Axles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ax&les';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Platform Template Axles";
                    RunPageLink = "Template Code" = field(Code);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            action(Platform)
            {
                ApplicationArea = Basic;
                Caption = 'Platform';
                Image = Template;
                RunObject = Page "Platform Templates";
            }
        }
    }
}

