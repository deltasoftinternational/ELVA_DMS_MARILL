Page 25006098 "Easy Clocking Menu Items"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Easy Clocking Menu Item";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies line number for the Easy Clocking menu item. Line numbers are used to define order how Easy Clocking menu items appear to users.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the line. It can be whether text line or a button.';
                }
                field(Caption; Rec.Caption)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the caption user will see when using Easy Clocking tool.';
                }
                field(RunAction; Rec."Run Action")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the action that would be executed once user presses a button.';
                }
                field(RunObjectType; Rec."Run Object Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the object type to run if no action is defined to be run.';
                }
                field(RunObjectID; Rec."Run Object ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the object code to run if no action is defined to be run.';
                }
                field(Icon; Rec.Icon)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the icon users would see for this button.';
                }
            }
        }
    }

    actions
    {
    }
}

