pageextension 25006205 "Available - Purchase Lines" extends "Available - Purchase Lines" //501
{
    var
        ServiceLineEDMS: Record "Service Line EDMS";
        ReserveServiceLineEDMS: Codeunit "Service Line EDMS-Reserve";
        ReservMgt: Codeunit "Reservation Management EDMS";
        ReservEntry: Record "Reservation Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        CaptionText: Text;

    procedure SetServiceLineEDMS(var CurrentServLine: Record "Service Line EDMS"; CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentServLine.TestField(Type, CurrentServLine.Type::Item);
        ServiceLineEDMS := CurrentServLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgt.SetServLineEDMS(ServiceLineEDMS);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        ReserveServiceLineEDMS.FilterReservFor(ReservEntry, ServiceLineEDMS);
        CaptionText := ReserveServiceLineEDMS.Caption(ServiceLineEDMS);
    end;
}