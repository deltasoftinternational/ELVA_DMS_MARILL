pageextension 25006457 "Order Processor Role Center" extends "Order Processor Role Center"//9006
{
    layout
    {
        modify(Control1901851508)
        {
            visible = false;
        }
        addafter(Control104)
        {
            part(DMSControl1901851508; "Vehicle SO Proc. Activities")
            {
                AccessByPermission = TableData "Sales Shipment Header" = R;
                ApplicationArea = Basic, Suite;
            }
        }
    }
}