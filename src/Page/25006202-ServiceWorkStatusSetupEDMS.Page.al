Page 25006202 "Service Work Status Setup EDMS"
{
    ApplicationArea = Basic;
    Caption = 'Service Work Status Setup';
    PageType = Card;
    SourceTable = "Service Work Status EDMS";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code used for the work status.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a work status description.';
                }
                field(ServiceOrderStatus; Rec."Service Order Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a Service Order Status. This links work statuses defined in sytem how users would like to see with the four technical statuses used by the system.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a a priority for each work status. If there are several allocations at the same time for service order or line, then the status set for the order or line will be the work status with the highest priority.';
                }
            }
        }
    }

    actions
    {
    }
}

