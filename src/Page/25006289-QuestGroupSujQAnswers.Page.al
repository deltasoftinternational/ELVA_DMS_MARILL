Page 25006289 "Quest. Group Suj. Q. Answers"
{
    Caption = 'Answers';
    PageType = List;
    SourceTable = "Quest. Subj. Group Q. Answer";
    SourceTableView = sorting("Questionary Subject Group Code", "Question No.", "Sorting No.")
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(AnswerText; Rec."Answer Text")
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

