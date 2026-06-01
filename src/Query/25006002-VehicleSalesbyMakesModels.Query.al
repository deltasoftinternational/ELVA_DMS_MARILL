Query 25006002 "Vehicle Sales by Makes Models"
{

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Entry Type" = const(Sale), "Item Type" = const("Model Version");
            column(Make_Code; "Make Code")
            {
            }
            column(Model_Code; "Model Code")
            {
            }
            column(Quantity; Quantity)
            {
                ReverseSign = true;
            }
        }
    }

    trigger OnBeforeOpen()
    var
        InvertedQuantity: Decimal;
    begin
    end;
}

