Codeunit 25006321 "Transfer Line-Veh. Reserve"
{
    // 12.07.2013 EDMS P8
    //   * Code taken from C99000836

    Permissions = TableData "Reservation Entry" = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Codeunit is not initialized correctly.';
        Text001: label 'Reserved quantity cannot be greater than %1';
        Text002: label 'must be filled in when a quantity is reserved';
        Text003: label 'must not be changed when a quantity is reserved';
        ReservMgt: Codeunit "Veh. Reservation Management";
        CreateReservEntry: Codeunit "Create Veh. Reserv. Entry";
        ReservEngineMgt: Codeunit "Veh. Reservation Engine Mgt.";
        Blocked: Boolean;
        SetFromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry",Service,Job;
        SetFromSubtype: Integer;
        SetFromID: Code[20];
        SetFromBatchName: Code[10];
        SetFromProdOrderLine: Integer;
        SetFromRefNo: Integer;
        SetFromVariantCode: Code[10];
        SetFromLocationCode: Code[10];
        SetFromSerialNo: Code[20];
        SetFromLotNo: Code[20];
        SetFromQtyPerUOM: Decimal;
        DeleteItemTracking: Boolean;


    procedure CreateReservation(var TransLine: Record "Transfer Line"; Description: Text[50]; ExpectedReceiptDate: Date; Quantity: Decimal; QuantityBase: Decimal; Direction: Option Outbound,Inbound)
    var
        ShipmentDate: Date;
    begin
        if SetFromType = 0 then
            Error(Text000);


        TransLine.TestField("Model Version No.");
        TransLine.TestField("Item No.");
        //TransLine.TESTFIELD("Variant Code",SetFromVariantCode);


        case Direction of
            Direction::Outbound:
                begin
                    TransLine.TestField("Shipment Date");
                    TransLine.TestField("Transfer-from Code", SetFromLocationCode);
                    TransLine.CalcFields("Reserved Qty. Outbnd. (Base)");
                    if Abs(TransLine."Outstanding Qty. (Base)") <
                       Abs(TransLine."Reserved Qty. Outbnd. (Base)") + QuantityBase
                    then
                        Error(
                          Text001,
                          Abs(TransLine."Outstanding Qty. (Base)") - Abs(TransLine."Reserved Qty. Outbnd. (Base)"));
                    ShipmentDate := TransLine."Shipment Date";
                end;
            Direction::Inbound:
                begin
                    TransLine.TestField("Receipt Date");
                    TransLine.TestField("Transfer-to Code", SetFromLocationCode);
                    TransLine.CalcFields("Reserved Qty. Inbnd. (Base)");
                    if Abs(TransLine."Outstanding Qty. (Base)") <
                       Abs(TransLine."Reserved Qty. Inbnd. (Base)") + QuantityBase
                    then
                        Error(
                          Text001,
                          Abs(TransLine."Outstanding Qty. (Base)") - Abs(TransLine."Reserved Qty. Inbnd. (Base)"));
                    ExpectedReceiptDate := TransLine."Receipt Date";
                end;
        end;
        CreateReservEntry.CreateReservEntryFor(
          Database::"Transfer Line",
          Direction,
          TransLine."Document No.",
          '',
          TransLine."Line No.",
          Quantity);
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromRefNo);
        CreateReservEntry.CreateReservEntry(
          TransLine."Model Version No.",
          TransLine."Vehicle Serial No.",
          SetFromLocationCode,
          Description);

        SetFromType := 0;
    end;


    procedure CreateReservationSetFrom(FromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry",Service,Job; FromSubtype: Integer; FromID: Code[20]; FromBatchName: Code[10]; FromRefNo: Integer; FromLocationCode: Code[10])
    begin
        SetFromType := FromType;
        SetFromSubtype := FromSubtype;
        SetFromID := FromID;
        SetFromBatchName := FromBatchName;
        SetFromRefNo := FromRefNo;
        SetFromLocationCode := FromLocationCode;
    end;


    procedure FilterReservFor(var FilterReservEntry: Record "Vehicle Reservation Entry"; TransLine: Record "Transfer Line"; Direction: Option Outbound,Inbound)
    begin
        FilterReservEntry.SetRange("Source Type", Database::"Transfer Line");
        FilterReservEntry.SetRange("Source Subtype", Direction);
        FilterReservEntry.SetRange("Source ID", TransLine."Document No.");
        FilterReservEntry.SetRange("Source Batch Name", '');
        FilterReservEntry.SetRange("Source Ref. No.", TransLine."Line No.");
    end;


    procedure Caption(TransLine: Record "Transfer Line") CaptionText: Text[80]
    begin
        CaptionText :=
          StrSubstNo(
            '%1 %2 %3', TransLine."Document No.", TransLine."Line No.",
            TransLine."Item No.");
    end;


    procedure FindReservEntry(TransLine: Record "Transfer Line"; var ReservEntry: Record "Vehicle Reservation Entry"; Direction: Option Outbound,Inbound): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, TransLine, Direction);
        exit(ReservEntry.FindLast);
    end;


    procedure ReservEntryExist(TransLine: Record "Transfer Line"): Boolean
    var
        ReservEntry: Record "Vehicle Reservation Entry";
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, TransLine, 0);
        ReservEntry.SetRange("Source Subtype"); // Ignore direction
        exit(not ReservEntry.IsEmpty);
    end;


    procedure VerifyChange(var NewTransLine: Record "Transfer Line"; var OldTransLine: Record "Transfer Line")
    var
        TransLine: Record "Transfer Line";
        TempReservEntry: Record "Vehicle Reservation Entry";
        ShowErrorInbnd: Boolean;
        ShowErrorOutbnd: Boolean;
        HasErrorInbnd: Boolean;
        HasErrorOutbnd: Boolean;
    begin
        if Blocked then
            exit;
        if NewTransLine."Line No." = 0 then
            if not TransLine.Get(NewTransLine."Document No.", NewTransLine."Line No.") then
                exit;

        NewTransLine.CalcFields("Reserved Qty. Inbnd. (Base)");
        NewTransLine.CalcFields("Reserved Qty. Outbnd. (Base)");

        ShowErrorInbnd := (NewTransLine."Reserved Qty. Inbnd. (Base)" <> 0);
        ShowErrorOutbnd := (NewTransLine."Reserved Qty. Outbnd. (Base)" <> 0);

        if NewTransLine."Shipment Date" = 0D then
            if ShowErrorOutbnd then
                NewTransLine.FieldError("Shipment Date", Text002)
            else
                HasErrorOutbnd := true;

        if NewTransLine."Receipt Date" = 0D then
            if ShowErrorInbnd then
                NewTransLine.FieldError("Receipt Date", Text002)
            else
                HasErrorInbnd := true;

        if NewTransLine."Item No." <> OldTransLine."Item No." then
            if ShowErrorInbnd or ShowErrorOutbnd then
                NewTransLine.FieldError("Item No.", Text003)
            else begin
                HasErrorInbnd := true;
                HasErrorOutbnd := true;
            end;

        if NewTransLine."Transfer-from Code" <> OldTransLine."Transfer-from Code" then
            if ShowErrorOutbnd then
                NewTransLine.FieldError("Transfer-from Code", Text003)
            else
                HasErrorOutbnd := true;

        if NewTransLine."Transfer-to Code" <> OldTransLine."Transfer-to Code" then
            if ShowErrorInbnd then
                NewTransLine.FieldError("Transfer-to Code", Text003)
            else
                HasErrorInbnd := true;

        if NewTransLine."Transfer-from Bin Code" <> OldTransLine."Transfer-from Bin Code" then
            if ShowErrorOutbnd then
                NewTransLine.FieldError("Transfer-from Bin Code", Text003)
            else
                HasErrorOutbnd := true;

        if NewTransLine."Transfer-To Bin Code" <> OldTransLine."Transfer-To Bin Code" then
            if ShowErrorInbnd then
                NewTransLine.FieldError("Transfer-To Bin Code", Text003)
            else
                HasErrorInbnd := true;

        if NewTransLine."Variant Code" <> OldTransLine."Variant Code" then
            if ShowErrorInbnd or ShowErrorOutbnd then
                NewTransLine.FieldError("Variant Code", Text003)
            else begin
                HasErrorInbnd := true;
                HasErrorOutbnd := true;
            end;

        if NewTransLine."Line No." <> OldTransLine."Line No." then begin
            HasErrorInbnd := true;
            HasErrorOutbnd := true;
        end;

        if HasErrorOutbnd then begin
            if (NewTransLine."Item No." <> OldTransLine."Item No.") or
               FindReservEntry(NewTransLine, TempReservEntry, 0)
            then begin
                if NewTransLine."Item No." <> OldTransLine."Item No." then begin
                    ReservMgt.SetTransferLine(OldTransLine, 0);
                    ReservMgt.DeleteReservEntries(true);
                    ReservMgt.SetTransferLine(NewTransLine, 0);
                end else begin
                    ReservMgt.SetTransferLine(NewTransLine, 0);
                    ReservMgt.DeleteReservEntries(true);
                end;
            end;
            AssignForPlanning(NewTransLine, 0);
            if (NewTransLine."Item No." <> OldTransLine."Item No.") or
               (NewTransLine."Variant Code" <> OldTransLine."Variant Code") or
               (NewTransLine."Transfer-to Code" <> OldTransLine."Transfer-to Code")
            then
                AssignForPlanning(OldTransLine, 0);
        end;

        if HasErrorInbnd then begin
            if (NewTransLine."Item No." <> OldTransLine."Item No.") or
               FindReservEntry(NewTransLine, TempReservEntry, 1)
            then begin
                if NewTransLine."Item No." <> OldTransLine."Item No." then begin
                    ReservMgt.SetTransferLine(OldTransLine, 1);
                    ReservMgt.DeleteReservEntries(true);
                    ReservMgt.SetTransferLine(NewTransLine, 1);
                end else begin
                    ReservMgt.SetTransferLine(NewTransLine, 1);
                    ReservMgt.DeleteReservEntries(true);
                end;
            end;
            AssignForPlanning(NewTransLine, 1);
            if (NewTransLine."Item No." <> OldTransLine."Item No.") or
               (NewTransLine."Variant Code" <> OldTransLine."Variant Code") or
               (NewTransLine."Transfer-from Code" <> OldTransLine."Transfer-from Code")
            then
                AssignForPlanning(OldTransLine, 1);
        end;
    end;


    procedure VerifyQuantity(var NewTransLine: Record "Transfer Line"; var OldTransLine: Record "Transfer Line")
    var
        TransLine: Record "Transfer Line";
        Direction: Option Outbound,Inbound;
    begin
        if Blocked then
            exit;

        if NewTransLine."Line No." = OldTransLine."Line No." then
            if NewTransLine."Quantity (Base)" = OldTransLine."Quantity (Base)" then
                exit;
        if NewTransLine."Line No." = 0 then
            if not TransLine.Get(NewTransLine."Document No.", NewTransLine."Line No.") then
                exit;
        for Direction := Direction::Outbound to Direction::Inbound do begin
            ReservMgt.SetTransferLine(NewTransLine, Direction);
            //IF "Qty. per Unit of Measure" <> OldTransLine."Qty. per Unit of Measure" THEN
            //ReservMgt.ModifyUnitOfMeasure;
            ReservMgt.DeleteReservEntries(false);
            AssignForPlanning(NewTransLine, Direction);
        end;
    end;


    procedure UpdatePlanningFlexibility(var TransLine: Record "Transfer Line")
    var
        ReservEntry: Record "Vehicle Reservation Entry";
    begin
        //IF FindReservEntry(TransLine,ReservEntry,0) THEN
        //ReservEntry.MODIFYALL("Planning Flexibility",TransLine."Planning Flexibility");
        //IF FindReservEntry(TransLine,ReservEntry,1) THEN
        //ReservEntry.MODIFYALL("Planning Flexibility",TransLine."Planning Flexibility");
    end;


    procedure TransferTransferToItemJnlLine(var TransLine: Record "Transfer Line"; var ItemJnlLine: Record "Item Journal Line"; TransferQty: Decimal; Direction: Option Outbound,Inbound)
    var
        OldReservEntry: Record "Vehicle Reservation Entry";
        TransferLocation: Code[10];
    begin
        if not FindReservEntry(TransLine, OldReservEntry, Direction) then
            exit;

        OldReservEntry.Lock;

        case Direction of
            Direction::Outbound:
                begin
                    TransferLocation := TransLine."Transfer-from Code";
                    ItemJnlLine.TestField("Location Code", TransferLocation);
                end;
            Direction::Inbound:
                begin
                    TransferLocation := TransLine."Transfer-to Code";
                    ItemJnlLine.TestField("New Location Code", TransferLocation);
                end;
        end;

        ItemJnlLine.TestField("Item No.", TransLine."Item No.");
        ItemJnlLine.TestField("Variant Code", TransLine."Variant Code");

        if TransferQty = 0 then
            exit;
        if ReservEngineMgt.InitRecordSet(OldReservEntry) then
            repeat
                OldReservEntry.TestField("Model Version No.", TransLine."Model Version No.");
                OldReservEntry.TestField("Vehicle Serial No.", TransLine."Vehicle Serial No.");
                OldReservEntry.TestField("Location Code", TransferLocation);

                CreateReservEntry.TransferReservEntry(Database::"Item Journal Line",
                    ItemJnlLine."Entry Type".AsInteger(),
                    ItemJnlLine."Journal Template Name",
                    ItemJnlLine."Journal Batch Name",
                    ItemJnlLine."Line No.",
                    OldReservEntry);

            until (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) or (TransferQty = 0);
    end;


    procedure RenameLine(var NewTransLine: Record "Transfer Line"; var OldTransLine: Record "Transfer Line")
    begin
        ReservEngineMgt.RenamePointer(Database::"Transfer Line",
          0,
          OldTransLine."Document No.",
          '',
          OldTransLine."Line No.",
          0,
          NewTransLine."Document No.",
          '',
          NewTransLine."Line No.");
    end;


    procedure DeleteLineConfirm(var TransLine: Record "Transfer Line"): Boolean
    begin
        if not TransLine.ReservEntryExist() then
            exit(true);

        ReservMgt.SetTransferLine(TransLine, 0);

        exit(true);
    end;


    procedure DeleteLine(var TransLine: Record "Transfer Line")
    begin
        if Blocked then
            exit;

        ReservMgt.SetTransferLine(TransLine, 0);
        ReservMgt.DeleteReservEntries(true);

        ReservMgt.SetTransferLine(TransLine, 1);
        ReservMgt.DeleteReservEntries(true);
    end;


    procedure AssignForPlanning(var TransLine: Record "Transfer Line"; Direction: Option Outbound,Inbound)
    var
        PlanningAssignment: Record "Planning Assignment";
    begin
        if TransLine."Item No." <> '' then
            case Direction of
                Direction::Outbound:
                    PlanningAssignment.ChkAssignOne(TransLine."Item No.", TransLine."Variant Code", TransLine."Transfer-to Code", TransLine."Shipment Date");
                Direction::Inbound:
                    PlanningAssignment.ChkAssignOne(TransLine."Item No.", TransLine."Variant Code", TransLine."Transfer-from Code", TransLine."Receipt Date");
            end;
    end;


    procedure Block(SetBlocked: Boolean)
    begin
        Blocked := SetBlocked;
    end;
}

