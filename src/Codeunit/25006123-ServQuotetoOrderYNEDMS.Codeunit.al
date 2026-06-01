Codeunit 25006123 "Serv-Quote to Order (Y/N) EDMS"
{
    TableNo = "Service Header EDMS";

    trigger OnRun()
    var
        OfficeMgt: Codeunit "Office Management";
        ServiceOrder: Page "Service Order EDMS";
        OpenPage: Boolean;
        DealType: Record "Deal Type";
    begin
        Rec.TestField("Document Type", Rec."document type"::Quote);
        if GuiAllowed then
            if not Confirm(Text000, false) then
                exit;

        if (Rec."Document Type" = Rec."document type"::Quote) then
            if Rec.CheckCustomerCreated(true) then begin
                if Rec."Deal Type" <> '' then begin
                    DealType.Get(Rec."Deal Type");
                    if not DealType."Vehicle Not Mandatory" then begin
                        if not Rec.CheckVehicleCreated(true) then
                            exit;
                    end;
                end;
                Rec.Get(Rec."document type"::Quote, Rec."No.");
            end else
                exit;

        ServQuoteToOrder.Run(Rec);
        ServQuoteToOrder.GetSalesOrderHeader(ServHeader2);
        Commit;
        OnAfterServiceQuoteToOrderRun(ServHeader2, Rec);
        if GuiAllowed then
            if OfficeMgt.AttachAvailable then
                OpenPage := true
            else
                OpenPage := Confirm(StrSubstNo(OpenNewInvoiceQst, ServHeader2."No."), true);
        if OpenPage then begin
            Clear(ServiceOrder);
            ServiceOrder.CheckNotificationsOnce;
            ServHeader2.SetRecfilter;
            ServiceOrder.SetTableview(ServHeader2);
            ServiceOrder.Run;
        end;
    end;

    var
        Text000: label 'Do you want to convert the quote to an order?';
        Text001: label 'Quote %1 has been changed to order %2.';
        Text002: label 'Do you want to add the quote to an existing order?';
        ServHeader2: Record "Service Header EDMS";
        ServQuoteToOrder: Codeunit "Serv-Quote to Order EDMS";
        OpenNewInvoiceQst: label 'The quote has been converted to order %1. Do you want to open the new order?', Comment = '%1 = No. of the new sales order document.';

    procedure AddToExistingOrderYN(ServiceQoute: Record "Service Header EDMS")
    var
        DealType: Record "Deal Type";
        ServiceOrders: Record "Service Header EDMS";
        ServiceOrderList: Page "Service Orders EDMS";
        ServiceOrderNo: Code[20];
        OfficeMgt: Codeunit "Office Management";
        OpenPage: Boolean;
        ServiceOrder: Page "Service Order EDMS";
    begin
        ServiceQoute.TestField(ServiceQoute."Document Type", ServiceQoute."Document Type"::Quote);
        if GuiAllowed then
            if not Confirm(Text002, false) then
                exit;

        if (ServiceQoute."Document Type" = ServiceQoute."Document Type"::Quote) then
            if ServiceQoute.CheckCustomerCreated(true) then begin
                if ServiceQoute."Deal Type" <> '' then begin
                    DealType.Get(ServiceQoute."Deal Type");
                    if not DealType."Vehicle Not Mandatory" then begin
                        if not ServiceQoute.CheckVehicleCreated(true) then
                            exit;
                    end;
                end;
                ServiceQoute.Get(ServiceQoute."Document Type"::Quote, ServiceQoute."No.");
            end else
                exit;

        ServiceOrders.Reset;

        ServiceOrders.Reset;
        ServiceOrders.SetCurrentkey("Vehicle Serial No.");
        ServiceOrders.SetRange("Document Type", ServiceOrders."Document Type"::Order);
        ServiceOrders.SetRange("Vehicle Serial No.", ServiceQoute."Vehicle Serial No.");
        if ServiceOrders.FindFirst then
            repeat
                ServiceOrders.Mark := true;
            until ServiceOrders.Next = 0;

        ServiceOrders.MarkedOnly(true);
        //VehCount := Vehicle.Count;



        ServiceOrderList.SetTableview(ServiceOrders);
        ServiceOrderList.SetRecord(ServiceOrders);
        ServiceOrderList.LookupMode(true);
        if ServiceOrderList.RunModal = Action::LookupOK then begin
            ServiceOrderList.GetRecord(ServiceOrders);
            ServiceOrderNo := ServiceOrders."No.";
        end;


        ServQuoteToOrder.AddToExistingOrder(ServiceQoute, ServiceOrderNo);
        ServQuoteToOrder.GetSalesOrderHeader(ServHeader2);
        Commit;

        if GuiAllowed then
            if OfficeMgt.AttachAvailable then
                OpenPage := true
            else
                OpenPage := Confirm(StrSubstNo(OpenNewInvoiceQst, ServHeader2."No."), true);
        if OpenPage then begin
            Clear(ServiceOrder);
            ServiceOrder.CheckNotificationsOnce;
            ServHeader2.SetRecfilter;
            ServiceOrder.SetTableview(ServHeader2);
            ServiceOrder.Run;
        end;

    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterServiceQuoteToOrderRun(var ServiceHeader2: Record "Service Header EDMS"; var ServiceHeader: Record "Service Header EDMS")
    begin
    end;
}

