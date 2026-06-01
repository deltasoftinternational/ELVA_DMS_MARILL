pageextension 25006202 "Reservation" extends Reservation//498
{
    // var
    //     SourceRecRef: RecordRef;
    //     ReservEntry: Record "Reservation Entry";
    //     ServiceLineEDMS: Record "Service Line EDMS";
    //     ReserveServiceLineEDMS: Codeunit "Service Line EDMS-Reserve";

    //     ReservMgt: Codeunit "Reservation Management";
    //     UOMMgt: Codeunit "Unit of Measure Management";
    //     CreateReservEntry: Codeunit "Create Reserv. Entry";

    //     CaptionText: Text;
    //     FormIsOpen: Boolean;
    //     [InDataSet]
    //     NoteTextVisible: Boolean;
    //     HandleItemTracking: Boolean;
    //     NonSpecificQty: Decimal;

    //     ItemTrackingQtyToReserve: Decimal;
    //     ItemTrackingQtyToReserveBase: Decimal;
    //     QtyToReserve: Decimal;
    //     QtyToReserveBase: Decimal;
    //     QtyReserved: Decimal;
    //     QtyReservedBase: Decimal;

    //     ReservConfirmQst: Label 'Do you want to reserve specific tracking numbers?';
    //     Text008: Label 'Action canceled.';


    //     //
    //     ReserveReqLine: Codeunit "Req. Line-Reserve";



    // procedure SetReqLine(var CurrentReqLine: Record "Requisition Line")
    // var
    //     ReqLine: Record "Requisition Line";
    // begin
    //     SourceRecRef.GetTable(CurrentReqLine);
    //     SetReservSource(SourceRecRef, "Transfer Direction"::Outbound);
    //     //18.01.2013 EDMS P8 >>
    //     if (CurrentReqLine."Sales Order No." = '') and (CurrentReqLine."Service Order No." = '') then begin
    //         CurrentReqLine.TestField("Sales Order No.", '');
    //     end else
    //         if (CurrentReqLine."Sales Order No." <> '') then begin
    //             CurrentReqLine.TestField("Sales Order No.", '');
    //             CurrentReqLine.TestField("Sales Order Line No.", 0);
    //         end else begin
    //             CurrentReqLine.TestField("Service Order No.", '');
    //             CurrentReqLine.TestField("Service Order Line No.", 0);
    //         end;
    //     //18.01.2013 EDMS P8 <<
    //     CurrentReqLine.TestField("Sell-to Customer No.", '');
    //     CurrentReqLine.TestField(Type, CurrentReqLine.Type::Item);
    //     CurrentReqLine.TestField("Due Date");

    //     ReqLine := CurrentReqLine;
    //     ReservEntry.SetSource(
    //       DATABASE::"Requisition Line", 0, ReqLine."Worksheet Template Name", ReqLine."Line No.", ReqLine."Journal Batch Name", 0);
    //     ReservEntry."Item No." := ReqLine."No.";
    //     ReservEntry."Variant Code" := ReqLine."Variant Code";
    //     ReservEntry."Location Code" := ReqLine."Location Code";
    //     ReservEntry."Shipment Date" := ReqLine."Due Date";

    //     CaptionText := ReserveReqLine.Caption(ReqLine);
    //     UpdateReservFrom;

    //     OnAfterSetReqLine(Rec, ReservEntry);
    // end;

    // procedure SetServiceLineEDMS(var CurrentServiceLine: Record "Service Line EDMS")
    // begin
    //     CurrentServiceLine.TestField(Type, CurrentServiceLine.Type::Item);

    //     ServiceLineEDMS := CurrentServiceLine;
    //     ReservEntry."Source Type" := Database::"Service Line EDMS";
    //     ReservEntry."Source Subtype" := ServiceLineEDMS."Document Type";
    //     ReservEntry."Source ID" := ServiceLineEDMS."Document No.";
    //     ReservEntry."Source Ref. No." := ServiceLineEDMS."Line No.";

    //     ReservEntry."Item No." := ServiceLineEDMS."No.";
    //     ReservEntry."Variant Code" := ServiceLineEDMS."Variant Code";
    //     ReservEntry."Location Code" := ServiceLineEDMS."Location Code";
    //     ReservEntry."Shipment Date" := ServiceLineEDMS."Planned Service Date";

    //     CaptionText := ReserveServiceLineEDMS.Caption(ServiceLineEDMS);
    //     UpdateReservFrom;
    // end;

    // local procedure FilterReservEntry(var FilterReservEntry: Record "Reservation Entry"; ReservEntrySummary: Record "Entry Summary")
    // begin
    //     FilterReservEntry.SetRange("Item No.", ReservEntry."Item No.");

    //     EDMSOnFilterReservEntry(FilterReservEntry, ReservEntrySummary);
    //     //FIXME BC16 Upgrader
    //     case ReservEntrySummary."Entry No." of
    //         220, 230:
    //             begin // Service Line EDMS
    //                 FilterReservEntry.SetRange("Source Type", Database::"Service Line EDMS");
    //             end;

    //     end;

    //     EDMSOnFilterReservEntryOnAfterFilterSource(FilterReservEntry, ReservEntrySummary, ReservEntry);

    //     FilterReservEntry.SetRange("Reservation Status", FilterReservEntry."Reservation Status"::Reservation);
    //     FilterReservEntry.SetRange("Location Code", ReservEntry."Location Code");
    //     FilterReservEntry.SetRange("Variant Code", ReservEntry."Variant Code");
    //     if ReservEntry.TrackingExists then
    //         FilterReservEntry.SetTrackingFilterFromReservEntry(ReservEntry);
    //     FilterReservEntry.SetRange(Positive, ReservMgt.IsPositive);
    // end;

    // local procedure UpdateReservFrom()
    // var
    //     EntrySummary: Record "Entry Summary";
    //     QtyPerUOM: Decimal;
    //     QtyReservedIT: Decimal;
    // begin
    //     if not FormIsOpen then
    //         GetSerialLotNo(ItemTrackingQtyToReserve, ItemTrackingQtyToReserveBase);

    //     EDMSOnGetQtyPerUOMFromSourceRecRef(
    //         SourceRecRef, QtyPerUOM, QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase, ReservEntry);

    //     OnAfterGetQtyPerUOMFromSource(ReservEntry, QtyPerUOM);

    //     UpdateReservMgt();
    //     ReservMgt.UpdateStatistics(Rec, ReservEntry."Shipment Date", HandleItemTracking);

    //     if HandleItemTracking then begin
    //         EntrySummary := Rec;
    //         QtyReservedBase := 0;
    //         if Rec.FindSet then
    //             repeat
    //                 QtyReservedBase += ReservedThisLine(Rec);
    //             until Rec.Next() = 0;
    //         QtyReservedIT := Round(QtyReservedBase / QtyPerUOM, UOMMgt.QtyRndPrecision);
    //         if Abs(QtyReserved - QtyReservedIT) > UOMMgt.QtyRndPrecision then
    //             QtyReserved := QtyReservedIT;
    //         QtyToReserveBase := ItemTrackingQtyToReserveBase;
    //         if Abs(ItemTrackingQtyToReserve - QtyToReserve) > UOMMgt.QtyRndPrecision then
    //             QtyToReserve := ItemTrackingQtyToReserve;
    //         Rec := EntrySummary;
    //     end;

    //     UpdateNonSpecific(); // Late Binding

    //     EDMSOnAfterUpdateReservFrom(Rec);

    //     if FormIsOpen then
    //         CurrPage.Update();
    // end;

    // local procedure GetSerialLotNo(var ItemTrackingQtyToReserve: Decimal; var ItemTrackingQtyToReserveBase: Decimal)
    // var
    //     Item: Record Item;
    //     ReservEntry2: Record "Reservation Entry";
    //     TempReservEntry: Record "Reservation Entry" temporary;
    //     TempTrackingSpecification: Record "Tracking Specification" temporary;
    //     ItemTrackingMgt: Codeunit "Item Tracking Management";
    //     SignFactor: Integer;
    //     IsHandled: Boolean;
    // begin
    //     IsHandled := false;
    //     OnBeforeGetSerialLotNo(ReservEntry, ItemTrackingQtyToReserve, ItemTrackingQtyToReserveBase, IsHandled);
    //     if IsHandled then
    //         exit;

    //     Item.Get(ReservEntry."Item No.");
    //     if Item."Item Tracking Code" = '' then
    //         exit;
    //     ReservEntry2 := ReservEntry;
    //     ReservEntry2.SetPointerFilter();
    //     ItemTrackingMgt.SumUpItemTracking(ReservEntry2, TempTrackingSpecification, true, true);

    //     if TempTrackingSpecification.Find('-') then begin
    //         if not Confirm(StrSubstNo(ReservConfirmQst, true)) then
    //             exit;
    //         repeat
    //             TempReservEntry.TransferFields(TempTrackingSpecification);
    //             TempReservEntry.Insert();
    //         until TempTrackingSpecification.Next() = 0;

    //         if PAGE.RunModal(PAGE::"Item Tracking List", TempReservEntry) = ACTION::LookupOK then begin
    //             ReservEntry.CopyTrackingFromReservEntry(TempReservEntry);
    //             OnGetSerialLotNoOnAfterSetTrackingFields(ReservEntry, TempReservEntry);
    //             CaptionText += StrSubstNo(ReservConfirmQst, ReservEntry.GetTrackingText());
    //             SignFactor := CreateReservEntry.SignFactor(TempReservEntry);
    //             ItemTrackingQtyToReserveBase := TempReservEntry."Quantity (Base)" * SignFactor;
    //             ItemTrackingQtyToReserve :=
    //               Round(ItemTrackingQtyToReserveBase / TempReservEntry."Qty. per Unit of Measure", UOMMgt.QtyRndPrecision);
    //             HandleItemTracking := true;
    //         end else
    //             Error(Text008);
    //     end;
    // end;

    // local procedure UpdateReservMgt()
    // begin
    //     Clear(ReservMgt);
    //     ReservMgt.SetReservSource(SourceRecRef, "Transfer Direction".FromInteger(ReservEntry."Source Subtype"));
    //     OnUpdateReservMgt(ReservEntry, ReservMgt);
    //     ReservMgt.SetTrackingFromReservEntry(ReservEntry);
    // end;

    // local procedure UpdateNonSpecific()
    // begin
    //     Rec.SetFilter("Non-specific Reserved Qty.", '>%1', 0);
    //     NoteTextVisible := not Rec.IsEmpty();
    //     NonSpecificQty := Rec."Non-specific Reserved Qty.";
    //     Rec.SetRange("Non-specific Reserved Qty.");
    // end;

    [IntegrationEvent(false, false)]
    local procedure EDMSOnGetQtyPerUOMFromSourceRecRef(SourceRecRef: RecordRef; var QtyPerUOM: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; ReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure EDMSOnAfterUpdateReservFrom(var EntrySummary: Record "Entry Summary")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure EDMSOnBeforeGetSerialLotNo(ReservEntry: Record "Reservation Entry"; var ItemTrackingQtyToReserve: Decimal; var ItemTrackingQtyToReserveBase: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure EDMSOnAfterGetQtyPerUOMFromSource(ReservationEntry: Record "Reservation Entry"; var QtyPerUOM: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure EDMSOnGetSerialLotNoOnAfterSetTrackingFields(var ReservationEntry: Record "Reservation Entry"; TempReservationEntry: Record "Reservation Entry" temporary)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure EDMSOnUpdateReservMgt(var ReservationEntry: Record "Reservation Entry"; var ReservationManagement: Codeunit "Reservation Management")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetReqLine(var EntrySummary: Record "Entry Summary"; ReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure EDMSOnFilterReservEntry(var FilterReservEntry: Record "Reservation Entry"; ReservEntrySummary: Record "Entry Summary");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure EDMSOnFilterReservEntryOnAfterFilterSource(var ReservationEntry: Record "Reservation Entry"; FromEntrySummary: Record "Entry Summary"; ReservEntry: Record "Reservation Entry")
    begin
    end;

}