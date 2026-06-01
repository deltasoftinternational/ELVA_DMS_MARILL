Page 25006371 "Resource Calendar Changes"
{
    ApplicationArea = Basic;
    Caption = 'Resource Calendar Changes';
    PageType = List;
    SourceTable = "Resource Calendar Change";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(ResourceCode; Rec."Resource Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resource for which this work time change is defined.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when work time change is defined.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Description field is used to add some additional information to this work time change entry.';
                }
                field(ChangeType; Rec."Change Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the the type of the change. It can be Work Time Change if there will be different working hours or Nonworking if person will not work at the specified date.';
                }
                field(StartingTime; Rec."Starting Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies new work starting time for the specified date. This field is used only if the change type is Work Time Change.';
                }
                field(EndingTime; Rec."Ending Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies new work ending time for the specified date. This field is used only if the change type is Work Time Change.';
                }
            }
        }
    }

    actions
    {
    }
}

