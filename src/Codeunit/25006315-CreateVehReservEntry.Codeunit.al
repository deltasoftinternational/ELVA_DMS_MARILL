Codeunit 25006315 "Create Veh. Reserv. Entry"
{
    Permissions = TableData "Reservation Entry" = rim;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Reservation is illegal.';
        InsertReservEntry: Record "Vehicle Reservation Entry";
        InsertReservEntry2: Record "Vehicle Reservation Entry";
        LastReservEntry: Record "Vehicle Reservation Entry";
        Inbound: Boolean;
        UseQtyToInvoice: Boolean;


    procedure CreateEntry(ModelVersionNo: Code[20]; VehicleSerialNo: Code[20]; LocationCode: Code[10]; Description: Text[100])
    var
        ReservEntry: Record "Vehicle Reservation Entry";
        ReservEntry2: Record "Vehicle Reservation Entry";
        ReservEntry3: Record "Vehicle Reservation Entry";
        ReservMgt: Codeunit "Veh. Reservation Management";
        LastEntryNo: Integer;
        TrackingSpecificationExists: Boolean;
        FirstSplit: Boolean;
    begin

        InsertReservEntry.TestField("Source Type");

        ReservEntry := InsertReservEntry;
        ReservEntry."Model Version No." := ModelVersionNo;
        ReservEntry."Vehicle Serial No." := VehicleSerialNo;
        ReservEntry."Location Code" := LocationCode;
        ReservEntry.Description := Description;
        ReservEntry."Creation Date" := WorkDate;
        ReservEntry."Created By" := UserId;
        ReservEntry.Positive := (ReservEntry.Quantity > 0);
        ReservEntry.Quantity := ReservEntry.Quantity;

        InsertReservEntry2.TestField("Source Type");

        ReservEntry2 := ReservEntry;
        ReservEntry2.Quantity := -ReservEntry.Quantity;
        ReservEntry2.Positive := (ReservEntry2.Quantity > 0);
        ReservEntry2."Source Type" := InsertReservEntry2."Source Type";
        ReservEntry2."Source Subtype" := InsertReservEntry2."Source Subtype";
        ReservEntry2."Source ID" := InsertReservEntry2."Source ID";
        ReservEntry2."Source Batch Name" := InsertReservEntry2."Source Batch Name";
        ReservEntry2."Source Ref. No." := InsertReservEntry2."Source Ref. No.";
        ReservEntry2."Model Version No." := ModelVersionNo;
        ReservEntry2."Vehicle Serial No." := VehicleSerialNo;
        ReservEntry2.Quantity := ReservEntry2.Quantity;
        //ReservMgt.MakeRoomForReservation(ReservEntry2);
        CheckValidity(ReservEntry2);


        CheckValidity(ReservEntry);

        //ReservMgt.MakeRoomForReservation(ReservEntry);

        ReservEntry3.LockTable;
        if ReservEntry3.FindLast then
            LastEntryNo := ReservEntry3."Entry No.";

        ReservEntry."Entry No." := LastEntryNo + 1;
        ReservEntry.Insert;
        ReservEntry2."Entry No." := ReservEntry."Entry No.";
        ReservEntry2.Insert;

        LastReservEntry := ReservEntry;

        Clear(InsertReservEntry);
        Clear(InsertReservEntry2);
    end;


    procedure CreateReservEntry(ModelVersionNo: Code[20]; VehicleSerialNo: Code[20]; LocationCode: Code[10]; Description: Text[50])
    begin
        CreateEntry(ModelVersionNo, VehicleSerialNo, LocationCode, Description);
    end;


    procedure CreateReservEntryFor(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForRefNo: Integer; Quantity: Decimal)
    begin
        InsertReservEntry."Source Type" := ForType;
        InsertReservEntry."Source Subtype" := ForSubtype;
        InsertReservEntry."Source ID" := ForID;
        InsertReservEntry."Source Batch Name" := ForBatchName;
        InsertReservEntry."Source Ref. No." := ForRefNo;
        InsertReservEntry.Quantity := SignFactor(InsertReservEntry) * Quantity;
    end;


    procedure CreateReservEntryFrom(FromType: Option; FromSubtype: Integer; FromID: Code[20]; FromBatchName: Code[10]; FromRefNo: Integer)
    begin
        InsertReservEntry2."Source Type" := FromType;
        InsertReservEntry2."Source Subtype" := FromSubtype;
        InsertReservEntry2."Source ID" := FromID;
        InsertReservEntry2."Source Batch Name" := FromBatchName;
        InsertReservEntry2."Source Ref. No." := FromRefNo;
    end;


    procedure CreateRemainingReservEntry(var OldReservEntry: Record "Vehicle Reservation Entry"; RemainingQuantity: Decimal)
    var
        OldReservEntry2: Record "Vehicle Reservation Entry";
    begin

        CreateReservEntryFor(
          OldReservEntry."Source Type", OldReservEntry."Source Subtype",
          OldReservEntry."Source ID", OldReservEntry."Source Batch Name",
          OldReservEntry."Source Ref. No.",
          RemainingQuantity);

        if OldReservEntry2.Get(OldReservEntry."Entry No.", not OldReservEntry.Positive) then begin // Get the related entry
            CreateReservEntryFrom(
                OldReservEntry2."Source Type", OldReservEntry2."Source Subtype",
                OldReservEntry2."Source ID", OldReservEntry2."Source Batch Name",
                OldReservEntry2."Source Ref. No.");
        end;
        CreateEntry(
          OldReservEntry."Model Version No.", OldReservEntry."Vehicle Serial No.",
          OldReservEntry."Location Code", OldReservEntry.Description);
    end;


    procedure TransferReservEntry(NewType: Option; NewSubtype: Integer; NewID: Code[20]; NewBatchName: Code[10]; NewRefNo: Integer; OldReservEntry: Record "Vehicle Reservation Entry")
    var
        NewReservEntry: Record "Vehicle Reservation Entry";
        RelatedReservEntry: Record "Vehicle Reservation Entry";
        Location: Record Location;
        CurrSignFactor: Integer;
        QtyInvoiced: Decimal;
    begin

        //CurrSignFactor := SignFactor(OldReservEntry);

        NewReservEntry := OldReservEntry;
        if NewReservEntry.RECORDLEVELLOCKING then
            NewReservEntry.Modify;

        NewReservEntry."Source Type" := NewType;
        NewReservEntry."Source Subtype" := NewSubtype;
        NewReservEntry."Source ID" := NewID;
        NewReservEntry."Source Batch Name" := NewBatchName;
        NewReservEntry."Source Ref. No." := NewRefNo;

        NewReservEntry.Modify;
    end;


    procedure SignFactor(var ReservEntry: Record "Vehicle Reservation Entry"): Integer
    begin

        // Demand is regarded as negative, supply is regarded as positive.
        case ReservEntry."Source Type" of
            Database::"Sales Line":
                if ReservEntry."Source Subtype" in [3, 5] then // Credit memo, Return Order = supply
                    exit(1)
                else
                    exit(-1);
            Database::"Requisition Line":
                if ReservEntry."Source Subtype" = 1 then
                    exit(-1)
                else
                    exit(1);
            Database::"Purchase Line":
                if ReservEntry."Source Subtype" in [3, 5] then // Credit memo, Return Order = demand
                    exit(-1)
                else
                    exit(1);
            Database::"Item Journal Line":
                if (ReservEntry."Source Subtype" = 4) and (Inbound) then
                    exit(1)
                else
                    if ReservEntry."Source Subtype" in [1, 3, 4, 5] then // Sale, Negative Adjmt., Transfer, Consumption
                        exit(-1)
                    else
                        exit(1);
            Database::"Item Ledger Entry":
                exit(1);
            Database::"Prod. Order Line":
                exit(1);
            Database::"Prod. Order Component":
                exit(-1);
            Database::"Planning Component":
                exit(-1);
            Database::"Transfer Line":
                if ReservEntry."Source Subtype" = 0 then // Outbound
                    exit(-1)
                else
                    exit(1);
            Database::"Service Invoice Line":
                exit(-1);
        end;
    end;


    procedure CheckValidity(var ReservEntry: Record "Vehicle Reservation Entry")
    var
        IsError: Boolean;
    begin

        case ReservEntry."Source Type" of
            Database::"Sales Line":
                IsError := not (ReservEntry."Source Subtype" in [1, 5]);

            Database::"Purchase Line":
                IsError := not (ReservEntry."Source Subtype" in [1, 5]);

        //DATABASE::"Requisition Line",

        end;

        if IsError then
            Error(Text000);
    end;


    procedure GetLastEntry(var ReservEntry: Record "Vehicle Reservation Entry")
    begin

        ReservEntry := LastReservEntry;
    end;


    procedure HasSamePointer(var ReservEntry: Record "Vehicle Reservation Entry"; var Reserventry2: Record "Vehicle Reservation Entry"): Boolean
    begin

        exit
          ((ReservEntry."Source Type" = Reserventry2."Source Type") and
          (ReservEntry."Source Subtype" = Reserventry2."Source Subtype") and
          (ReservEntry."Source ID" = Reserventry2."Source ID") and
          (ReservEntry."Source Batch Name" = Reserventry2."Source Batch Name") and
          (ReservEntry."Source Ref. No." = Reserventry2."Source Ref. No."));
    end;


    procedure SetInbound(NewInbound: Boolean)
    begin

        Inbound := NewInbound;
    end;


    procedure SetUseQtyToInvoice(UseQtyToInvoice2: Boolean)
    begin

        UseQtyToInvoice := UseQtyToInvoice2;
    end;
}

