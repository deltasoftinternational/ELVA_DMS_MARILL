pageextension 25006477 "Phys. Inventory Journal" extends "Phys. Inventory Journal"//392
{
    actions
    {
        modify(CalculateInventory)
        {
            Visible = false;
        }
        addafter(CalculateInventory)
        {
            action(DMSCalculateInventory)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Calculate &Inventory';
                Ellipsis = true;
                Image = CalculateInventory;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Start the process of counting inventory by filling the journal with known quantities.';

                trigger OnAction()
                begin
                    CalcQtyOnHand.SetItemJnlLine(Rec);
                    CalcQtyOnHand.RunModal;
                    Clear(CalcQtyOnHand);
                end;
            }
        }

    }
    var
        CalcQtyOnHand: Report "EDMS Calculate Inventory";
}