Query 25006012 "Service Actual"
{

    elements
    {
        dataitem(Service_Ledger_Entry_EDMS; "Service Ledger Entry EDMS")
        {
            DataItemTableFilter = "Entry Type" = const(Sale);
            column(Document_No; "Document No.")
            {
            }
            column(Amount_LCY; "Amount (LCY)")
            {
                ReverseSign = true;
            }
            column(Quantity; Quantity)
            {
                ReverseSign = true;
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Service_Receiver; "Service Receiver")
            {
            }
            column(Type; Type)
            {
            }
            dataitem(Sales_Invoice_Header; "Sales Invoice Header")
            {
                DataItemLink = "No." = Service_Ledger_Entry_EDMS."Document No.";
                column(Salesperson_Code; "Salesperson Code")
                {
                }
                dataitem(Location; Location)
                {
                    DataItemLink = Code = Service_Ledger_Entry_EDMS."Location Code";
                    column(Location_Name; Name)
                    {
                    }
                    dataitem(Salesperson_Purchaser; "Salesperson/Purchaser")
                    {
                        DataItemLink = Code = Service_Ledger_Entry_EDMS."Service Receiver";
                        column(Service_Advisor; Name)
                        {
                        }
                    }
                }
            }
        }
    }
}

