Codeunit 25006319 "Purch. Line-Veh. Reserve"
{
    Permissions = TableData "Reservation Entry" = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text004: label 'Codeunit is not initialized correctly.';
        Location: Record Location;
        CreateReservEntry: Codeunit "Create Veh. Reserv. Entry";
        ReservEngineMgt: Codeunit "Veh. Reservation Engine Mgt.";
        ReservMgt: Codeunit "Veh. Reservation Management";
        Blocked: Boolean;
        SetFromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry";
        SetFromSubtype: Integer;
        SetFromID: Code[20];
        SetFromBatchName: Code[10];
        SetFromRefNo: Integer;
        SetFromLocationCode: Code[10];


    procedure CreateReservation(var PurchLine: Record "Purchase Line"; Description: Text[50])
    var
        ShipmentDate: Date;
        OutBoundQty: Decimal;
        SignFactor: Integer;
    begin
        if SetFromType = 0 then
            Error(Text004);

        PurchLine.TestField("Line Type", PurchLine."line type"::Vehicle);
        PurchLine.TestField("No.");
        PurchLine.TestField("Model Version No.");

        PurchLine.TestField("Location Code", SetFromLocationCode);

        if (PurchLine."Document Type" = PurchLine."document type"::"Return Order") then
            SignFactor := -1
        else
            SignFactor := 1;

        CreateReservEntry.CreateReservEntryFor(
          Database::"Purchase Line", PurchLine."Document Type".asinteger(),
          PurchLine."Document No.", '', PurchLine."Line No.", PurchLine.Quantity);
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromRefNo);
        CreateReservEntry.CreateReservEntry(
          PurchLine."No.", PurchLine."Variant Code", PurchLine."Location Code",
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


    procedure FilterReservFor(var FilterReservEntry: Record "Vehicle Reservation Entry"; PurchLine: Record "Purchase Line")
    begin
        FilterReservEntry.SetRange("Source Type", Database::"Purchase Line");
        FilterReservEntry.SetRange("Source Subtype", PurchLine."Document Type");
        FilterReservEntry.SetRange("Source ID", PurchLine."Document No.");
        FilterReservEntry.SetRange("Source Batch Name", '');
        FilterReservEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
    end;


    procedure ReservQuantity(PurchLine: Record "Purchase Line") QtyToReserve: Decimal
    begin
        case PurchLine."Document Type" of
            PurchLine."document type"::Quote,
          PurchLine."document type"::Order,
          PurchLine."document type"::Invoice,
          PurchLine."document type"::"Blanket Order":
                QtyToReserve := -PurchLine."Outstanding Qty. (Base)";
            PurchLine."document type"::"Return Order",
          PurchLine."document type"::"Credit Memo":
                QtyToReserve := PurchLine."Outstanding Qty. (Base)";
        end;
    end;


    procedure FindReservEntry(PurchLine: Record "Purchase Line"; var ReservEntry: Record "Vehicle Reservation Entry"): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, PurchLine);
        exit(ReservEntry.FindLast);
    end;


    procedure TransferPurchLineToItemJnlLine(var PurchLine: Record "Purchase Line"; var ItemJnlLine: Record "Item Journal Line")
    var
        OldReservEntry: Record "Vehicle Reservation Entry";
    begin
        if not FindReservEntry(PurchLine, OldReservEntry) then
            exit;

        OldReservEntry.Lock;


        ItemJnlLine.TestField("Item No.", PurchLine."No.");
        ItemJnlLine.TestField("Model Version No.", PurchLine."Model Version No.");
        ItemJnlLine.TestField("Vehicle Serial No.", PurchLine."Vehicle Serial No.");
        ItemJnlLine.TestField("Location Code", PurchLine."Location Code");


        if ItemJnlLine."Invoiced Quantity" <> 0 then
            CreateReservEntry.SetUseQtyToInvoice(true);

        if ReservEngineMgt.InitRecordSet(OldReservEntry) then
            repeat
                OldReservEntry.TestField("Model Version No.", PurchLine."No.");
                OldReservEntry.TestField("Vehicle Serial No.", PurchLine."Vehicle Serial No.");
                OldReservEntry.TestField("Location Code", PurchLine."Location Code");

                CreateReservEntry.TransferReservEntry(Database::"Item Journal Line",
                  ItemJnlLine."Entry Type".asinteger(), ItemJnlLine."Journal Template Name",
                  ItemJnlLine."Journal Batch Name", ItemJnlLine."Line No.",
                  OldReservEntry);

            until (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0);
    end;


    procedure TransferPurchLineToPurchLine(var OldPurchLine: Record "Purchase Line"; var NewPurchLine: Record "Purchase Line")
    var
        OldReservEntry: Record "Vehicle Reservation Entry";
    begin
        if not FindReservEntry(OldPurchLine, OldReservEntry) then
            exit;

        OldReservEntry.Lock;

        NewPurchLine.TestField("No.", OldPurchLine."No.");
        NewPurchLine.TestField("Model Version No.", OldPurchLine."Model Version No.");
        NewPurchLine.TestField("Vehicle Serial No.", OldPurchLine."Vehicle Serial No.");
        NewPurchLine.TestField("Location Code", OldPurchLine."Location Code");


        if OldReservEntry.FindSet then
            repeat
                OldReservEntry.TestField("Model Version No.", OldPurchLine."Model Version No.");
                OldReservEntry.TestField("Vehicle Serial No.", OldPurchLine."Vehicle Serial No.");
                OldReservEntry.TestField("Location Code", OldPurchLine."Location Code");

                CreateReservEntry.TransferReservEntry(Database::"Purchase Line",
                   NewPurchLine."Document Type".asinteger(), NewPurchLine."Document No.", '', NewPurchLine."Line No.",
                   OldReservEntry);

            until (OldReservEntry.Next = 0);
    end;


    procedure RenameLine(var NewPurchLine: Record "Purchase Line"; var OldPurchLine: Record "Purchase Line")
    begin
        ReservEngineMgt.RenamePointer(Database::"Purchase Line",
          OldPurchLine."Document Type".asinteger(),
          OldPurchLine."Document No.",
          '',
          OldPurchLine."Line No.",
          NewPurchLine."Document Type".asinteger(),
          NewPurchLine."Document No.",
          '',
          NewPurchLine."Line No.");
    end;


    procedure DeleteLine(var PurchLine: Record "Purchase Line")
    begin
        if Blocked then
            exit;

        ReservMgt.SetPurchLine(PurchLine);
        ReservMgt.DeleteReservEntries(true);
        PurchLine.CalcFields(Reserved);
    end;


    procedure Block(SetBlocked: Boolean)
    begin
        Blocked := SetBlocked;
    end;
}

