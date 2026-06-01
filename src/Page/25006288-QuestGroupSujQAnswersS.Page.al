Page 25006288 "Quest. Group Suj. Q. Answers S"
{
    PageType = ListPart;
    SourceTable = "Quest. Subj. Group Q. Answer";

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

