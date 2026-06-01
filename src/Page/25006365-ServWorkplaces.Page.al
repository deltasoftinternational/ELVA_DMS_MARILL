Page 25006365 "Serv. Workplaces"
{
    ApplicationArea = Basic;
    Caption = 'Serv. Workplaces';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Serv. Workplace";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the service workplace.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description for the service workplace.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Workplace)
            {
                Caption = 'Workplace';
                action(Resources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';
                    Image = Resource;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Serv. Workplace Resources List";
                    RunPageLink = "Workplace Code" = field(Code);
                }
            }
        }
    }
}

