Codeunit 25006613 "Rent Availability Mgt."
{

    trigger OnRun()
    begin
    end;

    procedure GetRentAssetAvailabilityEntries(var TmpRentAvailabilityBuffer: Record "Rent Availability Buffer" temporary; StartingDate: Date; EndingDate: Date; var RentAsset: Record "Rent Asset")
    var
        n: Integer;
        RentLedgerEntry: Record "Rent Ledger Entry";
        RentLine: Record "Rent Line";
        RentAssetEntryExists: Boolean;
        AvailabilityType: Integer;
        ServiceHeaderEDMS: Record "Service Header EDMS";
        RentSetup: Record "Rent Mgt. Setup";
    begin
        TmpRentAvailabilityBuffer.Reset;
        TmpRentAvailabilityBuffer.DeleteAll;
        if StartingDate <> 0D then
            RentAsset.SetFilter("Date Filter", '..%1', StartingDate);
        RentAsset.SetAutocalcFields(Quantity);
        n := 0;
        if RentAsset.FindFirst then
            repeat
                // Get Transfered Rent Assets
                RentAssetEntryExists := false;
                RentLedgerEntry.Reset;
                RentLedgerEntry.SetRange("Rent Asset No.", RentAsset."No.");
                RentLedgerEntry.SetRange("Entry Type", RentLedgerEntry."entry type"::Inventory);
                RentLedgerEntry.SetFilter("Outstanding Qty.", '>0');
                if StartingDate = EndingDate then begin
                    RentLedgerEntry.SetFilter("Starting Date", '%1', StartingDate);
                end else begin
                    if StartingDate <> 0D then begin
                        RentLedgerEntry.SetFilter("Ending Date", '>%1', StartingDate);
                    end;
                    if EndingDate <> 0D then begin
                        RentLedgerEntry.SetFilter("Starting Date", '<=%1', EndingDate);
                    end;
                end;
                if RentLedgerEntry.FindSet then begin
                    RentAssetEntryExists := true;
                    repeat
                        n += 1;
                        if RentLedgerEntry."Service Order No." <> '' then
                            AvailabilityType := TmpRentAvailabilityBuffer.Type::"In Service"
                        else
                            if RentLedgerEntry."Rent Order No." <> '' then
                                AvailabilityType := TmpRentAvailabilityBuffer.Type::Rented
                            else
                                AvailabilityType := TmpRentAvailabilityBuffer.Type::" ";

                        InsertRentAssetAvailabilityEntry(TmpRentAvailabilityBuffer, n, AvailabilityType, RentLedgerEntry."Rent Item No.", 0, RentAsset."No.", RentAsset.Quantity, RentLedgerEntry.Quantity
                                                          , RentLedgerEntry."Starting Date", RentLedgerEntry."Ending Date", RentLedgerEntry."Location Code"
                                                          , RentLedgerEntry."Sell-to Customer No.", RentLedgerEntry."Service Order No.", RentLedgerEntry."Rent Order No.", RentLedgerEntry."Rent Order Line No.", RentLedgerEntry."Rent Order Type");
                    until RentLedgerEntry.Next = 0;
                end;

                // Get History Entries for Period
                RentSetup.Get;
                RentLedgerEntry.Reset;
                RentLedgerEntry.SetRange("Rent Asset No.", RentAsset."No.");
                RentLedgerEntry.SetRange("Entry Type", RentLedgerEntry."entry type"::Inventory);
                RentLedgerEntry.SetFilter("Location Code", '<>%1', RentSetup."Default Cust. Location Code");
                RentLedgerEntry.SetRange("Document Type", RentLedgerEntry."document type"::Shipment);
                RentLedgerEntry.SetFilter("Outstanding Qty.", '0');
                if StartingDate = EndingDate then begin
                    RentLedgerEntry.SetFilter("Starting Date", '%1', StartingDate);
                end else begin
                    if StartingDate <> 0D then begin
                        RentLedgerEntry.SetFilter("Ending Date", '>%1', StartingDate);
                    end;
                    if EndingDate <> 0D then begin
                        RentLedgerEntry.SetFilter("Starting Date", '<=%1', EndingDate);
                    end;
                end;
                if RentLedgerEntry.FindSet then begin
                    RentAssetEntryExists := true;
                    repeat
                        n += 1;
                        if RentLedgerEntry."Service Order No." <> '' then
                            AvailabilityType := TmpRentAvailabilityBuffer.Type::"In Service"
                        else
                            if RentLedgerEntry."Rent Order No." <> '' then
                                AvailabilityType := TmpRentAvailabilityBuffer.Type::Recieved
                            else
                                AvailabilityType := TmpRentAvailabilityBuffer.Type::" ";

                        InsertRentAssetAvailabilityEntry(TmpRentAvailabilityBuffer, n, AvailabilityType, RentLedgerEntry."Rent Item No.", 0, RentAsset."No.", RentAsset.Quantity, -RentLedgerEntry.Quantity
                                                          , RentLedgerEntry."Starting Date", RentLedgerEntry."Ending Date", RentLedgerEntry."Location Code"
                                                          , RentLedgerEntry."Sell-to Customer No.", RentLedgerEntry."Service Order No.", RentLedgerEntry."Rent Order No.", RentLedgerEntry."Rent Order Line No.", RentLedgerEntry."Rent Order Type");
                    until RentLedgerEntry.Next = 0;
                end;

                // Get Reserved and Requested Rent Asset Entries >>
                RentLine.Reset;
                RentLine.SetRange("Rent Asset No.", RentAsset."No.");
                RentLine.SetFilter("Actual Shipment Date", '');
                if StartingDate = EndingDate then begin
                    RentLine.SetFilter("Planned Shipment Date", '%1', StartingDate);
                end else begin
                    if StartingDate <> 0D then begin
                        RentLine.SetFilter("Planned Return Date", '>%1|%2', StartingDate, 0D);
                    end;
                    if EndingDate <> 0D then begin
                        RentLine.SetFilter("Planned Shipment Date", '<=%1', EndingDate);
                    end;
                end;
                RentLine.SetAutocalcFields("Sell-to Customer No.");
                if RentLine.FindSet then begin
                    RentAssetEntryExists := true;
                    repeat
                        n += 1;
                        if RentLine."Document Type" = RentLine."document type"::Order then
                            AvailabilityType := TmpRentAvailabilityBuffer.Type::Reserved
                        else
                            AvailabilityType := TmpRentAvailabilityBuffer.Type::Requested;
                        InsertRentAssetAvailabilityEntry(TmpRentAvailabilityBuffer, n, AvailabilityType, RentLine."Rent Item No.", 0, RentAsset."No.", RentAsset.Quantity, RentLine.Quantity
                                                          , RentLine."Planned Shipment Date", RentLine."Planned Return Date", RentLine."Location Code"
                                                          , RentLine."Sell-to Customer No.", '', RentLine."Document No.", RentLine."Line No.", RentLine."Document Type");
                    until RentLine.Next = 0;
                end;
                // Get Scheduled Service Entries >>
                if RentAsset."Vehicle Serial No." <> '' then begin
                    ServiceHeaderEDMS.Reset;
                    ServiceHeaderEDMS.SetRange("Vehicle Serial No.", RentAsset."Vehicle Serial No.");
                    if ServiceHeaderEDMS.FindFirst then
                        repeat
                            TmpRentAvailabilityBuffer.Reset;
                            TmpRentAvailabilityBuffer.SetRange("Service Order No.", ServiceHeaderEDMS."No.");
                            TmpRentAvailabilityBuffer.SetRange("Rent Asset No.", RentAsset."No.");
                            if not TmpRentAvailabilityBuffer.FindFirst then begin
                                RentAssetEntryExists := true;
                                n += 1;
                                InsertRentAssetAvailabilityEntry(TmpRentAvailabilityBuffer, n, TmpRentAvailabilityBuffer.Type::"Scheduled Service", RentLedgerEntry."Rent Item No.", 0, RentAsset."No.", RentAsset.Quantity, 1
                                                              , ServiceHeaderEDMS."Planned Service Date", 0D, ''
                                                              , ServiceHeaderEDMS."Sell-to Customer No.", ServiceHeaderEDMS."No.", '', 0, 0);
                            end;
                        until ServiceHeaderEDMS.Next = 0;
                end;
                if not RentAssetEntryExists then begin
                    n += 1;
                    InsertRentAssetAvailabilityEntry(TmpRentAvailabilityBuffer, n, TmpRentAvailabilityBuffer.Type::" ", '', 0, RentAsset."No.", RentAsset.Quantity, 0
                                                        , 0D, 0D, ''
                                                        , '', '', '', 0, 0);
                end;
            until RentAsset.Next = 0;

        TmpRentAvailabilityBuffer.Reset;
    end;

    local procedure InsertRentAssetAvailabilityEntry(var TmpRentAvailabilityBuffer: Record "Rent Availability Buffer" temporary; EntryNo: Integer; Type: Integer; RentItemNo: Code[20]; RentItemQuantity: Decimal; RentAssetNo: Code[20]; RentAssetQuantity: Decimal; Quantity: Decimal; StartingDate: Date; EndingDate: Date; LocationCode: Code[10]; CustomerNo: Code[20]; ServiceOrderNo: Code[20]; RentOrderNo: Code[20]; RentLineNo: Integer; RentOrderType: Option)
    begin
        TmpRentAvailabilityBuffer.Init;
        TmpRentAvailabilityBuffer."Entry No." := EntryNo;
        TmpRentAvailabilityBuffer.Type := Type;
        TmpRentAvailabilityBuffer."Rent Item No." := RentItemNo;
        TmpRentAvailabilityBuffer."Rent Item Total Qty." := RentItemQuantity;
        TmpRentAvailabilityBuffer."Rent Asset No." := RentAssetNo;
        TmpRentAvailabilityBuffer."Rent Asset Total Qty." := RentAssetQuantity;
        TmpRentAvailabilityBuffer.Quantity := Quantity;
        TmpRentAvailabilityBuffer."Starting Date" := StartingDate;
        TmpRentAvailabilityBuffer."Ending Date" := EndingDate;
        TmpRentAvailabilityBuffer."Location Code" := LocationCode;
        TmpRentAvailabilityBuffer."Customer No." := CustomerNo;
        TmpRentAvailabilityBuffer."Service Order No." := ServiceOrderNo;
        TmpRentAvailabilityBuffer."Rent Document No." := RentOrderNo;
        TmpRentAvailabilityBuffer."Rent Document Line No." := RentLineNo;
        TmpRentAvailabilityBuffer."Rent Document Type" := RentOrderType;
        TmpRentAvailabilityBuffer.Insert;
    end;
}

