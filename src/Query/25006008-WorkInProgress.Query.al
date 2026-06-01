Query 25006008 "Work In Progress"
{

    elements
    {
        dataitem(Serv_Labor_Allocation_Entry; "Serv. Labor Allocation Entry")
        {
            DataItemTableFilter = "Source Type" = const("Service Document"), "Source Subtype" = const(Order);
            column(Entry_No; "Entry No.")
            {
            }
            column(Total_Time_Spent; "Total Time Spent")
            {
            }
            column(Total_Cost_Amount; "Total Cost Amount")
            {
            }
            column(Last_Clocked; "Last Clocked")
            {
            }
            column(Start_Date_Time; "Start Date-Time")
            {
            }
            column(End_Date_Time; "End Date-Time")
            {
            }
            dataitem(Serv_Labor_Alloc_Application; "Serv. Labor Alloc. Application")
            {
                DataItemLink = "Allocation Entry No." = Serv_Labor_Allocation_Entry."Entry No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = Posted = const(false);
                column(Resource_No; "Resource No.")
                {
                }
                column(Posted; Posted)
                {
                }
                dataitem(Service_Header_EDMS; "Service Header EDMS")
                {
                    DataItemLink = "Document Type" = Serv_Labor_Allocation_Entry."Source Subtype", "No." = Serv_Labor_Allocation_Entry."Source ID";
                    SqlJoinType = InnerJoin;
                    column(No; "No.")
                    {
                    }
                    column(Document_Type; "Document Type")
                    {
                    }
                    dataitem(Service_Line_EDMS; "Service Line EDMS")
                    {
                        DataItemLink = "Document Type" = Service_Header_EDMS."Document Type", "Document No." = Service_Header_EDMS."No.";
                        column(Labor_No; "No.")
                        {
                        }
                        dataitem(Service_Labor; "Service Labor")
                        {
                            DataItemLink = "No." = Service_Line_EDMS."No.";
                            column(Group_Code; "Group Code")
                            {
                            }
                        }
                    }
                }
            }
        }
    }
}

