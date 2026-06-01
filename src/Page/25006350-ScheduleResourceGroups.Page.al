Page 25006350 "Schedule Resource Groups"
{
    ApplicationArea = Basic;
    Caption = 'Schedule Resource Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Schedule Resource Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the schedule resource group.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the schedule resource group.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code which should use this resource group to get resources to show in the service booking screen.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ResourceGroup)
            {
                Caption = 'Resource Group';
                action(Specification)
                {
                    ApplicationArea = Basic;
                    Caption = 'Specification';
                    Image = ExternalDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Schedule Res. Group Spec.";
                    RunPageLink = "Group Code" = field(Code);
                }
            }
        }
    }
}

