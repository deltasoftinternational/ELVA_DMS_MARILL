Codeunit 25006317 "Sales Line-Veh. Reserve"
{
    Permissions = TableData "Reservation Entry" = rimd,
                  TableData "Planning Assignment" = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text003: label 'must not be filled in when a quantity is reserved';
        Text004: label 'must not be changed when a quantity is reserved';
        Text005: label 'Codeunit is not initialized correctly.';
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
        Text105: label 'Vehicle is not available. It is reserved for another deal.';


    procedure CreateReservation(var SalesLine: Record "Sales Line"; Description: Text[50])
    var
        ShipmentDate: Date;
        OutBoundQty: Decimal;
        SignFactor: Integer;
    begin
        if SetFromType = 0 then
            Error(Text005);

        SalesLine.TestField("Line Type", SalesLine."line type"::Vehicle);
        SalesLine.TestField("No.");
        SalesLine.TestField("Model Version No.");
        SalesLine.TestField("Location Code", SetFromLocationCode);

        if (SalesLine."Document Type" = SalesLine."document type"::"Return Order") then
            SignFactor := 1
        else
            SignFactor := -1;

        CreateReservEntry.CreateReservEntryFor(
          Database::"Sales Line", SalesLine."Document Type".asinteger(),
          SalesLine."Document No.", '', SalesLine."Line No.", SalesLine.Quantity);
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromRefNo);
        CreateReservEntry.CreateReservEntry(
          SalesLine."No.", SalesLine."Vehicle Serial No.", SalesLine."Location Code",
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


    procedure FilterReservFor(var FilterReservEntry: Record "Vehicle Reservation Entry"; SalesLine: Record "Sales Line")
    begin
        FilterReservEntry.SetRange("Source Type", Database::"Sales Line");
        FilterReservEntry.SetRange("Source Subtype", SalesLine."Document Type");
        FilterReservEntry.SetRange("Source ID", SalesLine."Document No.");
        FilterReservEntry.SetRange("Source Batch Name", '');
        FilterReservEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
    end;


    procedure ReservQuantity(SalesLine: Record "Sales Line") QtyToReserve: Decimal
    begin
        case SalesLine."Document Type" of
            SalesLine."document type"::Quote,
          SalesLine."document type"::Order,
          SalesLine."document type"::Invoice,
          SalesLine."document type"::"Blanket Order":
                QtyToReserve := SalesLine."Outstanding Qty. (Base)";
            SalesLine."document type"::"Return Order",
          SalesLine."document type"::"Credit Memo":
                QtyToReserve := -SalesLine."Outstanding Qty. (Base)"
        end;
    end;


    procedure FindReservEntry(SalesLine: Record "Sales Line"; var ReservEntry: Record "Vehicle Reservation Entry"): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, SalesLine);
        exit(ReservEntry.FindLast);
    end;


    procedure VerifyChange(var NewSalesLine: Record "Sales Line"; var OldSalesLine: Record "Sales Line")
    var
        SalesLine: Record "Sales Line";
        TempReservEntry: Record "Vehicle Reservation Entry";
        ShowError: Boolean;
        HasError: Boolean;
    begin

        if (NewSalesLine.Type <> NewSalesLine.Type::Item) and (OldSalesLine.Type <> OldSalesLine.Type::Item) then
            exit;

        if (NewSalesLine."Line Type" <> NewSalesLine."line type"::Vehicle) and
           (OldSalesLine."Line Type" <> OldSalesLine."line type"::Vehicle) then
            exit;

        if Blocked then
            exit;

        if NewSalesLine."Line No." = 0 then
            if not SalesLine.Get(
                     NewSalesLine."Document Type", NewSalesLine."Document No.", NewSalesLine."Line No.")
            then
                exit;

        NewSalesLine.CalcFields(Reserved);
        ShowError := NewSalesLine.Reserved;

        if (NewSalesLine."Purchase Order No." <> '') then
            if ShowError then
                NewSalesLine.FieldError("Purchase Order No.", Text003)
            else
                HasError := NewSalesLine."Purchase Order No." <> OldSalesLine."Purchase Order No.";

        if (NewSalesLine."Purch. Order Line No." <> 0) then
            if ShowError then
                NewSalesLine.FieldError(
                  "Purch. Order Line No.", Text003)
            else
                HasError := NewSalesLine."Purch. Order Line No." <> OldSalesLine."Purch. Order Line No.";

        if NewSalesLine."Drop Shipment" <> OldSalesLine."Drop Shipment" then
            if ShowError and NewSalesLine."Drop Shipment" then
                NewSalesLine.FieldError("Drop Shipment", Text003)
            else
                HasError := true;

        if (NewSalesLine."No." <> OldSalesLine."No.") then
            if ShowError then
                NewSalesLine.FieldError("No.", Text004)
            else
                HasError := true;

        if (NewSalesLine."Vehicle Serial No." <> OldSalesLine."Vehicle Serial No.") then
            if ShowError then
                NewSalesLine.FieldError("Variant Code", Text004)
            else
                HasError := true;

        if (NewSalesLine."Location Code" <> OldSalesLine."Location Code") then
            if ShowError then
                NewSalesLine.FieldError("Location Code", Text004)
            else
                HasError := true;

        if NewSalesLine."Line No." <> OldSalesLine."Line No." then
            HasError := true;

        if HasError then
            if (NewSalesLine."No." <> OldSalesLine."No.") or
               FindReservEntry(NewSalesLine, TempReservEntry)
            then begin
                if (NewSalesLine."No." <> OldSalesLine."No.") then begin
                    ReservMgt.SetSalesLine(OldSalesLine);
                    ReservMgt.DeleteReservEntries(true);
                    ReservMgt.SetSalesLine(NewSalesLine);
                end else begin
                    ReservMgt.SetSalesLine(NewSalesLine);
                    ReservMgt.DeleteReservEntries(true);
                end;
            end;
    end;


    procedure VerifyQuantity(var NewSalesLine: Record "Sales Line"; var OldSalesLine: Record "Sales Line")
    var
        SalesLine: Record "Sales Line";
    begin

        if Blocked then
            exit;

        if not (NewSalesLine."Document Type" in
        [NewSalesLine."document type"::Quote, NewSalesLine."document type"::Order, NewSalesLine."document type"::"Return Order"])
then
            if NewSalesLine."Shipment No." = '' then
                exit;
        if NewSalesLine.Type <> NewSalesLine.Type::Item then
            exit;
        if NewSalesLine."Line No." = OldSalesLine."Line No." then
            if NewSalesLine."Quantity (Base)" = OldSalesLine."Quantity (Base)" then
                exit;
        if NewSalesLine."Line No." = 0 then
            if not SalesLine.Get(NewSalesLine."Document Type", NewSalesLine."Document No.", NewSalesLine."Line No.") then
                exit;
        ReservMgt.SetSalesLine(NewSalesLine);
        if NewSalesLine."Outstanding Qty. (Base)" * OldSalesLine."Outstanding Qty. (Base)" < 0 then
            ReservMgt.DeleteReservEntries(true)
        else
            ReservMgt.DeleteReservEntries(false);
    end;


    procedure TransferSalesLineToItemJnlLine(var SalesLine: Record "Sales Line"; var ItemJnlLine: Record "Item Journal Line")
    var
        OldReservEntry: Record "Vehicle Reservation Entry";
        OldReservEntry2: Record "Vehicle Reservation Entry";
    begin

        if not FindReservEntry(SalesLine, OldReservEntry) then
            exit;
        OldReservEntry.Lock;

        ItemJnlLine.TestField("Item No.", SalesLine."No.");
        ItemJnlLine.TestField("Model Version No.", SalesLine."Model Version No.");
        ItemJnlLine.TestField("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
        ItemJnlLine.TestField("Location Code", SalesLine."Location Code");


        if ItemJnlLine."Invoiced Quantity" <> 0 then
            CreateReservEntry.SetUseQtyToInvoice(true);

        OldReservEntry2 := OldReservEntry;

        if ReservEngineMgt.InitRecordSet(OldReservEntry) then
            repeat
                OldReservEntry.TestField("Model Version No.", SalesLine."No.");
                OldReservEntry.TestField("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
                OldReservEntry.TestField("Location Code", SalesLine."Location Code");

                OldReservEntry2.Get(OldReservEntry."Entry No.", not OldReservEntry.Positive);
                CreateReservEntry.TransferReservEntry(Database::"Item Journal Line",
                   ItemJnlLine."Entry Type".asinteger(), ItemJnlLine."Journal Template Name",
                   ItemJnlLine."Journal Batch Name", ItemJnlLine."Line No.",
                   OldReservEntry);

            until (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0);
    end;


    procedure RenameLine(var NewSalesLine: Record "Sales Line"; var OldSalesLine: Record "Sales Line")
    begin
        ReservEngineMgt.RenamePointer(Database::"Sales Line",
          OldSalesLine."Document Type".asinteger(),
          OldSalesLine."Document No.",
          '',
          OldSalesLine."Line No.",
          NewSalesLine."Document Type".asinteger(),
          NewSalesLine."Document No.",
          '',
          NewSalesLine."Line No.");
    end;


    procedure DeleteLine(var SalesLine: Record "Sales Line")
    begin
        ReservMgt.SetSalesLine(SalesLine);
        ReservMgt.DeleteReservEntries(true);
        SalesLine.CalcFields(Reserved);
    end;


    procedure Block(SetBlocked: Boolean)
    begin
        Blocked := SetBlocked;
    end;


    procedure CheckReservation(var SalesLine: Record "Sales Line")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ReservationEntry: Record "Vehicle Reservation Entry";
        ReservationEntry2: Record "Vehicle Reservation Entry";
    begin
        if SalesLine."Document Type" in [SalesLine."document type"::"Credit Memo", SalesLine."document type"::"Return Order"] then
            exit;

        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentkey("Item No.", Open, "Variant Code", Positive,
        "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.");
        ItemLedgerEntry.SetRange("Item No.", SalesLine."No.");
        ItemLedgerEntry.SetRange("Serial No.", SalesLine."Vehicle Serial No.");
        ItemLedgerEntry.SetRange(Open, true);
        if not ItemLedgerEntry.FindFirst then
            exit;

        ItemLedgerEntry.CalcFields(Reserved);
        if not ItemLedgerEntry.Reserved then
            exit;

        ReservationEntry.Reset;
        ReservationEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        ReservationEntry.SetRange("Source Type", Database::"Item Ledger Entry");
        ReservationEntry.SetRange("Source Ref. No.", ItemLedgerEntry."Entry No.");
        ReservationEntry.FindFirst;
        ReservationEntry2.Get(ReservationEntry."Entry No.", not ReservationEntry.Positive);
        if (ReservationEntry2."Source Type" <> Database::"Sales Line") or
           (ReservationEntry2."Source Subtype" <> SalesLine."Document Type".asinteger()) or
           (ReservationEntry2."Source ID" <> SalesLine."Document No.") or
           (ReservationEntry2."Source Ref. No." <> SalesLine."Line No.") then
            Error(Text105);
    end;
}

