Codeunit 25006316 "Veh. Reservation Engine Mgt."
{
    Permissions = TableData "Item Ledger Entry" = rm,
                  TableData "Reservation Entry" = rimd,
                  TableData "Action Message Entry" = rid;

    trigger OnRun()
    begin
    end;

    var
        Text000: label '%1 must be greater than 0.';
        Text001: label '%1 must be less than 0.';
        Text002: label 'Use Cancel Reservation.';
        Text003: label '%1 can only be reduced.';
        Text005: label 'Outbound,Inbound';
        CalcSalesLine: Record "Sales Line";
        CalcPurchLine: Record "Purchase Line";
        CalcItemJnlLine: Record "Item Journal Line";
        ModelVersion: Record Item;
        TempSortRec1: Record "Vehicle Reservation Entry" temporary;
        TempSortRec2: Record "Vehicle Reservation Entry" temporary;
        TempSortRec3: Record "Vehicle Reservation Entry" temporary;
        TempSortRec4: Record "Vehicle Reservation Entry" temporary;
        ReservMgt: Codeunit "Veh. Reservation Management";
        Text007: label 'Renaming reservation entries...';
        EDMS001: label 'You are not allowed to cancel other user reservation.';
        UserSetup: Record "User Setup";


    procedure CloseReservEntry2(ReservEntry: Record "Vehicle Reservation Entry")
    var
        ReservEntry3: Record "Vehicle Reservation Entry";
        LastEntryNo: Integer;
    begin
        if UserSetup.Get(UserId) then;
        if UserSetup."Cancel Only Own Reservation" and (ReservEntry."Created By" <> UpperCase(UserId)) then
            Error(EDMS001);

        ReservEntry3.LockTable;
        if ReservEntry3.FindLast then
            LastEntryNo := ReservEntry3."Entry No.";

        CloseReservEntry(ReservEntry);
    end;


    procedure CloseReservEntry(ReservEntry: Record "Vehicle Reservation Entry")
    var
        ReservEntry2: Record "Vehicle Reservation Entry";
        SurplusReservEntry: Record "Vehicle Reservation Entry";
        DummyReservEntry: Record "Vehicle Reservation Entry";
        TotalQty: Decimal;
        AvailabilityDate: Date;
        DeleteOnly: Boolean;
    begin

        ReservEntry.Delete;
        GetModelVersion(ReservEntry."Model Version No.");

        ReservEntry2.Get(ReservEntry."Entry No.", not ReservEntry.Positive);
        DeleteOnly := true;

        if DeleteOnly then
            ReservEntry2.Delete
        else begin
            if not (CheckValidity(ReservEntry2)) then begin
                ReservEntry2.Delete;
                exit;
            end;

            ReservEntry2.Modify;
            if ReservEntry2.Quantity = 0 then begin
                ReservEntry2.Delete(true);
            end else begin
                ReservEntry2.Modify;


            end;
        end;
    end;


    procedure ModifyReservEntry(ReservEntry: Record "Vehicle Reservation Entry"; NewQuantity: Decimal; NewDescription: Text[50]; ModifyReserved: Boolean)
    var
        TotalQty: Decimal;
    begin
        if NewQuantity * ReservEntry.Quantity < 0 then
            if NewQuantity < 0 then
                Error(Text000, ReservEntry.FieldCaption(Quantity))
            else
                Error(Text001, ReservEntry.FieldCaption(Quantity));
        if NewQuantity = 0 then
            Error(Text002);
        if Abs(NewQuantity) > Abs(ReservEntry.Quantity) then
            Error(Text003, ReservEntry.FieldCaption(Quantity));

        if ModifyReserved then begin
            if ReservEntry."Model Version No." <> ModelVersion."No." then
                GetModelVersion(ReservEntry."Model Version No.");

            ReservEntry.Get(ReservEntry."Entry No.", ReservEntry.Positive); // Get existing entry
            ReservEntry.Validate(Quantity, NewQuantity);
            ReservEntry.Description := NewDescription;
            ReservEntry."Changed By" := UserId;
            ReservEntry.Modify;

            if ReservEntry.Get(ReservEntry."Entry No.", not ReservEntry.Positive) then begin // Get related entry
                ReservEntry.Validate(Quantity, -NewQuantity);
                ReservEntry.Description := NewDescription;
                ReservEntry."Changed By" := UserId;
                ReservEntry.Modify;
            end;
        end;
    end;


    procedure CreateForText(ReservEntry: Record "Vehicle Reservation Entry"): Text[80]
    begin

        if ReservEntry.Get(ReservEntry."Entry No.", false) then
            exit(CreateText(ReservEntry))
        else
            exit('');
    end;


    procedure CreateFromText(ReservEntry: Record "Vehicle Reservation Entry"): Text[80]
    begin

        if ReservEntry.Get(ReservEntry."Entry No.", true) then
            exit(CreateText(ReservEntry))
        else
            exit('');
    end;


    procedure CreateText(ReservEntry: Record "Vehicle Reservation Entry"): Text[80]
    var
        SourceType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry","Prod. Order Line","Prod. Order Component","Planning Line","Planning Component",Transfer,"Service Order";
        SourceTypeText: label 'Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order';
    begin

        case ReservEntry."Source Type" of
            Database::"Sales Line":
                begin
                    SourceType := Sourcetype::Sales;
                    CalcSalesLine."Document Type" := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2 %3', SelectStr(SourceType, SourceTypeText),
                      CalcSalesLine."Document Type", ReservEntry."Source ID"));
                end;
            Database::"Purchase Line":
                begin
                    SourceType := Sourcetype::Purchase;
                    CalcPurchLine."Document Type" := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2 %3', SelectStr(SourceType, SourceTypeText),
                      CalcPurchLine."Document Type", ReservEntry."Source ID"));
                end;
            Database::"Requisition Line":
                begin
                    SourceType := Sourcetype::"Requisition Line";
                    exit(StrSubstNo('%1 %2 %3', SelectStr(SourceType, SourceTypeText),
                    ReservEntry."Source ID", ReservEntry."Source Batch Name"));
                end;
            Database::"Item Journal Line":
                begin
                    SourceType := Sourcetype::"Item Journal";
                    CalcItemJnlLine."Entry Type" := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2 %3 %4', SelectStr(SourceType, SourceTypeText),
                      CalcItemJnlLine."Entry Type", ReservEntry."Source ID", ReservEntry."Source Batch Name"));
                end;
            Database::"Item Ledger Entry":
                begin
                    SourceType := Sourcetype::"Item Ledger Entry";
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText), ReservEntry."Source Ref. No."));
                end;
            Database::"Transfer Line":
                begin
                    SourceType := Sourcetype::Transfer;
                    exit(StrSubstNo('%1 %2, %3', SelectStr(SourceType, SourceTypeText),
                      ReservEntry."Source ID", SelectStr(ReservEntry."Source Subtype" + 1, Text005)));
                end;
            Database::"Service Invoice Line":
                begin
                    SourceType := Sourcetype::"Service Order";
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText), ReservEntry."Source ID"));
                end;
        end;

        exit('');
    end;


    procedure InitFilterAndSortingFor(var FilterReservEntry: Record "Vehicle Reservation Entry")
    begin
        FilterReservEntry.Reset;
        FilterReservEntry.SetCurrentkey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");
    end;


    procedure InitFilterAndSortingLookupFor(var FilterReservEntry: Record "Vehicle Reservation Entry")
    begin

        FilterReservEntry.Reset;
        FilterReservEntry.SetCurrentkey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");
    end;


    procedure LastReservEntryNo(): Integer
    var
        ReservEntry: Record "Vehicle Reservation Entry";
    begin

        if ReservEntry.FindLast then
            exit(ReservEntry."Entry No.")
        else
            exit(0);
    end;

    local procedure GetModelVersion(ModelVersionNo: Code[20])
    begin

        if ModelVersion."No." <> ModelVersionNo then
            ModelVersion.Get(ModelVersionNo);
    end;


    procedure InitRecordSet(var ReservEntry: Record "Vehicle Reservation Entry"): Boolean
    var
        IsDemand: Boolean;
        CarriesItemTracking: Boolean;
    begin

        // Used for combining sorting of reservation entries with priorities
        if ReservEntry.IsEmpty then
            exit(false);

        IsDemand := ReservEntry.Quantity < 0;

        TempSortRec1.Reset;
        TempSortRec2.Reset;
        TempSortRec3.Reset;
        TempSortRec4.Reset;

        TempSortRec1.DeleteAll;
        TempSortRec2.DeleteAll;
        TempSortRec3.DeleteAll;
        TempSortRec4.DeleteAll;

        repeat
            TempSortRec1 := ReservEntry;
            TempSortRec1.Insert;

            if IsDemand then
                if CarriesItemTracking then begin
                    TempSortRec4 := TempSortRec1;
                    TempSortRec4.Insert;
                    TempSortRec2.Delete;
                end else begin
                    TempSortRec3 := TempSortRec1;
                    TempSortRec3.Insert;
                end;
        until ReservEntry.Next = 0;

        SetKeyAndFilters(TempSortRec1);
        SetKeyAndFilters(TempSortRec2);
        SetKeyAndFilters(TempSortRec3);
        SetKeyAndFilters(TempSortRec4);

        exit(NEXTRecord(ReservEntry) <> 0);
    end;


    procedure NEXTRecord(var ReservEntry: Record "Vehicle Reservation Entry"): Integer
    var
        Found: Boolean;
    begin

        // Used for combining sorting of reservation entries with priorities
        if TempSortRec1.IsEmpty then
            exit(0);
        if not TempSortRec3.IsEmpty then begin // Reservations with no item tracking against inventory
            TempSortRec3.FindFirst;
            TempSortRec1 := TempSortRec3;
            TempSortRec3.Delete;
            Found := true;
        end;


        if not Found then begin
            if not TempSortRec2.IsEmpty then begin // Records carrying item tracking
                TempSortRec2.FindFirst;
                TempSortRec1 := TempSortRec2;
                TempSortRec2.Delete;
            end else begin
                if not TempSortRec2.IsEmpty then begin // Records carrying item tracking
                    TempSortRec2.FindFirst;
                    TempSortRec1 := TempSortRec2;
                    TempSortRec2.Delete;
                end;
            end;
        end;

        ReservEntry := TempSortRec1;
        TempSortRec1.Delete;
        exit(1);
    end;

    local procedure SetKeyAndFilters(var ReservEntry: Record "Vehicle Reservation Entry")
    begin

        if ReservEntry.IsEmpty then
            exit;

        ReservEntry.SetCurrentkey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");

        if ReservEntry.FindSet then
            ReservMgt.SetPointerFilter(ReservEntry);
    end;


    procedure RenamePointer(TableID: Integer; OldSubtype: Integer; OldID: Code[20]; OldBatchName: Code[10]; OldRefNo: Integer; NewSubtype: Integer; NewID: Code[20]; NewBatchName: Code[10]; NewRefNo: Integer)
    var
        ReservEntry: Record "Vehicle Reservation Entry";
        NewReservEntry: Record "Vehicle Reservation Entry";
        PointerFieldIsActive: array[6] of Boolean;
        W: Dialog;
    begin

        GetActivePointerFields(TableID, PointerFieldIsActive);
        if not PointerFieldIsActive[1] then
            exit;

        ReservEntry.SetCurrentkey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");

        if PointerFieldIsActive[3] then
            ReservEntry.SetRange("Source ID", OldID)
        else
            ReservEntry.SetRange("Source ID", '');

        if PointerFieldIsActive[6] then
            ReservEntry.SetRange("Source Ref. No.", OldRefNo)
        else
            ReservEntry.SetRange("Source Ref. No.", 0);

        ReservEntry.SetRange("Source Type", TableID);

        if PointerFieldIsActive[2] then
            ReservEntry.SetRange("Source Subtype", OldSubtype)
        else
            ReservEntry.SetRange("Source Subtype", 0);

        if PointerFieldIsActive[4] then
            ReservEntry.SetRange("Source Batch Name", OldBatchName)
        else
            ReservEntry.SetRange("Source Batch Name", '');

        ReservEntry.Lock;

        if ReservEntry.FindSet(true, true) then begin
            W.Open(Text007);
            repeat
                NewReservEntry := ReservEntry;
                if OldSubtype <> NewSubtype then
                    NewReservEntry."Source Subtype" := NewSubtype;
                if OldID <> NewID then
                    NewReservEntry."Source ID" := NewID;
                if OldBatchName <> NewBatchName then
                    NewReservEntry."Source Batch Name" := NewBatchName;
                if OldRefNo <> NewRefNo then
                    NewReservEntry."Source Ref. No." := NewRefNo;
                ReservEntry.Delete;
                NewReservEntry.Insert;
            until ReservEntry.Next = 0;
            W.Close;
        end;
    end;

    local procedure GetActivePointerFields(TableID: Integer; var PointerFieldIsActive: array[6] of Boolean)
    begin

        Clear(PointerFieldIsActive);
        PointerFieldIsActive[1] := true;  // Type

        case TableID of
            Database::"Sales Line", Database::"Purchase Line", Database::"Service Invoice Line":
                begin
                    PointerFieldIsActive[2] := true;  // SubType
                    PointerFieldIsActive[3] := true;  // ID
                    PointerFieldIsActive[6] := true;  // RefNo
                end;
            Database::"Requisition Line": //,Database::Table89:
                begin
                    PointerFieldIsActive[3] := true;  // ID
                    PointerFieldIsActive[4] := true;  // BatchName
                    PointerFieldIsActive[6] := true;  // RefNo
                end;
            Database::"Item Journal Line":
                begin
                    PointerFieldIsActive[2] := true;  // SubType
                    PointerFieldIsActive[3] := true;  // ID
                    PointerFieldIsActive[4] := true;  // BatchName
                    PointerFieldIsActive[6] := true;  // RefNo
                end;
            Database::"Item Ledger Entry":
                begin
                    PointerFieldIsActive[6] := true;  // RefNo
                end;
            Database::"Prod. Order Line":
                begin
                    PointerFieldIsActive[2] := true;  // SubType
                    PointerFieldIsActive[3] := true;  // ID
                    PointerFieldIsActive[5] := true;  // ProdOrderLine
                end;
            Database::"Prod. Order Component", Database::"Transfer Line":
                begin
                    PointerFieldIsActive[2] := true;  // SubType
                    PointerFieldIsActive[3] := true;  // ID
                    PointerFieldIsActive[5] := true;  // ProdOrderLine
                    PointerFieldIsActive[6] := true;  // RefNo
                end;
            Database::"Planning Component":
                begin
                    PointerFieldIsActive[3] := true;  // ID
                    PointerFieldIsActive[4] := true;  // BatchName
                    PointerFieldIsActive[5] := true;  // ProdOrderLine
                    PointerFieldIsActive[6] := true;  // RefNo
                end;
            else
                PointerFieldIsActive[1] := false;  // Type is not used
        end;
    end;


    procedure CheckValidity(ReservEntry: Record "Vehicle Reservation Entry"): Boolean
    begin

        if ReservEntry."Source Type" in [Database::"Sales Line", Database::"Purchase Line"] then
            if not (ReservEntry."Source Subtype" in [1, 5]) then
                exit; // Only order, return order

        if ReservEntry."Source Type" in [Database::"Prod. Order Line", Database::"Prod. Order Component"]
        then
            if ReservEntry."Source Subtype" = 0 then
                exit; // Not simulation

        exit(true);
    end;
}

