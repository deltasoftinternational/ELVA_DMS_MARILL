Query 25006003 "Campaign Query"
{

    elements
    {
        dataitem(Posted_Serv_Order_Header; "Posted Serv. Order Header")
        {
            column(CurrencyCode; "Currency Code")
            {
            }
            filter(Campaign_No; "Campaign No.")
            {
            }
            filter(PostingDate; "Posting Date")
            {
            }
            dataitem(Posted_Serv_Order_Line; "Posted Serv. Order Line")
            {
                DataItemLink = "Document No." = Posted_Serv_Order_Header."No.";
                column(Amount; Amount)
                {
                    Method = Sum;
                }
                column(Type; Type)
                {
                }
            }
        }
    }
}

