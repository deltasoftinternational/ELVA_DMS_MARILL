Query 25006004 "Vehicle Inventory Overview 2"
{

    elements
    {
        dataitem(Value_Entry; "Value Entry")
        {
            DataItemTableFilter = "Item Type" = filter("Model Version");
            column(Sum_Cost_Amount_Actual; "Cost Amount (Actual)")
            {
                Method = Sum;
            }
            column(Sum_Item_Ledger_Entry_Quantity; "Item Ledger Entry Quantity")
            {
                Method = Sum;
            }
            filter(Posting_Date; "Posting Date")
            {
            }
            dataitem(Item_Ledger_Entry; "Item Ledger Entry")
            {
                DataItemLink = "Entry No." = Value_Entry."Item Ledger Entry No.";
                column(Serial_No; "Serial No.")
                {
                }
                column(Location_Code; "Location Code")
                {
                }
                column(Make_Code; "Make Code")
                {
                }
                column(Model_Code; "Model Code")
                {
                }
                column(VIN; VIN)
                {
                }
                column(Item_No; "Item No.")
                {
                }
                dataitem(Vehicle; Vehicle)
                {
                    DataItemLink = "Serial No." = Item_Ledger_Entry."Serial No.";
                    column(Body_Color_Code; "Body Color Code")
                    {
                    }
                    column(Status_Code; "Status Code")
                    {
                    }
                    column(Model_Version_No; "Model Version No.")
                    {
                    }
                    column(Production_Year; "Production Year")
                    {
                    }
                    column(Variable_Field_Run_1; "Variable Field Run 1")
                    {
                    }
                }
            }
        }
    }
}

