Codeunit 25006300 "Veh. Reservation Management"
{
    Permissions = TableData "Item Ledger Entry" = rm,
                  TableData "Vehicle Reservation Entry" = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text003: label 'CU99000845: CalculateRemainingQty - Source type missing';
        Text006: label 'Outbound,Inbound';
        CalcReservEntry: Record "Vehicle Reservation Entry";
        CalcReservEntry2: Record "Vehicle Reservation Entry";
        ForItemLedgEntry: Record "Item Ledger Entry";
        CalcItemLedgEntry: Record "Item Ledger Entry";
        ForSalesLine: Record "Sales Line";
        CalcSalesLine: Record "Sales Line";
        ForPurchLine: Record "Purchase Line";
        CalcPurchLine: Record "Purchase Line";
        ForItemJnlLine: Record "Item Journal Line";
        ForReqLine: Record "Requisition Line";
        CalcReqLine: Record "Requisition Line";
        ForTransLine: Record "Transfer Line";
        CalcTransLine: Record "Transfer Line";
        ModelVersion: Record Item;
        Location: Record Location;
        CreateReservEntry: Codeunit "Create Veh. Reserv. Entry";
        ReservEngineMgt: Codeunit "Veh. Reservation Engine Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
        ReserveReqLine: Codeunit "Req. Line-Veh. Reserve";
        ReservePurchLine: Codeunit "Purch. Line-Veh. Reserve";
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Veh. Reserve";
        ReserveTransLine: Codeunit "Transfer Line-Veh. Reserve";
        Positive: Boolean;
        FieldFilter: Text[80];
        ValueArray: array[18] of Integer;
        CurrentBinding: Option ,"Order-to-Order";


    procedure IsPositive(): Boolean
    begin
        exit(Positive);
    end;


    procedure FormatQty(Quantity: Decimal): Decimal
    begin
        if Positive then
            exit(Quantity);

        exit(-Quantity);
    end;


    procedure SetSalesLine(NewSalesLine: Record "Sales Line")
    begin
        ClearAll;

        ForSalesLine := NewSalesLine;

        CalcReservEntry."Source Type" := Database::"Sales Line";
        CalcReservEntry."Source Subtype" := ForSalesLine."Document Type";
        CalcReservEntry."Source ID" := NewSalesLine."Document No.";
        CalcReservEntry."Source Ref. No." := NewSalesLine."Line No.";

        CalcReservEntry."Model Version No." := NewSalesLine."Model Version No.";
        CalcReservEntry."Vehicle Serial No." := NewSalesLine."Vehicle Serial No.";

        CalcReservEntry."Location Code" := NewSalesLine."Location Code";

        CalcReservEntry.Description := NewSalesLine.Description;
        CalcReservEntry2 := CalcReservEntry;

        GetModelVersionSetup(CalcReservEntry);

        Positive :=
          ((CreateReservEntry.SignFactor(CalcReservEntry) * ForSalesLine."Outstanding Qty. (Base)") <= 0);
        GetModelVersionSetup(CalcReservEntry);

        SetPointerFilter(CalcReservEntry2);
    end;


    procedure SetReqLine(NewReqLine: Record "Requisition Line")
    begin

        ClearAll;

        ForReqLine := NewReqLine;

        CalcReservEntry."Source Type" := Database::"Requisition Line";
        CalcReservEntry."Source ID" := NewReqLine."Worksheet Template Name";
        CalcReservEntry."Source Batch Name" := NewReqLine."Journal Batch Name";
        CalcReservEntry."Source Ref. No." := NewReqLine."Line No.";

        CalcReservEntry."Model Version No." := NewReqLine."No.";
        CalcReservEntry."Vehicle Serial No." := NewReqLine."Vehicle Serial No.";

        CalcReservEntry."Location Code" := NewReqLine."Location Code";
        CalcReservEntry.Description := NewReqLine.Description;

        CalcReservEntry2 := CalcReservEntry;

        Positive := ForReqLine."Net Quantity (Base)" < 0;

        GetModelVersionSetup(CalcReservEntry);

        SetPointerFilter(CalcReservEntry2);
    end;


    procedure SetPurchLine(NewPurchLine: Record "Purchase Line")
    begin
        ClearAll;
        ForPurchLine := NewPurchLine;

        CalcReservEntry."Source Type" := Database::"Purchase Line";
        CalcReservEntry."Source Subtype" := ForPurchLine."Document Type";
        CalcReservEntry."Source ID" := NewPurchLine."Document No.";
        CalcReservEntry."Source Ref. No." := NewPurchLine."Line No.";

        CalcReservEntry."Model Version No." := NewPurchLine."Model Version No.";
        CalcReservEntry."Vehicle Serial No." := NewPurchLine."Vehicle Serial No.";
        CalcReservEntry."Location Code" := NewPurchLine."Location Code";

        CalcReservEntry.Description := NewPurchLine.Description;

        CalcReservEntry2 := CalcReservEntry;

        GetModelVersionSetup(CalcReservEntry);

        Positive :=
          ((CreateReservEntry.SignFactor(CalcReservEntry) * ForPurchLine."Outstanding Qty. (Base)") < 0);

        SetPointerFilter(CalcReservEntry2);
    end;


    procedure SetItemJnlLine(NewItemJnlLine: Record "Item Journal Line")
    begin
        ClearAll;
        ForItemJnlLine := NewItemJnlLine;

        CalcReservEntry."Source Type" := Database::"Item Journal Line";
        CalcReservEntry."Source Subtype" := ForItemJnlLine."Entry Type";
        CalcReservEntry."Source ID" := NewItemJnlLine."Journal Template Name";
        CalcReservEntry."Source Batch Name" := NewItemJnlLine."Journal Batch Name";
        CalcReservEntry."Source Ref. No." := NewItemJnlLine."Line No.";

        CalcReservEntry."Model Version No." := NewItemJnlLine."Model Version No.";
        CalcReservEntry."Vehicle Serial No." := NewItemJnlLine."Vehicle Serial No.";
        CalcReservEntry."Location Code" := NewItemJnlLine."Location Code";

        CalcReservEntry.Description := NewItemJnlLine.Description;

        CalcReservEntry2 := CalcReservEntry;

        GetModelVersionSetup(CalcReservEntry);

        Positive :=
          ((CreateReservEntry.SignFactor(CalcReservEntry) * ForItemJnlLine."Quantity (Base)") < 0);

        SetPointerFilter(CalcReservEntry2);
    end;


    procedure SetItemLedgEntry(NewItemLedgEntry: Record "Item Ledger Entry")
    begin
        ClearAll;

        ForItemLedgEntry := NewItemLedgEntry;

        CalcReservEntry."Source Type" := Database::"Item Ledger Entry";
        CalcReservEntry."Source Ref. No." := NewItemLedgEntry."Entry No.";

        CalcReservEntry."Model Version No." := NewItemLedgEntry."Model Version No.";
        CalcReservEntry."Vehicle Serial No." := NewItemLedgEntry."Serial No.";
        CalcReservEntry."Location Code" := NewItemLedgEntry."Location Code";

        CalcReservEntry.Description := NewItemLedgEntry.Description;

        Positive := ForItemLedgEntry."Remaining Quantity" <= 0;

        CalcReservEntry2 := CalcReservEntry;

        GetModelVersionSetup(CalcReservEntry);

        SetPointerFilter(CalcReservEntry2);
    end;


    procedure SetTransferLine(NewTransLine: Record "Transfer Line"; Direction: Option Outbound,Inbound)
    begin
        ClearAll;

        ForTransLine := NewTransLine;

        CalcReservEntry."Source Type" := Database::"Transfer Line";
        CalcReservEntry."Source Subtype" := Direction;
        CalcReservEntry."Source ID" := NewTransLine."Document No.";
        CalcReservEntry."Source Ref. No." := NewTransLine."Line No.";

        CalcReservEntry."Model Version No." := NewTransLine."Model Version No.";
        CalcReservEntry."Vehicle Serial No." := NewTransLine."Vehicle Serial No.";
        case Direction of
            Direction::Outbound:
                begin
                    CalcReservEntry."Location Code" := NewTransLine."Transfer-from Code";
                end;
            Direction::Inbound:
                begin
                    CalcReservEntry."Location Code" := NewTransLine."Transfer-to Code";
                end;

        end;

        CalcReservEntry.Description := NewTransLine.Description;
        CalcReservEntry2 := CalcReservEntry;

        GetModelVersionSetup(CalcReservEntry);

        Positive :=
          ((CreateReservEntry.SignFactor(CalcReservEntry) * ForTransLine."Outstanding Qty. (Base)") <= 0);
        GetModelVersionSetup(CalcReservEntry);

        SetPointerFilter(CalcReservEntry2);
    end;


    procedure UpdateStatistics(var ReservSummEntry: Record "Vehicle Reserv. Entry Summary")
    var
        ReservEntry: Record "Vehicle Reservation Entry";
        i: Integer;
        CurrentEntryNo: Integer;
        ValueArrayNo: Integer;
        CalcSumValue: Decimal;
        CurrReservedQty: Decimal;
        NewEntryNo: Integer;
        ReservForm: Page "Vehicle Reservation";
    begin

        CurrentEntryNo := ReservSummEntry.Sequence;
        CalcReservEntry.TestField("Source Type");
        ReservSummEntry.DeleteAll;
        NewEntryNo := 0;

        for i := 1 to SetValueArray do begin
            CalcSumValue := 0;

            case ValueArray[i] of
                1: // Item Ledger Entry
                    if CalcItemLedgEntry.ReadPermission
                    then begin
                        InitFilter(ValueArray[i]);
                        if CalcItemLedgEntry.FindSet then
                            repeat
                                CalcItemLedgEntry.CalcFields(Reserved);
                                CalcSumValue := CalcItemLedgEntry."Remaining Quantity";
                                if CalcSumValue <> 0 then
                                    if (CalcSumValue > 0) = Positive then begin
                                        Clear(ReservForm);
                                        ReservForm.SetReservEntry(CalcReservEntry);
                                        //CurrReservedQty := ReservForm.ReservedThisLine(ReservSummEntry);

                                        ReservSummEntry.Init;
                                        NewEntryNo += 1;
                                        ReservSummEntry."Entry No." := NewEntryNo;
                                        ReservSummEntry.Sequence := ValueArray[i];
                                        ReservSummEntry."Source Type" := Database::"Item Ledger Entry";
                                        ReservSummEntry."Source Ref. No." := CalcItemLedgEntry."Entry No.";
                                        ReservSummEntry.Description :=
                                         CopyStr(CalcItemLedgEntry.TableCaption, 1, MaxStrLen(ReservSummEntry.Description));
                                        ReservSummEntry.Insert;
                                    end;
                            until CalcItemLedgEntry.Next = 0;
                    end;
                12, 16: // Purchase Order, Purchase Return Order
                    if CalcPurchLine.ReadPermission
                    then begin
                        InitFilter(ValueArray[i]);
                        if CalcPurchLine.FindSet then
                            repeat
                                CalcPurchLine.CalcFields(Reserved);
                                CalcSumValue := CalcPurchLine."Outstanding Qty. (Base)";
                                if CalcSumValue <> 0 then
                                    if (Positive = (CalcSumValue > 0)) and (ValueArray[i] <> 16) or
                                       (Positive = (CalcSumValue < 0)) and (ValueArray[i] = 16)
                                    then begin
                                        ReservSummEntry.Init;
                                        NewEntryNo += 1;
                                        ReservSummEntry."Entry No." := NewEntryNo;
                                        ReservSummEntry.Sequence := ValueArray[i];
                                        ReservSummEntry."Source Type" := Database::"Purchase Line";
                                        ReservSummEntry."Source Subtype" := CalcPurchLine."Document Type";
                                        ReservSummEntry."Source ID" := CalcPurchLine."Document No.";
                                        ReservSummEntry."Source Ref. No." := CalcPurchLine."Line No.";
                                        ReservSummEntry.Description :=
                                           CopyStr(
                                             StrSubstNo('%1, %2', CalcPurchLine.TableCaption, CalcPurchLine."Document Type"),
                                             1, MaxStrLen(ReservSummEntry.Description));
                                        ReservSummEntry.Insert;
                                    end;
                            until CalcPurchLine.Next = 0;
                    end;
                32, 36: // Sales Order, Sales Return Order
                    if CalcSalesLine.ReadPermission
                    then begin
                        InitFilter(ValueArray[i]);
                        if CalcSalesLine.FindSet then
                            repeat
                                CalcSalesLine.CalcFields(Reserved);
                                CalcSumValue := CalcSalesLine."Outstanding Qty. (Base)";
                                if CalcSumValue <> 0 then
                                    if (Positive = (CalcSumValue < 0)) and (ValueArray[i] <> 36) or
                                       (Positive = (CalcSumValue > 0)) and (ValueArray[i] = 36)
                                    then begin
                                        ReservSummEntry.Init;
                                        NewEntryNo += 1;
                                        ReservSummEntry."Entry No." := NewEntryNo;
                                        ReservSummEntry.Sequence := ValueArray[i];
                                        ReservSummEntry."Source Type" := Database::"Sales Line";
                                        ReservSummEntry."Source Subtype" := CalcSalesLine."Document Type";
                                        ReservSummEntry."Source ID" := CalcSalesLine."Document No.";
                                        ReservSummEntry."Source Ref. No." := CalcSalesLine."Line No.";

                                        ReservSummEntry.Description :=
                                          CopyStr(
                                            StrSubstNo('%1, %2', CalcSalesLine.TableCaption, CalcSalesLine."Document Type"),
                                            1, MaxStrLen(ReservSummEntry.Description));
                                        ReservSummEntry.Insert;
                                    end;
                            until CalcSalesLine.Next = 0;

                    end;
                101, 102: // Transfer Line
                    if CalcTransLine.ReadPermission then begin
                        InitFilter(ValueArray[i]);
                        if CalcTransLine.FindSet then
                            repeat
                                case ValueArray[i] of
                                    101:
                                        begin
                                            CalcTransLine.CalcFields("Reserved Outbound");
                                            CalcSumValue := -CalcTransLine."Outstanding Qty. (Base)";
                                        end;
                                    102:
                                        begin
                                            CalcTransLine.CalcFields("Reserved Inbound");
                                            CalcSumValue := CalcTransLine."Outstanding Qty. (Base)";
                                        end;
                                end;
                                if CalcSumValue <> 0 then
                                    if (CalcSumValue > 0) = Positive then begin
                                        ReservSummEntry.Init;
                                        NewEntryNo += 1;
                                        ReservSummEntry."Entry No." := NewEntryNo;
                                        ReservSummEntry.Sequence := ValueArray[i];
                                        ReservSummEntry."Source Type" := Database::"Transfer Line";
                                        ReservSummEntry."Source ID" := CalcTransLine."Document No.";
                                        ReservSummEntry."Source Ref. No." := CalcTransLine."Line No.";

                                        ReservSummEntry.Description :=
                                          CopyStr(
                                            StrSubstNo('%1, %2', CalcTransLine.TableCaption, SelectStr(ValueArray[i] - 100, Text006)),
                                            1, MaxStrLen(ReservSummEntry.Description));
                                        ReservSummEntry.Insert;
                                    end;
                            until CalcTransLine.Next = 0;
                    end;
            end;
        end;
        if not ReservSummEntry.Get(CurrentEntryNo) then;
    end;


    procedure AutoReserve(var FullAutoReservation: Boolean; Description: Text[50]; MaxQtyToReserve: Decimal)
    var
        ReservSummEntry: Record "Vehicle Reserv. Entry Summary" temporary;
        RemainingQtyToReserve: Decimal;
        i: Integer;
        StopReservation: Boolean;
    begin
        CalcReservEntry.TestField("Source Type");

        if CalcReservEntry."Source Type" in [Database::"Sales Line", Database::"Purchase Line"] then
            StopReservation := not (CalcReservEntry."Source Subtype" in [1, 5]); // Only order and return order

        if (CalcReservEntry."Source Type" = Database::"Sales Line") then
            if ((CalcReservEntry."Source Subtype" = 1) and (ForSalesLine.Quantity < 0)) then
                StopReservation := true;

        if (CalcReservEntry."Source Type" = Database::"Sales Line") then
            if ((CalcReservEntry."Source Subtype" = 5) and (ForSalesLine.Quantity >= 0)) then
                StopReservation := true;

        if StopReservation then begin
            FullAutoReservation := true;
            exit;
        end;

        RemainingQtyToReserve := CalculateRemainingQty;
        if (MaxQtyToReserve <> 0) and (Abs(MaxQtyToReserve) < Abs(RemainingQtyToReserve)) then
            RemainingQtyToReserve := MaxQtyToReserve;

        FullAutoReservation := false;

        if RemainingQtyToReserve = 0 then begin
            FullAutoReservation := true;
            exit;
        end;

        UpdateStatistics(ReservSummEntry);
        if ReservSummEntry.FindFirst then begin
            AutoReserveOneLine(ReservSummEntry);
            RemainingQtyToReserve := 0;
        end;

        FullAutoReservation := (RemainingQtyToReserve = 0);
    end;


    procedure AutoReserveOneLine(var ReservSummEntry: Record "Vehicle Reserv. Entry Summary")
    var
        ModelVersion: Record Item;
        LocationCode: Code[10];
        Reserved: Boolean;
    begin
        CalcReservEntry.TestField("Source Type");

        ReservSummEntry.CalcFields(Reserved);
        if ReservSummEntry.Reserved then
            exit;

        if not ModelVersion.Get(CalcReservEntry."Model Version No.") then
            Clear(ModelVersion);
        if not Location.Get(CalcReservEntry."Location Code") then
            Clear(Location);

        CalcReservEntry.Lock;

        case ReservSummEntry.Sequence of
            1:
                begin // Item Ledger Entry
                    CalcItemLedgEntry.Get(ReservSummEntry."Source Ref. No.");
                    CalcItemLedgEntry.CalcFields(Reserved);
                    if not CalcItemLedgEntry.Reserved then
                        CreateReservation(
                          '',
                          Database::"Item Ledger Entry", 0, '', '',
                          CalcItemLedgEntry."Entry No.",
                          CalcItemLedgEntry."Location Code");

                end;
            12, 16:
                begin // Purchase Line, Purchase Return Line
                    CalcPurchLine.Get(ReservSummEntry."Source Subtype", ReservSummEntry."Source ID", ReservSummEntry."Source Ref. No.");
                    CalcPurchLine.CalcFields(Reserved);
                    if not CalcPurchLine.Reserved then
                        CreateReservation(
                          '',
                          Database::"Purchase Line",
                          CalcPurchLine."Document Type".AsInteger(), CalcPurchLine."Document No.", '',
                          CalcPurchLine."Line No.",
                          CalcPurchLine."Location Code");
                end;
            21:
                begin // Requisition Line

                end;
            31, 32, 36:
                begin // Sales Line, Sales Return Line
                    CalcSalesLine.Get(ReservSummEntry."Source Subtype", ReservSummEntry."Source ID", ReservSummEntry."Source Ref. No.");
                    CalcSalesLine.CalcFields(Reserved);
                    if not CalcSalesLine.Reserved then
                        CreateReservation(
                          '',
                          Database::"Sales Line",
                          CalcSalesLine."Document Type".asinteger(), CalcSalesLine."Document No.", '',
                          CalcSalesLine."Line No.",
                          CalcSalesLine."Location Code");
                end;
            101, 102:
                begin // Transfer
                    CalcTransLine.Get(ReservSummEntry."Source Subtype", ReservSummEntry."Source ID", ReservSummEntry."Source Ref. No.");

                    case ReservSummEntry.Sequence of
                        101: // Outbound
                            begin
                                CalcTransLine.CalcFields(CalcTransLine."Reserved Outbound");
                                LocationCode := CalcTransLine."Transfer-from Code";
                                Reserved := CalcTransLine."Reserved Outbound";
                            end;
                        102: // Inbound
                            begin
                                CalcTransLine.CalcFields(CalcTransLine."Reserved Inbound");
                                LocationCode := CalcTransLine."Transfer-to Code";
                                Reserved := CalcTransLine."Reserved Inbound";
                            end;
                    end;

                    if not Reserved then
                        CreateReservation(
                          '',
                          Database::"Transfer Line",
                          ReservSummEntry.Sequence - 101,
                          CalcTransLine."Document No.", '',
                          CalcTransLine."Line No.",
                          LocationCode);
                end;
        end;
    end;


    procedure CreateReservation(Description: Text[50]; FromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal"; FromSubtype: Integer; FromID: Code[20]; FromBatchName: Code[10]; FromRefNo: Integer; FromLocationCode: Code[10])
    begin
        CalcReservEntry.TestField("Source Type");

        case CalcReservEntry."Source Type" of
            Database::"Sales Line":
                begin
                    ReserveSalesLine.CreateReservationSetFrom(
                      FromType, FromSubtype, FromID, FromBatchName, FromRefNo,
                      FromLocationCode);
                    ReserveSalesLine.CreateReservation(
                      ForSalesLine, Description);
                    ForSalesLine.CalcFields(Reserved);
                end;
            Database::"Requisition Line":
                begin
                    ReserveReqLine.CreateReservationSetFrom(
                      FromType, FromSubtype, FromID, FromBatchName, FromRefNo,
                      FromLocationCode);
                    ReserveReqLine.CreateReservation(
                      ForReqLine, Description);
                    ForReqLine.CalcFields(Reserved);
                end;
            Database::"Purchase Line":
                begin
                    ReservePurchLine.CreateReservationSetFrom(
                      FromType, FromSubtype, FromID, FromBatchName, FromRefNo,
                      FromLocationCode);
                    ReservePurchLine.CreateReservation(
                      ForPurchLine, Description);
                    ForPurchLine.CalcFields(Reserved);
                end;
            Database::"Item Journal Line":
                begin
                    ReserveItemJnlLine.CreateReservationSetFrom(
                      FromType, FromSubtype, FromID, FromBatchName, FromRefNo,
                      FromLocationCode);
                    ReserveItemJnlLine.CreateReservation(
                      ForItemJnlLine, Description);
                    ForItemJnlLine.CalcFields(Reserved);
                end;
            Database::"Transfer Line":
                begin
                    //???P8
                    ReserveTransLine.CreateReservationSetFrom(
                      FromType, FromSubtype, FromID, FromBatchName, FromRefNo,
                      FromLocationCode);
                    ReserveTransLine.CreateReservation(
                      ForTransLine, Description, ForTransLine."Shipment Date", ForTransLine.Quantity, ForTransLine."Quantity (Base)",
                      CalcReservEntry."Source Subtype");
                    ForTransLine.CalcFields("Reserved Outbound");
                    ForTransLine.CalcFields("Reserved Inbound");
                end;
        end;
    end;


    procedure DeleteReservEntries(DeleteAll: Boolean)
    var
        ReservMgt: Codeunit "Veh. Reservation Management";
        CalcReservEntry4: Record "Vehicle Reservation Entry";
        QtyToReTrack: Decimal;
        QtyTracked: Decimal;
    begin
        DeleteReservEntries2(CalcReservEntry2);

        // Handle both sides of a req. line related to a transfer line:
        if ((CalcReservEntry."Source Type" = Database::"Requisition Line") and
          (ForReqLine."Ref. Order Type" = ForReqLine."ref. order type"::Transfer))
        then begin
            CalcReservEntry4 := CalcReservEntry;
            CalcReservEntry4."Source Subtype" := 1;
            SetPointerFilter(CalcReservEntry4);
            DeleteReservEntries2(CalcReservEntry4);
        end;
    end;


    procedure DeleteReservEntries2(var ReservEntry: Record "Vehicle Reservation Entry")
    var
        CalcReservEntry4: Record "Vehicle Reservation Entry";
        DummyEntry: Record "Vehicle Reservation Entry";
        CurrentVehicleSerialNo: Code[20];
        ReleaseInventory: Boolean;
        SignFactor: Integer;
    begin

        if ReservEntry.IsEmpty then
            exit;
        CurrentVehicleSerialNo := ReservEntry."Vehicle Serial No.";

        GetModelVersionSetup(ReservEntry);
        ReservEntry.TestField("Source Type");
        ReservEntry.Lock;
        SignFactor := CreateReservEntry.SignFactor(ReservEntry);

        if ReservEntry.FindSet then
            repeat
                ReservEngineMgt.CloseReservEntry(ReservEntry);
            until ReservEntry.Next = 0;
    end;


    procedure CalculateRemainingQty(): Decimal
    begin
        CalcReservEntry.TestField("Source Type");

        case CalcReservEntry."Source Type" of
            Database::"Sales Line":
                begin
                    ForSalesLine.CalcFields(Reserved);
                    if ForSalesLine.Reserved then
                        exit(0)
                    else
                        exit(ForSalesLine."Outstanding Qty. (Base)");
                end;
            Database::"Requisition Line":
                begin
                    ForReqLine.CalcFields(Reserved);
                    if ForReqLine.Reserved then
                        exit(0)
                    else
                        exit(ForReqLine."Net Quantity (Base)");
                end;
            Database::"Purchase Line":
                begin
                    ForPurchLine.CalcFields(Reserved);
                    if ForPurchLine.Reserved then
                        exit(0)
                    else
                        exit(ForPurchLine."Outstanding Qty. (Base)");
                end;
            Database::"Item Journal Line":
                begin
                    ForItemJnlLine.CalcFields(Reserved);
                    if ForItemJnlLine.Reserved then
                        exit(0)
                    else
                        exit(ForItemJnlLine.Quantity);
                end;
            Database::"Transfer Line":
                begin
                    case CalcReservEntry."Source Subtype" of
                        0: // Outbound
                            begin
                                ForTransLine.CalcFields("Reserved Outbound");
                                if ForTransLine."Reserved Outbound" then
                                    exit(0)
                                else
                                    exit(ForTransLine."Outstanding Qty. (Base)");
                            end;
                        1: // Inbound
                            begin
                                ForTransLine.CalcFields("Reserved Inbound");
                                if ForTransLine."Reserved Inbound" then
                                    exit(0)
                                else
                                    exit(ForTransLine."Outstanding Qty. (Base)");
                            end;
                    end;
                end;
            else
                Error(Text003);
        end;
    end;


    procedure CopySign(FromValue: Decimal; var ToValue: Decimal)
    begin
        if FromValue * ToValue < 0 then
            ToValue := -ToValue;
    end;

    local procedure InitFilter(EntryID: Integer)
    begin
        case EntryID of
            1:
                begin // Item Ledger Entry
                    CalcItemLedgEntry.Reset;
                    CalcItemLedgEntry.SetCurrentkey("Item No.", Open, "Variant Code", Positive, "Location Code",
                     "Posting Date", "Expiration Date", "Lot No.", "Serial No.");
                    CalcItemLedgEntry.SetRange("Item No.", CalcReservEntry."Model Version No.");
                    CalcItemLedgEntry.SetRange(Open, true);
                    CalcItemLedgEntry.SetRange("Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcItemLedgEntry.SetRange(Positive, Positive);
                    CalcItemLedgEntry.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcItemLedgEntry.SetRange("Drop Shipment", false);
                end;
            12, 16:
                begin // Purchase Line
                    CalcPurchLine.Reset;
                    CalcPurchLine.SetCurrentkey("Vehicle Serial No.", "Vehicle Assembly ID");
                    CalcPurchLine.SetRange("Document Type", EntryID - 11);
                    CalcPurchLine.SetRange(Type, CalcPurchLine.Type::Item);
                    CalcPurchLine.SetRange("Model Version No.", CalcReservEntry."Model Version No.");
                    CalcPurchLine.SetRange("Vehicle Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcPurchLine.SetRange("Drop Shipment", false);
                    CalcPurchLine.SetRange("Location Code", CalcReservEntry."Location Code");
                    if Positive and (EntryID <> 16) then
                        CalcPurchLine.SetFilter("Quantity (Base)", '>0')
                    else
                        CalcPurchLine.SetFilter("Quantity (Base)", '<0');
                    CalcPurchLine.SetRange("Job No.", ' ');
                end;
            21:
                begin // Requisition Line
                    CalcReqLine.Reset;
                    CalcReqLine.SetCurrentkey(
                      Type, "No.", "Vehicle Serial No.", "Location Code", "Sales Order No.", "Planning Line Origin", "Due Date");
                    CalcReqLine.SetRange(Type, CalcReqLine.Type::Item);
                    CalcReqLine.SetRange("Model Version No.", CalcReservEntry."Model Version No.");
                    CalcReqLine.SetRange("Vehicle Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcReqLine.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcReqLine.SetRange("Sales Order No.", '');
                    if Positive then
                        CalcReqLine.SetFilter("Quantity (Base)", '>0')
                    else
                        CalcReqLine.SetFilter("Quantity (Base)", '<0');
                end;
            31, 32, 36:
                begin // Sales Line
                    CalcSalesLine.Reset;
                    CalcSalesLine.SetCurrentkey("Vehicle Serial No.", "Vehicle Assembly ID");
                    CalcSalesLine.SetRange("Document Type", EntryID - 31);
                    CalcSalesLine.SetRange(Type, CalcSalesLine.Type::Item);
                    CalcSalesLine.SetRange("Model Version No.", CalcReservEntry."Model Version No.");
                    CalcSalesLine.SetRange("Vehicle Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcSalesLine.SetRange("Drop Shipment", false);
                    CalcSalesLine.SetRange("Location Code", CalcReservEntry."Location Code");
                    if EntryID = 36 then
                        if Positive then
                            CalcSalesLine.SetFilter("Quantity (Base)", '>0')
                        else
                            CalcSalesLine.SetFilter("Quantity (Base)", '<0')
                    else
                        if Positive then
                            CalcSalesLine.SetFilter("Quantity (Base)", '<0')
                        else
                            CalcSalesLine.SetFilter("Quantity (Base)", '>0');
                    CalcSalesLine.SetRange("Job No.", ' ');
                end;
            101:
                begin // Transfer, Outbound
                    CalcTransLine.Reset;
                    CalcTransLine.SetCurrentkey("Transfer-from Code");
                    CalcTransLine.SetRange("Model Version No.", CalcReservEntry."Model Version No.");
                    CalcTransLine.SetRange("Vehicle Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcTransLine.SetRange("Transfer-from Code", CalcReservEntry."Location Code");
                    if Positive then
                        CalcTransLine.SetFilter("Outstanding Qty. (Base)", '<0')
                    else
                        CalcTransLine.SetFilter("Outstanding Qty. (Base)", '>0');
                end;
            102:
                begin // Transfer, Inbound
                    CalcTransLine.Reset;
                    CalcTransLine.SetCurrentkey("Transfer-to Code");
                    CalcTransLine.SetRange("Model Version No.", CalcReservEntry."Model Version No.");
                    CalcTransLine.SetRange("Vehicle Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcTransLine.SetRange("Transfer-to Code", CalcReservEntry."Location Code");
                    if Positive then
                        CalcTransLine.SetFilter("Outstanding Qty. (Base)", '>0')
                    else
                        CalcTransLine.SetFilter("Outstanding Qty. (Base)", '<0');
                end;
        end;
    end;

    local procedure SetValueArray(): Integer
    begin
        Clear(ValueArray);
        ValueArray[1] := 1;
        ValueArray[2] := 12;
        ValueArray[3] := 16;
        ValueArray[4] := 32;
        ValueArray[5] := 36;
        ValueArray[6] := 63;
        ValueArray[7] := 64;
        ValueArray[8] := 73;
        ValueArray[9] := 74;
        ValueArray[10] := 101;
        ValueArray[11] := 102;
        ValueArray[12] := 110;
        exit(12);
    end;


    procedure SetPointerFilter(var ReservEntry: Record "Vehicle Reservation Entry")
    begin
        ReservEntry.SetCurrentkey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");
        ReservEntry.SetRange("Source ID", ReservEntry."Source ID");
        ReservEntry.SetRange("Source Ref. No.", ReservEntry."Source Ref. No.");
        ReservEntry.SetRange("Source Type", ReservEntry."Source Type");
        ReservEntry.SetRange("Source Subtype", ReservEntry."Source Subtype");
        ReservEntry.SetRange("Source Batch Name", ReservEntry."Source Batch Name");
    end;

    local procedure MakeConnection(var FromReservEntry: Record "Vehicle Reservation Entry"; var ToReservEntry: Record "Vehicle Reservation Entry"; Quantity: Decimal; AvailabilityDate: Date; Binding: Option ,"Order-to-Order")
    begin
        CreateReservEntry.CreateReservEntryFor(
          FromReservEntry."Source Type", FromReservEntry."Source Subtype", FromReservEntry."Source ID",
          FromReservEntry."Source Batch Name", FromReservEntry."Source Ref. No.",
          CreateReservEntry.SignFactor(FromReservEntry) * Quantity);
        CreateReservEntry.CreateReservEntryFrom(
          ToReservEntry."Source Type", ToReservEntry."Source Subtype", ToReservEntry."Source ID", ToReservEntry."Source Batch Name",
          ToReservEntry."Source Ref. No.");
        CreateReservEntry.CreateEntry(
          FromReservEntry."Model Version No.", FromReservEntry."Vehicle Serial No.", FromReservEntry."Location Code",
          FromReservEntry.Description);
    end;


    procedure MakeRoomForReservation(var ReservEntry: Record "Vehicle Reservation Entry"): Decimal
    var
        ReservEntry2: Record "Vehicle Reservation Entry";
        TotalQuantity: Decimal;
    begin
        TotalQuantity := SourceQuantity(ReservEntry, false);
        ReservEntry2 := ReservEntry;
        SetPointerFilter(ReservEntry2);
        DeleteReservEntries2(ReservEntry2);
    end;


    procedure SourceQuantity(var ReservEntry: Record "Vehicle Reservation Entry"; SetAsCurrent: Boolean): Decimal
    begin
        exit(GetSourceRecordValue(ReservEntry, SetAsCurrent));
    end;


    procedure GetSourceRecordValue(var ReservEntry: Record "Vehicle Reservation Entry"; SetAsCurrent: Boolean): Decimal
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        SalesLine: Record "Sales Line";
        ReqLine: Record "Requisition Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        TransLine: Record "Transfer Line";
    begin
        case ReservEntry."Source Type" of
            Database::"Item Ledger Entry":
                begin
                    ItemLedgEntry.Get(ReservEntry."Source Ref. No.");
                    if SetAsCurrent then
                        SetItemLedgEntry(ItemLedgEntry);
                    exit(ItemLedgEntry."Remaining Quantity")
                end;
            Database::"Sales Line":
                begin
                    SalesLine.Get(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.");
                    if SetAsCurrent then
                        SetSalesLine(SalesLine);
                    exit(SalesLine."Quantity (Base)");
                end;
            Database::"Requisition Line":
                begin
                    ReqLine.Get(ReservEntry."Source ID", ReservEntry."Source Batch Name", ReservEntry."Source Ref. No.");
                    if SetAsCurrent then
                        SetReqLine(ReqLine);
                    exit(ReqLine."Quantity (Base)");
                end;
            Database::"Purchase Line":
                begin
                    PurchLine.Get(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.");
                    if SetAsCurrent then
                        SetPurchLine(PurchLine);
                    exit(PurchLine."Quantity (Base)");
                end;
            Database::"Item Journal Line":
                begin
                    ItemJnlLine.Get(ReservEntry."Source ID", ReservEntry."Source Batch Name", ReservEntry."Source Ref. No.");
                    if SetAsCurrent then
                        SetItemJnlLine(ItemJnlLine);
                    exit(ItemJnlLine."Quantity (Base)");

                end;
            Database::"Transfer Line":
                begin
                    TransLine.Get(ReservEntry."Source ID", ReservEntry."Source Ref. No.");
                    if SetAsCurrent then
                        SetTransferLine(TransLine, ReservEntry."Source Subtype");
                    exit(TransLine."Quantity (Base)");
                end;
        end;
        // WITH
    end;

    local procedure GetModelVersionSetup(var ReservEntry: Record "Vehicle Reservation Entry")
    begin
        if ReservEntry."Model Version No." <> ModelVersion."No." then
            ModelVersion.Get(ReservEntry."Model Version No.");
    end;


    procedure MarkReservConnection(var ReservEntry: Record "Vehicle Reservation Entry"; TargetReservEntry: Record "Vehicle Reservation Entry") ReservedQuantity: Decimal
    var
        ReservEntry2: Record "Vehicle Reservation Entry";
        SignFactor: Integer;
    begin
        if not ReservEntry.FindSet then
            exit;
        SignFactor := CreateReservEntry.SignFactor(ReservEntry);

        repeat
            if ReservEntry2.Get(ReservEntry."Entry No.", not ReservEntry.Positive) then
                if ((ReservEntry2."Source Type" = TargetReservEntry."Source Type") and
                    (ReservEntry2."Source Subtype" = TargetReservEntry."Source Subtype") and
                    (ReservEntry2."Source ID" = TargetReservEntry."Source ID") and
                    (ReservEntry2."Source Batch Name" = TargetReservEntry."Source Batch Name") and
                    (ReservEntry2."Source Ref. No." = TargetReservEntry."Source Ref. No."))
                then begin
                    ReservEntry.Mark(true);
                    ReservedQuantity += ReservEntry.Quantity * SignFactor;
                end;
        until ReservEntry.Next = 0;
        ReservEntry.MarkedOnly(true);
    end;


    procedure SetMatchFilter(var ReservEntry: Record "Vehicle Reservation Entry"; var FilterReservEntry: Record "Vehicle Reservation Entry"; SearchForSupply: Boolean; AvailabilityDate: Date)
    begin
        FilterReservEntry.Reset;
        FilterReservEntry.SetCurrentkey(
          "Model Version No.", "Vehicle Serial No.", "Location Code");
        FilterReservEntry.SetRange("Model Version No.", ReservEntry."Model Version No.");
        FilterReservEntry.SetRange("Vehicle Serial No.", ReservEntry."Vehicle Serial No.");
        FilterReservEntry.SetRange("Location Code", ReservEntry."Location Code");
        FilterReservEntry.SetRange(Positive, SearchForSupply);
    end;


    procedure LookupLine(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceRefNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ReqLine: Record "Requisition Line";
    begin
        case SourceType of
            Database::"Sales Line":
                begin
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", SourceSubtype);
                    SalesLine.SetRange("Document No.", SourceID);
                    SalesLine.SetRange("Line No.", SourceRefNo);
                    Page.Run(Page::"Sales Lines", SalesLine);
                end;
            Database::"Requisition Line":
                begin
                    ReqLine.Reset;
                    ReqLine.SetRange("Worksheet Template Name", SourceID);
                    ReqLine.SetRange("Journal Batch Name", SourceBatchName);
                    ReqLine.SetRange("Line No.", SourceRefNo);
                    Page.Run(Page::"Requisition Lines", ReqLine);
                end;
            Database::"Purchase Line":
                begin
                    PurchLine.Reset;
                    PurchLine.SetRange("Document Type", SourceSubtype);
                    PurchLine.SetRange("Document No.", SourceID);
                    PurchLine.SetRange("Line No.", SourceRefNo);
                    Page.Run(Page::"Purchase Lines", PurchLine);
                end;
            Database::"Item Journal Line":
                begin
                    ItemJnlLine.Reset;
                    ItemJnlLine.SetRange("Journal Template Name", SourceID);
                    ItemJnlLine.SetRange("Journal Batch Name", SourceBatchName);
                    ItemJnlLine.SetRange("Line No.", SourceRefNo);
                    ItemJnlLine.SetRange("Entry Type", SourceSubtype);
                    Page.Run(Page::"Item Journal Lines", ItemJnlLine);
                end;
            Database::"Item Ledger Entry":
                begin
                    ItemLedgEntry.Reset;
                    ItemLedgEntry.SetRange("Entry No.", SourceRefNo);
                    Page.Run(0, ItemLedgEntry);
                end;
        end;
    end;


    procedure LookupDocument(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceRefNo: Integer)
    var
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        ReqLine: Record "Requisition Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        TransHeader: Record "Transfer Header";
    begin
        case SourceType of
            Database::"Sales Line":
                begin
                    SalesHeader.Reset;
                    SalesHeader.SetRange("Document Type", SourceSubtype);
                    SalesHeader.SetRange("No.", SourceID);
                    case SourceSubtype of
                        0:
                            Page.RunModal(Page::"Sales Quote", SalesHeader);
                        1:
                            Page.RunModal(Page::"Sales Order", SalesHeader);
                        2:
                            Page.RunModal(Page::"Sales Invoice", SalesHeader);
                        3:
                            Page.RunModal(Page::"Sales Credit Memo", SalesHeader);
                    end;
                end;
            Database::"Requisition Line":
                begin
                    ReqLine.Reset;
                    ReqLine.SetRange("Worksheet Template Name", SourceID);
                    ReqLine.SetRange("Journal Batch Name", SourceBatchName);
                    ReqLine.SetRange("Line No.", SourceRefNo);
                    Page.RunModal(Page::"Requisition Lines", ReqLine);
                end;
            Database::"Purchase Line":
                begin
                    PurchHeader.Reset;
                    PurchHeader.SetRange("Document Type", SourceSubtype);
                    PurchHeader.SetRange("No.", SourceID);
                    case SourceSubtype of
                        0:
                            Page.RunModal(Page::"Purchase Quote", PurchHeader);
                        1:
                            Page.RunModal(Page::"Purchase Order", PurchHeader);
                        2:
                            Page.RunModal(Page::"Purchase Invoice", PurchHeader);
                        3:
                            Page.RunModal(Page::"Purchase Credit Memo", PurchHeader);
                    end;
                end;
            Database::"Item Journal Line":
                begin
                    ItemJnlLine.Reset;
                    ItemJnlLine.SetRange("Journal Template Name", SourceID);
                    ItemJnlLine.SetRange("Journal Batch Name", SourceBatchName);
                    ItemJnlLine.SetRange("Line No.", SourceRefNo);
                    ItemJnlLine.SetRange("Entry Type", SourceSubtype);
                    Page.RunModal(Page::"Item Journal Lines", ItemJnlLine);
                end;
            Database::"Item Ledger Entry":
                begin
                    ItemLedgEntry.Reset;
                    ItemLedgEntry.SetRange("Entry No.", SourceRefNo);
                    Page.RunModal(0, ItemLedgEntry);
                end;
            Database::"Transfer Line":
                begin
                    TransHeader.Reset;
                    TransHeader.SetRange("No.", SourceID);
                    Page.RunModal(Page::"Transfer Order", TransHeader);
                end;
        end;
    end;
}

