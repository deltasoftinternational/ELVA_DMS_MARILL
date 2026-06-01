Query 25006005 "Vehicle Inventory Overview 3"
{

    elements
    {
        dataitem(Value_Entry; "Value Entry")
        {
            DataItemTableFilter = "Item Type" = filter("Model Version");
            column(Item_Ledger_Entry_Quantity; "Item Ledger Entry Quantity")
            {

            }
            column(Entry_No; "Entry No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Document_No; "Document No.")
            {
            }
            column(Cost_Amount_Actual; "Cost Amount (Actual)")
            {
            }
            column(Source_Type; "Source Type")
            {
            }
            column(Description; Description)
            {
            }
            column(Item_Ledger_Entry_Type; "Item Ledger Entry Type")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = Value_Entry."Source No.";
                column(Customer_Name; Name)
                {
                }
                dataitem(Vendor; Vendor)
                {
                    DataItemLink = "No." = Value_Entry."Source No.";
                    column(Vendor_Name; Name)
                    {
                    }
                    dataitem(Item_Ledger_Entry; "Item Ledger Entry")
                    {
                        DataItemLink = "Entry No." = Value_Entry."Item Ledger Entry No.";
                        column(Item_Ledger_Entry_No; "Entry No.")
                        {
                        }
                        column(Serial_No; "Serial No.")
                        {
                        }
                        column(Vehicle_Accounting_Cycle_No; "Vehicle Accounting Cycle No.")
                        {
                        }
                    }
                }
            }
        }
    }
}

