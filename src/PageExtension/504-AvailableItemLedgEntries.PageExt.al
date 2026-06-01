pageextension 25006074 "Available - Item Ledg. Entries" extends "Available - Item Ledg. Entries" //504
{
    var
        ReservEntry: Record "Reservation Entry";
        ReservMgt: Codeunit "Reservation Management";
        EDMSReservMgt: Codeunit "Reservation Management EDMS";
        CaptionText: Text;


    procedure SetServiceLineEDMS(var CurrentServLine: Record "Service Line EDMS"; CurrentReservEntry: Record "Reservation Entry")
    var
        ServiceLineEdms: Record "Service Line EDMS";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveServiceLineEDMS: Codeunit "Service Line EDMS-Reserve";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";

        SalesLine: Record "Sales Line";
    begin
        CurrentServLine.TestField(Type, CurrentServLine.Type::Item);
        ServiceLineEdms := CurrentServLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        EDMSReservMgt.SetServLineEDMS(ServiceLineEdms);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        SalesLine.SetReservationFilters(ReservEntry);
        CaptionText := ReserveServiceLineEDMS.Caption(ServiceLineEdms);
    end;
}