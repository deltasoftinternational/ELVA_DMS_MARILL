Codeunit 25006871 "Service Booking to Order (Y/N)"
{
    TableNo = "Service Header EDMS";

    trigger OnRun()
    var
        ServiceOrder: Record "Service Header EDMS";
    begin
        ServiceBookingToOrderYN(Rec, ServiceOrder);
    end;

    var
        Text000: label 'Do you want to convert the booking to an order?';
        Text001: label 'Booking %1 has been changed to order %2.';
        ServHeader2: Record "Service Header EDMS";
        ServBookingToOrder: Codeunit "Service Booking to Order";


    procedure ServiceBookingToOrderYN(var ServiceBooking: Record "Service Header EDMS"; var ServiceOrder: Record "Service Header EDMS"): Boolean
    begin
        ServiceBooking.TestField("Document Type", ServiceBooking."document type"::Booking);
        if GuiAllowed then
            if not Confirm(Text000, false) then
                exit(false);

        if (ServiceBooking."Document Type" = ServiceBooking."document type"::Booking) then
            if ServiceBooking.CheckCustomerCreated(true) and ServiceBooking.CheckVehicleCreated(true) then
                ServiceBooking.Get(ServiceBooking."document type"::Booking, ServiceBooking."No.")
            else
                exit(false);

        ServBookingToOrder.Run(ServiceBooking);
        ServBookingToOrder.GetSalesOrderHeader(ServiceOrder);
        Commit;
        Message(Text001, ServiceBooking."No.", ServiceOrder."No.");

        exit(true);
    end;
}

