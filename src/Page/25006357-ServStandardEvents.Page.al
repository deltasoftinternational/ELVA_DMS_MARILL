Page 25006357 "Serv. Standard Events"
{
    ApplicationArea = Basic;
    Caption = 'Service Standard Events';
    PageType = List;
    SourceTable = "Serv. Standard Event";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the standard event.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the standard event.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies an additional description of the standard event.';
                }
                field(GroupCode; Rec."Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the group of the standard event.';
                }
            }
        }
    }

    actions
    {
    }
}

