pageextension 25006019 "General Posting Setup Card" extends "General Posting Setup Card"//395
{
    layout
    {
        addlast(content)
        {
            group(Service)
            {
                Caption = 'Service';
                field(ServicePrepaymentsAccount; Rec."Service Prepayments Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post service prepayment amounts to.';
                }
                field(VehAddExpensesAccount; Rec."Veh. Add. Expenses Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general ledger account number to post the vehicle additional expenses with this particular combination of business posting group and product posting group.';
                }
                field(WIPAccuredCostAcc; Rec."WIP Accured Cost Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post service WIP cost amounts to.';
                }
                field(WIPAccuredSalesAcc; Rec."WIP Accured Sales Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post service WIP sales amounts to.';
                }
                field(WIPCostAdjustmentAcc; Rec."WIP Cost Adjustment Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post service WIP cost adjustment amounts to.';
                }
                field(WIPSalesAdjusmentAcc; Rec."WIP Sales Adjusment Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post service WIP sales adjustment amounts to.';
                }
                field(LaborCostAccount; Rec."Labor Cost Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post service labor cost amounts to. The costs can be defined based on labor codes or resources used for mechanics.';
                }
                field(LaborCostAdjustmentAccount; Rec."Labor Cost Adjustment Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post service labor cost adjustment amounts to. The costs can be defined based on labor codes or resources used for mechanics.';
                }
            }
        }
    }
}