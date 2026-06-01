Query 25006009 "Service Actual Labor"
{

    elements
    {
        dataitem(Det_Serv_Ledger_Entry_EDMS; "Det. Serv. Ledger Entry EDMS")
        {
            column(Finished_Quantity_Hours; "Finished Quantity (Hours)")
            {
                ReverseSign = true;
            }
            column(Resource_No; "Resource No.")
            {
            }
            dataitem(Service_Ledger_Entry_EDMS; "Service Ledger Entry EDMS")
            {
                DataItemLink = "Entry No." = Det_Serv_Ledger_Entry_EDMS."Service Ledger Entry No.";
                DataItemTableFilter = "Entry Type" = const(Sale), Type = const(Labor);
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
}

