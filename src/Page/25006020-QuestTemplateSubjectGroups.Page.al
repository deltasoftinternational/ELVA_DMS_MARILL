Page 25006020 "Quest. Template Subject Groups"
{
    // 06/03/2018 GH P1
    //   *Added ENG captions

    Caption = 'Questionary Template Subject Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Questionary Templ. Subj. Group";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(QuestionaryTemplateCode; rec."Questionary Template Code")
                {
                    ApplicationArea = Basic;
                }
                field(QuestionarySubjectGroupCode; rec."Questionary Subject Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(SortingNo; rec."Sorting No.")
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

