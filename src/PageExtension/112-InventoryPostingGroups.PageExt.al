pageextension 25006033 "Inventory Posting Groups" extends "Inventory Posting Groups"//112
{
    layout
    {
        addafter(Description)
        {
            field(VehicleAdditionalExpenses; Rec."Vehicle Additional Expenses")
            {
                ApplicationArea = Basic;
            }
            field(SplitValueEntries; Rec."Split Value Entries")
            {
                ApplicationArea = Basic;
            }
        }

    }
}