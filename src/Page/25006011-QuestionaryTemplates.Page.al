Page 25006011 "Questionary Templates"
{
    // 06/03/2018 GH P1
    //   *Added ENG captions

    ApplicationArea = Basic;
    Caption = 'Questionary Templates';
    PageType = List;
    SourceTable = "Questionary Template";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Checklist Category"; rec."Checklist Category")
                {
                    ToolTip = 'Specifies the Checklist Category.';
                    ApplicationArea = All;
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            action(LinkedSubjectGroups)
            {
                ApplicationArea = Basic;
                Caption = 'Linked Subject Groups';
                Image = LinkAccount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Quest. Template Subject Groups";
                RunPageLink = "Questionary Template Code" = field(Code);
            }
        }
    }
}

