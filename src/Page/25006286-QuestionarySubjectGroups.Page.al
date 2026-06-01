Page 25006286 "Questionary Subject Groups"
{
    // 06/03/2018 GH P1
    //   *Promoted set to NO for action "Linked Questionary Templates"
    //   *Added ENG captions

    Caption = 'Questionary Subject Groups';
    PageType = List;
    SourceTable = "Questionary Subject Group";

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
            action(LinkedQuestionaryTemplates)
            {
                ApplicationArea = Basic;
                Caption = 'Linked Questionary Templates';
                Image = LinkAccount;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Quest. Template Subject Groups";
                RunPageLink = "Questionary Subject Group Code" = field(Code);
            }
            action(Questions)
            {
                ApplicationArea = Basic;
                Caption = 'Questions';
                Image = QuestionaireSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Quest. Subj. Group Questions";
                RunPageLink = "Questionary Subject Group Code" = field(Code);
            }
        }
    }
}

