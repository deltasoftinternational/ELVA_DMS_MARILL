Page 25006205 "Service Plan Templates"
{
    ApplicationArea = Basic;
    Caption = 'Service Plan Templates';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Plan Template";
    UsageCategory = Tasks;

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
                field(ServicePlanType; Rec."Service Plan Type")
                {
                    ApplicationArea = Basic;
                }
                field(Adjust; Rec.Adjust)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Recurring; Rec.Recurring)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1190010>")
            {
                Caption = 'Service Plan Template';
                action(Stages)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stages';
                    Image = Stages;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Service Plan Template Stages";
                    RunPageLink = "Template Code" = field(Code);
                }
                action(Usage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Usage';
                    Image = History;
                    RunObject = Page "Service Plan Template Usage";
                    RunPageLink = "Template Code" = field(Code);
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page "Service Plan Comment Sheet";
                    RunPageLink = Type = const("Plan Template"),
                                  "Plan No." = field(Code);
                    RunPageView = sorting(Type, "Plan No.", "Stage Code", "Vehicle Serial No.", "Line No.");
                }
            }
        }
    }
}

