Page 25006691 "GH ClockingTerminal Menu"
{
    PageType = List;
    SourceTable = "Easy Clocking Menu Item";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(Caption; Rec.Caption)
                {
                    ApplicationArea = Basic;
                }
                field(RunAction; Rec."Run Action")
                {
                    ApplicationArea = Basic;
                }
                field(RunObjectType; Rec."Run Object Type")
                {
                    ApplicationArea = Basic;
                }
                field(RunObjectID; Rec."Run Object ID")
                {
                    ApplicationArea = Basic;
                }
                field(Icon; Rec.Icon)
                {
                    ApplicationArea = Basic;
                }
                field(StandardEventCode; Rec."Standard Event Code")
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

