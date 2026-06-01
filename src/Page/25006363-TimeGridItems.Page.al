Page 25006363 "Time Grid Items"
{
    PageType = List;
    SourceTable = "Time Grid Item";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(GridCode; Rec."Grid Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(TimeStart; Rec."Time Start")
                {
                    ApplicationArea = Basic;
                }
                field(TimeEnd; Rec."Time End")
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

