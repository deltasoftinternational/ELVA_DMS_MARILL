pageextension 25006041 "Marketing Setup" extends "Marketing Setup"//5094
{
    layout
    {
        addlast(content)
        {
            group(Todo)
            {
                Caption = 'To-do';
                field(WorkdayStartingTime; Rec."Workday Starting Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies starting time of to-do tasks, when tasks are created in relation to opportunity steps.';
                }
            }
        }
    }
}