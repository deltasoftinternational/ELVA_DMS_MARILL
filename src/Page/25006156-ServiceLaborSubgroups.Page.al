Page 25006156 "Service Labor Subgroups"
{
    Caption = 'Service Labor Subgroups';
    DataCaptionFields = "Group Code";
    PageType = List;
    SourceTable = "Service Labor Subgroup";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the make code to which this service labor subgroup belongs to.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service labor subgroup.';
                }
                field(GroupCode; Rec."Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the code of the service labor group to which this service labor subgroup belongs to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service labor subgroup.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies an additional description of the service labor subgroup.';
                }
            }
        }
    }

    actions
    {
    }
}

