pageextension 25006203 "Available - Sales Lines" extends "Available - Sales Lines"//499
{
    var
        ServiceLineEDMS: Record "Service Line EDMS";
        ReservEntry: Record "Reservation Entry";

        ReserveServiceLineEDMS: Codeunit "Service Line EDMS-Reserve";
        SourceRecRef: RecordRef;
        ReservMgt: Codeunit "Reservation Management";
        ReservMgtEDMS: Codeunit "Reservation Management EDMS";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        CaptionText: Text;



    local procedure UpdateReservFrom()
    begin
        SetSource(SourceRecRef, ReservEntry, ReservEntry.GetTransferDirection());
        //FIXME BC16upgrade
        case ReservEntry."Source Type" of
            Database::"Service Line EDMS":  //11.07.2013 EDMS P8
                begin
                    ServiceLineEDMS.Find;
                    SetServiceLineEDMS(ServiceLineEDMS, ReservEntry);
                end;
        end;

        DMSOnAfterUpdateReservFrom(ReservEntry);
    end;

    procedure SetServiceLineEDMS(var CurrentServLine: Record "Service Line EDMS"; CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentServLine.TestField(Type, CurrentServLine.Type::Item);
        ServiceLineEDMS := CurrentServLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservMgt);
        ReservMgtEDMS.SetServLineEDMS(ServiceLineEDMS);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        ReserveServiceLineEDMS.FilterReservFor(ReservEntry, ServiceLineEDMS);
        CaptionText := ReserveServiceLineEDMS.Caption(ServiceLineEDMS);
    end;

    local procedure UpdateReservMgt()
    begin
        Clear(ReservMgt);

        ReservMgt.SetReservSource(SourceRecRef, ReservEntry.GetTransferDirection());
        case ReservEntry."Source Type" of
            Database::"Service Line EDMS":  //11.07.2013 EDMS P8
                ReservMgtEDMS.SetServLineEDMS(ServiceLineEDMS);
        end;
        DMSOnAfterUpdateReservMgt(ReservEntry);
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure DMSOnAfterUpdateReservFrom(var ReservationEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure DMSOnAfterUpdateReservMgt(var ReservationEntry: Record "Reservation Entry")
    begin
    end;
}