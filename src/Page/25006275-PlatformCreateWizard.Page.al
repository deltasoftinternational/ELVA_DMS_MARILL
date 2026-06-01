Page 25006275 "Platform Create Wizard"
{
    Caption = 'Platform Create Wizard';
    PageType = NavigatePage;
    SourceTable = "Platform Template";

    layout
    {
        area(content)
        {
            group("Step 1")
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
            }
            group("Step 2")
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Back)
            {
                ApplicationArea = Basic;
                Caption = 'Back';
                InFooterBar = true;
                RunPageMode = Edit;
                Visible = true;
            }
            action(Next)
            {
                ApplicationArea = Basic;
                Caption = 'Next';
                InFooterBar = true;
            }
            action(Finish)
            {
                ApplicationArea = Basic;
                Caption = 'Finish';
                InFooterBar = true;
            }
        }
    }
}

