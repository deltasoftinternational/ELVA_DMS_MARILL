Codeunit 25006318 "Req. Line-Veh. Reserve"
{
    Permissions = TableData "Reservation Entry" = rimd,
                  TableData "Action Message Entry" = rmd;

    trigger OnRun()
    begin
    end;

    var
        Text005: label 'Codeunit is not initialized correctly.';
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


    procedure CreateReservation(var ReqLine: Record "Requisition Line"; Description: Text[50])
    var
        ShipmentDate: Date;
    begin
        if SetFromType = 0 then
            Error(Text005);

        ReqLine.TestField(Type, ReqLine.Type::Item);
        ReqLine.TestField("No.");
        ReqLine.TestField("Model Version No.");

        ReqLine.TestField("Location Code", SetFromLocationCode);


        CreateReservEntry.CreateReservEntryFor(
          Database::"Requisition Line", 0,
          ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name", 0, ReqLine."Line No.");
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromRefNo);
        CreateReservEntry.CreateReservEntry(
          ReqLine."No.", ReqLine."Vehicle Serial No.", ReqLine."Location Code",
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


    procedure FilterReservFor(var FilterReservEntry: Record "Vehicle Reservation Entry"; ReqLine: Record "Requisition Line")
    begin
        FilterReservEntry.SetRange("Source Type", Database::"Requisition Line");
        FilterReservEntry.SetRange("Source Subtype", 0);
        FilterReservEntry.SetRange("Source ID", ReqLine."Worksheet Template Name");
        FilterReservEntry.SetRange("Source Batch Name", ReqLine."Journal Batch Name");
        FilterReservEntry.SetRange("Source Ref. No.", ReqLine."Line No.");
    end;


    procedure FindReservEntry(ReqLine: Record "Requisition Line"; var ReservEntry: Record "Vehicle Reservation Entry"): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, ReqLine);
        exit(ReservEntry.FindLast);
    end;


    procedure TransferReqLineToPurchLine(var ReqLine: Record "Requisition Line"; var PurchLine: Record "Purchase Line")
    var
        OldReservEntry: Record "Vehicle Reservation Entry";
        OldReservEntry2: Record "Vehicle Reservation Entry";
        NewReservEntry: Record "Vehicle Reservation Entry";
    begin
        if not FindReservEntry(ReqLine, OldReservEntry) then
            exit;

        OldReservEntry.Lock;

        PurchLine.TestField("No.", ReqLine."No.");
        PurchLine.TestField("Variant Code", ReqLine."Variant Code");
        PurchLine.TestField("Location Code", ReqLine."Location Code");

        OldReservEntry.FindSet;

        repeat
            OldReservEntry.TestField("Model Version No.", ReqLine."Model Version No.");
            OldReservEntry.TestField("Vehicle Serial No.", ReqLine."Vehicle Serial No.");
            OldReservEntry.TestField("Location Code", ReqLine."Location Code");

            NewReservEntry := OldReservEntry;
            NewReservEntry."Source Type" := Database::"Purchase Line";
            NewReservEntry."Source Subtype" := PurchLine."Document Type";
            NewReservEntry."Source ID" := PurchLine."Document No.";
            NewReservEntry."Source Batch Name" := '';
            NewReservEntry."Source Ref. No." := PurchLine."Line No.";

            if OldReservEntry2.Get(OldReservEntry."Entry No.", not OldReservEntry.Positive) then begin
                if CreateReservEntry.HasSamePointer(OldReservEntry2, NewReservEntry) then begin
                    OldReservEntry2.Delete;
                    NewReservEntry.Delete;
                end else
                    NewReservEntry.Modify;
            end else
                NewReservEntry.Modify;

        until OldReservEntry.Next = 0;
    end;


    procedure DeleteLine(var ReqLine: Record "Requisition Line")
    begin
        if Blocked then
            exit;

        ReservMgt.SetReqLine(ReqLine);
        ReservMgt.DeleteReservEntries(true);
    end;
}

