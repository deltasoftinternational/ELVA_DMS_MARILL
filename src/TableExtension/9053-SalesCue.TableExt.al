tableextension 25006378 "Sales Cue" extends "Sales Cue" //9053
{
    fields
    {

    }

    procedure CountOrdersEDMS(FieldNumber: Integer): Integer
    var
        SalesHeader: Record "Sales Header";
        CountSalesOrders: Query "Count Sales Orders EDMS";
        DocProfMgt: Codeunit "Document Profile Mgt. EDMS";
    begin
        CountSalesOrders.SetRange(Status, SalesHeader.Status::Released);
        CountSalesOrders.SetRange(Completely_Shipped, false);
        CountSalesOrders.SetFilter(Document_Profile, DocProfMgt.GetDocProfileFilter());
        FilterGroup(2);
        CountSalesOrders.SetFilter(Responsibility_Center, GetFilter("Responsibility Center Filter"));

        FilterGroup(0);

        case FieldNumber of
            FieldNo("Ready to Ship"):
                begin
                    CountSalesOrders.SetRange(Ship);
                    CountSalesOrders.SetFilter(Shipment_Date, GetFilter("Date Filter2"));
                end;
            FieldNo("Partially Shipped"):
                begin
                    CountSalesOrders.SetRange(Shipped, true);
                    CountSalesOrders.SetFilter(Shipment_Date, GetFilter("Date Filter2"));
                end;
            FieldNo(Delayed):
                begin
                    CountSalesOrders.SetRange(Ship);
                    CountSalesOrders.SetFilter(Date_Filter, GetFilter("Date Filter"));
                    CountSalesOrders.SetRange(Late_Order_Shipping, true);
                end;
        end;
        CountSalesOrders.Open;
        CountSalesOrders.Read;
        exit(CountSalesOrders.Count_Orders);
    end;
}
