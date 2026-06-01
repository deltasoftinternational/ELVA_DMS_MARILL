Query 25006006 "Employee Activity Report"
{

    elements
    {
        dataitem(Resource_Time_Reg_Entry; "Resource Time Reg. Entry")
        {
            DataItemTableFilter = Canceled = const(false), "Worktime Entry" = const(false);
            column(Resource_Time_Entry_No; "Entry No.")
            {
            }
            column(Resource_No; "Resource No.")
            {
            }
            column(Resource_Name; "Resource Name")
            {
            }
            column(Entry_Type; "Entry Type")
            {
            }
            column(Time_Spent; "Time Spent")
            {
            }
            column(Date; Date)
            {
            }
            column(Time; Time)
            {
            }
            dataitem(Serv_Labor_Allocation_Entry; "Serv. Labor Allocation Entry")
            {
                DataItemLink = "Entry No." = Resource_Time_Reg_Entry."Allocation Entry No.", "Resource No." = Resource_Time_Reg_Entry."Resource No.";
                column(Labor_Alloc_Entry_No; "Entry No.")
                {
                }
                column(Source_Type; "Source Type")
                {
                }
                dataitem(Service_Ledger_Entry_EDMS; "Service Ledger Entry EDMS")
                {
                    DataItemLink = "Document Type" = Serv_Labor_Allocation_Entry."Source Subtype", "Document No." = Serv_Labor_Allocation_Entry."Source ID";
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
                    column(Location_Code; "Location Code")
                    {
                    }
                    dataitem(Det_Serv_Ledger_Entry_EDMS; "Det. Serv. Ledger Entry EDMS")
                    {
                        DataItemLink = "Service Ledger Entry No." = Service_Ledger_Entry_EDMS."Entry No.", "Resource No." = Resource_Time_Reg_Entry."Resource No.";
                        column(Finished_Quantity_Hours; "Finished Quantity (Hours)")
                        {
                        }
                        column(Unit_Cost; "Unit Cost")
                        {
                        }
                        column(Cost_Amount; "Cost Amount")
                        {
                        }
                        column(Quantity_Hours; "Quantity (Hours)")
                        {
                        }
                    }
                }
            }
        }
    }
}

