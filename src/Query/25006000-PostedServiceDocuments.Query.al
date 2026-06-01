Query 25006000 "Posted Service Documents"
{

    elements
    {
        dataitem(Posted_Serv_Order_Header; "Posted Serv. Order Header")
        {
            column(Make_Code; "Make Code")
            {
            }
            column(Sum_Amount; Amount)
            {
                Method = Sum;
            }
        }
    }
}

