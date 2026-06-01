Codeunit 25006320 "Item Jnl. Line-Veh. Reserve"
{
    Permissions = TableData "Reservation Entry" = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text005: label 'Codeunit is not initialized correctly.';
        ReservMgt: Codeunit "Veh. Reservation Management";
        CreateReservEntry: Codeunit "Create Veh. Reserv. Entry";
        ReservEngineMgt: Codeunit "Veh. Reservation Engine Mgt.";
        Blocked: Boolean;
        SetFromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry";
        SetFromSubtype: Integer;
        SetFromID: Code[20];
        SetFromBatchName: Code[10];
        SetFromRefNo: Integer;
        SetFromVehicleSerialNo: Code[20];
        SetFromLocationCode: Code[10];


    procedure CreateReservation(var ItemJnlLine: Record "Item Journal Line"; Description: Text[50])
    begin
        if SetFromType = 0 then
            Error(Text005);

        ItemJnlLine.TestField("Item No.");
        ItemJnlLine.TestField("Posting Date");
        ItemJnlLine.CalcFields(Reserved);

        ItemJnlLine.TestField("Location Code", SetFromLocationCode);
        ItemJnlLine.TestField("Vehicle Serial No.", SetFromVehicleSerialNo);


        CreateReservEntry.CreateReservEntryFor(
          Database::"Item Journal Line",
          ItemJnlLine."Entry Type".AsInteger(), ItemJnlLine."Journal Template Name",
          ItemJnlLine."Journal Batch Name", ItemJnlLine."Line No.", ItemJnlLine.Quantity);
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromRefNo);
        CreateReservEntry.CreateReservEntry(
          ItemJnlLine."Item No.", ItemJnlLine."Vehicle Serial No.", ItemJnlLine."Location Code",
          Description);

        SetFromType := 0;
    end;


    procedure CreateReservationSetFrom(FromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry"; FromSubtype: Integer; FromID: Code[20]; FromBatchName: Code[10]; FromRefNo: Integer; FromLocationCode: Code[10])
    begin
        SetFromType := FromType;
        SetFromSubtype := FromSubtype;
        SetFromID := FromID;
        SetFromBatchName := FromBatchName;
        SetFromRefNo := FromRefNo;
        SetFromLocationCode := FromLocationCode;
    end;


    procedure FilterReservFor(var FilterReservEntry: Record "Vehicle Reservation Entry"; ItemJnlLine: Record "Item Journal Line")
    begin

        FilterReservEntry.SetRange("Source Type", Database::"Item Journal Line");
        FilterReservEntry.SetRange("Source Subtype", ItemJnlLine."Entry Type");
        FilterReservEntry.SetRange("Source ID", ItemJnlLine."Journal Template Name");
        FilterReservEntry.SetRange("Source Batch Name", ItemJnlLine."Journal Batch Name");
        FilterReservEntry.SetRange("Source Ref. No.", ItemJnlLine."Line No.");
    end;


    procedure FindReservEntry(ItemJnlLine: Record "Item Journal Line"; var ReservEntry: Record "Vehicle Reservation Entry"): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, ItemJnlLine);
        exit(ReservEntry.FindLast);
    end;


    procedure TransferItemJnlToItemLedgEntry(var ItemJnlLine: Record "Item Journal Line"; var ItemLedgEntry: Record "Item Ledger Entry"; SkipInventory: Boolean)
    var
        OldReservEntry: Record "Vehicle Reservation Entry";
        OldReservEntry2: Record "Vehicle Reservation Entry";
        SkipThisRecord: Boolean;
    begin
        if not FindReservEntry(ItemJnlLine, OldReservEntry) then
            exit;

        OldReservEntry.Lock;

        ItemLedgEntry.TestField("Item No.", ItemJnlLine."Item No.");
        ItemLedgEntry.TestField("Serial No.", ItemJnlLine."Vehicle Serial No.");
        ItemLedgEntry.TestField("Model Version No.", ItemJnlLine."Model Version No.");

        if ItemJnlLine."Entry Type" = ItemJnlLine."entry type"::Transfer then begin
            ItemLedgEntry.TestField("Location Code", ItemJnlLine."New Location Code");
        end else begin
            ItemLedgEntry.TestField("Location Code", ItemJnlLine."Location Code");
        end;


        if OldReservEntry.FindSet then
            repeat
                OldReservEntry.TestField("Model Version No.", ItemJnlLine."Item No.");
                OldReservEntry.TestField("Vehicle Serial No.", ItemJnlLine."Vehicle Serial No.");

                if SkipInventory then begin
                    OldReservEntry2.Get(OldReservEntry."Entry No.", not OldReservEntry.Positive);
                    SkipThisRecord := OldReservEntry2."Source Type" = Database::"Item Ledger Entry";
                end;

                if not SkipThisRecord then begin
                    if ItemJnlLine."Entry Type" = ItemJnlLine."entry type"::Transfer then begin
                        if ItemLedgEntry.Quantity < 0 then
                            OldReservEntry.TestField("Location Code", ItemJnlLine."Location Code");
                        CreateReservEntry.SetInbound(true);
                    end else
                        OldReservEntry.TestField("Location Code", ItemJnlLine."Location Code");


                    CreateReservEntry.TransferReservEntry(
                      Database::"Item Ledger Entry", 0, '', '', ItemLedgEntry."Entry No.",
                      OldReservEntry);
                end
            until (OldReservEntry.Next = 0);
    end;


    procedure RenameLine(var NewItemJnlLine: Record "Item Journal Line"; var OldItemJnlLine: Record "Item Journal Line")
    begin
        ReservEngineMgt.RenamePointer(Database::"Item Journal Line",
          OldItemJnlLine."Entry Type".AsInteger(),
          OldItemJnlLine."Journal Template Name",
          OldItemJnlLine."Journal Batch Name",
          OldItemJnlLine."Line No.",
          NewItemJnlLine."Entry Type".AsInteger(),
          NewItemJnlLine."Journal Template Name",
          NewItemJnlLine."Journal Batch Name",
          NewItemJnlLine."Line No.");
    end;


    procedure DeleteLine(var ItemJnlLine: Record "Item Journal Line")
    begin
        if Blocked then
            exit;

        ReservMgt.SetItemJnlLine(ItemJnlLine);
        ReservMgt.DeleteReservEntries(true);
        ItemJnlLine.CalcFields("Reserved Qty. (Base)");
    end;


    procedure Block(SetBlocked: Boolean)
    begin
        Blocked := SetBlocked;
    end;
}

