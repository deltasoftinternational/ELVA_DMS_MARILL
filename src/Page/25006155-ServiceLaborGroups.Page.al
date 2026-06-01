Page 25006155 "Service Labor Groups"
{
    Caption = 'Service Labor Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Labor Group";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the make code this service labor group would be related to.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service labor group.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service labor group.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies an additional description of the service labor group.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(LaborGroup)
            {
                Caption = 'Labor Group';
                action(LaborSubgroups)
                {
                    ApplicationArea = Basic;
                    Caption = 'Labor Subgroups';
                    Image = Group;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Service Labor Subgroups";
                    RunPageLink = "Make Code" = field("Make Code"),
                                  "Group Code" = field(Code);
                    RunPageView = sorting("Make Code", "Group Code", Code);
                }
            }
        }
    }
}

