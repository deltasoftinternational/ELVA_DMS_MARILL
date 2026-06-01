Page 25006380 "Service WIP Setup"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Service WIP Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(WIPDocumentNoSeries; Rec."WIP Document No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to service WIP documents.';
                }
                field(DefaultResourceUnitCost; Rec."Default Resource Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default unit cost that will be used in WIP calculation if resource has no cost set up in resource card.';
                }
                field(WIPMethod; Rec."WIP Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the the method used in WIP calculation. It definies whether WIP is used to recognize revenue or costs from open service orders.';
                }
                field(PostLaborCostforSalesMeth; Rec."Post Labor Cost for Sales Meth")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if in sales method additionally labor costs should be calculated.';
                }
            }
        }
    }

    actions
    {
    }
}

