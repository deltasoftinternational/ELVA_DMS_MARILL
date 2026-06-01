Page 25006296 "Service Mechanic Time Qty."
{

    layout
    {
        area(content)
        {
            group(Control25006001)
            {
                field(TimeQty; TimeQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Enter Time Quantity';
                }
            }
        }
    }

    actions
    {
    }

    var
        TimeQty: Decimal;


    procedure GetTimeQty(): Decimal
    begin
        exit(TimeQty)
    end;
}

