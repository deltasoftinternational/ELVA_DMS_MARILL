query 25006001 "Count Sales Orders EDMS"  //>>--Added by delta  
{
    Caption = 'Count Sales Orders EDMS';


    elements
    {
        dataitem(Sales_Header; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = CONST(Order);
            filter(Status; Status)
            {
            }
            filter(Shipped; Shipped)
            {
            }
            filter(Completely_Shipped; "Completely Shipped")
            {
            }
            filter(Responsibility_Center; "Responsibility Center")
            {
            }
            filter(Shipped_Not_Invoiced; "Shipped Not Invoiced")
            {
            }
            filter(Ship; Ship)
            {
            }
            filter(Date_Filter; "Date Filter")
            {
            }
            filter(Late_Order_Shipping; "Late Order Shipping")
            {
            }
            filter(Shipment_Date; "Shipment Date")
            {
            }
            filter(Document_Profile; "Document Profile")
            {
            }
            column(Count_Orders)
            {
                Method = Count;
            }
        }

    }

    trigger OnBeforeOpen()
    begin

    end;
}
