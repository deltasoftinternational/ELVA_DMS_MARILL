tableextension 25006381 "InventoryProfile" extends "Inventory Profile" //99000853
{
    fields
    {

    }

    procedure TransferFromServLineEDMS(var ServLine: Record "Service Line EDMS"; var TrackingEntry: Record "Reservation Entry")
    var
        ReservEntry: Record "Reservation Entry";
        ReserveServLine: Codeunit "Service Line EDMS-Reserve";
        AutoReservedQty: Decimal;
    begin
        ServLine.TestField(Type, ServLine.Type::Item);
        "Source Type" := Database::"Service Line EDMS";
        "Source Order Status" := ServLine."Document Type";
        "Source ID" := ServLine."Document No.";
        "Source Ref. No." := ServLine."Line No.";
        "Item No." := ServLine."No.";
        "Variant Code" := ServLine."Variant Code";
        "Location Code" := ServLine."Location Code";
        "Bin Code" := ServLine."Bin Code";
        ServLine.CalcFields("Reserved Qty. (Base)");
        ReserveServLine.FilterReservFor(ReservEntry, ServLine);
        AutoReservedQty := -TransferBindings(ReservEntry, TrackingEntry);
        if ServLine."Document Type" = ServLine."document type"::"Return Order" then begin
            ServLine."Reserved Qty. (Base)" := ServLine."Reserved Qty. (Base)";
            AutoReservedQty := -AutoReservedQty;
        end;
        "Untracked Quantity" :=
          ServLine."Outstanding Qty. (Base)" -
          ServLine."Reserved Qty. (Base)" +
          AutoReservedQty;
        Quantity := ServLine.Quantity;
        "Remaining Quantity" := ServLine."Outstanding Quantity";
        "Quantity (Base)" := ServLine."Quantity (Base)";
        "Remaining Quantity (Base)" := ServLine."Outstanding Qty. (Base)";
        "Unit of Measure Code" := ServLine."Unit of Measure Code";
        "Qty. per Unit of Measure" := ServLine."Qty. per Unit of Measure";
        if ServLine."Document Type" = ServLine."document type"::"Return Order" then
            ChangeSign;
        IsSupply := "Untracked Quantity" < 0;
        "Due Date" := ServLine."Planned Service Date";
        "Planning Flexibility" := "planning flexibility"::None;
        "Drop Shipment" := ServLine."Drop Shipment";
    end;

}
