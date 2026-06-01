Page 25006230 "Service Labor Price Groups"
{
    Caption = 'Service Labor Price Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Labor Price Group";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service labor price group.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service labor price group.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ServLaborGr)
            {
                Caption = 'Serv. Labor Gr.';
                action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = SalesPrices;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Service Prices";
                    RunPageLink = Type = const("Labor Group"),
                                  Code = field("No.");
                }
            }
        }
    }
}

