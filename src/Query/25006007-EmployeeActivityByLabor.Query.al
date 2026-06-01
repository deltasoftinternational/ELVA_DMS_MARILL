Query 25006007 "Employee Activity By Labor"
{

    elements
    {
        dataitem(Service_Ledger_Entry_EDMS; "Service Ledger Entry EDMS")
        {
            DataItemTableFilter = "Document Type" = const(Order);
            column(Labor_No; "No.")
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Document_No; "Document No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Description; Description)
            {
            }
            column(Amount; Amount)
            {
            }
            column(Quantity_Hours; "Quantity (Hours)")
            {
            }
            column(Finished_Hours; "Finished Hours")
            {
            }
            column(Resource_Cost_Amount; "Resource Cost Amount")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Labor_Group_Code; "Labor Group Code")
            {
            }
        }
    }
}

