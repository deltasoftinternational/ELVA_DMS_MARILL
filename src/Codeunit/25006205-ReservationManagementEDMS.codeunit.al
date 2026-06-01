codeunit 25006205 "Reservation Management EDMS"
{
    //FIXME BC16 Upgrade Needs total refactoring
    // 18.10.2018 EB.P7  FIX
    //   Added function SetServiceReservLoc
    // 
    // 18.01.2017 EB.RC Upgrade 2017
    //   Function Added:
    //     CreateTrackingSpecification
    // 
    // 27.03.2013 EDMS P8
    //   * SMALL FIX
    // 
    // 28.02.2013 EDMS P8 - fix for EDMS Service Management integration

    Permissions = TableData "Item Ledger Entry" = rm,
                  TableData "Reservation Entry" = rimd,
                  TableData "Prod. Order Line" = rimd,
                  TableData "Prod. Order Component" = rimd,
                  TableData "Action Message Entry" = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text003: Label 'CU99000845: CalculateRemainingQty - Source type missing';
        Text004: Label 'Codeunit 99000845: Illegal FieldFilter parameter';
        Text007: Label 'CU99000845 DeleteReservEntries2: Surplus order tracking double record detected.';
        CalcReservEntry: Record "Reservation Entry";
        CalcReservEntry2: Record "Reservation Entry";
        CalcItemLedgEntry: Record "Item Ledger Entry";
        ForServiceLineEDMS: Record "Service Line EDMS";
        CalcServiceLineEDMS: Record "Service Line EDMS";
        Item: Record Item;
        Location: Record Location;
        MfgSetup: Record "Manufacturing Setup";
        SKU: Record "Stockkeeping Unit";
        ItemTrackingCode: Record "Item Tracking Code";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        CallTrackingSpecification: Record "Tracking Specification";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveServiceLineEDMS: Codeunit "Service Line EDMS-Reserve";
        CreatePick: Codeunit "Create Pick";
        UOMMgt: Codeunit "Unit of Measure Management";
        LateBindingMgt: Codeunit "Late Binding Management";
        ItemTrackingType: Enum "Item Tracking Type";
        SourceRecRef: RecordRef;
        RefOrderType: Option;
        PlanningLineOrigin: Option;
        Positive: Boolean;
        CurrentBindingIsSet: Boolean;
        HandleItemTracking: Boolean;
        InvSearch: Text[1];
        FieldFilter: Text;
        InvNextStep: Integer;
        ValueArray: array[30] of Integer;
        CurrentBinding: Enum "Reservation Binding";
        ItemTrackingHandling: Option "None","Allow deletion",Match;
        Text008: Label 'Item tracking defined for item %1 in the %2 accounts for more than the quantity you have entered.\You must adjust the existing item tracking and then reenter the new quantity.';
        ItemTrackingCannotBeFullyMatchedErr: Label 'Item Tracking cannot be fully matched.\Serial No.: %1, Lot No.: %2, outstanding quantity: %3.';
        Text010: Label 'Item tracking is defined for item %1 in the %2.\You must delete the existing item tracking before modifying or deleting the %2.';
        TotalAvailQty: Decimal;
        QtyAllocInWhse: Decimal;
        QtyOnOutBound: Decimal;
        Text011: Label 'Item tracking is defined for item %1 in the %2.\Do you want to delete the %2 and the item tracking lines?';
        QtyReservedOnPickShip: Decimal;
        AssemblyTxt: Label 'Assembly';
        DeleteDocLineWithItemReservQst: Label '%1 %2 has item reservation. Do you want to delete it anyway?', Comment = '%1 = Document Type, %2 = Document No.';
        DeleteTransLineWithItemReservQst: Label 'Transfer order %1 has item reservation. Do you want to delete it anyway?', Comment = '%1 = Document No.';
        DeleteProdOrderLineWithItemReservQst: Label '%1 production order %2 has item reservation. Do you want to delete it anyway?', Comment = '%1 = Status, %2 = Prod. Order No.';
        SkipUntrackedSurplus: Boolean;
        ServSpecEDMS: Boolean;
        ServSpecDocType: Integer;
        ServSpecDocNo: Code[20];
        ServSpecLoc: Code[20];
        ServTransfMgt: Codeunit "Service Transfer Mgt.";
        SpecSummEntryNo: Integer;
        ReservationManagement: Codeunit "Reservation Management";

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

    procedure SetCalcReservEntry(TrackingSpecification: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        // Late Binding
        CalcReservEntry.TransferFields(TrackingSpecification);
        SourceQuantity(CalcReservEntry, true);
        CalcReservEntry.CopyTrackingFromSpec(TrackingSpecification);
        ReservEntry := CalcReservEntry;
        HandleItemTracking := true;
    end;

    procedure SetOrderTrackingSurplusEntries(var TempReservEntry: Record "Reservation Entry" temporary)
    begin
        // Late Binding
        LateBindingMgt.SetOrderTrackingSurplusEntries(TempReservEntry);
    end;

    procedure SetReservSource(NewRecordVar: Variant)
    begin
        SourceRecRef.GetTable(NewRecordVar);
        SetReservSource(SourceRecRef, "Transfer Direction"::Outbound);
    end;

    procedure SetReservSource(NewRecordVar: Variant; Direction: Enum "Transfer Direction")
    begin
        SourceRecRef.GetTable(NewRecordVar);
        SetReservSource(SourceRecRef, Direction);
    end;

    procedure SetReservSource(NewSourceRecRef: RecordRef)
    begin
        SetReservSource(NewSourceRecRef, "Transfer Direction"::Outbound);
    end;

    procedure SetReservSource(NewSourceRecRef: RecordRef; Direction: Enum "Transfer Direction")
    begin
        ClearAll;
        TempTrackingSpecification.DeleteAll();

        SourceRecRef := NewSourceRecRef;

        OnSetReservSource(SourceRecRef, CalcReservEntry, Direction);
        case SourceRecRef.Number of
            DATABASE::"Sales Line":
                SetSourceForSalesLine();
            DATABASE::"Requisition Line":
                SetSourceForReqLine();
            DATABASE::"Purchase Line":
                SetSourceForPurchLine();
            DATABASE::"Item Journal Line":
                SetSourceForItemJnlLine();
            DATABASE::"Item Ledger Entry":
                SetSourceForItemLedgerEntry();
            DATABASE::"Prod. Order Line":
                SetSourceForProdOrderLine();
            DATABASE::"Prod. Order Component":
                SetSourceForProdOrderComp();
            DATABASE::"Planning Component":
                SetSourceForPlanningComp();
            DATABASE::"Transfer Line":
                SetSourceForTransferLine(Direction);
            DATABASE::"Service Line":
                SetSourceForServiceLine();
            DATABASE::"Job Journal Line":
                SetSourceForJobJournalLine();
            DATABASE::"Job Planning Line":
                SetSourceForJobPlanningLine();
            DATABASE::"Assembly Header":
                SetSourceForAssemblyHeader();
            DATABASE::"Assembly Line":
                SetSourceForAssemblyLine();
            DATABASE::"Invt. Document Line":
                SetSourceForInvtDocLine();
            Database::"Service Line EDMS":
                SetSourceForServiceLineEDMS();
        end;
    end;

    local procedure SetSourceForAssemblyHeader()
    var
        AssemblyHeader: Record "Assembly Header";
    begin
        SourceRecRef.SetTable(AssemblyHeader);
        AssemblyHeader.SetReservationEntry(CalcReservEntry);
        OnSetAssemblyHeaderOnBeforeUpdateReservation(CalcReservEntry, AssemblyHeader);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * AssemblyHeader."Remaining Quantity (Base)") < 0);
    end;

    local procedure SetSourceForAssemblyLine()
    var
        AssemblyLine: Record "Assembly Line";
    begin
        SourceRecRef.SetTable(AssemblyLine);
        AssemblyLine.SetReservationEntry(CalcReservEntry);
        OnSetAssemblyLineOnBeforeUpdateReservation(CalcReservEntry, AssemblyLine);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * AssemblyLine."Remaining Quantity (Base)") <= 0);
    end;

    local procedure SetSourceForInvtDocLine()
    var
        InvtDocLine: Record "Invt. Document Line";
    begin
        SourceRecRef.SetTable(InvtDocLine);
        InvtDocLine.SetReservationEntry(CalcReservEntry);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * InvtDocLine."Quantity (Base)") < 0);
    end;

    local procedure SetSourceForItemJnlLine()
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        SourceRecRef.SetTable(ItemJnlLine);
        ItemJnlLine.SetReservationEntry(CalcReservEntry);
        OnSetItemJnlLineOnBeforeUpdateReservation(CalcReservEntry, ItemJnlLine);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ItemJnlLine."Quantity (Base)") < 0);
    end;

    local procedure SetSourceForItemLedgerEntry()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        SourceRecRef.SetTable(ItemLedgerEntry);
        ItemLedgerEntry.SetReservationEntry(CalcReservEntry);
        CalcReservEntry.CopyTrackingFromItemLedgEntry(ItemLedgerEntry);
        OnSetItemLedgEntryOnBeforeUpdateReservation(CalcReservEntry, ItemLedgerEntry);
        UpdateReservation(Positive);
    end;

    local procedure SetSourceForJobJournalLine()
    var
        JobJournalLine: Record "Job Journal Line";
    begin
        SourceRecRef.SetTable(JobJournalLine);
        JobJournalLine.SetReservationEntry(CalcReservEntry);
        OnSetJobJnlLineOnBeforeUpdateReservation(CalcReservEntry, JobJournalLine);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * JobJournalLine."Quantity (Base)") < 0);
    end;

    local procedure SetSourceForJobPlanningLine()
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        SourceRecRef.SetTable(JobPlanningLine);
        JobPlanningLine.SetReservationEntry(CalcReservEntry);
        OnSetJobPlanningLineOnBeforeUpdateReservation(CalcReservEntry, JobPlanningLine);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * JobPlanningLine."Remaining Qty. (Base)") <= 0);
    end;

    local procedure SetSourceForReqLine()
    var
        ReqLine: Record "Requisition Line";
    begin
        SourceRecRef.SetTable(ReqLine);
        ReqLine.SetReservationEntry(CalcReservEntry);
        RefOrderType := ReqLine."Ref. Order Type";
        PlanningLineOrigin := ReqLine."Planning Line Origin";
        OnSetReqLineOnBeforeUpdateReservation(CalcReservEntry, ReqLine);
        UpdateReservation(ReqLine."Net Quantity (Base)" < 0);
    end;

    local procedure SetSourceForProdOrderLine()
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        SourceRecRef.SetTable(ProdOrderLine);
        ProdOrderLine.SetReservationEntry(CalcReservEntry);
        OnSetProdOrderLineOnBeforeUpdateReservation(CalcReservEntry, ProdOrderLine);
        UpdateReservation(ProdOrderLine."Remaining Qty. (Base)" < 0);
    end;

    local procedure SetSourceForProdOrderComp()
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        SourceRecRef.SetTable(ProdOrderComp);
        ProdOrderComp.SetReservationEntry(CalcReservEntry);
        OnSetProdOrderCompOnBeforeUpdateReservation(CalcReservEntry, ProdOrderComp);
        UpdateReservation(ProdOrderComp."Remaining Qty. (Base)" > 0);
    end;

    local procedure SetSourceForPlanningComp()
    var
        PlanningComponent: Record "Planning Component";
    begin
        SourceRecRef.SetTable(PlanningComponent);
        PlanningComponent.SetReservationEntry(CalcReservEntry);
        OnSetPlanningCompOnBeforeUpdateReservation(CalcReservEntry, PlanningComponent);
        UpdateReservation(PlanningComponent."Net Quantity (Base)" > 0);
    end;

    local procedure SetSourceForPurchLine()
    var
        PurchLine: Record "Purchase Line";
    begin
        SourceRecRef.SetTable(PurchLine);
        PurchLine.SetReservationEntry(CalcReservEntry);
        OnSetPurchLineOnBeforeUpdateReservation(CalcReservEntry, PurchLine);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * PurchLine."Outstanding Qty. (Base)") < 0);
    end;

    local procedure SetSourceForTransferLine(Direction: Enum "Transfer Direction")
    var
        TransferLine: Record "Transfer Line";
    begin
        SourceRecRef.SetTable(TransferLine);
        TransferLine.SetReservationEntry(CalcReservEntry, Direction);
        OnSetTransLineOnBeforeUpdateReservation(CalcReservEntry, TransferLine);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * TransferLine."Outstanding Qty. (Base)") <= 0);
        //EDMS 21.07.08 >>
        if (Direction = Direction::Outbound) and (ServTransfMgt.IsServiceLocation(TransferLine."Transfer-from Code")) then begin
            if TransferLine."Source No." <> '' then
                SetServiceReserv(TransferLine."Source Subtype",
                                          TransferLine."Source No.");
        end
        else begin
            if (Direction = Direction::Inbound) and (ServTransfMgt.IsServiceLocation(TransferLine."Transfer-to Code")) then begin
                if TransferLine."Source No." <> '' then
                    SetServiceReserv(TransferLine."Source Subtype",
                                              TransferLine."Source No.");
            end;
        end;
        //EDMS 21.07.08 <<
    end;


    procedure SetServLineEDMS(NewServiceLineEDMS: Record "Service Line EDMS")
    begin
        ClearAll;
        TempTrackingSpecification.DeleteAll;

        ForServiceLineEDMS := NewServiceLineEDMS;

        CalcReservEntry."Source Type" := Database::"Service Line EDMS";
        CalcReservEntry."Source Subtype" := NewServiceLineEDMS."Document Type";
        CalcReservEntry."Source ID" := NewServiceLineEDMS."Document No.";
        CalcReservEntry."Source Ref. No." := NewServiceLineEDMS."Line No.";

        if NewServiceLineEDMS.Type = NewServiceLineEDMS.Type::Item then
            CalcReservEntry."Item No." := NewServiceLineEDMS."No.";
        CalcReservEntry."Variant Code" := NewServiceLineEDMS."Variant Code";
        CalcReservEntry."Location Code" := NewServiceLineEDMS."Location Code";
        CalcReservEntry."Serial No." := '';
        CalcReservEntry."Lot No." := '';
        CalcReservEntry."Qty. per Unit of Measure" := NewServiceLineEDMS."Qty. per Unit of Measure";
        CalcReservEntry."Expected Receipt Date" := NewServiceLineEDMS."Planned Service Date";
        CalcReservEntry."Shipment Date" := NewServiceLineEDMS."Planned Service Date";
        CalcReservEntry.Description := NewServiceLineEDMS.Description;
        CalcReservEntry2 := CalcReservEntry;

        GetItemSetup(CalcReservEntry);

        Positive :=
          ((CreateReservEntry.SignFactor(CalcReservEntry) * ForServiceLineEDMS."Outstanding Qty. (Base)") <= 0);

        SetPointerFilter(CalcReservEntry2);

        if (CalcReservEntry."Location Code" <> '') and
           Location.Get(CalcReservEntry."Location Code") and
           (Location."Bin Mandatory" or Location."Require Pick")
        then
            CalcReservedQtyOnPick(TotalAvailQty, QtyAllocInWhse);

        SetServiceReserv(NewServiceLineEDMS."Document Type",
                         NewServiceLineEDMS."Document No.");
    end;

    local procedure SetSourceForSalesLine()
    var
        SalesLine: Record "Sales Line";
    begin
        SourceRecRef.SetTable(SalesLine);
        SalesLine.SetReservationEntry(CalcReservEntry);
        OnSetSalesLineOnBeforeUpdateReservation(CalcReservEntry, SalesLine);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * SalesLine."Outstanding Qty. (Base)") <= 0);
        OnAfterSetSourceForSalesLine(CalcReservEntry, SalesLine);
    end;

    local procedure SetSourceForServiceLine()
    var
        ServiceLine: Record "Service Line";
    begin
        SourceRecRef.SetTable(ServiceLine);
        ServiceLine.SetReservationEntry(CalcReservEntry);
        OnSetServLineOnBeforeUpdateReservation(CalcReservEntry, ServiceLine);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ServiceLine."Outstanding Qty. (Base)") <= 0);
    end;

    local procedure SetSourceForServiceLineEDMS()
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        SourceRecRef.SetTable(ServiceLineEDMS);
        ServiceLineEDMS.SetReservationEntry(CalcReservEntry);
        OnSetServLineEDMSOnBeforeUpdateReservation(CalcReservEntry, ServiceLineEDMS);
        UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ServiceLineEDMS."Outstanding Qty. (Base)") <= 0);
    end;

    procedure SetSalesLine(NewSalesLine: Record "Sales Line")
    begin
        SourceRecRef.GetTable(NewSalesLine);
        SetReservSource(SourceRecRef);
    end;

    procedure SetReqLine(NewReqLine: Record "Requisition Line")
    begin
        SourceRecRef.GetTable(NewReqLine);
        SetReservSource(SourceRecRef);
    end;

    procedure SetPurchLine(NewPurchLine: Record "Purchase Line")
    begin
        SourceRecRef.GetTable(NewPurchLine);
        SetReservSource(SourceRecRef);
    end;

    procedure SetItemJnlLine(NewItemJnlLine: Record "Item Journal Line")
    begin
        SourceRecRef.GetTable(NewItemJnlLine);
        SetReservSource(SourceRecRef);
    end;


    procedure SetProdOrderLine(NewProdOrderLine: Record "Prod. Order Line")
    begin
        SourceRecRef.GetTable(NewProdOrderLine);
        SetReservSource(SourceRecRef);
    end;


    procedure SetProdOrderComponent(NewProdOrderComp: Record "Prod. Order Component")
    begin
        SourceRecRef.GetTable(NewProdOrderComp);
        SetReservSource(SourceRecRef);
    end;


    procedure SetAssemblyHeader(NewAssemblyHeader: Record "Assembly Header")
    begin
        SourceRecRef.GetTable(NewAssemblyHeader);
        SetReservSource(SourceRecRef);
    end;


    procedure SetAssemblyLine(NewAssemblyLine: Record "Assembly Line")
    begin
        SourceRecRef.GetTable(NewAssemblyLine);
        SetReservSource(SourceRecRef);
    end;


    procedure SetPlanningComponent(NewPlanningComponent: Record "Planning Component")
    begin
        SourceRecRef.GetTable(NewPlanningComponent);
        SetReservSource(SourceRecRef);
    end;


    procedure SetItemLedgEntry(NewItemLedgEntry: Record "Item Ledger Entry")
    begin
        SourceRecRef.GetTable(NewItemLedgEntry);
        SetReservSource(SourceRecRef);
    end;


    procedure SetTransferLine(NewTransLine: Record "Transfer Line"; TransferDirection: Enum "Transfer Direction")
    begin
        SourceRecRef.GetTable(NewTransLine);
        SetReservSource(SourceRecRef, TransferDirection);
    end;


    procedure SetServLine(NewServiceLine: Record "Service Line")
    begin
        SourceRecRef.GetTable(NewServiceLine);
        SetReservSource(SourceRecRef);
    end;


    procedure SetJobJnlLine(NewJobJnlLine: Record "Job Journal Line")
    begin
        SourceRecRef.GetTable(NewJobJnlLine);
        SetReservSource(SourceRecRef);
    end;


    procedure SetJobPlanningLine(NewJobPlanningLine: Record "Job Planning Line")
    begin
        SourceRecRef.GetTable(NewJobPlanningLine);
        SetReservSource(SourceRecRef);
    end;


    procedure SetExternalDocumentResEntry(ReservEntry: Record "Reservation Entry"; UpdReservation: Boolean)
    begin
        ClearAll;
        TempTrackingSpecification.DeleteAll();
        CalcReservEntry := ReservEntry;
        UpdateReservation(UpdReservation);
    end;



    procedure SalesLineUpdateValues(var CurrentSalesLine: Record "Sales Line"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal)
    begin
        CurrentSalesLine.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
    end;


    procedure ReqLineUpdateValues(var CurrentReqLine: Record "Requisition Line"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal)
    begin
        CurrentReqLine.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
    end;


    procedure PurchLineUpdateValues(var CurrentPurchLine: Record "Purchase Line"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal)
    begin
        CurrentPurchLine.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
    end;


    procedure ProdOrderLineUpdateValues(var CurrentProdOrderLine: Record "Prod. Order Line"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal)
    begin
        CurrentProdOrderLine.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
    end;


    procedure ProdOrderCompUpdateValues(var CurrentProdOrderComp: Record "Prod. Order Component"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal)
    begin
        CurrentProdOrderComp.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
    end;


    procedure AssemblyHeaderUpdateValues(var CurrentAssemblyHeader: Record "Assembly Header"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal)
    begin
        CurrentAssemblyHeader.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
    end;


    procedure ServiceLineEDMSUpdateValues(var CurrentServiceLineEDMS: Record "Service Line EDMS"; var QtyToReserve: Decimal; var QtyReservedThisLine: Decimal)
    begin
        CurrentServiceLineEDMS.CalcFields("Reserved Qty. (Base)");
        QtyReservedThisLine := CurrentServiceLineEDMS."Reserved Qty. (Base)";
        QtyToReserve := CurrentServiceLineEDMS."Outstanding Qty. (Base)" - CurrentServiceLineEDMS."Reserved Qty. (Base)";
    end;


    procedure AssemblyLineUpdateValues(var CurrentAssemblyLine: Record "Assembly Line"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal)
    begin
        CurrentAssemblyLine.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
    end;

    procedure PlanningComponentUpdateValues(var CurrentPlanningComponent: Record "Planning Component"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal)
    begin
        CurrentPlanningComponent.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
    end;

    procedure ItemLedgEntryUpdateValues(var CurrentItemLedgEntry: Record "Item Ledger Entry"; var QtyToReserve: Decimal; var QtyReserved: Decimal)
    begin
        CurrentItemLedgEntry.GetReservationQty(QtyReserved, QtyToReserve);
    end;


    procedure ServiceInvLineUpdateValues(var CurrentServiceLine: Record "Service Line"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal)
    begin
        CurrentServiceLine.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
    end;


    procedure TransferLineUpdateValues(var CurrentTransLine: Record "Transfer Line"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal; TransferDirection: Enum "Transfer Direction")
    begin
        CurrentTransLine.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase, TransferDirection.AsInteger());
    end;


    procedure JobPlanningLineUpdateValues(var CurrentJobPlanningLine: Record "Job Planning Line"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal)
    begin
        CurrentJobPlanningLine.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
    end;


    local procedure UpdateReservation(EntryIsPositive: Boolean)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateReservation(SourceRecRef, CalcReservEntry, IsHandled);
        if IsHandled then
            exit;

        CalcReservEntry2 := CalcReservEntry;
        GetItemSetup(CalcReservEntry);
        Positive := EntryIsPositive;
        CalcReservEntry2.SetPointerFilter();
        CallCalcReservedQtyOnPick();
    end;

    procedure UpdateStatistics(var TempEntrySummary: Record "Entry Summary" temporary; AvailabilityDate: Date; HandleItemTracking2: Boolean)
    var
        i: Integer;
        CurrentEntryNo: Integer;
        ValueArrayNo: Integer;
        TotalQuantity: Decimal;
        CalcSumValue: Decimal;
    begin
        CurrentEntryNo := TempEntrySummary."Entry No.";
        CalcReservEntry.TestField("Source Type");
        TempEntrySummary.DeleteAll();
        HandleItemTracking := HandleItemTracking2;
        if HandleItemTracking2 then
            ValueArrayNo := 3;
        for i := 1 to SetValueArray(ValueArrayNo) do begin
            TotalQuantity := 0;
            TempEntrySummary.Init();
            TempEntrySummary."Entry No." := ValueArray[i];

            case ValueArray[i] of
                "Reservation Summary Type"::"Item Ledger Entry".AsInteger():
                    UpdateItemLedgEntryStats(CalcReservEntry, TempEntrySummary, TotalQuantity, HandleItemTracking2);
                220, 230: // Service Order EDMS, Service Return Order - 08.07.08 EDMS P1
                    UpdateServLineEDMSStats(TempEntrySummary, AvailabilityDate, i, CalcSumValue);
                "Reservation Summary Type"::"Item Tracking Line".AsInteger():
                    UpdateItemTrackingLineStats(CalcReservEntry, TempEntrySummary, AvailabilityDate);
            end;

            OnUpdateStatistics(CalcReservEntry, TempEntrySummary, AvailabilityDate, Positive, TotalQuantity);
        end;

        OnAfterUpdateStatistics(TempEntrySummary, AvailabilityDate, TotalQuantity);

        if not TempEntrySummary.Get(CurrentEntryNo) then
            if TempEntrySummary.IsEmpty() then
                Clear(TempEntrySummary);
    end;

    local procedure UpdateItemLedgEntryStats(CalcReservEntry: Record "Reservation Entry"; var TempEntrySummary: Record "Entry Summary" temporary; var CalcSumValue: Decimal; HandleItemTracking2: Boolean)
    var
        ReservForm: Page Reservation;
        CurrReservedQtyBase: Decimal;
    begin
        OnBeforeUpdateItemLedgEntryStats(CalcReservEntry);
        if CalcItemLedgEntry.ReadPermission then begin
            CalcItemLedgEntry.FilterLinesForReservation(CalcReservEntry, Positive);
            CalcItemLedgEntry.FilterLinesForTracking(CalcReservEntry, Positive);
            OnAfterInitFilter(CalcReservEntry, 1);
            if CalcItemLedgEntry.FindSet then
                repeat
                    CalcItemLedgEntry.CalcFields("Reserved Quantity");
                    OnUpdateItemLedgEntryStatsUpdateTotals(CalcReservEntry, CalcItemLedgEntry, TotalAvailQty, QtyOnOutBound);
                    TempEntrySummary."Total Reserved Quantity" += CalcItemLedgEntry."Reserved Quantity";
                    CalcSumValue += CalcItemLedgEntry."Remaining Quantity";
                until CalcItemLedgEntry.Next() = 0;
            if HandleItemTracking2 then
                if TempEntrySummary."Total Reserved Quantity" > 0 then
                    TempEntrySummary."Non-specific Reserved Qty." := LateBindingMgt.NonspecificReservedQty(CalcItemLedgEntry);

            if CalcSumValue <> 0 then
                if (CalcSumValue > 0) = Positive then begin
                    if Location.Get(CalcItemLedgEntry."Location Code") and
                       (Location."Bin Mandatory" or Location."Require Pick")
                    then begin
                        CalcReservedQtyOnPick(TotalAvailQty, QtyAllocInWhse);
                        QtyOnOutBound :=
                          CreatePick.CheckOutBound(
                            CalcReservEntry."Source Type", CalcReservEntry."Source Subtype",
                            CalcReservEntry."Source ID", CalcReservEntry."Source Ref. No.",
                            CalcReservEntry."Source Prod. Order Line");
                    end else begin
                        QtyAllocInWhse := 0;
                        QtyOnOutBound := 0;
                    end;
                    if QtyAllocInWhse < 0 then
                        QtyAllocInWhse := 0;

                    TempEntrySummary."Table ID" := DATABASE::"Item Ledger Entry";
                    TempEntrySummary."Summary Type" :=
                      CopyStr(CalcItemLedgEntry.TableCaption, 1, MaxStrLen(TempEntrySummary."Summary Type"));
                    TempEntrySummary."Total Quantity" := CalcSumValue;
                    TempEntrySummary."Total Available Quantity" :=
                      TempEntrySummary."Total Quantity" - TempEntrySummary."Total Reserved Quantity";

                    Clear(ReservForm);
                    ReservForm.SetReservEntry(CalcReservEntry);
                    CurrReservedQtyBase := ReservForm.ReservedThisLine(TempEntrySummary);
                    if (CurrReservedQtyBase <> 0) and (QtyOnOutBound <> 0) then
                        if QtyOnOutBound > CurrReservedQtyBase then
                            QtyOnOutBound := QtyOnOutBound - CurrReservedQtyBase
                        else
                            QtyOnOutBound := 0;

                    if Location."Bin Mandatory" or Location."Require Pick" then begin
                        if TotalAvailQty + QtyOnOutBound < TempEntrySummary."Total Available Quantity" then
                            TempEntrySummary."Total Available Quantity" := TotalAvailQty + QtyOnOutBound;
                        TempEntrySummary."Qty. Alloc. in Warehouse" := QtyAllocInWhse;
                        TempEntrySummary."Res. Qty. on Picks & Shipmts." := QtyReservedOnPickShip
                    end else begin
                        TempEntrySummary."Qty. Alloc. in Warehouse" := 0;
                        TempEntrySummary."Res. Qty. on Picks & Shipmts." := 0
                    end;

                    if not TempEntrySummary.Insert() then
                        TempEntrySummary.Modify();
                end;
        end;
    end;

    local procedure UpdateItemTrackingLineStats(CalcReservEntry: Record "Reservation Entry"; var TempEntrySummary: Record "Entry Summary"; AvailabilityDate: Date)
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.Reset();
        ReservEntry.SetCurrentKey(
          "Item No.", "Source Type", "Source Subtype", "Reservation Status", "Location Code",
          "Variant Code", "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");
        ReservEntry.SetRange("Item No.", CalcReservEntry."Item No.");
        ReservEntry.SetFilter("Source Type", '<> %1', DATABASE::"Item Ledger Entry");
        ReservEntry.SetRange("Reservation Status",
          ReservEntry."Reservation Status"::Reservation, ReservEntry."Reservation Status"::Surplus);
        ReservEntry.SetRange("Location Code", CalcReservEntry."Location Code");
        ReservEntry.SetRange("Variant Code", CalcReservEntry."Variant Code");
        if Positive then
            ReservEntry.SetFilter("Expected Receipt Date", '..%1', AvailabilityDate)
        else
            ReservEntry.SetFilter("Shipment Date", '>=%1', AvailabilityDate);
        ReservEntry.SetTrackingFilterFromReservEntry(CalcReservEntry);
        ReservEntry.SetRange(Positive, Positive);
        if ReservEntry.FindSet then
            repeat
                ReservEntry.SetRange("Source Type", ReservEntry."Source Type");
                ReservEntry.SetRange("Source Subtype", ReservEntry."Source Subtype");
                TempEntrySummary.Init();
                TempEntrySummary."Entry No." := ReservEntry.SummEntryNo;
                TempEntrySummary."Table ID" := ReservEntry."Source Type";
                TempEntrySummary."Summary Type" :=
                  CopyStr(ReservEntry.TextCaption, 1, MaxStrLen(TempEntrySummary."Summary Type"));
                TempEntrySummary."Source Subtype" := ReservEntry."Source Subtype";
                TempEntrySummary.CopyTrackingFromReservEntry(ReservEntry);
                if ReservEntry.FindSet then
                    repeat
                        TempEntrySummary."Total Quantity" += ReservEntry."Quantity (Base)";
                        if ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Reservation then
                            TempEntrySummary."Total Reserved Quantity" += ReservEntry."Quantity (Base)";
                        if CalcReservEntry.HasSamePointer(ReservEntry) then
                            TempEntrySummary."Current Reserved Quantity" += ReservEntry."Quantity (Base)";
                    until ReservEntry.Next() = 0;
                TempEntrySummary."Total Available Quantity" :=
                  TempEntrySummary."Total Quantity" - TempEntrySummary."Total Reserved Quantity";
                OnUpdateItemTrackingLineStatsOnBeforeReservEntrySummaryInsert(TempEntrySummary, ReservEntry);
                TempEntrySummary.Insert();
                ReservEntry.SetRange("Source Type");
                ReservEntry.SetRange("Source Subtype");
            until ReservEntry.Next() = 0;
    end;

    local procedure UpdateServLineEDMSStats(var ReservEntrySummary: Record "Entry Summary"; AvailabilityDate: Date; i: Integer; var CalcSumValue: Decimal)
    begin
        if CalcServiceLineEDMS.ReadPermission
        then begin
            InitFilterEDMS(ValueArray[i], AvailabilityDate);
            if CalcServiceLineEDMS.FindSet then
                repeat
                    CalcServiceLineEDMS.CalcFields("Reserved Qty. (Base)");
                    ReservEntrySummary."Total Reserved Quantity" -= CalcServiceLineEDMS."Reserved Qty. (Base)";
                    CalcSumValue += CalcServiceLineEDMS."Outstanding Qty. (Base)";
                until CalcServiceLineEDMS.Next = 0;

            if CalcSumValue <> 0 then
                if (Positive = (CalcSumValue < 0)) and (ValueArray[i] <> 230) or
                   (Positive = (CalcSumValue > 0)) and (ValueArray[i] = 230)
                then begin
                    ReservEntrySummary."Table ID" := Database::"Service Line EDMS";
                    ReservEntrySummary."Summary Type" :=
                      CopyStr(
                        StrSubstNo('%1', CalcServiceLineEDMS.TableCaption),
                        1, MaxStrLen(ReservEntrySummary."Summary Type"));
                    if ValueArray[i] = 230 then
                        ReservEntrySummary."Total Quantity" := CalcSumValue
                    else
                        ReservEntrySummary."Total Quantity" := -CalcSumValue;
                    ReservEntrySummary."Total Available Quantity" :=
                      ReservEntrySummary."Total Quantity" - ReservEntrySummary."Total Reserved Quantity";
                    if not ReservEntrySummary.Insert then
                        ReservEntrySummary.Modify;
                end;
        end;
    end;

    procedure AutoReserve(var FullAutoReservation: Boolean; Description: Text[100]; AvailabilityDate: Date; MaxQtyToReserve: Decimal; MaxQtyToReserveBase: Decimal)
    var
        SalesLine: Record "Sales Line";
        RemainingQtyToReserve: Decimal;
        RemainingQtyToReserveBase: Decimal;
        i: Integer;
        ValueArrayNo: Integer;
        StopReservation: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeAutoReserve(CalcReservEntry, FullAutoReservation, Description, AvailabilityDate, MaxQtyToReserve, MaxQtyToReserveBase, IsHandled);
        if IsHandled then
            exit;

        CalcReservEntry.TestField("Source Type");

        if CalcReservEntry."Source Type" in [DATABASE::"Sales Line", DATABASE::"Purchase Line", DATABASE::"Service Line"] then
            StopReservation := not (CalcReservEntry."Source Subtype" in [1, 5]); // Only order and return order

        //09.07.08 EDMS P1 - Added EDMS >>
        if CalcReservEntry."Source Type" in [Database::"Service Line EDMS"] then
            StopReservation := not (CalcReservEntry."Source Subtype" in [1, 2]); // Only order and return order
        //09.07.08 EDMS P1 - Added EDMS <<

        if CalcReservEntry."Source Type" in [DATABASE::"Assembly Line", DATABASE::"Assembly Header"] then
            StopReservation := not (CalcReservEntry."Source Subtype" = 1); // Only Assembly Order

        if CalcReservEntry."Source Type" in [DATABASE::"Prod. Order Line", DATABASE::"Prod. Order Component"]
        then
            StopReservation := CalcReservEntry."Source Subtype" < 2; // Not simulated or planned

        if CalcReservEntry."Source Type" = DATABASE::"Sales Line" then begin
            SourceRecRef.SetTable(SalesLine);
            if (CalcReservEntry."Source Subtype" = 1) and (SalesLine.Quantity < 0) then
                StopReservation := true;
            if (CalcReservEntry."Source Subtype" = 5) and (SalesLine.Quantity >= 0) then
                StopReservation := true;
        end;

        if CalcReservEntry."Source Type" = DATABASE::"Job Planning Line" then
            StopReservation := CalcReservEntry."Source Subtype" <> 2;

        OnAutoReserveOnBeforeStopReservation(CalcReservEntry, FullAutoReservation, AvailabilityDate, MaxQtyToReserve, MaxQtyToReserveBase, StopReservation);
        if StopReservation then begin
            FullAutoReservation := true;
            exit;
        end;

        CalculateRemainingQty(RemainingQtyToReserve, RemainingQtyToReserveBase);
        if (MaxQtyToReserveBase <> 0) and (Abs(MaxQtyToReserveBase) < Abs(RemainingQtyToReserveBase)) then begin
            RemainingQtyToReserve := MaxQtyToReserve;
            RemainingQtyToReserveBase := MaxQtyToReserveBase;
        end;

        if (RemainingQtyToReserveBase <> 0) and
           HandleItemTracking and
           ItemTrackingCode."SN Specific Tracking"
        then
            RemainingQtyToReserveBase := 1;
        FullAutoReservation := false;

        if RemainingQtyToReserveBase = 0 then begin
            FullAutoReservation := true;
            exit;
        end;

        OnAutoReserveOnBeforeSetValueArray(ValueArrayNo);
        for i := 1 to SetValueArray(ValueArrayNo) do
            AutoReserveOneLine(ValueArray[i], RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate);

        FullAutoReservation := (RemainingQtyToReserveBase = 0);

        OnAfterAutoReserve(CalcReservEntry, FullAutoReservation);
    end;

    procedure AutoReserveOneLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date)
    var
        Item: Record Item;
        ReservSummaryType: Enum "Reservation Summary Type";
        Search: Text[1];
        NextStep: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeAutoReserveOneLine(IsHandled);
        if IsHandled then
            exit;

        CalcReservEntry.TestField("Source Type");

        if RemainingQtyToReserveBase = 0 then
            exit;

        if not Item.Get(CalcReservEntry."Item No.") then
            Clear(Item);

        CalcReservEntry.Lock();

        if Positive then begin
            Search := '+';
            NextStep := -1;
            if Item."Costing Method" = Item."Costing Method"::LIFO then begin
                InvSearch := '+';
                InvNextStep := -1;
            end else begin
                InvSearch := '-';
                InvNextStep := 1;
            end;
        end else begin
            Search := '-';
            NextStep := 1;
            InvSearch := '-';
            InvNextStep := 1;
        end;

        ReservSummaryType := "Reservation Summary Type".FromInteger(ReservSummEntryNo);

        OnAutoReserveOneLineOnAfterUpdateSearchNextStep(Item, Positive, Search, NextStep, InvSearch, InvNextStep);

        case ReservSummaryType of
            "Reservation Summary Type"::"Item Ledger Entry":
                AutoReserveItemLedgEntry(
                    ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate);
            "Reservation Summary Type"::"Purchase Order",
            "Reservation Summary Type"::"Purchase Return Order":
                AutoReservePurchLine(
                    ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);
            "Reservation Summary Type"::"Sales Quote",
            "Reservation Summary Type"::"Sales Order",
            "Reservation Summary Type"::"Sales Return Order":
                AutoReserveSalesLine(
                    ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);
            "Reservation Summary Type"::"Simulated Production Order",
            "Reservation Summary Type"::"Planned Production Order",
            "Reservation Summary Type"::"Firm Planned Production Order",
            "Reservation Summary Type"::"Released Production Order":
                AutoReserveProdOrderLine(
                    ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);
            "Reservation Summary Type"::"Simulated Prod. Order Comp.",
            "Reservation Summary Type"::"Planned Prod. Order Comp.",
            "Reservation Summary Type"::"Firm Planned Prod. Order Comp.",
            "Reservation Summary Type"::"Released Prod. Order Comp.":
                AutoReserveProdOrderComp(
                    ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);
            "Reservation Summary Type"::"Transfer Shipment",
            "Reservation Summary Type"::"Transfer Receipt":
                AutoReserveTransLine(
                    ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);
            "Reservation Summary Type"::"Service Order":
                AutoReserveServLine(
                    ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);
            "Reservation Summary Type"::"Job Planning Order":
                AutoReserveJobPlanningLine(
                    ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);
            "Reservation Summary Type"::"Assembly Order Header":
                AutoReserveAssemblyHeader(
                    ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);
            "Reservation Summary Type"::"Assembly Order Line":
                AutoReserveAssemblyLine(
                  ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);
            "Reservation Summary Type"::"Inventory Receipt",
            "Reservation Summary Type"::"Inventory Shipment":
                AutoInvtDocLineReserve(
                  ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);
            220, 230: // Service Line EDMS
                AutoReserveServLineEDMS(ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep);  //28.02.2013 EDMS P8
            else
                OnAfterAutoReserveOneLine(
                  ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, Search, NextStep, CalcReservEntry, CalcReservEntry2, Positive);
        end;
    end;

    local procedure AutoReserveItemLedgEntry(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date)
    var
        Location: Record Location;
        AllocationsChanged: Boolean;
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        IsReserved: Boolean;
        IsHandled: Boolean;
        IsFound: Boolean;
    begin
        IsReserved := false;
        OnBeforeAutoReserveItemLedgEntry(
          ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, IsReserved, CalcReservEntry);
        if IsReserved then
            exit;

        if not Location.Get(CalcReservEntry."Location Code") then
            Clear(Location);

        CalcItemLedgEntry.FilterLinesForReservation(CalcReservEntry, Positive);
        CalcItemLedgEntry.FilterLinesForTracking(CalcReservEntry, Positive);

        // Late Binding
        if HandleItemTracking then
            AllocationsChanged :=
              LateBindingMgt.ReleaseForReservation(CalcItemLedgEntry, CalcReservEntry, RemainingQtyToReserveBase);

        IsFound := false;
        IsHandled := false;
        OnAutoReserveItemLedgEntryOnFindFirstItemLedgEntry(CalcReservEntry, CalcItemLedgEntry, InvSearch, IsHandled, IsFound);
        if not IsHandled then
            IsFound := CalcItemLedgEntry.Find(InvSearch);
        if IsFound then begin
            if Location."Bin Mandatory" or Location."Require Pick" then begin
                QtyOnOutBound :=
                  CreatePick.CheckOutBound(
                    CalcReservEntry."Source Type", CalcReservEntry."Source Subtype",
                    CalcReservEntry."Source ID", CalcReservEntry."Source Ref. No.",
                    CalcReservEntry."Source Prod. Order Line") -
                  CalcCurrLineReservQtyOnPicksShips(CalcReservEntry);
                if AllocationsChanged then
                    CalcReservedQtyOnPick(TotalAvailQty, QtyAllocInWhse); // If allocations have changed we must recalculate
            end;
            repeat
                CalcItemLedgEntry.CalcFields("Reserved Quantity");
                if (CalcItemLedgEntry."Remaining Quantity" -
                    CalcItemLedgEntry."Reserved Quantity") <> 0
                then begin
                    if Abs(CalcItemLedgEntry."Remaining Quantity" -
                         CalcItemLedgEntry."Reserved Quantity") > Abs(RemainingQtyToReserveBase)
                    then begin
                        QtyThisLine := Abs(RemainingQtyToReserve);
                        QtyThisLineBase := Abs(RemainingQtyToReserveBase);
                    end else begin
                        QtyThisLineBase :=
                          CalcItemLedgEntry."Remaining Quantity" - CalcItemLedgEntry."Reserved Quantity";
                        QtyThisLine := 0;
                    end;
                    if (FindUnfinishedSpecialOrderSalesNo(CalcItemLedgEntry) <> '') or (Positive = (QtyThisLineBase < 0)) then begin
                        QtyThisLineBase := 0;
                        QtyThisLine := 0;
                    end;

                    if (Location."Bin Mandatory" or Location."Require Pick") and
                       (TotalAvailQty + QtyOnOutBound < QtyThisLineBase)
                    then
                        if (TotalAvailQty + QtyOnOutBound) < 0 then begin
                            QtyThisLineBase := 0;
                            QtyThisLine := 0
                        end else begin
                            QtyThisLineBase := TotalAvailQty + QtyOnOutBound;
                            QtyThisLine := Round(QtyThisLineBase, UOMMgt.QtyRndPrecision);
                        end;

                    OnAfterCalcReservation(CalcReservEntry, CalcItemLedgEntry, ReservSummEntryNo, QtyThisLine, QtyThisLineBase);

                    CallTrackingSpecification.InitTrackingSpecification(
                      DATABASE::"Item Ledger Entry", 0, '', '', 0, CalcItemLedgEntry."Entry No.",
                      CalcItemLedgEntry."Variant Code", CalcItemLedgEntry."Location Code", CalcItemLedgEntry."Qty. per Unit of Measure");
                    CallTrackingSpecification.CopyTrackingFromItemLedgEntry(CalcItemLedgEntry);

                    if InsertReservationEntries(
                        RemainingQtyToReserve, RemainingQtyToReserveBase, 0,
                        Description, 0D, QtyThisLine, QtyThisLineBase, CallTrackingSpecification)
                    then
                        if Location."Bin Mandatory" or Location."Require Pick" then
                            TotalAvailQty := TotalAvailQty - QtyThisLineBase;
                end;

                IsHandled := false;
                IsFound := false;
                OnAutoReserveItemLedgEntryOnFindNextItemLedgEntry(CalcReservEntry, CalcItemLedgEntry, InvSearch, IsHandled, IsFound);
                if not IsHandled then
                    IsFound := CalcItemLedgEntry.Next(InvNextStep) <> 0;
            until not IsFound or (RemainingQtyToReserveBase = 0);
        end;

        OnAfterAutoReserveItemLedgEntry(CalcItemLedgEntry, RemainingQtyToReserveBase);
    end;

    local procedure AutoReservePurchLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        PurchLine: Record "Purchase Line";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
        IsReserved: Boolean;
    begin
        IsReserved := false;
        OnBeforeAutoReservePurchLine(
          ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserve, Description, AvailabilityDate, IsReserved, Search, NextStep, CalcReservEntry);
        if IsReserved then
            exit;

        PurchLine.FilterLinesForReservation(
          CalcReservEntry, "Purchase Document Type".FromInteger(ReservSummEntryNo - "Reservation Summary Type"::"Purchase Quote".AsInteger()),
          GetAvailabilityFilter(AvailabilityDate), Positive);
        if PurchLine.Find(Search) then
            repeat
                PurchLine.CalcFields("Reserved Qty. (Base)");
                if not PurchLine."Special Order" then begin
                    QtyThisLine := PurchLine."Outstanding Quantity";
                    QtyThisLineBase := PurchLine."Outstanding Qty. (Base)";
                end;
                if ReservSummEntryNo = "Reservation Summary Type"::"Purchase Return Order".AsInteger() then
                    ReservQty := -PurchLine."Reserved Qty. (Base)"
                else
                    ReservQty := PurchLine."Reserved Qty. (Base)";
                if (Positive = (QtyThisLineBase < 0)) and (ReservSummEntryNo <> "Reservation Summary Type"::"Purchase Return Order".AsInteger()) or
                   (Positive = (QtyThisLineBase > 0)) and (ReservSummEntryNo = "Reservation Summary Type"::"Purchase Return Order".AsInteger())
                then begin
                    QtyThisLine := 0;
                    QtyThisLineBase := 0;
                end;

                SetQtyToReserveDownToTrackedQuantity(CalcReservEntry, PurchLine.RowID1, QtyThisLine, QtyThisLineBase);

                CallTrackingSpecification.InitTrackingSpecification(
                    DATABASE::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", '', 0, PurchLine."Line No.",
                    PurchLine."Variant Code", PurchLine."Location Code", PurchLine."Qty. per Unit of Measure");
                CallTrackingSpecification.CopyTrackingFromReservEntry(CalcReservEntry);

                InsertReservationEntries(
                    RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                    Description, PurchLine."Expected Receipt Date", QtyThisLine, QtyThisLineBase, CallTrackingSpecification);
            until (PurchLine.Next(NextStep) = 0) or (RemainingQtyToReserveBase = 0);

        OnAfterAutoReservePurchLine(PurchLine, ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate);
    end;

    local procedure AutoReserveSalesLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        SalesLine: Record "Sales Line";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
        IsReserved: Boolean;
    begin
        IsReserved := false;
        OnBeforeAutoReserveSalesLine(
          ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate, IsReserved, Search, NextStep, CalcReservEntry);
        if IsReserved then
            exit;

        SalesLine.FilterLinesForReservation(
          CalcReservEntry, "Sales Document Type".FromInteger(ReservSummEntryNo - "Reservation Summary Type"::"Sales Quote".AsInteger()), GetAvailabilityFilter(AvailabilityDate), Positive);
        if SalesLine.Find(Search) then
            repeat
                SalesLine.CalcFields("Reserved Qty. (Base)");
                QtyThisLine := SalesLine."Outstanding Quantity";
                QtyThisLineBase := SalesLine."Outstanding Qty. (Base)";
                if ReservSummEntryNo = "Reservation Summary Type"::"Sales Return Order".AsInteger() then // Return Order
                    ReservQty := -SalesLine."Reserved Qty. (Base)"
                else
                    ReservQty := SalesLine."Reserved Qty. (Base)";
                if (Positive = (QtyThisLineBase > 0)) and (ReservSummEntryNo <> "Reservation Summary Type"::"Sales Return Order".AsInteger()) or
                   (Positive = (QtyThisLineBase < 0)) and (ReservSummEntryNo = "Reservation Summary Type"::"Sales Return Order".AsInteger())
                then begin
                    QtyThisLine := 0;
                    QtyThisLineBase := 0;
                end;

                SetQtyToReserveDownToTrackedQuantity(CalcReservEntry, SalesLine.RowID1, QtyThisLine, QtyThisLineBase);

                CallTrackingSpecification.InitTrackingSpecification(
                  DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", '', 0, SalesLine."Line No.",
                  SalesLine."Variant Code", SalesLine."Location Code", SalesLine."Qty. per Unit of Measure");
                CallTrackingSpecification.CopyTrackingFromReservEntry(CalcReservEntry);

                InsertReservationEntries(
                    RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                    Description, SalesLine."Shipment Date", QtyThisLine, QtyThisLineBase, CallTrackingSpecification);
            until (SalesLine.Next(NextStep) = 0) or (RemainingQtyToReserveBase = 0);
    end;

    local procedure AutoReserveProdOrderLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        ProdOrderLine: Record "Prod. Order Line";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
        IsReserved: Boolean;
    begin
        IsReserved := false;
        OnBeforeAutoReserveProdOrderLine(
          ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserve, Description, AvailabilityDate, IsReserved, Search, NextStep, CalcReservEntry);
        if IsReserved then
            exit;

        ProdOrderLine.FilterLinesForReservation(
            CalcReservEntry, ReservSummEntryNo - "Reservation Summary Type"::"Simulated Production Order".AsInteger(),
            GetAvailabilityFilter(AvailabilityDate), Positive);
        if ProdOrderLine.Find(Search) then
            repeat
                ProdOrderLine.CalcFields("Reserved Qty. (Base)");
                QtyThisLine := ProdOrderLine."Remaining Quantity";
                QtyThisLineBase := ProdOrderLine."Remaining Qty. (Base)";
                ReservQty := ProdOrderLine."Reserved Qty. (Base)";
                if Positive = (QtyThisLineBase < 0) then begin
                    QtyThisLine := 0;
                    QtyThisLineBase := 0;
                end;

                SetQtyToReserveDownToTrackedQuantity(CalcReservEntry, ProdOrderLine.RowID1, QtyThisLine, QtyThisLineBase);

                CallTrackingSpecification.InitTrackingSpecification(
                    DATABASE::"Prod. Order Line", ProdOrderLine.Status.AsInteger(), ProdOrderLine."Prod. Order No.", '', ProdOrderLine."Line No.", 0,
                    ProdOrderLine."Variant Code", ProdOrderLine."Location Code", ProdOrderLine."Qty. per Unit of Measure");
                CallTrackingSpecification.CopyTrackingFromReservEntry(CalcReservEntry);

                InsertReservationEntries(
                    RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                    Description, ProdOrderLine."Due Date", QtyThisLine, QtyThisLineBase, CallTrackingSpecification);
            until (ProdOrderLine.Next(NextStep) = 0) or (RemainingQtyToReserveBase = 0);
    end;

    local procedure AutoReserveProdOrderComp(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        ProdOrderComp: Record "Prod. Order Component";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
        IsReserved: Boolean;
    begin
        IsReserved := false;
        OnBeforeAutoReserveProdOrderComp(
          ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserve, Description, AvailabilityDate, IsReserved, Search, NextStep, CalcReservEntry);
        if IsReserved then
            exit;

        ProdOrderComp.FilterLinesForReservation(
            CalcReservEntry, ReservSummEntryNo - "Reservation Summary Type"::"Simulated Prod. Order Comp.".AsInteger(),
            GetAvailabilityFilter(AvailabilityDate), Positive);
        if ProdOrderComp.Find(Search) then
            repeat
                ProdOrderComp.CalcFields("Reserved Qty. (Base)");
                QtyThisLine := ProdOrderComp."Remaining Quantity";
                QtyThisLineBase := ProdOrderComp."Remaining Qty. (Base)";
                ReservQty := ProdOrderComp."Reserved Qty. (Base)";
                if Positive = (QtyThisLineBase > 0) then begin
                    QtyThisLine := 0;
                    QtyThisLineBase := 0;
                end;

                SetQtyToReserveDownToTrackedQuantity(CalcReservEntry, ProdOrderComp.RowID1, QtyThisLine, QtyThisLineBase);

                CallTrackingSpecification.InitTrackingSpecification(
                    DATABASE::"Prod. Order Component", ProdOrderComp.Status.AsInteger(), ProdOrderComp."Prod. Order No.", '',
                    ProdOrderComp."Prod. Order Line No.", ProdOrderComp."Line No.",
                    ProdOrderComp."Variant Code", ProdOrderComp."Location Code", ProdOrderComp."Qty. per Unit of Measure");
                CallTrackingSpecification.CopyTrackingFromReservEntry(CalcReservEntry);

                InsertReservationEntries(
                    RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                    Description, ProdOrderComp."Due Date", QtyThisLine, QtyThisLineBase, CallTrackingSpecification);
            until (ProdOrderComp.Next(NextStep) = 0) or (RemainingQtyToReserveBase = 0);
    end;

    local procedure AutoReserveAssemblyHeader(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        AssemblyHeader: Record "Assembly Header";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
        IsReserved: Boolean;
    begin
        IsReserved := false;
        OnBeforeAutoReserveAssemblyHeader(
          ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserve, Description, AvailabilityDate, IsReserved, Search, NextStep, CalcReservEntry);
        if IsReserved then
            exit;

        AssemblyHeader.FilterLinesForReservation(
            CalcReservEntry, ReservSummEntryNo - "Reservation Summary Type"::"Assembly Quote Header".AsInteger(),
            GetAvailabilityFilter(AvailabilityDate), Positive);
        if AssemblyHeader.Find(Search) then
            repeat
                AssemblyHeader.CalcFields("Reserved Qty. (Base)");
                QtyThisLine := AssemblyHeader."Remaining Quantity";
                QtyThisLineBase := AssemblyHeader."Remaining Quantity (Base)";
                ReservQty := AssemblyHeader."Reserved Qty. (Base)";
                if Positive = (QtyThisLineBase < 0) then begin
                    QtyThisLine := 0;
                    QtyThisLineBase := 0;
                end;

                SetQtyToReserveDownToTrackedQuantity(CalcReservEntry, AssemblyHeader.RowID1, QtyThisLine, QtyThisLineBase);

                CallTrackingSpecification.InitTrackingSpecification(
                  DATABASE::"Assembly Header", AssemblyHeader."Document Type".AsInteger(), AssemblyHeader."No.", '', 0, 0,
                  AssemblyHeader."Variant Code", AssemblyHeader."Location Code", AssemblyHeader."Qty. per Unit of Measure");
                CallTrackingSpecification.CopyTrackingFromReservEntry(CalcReservEntry);

                InsertReservationEntries(
                    RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                    Description, AssemblyHeader."Due Date", QtyThisLine, QtyThisLineBase, CallTrackingSpecification);
            until (AssemblyHeader.Next(NextStep) = 0) or (RemainingQtyToReserveBase = 0);
    end;

    local procedure AutoReserveAssemblyLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        AssemblyLine: Record "Assembly Line";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
        IsReserved: Boolean;
    begin
        IsReserved := false;
        OnBeforeAutoReserveAssemblyLine(
          ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserve, Description, AvailabilityDate, IsReserved, Search, NextStep, CalcReservEntry);
        if IsReserved then
            exit;

        AssemblyLine.FilterLinesForReservation(
            CalcReservEntry, ReservSummEntryNo - "Reservation Summary Type"::"Assembly Quote Line".AsInteger(),
            GetAvailabilityFilter(AvailabilityDate), Positive);
        if AssemblyLine.Find(Search) then
            repeat
                AssemblyLine.CalcFields("Reserved Qty. (Base)");
                QtyThisLine := AssemblyLine."Remaining Quantity";
                QtyThisLineBase := AssemblyLine."Remaining Quantity (Base)";
                ReservQty := AssemblyLine."Reserved Qty. (Base)";
                if Positive = (QtyThisLineBase > 0) then begin
                    QtyThisLine := 0;
                    QtyThisLineBase := 0;
                end;

                SetQtyToReserveDownToTrackedQuantity(CalcReservEntry, AssemblyLine.RowID1, QtyThisLine, QtyThisLineBase);

                CallTrackingSpecification.InitTrackingSpecification(
                  DATABASE::"Assembly Line", AssemblyLine."Document Type".AsInteger(), AssemblyLine."Document No.", '', 0, AssemblyLine."Line No.",
                  AssemblyLine."Variant Code", AssemblyLine."Location Code", AssemblyLine."Qty. per Unit of Measure");
                CallTrackingSpecification.CopyTrackingFromReservEntry(CalcReservEntry);

                InsertReservationEntries(
                    RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                    Description, AssemblyLine."Due Date", QtyThisLine, QtyThisLineBase, CallTrackingSpecification);
            until (AssemblyLine.Next(NextStep) = 0) or (RemainingQtyToReserveBase = 0);
    end;

    local procedure AutoReserveTransLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        TransLine: Record "Transfer Line";
        TransferDirection: Enum "Transfer Direction";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
        LocationCode: Code[10];
        EntryDate: Date;
        IsReserved: Boolean;
    begin
        IsReserved := false;
        OnBeforeAutoReserveTransLine(
          ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserve, Description, AvailabilityDate, IsReserved, Search, NextStep, CalcReservEntry);
        if IsReserved then
            exit;

        case ReservSummEntryNo of
            "Reservation Summary Type"::"Transfer Shipment".AsInteger():
                TransLine.FilterOutboundLinesForReservation(CalcReservEntry, GetAvailabilityFilter(AvailabilityDate), Positive);
            "Reservation Summary Type"::"Transfer Receipt".AsInteger():
                TransLine.FilterInboundLinesForReservation(CalcReservEntry, GetAvailabilityFilter(AvailabilityDate), Positive);
        end;
        if TransLine.Find(Search) then
            repeat
                case ReservSummEntryNo of
                    "Reservation Summary Type"::"Transfer Shipment".AsInteger():
                        begin
                            TransLine.CalcFields("Reserved Qty. Outbnd. (Base)");
                            QtyThisLine := -TransLine."Outstanding Quantity";
                            QtyThisLineBase := -TransLine."Outstanding Qty. (Base)";
                            ReservQty := -TransLine."Reserved Qty. Outbnd. (Base)";
                            EntryDate := TransLine."Shipment Date";
                            LocationCode := TransLine."Transfer-from Code";
                            if Positive = (QtyThisLineBase < 0) then begin
                                QtyThisLine := 0;
                                QtyThisLineBase := 0;
                            end;
                            SetQtyToReserveDownToTrackedQuantity(
                                CalcReservEntry, TransLine.RowID1(TransferDirection::Outbound), QtyThisLine, QtyThisLineBase);
                        end;
                    "Reservation Summary Type"::"Transfer Receipt".AsInteger():
                        begin
                            TransLine.CalcFields("Reserved Qty. Inbnd. (Base)");
                            QtyThisLine := TransLine."Outstanding Quantity";
                            QtyThisLineBase := TransLine."Outstanding Qty. (Base)";
                            ReservQty := TransLine."Reserved Qty. Inbnd. (Base)";
                            EntryDate := TransLine."Receipt Date";
                            LocationCode := TransLine."Transfer-to Code";
                            if Positive = (QtyThisLineBase < 0) then begin
                                QtyThisLine := 0;
                                QtyThisLineBase := 0;
                            end;
                            SetQtyToReserveDownToTrackedQuantity(
                                CalcReservEntry, TransLine.RowID1(TransferDirection::Inbound), QtyThisLine, QtyThisLineBase);
                        end;
                end;

                CallTrackingSpecification.InitTrackingSpecification(
                  DATABASE::"Transfer Line", ReservSummEntryNo - "Reservation Summary Type"::"Transfer Shipment".AsInteger(),
                  TransLine."Document No.", '', TransLine."Derived From Line No.", TransLine."Line No.",
                  TransLine."Variant Code", LocationCode, TransLine."Qty. per Unit of Measure");
                CallTrackingSpecification.CopyTrackingFromReservEntry(CalcReservEntry);

                InsertReservationEntries(
                    RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                    Description, EntryDate, QtyThisLine, QtyThisLineBase, CallTrackingSpecification);
            until (TransLine.Next(NextStep) = 0) or (RemainingQtyToReserveBase = 0);
    end;

    local procedure AutoReserveServLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        ServiceLine: Record "Service Line";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
        IsReserved: Boolean;
    begin
        IsReserved := false;
        OnBeforeAutoReserveServLine(
          ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserve, Description, AvailabilityDate, IsReserved, Search, NextStep, CalcReservEntry);
        if IsReserved then
            exit;

        ServiceLine.FindLinesForReservation(CalcReservEntry, GetAvailabilityFilter(AvailabilityDate), Positive);
        if ServiceLine.Find(Search) then
            repeat
                ServiceLine.CalcFields("Reserved Qty. (Base)");
                QtyThisLine := ServiceLine."Outstanding Quantity";
                QtyThisLineBase := ServiceLine."Outstanding Qty. (Base)";
                ReservQty := ServiceLine."Reserved Qty. (Base)";
                if Positive = (QtyThisLineBase > 0) then begin
                    QtyThisLine := 0;
                    QtyThisLineBase := 0;
                end;

                SetQtyToReserveDownToTrackedQuantity(CalcReservEntry, ServiceLine.RowID1, QtyThisLine, QtyThisLineBase);

                CallTrackingSpecification.InitTrackingSpecification(
                  DATABASE::"Service Line", ServiceLine."Document Type".AsInteger(), ServiceLine."Document No.", '', 0, ServiceLine."Line No.",
                  ServiceLine."Variant Code", ServiceLine."Location Code", ServiceLine."Qty. per Unit of Measure");
                CallTrackingSpecification.CopyTrackingFromReservEntry(CalcReservEntry);

                InsertReservationEntries(
                    RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                    Description, ServiceLine."Needed by Date", QtyThisLine, QtyThisLineBase, CallTrackingSpecification);
            until (ServiceLine.Next(NextStep) = 0) or (RemainingQtyToReserveBase = 0);
    end;

    local procedure AutoReserveServLineEDMS(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[50]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
    begin
        InitFilterEDMS(ReservSummEntryNo, AvailabilityDate); //FIXME BC16 Upgrade
        if CalcServiceLineEDMS.Find(Search) then
            repeat
                CalcServiceLineEDMS.CalcFields("Reserved Qty. (Base)");
                QtyThisLineBase := CalcServiceLineEDMS."Outstanding Qty. (Base)";
                QtyThisLine := CalcServiceLineEDMS."Outstanding Qty. (Base)";
                if ReservSummEntryNo = 230 then // Return Order
                    ReservQty := -CalcServiceLineEDMS."Reserved Qty. (Base)"
                else
                    ReservQty := CalcServiceLineEDMS."Reserved Qty. (Base)";
                if (Positive = (QtyThisLine > 0)) and (ReservSummEntryNo <> 230) or
                  (Positive = (QtyThisLine < 0)) and (ReservSummEntryNo = 230)
                then
                    QtyThisLine := 0;
                if QtyThisLine <> 0 then begin
                    if Abs(QtyThisLine - ReservQty) > Abs(RemainingQtyToReserve) then
                        QtyThisLine := RemainingQtyToReserve
                    else
                        QtyThisLine := QtyThisLine - ReservQty;
                    CopySign(RemainingQtyToReserve, QtyThisLine);

                    //EDMS 12.25.2013 >>
                    CreateTrackingSpecification(CallTrackingSpecification,
                      Database::"Service Line EDMS",
                      CalcServiceLineEDMS."Document Type",
                      CalcServiceLineEDMS."Document No.",
                      '',
                      0,
                      CalcServiceLineEDMS."Line No.",
                      CalcServiceLineEDMS."Variant Code",
                      CalcServiceLineEDMS."Location Code",
                      CalcReservEntry."Serial No.", CalcReservEntry."Lot No.",
                      CalcServiceLineEDMS."Qty. per Unit of Measure");
                    //EDMS 12.25.2013 <<

                    CallCreateReservation(RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                      Description, 0D, QtyThisLine, QtyThisLineBase, CallTrackingSpecification);

                end;
            until (CalcServiceLineEDMS.Next(NextStep) = 0) or (RemainingQtyToReserve = 0);
    end;

    local procedure AutoReserveJobPlanningLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        JobPlanningLine: Record "Job Planning Line";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
        IsReserved: Boolean;
    begin
        IsReserved := false;
        OnBeforeAutoReserveJobPlanningLine(
          ReservSummEntryNo, RemainingQtyToReserve, RemainingQtyToReserve, Description, AvailabilityDate, IsReserved, Search, NextStep, CalcReservEntry);
        if IsReserved then
            exit;

        JobPlanningLine.FilterLinesForReservation(
          CalcReservEntry, ReservSummEntryNo - 131, GetAvailabilityFilter(AvailabilityDate), Positive);
        if JobPlanningLine.Find(Search) then
            repeat
                JobPlanningLine.CalcFields("Reserved Qty. (Base)");
                QtyThisLine := JobPlanningLine."Remaining Qty.";
                QtyThisLineBase := JobPlanningLine."Remaining Qty. (Base)";
                ReservQty := JobPlanningLine."Reserved Qty. (Base)";
                if Positive = (QtyThisLineBase > 0) then begin
                    QtyThisLine := 0;
                    QtyThisLineBase := 0;
                end;

                CallTrackingSpecification.InitTrackingSpecification(
                DATABASE::"Job Planning Line", JobPlanningLine.Status.asinteger(), JobPlanningLine."Job No.", '',
                  0, JobPlanningLine."Job Contract Entry No.",
                  JobPlanningLine."Variant Code", JobPlanningLine."Location Code", JobPlanningLine."Qty. per Unit of Measure");
                CallTrackingSpecification.CopyTrackingFromReservEntry(CalcReservEntry);

                InsertReservationEntries(
                    RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                    Description, JobPlanningLine."Planning Date", QtyThisLine, QtyThisLineBase, CallTrackingSpecification);
            until (JobPlanningLine.Next(NextStep) = 0) or (RemainingQtyToReserveBase = 0);
    end;

    local procedure AutoInvtDocLineReserve(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer)
    var
        InvtDocLine: Record "Invt. Document Line";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
    begin
        case ReservSummEntryNo of
            DATABASE::"Invt. Receipt Header":
                InvtDocLine.FilterReceiptLinesForReservation(CalcReservEntry, GetAvailabilityFilter(AvailabilityDate), Positive);
            DATABASE::"Invt. Shipment Header":
                InvtDocLine.FilterShipmentLinesForReservation(CalcReservEntry, GetAvailabilityFilter(AvailabilityDate), Positive);
        end;

        if InvtDocLine.Find(Search) then
            repeat
                case ReservSummEntryNo of
                    "Reservation Summary Type"::"Inventory Shipment".AsInteger():
                        begin
                            InvtDocLine.CalcFields("Reserved Qty. Outbnd. (Base)");
                            QtyThisLine := -InvtDocLine.Quantity;
                            QtyThisLineBase := -InvtDocLine."Quantity (Base)";
                            ReservQty := -InvtDocLine."Reserved Qty. Outbnd. (Base)";
                            if Positive = (QtyThisLine < 0) then begin
                                QtyThisLine := 0;
                                QtyThisLineBase := 0;
                            end;
                        end;
                    "Reservation Summary Type"::"Inventory Receipt".AsInteger():
                        begin
                            InvtDocLine.CalcFields("Reserved Qty. Inbnd. (Base)");
                            QtyThisLine := InvtDocLine.Quantity;
                            QtyThisLineBase := InvtDocLine."Quantity (Base)";
                            ReservQty := InvtDocLine."Reserved Qty. Inbnd. (Base)";
                            if Positive = (QtyThisLine < 0) then begin
                                QtyThisLine := 0;
                                QtyThisLineBase := 0;
                            end;
                        end;
                end;
                if QtyThisLine <> 0 then
                    if Abs(QtyThisLine - ReservQty) > 0 then begin
                        if Abs(QtyThisLine - ReservQty) > Abs(RemainingQtyToReserve) then begin
                            QtyThisLine := RemainingQtyToReserve;
                            QtyThisLineBase := RemainingQtyToReserveBase;
                        end else begin
                            QtyThisLineBase := QtyThisLineBase - ReservQty;
                            QtyThisLine := Round(RemainingQtyToReserve / RemainingQtyToReserveBase * QtyThisLineBase, UOMMgt.QtyRndPrecision);
                        end;

                        CopySign(RemainingQtyToReserve, QtyThisLine);
                        CopySign(RemainingQtyToReserveBase, QtyThisLineBase);

                        CallTrackingSpecification.InitTrackingSpecification(
                          DATABASE::"Invt. Document Line", ReservSummEntryNo - "Reservation Summary Type"::"Inventory Receipt".AsInteger(),
                          InvtDocLine."Document No.", '', 0, InvtDocLine."Line No.", InvtDocLine."Variant Code", InvtDocLine."Location Code", InvtDocLine."Qty. per Unit of Measure");
                        CallTrackingSpecification.CopyTrackingFromReservEntry(CalcReservEntry);

                        CreateReservation(Description, InvtDocLine."Posting Date", QtyThisLine, QtyThisLineBase, CallTrackingSpecification);

                        RemainingQtyToReserve := RemainingQtyToReserve - QtyThisLine;
                        RemainingQtyToReserveBase := RemainingQtyToReserveBase - QtyThisLineBase;
                    end;
            until (InvtDocLine.Next(NextStep) = 0) or (RemainingQtyToReserve = 0);
    end;

    procedure InsertReservationEntries(var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; ReservQty: Decimal; Description: Text[100]; ExpectedDate: Date; QtyThisLine: Decimal; QtyThisLineBase: Decimal; TrackingSpecification: Record "Tracking Specification") ReservationCreated: Boolean
    begin
        if QtyThisLineBase = 0 then
            exit;
        if Abs(QtyThisLineBase - ReservQty) > 0 then begin
            if Abs(QtyThisLineBase - ReservQty) > Abs(RemainingQtyToReserveBase) then begin
                QtyThisLine := RemainingQtyToReserve;
                QtyThisLineBase := RemainingQtyToReserveBase;
            end else begin
                QtyThisLineBase := QtyThisLineBase - ReservQty;
                QtyThisLine := Round(RemainingQtyToReserve / RemainingQtyToReserveBase * QtyThisLineBase, UOMMgt.QtyRndPrecision);
            end;
            CopySign(RemainingQtyToReserveBase, QtyThisLineBase);
            CopySign(RemainingQtyToReserve, QtyThisLine);
            OnInsertReservationEntriesOnBeforeCreateReservation(TrackingSpecification, CalcReservEntry);
            CreateReservation(Description, ExpectedDate, QtyThisLine, QtyThisLineBase, TrackingSpecification);
            RemainingQtyToReserve := RemainingQtyToReserve - QtyThisLine;
            RemainingQtyToReserveBase := RemainingQtyToReserveBase - QtyThisLineBase;
            ReservationCreated := true;
        end;

        OnAfterInsertReservationEntries(TrackingSpecification, CalcReservEntry, RemainingQtyToReserve, RemainingQtyToReserveBase, QtyThisLine, QtyThisLineBase, ReservationCreated);
    end;

    procedure CreateReservation(Description: Text[100]; ExpectedDate: Date; Quantity: Decimal; QuantityBase: Decimal; TrackingSpecification: Record "Tracking Specification")
    var
        TransferLine: Record "Transfer Line";
        TransferLineReserve: Codeunit "Transfer Line-Reserve";
    begin
        CalcReservEntry.TestField("Source Type");

        OnBeforeCreateReservation(TrackingSpecification, CalcReservEntry, CalcItemLedgEntry);

        OnCreateReservation(SourceRecRef, TrackingSpecification, CalcReservEntry, Description, ExpectedDate, Quantity, QuantityBase);
        if CalcReservEntry."Source Type" = 5741 then begin
            TransferLineReserve.CreateReservationSetFrom(TrackingSpecification);
            SourceRecRef.SetTable(TransferLine);
            TransferLineReserve.CreateReservation(
                TransferLine, Description, ExpectedDate, Quantity, QuantityBase, CalcReservEntry, CalcReservEntry.GetTransferDirection());
        end;
    end;

    procedure DeleteReservEntries(DeleteAll: Boolean; DownToQuantity: Decimal)
    var
        CalcReservEntry4: Record "Reservation Entry";
        ReqLine: Record "Requisition Line";
        TrackingMgt: Codeunit OrderTrackingManagement;
        //ReservMgt: Codeunit "Reservation Management";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
        QtyToReTrack: Decimal;
        QtyTracked: Decimal;
    begin
        DeleteReservEntries(DeleteAll, DownToQuantity, CalcReservEntry2);

        // Handle both sides of a req. line related to a transfer line:
        if ((CalcReservEntry."Source Type" = DATABASE::"Requisition Line") and
            (RefOrderType = ReqLine."Ref. Order Type"::Transfer))
        then begin
            CalcReservEntry4 := CalcReservEntry;
            CalcReservEntry4."Source Subtype" := 1;
            CalcReservEntry4.SetPointerFilter;
            DeleteReservEntries(DeleteAll, DownToQuantity, CalcReservEntry4);
        end;

        if DeleteAll then
            if ((CalcReservEntry."Source Type" = DATABASE::"Requisition Line") and
                (PlanningLineOrigin <> ReqLine."Planning Line Origin"::" ".AsInteger())) or
               (CalcReservEntry."Source Type" = DATABASE::"Planning Component")
            then begin
                CalcReservEntry4.Reset();
                if TrackingMgt.DerivePlanningFilter(CalcReservEntry2, CalcReservEntry4) then
                    if CalcReservEntry4.FindFirst then begin
                        QtyToReTrack := ReservationMgtEDMS.SourceQuantity(CalcReservEntry4, true);
                        CalcReservEntry4.SetRange("Reservation Status", CalcReservEntry4."Reservation Status"::Reservation);
                        if not CalcReservEntry4.IsEmpty() then begin
                            CalcReservEntry4.CalcSums("Quantity (Base)");
                            QtyTracked += CalcReservEntry4."Quantity (Base)";
                        end;
                        CalcReservEntry4.SetFilter("Reservation Status", '<>%1', CalcReservEntry4."Reservation Status"::Reservation);
                        CalcReservEntry4.SetFilter("Item Tracking", '<>%1', CalcReservEntry4."Item Tracking"::None);
                        if not CalcReservEntry4.IsEmpty() then begin
                            CalcReservEntry4.CalcSums("Quantity (Base)");
                            QtyTracked += CalcReservEntry4."Quantity (Base)";
                        end;
                        if CalcReservEntry."Source Type" = DATABASE::"Planning Component" then
                            QtyTracked := -QtyTracked;
                        ReservationMgtEDMS.DeleteReservEntries(QtyTracked = 0, QtyTracked);
                        ReservationMgtEDMS.AutoTrack(QtyToReTrack);
                    end;
            end;
    end;

    procedure DeleteReservEntries(DeleteAll: Boolean; DownToQuantity: Decimal; var ReservEntry: Record "Reservation Entry")
    var
        CalcReservEntry4: Record "Reservation Entry";
        SurplusEntry: Record "Reservation Entry";
        DummyEntry: Record "Reservation Entry";
        CurrentItemTrackingSetup: Record "Item Tracking Setup";
        ReservStatus: Enum "Reservation Status";
        QtyToRelease: Decimal;
        QtyTracked: Decimal;
        QtyToReleaseForLotSN: Decimal;
        CurrentQty: Decimal;
        AvailabilityDate: Date;
        Release: Option "Non-Inventory",Inventory;
        HandleItemTracking2: Boolean;
        SignFactor: Integer;
        QuantityIsValidated: Boolean;
        IsHandled: Boolean;
    begin
        OnBeforeDeleteReservEntries(ReservEntry, DownToQuantity, CalcReservEntry, CalcReservEntry2, IsHandled);

        ReservEntry.SetRange("Reservation Status");
        if ReservEntry.IsEmpty() then
            exit;

        CurrentItemTrackingSetup.CopyTrackingFromReservEntry(ReservEntry);
        CurrentQty := ReservEntry."Quantity (Base)";

        GetItemSetup(ReservEntry);
        ReservEntry.TestField("Source Type");
        ReservEntry.Lock;
        SignFactor := CreateReservEntry.SignFactor(ReservEntry);
        QtyTracked := QuantityTracked(ReservEntry);
        CurrentBinding := ReservEntry.Binding;
        CurrentBindingIsSet := true;

        // Item Tracking:
        if ItemTrackingCode.IsSpecific() or CurrentItemTrackingSetup.TrackingExists() then begin
            ReservEntry.SetFilter("Item Tracking", '<>%1', ReservEntry."Item Tracking"::None);
            HandleItemTracking2 := not ReservEntry.IsEmpty;
            ReservEntry.SetRange("Item Tracking");
            OnDeleteReservEntriesOnAfterReservEntrySetFilters(ReservEntry, ItemTrackingHandling);
            case ItemTrackingHandling of
                ItemTrackingHandling::None:
                    ReservEntry.SetTrackingFilterBlank;
                ItemTrackingHandling::Match:
                    begin
                        if CurrentItemTrackingSetup.TrackingExists() then begin
                            QtyToReleaseForLotSN := QuantityTracked2(ReservEntry);
                            if Abs(QtyToReleaseForLotSN) > Abs(CurrentQty) then
                                QtyToReleaseForLotSN := CurrentQty;
                            DownToQuantity := (QtyTracked - QtyToReleaseForLotSN) * SignFactor;
                            ReservEntry.SetTrackingFilterFromItemTrackingSetup(CurrentItemTrackingSetup);
                        end else
                            DownToQuantity += CalcDownToQtySyncingToAssembly(ReservEntry);
                    end;
            end;
        end;

        if SignFactor * QtyTracked * DownToQuantity < 0 then
            DeleteAll := true
        else
            if Abs(QtyTracked) < Abs(DownToQuantity) then
                exit;

        QtyToRelease := QtyTracked - (DownToQuantity * SignFactor);

        for ReservStatus := ReservStatus::Prospect downto ReservStatus::Reservation do begin
            ReservEntry.SetRange("Reservation Status", ReservStatus);
            if ReservEntry.FindSet and (QtyToRelease <> 0) then
                case ReservStatus of
                    ReservStatus::Prospect:
                        repeat
                            if (Abs(ReservEntry."Quantity (Base)") <= Abs(QtyToRelease)) or DeleteAll then begin
                                ReservEntry.Delete();
                                SaveTrackingSpecification(ReservEntry, ReservEntry."Quantity (Base)");
                                QtyToRelease := QtyToRelease - ReservEntry."Quantity (Base)";
                            end else begin
                                ReservEntry.Validate("Quantity (Base)", ReservEntry."Quantity (Base)" - QtyToRelease);
                                ReservEntry.Modify();
                                SaveTrackingSpecification(ReservEntry, QtyToRelease);
                                QtyToRelease := 0;
                            end;
                        until (ReservEntry.Next() = 0) or ((not DeleteAll) and (QtyToRelease = 0));
                    ReservStatus::Surplus:
                        repeat
                            if CalcReservEntry4.Get(ReservEntry."Entry No.", not ReservEntry.Positive) then // Find related entry
                                Error(Text007);
                            if (Abs(ReservEntry."Quantity (Base)") <= Abs(QtyToRelease)) or DeleteAll then begin
                                ReservEngineMgt.CloseReservEntry(ReservEntry, false, DeleteAll);
                                SaveTrackingSpecification(ReservEntry, ReservEntry."Quantity (Base)");
                                QtyToRelease := QtyToRelease - ReservEntry."Quantity (Base)";
                                if not DeleteAll and CalcReservEntry4.TrackingExists then begin
                                    CalcReservEntry4."Reservation Status" := CalcReservEntry4."Reservation Status"::Surplus;
                                    CalcReservEntry4.Insert();
                                end;
                                ModifyActionMessage(ReservEntry."Entry No.", 0, true); // Delete action messages
                            end else begin
                                ReservEntry.Validate("Quantity (Base)", ReservEntry."Quantity (Base)" - QtyToRelease);
                                ReservEntry.Modify();
                                SaveTrackingSpecification(ReservEntry, QtyToRelease);
                                ModifyActionMessage(ReservEntry."Entry No.", QtyToRelease, false); // Modify action messages
                                QtyToRelease := 0;
                            end;
                        until (ReservEntry.Next() = 0) or ((not DeleteAll) and (QtyToRelease = 0));
                    ReservStatus::Tracking,
                    ReservStatus::Reservation:
                        for Release := Release::"Non-Inventory" to Release::Inventory do begin
                            // Release non-inventory reservations in first cycle
                            repeat
                                CalcReservEntry4.Get(ReservEntry."Entry No.", not ReservEntry.Positive); // Find related entry
                                if (Release = Release::Inventory) = (CalcReservEntry4."Source Type" = DATABASE::"Item Ledger Entry") then
                                    if (Abs(ReservEntry."Quantity (Base)") <= Abs(QtyToRelease)) or DeleteAll then begin
                                        ReservEngineMgt.CloseReservEntry(ReservEntry, false, DeleteAll);
                                        SaveTrackingSpecification(ReservEntry, ReservEntry."Quantity (Base)");
                                        QtyToRelease := QtyToRelease - ReservEntry."Quantity (Base)";
                                    end else begin
                                        ReservEntry.Validate("Quantity (Base)", ReservEntry."Quantity (Base)" - QtyToRelease);
                                        ReservEntry.Modify();
                                        SaveTrackingSpecification(ReservEntry, QtyToRelease);

                                        if Item."Order Tracking Policy" <> Item."Order Tracking Policy"::None then begin
                                            if CalcReservEntry4."Quantity (Base)" > 0 then
                                                AvailabilityDate := CalcReservEntry4."Shipment Date"
                                            else
                                                AvailabilityDate := CalcReservEntry4."Expected Receipt Date";

                                            QtyToRelease := -MatchSurplus(CalcReservEntry4, SurplusEntry, -QtyToRelease,
                                                CalcReservEntry4."Quantity (Base)" < 0, AvailabilityDate, Item."Order Tracking Policy");

                                            // Make residual surplus record:
                                            if QtyToRelease <> 0 then begin
                                                MakeConnection(
                                                    CalcReservEntry4, CalcReservEntry4, -QtyToRelease, CalcReservEntry4."Reservation Status"::Surplus,
                                                    AvailabilityDate, CalcReservEntry4.Binding);
                                                if Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." then begin
                                                    CreateReservEntry.GetLastEntry(SurplusEntry); // Get the surplus-entry just inserted
                                                    IssueActionMessage(SurplusEntry, false, DummyEntry);
                                                end;
                                            end;
                                        end else
                                            if ItemTrackingHandling = ItemTrackingHandling::None then
                                                QuantityIsValidated :=
                                                    SaveItemTrackingAsSurplus(CalcReservEntry4, -ReservEntry.Quantity, -ReservEntry."Quantity (Base)");

                                        if not QuantityIsValidated then
                                            CalcReservEntry4.Validate("Quantity (Base)", -ReservEntry."Quantity (Base)");

                                        CalcReservEntry4.Modify();
                                        QtyToRelease := 0;
                                        QuantityIsValidated := false;
                                    end;
                            until (ReservEntry.Next() = 0) or ((not DeleteAll) and (QtyToRelease = 0));
                            if not ReservEntry.FindFirst then // Rewind for second cycle
                                Release := Release::Inventory;
                        end;
                end;
        end;

        if HandleItemTracking2 then
            CheckQuantityIsCompletelyReleased(QtyToRelease, DeleteAll, CurrentItemTrackingSetup, ReservEntry);
    end;

    procedure CalculateRemainingQty(var RemainingQty: Decimal; var RemainingQtyBase: Decimal)
    Var
        TransferLine: Record "Transfer Line";
    begin
        CalcReservEntry.TestField("Source Type");

        OnCalculateRemainingQty(SourceRecRef, CalcReservEntry, RemainingQty, RemainingQtyBase);
        if CalcReservEntry."Source Type" = 5741 then begin
            SourceRecRef.SetTable(TransferLine);
            TransferLine.GetRemainingQty(RemainingQty, RemainingQtyBase, CalcReservEntry."Source Subtype");
        end;

    end;

#if not CLEAN16
    [Obsolete('Replaced by ReservEntry.FieldFilterNeeded(FieldFilter, SearchForSupply, Field)', '16.0')]
    procedure FieldFilterNeeded(var ReservEntry: Record "Reservation Entry"; SearchForSupply: Boolean; TrackingField: Enum "Item Tracking Type"): Boolean
    var
        ReservEntry2: Record "Reservation Entry";
        FieldValue: Code[50];
    begin
        case TrackingField of
            TrackingField::"Lot No.":
                exit(ReservEntry.FieldFilterNeeded(FieldFilter, SearchForSupply, ItemTrackingType::"Lot No."));
            TrackingField::"Serial No.":
                exit(ReservEntry.FieldFilterNeeded(FieldFilter, SearchForSupply, ItemTrackingType::"Serial No."));
        end;
    end;

    [Obsolete('Not used', '16.0')]
    procedure GetFieldFilter(): Text[80]
    begin
        exit(FieldFilter);
    end;
#endif

    procedure GetAvailabilityFilter(AvailabilityDate: Date): Text[80]
    begin
        exit(GetAvailabilityFilter2(AvailabilityDate, Positive));
    end;

    local procedure GetAvailabilityFilter2(AvailabilityDate: Date; SearchForSupply: Boolean): Text[80]
    var
        ReservEntry2: Record "Reservation Entry";
    begin
        if SearchForSupply then
            ReservEntry2.SetFilter("Expected Receipt Date", '..%1', AvailabilityDate)
        else
            ReservEntry2.SetFilter("Expected Receipt Date", '>=%1', AvailabilityDate);

        exit(ReservEntry2.GetFilter("Expected Receipt Date"));
    end;

    procedure CopySign(FromValue: Decimal; var ToValue: Decimal)
    begin
        if FromValue * ToValue < 0 then
            ToValue := -ToValue;
    end;

    /* FIXME BC16 upgrade 
    local procedure InitFilter(EntryID: Integer; AvailabilityDate: Date)
    begin
        case EntryID of
            1:
                begin // Item Ledger Entry
                    CalcItemLedgEntry.Reset;
                    CalcItemLedgEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code");
                    CalcItemLedgEntry.SetRange("Item No.", CalcReservEntry."Item No.");
                    CalcItemLedgEntry.SetRange(Open, true);
                    CalcItemLedgEntry.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcItemLedgEntry.SetRange(Positive, Positive);
                    CalcItemLedgEntry.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcItemLedgEntry.SetRange("Drop Shipment", false);
                    if FieldFilterNeeded(CalcReservEntry, Positive, 0) then
                        CalcItemLedgEntry.SetFilter("Lot No.", GetFieldFilter);
                    if FieldFilterNeeded(CalcReservEntry, Positive, 1) then
                        CalcItemLedgEntry.SetFilter("Serial No.", GetFieldFilter);
                end;
            12, 16:
                begin // Purchase Line
                    CalcPurchLine.Reset;
                    CalcPurchLine.SetCurrentKey(
                      "Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Expected Receipt Date");
                    CalcPurchLine.SetRange("Document Type", EntryID - 11);
                    CalcPurchLine.SetRange(Type, CalcPurchLine.Type::Item);
                    CalcPurchLine.SetRange("No.", CalcReservEntry."Item No.");
                    CalcPurchLine.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcPurchLine.SetRange("Drop Shipment", false);
                    CalcPurchLine.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcPurchLine.SetFilter("Expected Receipt Date", GetAvailabilityFilter(AvailabilityDate));
                    if Positive and (EntryID <> 16) then
                        CalcPurchLine.SetFilter("Quantity (Base)", '>0')
                    else
                        CalcPurchLine.SetFilter("Quantity (Base)", '<0');
                    CalcPurchLine.SetRange("Job No.", ' ');
                end;
            21:
                begin // Requisition Line
                    CalcReqLine.Reset;
                    CalcReqLine.SetCurrentKey(
                      Type, "No.", "Variant Code", "Location Code", "Sales Order No.", "Planning Line Origin", "Due Date");
                    CalcReqLine.SetRange(Type, CalcReqLine.Type::Item);
                    CalcReqLine.SetRange("No.", CalcReservEntry."Item No.");
                    CalcReqLine.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcReqLine.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcReqLine.SetRange("Sales Order No.", '');
                    CalcReqLine.SetFilter("Due Date", GetAvailabilityFilter(AvailabilityDate));
                    if Positive then
                        CalcReqLine.SetFilter("Quantity (Base)", '>0')
                    else
                        CalcReqLine.SetFilter("Quantity (Base)", '<0');
                end;
            31, 32, 36:
                begin // Sales Line
                    CalcSalesLine.Reset;
                    CalcSalesLine.SetCurrentKey(
                      "Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
                    CalcSalesLine.SetRange("Document Type", EntryID - 31);
                    CalcSalesLine.SetRange(Type, CalcSalesLine.Type::Item);
                    CalcSalesLine.SetRange("No.", CalcReservEntry."Item No.");
                    CalcSalesLine.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcSalesLine.SetRange("Drop Shipment", false);
                    CalcSalesLine.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcSalesLine.SetFilter("Shipment Date", GetAvailabilityFilter(AvailabilityDate));
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
            61, 62, 63, 64:
                begin // Prod. Order
                    CalcProdOrderLine.Reset;
                    CalcProdOrderLine.SetCurrentKey(Status, "Item No.", "Variant Code", "Location Code", "Due Date");
                    CalcProdOrderLine.SetRange(Status, EntryID - 61);
                    CalcProdOrderLine.SetRange("Item No.", CalcReservEntry."Item No.");
                    CalcProdOrderLine.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcProdOrderLine.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcProdOrderLine.SetFilter("Due Date", GetAvailabilityFilter(AvailabilityDate));
                    if Positive then
                        CalcProdOrderLine.SetFilter("Remaining Qty. (Base)", '>0')
                    else
                        CalcProdOrderLine.SetFilter("Remaining Qty. (Base)", '<0');
                end;
            71, 72, 73, 74:
                begin // Prod. Order Component
                    CalcProdOrderComp.Reset;
                    CalcProdOrderComp.SetCurrentKey(Status, "Item No.", "Variant Code", "Location Code", "Due Date");
                    CalcProdOrderComp.SetRange(Status, EntryID - 71);
                    CalcProdOrderComp.SetRange("Item No.", CalcReservEntry."Item No.");
                    CalcProdOrderComp.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcProdOrderComp.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcProdOrderComp.SetFilter("Due Date", GetAvailabilityFilter(AvailabilityDate));
                    if Positive then
                        CalcProdOrderComp.SetFilter("Remaining Qty. (Base)", '<0')
                    else
                        CalcProdOrderComp.SetFilter("Remaining Qty. (Base)", '>0');
                end;
            91:
                FilterPlanningComponent(AvailabilityDate);
            101:
                begin // Transfer, Outbound
                    CalcTransLine.Reset;
                    CalcTransLine.SetCurrentKey("Transfer-from Code", "Shipment Date", "Item No.", "Variant Code");
                    CalcTransLine.SetRange("Item No.", CalcReservEntry."Item No.");
                    CalcTransLine.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcTransLine.SetRange("Transfer-from Code", CalcReservEntry."Location Code");
                    CalcTransLine.SetFilter("Shipment Date", GetAvailabilityFilter(AvailabilityDate));
                    if Positive then
                        CalcTransLine.SetFilter("Outstanding Qty. (Base)", '<0')
                    else
                        CalcTransLine.SetFilter("Outstanding Qty. (Base)", '>0');

              //23.08.2008 EDMS >>
              if ServSpecEDMS and (CalcReservEntry."Source Type" <> Database::"Transfer Line") then
                begin
                 CalcTransLine.SetRange("Source Type",Database::"Service Line EDMS");
                 CalcTransLine.SetRange("Source Subtype",ServSpecDocType);
                 CalcTransLine.SetRange("Source No.",ServSpecDocNo);
                end;
              //23.08.2008 EDMS <<
                end;
            102:
                begin // Transfer, Inbound
                    CalcTransLine.Reset;
                    CalcTransLine.SetCurrentKey("Transfer-to Code", "Receipt Date", "Item No.", "Variant Code");
                    CalcTransLine.SetRange("Item No.", CalcReservEntry."Item No.");
                    CalcTransLine.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcTransLine.SetRange("Transfer-to Code", CalcReservEntry."Location Code");
                    CalcTransLine.SetFilter("Receipt Date", GetAvailabilityFilter(AvailabilityDate));
                    if Positive then
                        CalcTransLine.SetFilter("Outstanding Qty. (Base)", '>0')
                    else
                        CalcTransLine.SetFilter("Outstanding Qty. (Base)", '<0');

              //23.08.2008 EDMS >>
              if ServSpecEDMS and (CalcReservEntry."Source Type" <> Database::"Transfer Line") then
                begin
                 CalcTransLine.SetRange("Source Type",Database::"Service Line EDMS");
                 CalcTransLine.SetRange("Source Subtype",ServSpecDocType);
                 CalcTransLine.SetRange("Source No.",ServSpecDocNo);
                end;
              //23.08.2008 EDMS <<

                end;
            110:
                begin // Service Line
                    CalcServiceLine.Reset;
                    CalcServiceLine.SetCurrentKey(Type, "No.", "Variant Code", "Location Code", "Needed by Date", "Document Type");
                    CalcServiceLine.SetRange(Type, CalcServiceLine.Type::Item);
                    CalcServiceLine.SetRange("No.", CalcReservEntry."Item No.");
                    CalcServiceLine.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcServiceLine.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcServiceLine.SetFilter("Needed by Date", GetAvailabilityFilter(AvailabilityDate));
                    if Positive then
                        CalcServiceLine.SetFilter("Quantity (Base)", '<0')
                    else
                        CalcServiceLine.SetFilter("Quantity (Base)", '>0');
                    CalcServiceLine.SetRange("Job No.", ' ');
                end;
            133:
                begin // Job Planning Line
                    CalcJobPlanningLine.Reset;
                    CalcJobPlanningLine.SetCurrentKey(Status, Type, "No.", "Variant Code", "Location Code", "Planning Date");
                    CalcJobPlanningLine.SetRange(Status, EntryID - 131);
                    CalcJobPlanningLine.SetRange(Type, CalcJobPlanningLine.Type::Item);
                    CalcJobPlanningLine.SetRange("No.", CalcReservEntry."Item No.");
                    CalcJobPlanningLine.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcJobPlanningLine.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcJobPlanningLine.SetFilter("Planning Date", GetAvailabilityFilter(AvailabilityDate));
                    if Positive then
                        CalcJobPlanningLine.SetFilter("Quantity (Base)", '<0')
                    else
                        CalcJobPlanningLine.SetFilter("Quantity (Base)", '>0');
                end;
            141, 142:
                begin // Assembly Header
                    CalcAssemblyHeader.Reset;
                    CalcAssemblyHeader.SetCurrentKey(
                      "Document Type", "Item No.", "Variant Code", "Location Code", "Due Date");
                    CalcAssemblyHeader.SetRange("Document Type", EntryID - 141);
                    CalcAssemblyHeader.SetRange("Item No.", CalcReservEntry."Item No.");
                    CalcAssemblyHeader.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcAssemblyHeader.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcAssemblyHeader.SetFilter("Due Date", GetAvailabilityFilter(AvailabilityDate));
                    if Positive then
                        CalcAssemblyHeader.SetFilter("Remaining Quantity (Base)", '>0')
                    else
                        CalcAssemblyHeader.SetFilter("Remaining Quantity (Base)", '<0');
                end;
            151, 152:
                begin // Assembly Line
                    CalcAssemblyLine.Reset;
                    CalcAssemblyLine.SetCurrentKey(
                      "Document Type", Type, "No.", "Variant Code", "Location Code", "Due Date");
                    CalcAssemblyLine.SetRange("Document Type", EntryID - 151);
                    CalcAssemblyLine.SetRange(Type, CalcAssemblyLine.Type::Item);
                    CalcAssemblyLine.SetRange("No.", CalcReservEntry."Item No.");
                    CalcAssemblyLine.SetRange("Variant Code", CalcReservEntry."Variant Code");
                    CalcAssemblyLine.SetRange("Location Code", CalcReservEntry."Location Code");
                    CalcAssemblyLine.SetFilter("Due Date", GetAvailabilityFilter(AvailabilityDate));
                    if Positive then
                        CalcAssemblyLine.SetFilter("Remaining Quantity (Base)", '<0')
                    else
                        CalcAssemblyLine.SetFilter("Remaining Quantity (Base)", '>0');
                end;

          220, 230: //08.07.08 EDMS P1
            begin // Service Line EDMS
              CalcServiceLineEDMS.Reset;
              CalcServiceLineEDMS.SetCurrentkey(
                Type,"No.","Variant Code","Location Code");
              if EntryID = 230 then
                CalcServiceLineEDMS.SetRange("Document Type",CalcServiceLineEDMS."document type"::"Return Order")
              else
                CalcServiceLineEDMS.SetRange("Document Type",CalcServiceLineEDMS."document type"::Order);
              CalcServiceLineEDMS.SetRange(Type,CalcServiceLineEDMS.Type::Item);
              CalcServiceLineEDMS.SetRange("No.",CalcReservEntry."Item No.");
              CalcServiceLineEDMS.SetRange("Variant Code",CalcReservEntry."Variant Code");
              CalcServiceLineEDMS.SetRange("Location Code",CalcReservEntry."Location Code");
              CalcServiceLineEDMS.SetFilter("Planned Service Date",GetAvailabilityFilter(AvailabilityDate));

              //10.10.2018 EB.P7 >>
              if ServSpecLoc <> '' then
                CalcServiceLineEDMS.SetRange("Transfer From Location Code",ServSpecLoc);
              //10.10.2018 EB.P7 <<

              //27.03.2013 EDMS P8 >>
              if EntryID = 230 then
                if Positive then
        //          CalcSalesLine.SETFILTER("Quantity (Base)",'>0')
                  CalcServiceLineEDMS.SetFilter("Quantity (Base)",'>0')
                else
                  CalcServiceLineEDMS.SetFilter("Quantity (Base)",'<0')
              else
                if Positive then
                  CalcServiceLineEDMS.SetFilter("Quantity (Base)",'<0')
                else
                  CalcServiceLineEDMS.SetFilter("Quantity (Base)",'>0');
              //27.03.2013 EDMS P8 <<
              CalcServiceLineEDMS.SetRange("Job No.",' ');

              if ServSpecEDMS and (CalcReservEntry."Source Type" <> Database::"Service Line EDMS") then
                begin
                 CalcServiceLineEDMS.SetRange("Document Type",ServSpecDocType);
                 CalcServiceLineEDMS.SetRange("Document No.",ServSpecDocNo);
                end;

            end;


        end;

        OnAfterInitFilter(CalcReservEntry, EntryID);
    end;  
    */

    local procedure SetValueArray(EntryStatus: Option Reservation,Tracking,Simulation) ArrayCounter: Integer
    begin
        Clear(ValueArray);
        case EntryStatus of
            0:
                begin // Reservation
                    //23.07.08 EDMS P1 >>
                    if SpecSummEntryNo <> 0 then begin
                        ValueArray[1] := SpecSummEntryNo;
                        exit(1);
                    end;
                    //23.07.08 EDMS P1 <<		
                    ValueArray[1] := "Reservation Summary Type"::"Item Ledger Entry".AsInteger();
                    ValueArray[2] := "Reservation Summary Type"::"Sales Order".AsInteger();
                    ValueArray[3] := "Reservation Summary Type"::"Sales Return Order".AsInteger();
                    ValueArray[4] := "Reservation Summary Type"::"Purchase Order".AsInteger();
                    ValueArray[5] := "Reservation Summary Type"::"Purchase Return Order".AsInteger();
                    ValueArray[6] := "Reservation Summary Type"::"Firm Planned Production Order".AsInteger();
                    ValueArray[7] := "Reservation Summary Type"::"Released Production Order".AsInteger();
                    ValueArray[8] := "Reservation Summary Type"::"Firm Planned Prod. Order Comp.".AsInteger();
                    ValueArray[9] := "Reservation Summary Type"::"Released Prod. Order Comp.".AsInteger();
                    ValueArray[10] := "Reservation Summary Type"::"Transfer Shipment".AsInteger();
                    ValueArray[11] := "Reservation Summary Type"::"Transfer Receipt".AsInteger();
                    ValueArray[12] := "Reservation Summary Type"::"Service Order".AsInteger();
                    ValueArray[13] := "Reservation Summary Type"::"Job Planning Order".AsInteger();
                    ValueArray[14] := "Reservation Summary Type"::"Assembly Order Header".AsInteger();
                    ValueArray[15] := "Reservation Summary Type"::"Assembly Order Line".AsInteger();
                    ValueArray[16] := "Reservation Summary Type"::"Inventory Receipt".AsInteger();
                    ValueArray[17] := "Reservation Summary Type"::"Inventory Shipment".AsInteger();
                    ValueArray[18] := 220; //18.07.2008 EDMS P1
                    ValueArray[19] := 230; //18.07.2008 EDMS P1		    
                    ArrayCounter := 19; //18.10.2012 EDMS P1 - changed to 19
                end;
            1:
                begin // Order Tracking
                    ValueArray[1] := "Reservation Summary Type"::"Item Ledger Entry".AsInteger();
                    ValueArray[2] := "Reservation Summary Type"::"Sales Order".AsInteger();
                    ValueArray[3] := "Reservation Summary Type"::"Sales Return Order".AsInteger();
                    ValueArray[4] := "Reservation Summary Type"::"Requisition Line".AsInteger();
                    ValueArray[5] := "Reservation Summary Type"::"Purchase Order".AsInteger();
                    ValueArray[6] := "Reservation Summary Type"::"Purchase Return Order".AsInteger();
                    ValueArray[7] := "Reservation Summary Type"::"Planned Production Order".AsInteger();
                    ValueArray[8] := "Reservation Summary Type"::"Firm Planned Production Order".AsInteger();
                    ValueArray[9] := "Reservation Summary Type"::"Released Production Order".AsInteger();
                    ValueArray[10] := "Reservation Summary Type"::"Planned Prod. Order Comp.".AsInteger();
                    ValueArray[11] := "Reservation Summary Type"::"Firm Planned Prod. Order Comp.".AsInteger();
                    ValueArray[12] := "Reservation Summary Type"::"Released Prod. Order Comp.".AsInteger();
                    ValueArray[13] := "Reservation Summary Type"::"Transfer Shipment".AsInteger();
                    ValueArray[14] := "Reservation Summary Type"::"Transfer Receipt".AsInteger();
                    ValueArray[15] := "Reservation Summary Type"::"Service Order".AsInteger();
                    ValueArray[16] := "Reservation Summary Type"::"Job Planning Order".AsInteger();
                    ValueArray[17] := "Reservation Summary Type"::"Assembly Order Header".AsInteger();
                    ValueArray[18] := "Reservation Summary Type"::"Assembly Order Line".AsInteger();
                    ValueArray[19] := "Reservation Summary Type"::"Inventory Receipt".AsInteger();
                    ValueArray[20] := "Reservation Summary Type"::"Inventory Shipment".AsInteger();
                    ValueArray[21] := 220; //18.07.2008 EDMS P1
                    ValueArray[22] := 230; //18.07.2008 EDMS P1		    
                    ArrayCounter := 22; //18.10.2012 EDMS P1 - changed to 22
                end;
            2:
                begin // Simulation order tracking
                    ValueArray[1] := "Reservation Summary Type"::"Sales Quote".AsInteger();
                    ValueArray[2] := "Reservation Summary Type"::"Simulated Production Order".AsInteger();
                    ValueArray[3] := "Reservation Summary Type"::"Simulated Prod. Order Comp.".AsInteger();
                    ArrayCounter := 3;
                end;
            3:
                begin // Item Tracking
                    ValueArray[1] := "Reservation Summary Type"::"Item Ledger Entry".AsInteger();
                    ValueArray[2] := "Reservation Summary Type"::"Item Tracking Line".AsInteger();
                    ArrayCounter := 2;
                end;
        end;

        OnAfterSetValueArray(EntryStatus, ValueArray, ArrayCounter);
    end;

    procedure ClearSurplus()
    var
        ReservEntry2: Record "Reservation Entry";
        ActionMessageEntry: Record "Action Message Entry";
    begin
        CalcReservEntry.TestField("Source Type");
        ReservEntry2 := CalcReservEntry;
        ReservEntry2.SetPointerFilter;
        ReservEntry2.SetRange("Reservation Status", ReservEntry2."Reservation Status"::Surplus);
        // Item Tracking
        if ItemTrackingHandling = ItemTrackingHandling::None then
            ReservEntry2.SetTrackingFilterBlank;
        OnClearSurplusOnAfterReservEntry2SetFilters(ReservEntry2, ItemTrackingHandling);

        if Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." then begin
            ReservEntry2.Lock;
            if not ReservEntry2.FindSet then
                exit;
            ActionMessageEntry.Reset();
            ActionMessageEntry.SetCurrentKey("Reservation Entry");
            repeat
                ActionMessageEntry.SetRange("Reservation Entry", ReservEntry2."Entry No.");
                ActionMessageEntry.DeleteAll();
            until ReservEntry2.Next() = 0;
        end;

        ReservEntry2.SetRange(
          "Reservation Status", ReservEntry2."Reservation Status"::Surplus, ReservEntry2."Reservation Status"::Prospect);
        if not ReservEntry2.IsEmpty() then
            ReservEntry2.DeleteAll();
    end;

    local procedure QuantityTracked(var ReservEntry: Record "Reservation Entry"): Decimal
    var
        ReservEntry2: Record "Reservation Entry";
        QtyTracked: Decimal;
    begin
        ReservEntry2 := ReservEntry;
        ReservEntry2.SetPointerFilter();
        ReservEntry.CopyTrackingFiltersToReservEntry(ReservEntry2);
        if ReservEntry2.FindFirst() then begin
            ReservEntry.Binding := ReservEntry2.Binding;
            ReservEntry2.CalcSums("Quantity (Base)");
            QtyTracked := ReservEntry2."Quantity (Base)";
        end;
        exit(QtyTracked);
    end;

    local procedure QuantityTracked2(var ReservEntry: Record "Reservation Entry"): Decimal
    var
        ReservEntry2: Record "Reservation Entry";
        QtyTracked: Decimal;
    begin
        ReservEntry2 := ReservEntry;
        ReservEntry2.SetPointerFilter;
        ReservEntry2.SetTrackingFilterFromReservEntry(ReservEntry);
        ReservEntry2.SetRange("Reservation Status",
          ReservEntry2."Reservation Status"::Tracking, ReservEntry2."Reservation Status"::Prospect);
        if not ReservEntry2.IsEmpty() then begin
            ReservEntry2.CalcSums("Quantity (Base)");
            QtyTracked := ReservEntry2."Quantity (Base)";
        end;
        exit(QtyTracked);
    end;

    procedure AutoTrack(TotalQty: Decimal)
    var
        SurplusEntry: Record "Reservation Entry";
        DummyEntry: Record "Reservation Entry";
        AvailabilityDate: Date;
        QtyToTrack: Decimal;
    begin
        CalcReservEntry.TestField("Source Type");

        if CalcReservEntry."Source Type" in [DATABASE::"Sales Line", DATABASE::"Purchase Line", DATABASE::"Service Line"] then
            if not (CalcReservEntry."Source Subtype" in [1, 5]) then
                exit; // Only order, return order

        if CalcReservEntry."Source Type" in [DATABASE::"Prod. Order Line", DATABASE::"Prod. Order Component"]
        then
            if CalcReservEntry."Source Subtype" = 0 then
                exit; // Not simulation

        if CalcReservEntry."Source Type" = DATABASE::"Item Journal Line" then
            exit;

        if CalcReservEntry."Item No." = '' then
            exit;

        GetItemSetup(CalcReservEntry);
        if Item."Order Tracking Policy" = Item."Order Tracking Policy"::None then
            exit;

        CalcReservEntry.Lock;

        QtyToTrack := CreateReservEntry.SignFactor(CalcReservEntry) * TotalQty - QuantityTracked(CalcReservEntry);

        if QtyToTrack = 0 then begin
            UpdateDating;
            exit;
        end;

        QtyToTrack := MatchSurplus(CalcReservEntry, SurplusEntry, QtyToTrack, Positive, AvailabilityDate, Item."Order Tracking Policy");

        // Make residual surplus record:
        if QtyToTrack <> 0 then begin
            if CurrentBindingIsSet then
                MakeConnection(
                    CalcReservEntry, SurplusEntry, QtyToTrack, CalcReservEntry."Reservation Status"::Surplus, AvailabilityDate, CurrentBinding)
            else
                MakeConnection(
                    CalcReservEntry, SurplusEntry, QtyToTrack, CalcReservEntry."Reservation Status"::Surplus, AvailabilityDate, CalcReservEntry.Binding);

            CreateReservEntry.GetLastEntry(SurplusEntry); // Get the surplus-entry just inserted
            if IsResidualSurplusDLT(SurplusEntry) then begin
                SurplusEntry."Untracked Surplus" := true;
                SurplusEntry.Modify();
            end;
            if Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." then // Issue Action Message
                IssueActionMessage(SurplusEntry, true, DummyEntry);
        end else
            UpdateDating;
    end;

    procedure MatchSurplus(var ReservEntry: Record "Reservation Entry"; var SurplusEntry: Record "Reservation Entry"; QtyToTrack: Decimal; SearchForSupply: Boolean; var AvailabilityDate: Date; TrackingPolicy: Enum "Order Tracking Policy"): Decimal
    var
        ReservEntry2: Record "Reservation Entry";
        Search: Text[1];
        NextStep: Integer;
        ReservationStatus: Enum "Reservation Status";
    begin
        if QtyToTrack = 0 then
            exit;

        ReservEntry.Lock;
        SurplusEntry.SetCurrentKey(
          "Item No.", "Variant Code", "Location Code", "Reservation Status",
          "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");
        SurplusEntry.SetRange("Item No.", ReservEntry."Item No.");
        SurplusEntry.SetRange("Variant Code", ReservEntry."Variant Code");
        SurplusEntry.SetRange("Location Code", ReservEntry."Location Code");
        SurplusEntry.SetRange("Reservation Status", SurplusEntry."Reservation Status"::Surplus);
        if SkipUntrackedSurplus then
            SurplusEntry.SetRange("Untracked Surplus", false);
        if SearchForSupply then begin
            AvailabilityDate := ReservEntry."Shipment Date";
            Search := '+';
            NextStep := -1;
            SurplusEntry.SetFilter("Expected Receipt Date", GetAvailabilityFilter2(AvailabilityDate, SearchForSupply));
            SurplusEntry.SetFilter("Quantity (Base)", '>0');
        end else begin
            AvailabilityDate := ReservEntry."Expected Receipt Date";
            Search := '-';
            NextStep := 1;
            SurplusEntry.SetFilter("Shipment Date", GetAvailabilityFilter2(AvailabilityDate, SearchForSupply));
            SurplusEntry.SetFilter("Quantity (Base)", '<0')
        end;
        SurplusEntry.FilterLinesForTracking(ReservEntry, SearchForSupply);
        if SurplusEntry.Find(Search) then
            repeat
                if not IsSpecialOrderOrDropShipment(SurplusEntry) then begin
                    ReservationStatus := ReservationStatus::Tracking;
                    if Abs(SurplusEntry."Quantity (Base)") <= Abs(QtyToTrack) then begin
                        ReservEntry2 := SurplusEntry;
                        MakeConnection(
                            ReservEntry, SurplusEntry, -SurplusEntry."Quantity (Base)", ReservationStatus, AvailabilityDate, SurplusEntry.Binding);
                        QtyToTrack := QtyToTrack + SurplusEntry."Quantity (Base)";
                        SurplusEntry := ReservEntry2;
                        SurplusEntry.Delete();
                        if TrackingPolicy = TrackingPolicy::"Tracking & Action Msg." then
                            ModifyActionMessage(SurplusEntry."Entry No.", 0, true); // Delete related Action Message
                    end else begin
                        SurplusEntry.Validate("Quantity (Base)", SurplusEntry."Quantity (Base)" + QtyToTrack);
                        SurplusEntry.Modify();
                        MakeConnection(
                            ReservEntry, SurplusEntry, QtyToTrack, ReservationStatus, AvailabilityDate, SurplusEntry.Binding);
                        if TrackingPolicy = TrackingPolicy::"Tracking & Action Msg." then
                            ModifyActionMessage(SurplusEntry."Entry No.", QtyToTrack, false); // Modify related Action Message
                        QtyToTrack := 0;
                    end;
                end;
            until (SurplusEntry.Next(NextStep) = 0) or (QtyToTrack = 0);

        exit(QtyToTrack);
    end;

    local procedure MakeConnection(var FromReservEntry: Record "Reservation Entry"; var ToReservEntry: Record "Reservation Entry"; Quantity: Decimal; ReservationStatus: Enum "Reservation Status"; AvailabilityDate: Date; Binding: Enum "Reservation Binding")
    var
        FromTrackingSpecification: Record "Tracking Specification";
        Sign: Integer;
    begin
        if Quantity < 0 then
            ToReservEntry."Shipment Date" := AvailabilityDate
        else
            ToReservEntry."Expected Receipt Date" := AvailabilityDate;

        CreateReservEntry.SetBinding(Binding);

        if FromReservEntry."Planning Flexibility" <> FromReservEntry."Planning Flexibility"::Unlimited then
            CreateReservEntry.SetPlanningFlexibility(FromReservEntry."Planning Flexibility");

        Sign := CreateReservEntry.SignFactor(FromReservEntry);
        CreateReservEntry.CreateReservEntryFor(
          FromReservEntry."Source Type", FromReservEntry."Source Subtype", FromReservEntry."Source ID",
          FromReservEntry."Source Batch Name", FromReservEntry."Source Prod. Order Line", FromReservEntry."Source Ref. No.",
          FromReservEntry."Qty. per Unit of Measure", 0, Sign * Quantity,
          FromReservEntry);

        FromTrackingSpecification.SetSourceFromReservEntry(ToReservEntry);
        FromTrackingSpecification."Qty. per Unit of Measure" := ToReservEntry."Qty. per Unit of Measure";
        FromTrackingSpecification.CopyTrackingFromReservEntry(ToReservEntry);
        CreateReservEntry.CreateReservEntryFrom(FromTrackingSpecification);
        CreateReservEntry.SetApplyFromEntryNo(FromReservEntry."Appl.-from Item Entry");
        CreateReservEntry.SetApplyToEntryNo(FromReservEntry."Appl.-to Item Entry");
        //CreateReservEntry.SetUntrackedSurplus(ToReservEntry."Untracked Surplus");

        if IsSpecialOrderOrDropShipment(ToReservEntry) then begin
            if FromReservEntry."Source Type" = DATABASE::"Purchase Line" then
                ToReservEntry."Shipment Date" := 0D;
            if FromReservEntry."Source Type" = DATABASE::"Sales Line" then
                ToReservEntry."Expected Receipt Date" := 0D;
        end;
        CreateReservEntry.CreateEntry(
          FromReservEntry."Item No.", FromReservEntry."Variant Code", FromReservEntry."Location Code",
          FromReservEntry.Description, ToReservEntry."Expected Receipt Date", ToReservEntry."Shipment Date", 0, ReservationStatus);
    end;

    procedure ModifyUnitOfMeasure()
    begin
        ReservEngineMgt.ModifyUnitOfMeasure(CalcReservEntry, CalcReservEntry."Qty. per Unit of Measure");
    end;

    procedure MakeRoomForReservation(var ReservEntry: Record "Reservation Entry")
    var
        ReservEntry2: Record "Reservation Entry";
        TotalQuantity: Decimal;
    begin
        TotalQuantity := SourceQuantity(ReservEntry, false);
        ReservEntry2 := ReservEntry;
        ReservEntry2.SetPointerFilter;
        ItemTrackingHandling := ItemTrackingHandling::Match;
        DeleteReservEntries(false, TotalQuantity - (ReservEntry."Quantity (Base)" * CreateReservEntry.SignFactor(ReservEntry)),
          ReservEntry2);
    end;

    local procedure SaveTrackingSpecification(var ReservEntry: Record "Reservation Entry"; QtyReleased: Decimal)
    begin
        // Used when creating reservations.
        if ItemTrackingHandling = ItemTrackingHandling::None then
            exit;
        if not ReservEntry.TrackingExists then
            exit;
        TempTrackingSpecification.SetTrackingFilterFromReservEntry(ReservEntry);
        if TempTrackingSpecification.FindSet then begin
            TempTrackingSpecification.Validate("Quantity (Base)",
              TempTrackingSpecification."Quantity (Base)" + QtyReleased);
            TempTrackingSpecification.Modify();
        end else begin
            TempTrackingSpecification.TransferFields(ReservEntry);
            TempTrackingSpecification.Validate("Quantity (Base)", QtyReleased);
            TempTrackingSpecification.Insert();
        end;
        TempTrackingSpecification.Reset();

        OnAfterSaveTrackingSpecification(ReservEntry, TempTrackingSpecification, QtyReleased);
    end;

    procedure CollectTrackingSpecification(var TargetTrackingSpecification: Record "Tracking Specification" temporary): Boolean
    begin
        // Used when creating reservations.
        TempTrackingSpecification.Reset();
        TargetTrackingSpecification.Reset();

        if not TempTrackingSpecification.FindSet then
            exit(false);

        repeat
            TargetTrackingSpecification := TempTrackingSpecification;
            TargetTrackingSpecification.Insert();
        until TempTrackingSpecification.Next() = 0;

        TempTrackingSpecification.DeleteAll();

        exit(true);
    end;

    procedure SourceQuantity(var ReservEntry: Record "Reservation Entry"; SetAsCurrent: Boolean): Decimal
    begin
        exit(GetSourceRecordValue(ReservEntry, SetAsCurrent, 0));
    end;

    procedure FilterReservFor(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; Direction: Enum "Transfer Direction") CaptionText: Text
    begin
        ReservEntry.InitSortingAndFilters(true);

        OnFilterReservFor(SourceRecRef, ReservEntry, Direction.AsInteger(), CaptionText);
    end;

    procedure GetSourceRecordValue(var ReservEntry: Record "Reservation Entry"; SetAsCurrent: Boolean; ReturnOption: Option "Net Qty. (Base)","Gross Qty. (Base)") SourceQty: Decimal
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnGetSourceRecordValue(ReservEntry, SetAsCurrent, ReturnOption, SourceQty, SourceRecRef, IsHandled);
        if IsHandled then
            exit;

        if SetAsCurrent then
            SetReservSource(SourceRecRef, ReservEntry.GetTransferDirection());
    end;

    local procedure GetItemSetup(var ReservEntry: Record "Reservation Entry")
    var
        PlanningGetParameters: Codeunit "Planning-Get Parameters";
    begin
        if ReservEntry."Item No." <> Item."No." then begin
            Item.Get(ReservEntry."Item No.");
            if Item."Item Tracking Code" <> '' then
                ItemTrackingCode.Get(Item."Item Tracking Code")
            else
                ItemTrackingCode.Init();
            PlanningGetParameters.AtSKU(
              SKU, ReservEntry."Item No.", ReservEntry."Variant Code", ReservEntry."Location Code");
            MfgSetup.Get();
        end;
    end;

    local procedure GetSourceServLineEDMSValue(var ReservEntry: Record "Reservation Entry"; SetAsCurrent: Boolean; ReturnOption: Option "Net Qty. (Base)","Gross Qty. (Base)"): Decimal
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        ServiceLineEDMS.Get(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.");
        if SetAsCurrent then
            SetServLineEDMS(ServiceLineEDMS);
        case ReturnOption of
            Returnoption::"Net Qty. (Base)":
                exit(ServiceLineEDMS."Quantity (Base)");
            Returnoption::"Gross Qty. (Base)":
                exit(ServiceLineEDMS."Quantity (Base)");
        end;
    end;

    procedure MarkReservConnection(var ReservEntry: Record "Reservation Entry"; TargetReservEntry: Record "Reservation Entry") ReservedQuantity: Decimal
    var
        ReservEntry2: Record "Reservation Entry";
        SignFactor: Integer;
    begin
        if not ReservEntry.FindSet then
            exit;
        SignFactor := CreateReservEntry.SignFactor(ReservEntry);

        repeat
            if ReservEntry2.Get(ReservEntry."Entry No.", not ReservEntry.Positive) then
                if ReservEntry2.HasSamePointer(TargetReservEntry) then begin
                    ReservEntry.Mark(true);
                    ReservedQuantity += ReservEntry."Quantity (Base)" * SignFactor;
                end;
        until ReservEntry.Next() = 0;
        ReservEntry.MarkedOnly(true);
    end;

    procedure IssueActionMessage(var SurplusEntry: Record "Reservation Entry"; UseGlobalSettings: Boolean; AllDeletedEntry: Record "Reservation Entry")
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        ReservEntry3: Record "Reservation Entry";
        ActionMessageEntry: Record "Action Message Entry";
        ActionMessageEntry2: Record "Action Message Entry";
        NextEntryNo: Integer;
        FirstDate: Date;
        Found: Boolean;
        FreeBinding: Boolean;
        NoMoreData: Boolean;
        DateFormula: DateFormula;
    begin
        SurplusEntry.TestField("Quantity (Base)");
        if SurplusEntry.IsReservationOrTracking() then
            SurplusEntry.FieldError("Reservation Status");
        SurplusEntry.CalcFields("Action Message Adjustment");
        if SurplusEntry."Quantity (Base)" + SurplusEntry."Action Message Adjustment" = 0 then
            exit;

        ActionMessageEntry.Reset();
        NextEntryNo := ActionMessageEntry.GetLastEntryNo() + 1;

        ActionMessageEntry.Init();
        ActionMessageEntry."Entry No." := NextEntryNo;

        if SurplusEntry."Quantity (Base)" > 0 then begin // Supply: Issue AM directly
            if SurplusEntry."Planning Flexibility" = SurplusEntry."Planning Flexibility"::None then
                exit;
            if not (SurplusEntry."Source Type" in [DATABASE::"Prod. Order Line", DATABASE::"Purchase Line"]) then
                exit;

            ActionMessageEntry.TransferFromReservEntry(SurplusEntry);
            ActionMessageEntry.Quantity := -(SurplusEntry."Quantity (Base)" + SurplusEntry."Action Message Adjustment");
            ActionMessageEntry.Type := ActionMessageEntry.Type::New;
            ReservEntry2 := SurplusEntry;
        end else begin // Demand: Find supply and issue AM
            case SurplusEntry.Binding of
                SurplusEntry.Binding::" ":
                    begin
                        if UseGlobalSettings then begin
                            ReservEntry.Copy(SurplusEntry); // Copy filter and sorting
                            ReservEntry.SetRange("Reservation Status"); // Remove filter on Reservation Status
                        end else begin
                            GetItemSetup(SurplusEntry);
                            Positive := true;
                            ReservEntry.SetCurrentKey(
                              "Item No.", "Variant Code", "Location Code", "Reservation Status",
                              "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");
                            ReservEntry.SetRange("Item No.", SurplusEntry."Item No.");
                            ReservEntry.SetRange("Variant Code", SurplusEntry."Variant Code");
                            ReservEntry.SetRange("Location Code", SurplusEntry."Location Code");
                            ReservEntry.SetFilter("Expected Receipt Date", GetAvailabilityFilter(SurplusEntry."Shipment Date"));
                            ReservEntry.FilterLinesForTracking(SurplusEntry, Positive);
                            ReservEntry.SetRange(Positive, true);
                        end;
                        ReservEntry.SetRange(Binding, ReservEntry.Binding::" ");
                        ReservEntry.SetRange("Planning Flexibility", ReservEntry."Planning Flexibility"::Unlimited);
                        ReservEntry.SetFilter("Source Type", '=%1|=%2', DATABASE::"Purchase Line", DATABASE::"Prod. Order Line");
                    end;
                SurplusEntry.Binding::"Order-to-Order":
                    begin
                        ReservEntry3 := SurplusEntry;
                        ReservEntry3.SetPointerFilter;
                        ReservEntry3.SetRange(
                          "Reservation Status", ReservEntry3."Reservation Status"::Reservation, ReservEntry3."Reservation Status"::Tracking);
                        ReservEntry3.SetRange(Binding, ReservEntry3.Binding::"Order-to-Order");
                        if ReservEntry3.FindFirst then begin
                            ReservEntry3.Get(ReservEntry3."Entry No.", not ReservEntry3.Positive);
                            ReservEntry := ReservEntry3;
                            ReservEntry.SetRecFilter;
                            Found := true;
                        end else begin
                            Found := false;
                            FreeBinding := true;
                        end;
                    end;
            end;

            ActionMessageEntry.Quantity := -(SurplusEntry."Quantity (Base)" + SurplusEntry."Action Message Adjustment");

            if not FreeBinding then
                if ReservEntry.Find('+') then begin
                    if AllDeletedEntry."Entry No." > 0 then // The supply record has been deleted and cannot be reused.
                        repeat
                            Found := not AllDeletedEntry.HasSamePointer(ReservEntry);
                            if not Found then
                                NoMoreData := ReservEntry.Next(-1) = 0;
                        until Found or NoMoreData
                    else
                        Found := true;
                end;

            if Found then begin
                ActionMessageEntry.TransferFromReservEntry(ReservEntry);
                ActionMessageEntry.Type := ActionMessageEntry.Type::"Change Qty.";
                ReservEntry2 := ReservEntry;
            end else begin
                ActionMessageEntry."Location Code" := SurplusEntry."Location Code";
                ActionMessageEntry."Variant Code" := SurplusEntry."Variant Code";
                ActionMessageEntry."Item No." := SurplusEntry."Item No.";

                case SKU."Replenishment System" of
                    SKU."Replenishment System"::Purchase:
                        ActionMessageEntry."Source Type" := DATABASE::"Purchase Line";
                    SKU."Replenishment System"::"Prod. Order":
                        ActionMessageEntry."Source Type" := DATABASE::"Prod. Order Line";
                    SKU."Replenishment System"::Transfer:
                        ActionMessageEntry."Source Type" := DATABASE::"Transfer Line";
                    SKU."Replenishment System"::Assembly:
                        ActionMessageEntry."Source Type" := DATABASE::"Assembly Header";
                end;

                ActionMessageEntry.Type := ActionMessageEntry.Type::New;
            end;
            ActionMessageEntry."Reservation Entry" := SurplusEntry."Entry No.";
        end;

        ReservEntry2.SetPointerFilter;
        ReservEntry2.SetRange(
          "Reservation Status", ReservEntry2."Reservation Status"::Reservation, ReservEntry2."Reservation Status"::Tracking);

        if ReservEntry2."Source Type" <> DATABASE::"Item Ledger Entry" then
            if ReservEntry2.FindFirst then begin
                FirstDate := FindDate(ReservEntry2, 0, true);
                if FirstDate <> 0D then begin
                    if (Format(MfgSetup."Default Dampener Period") = '') or
                       ((ReservEntry2.Binding = ReservEntry2.Binding::"Order-to-Order") and
                        (ReservEntry2."Reservation Status" = ReservEntry2."Reservation Status"::Reservation))
                    then
                        Evaluate(MfgSetup."Default Dampener Period", '<0D>');

                    Evaluate(DateFormula, StrSubstNo('%1%2', '-', Format(MfgSetup."Default Dampener Period")));
                    if CalcDate(DateFormula, FirstDate) > ReservEntry2."Expected Receipt Date" then begin
                        ActionMessageEntry2.SetCurrentKey(
                          "Source Type", "Source Subtype", "Source ID", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
                        ActionMessageEntry2.SetSourceFilterFromActionEntry(ActionMessageEntry);
                        ActionMessageEntry2.SetRange(Quantity, 0);
                        ActionMessageEntry2.DeleteAll();
                        ActionMessageEntry2.Reset();
                        ActionMessageEntry2 := ActionMessageEntry;
                        ActionMessageEntry2.Quantity := 0;
                        ActionMessageEntry2."New Date" := FirstDate;
                        ActionMessageEntry2.Type := ActionMessageEntry.Type::Reschedule;
                        ActionMessageEntry2."Reservation Entry" := ReservEntry2."Entry No.";
                        while not ActionMessageEntry2.Insert do
                            ActionMessageEntry2."Entry No." += 1;
                        ActionMessageEntry."Entry No." := ActionMessageEntry2."Entry No." + 1;
                    end;
                end;
            end;

        while not ActionMessageEntry.Insert do
            ActionMessageEntry."Entry No." += 1;
    end;

    procedure ModifyActionMessage(RelatedToEntryNo: Integer; Quantity: Decimal; Delete: Boolean)
    var
        ActionMessageEntry: Record "Action Message Entry";
    begin
        ActionMessageEntry.Reset();
        ActionMessageEntry.SetCurrentKey("Reservation Entry");
        ActionMessageEntry.SetRange("Reservation Entry", RelatedToEntryNo);

        if Delete then begin
            ActionMessageEntry.DeleteAll();
            exit;
        end;
        ActionMessageEntry.SetRange("New Date", 0D);

        if ActionMessageEntry.FindFirst then begin
            ActionMessageEntry.Quantity -= Quantity;
            if ActionMessageEntry.Quantity = 0 then
                ActionMessageEntry.Delete
            else
                ActionMessageEntry.Modify();
        end;
    end;

    procedure FindDate(var ReservEntry: Record "Reservation Entry"; Which: Option "Earliest Shipment","Latest Receipt"; ReturnRecord: Boolean): Date
    var
        ReservEntry2: Record "Reservation Entry";
        LastDate: Date;
    begin
        ReservEntry2.Copy(ReservEntry); // Copy filter and sorting

        if not ReservEntry2.FindSet then
            exit;

        case Which of
            0:
                begin
                    LastDate := DMY2Date(31, 12, 9999);
                    repeat
                        if ReservEntry2."Shipment Date" < LastDate then begin
                            LastDate := ReservEntry2."Shipment Date";
                            if ReturnRecord then
                                ReservEntry := ReservEntry2;
                        end;
                    until ReservEntry2.Next() = 0;
                end;
            1:
                begin
                    LastDate := 0D;
                    repeat
                        if ReservEntry2."Expected Receipt Date" > LastDate then begin
                            LastDate := ReservEntry2."Expected Receipt Date";
                            if ReturnRecord then
                                ReservEntry := ReservEntry2;
                        end;
                    until ReservEntry2.Next() = 0;
                end;
        end;
        exit(LastDate);
    end;

    local procedure UpdateDating()
    var
        FilterReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        ReqLine: Record "Requisition Line";
    begin
        if CalcReservEntry2."Source Type" = DATABASE::"Planning Component" then
            exit;

        if Item."Order Tracking Policy" <> Item."Order Tracking Policy"::"Tracking & Action Msg." then
            exit;

        if CalcReservEntry2."Source Type" = DATABASE::"Requisition Line" then
            if PlanningLineOrigin <> ReqLine."Planning Line Origin"::" ".AsInteger() then
                exit;

        FilterReservEntry := CalcReservEntry2;
        FilterReservEntry.SetPointerFilter;

        if not FilterReservEntry.FindFirst then
            exit;

        if CalcReservEntry2."Source Type" in [DATABASE::"Prod. Order Line", DATABASE::"Purchase Line"]
        then
            ReservEngineMgt.ModifyActionMessageDating(FilterReservEntry)
        else begin
            if FilterReservEntry.Positive then
                exit;
            FilterReservEntry.SetRange("Reservation Status", FilterReservEntry."Reservation Status"::Reservation,
              FilterReservEntry."Reservation Status"::Tracking);
            if not FilterReservEntry.FindSet then
                exit;
            repeat
                if ReservEntry2.Get(FilterReservEntry."Entry No.", not FilterReservEntry.Positive) then
                    ReservEngineMgt.ModifyActionMessageDating(ReservEntry2);
            until FilterReservEntry.Next() = 0;
        end;
    end;

    procedure ClearActionMessageReferences()
    var
        ActionMessageEntry: Record "Action Message Entry";
        ActionMessageEntry2: Record "Action Message Entry";
    begin
        ActionMessageEntry.Reset();
        ActionMessageEntry.FilterFromReservEntry(CalcReservEntry);
        if ActionMessageEntry.FindSet then
            repeat
                ActionMessageEntry2 := ActionMessageEntry;
                if ActionMessageEntry2.Quantity = 0 then
                    ActionMessageEntry2.Delete
                else begin
                    ActionMessageEntry2."Source Subtype" := 0;
                    ActionMessageEntry2."Source ID" := '';
                    ActionMessageEntry2."Source Batch Name" := '';
                    ActionMessageEntry2."Source Prod. Order Line" := 0;
                    ActionMessageEntry2."Source Ref. No." := 0;
                    ActionMessageEntry2."New Date" := 0D;
                    ActionMessageEntry2.Modify();
                end;
            until ActionMessageEntry.Next() = 0;
    end;

    procedure SetItemTrackingHandling(Mode: Option "None","Allow deletion",Match)
    begin
        ItemTrackingHandling := Mode;
    end;

    procedure DeleteItemTrackingConfirm() Result: Boolean
    var
        ConfirmManagement: Codeunit "Confirm Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeDeleteItemTrackingConfirm(CalcReservEntry2, IsHandled, Result);
        if IsHandled then
            exit(Result);

        if not ItemTrackingExist(CalcReservEntry2) then
            exit(true);

        if ConfirmManagement.GetResponseOrDefault(
             StrSubstNo(Text011, CalcReservEntry2."Item No.", CalcReservEntry2.TextCaption), true)
        then
            exit(true);

        exit(false);
    end;

    local procedure ItemTrackingExist(var ReservEntry: Record "Reservation Entry"): Boolean
    var
        ReservEntry2: Record "Reservation Entry";
    begin
        ReservEntry2.Copy(ReservEntry);
        ReservEntry2.SetFilter("Item Tracking", '> %1', ReservEntry2."Item Tracking"::None);
        exit(not ReservEntry2.IsEmpty);
    end;

#if not CLEAN17
    [Obsolete('Replaced by CopyTrackingFrom procedures.', '17.0')]
    procedure SetSerialLotNo(SerialNo: Code[50]; LotNo: Code[50])
    begin
        CalcReservEntry."Serial No." := SerialNo;
        CalcReservEntry."Lot No." := LotNo;
    end;
#endif

    procedure SetTrackingFromReservEntry(ReservEntry: Record "Reservation Entry")
    begin
        CalcReservEntry.CopyTrackingFromReservEntry(ReservEntry);
    end;

    procedure SetTrackingFromWhseActivityLine(WhseActivityLine: Record "Warehouse Activity Line")
    begin
        CalcReservEntry.CopyTrackingFromWhseActivLine(WhseActivityLine);
    end;

    procedure SetMatchFilter(var ReservEntry: Record "Reservation Entry"; var FilterReservEntry: Record "Reservation Entry"; SearchForSupply: Boolean; AvailabilityDate: Date)
    begin
        FilterReservEntry.Reset();
        FilterReservEntry.SetCurrentKey(
          "Item No.", "Variant Code", "Location Code", "Reservation Status",
          "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");
        FilterReservEntry.SetRange("Item No.", ReservEntry."Item No.");
        FilterReservEntry.SetRange("Variant Code", ReservEntry."Variant Code");
        FilterReservEntry.SetRange("Location Code", ReservEntry."Location Code");
        FilterReservEntry.SetRange("Reservation Status",
          FilterReservEntry."Reservation Status"::Reservation, FilterReservEntry."Reservation Status"::Surplus);
        if SearchForSupply then
            FilterReservEntry.SetFilter("Expected Receipt Date", '..%1', AvailabilityDate)
        else
            FilterReservEntry.SetFilter("Shipment Date", '>=%1', AvailabilityDate);
        FilterReservEntry.FilterLinesForTracking(ReservEntry, SearchForSupply);
        FilterReservEntry.SetRange(Positive, SearchForSupply);
    end;

    procedure LookupLine(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        case SourceType of
            Database::"Service Line EDMS": //08.07.08 EDMS P1
                begin
                    ServiceLineEDMS.Reset;
                    ServiceLineEDMS.SetRange("Document Type", SourceSubtype);
                    ServiceLineEDMS.SetRange("Document No.", SourceID);
                    ServiceLineEDMS.SetRange("Line No.", SourceRefNo);
                    Page.Run(0, ServiceLineEDMS);
                end;

        end;
        OnLookupLine(SourceType, SourceSubtype, SourceID, SourceBatchName, SourceProdOrderLine, SourceRefNo);
    end;

    procedure LookupDocument(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer)
    var
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        IsHandled: Boolean;
        ServiceHeaderEDMS: Record "Service Header EDMS";
    begin
        IsHandled := false;
        OnBeforeLookupDocument(SourceType, SourceSubtype, SourceID, SourceBatchName, SourceProdOrderLine, SourceRefNo, IsHandled);
        if IsHandled then
            exit;

        //FIXME BC16 upgrade
        case SourceType of
            DATABASE::"Sales Line":
                begin
                    SalesHeader.Reset;
                    SalesHeader.SetRange("Document Type", SourceSubtype);
                    SalesHeader.SetRange("No.", SourceID);
                    if SalesHeader.FindFirst then;

                    case SalesHeader."Document Profile" of

                        //30.10.2012 EDMS >>

                        SalesHeader."document profile"::"Vehicles Trade":
                            begin
                                SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::"Vehicles Trade");
                                case SourceSubtype of
                                    0:
                                        Page.Run(Page::"Sales Quote", SalesHeader);
                                    1:
                                        Page.Run(Page::"Sales Order", SalesHeader);
                                    2:
                                        Page.Run(Page::"Sales Invoice", SalesHeader);
                                    3:
                                        Page.Run(Page::"Sales Credit Memo", SalesHeader);
                                end;
                            end;

                        //30.10.2012 EDMS <<

                        SalesHeader."document profile"::"Spare Parts Trade":
                            case SourceSubtype of
                                0:
                                    Page.Run(Page::"Sales Quote", SalesHeader);
                                1:
                                    Page.Run(Page::"Sales Order", SalesHeader);
                                2:
                                    Page.Run(Page::"Sales Invoice", SalesHeader);
                                3:
                                    Page.Run(Page::"Sales Credit Memo", SalesHeader);
                            end;

                        //30.10.2012 EDMS >>

                        SalesHeader."document profile"::Service:
                            begin
                                case SourceSubtype of
                                    0:
                                        Page.Run(Page::"Sales Quote", SalesHeader);
                                    1:
                                        Page.Run(Page::"Sales Order", SalesHeader);
                                    2:
                                        begin
                                            SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::Service);
                                            Page.Run(Page::"Sales Invoice", SalesHeader);
                                        end;
                                    3:
                                        begin
                                            SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::Service);
                                            Page.Run(Page::"Sales Credit Memo", SalesHeader);
                                        end;
                                end;
                            end;
                    end;
                end;
            DATABASE::"Purchase Line":
                begin
                    PurchHeader.Reset;
                    PurchHeader.SetRange("Document Type", SourceSubtype);
                    PurchHeader.SetRange("No.", SourceID);
                    if PurchHeader.FindFirst then;
                    case PurchHeader."Document Profile" of
                        PurchHeader."document profile"::"Spare Parts Trade":
                            case SourceSubtype of
                                0:
                                    Page.Run(Page::"Purchase Quote", PurchHeader);
                                1:
                                    Page.Run(Page::"Purchase Order", PurchHeader);
                                2:
                                    Page.Run(Page::"Purchase Invoice", PurchHeader);
                                3:
                                    Page.Run(Page::"Purchase Credit Memo", PurchHeader);
                            end;


                        //30.10.2012 EDMS >>

                        PurchHeader."document profile"::"Vehicles Trade":
                            begin
                                PurchHeader.SetRange("Document Profile", PurchHeader."document profile"::"Vehicles Trade");
                                case SourceSubtype of
                                    1:
                                        Page.Run(Page::"Purchase Quote", PurchHeader);
                                    2:
                                        Page.Run(Page::"Purchase Order", PurchHeader);
                                    3:
                                        Page.Run(Page::"Purchase Invoice", PurchHeader);
                                    4:
                                        Page.Run(Page::"Purchase Credit Memo", PurchHeader);
                                end;
                            end;
                        PurchHeader."document profile"::Service:
                            case SourceSubtype of
                                3:
                                    begin
                                        PurchHeader.SetRange("Document Profile", PurchHeader."document profile"::"Vehicles Trade");
                                        Page.Run(Page::"Purchase Invoice", PurchHeader);
                                    end;
                            end;

                    //30.10.2012 EDMS <<
                    end;
                end;
            Database::"Service Line EDMS": //08.07.08 EDMS P1
                begin
                    ServiceHeaderEDMS.Reset;
                    ServiceHeaderEDMS.SetRange("Document Type", SourceSubtype);
                    ServiceHeaderEDMS.SetRange("No.", SourceID);
                    if SourceSubtype = 0 then
                        Page.RunModal(Page::"Service Quote EDMS", ServiceHeaderEDMS)
                    else
                        Page.RunModal(Page::"Service Order EDMS", ServiceHeaderEDMS);
                end;

        end;
        OnLookupDocument(SourceType, SourceSubtype, SourceID, SourceBatchName, SourceProdOrderLine, SourceRefNo);
    end;

    local procedure CallCalcReservedQtyOnPick()
    var
        ShouldCalsReservedQtyOnPick: Boolean;
    begin
        ShouldCalsReservedQtyOnPick :=
            Positive and (CalcReservEntry."Location Code" <> '') and
            Location.Get(CalcReservEntry."Location Code") and (Location."Bin Mandatory" or Location."Require Pick");

        OnBeforeCallCalcReservedQtyOnPick(CalcReservEntry, Positive, ShouldCalsReservedQtyOnPick);

        if ShouldCalsReservedQtyOnPick then
            CalcReservedQtyOnPick(TotalAvailQty, QtyAllocInWhse);
    end;

    local procedure CalcReservedQtyOnPick(var AvailQty: Decimal; var AllocQty: Decimal)
    var
        WhseActivLine: Record "Warehouse Activity Line";
        WhseItemTrackingSetup: Record "Item Tracking Setup";
        TempWhseActivLine2: Record "Warehouse Activity Line" temporary;
        TempBinContentBuffer: Record "Bin Content Buffer" temporary;
        WhseAvailMgt: Codeunit "Warehouse Availability Mgt.";
        QtyOnOutboundBins: Decimal;
        QtyOnInvtMovement: Decimal;
        QtyOnSpecialBins: Decimal;
        IsHandled: Boolean;
    begin
        GetItemSetup(CalcReservEntry);
        Item.SetRange("Location Filter", CalcReservEntry."Location Code");
        IsHandled := false;
        OnCalcReservedQtyOnPickOnbeforeSetItemVariantCodeFilter(Item, CalcReservEntry, IsHandled);
        if not IsHandled then
            Item.SetRange("Variant Filter", CalcReservEntry."Variant Code");
        CalcReservEntry.SetTrackingFilterToItemIfRequired(Item);
        Item.CalcFields(Inventory, "Reserved Qty. on Inventory");

        WhseActivLine.SetCurrentKey(
          "Item No.", "Bin Code", "Location Code", "Action Type", "Variant Code",
          "Unit of Measure Code", "Breakbulk No.", "Activity Type", "Lot No.", "Serial No.");

        WhseActivLine.SetRange("Item No.", CalcReservEntry."Item No.");
        if Location."Bin Mandatory" then
            WhseActivLine.SetFilter("Bin Code", '<>%1', '');
        WhseActivLine.SetRange("Location Code", CalcReservEntry."Location Code");
        WhseActivLine.SetFilter(
          "Action Type", '%1|%2', WhseActivLine."Action Type"::" ", WhseActivLine."Action Type"::Take);
        IsHandled := false;
        OnCalcReservedQtyOnPickOnBeforeSetWhseActivLineVariantCodeFilter(WhseActivLine, CalcReservEntry, IsHandled);
        if not IsHandled then
            WhseActivLine.SetRange("Variant Code", CalcReservEntry."Variant Code");
        WhseActivLine.SetRange("Breakbulk No.", 0);
        WhseActivLine.SetFilter(
          "Activity Type", '%1|%2', WhseActivLine."Activity Type"::Pick, WhseActivLine."Activity Type"::"Invt. Pick");
        WhseActivLine.SetTrackingFilterFromReservEntryIfRequired(CalcReservEntry);
        WhseActivLine.CalcSums("Qty. Outstanding (Base)");

        if Location."Require Pick" then begin
            WhseItemTrackingSetup.CopyTrackingFromReservEntry(CalcReservEntry);

            if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" and
               WhseItemTrackingSetup.TrackingExists()
            then begin
                WhseAvailMgt.GetOutboundBinsOnBasicWarehouseLocation(
                  TempBinContentBuffer, CalcReservEntry."Location Code", CalcReservEntry."Item No.", CalcReservEntry."Variant Code", WhseItemTrackingSetup);
                TempBinContentBuffer.CalcSums("Qty. Outstanding (Base)");
                QtyOnOutboundBins := TempBinContentBuffer."Qty. Outstanding (Base)";
            end else
                QtyOnOutboundBins :=
                    WhseAvailMgt.CalcQtyOnOutboundBins(CalcReservEntry."Location Code", CalcReservEntry."Item No.", CalcReservEntry."Variant Code", WhseItemTrackingSetup, true);

            QtyReservedOnPickShip :=
              WhseAvailMgt.CalcReservQtyOnPicksShips(
                CalcReservEntry."Location Code", CalcReservEntry."Item No.", CalcReservEntry."Variant Code", TempWhseActivLine2);

            QtyOnInvtMovement := CalcQtyOnInvtMovement(WhseActivLine);

            QtyOnSpecialBins :=
                WhseAvailMgt.CalcQtyOnSpecialBinsOnLocation(
                  CalcReservEntry."Location Code", CalcReservEntry."Item No.", CalcReservEntry."Variant Code", WhseItemTrackingSetup, TempBinContentBuffer);
        end;

        CalcAvailAllocQuantities(
            Item, WhseActivLine, QtyOnOutboundBins, QtyOnInvtMovement, QtyOnSpecialBins, AvailQty, AllocQty);

        OnAfterCalcReservedQtyOnPick(Item, WhseActivLine, CalcReservEntry, AvailQty, AllocQty);
    end;

    local procedure CalcAvailAllocQuantities(
        Item: Record Item; WhseActivLine: Record "Warehouse Activity Line";
        QtyOnOutboundBins: Decimal; QtyOnInvtMovement: Decimal; QtyOnSpecialBins: Decimal;
        var AvailQty: Decimal; var AllocQty: Decimal)
    var
        IsHandled: Boolean;
        PickQty: Decimal;
    begin
        IsHandled := false;
        OnBeforeCalcAvailAllocQuantities(
            Item, WhseActivLine, QtyOnOutboundBins, QtyOnInvtMovement, QtyOnSpecialBins,
            AvailQty, AllocQty, IsHandled);
        if IsHandled then
            exit;

        AllocQty :=
            WhseActivLine."Qty. Outstanding (Base)" + QtyOnInvtMovement +
            QtyOnOutboundBins + QtyOnSpecialBins;
        PickQty := WhseActivLine."Qty. Outstanding (Base)" + QtyOnInvtMovement;

        AvailQty :=
            Item.Inventory - PickQty - QtyOnOutboundBins - QtyOnSpecialBins -
            Item."Reserved Qty. on Inventory" + QtyReservedOnPickShip;
    end;

    local procedure SaveItemTrackingAsSurplus(var ReservEntry: Record "Reservation Entry"; NewQty: Decimal; NewQtyBase: Decimal) QuantityIsValidated: Boolean
    var
        SurplusEntry: Record "Reservation Entry";
        CreateReservEntry2: Codeunit "Create Reserv. Entry";
        QtyToSave: Decimal;
        QtyToSaveBase: Decimal;
        QtyToHandleThisLine: Decimal;
        QtyToInvoiceThisLine: Decimal;
        SignFactor: Integer;
    begin
        QtyToSave := ReservEntry.Quantity - NewQty;
        QtyToSaveBase := ReservEntry."Quantity (Base)" - NewQtyBase;

        if QtyToSaveBase = 0 then
            exit;

        if ReservEntry."Item Tracking" = ReservEntry."Item Tracking"::None then
            exit;

        if ReservEntry."Source Type" = DATABASE::"Item Ledger Entry" then
            exit;

        if QtyToSaveBase * ReservEntry."Quantity (Base)" < 0 then
            ReservEntry.FieldError("Quantity (Base)");

        SignFactor := ReservEntry."Quantity (Base)" / Abs(ReservEntry."Quantity (Base)");

        if SignFactor * QtyToSaveBase > SignFactor * ReservEntry."Quantity (Base)" then
            ReservEntry.FieldError("Quantity (Base)");

        QtyToHandleThisLine := ReservEntry."Qty. to Handle (Base)" - NewQtyBase;
        QtyToInvoiceThisLine := ReservEntry."Qty. to Invoice (Base)" - NewQtyBase;

        ReservEntry.Validate("Quantity (Base)", NewQtyBase);

        if SignFactor * QtyToHandleThisLine < 0 then begin
            ReservEntry.Validate("Qty. to Handle (Base)", ReservEntry."Qty. to Handle (Base)" + QtyToHandleThisLine);
            QtyToHandleThisLine := 0;
        end;

        if SignFactor * QtyToInvoiceThisLine < 0 then begin
            ReservEntry.Validate("Qty. to Invoice (Base)", ReservEntry."Qty. to Invoice (Base)" + QtyToInvoiceThisLine);
            QtyToInvoiceThisLine := 0;
        end;

        QuantityIsValidated := true;

        SurplusEntry := ReservEntry;
        SurplusEntry."Reservation Status" := SurplusEntry."Reservation Status"::Surplus;
        if SurplusEntry.Positive then
            SurplusEntry."Shipment Date" := 0D
        else
            SurplusEntry."Expected Receipt Date" := 0D;
        CreateReservEntry2.SetQtyToHandleAndInvoice(QtyToHandleThisLine, QtyToInvoiceThisLine);
        CreateReservEntry2.CreateRemainingReservEntry(SurplusEntry, QtyToSave, QtyToSaveBase);
    end;

    procedure CalcIsAvailTrackedQtyInBin(ItemNo: Code[20]; BinCode: Code[20]; LocationCode: Code[10]; VariantCode: Code[10]; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer): Boolean
    var
        ReservationEntry: Record "Reservation Entry";
        WhseEntry: Record "Warehouse Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        if not ItemTrackingMgt.GetWhseItemTrkgSetup(ItemNo) or (BinCode = '') then
            exit(true);

        ReservationEntry.SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, false);
        ReservationEntry.SetSourceFilter(SourceBatchName, SourceProdOrderLine);
        ReservationEntry.SetRange(Positive, false);
        if ReservationEntry.FindSet then
            repeat
                if ReservEntryPositiveTypeIsItemLedgerEntry(ReservationEntry."Entry No.") then begin
                    WhseEntry.SetCurrentKey("Item No.", "Location Code", "Variant Code", "Bin Type Code");
                    WhseEntry.SetRange("Item No.", ItemNo);
                    WhseEntry.SetRange("Location Code", LocationCode);
                    WhseEntry.SetRange("Bin Code", BinCode);
                    WhseEntry.SetRange("Variant Code", VariantCode);
                    WhseEntry.SetTrackingFilterFromReservEntryIfNotBlank(ReservationEntry);
                    WhseEntry.CalcSums("Qty. (Base)");
                    if WhseEntry."Qty. (Base)" < Abs(ReservationEntry."Quantity (Base)") then
                        exit(false);
                end;
            until ReservationEntry.Next() = 0;

        exit(true);
    end;

    local procedure CalcQtyOnInvtMovement(var WarehouseActivityLine: Record "Warehouse Activity Line"): Decimal
    var
        xWarehouseActivityLine: Record "Warehouse Activity Line";
        OutstandingQty: Decimal;
    begin
        xWarehouseActivityLine.Copy(WarehouseActivityLine);

        WarehouseActivityLine.SetRange("Activity Type", WarehouseActivityLine."Activity Type"::"Invt. Movement");
        if WarehouseActivityLine.Find('-') then
            repeat
                if WarehouseActivityLine."Source Type" <> 0 then
                    OutstandingQty += WarehouseActivityLine."Qty. Outstanding (Base)"
            until WarehouseActivityLine.Next() = 0;

        WarehouseActivityLine.Copy(xWarehouseActivityLine);
        exit(OutstandingQty);
    end;

    local procedure ProdJnlLineEntry(ReservationEntry: Record "Reservation Entry"): Boolean
    begin
        exit((ReservationEntry."Source Type" = DATABASE::"Item Journal Line") and (ReservationEntry."Source Subtype" = 6));
    end;

    local procedure CalcDownToQtySyncingToAssembly(ReservEntry: Record "Reservation Entry"): Decimal
    var
        SynchronizingSalesLine: Record "Sales Line";
    begin
        if ReservEntry."Source Type" = DATABASE::"Sales Line" then begin
            SynchronizingSalesLine.Get(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.");
            if (Item."Order Tracking Policy" <> Item."Order Tracking Policy"::None) and
               (Item."Assembly Policy" = Item."Assembly Policy"::"Assemble-to-Order") and
               (Item."Replenishment System" = Item."Replenishment System"::Assembly) and
               (SynchronizingSalesLine."Quantity (Base)" = 0)
            then
                exit(ReservEntry."Quantity (Base)" * CreateReservEntry.SignFactor(ReservEntry));
        end;
    end;

    procedure AutoReserveToShip(var FullAutoReservation: Boolean; Description: Text[100]; AvailabilityDate: Date; QuantityToShip: Decimal; QuantityToShipBase: Decimal)
    var
        RemainingQtyToReserve: Decimal;
        RemainingQtyToReserveBase: Decimal;
        StopReservation: Boolean;
    begin
        CalcReservEntry.TestField("Source Type");

        if CalcReservEntry."Source Type" in [1 /*Sales*/, 3 /* Purchase*/]
        then
            StopReservation := not (CalcReservEntry."Source Subtype" in [1, 2, 5]); // Only invoice, order and return order

        if CalcReservEntry."Source Type" in [7 /*Prod. Order Line"*/, 8 /* Prod. Order Component */]
        then
            StopReservation := CalcReservEntry."Source Subtype" < 2; // Not simulated or planned

        if StopReservation then begin
            FullAutoReservation := true;
            exit;
        end;

        RemainingQtyToReserve := QuantityToShip;
        RemainingQtyToReserveBase := QuantityToShipBase;
        FullAutoReservation := false;

        if RemainingQtyToReserve = 0 then begin
            FullAutoReservation := true;
            exit;
        end;

        SetValueArray(0);
        AutoReserveOneLine(ValueArray[1], RemainingQtyToReserve, RemainingQtyToReserveBase, Description, AvailabilityDate);

        FullAutoReservation := (RemainingQtyToReserve = 0);
    end;

    local procedure CalcCurrLineReservQtyOnPicksShips(ReservationEntry: Record "Reservation Entry"): Decimal
    var
        ReservEntry: Record "Reservation Entry";
        TempWhseActivLine: Record "Warehouse Activity Line" temporary;
        WhseAvailMgt: Codeunit "Warehouse Availability Mgt.";
        PickQty: Decimal;
    begin
        PickQty := WhseAvailMgt.CalcRegisteredAndOutstandingPickQty(ReservationEntry, TempWhseActivLine);

        ReservEntry.SetSourceFilter(
          ReservationEntry."Source Type", ReservationEntry."Source Subtype",
          ReservationEntry."Source ID", ReservationEntry."Source Ref. No.", false);
        ReservEntry.SetRange("Source Prod. Order Line", ReservationEntry."Source Prod. Order Line");
        ReservEntry.SetRange("Reservation Status", ReservEntry."Reservation Status"::Reservation);
        ReservEntry.CalcSums("Quantity (Base)");
        if -ReservEntry."Quantity (Base)" > PickQty then
            exit(PickQty);
        exit(-ReservEntry."Quantity (Base)");
    end;

    local procedure CheckQuantityIsCompletelyReleased(QtyToRelease: Decimal; DeleteAll: Boolean; CurrentItemTrackingSetup: Record "Item Tracking Setup"; ReservEntry: Record "Reservation Entry")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckQuantityIsCompletelyReleased(ItemTrackingHandling, QtyToRelease, DeleteAll, CurrentItemTrackingSetup, ReservEntry, IsHandled);
        if IsHandled then
            exit;

        if QtyToRelease = 0 then
            exit;

        if ItemTrackingHandling = ItemTrackingHandling::None then begin
            if DeleteAll then
                Error(Text010, ReservEntry."Item No.", ReservEntry.TextCaption);
            if not ProdJnlLineEntry(ReservEntry) then
                Error(Text008, ReservEntry."Item No.", ReservEntry.TextCaption);
        end;

        if ItemTrackingHandling = ItemTrackingHandling::Match then
            Error(
                ItemTrackingCannotBeFullyMatchedErr,
                CurrentItemTrackingSetup."Serial No.", CurrentItemTrackingSetup."Lot No.", Abs(QtyToRelease));
    end;


    procedure ReservEntryPositiveTypeIsItemLedgerEntry(ReservationEntryNo: Integer): Boolean
    var
        ReservationEntryPositive: Record "Reservation Entry";
    begin
        if ReservationEntryPositive.Get(ReservationEntryNo, true) then
            exit(ReservationEntryPositive."Source Type" = DATABASE::"Item Ledger Entry");

        exit(true);
    end;

    procedure DeleteDocumentReservation(TableID: Integer; DocType: Option; DocNo: Code[20]; HideValidationDialog: Boolean)
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        ConfirmManagement: Codeunit "Confirm Management";
        DocTypeCaption: Text;
        Confirmed: Boolean;
    begin
        OnBeforeDeleteDocumentReservation(TableID, DocType, DocNo, HideValidationDialog);

        ReservEntry.Reset();
        ReservEntry.SetCurrentKey(
            "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
            "Source Batch Name", "Source Prod. Order Line", "Reservation Status");
        if TableID <> DATABASE::"Prod. Order Line" then begin
            ReservEntry.SetRange("Source Type", TableID);
            ReservEntry.SetRange("Source Prod. Order Line", 0);
        end else
            ReservEntry.SetFilter("Source Type", '%1|%2', DATABASE::"Prod. Order Line", DATABASE::"Prod. Order Component");

        case TableID of
            DATABASE::"Transfer Line":
                ReservEntry.SetRange("Source Subtype");
            DATABASE::"Prod. Order Line":
                ReservEntry.SetRange("Source Subtype", DocType);
            DATABASE::"Assembly Line":
                ReservEntry.SetRange("Source Subtype", DocType);
            else
                ReservEntry.SetRange("Source Subtype", DocType);
        end;

        ReservEntry.SetRange("Source ID", DocNo);
        ReservEntry.SetRange("Source Batch Name", '');
        ReservEntry.SetFilter("Item Tracking", '> %1', "Item Tracking Entry Type"::None);
        if ReservEntry.IsEmpty() then
            exit;

        if HideValidationDialog then
            Confirmed := true
        else begin
            DocTypeCaption := GetDocumentReservationDeleteQst(TableID, DocType, DocNo);
            Confirmed := ConfirmManagement.GetResponseOrDefault(DocTypeCaption, true);
        end;

        if not Confirmed then
            Error('');

        if ReservEntry.FindSet() then
            repeat
                ReservEntry2 := ReservEntry;
                ReservEntry2.ClearItemTrackingFields();
                ReservEntry2.Modify();
            until ReservEntry.Next() = 0;
    end;

    local procedure GetDocumentReservationDeleteQst(TableID: Integer; DocType: Option; DocNo: Code[20]): Text
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        DocTypeCaption: Text;
        IsHandled: Boolean;
    begin
        case TableID of
            DATABASE::"Transfer Line":
                exit(StrSubstNo(DeleteTransLineWithItemReservQst, DocNo));
            DATABASE::"Prod. Order Line":
                begin
                    RecRef.Open(TableID);
                    FldRef := RecRef.FieldIndex(1);
                    exit(StrSubstNo(DeleteProdOrderLineWithItemReservQst, SelectStr(DocType + 1, FldRef.OptionCaption), DocNo));
                end;
            DATABASE::"Assembly Line":
                begin
                    RecRef.Open(TableID);
                    FldRef := RecRef.FieldIndex(1);
                    case DocType of
                        "Assembly Document Type"::Quote.AsInteger(),
                        "Assembly Document Type"::"Order".AsInteger():
                            exit(StrSubstNo(DeleteDocLineWithItemReservQst, SelectStr(DocType + 1, FldRef.OptionCaption), DocNo));
                        "Assembly Document Type"::"Blanket Order".AsInteger():
                            exit(StrSubstNo(DeleteDocLineWithItemReservQst, SelectStr(3, FldRef.OptionCaption), DocNo));
                    end;
                end;
            else begin
                RecRef.Open(TableID);
                FldRef := RecRef.FieldIndex(1);
                OnGetDocumentReservationDeleteQstOnElseCase(RecRef, FldRef, DocType, DocTypeCaption, IsHandled);
                if not IsHandled then
                    exit(StrSubstNo(DeleteDocLineWithItemReservQst, SelectStr(DocType + 1, FldRef.OptionCaption), DocNo));
            end;
        end;
    end;


    procedure SetSkipUntrackedSurplus(NewSkipUntrackedSurplus: Boolean)
    begin
        SkipUntrackedSurplus := NewSkipUntrackedSurplus;
    end;

    procedure SetQtyToReserveDownToTrackedQuantity(ReservEntry: Record "Reservation Entry"; RowID: Text[250]; var QtyThisLine: Decimal; var QtyThisLineBase: Decimal)
    var
        FilterReservEntry: Record "Reservation Entry";
        TempTrackingSpec: Record "Tracking Specification" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        UOMMgt: Codeunit "Unit of Measure Management";
        MaxReservQtyPerLotOrSerial: Decimal;
        MaxReservQtyBasePerLotOrSerial: Decimal;
    begin
        if not ReservEntry.TrackingExists() then
            exit;

        FilterReservEntry.SetPointer(RowID);
        FilterReservEntry.SetPointerFilter();
        FilterReservEntry.SetTrackingFilterFromReservEntry(ReservEntry);
        ItemTrackingMgt.SumUpItemTracking(FilterReservEntry, TempTrackingSpec, true, true);

        MaxReservQtyBasePerLotOrSerial := TempTrackingSpec."Quantity (Base)";
        MaxReservQtyPerLotOrSerial :=
            UOMMgt.CalcQtyFromBase(
                FilterReservEntry."Item No.", FilterReservEntry."Variant Code", '',
                MaxReservQtyBasePerLotOrSerial, TempTrackingSpec."Qty. per Unit of Measure");
        QtyThisLine := GetMinAbs(QtyThisLine, MaxReservQtyPerLotOrSerial) * GetSign(QtyThisLine);
        QtyThisLineBase := GetMinAbs(QtyThisLineBase, MaxReservQtyBasePerLotOrSerial) * GetSign(QtyThisLineBase);
    end;

    local procedure IsSpecialOrderOrDropShipment(ReservationEntry: Record "Reservation Entry"): Boolean
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
    begin
        if ReservationEntry."Source Type" = DATABASE::"Sales Line" then
            if SalesLine.Get(ReservationEntry."Source Subtype", ReservationEntry."Source ID", ReservationEntry."Source Ref. No.") then
                if SalesLine."Special Order" or SalesLine."Drop Shipment" then
                    exit(true);
        if ReservationEntry."Source Type" = DATABASE::"Purchase Line" then
            if PurchaseLine.Get(ReservationEntry."Source Subtype", ReservationEntry."Source ID", ReservationEntry."Source Ref. No.") then
                if PurchaseLine."Special Order" or PurchaseLine."Drop Shipment" then
                    exit(true);
        exit(false);
    end;

    procedure FindUnfinishedSpecialOrderSalesNo(ItemLedgerEntry: Record "Item Ledger Entry") Result: Code[20]
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        SalesLine: Record "Sales Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeFindUnfinishedSpecialOrderSalesNo(ItemLedgerEntry, Result, IsHandled);
        if IsHandled then
            exit(Result);

        if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Receipt" then
            if PurchRcptLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then
                if SalesLine.Get(
                     SalesLine."Document Type"::Order, PurchRcptLine."Special Order Sales No.", PurchRcptLine."Special Order Sales Line No.")
                then
                    if SalesLine.Quantity <> SalesLine."Quantity Shipped" then
                        exit(SalesLine."Document No.");

        exit('');
    end;

    procedure GetMinAbs(Value1: Decimal; Value2: Decimal): Decimal
    begin
        Value1 := Abs(Value1);
        Value2 := Abs(Value2);
        if Value1 <= Value2 then
            exit(Value1);
        exit(Value2);
    end;

    procedure GetSign(Value: Decimal): Integer
    begin
        if Value >= 0 then
            exit(1);
        exit(-1);
    end;

    procedure TestItemType(SourceRecRef: RecordRef)
    var
        AssemblyLine: Record "Assembly Line";
        JobPlanningLine: Record "Job Planning Line";
        PurchaseLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        ServiceLine: Record "Service Line";
    begin
        case SourceRecRef.Number of
            DATABASE::"Assembly Line":
                begin
                    SourceRecRef.SetTable(AssemblyLine);
                    AssemblyLine.TestField(Type, AssemblyLine.Type::Item);
                end;
            DATABASE::"Sales Line":
                begin
                    SourceRecRef.SetTable(SalesLine);
                    SalesLine.TestField(Type, SalesLine.Type::Item);
                end;
            DATABASE::"Purchase Line":
                begin
                    SourceRecRef.SetTable(PurchaseLine);
                    PurchaseLine.TestField(Type, PurchaseLine.Type::Item);
                end;
            DATABASE::"Service Line":
                begin
                    SourceRecRef.SetTable(ServiceLine);
                    ServiceLine.TestField(Type, ServiceLine.Type::Item);
                end;
            DATABASE::"Job Planning Line":
                begin
                    SourceRecRef.SetTable(JobPlanningLine);
                    JobPlanningLine.TestField(Type, JobPlanningLine.Type::Item);
                end;
        end;
    end;

    procedure IsResidualSurplusDLT(var ReservationEntry: Record "Reservation Entry"): Boolean
    begin
        exit(
          (ReservationEntry."Item Tracking" = ReservationEntry."Item Tracking"::None) and
          (ReservationEntry."Reservation Status" = ReservationEntry."Reservation Status"::Surplus) and not ReservationEntry.Positive and
          (ReservationEntry."Source Type" = DATABASE::"Sales Line") and (ReservationEntry."Source Subtype" = 1));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAutoReserve(var ReservationEntry: Record "Reservation Entry"; var FullAutoReservation: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAutoReserveOneLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer; CalcReservEntry: Record "Reservation Entry"; CalcReservEntry2: Record "Reservation Entry"; Positive: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAutoReservePurchLine(var PurchLine: Record "Purchase Line"; ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcReservation(var ReservEntry: Record "Reservation Entry"; var ItemLedgEntry: Record "Item Ledger Entry"; var ResSummEntryNo: Integer; var QtyThisLine: Decimal; var QtyThisLineBase: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAutoReserveItemLedgEntry(var CalcItemLedgEntry: Record "Item Ledger Entry"; var RemainingQtyToReserveBase: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertReservationEntries(var TrackingSpecification: Record "Tracking Specification"; var CalcReservEntry: Record "Reservation Entry"; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; var QtyThisLine: Decimal; var QtyThisLineBase: Decimal; var ReservationCreated: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserveOneLine(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteDocumentReservation(TableID: Integer; DocType: Option; DocNo: Code[20]; var HideValidationDialog: Boolean)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterInitFilter(var CalcReservEntry: Record "Reservation Entry"; EntryID: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSaveTrackingSpecification(var ReservationEntry: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification"; QtyReleased: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetValueArray(EntryStatus: Option Reservation,Tracking,Simulation; var ValueArray: array[30] of Integer; var ArrayCounter: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateStatistics(var ReservEntrySummary: Record "Entry Summary"; AvailabilityDate: Date; var CalcSumValue: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAutoReserveItemLedgEntryOnFindFirstItemLedgEntry(CalcReservEntry: Record "Reservation Entry"; var CalcItemLedgEntry: Record "Item Ledger Entry"; var InvSearch: Text[1]; var IsHandled: Boolean; var IsFound: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAutoReserveOnBeforeStopReservation(var CalcReservEntry: Record "Reservation Entry"; var FullAutoReservation: Boolean; var AvailabilityDate: Date; var MaxQtyToReserve: Decimal; var MaxQtyToReserveBase: Decimal; var StopReservation: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAutoReserveOnBeforeSetValueArray(var ValueArrayNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAutoReserveOneLineOnAfterUpdateSearchNextStep(var Item: Record Item; var Positive: Boolean; var Search: Text[1]; var NextStep: Integer; var InvSearch: Text[1]; InvNextStep: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAutoReserveItemLedgEntryOnFindNextItemLedgEntry(CalcReservEntry: Record "Reservation Entry"; var CalcItemLedgEntry: Record "Item Ledger Entry"; var InvSearch: Text[1]; var IsHandled: Boolean; var IsFound: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetSourceForSalesLine(var CalcReservEntry: Record "Reservation Entry"; SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserve(var CalcReservEntry: Record "Reservation Entry"; var FullAutoReservation: Boolean; var Description: Text[100]; var AvailabilityDate: Date; var MaxQtyToReserve: Decimal; var MaxQtyToReserveBase: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserveItemLedgEntry(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReservePurchLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; var Search: Text[1]; var NextStep: Integer; CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserveSalesLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; Search: Text[1]; NextStep: Integer; CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserveProdOrderLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; Search: Text[1]; NextStep: Integer; CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserveProdOrderComp(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; Search: Text[1]; NextStep: Integer; CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserveAssemblyHeader(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; Search: Text[1]; NextStep: Integer; CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserveAssemblyLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; Search: Text[1]; NextStep: Integer; CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserveTransLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; var Search: Text[1]; var NextStep: Integer; CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserveServLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; Search: Text[1]; NextStep: Integer; CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAutoReserveJobPlanningLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; Search: Text[1]; NextStep: Integer; CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcAvailAllocQuantities(
        Item: Record Item; WhseActivLine: Record "Warehouse Activity Line";
        QtyOnOutboundBins: Decimal; QtyOnInvtMovement: Decimal; QtyOnSpecialBins: Decimal;
        var AvailQty: Decimal; var AllocQty: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateReservation(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry"; var ItemLedgEntry: Record "Item Ledger Entry")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeDeleteItemTrackingConfirm(var CalcReservEntry2: Record "Reservation Entry"; var IsHandled: Boolean; var Result: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteReservEntries(var ReservationEntry: Record "Reservation Entry"; var DownToQuantity: Decimal; CalcReservEntry: Record "Reservation Entry"; var CalcReservEntry2: Record "Reservation Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindUnfinishedSpecialOrderSalesNo(ItemLedgerEntry: Record "Item Ledger Entry"; var Result: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupDocument(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateItemLedgEntryStats(var CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateReservation(var SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalculateRemainingQty(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; var RemainingQty: Decimal; var RemainingQtyBase: Decimal);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcReservedQtyOnPickOnBeforeSetItemVariantCodeFilter(var Item: Record Item; var ReservationEntry: Record "Reservation Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcReservedQtyOnPickOnBeforeSetWhseActivLineVariantCodeFilter(var WnseActivLine: Record "Warehouse Activity Line"; var ReservationEntry: Record "Reservation Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnClearSurplusOnAfterReservEntry2SetFilters(var ReservationEntry: Record "Reservation Entry"; ItemTrackingHandling: Option "None","Allow deletion",Match)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateReservation(SourceRecRef: RecordRef; TrackingSpecification: Record "Tracking Specification"; ForReservEntry: Record "Reservation Entry"; Description: Text[100]; ExpectedDate: Date; Quantity: Decimal; QuantityBase: Decimal);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetDocumentReservationDeleteQstOnElseCase(RecRef: RecordRef; FldRef: FieldRef; DocType: Integer; var DocTypeCaption: Text; var IsHandled: Boolean)
    begin
    end;

#if not CLEAN17
    [Obsolete('Not used.', '17.0')]
    [IntegrationEvent(false, false)]
    local procedure OnDeleteDeleteDocumentReservationOnSetDocTypeCaptionElse(RecRef: RecordRef; FldRef: FieldRef; DocType: Integer; DocTypeCaption: Text)
    begin
    end;
#endif

    [IntegrationEvent(false, false)]
    local procedure OnDeleteReservEntriesOnAfterReservEntrySetFilters(var ReservEntry: Record "Reservation Entry"; var ItemTrackingHandling: Option "None","Allow deletion",Match)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetSourceRecordValue(var ReservEntry: Record "Reservation Entry"; SetAsCurrent: Boolean; ReturnOption: Option "Net Qty. (Base)","Gross Qty. (Base)"; var ReturnQty: Decimal; var SourceRecRef: RecordRef; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFilterReservFor(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; Direction: Integer; var CaptionText: Text);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertReservationEntriesOnBeforeCreateReservation(var TrackingSpecification: Record "Tracking Specification"; var CalcReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupDocument(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupLine(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetAssemblyHeaderOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; AssemblyHeader: Record "Assembly Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetAssemblyLineOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; AssemblyLine: Record "Assembly Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetItemJnlLineOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetItemLedgEntryOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetJobPlanningLineOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; JobPlanningLine: Record "Job Planning Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetJobJnlLineOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; JobJnlLine: Record "Job Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetSalesLineOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetPlanningCompOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; PlanningComponent: Record "Planning Component")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetProdOrderLineOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; ProdOrderLine: Record "Prod. Order Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetProdOrderCompOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; ProdOrderComp: Record "Prod. Order Component")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetPurchLineOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; PurchLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetReservSource(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; Direction: Enum "Transfer Direction")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetReqLineOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; ReqLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetServLineOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; ServiceLine: Record "Service Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetServLineEDMSOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetTransLineOnBeforeUpdateReservation(var ReservEntry: Record "Reservation Entry"; TransferLine: Record "Transfer Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateItemLedgEntryStatsUpdateTotals(CalcReservEntry: Record "Reservation Entry"; var CalcItemLedgEntry: Record "Item Ledger Entry"; TotalAvailQty: Decimal; QtyOnOutBound: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateItemTrackingLineStatsOnBeforeReservEntrySummaryInsert(var ReservEntrySummary: Record "Entry Summary"; ReservationEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateStatistics(CalcReservEntry: Record "Reservation Entry"; var ReservSummEntry: Record "Entry Summary"; AvailabilityDate: Date; Positive: Boolean; var TotalQuantity: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcReservedQtyOnPick(var Item: Record Item; var WhseActivLine: Record "Warehouse Activity Line"; var CalcReservEntry: Record "Reservation Entry"; var AvailQty: Decimal; var AllocQty: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCallCalcReservedQtyOnPick(CalcReservEntry: Record "Reservation Entry"; Positive: Boolean; var ShouldCalsReservedQtyOnPick: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckQuantityIsCompletelyReleased(ItemTrackingHandling: Option "None","Allow deletion",Match; QtyToRelease: Decimal; DeleteAll: Boolean; CurrentItemTrackingSetup: Record "Item Tracking Setup"; ReservEntry: Record "Reservation Entry"; var IsHandled: boolean)
    begin
    end;


    procedure SetServiceReservLoc(TransfFromLoc: Code[20])
    begin
        //EDMS function
        ServSpecEDMS := true;
        ServSpecLoc := TransfFromLoc;
    end;


    procedure SetServiceReserv(DocumentType: Integer; DocumentNo: Code[20])
    begin
        //EDMS function
        ServSpecEDMS := true;
        ServSpecDocType := DocumentType;
        ServSpecDocNo := DocumentNo;
    end;


    procedure GetServiceReserv(var IsSpecReserv: Boolean; var DocumentType: Integer; var DocumentNo: Code[20])
    begin
        //EDMS function
        IsSpecReserv := ServSpecEDMS;
        DocumentType := ServSpecDocType;
        DocumentNo := ServSpecDocNo;
    end;


    procedure SetSpecSummEntryNo(SummEntryNo: Integer)
    begin
        SpecSummEntryNo := SummEntryNo;
    end;


    procedure CancelServLineRresILE(var ServiceLine: Record "Service Line EDMS")
    var
        ResEntry: Record "Reservation Entry";
        ResEntry2: Record "Reservation Entry";
    begin
        //EDMS function
        ServiceLine.FilterTransferedResEntries(ResEntry);
        if ResEntry.FindFirst then
            repeat
                ResEntry2.SetRange("Entry No.", ResEntry."Entry No.");
                ResEntry2.FindFirst;
                repeat
                    ResEntry2.Mark(true);
                until ResEntry2.Next = 0;
            until ResEntry.Next = 0;

        ResEntry2.MarkedOnly(true);
        ResEntry2.SetRange("Entry No.");
        ResEntry2.DeleteAll;
    end;


    procedure CreateTrackingSpecification(var TrackingSpecification: Record "Tracking Specification"; FromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal"; FromSubtype: Integer; FromID: Code[20]; FromBatchName: Code[10]; FromProdOrderLine: Integer; FromRefNo: Integer; FromVariantCode: Code[10]; FromLocationCode: Code[10]; FromSerialNo: Code[20]; FromLotNo: Code[20]; FromQtyPerUOM: Decimal)
    begin
        TrackingSpecification."Source Type" := FromType;
        TrackingSpecification."Source Subtype" := FromSubtype;
        TrackingSpecification."Source ID" := FromID;
        TrackingSpecification."Source Batch Name" := FromBatchName;
        TrackingSpecification."Source Prod. Order Line" := FromProdOrderLine;
        TrackingSpecification."Source Ref. No." := FromRefNo;
        TrackingSpecification."Variant Code" := FromVariantCode;
        TrackingSpecification."Location Code" := FromLocationCode;
        TrackingSpecification."Serial No." := FromSerialNo;
        TrackingSpecification."Lot No." := FromLotNo;
        TrackingSpecification."Qty. per Unit of Measure" := FromQtyPerUOM;
    end;


    procedure SetPointerFilter(var ReservEntry: Record "Reservation Entry")
    begin
        ReservEntry.SetCurrentkey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Reservation Status",
          "Shipment Date", "Expected Receipt Date");
        ReservEntry.SetRange("Source ID", ReservEntry."Source ID");
        ReservEntry.SetRange("Source Ref. No.", ReservEntry."Source Ref. No.");
        ReservEntry.SetRange("Source Type", ReservEntry."Source Type");
        ReservEntry.SetRange("Source Subtype", ReservEntry."Source Subtype");
        ReservEntry.SetRange("Source Batch Name", ReservEntry."Source Batch Name");
        ReservEntry.SetRange("Source Prod. Order Line", ReservEntry."Source Prod. Order Line");
    end;

    local procedure InitFilterEDMS(EntryID: Integer; AvailabilityDate: Date)
    begin
        CalcServiceLineEDMS.RESET;
        CalcServiceLineEDMS.SETCURRENTKEY(
          Type, "No.", "Variant Code", "Location Code");
        IF EntryID = 230 THEN
            CalcServiceLineEDMS.SETRANGE("Document Type", CalcServiceLineEDMS."Document Type"::"Return Order")
        ELSE
            CalcServiceLineEDMS.SETRANGE("Document Type", CalcServiceLineEDMS."Document Type"::Order);
        CalcServiceLineEDMS.SETRANGE(Type, CalcServiceLineEDMS.Type::Item);
        CalcServiceLineEDMS.SETRANGE("No.", CalcReservEntry."Item No.");
        CalcServiceLineEDMS.SETRANGE("Variant Code", CalcReservEntry."Variant Code");
        CalcServiceLineEDMS.SETRANGE("Location Code", CalcReservEntry."Location Code");
        CalcServiceLineEDMS.SETFILTER("Planned Service Date", GetAvailabilityFilter(AvailabilityDate));

        IF ServSpecLoc <> '' THEN
            CalcServiceLineEDMS.SETRANGE("Transfer From Location Code", ServSpecLoc);

        IF EntryID = 230 THEN
            IF Positive THEN
                CalcServiceLineEDMS.SETFILTER("Quantity (Base)", '>0')
            ELSE
                CalcServiceLineEDMS.SETFILTER("Quantity (Base)", '<0')
        ELSE
            IF Positive THEN
                CalcServiceLineEDMS.SETFILTER("Quantity (Base)", '<0')
            ELSE
                CalcServiceLineEDMS.SETFILTER("Quantity (Base)", '>0');

        CalcServiceLineEDMS.SETRANGE("Job No.", ' ');

        IF ServSpecEDMS AND (CalcReservEntry."Source Type" <> DATABASE::"Service Line EDMS") THEN BEGIN
            CalcServiceLineEDMS.SETRANGE("Document Type", ServSpecDocType);
            CalcServiceLineEDMS.SETRANGE("Document No.", ServSpecDocNo);
        END;
    end;

    local procedure CallCreateReservation(var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; ReservQty: Decimal; Description: Text[100]; ExpectedDate: Date; QtyThisLine: Decimal; QtyThisLineBase: Decimal; TrackingSpecification: Record "Tracking Specification") ReservationCreated: Boolean
    begin
        if QtyThisLineBase = 0 then
            exit;
        if Abs(QtyThisLineBase - ReservQty) > 0 then begin
            if Abs(QtyThisLineBase - ReservQty) > Abs(RemainingQtyToReserveBase) then begin
                QtyThisLine := RemainingQtyToReserve;
                QtyThisLineBase := RemainingQtyToReserveBase;
            end else begin
                QtyThisLineBase := QtyThisLineBase - ReservQty;
                QtyThisLine := Round(RemainingQtyToReserve / RemainingQtyToReserveBase * QtyThisLineBase, UOMMgt.QtyRndPrecision);
            end;
            CopySign(RemainingQtyToReserveBase, QtyThisLineBase);
            CopySign(RemainingQtyToReserve, QtyThisLine);
            CreateReservation(Description, ExpectedDate, QtyThisLine, QtyThisLineBase, TrackingSpecification);
            RemainingQtyToReserve := RemainingQtyToReserve - QtyThisLine;
            RemainingQtyToReserveBase := RemainingQtyToReserveBase - QtyThisLineBase;
            ReservationCreated := true;
        end;
    end;

    procedure GetReservForEntryNo(DocumentNo: Code[20]; LineNo: Integer; TableNo: Integer; DocumentType: Integer; DerivedFromLineNo: Integer; JournalBatchName: Code[10]): Integer
    var
        ResEntryPositive: Record "Reservation Entry";
        ResEntryNegative: Record "Reservation Entry";
        TransferLine: Record "Transfer Line";
    begin
        ResEntryPositive.Reset;
        ResEntryPositive.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryPositive.SetRange("Source ID", DocumentNo);
        ResEntryPositive.SetRange("Source Ref. No.", LineNo);
        ResEntryPositive.SetRange("Source Type", TableNo);
        ResEntryPositive.SetRange("Source Subtype", DocumentType);
        ResEntryPositive.SetRange("Source Prod. Order Line", DerivedFromLineNo);
        ResEntryPositive.SetRange("Reservation Status", ResEntryPositive."reservation status"::Reservation);
        if JournalBatchName <> '' then
            ResEntryPositive.SetRange("Source Batch Name", JournalBatchName);
        if ResEntryPositive.FindFirst then
            repeat
                if ResEntryNegative.Get(ResEntryPositive."Entry No.", not ResEntryPositive.Positive) then begin
                    case ResEntryNegative."Source Type" of
                        Database::"Sales Line":
                            exit(ResEntryNegative."Entry No.");

                        Database::"Service Line EDMS":
                            exit(ResEntryNegative."Entry No.");

                        Database::"Transfer Line":
                            begin
                                if TransferLine.Get(ResEntryNegative."Source ID", ResEntryNegative."Source Ref. No.") then;
                                exit(GetReservForEntryNo(TransferLine."Document No.", TransferLine."Line No.", Database::"Transfer Line",
                                     1, TransferLine."Derived From Line No.", ''));
                            end;
                    end;
                end;
            until ResEntryPositive.Next = 0;
    end;

    procedure CreateForText2(ReservEntry: Record "Reservation Entry"): Text[80]
    begin
        if ReservEntry.Get(ReservEntry."Entry No.", false) then
            exit(CreateText2(ReservEntry));

        exit('');
    end;

    procedure CreateText2(ReservEntry: Record "Reservation Entry"): Text[80]
    var
        SourceType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry","Prod. Order Line","Prod. Order Component","Planning Line","Planning Component",Transfer,Service,"Job Journal",Job,"Assembly Header","Assembly Line";
        SourceTypeText: label 'Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service,Job Journal,Job,Assembly Header,Assembly Line';
        CalcAsmHeader: Record "Assembly Header";
        CalcAsmLine: Record "Assembly Line";
        DummyItemJnlLine: Record "Item Journal Line";
        DummyProdOrderLine: Record "Prod. Order Line";
        DummyJobJnlLine: Record "Job Journal Line";
        Text005: Label 'Outbound,Inbound';
    begin
        case ReservEntry."Source Type" of
            Database::"Sales Line":
                exit(ReservEntry."Source ID");
            Database::"Purchase Line":
                exit(ReservEntry."Source ID");
            Database::"Requisition Line":
                begin
                    SourceType := Sourcetype::"Requisition Line";
                    exit(StrSubstNo('%1 %2 %3', SelectStr(SourceType, SourceTypeText),
                        ReservEntry."Source ID", ReservEntry."Source Batch Name"));
                end;
            Database::"Planning Component":
                begin
                    SourceType := Sourcetype::"Planning Component";
                    exit(StrSubstNo('%1 %2 %3', SelectStr(SourceType, SourceTypeText),
                        ReservEntry."Source ID", ReservEntry."Source Batch Name"));
                end;
            Database::"Item Journal Line":
                begin
                    SourceType := Sourcetype::"Item Journal";
                    DummyItemJnlLine."Entry Type" := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2 %3 %4', SelectStr(SourceType, SourceTypeText),
                        DummyItemJnlLine."Entry Type", ReservEntry."Source ID", ReservEntry."Source Batch Name"));
                end;
            Database::"Job Journal Line":
                begin
                    SourceType := Sourcetype::"Job Journal";
                    exit(StrSubstNo('%1 %2 %3 %4', SelectStr(SourceType, SourceTypeText),
                        DummyJobJnlLine."Entry Type", ReservEntry."Source ID", ReservEntry."Source Batch Name"));
                end;
            Database::"Item Ledger Entry":
                begin
                    SourceType := Sourcetype::"Item Ledger Entry";
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText), ReservEntry."Source Ref. No."));
                end;
            Database::"Prod. Order Line":
                begin
                    SourceType := Sourcetype::"Prod. Order Line";
                    DummyProdOrderLine.Status := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2 %3', SelectStr(SourceType, SourceTypeText),
                        DummyProdOrderLine.Status, ReservEntry."Source ID"));
                end;
            Database::"Prod. Order Component":
                begin
                    SourceType := Sourcetype::"Prod. Order Component";
                    DummyProdOrderLine.Status := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2 %3', SelectStr(SourceType, SourceTypeText),
                        DummyProdOrderLine.Status, ReservEntry."Source ID"));
                end;
            Database::"Transfer Line":
                begin
                    SourceType := Sourcetype::Transfer;
                    exit(StrSubstNo('%1 %2, %3', SelectStr(SourceType, SourceTypeText),
                        ReservEntry."Source ID", SelectStr(ReservEntry."Source Subtype" + 1, Text005)));
                end;
            Database::"Service Line":
                begin
                    SourceType := Sourcetype::Service;
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText), ReservEntry."Source ID"));
                end;
            Database::"Job Planning Line":
                begin
                    SourceType := Sourcetype::Job;
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText), ReservEntry."Source ID"));
                end;
            Database::"Assembly Header":
                begin
                    CalcAsmHeader.Init;
                    SourceType := Sourcetype::"Assembly Header";
                    CalcAsmHeader."Document Type" := ReservEntry."Source Subtype";
                    exit(
                      StrSubstNo('%1 %2 %3', SelectStr(SourceType, SourceTypeText),
                        CalcAsmHeader."Document Type", ReservEntry."Source ID"));
                end;
            Database::"Assembly Line":
                begin
                    CalcAsmLine.Init;
                    SourceType := Sourcetype::"Assembly Line";
                    CalcAsmLine."Document Type" := ReservEntry."Source Subtype";
                    exit(
                      StrSubstNo('%1 %2 %3', SelectStr(SourceType, SourceTypeText),
                        CalcAsmLine."Document Type", ReservEntry."Source ID"));
                end;
            Database::"Service Line EDMS":
                exit(ReservEntry."Source ID");

        end;

        exit('');
    end;

    var
        Text005: label 'Purchase Line No. %1 quantity is reserved! Do you wish to update reservation data?';
        Text006: label 'Item No. %1 must not be changed when a quantity is reserved to Item Legder Entry!';

    procedure UpdateReservAfterItemNoChange(var NewPurchLine: Record "Purchase Line"; var OldPurchLine: Record "Purchase Line"; var TempReservEntry: Record "Reservation Entry" temporary)
    var
        PurchLine: Record "Purchase Line";
        ResEntryNegative: Record "Reservation Entry";
        ResEntryPositive: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        TransfLine: Record "Transfer Line";
        ReservEntryTemp: Integer;
        TempResEntryNegative: Record "Reservation Entry";
        TempResEntryPositive: Record "Reservation Entry";
        PurchLineReserve: codeunit "Purch. Line-Reserve";
    begin
        if (NewPurchLine.Type <> NewPurchLine.Type::Item) and (OldPurchLine.Type <> OldPurchLine.Type::Item) then
            exit;
        /* if Blocked then
           exit;*/
        if NewPurchLine."Line No." = 0 then
            if not PurchLine.Get(
                 NewPurchLine."Document Type",
                 NewPurchLine."Document No.",
                 NewPurchLine."Line No.")
            then
                exit;

        if Confirm(Text005, false, OldPurchLine."Line No.") then
            FindNextReservEntry(NewPurchLine, OldPurchLine, TempReservEntry, OldPurchLine."Document No.", OldPurchLine."Line No.", Database::"Purchase Line",
                                OldPurchLine."Document Type".AsInteger(), 0);
    end;

    procedure FindNextReservEntry(var NewPurchLine: Record "Purchase Line"; var OldPurchLine: Record "Purchase Line"; var TempReservEntry: Record "Reservation Entry" temporary; DocumentNo: Code[20]; LineNo: Integer; TableNo: Integer; DocumentType: Integer; DerivedFromLineNo: Integer)
    var
        ResEntryNegative: Record "Reservation Entry";
        ResEntryPositive: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        TransfLine: Record "Transfer Line";
        ServiceLine: Record "Service Line EDMS";
        ServiceHeader: Record "Service Header EDMS";
        SalesHeader: Record "Sales Header";
        ReleaseServiceDoc: Codeunit "Release Service Document EDMS";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        ResEntryPositive.LockTable;
        ResEntryPositive.Reset;
        ResEntryPositive.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryPositive.SetRange("Source ID", DocumentNo);
        ResEntryPositive.SetRange("Source Ref. No.", LineNo);
        ResEntryPositive.SetRange("Source Type", TableNo);
        ResEntryPositive.SetRange("Source Subtype", DocumentType);
        ResEntryPositive.SetRange("Source Prod. Order Line", DerivedFromLineNo);
        ResEntryPositive.SetRange("Reservation Status", ResEntryPositive."reservation status"::Reservation);
        if ResEntryPositive.FindFirst then
            repeat
                if ResEntryNegative.Get(ResEntryPositive."Entry No.", not ResEntryPositive.Positive) then begin
                    case ResEntryNegative."Source Type" of
                        Database::"Item Ledger Entry":
                            begin
                                Error(Text006, NewPurchLine."No.");
                                exit;
                            end;
                        Database::"Sales Line":
                            begin
                                if SalesLine.Get(ResEntryNegative."Source Subtype", ResEntryNegative."Source ID", ResEntryNegative."Source Ref. No.") then begin
                                    InsertTempReservEntry(ResEntryPositive, ResEntryNegative, TempReservEntry);
                                    SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                                    if SalesHeader.Status = SalesHeader.Status::Released then
                                        ReleaseSalesDoc.Reopen(SalesHeader);
                                    SalesLine.Validate("No.", NewPurchLine."No.");
                                    SalesLine.Modify(true);
                                end;
                                exit;
                            end;
                        Database::"Service Line EDMS":
                            begin
                                if ServiceLine.Get(ResEntryNegative."Source Subtype", ResEntryNegative."Source ID", ResEntryNegative."Source Ref. No.") then begin
                                    InsertTempReservEntry(ResEntryPositive, ResEntryNegative, TempReservEntry);
                                    ServiceHeader.Get(ServiceLine."Document Type", ServiceLine."Document No.");
                                    if ServiceHeader.Status = ServiceHeader.Status::Released then begin
                                        ReleaseServiceDoc.Reopen(ServiceHeader);
                                        ServiceLine.Get(ResEntryNegative."Source Subtype", ResEntryNegative."Source ID", ResEntryNegative."Source Ref. No.");
                                    end;
                                    ServiceLine.Validate("No.", NewPurchLine."No.");
                                    ServiceLine.Validate(Quantity, OldPurchLine.Quantity);
                                    ServiceLine.Modify(true);
                                end;
                                exit;
                            end;
                        Database::"Transfer Line":
                            begin
                                if TransfLine.Get(ResEntryNegative."Source ID", ResEntryNegative."Source Ref. No.") then begin
                                    InsertTempReservEntry(ResEntryPositive, ResEntryNegative, TempReservEntry);
                                    FindNextReservEntry(NewPurchLine, OldPurchLine, TempReservEntry, TransfLine."Document No.", TransfLine."Line No.", Database::"Transfer Line",
                                                        1, TransfLine."Derived From Line No.");

                                    TransfLine.Validate("Item No.", NewPurchLine."No.");
                                    TransfLine.Modify(true);
                                end;
                            end;
                    end;
                end;
            until ResEntryPositive.Next = 0;
    end;

    procedure InsertTempReservEntry(var ResEntryPositive: Record "Reservation Entry"; var ResEntryNegative: Record "Reservation Entry"; var TempReservEntry: Record "Reservation Entry" temporary)
    begin
        TempReservEntry.Init;
        TempReservEntry := ResEntryPositive;
        TempReservEntry.Insert;

        TempReservEntry.Init;
        TempReservEntry := ResEntryNegative;
        TempReservEntry.Insert;

        ResEntryPositive.Delete;
        ResEntryNegative.Delete;
    end;

    procedure CopyReservEntryFromTemp(NewPurchLine: Record "Purchase Line"; var TempReservEntry: Record "Reservation Entry" temporary)
    var
        ReservEntry: Record "Reservation Entry";
    begin
        TempReservEntry.Reset;
        if TempReservEntry.FindFirst then
            repeat
                ReservEntry.Init;
                ReservEntry := TempReservEntry;
                ReservEntry."Item No." := NewPurchLine."No.";
                ReservEntry."Item No. Changed" := true;
                ReservEntry.Insert;
            until TempReservEntry.Next = 0;
    end;

    //>>ADDED FOR 99000831 "Reservation Engine Mgt."
    procedure GetReservInfoForFactBox(ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType,Model,Make,Location; DocumentNo: Code[20]; LineNo: Integer; TableNo: Integer; DocumentType: Integer; DerivedFromLineNo: Integer; JournalBatchName: Code[10]): Text[50]
    var
        ResEntryPositive: Record "Reservation Entry";
        ResEntryNegative: Record "Reservation Entry";
        ServiceHeader: Record "Service Header EDMS";
        SalesHeader: Record "Sales Header";
        TransferLine: Record "Transfer Line";
        SalesLine: Record "Sales Line";
        ServiceLine: Record "Service Line EDMS";
    begin
        ResEntryPositive.Reset;
        ResEntryPositive.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryPositive.SetRange("Source ID", DocumentNo);
        ResEntryPositive.SetRange("Source Ref. No.", LineNo);
        ResEntryPositive.SetRange("Source Type", TableNo);
        ResEntryPositive.SetRange("Source Subtype", DocumentType);
        ResEntryPositive.SetRange("Source Prod. Order Line", DerivedFromLineNo);
        ResEntryPositive.SetRange("Reservation Status", ResEntryPositive."reservation status"::Reservation);
        if JournalBatchName <> '' then
            ResEntryPositive.SetRange("Source Batch Name", JournalBatchName);
        if ResEntryPositive.FindFirst then
            repeat
                if ResEntryNegative.Get(ResEntryPositive."Entry No.", not ResEntryPositive.Positive) then begin
                    case ResEntryNegative."Source Type" of
                        Database::"Sales Line":
                            begin
                                if SalesHeader.Get(ResEntryNegative."Source Subtype", ResEntryNegative."Source ID") then begin
                                    case ReturnValue of
                                        Returnvalue::CustomerNo:
                                            exit(SalesHeader."Sell-to Customer No.");
                                        Returnvalue::VIN:
                                            begin
                                                //SalesHeader.CALCFIELDS(VIN);  //09.06.2014 Elva Baltic P8 #F0002 EDMS7.10
                                                exit(SalesHeader.VIN);
                                            end;
                                        // 28.08.2018 EB.P30 EDMS >>
                                        Returnvalue::Make:
                                            exit(SalesHeader."Make Code");
                                        Returnvalue::Model:
                                            exit(SalesHeader."Model Code");
                                        // 28.08.2018 EB.P30 EDMS <<
                                        // 15.11.2019 EB.P7 EDMS >>
                                        Returnvalue::Location:
                                            exit(SalesHeader."Location Code");
                                        // 15.11.2019 EB.P7 EDMS <<
                                        Returnvalue::DealType:
                                            exit(SalesHeader."Deal Type Code");
                                        Returnvalue::CustomerName:
                                            exit(copystr(SalesHeader."Sell-to Customer Name", 1, 50));
                                        Returnvalue::OrderingPriceType:
                                            begin
                                                if SalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", ResEntryNegative."Source Ref. No.") then
                                                    exit(SalesLine."Ordering Price Type Code");
                                            end;
                                    end;
                                end;
                            end;

                        Database::"Service Line EDMS":
                            begin
                                if ServiceHeader.Get(ResEntryNegative."Source Subtype", ResEntryNegative."Source ID") then
                                    case ReturnValue of
                                        Returnvalue::CustomerNo:
                                            exit(ServiceHeader."Sell-to Customer No.");
                                        Returnvalue::VIN:
                                            exit(ServiceHeader.VIN);
                                        // 28.08.2018 EB.P30 EDMS >>
                                        Returnvalue::Make:
                                            exit(ServiceHeader."Make Code");
                                        Returnvalue::Model:
                                            exit(ServiceHeader."Model Code");
                                        // 28.08.2018 EB.P30 EDMS <<
                                        // 15.11.2019 EB.P7 EDMS >>
                                        Returnvalue::Location:
                                            exit(ServiceHeader."Location Code");
                                        // 15.11.2019 EB.P7 EDMS <<
                                        Returnvalue::DealType:
                                            exit(ServiceHeader."Deal Type");
                                        Returnvalue::CustomerName:
                                            exit(ServiceHeader."Sell-to Customer Name");
                                        Returnvalue::OrderingPriceType:
                                            begin
                                                if ServiceLine.Get(ServiceHeader."Document Type", ServiceHeader."No.", ResEntryNegative."Source Ref. No.") then
                                                    exit(ServiceLine."Ordering Price Type Code");
                                            end;
                                    end;
                            end;

                        Database::"Transfer Line":
                            begin
                                if TransferLine.Get(ResEntryNegative."Source ID", ResEntryNegative."Source Ref. No.") then
                                    exit(GetReservInfoForFactBox(ReturnValue, TransferLine."Document No.", TransferLine."Line No.", Database::"Transfer Line",
                                         1, TransferLine."Derived From Line No.", ''));
                            end;
                    end;
                end;
            until ResEntryPositive.Next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnSetReservSource', '', false, false)]
    local procedure OnAfterSetReservSource(sender: Codeunit "Reservation Management"; SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; Direction: Enum "Transfer Direction");
    Var
        ServiceLineEDMS: Record "Service Line EDMS";
        TransferLine: Record "Transfer Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ServTransfMgt: Codeunit "Service Transfer Mgt.";
    begin
        If SourceRecRef.Number = Database::"Service Line EDMS" Then begin
            SourceRecRef.SetTable(ServiceLineEDMS);
            ServiceLineEDMS.SetReservationEntry(ReservEntry);
            // OnSetServLineEDMSOnBeforeUpdateReservation(ReservEntry, ServiceLineEDMS);
            sender.UpdateReservation((CreateReservEntry.SignFactor(ReservEntry) * ServiceLineEDMS."Outstanding Qty. (Base)") <= 0);
        end;
        IF SourceRecRef.Number = DATABASE::"Transfer Line" Then begin
            SourceRecRef.SetTable(TransferLine);
            TransferLine.SetReservationEntry(ReservEntry, Direction);
            //EDMS 21.07.08 >>
            if (Direction = Direction::Outbound) and (ServTransfMgt.IsServiceLocation(TransferLine."Transfer-from Code")) then begin
                if TransferLine."Source No." <> '' then
                    SetServiceReserv(TransferLine."Source Subtype",
                                              TransferLine."Source No.");
            end
            else begin
                if (Direction = Direction::Inbound) and (ServTransfMgt.IsServiceLocation(TransferLine."Transfer-to Code")) then begin
                    if TransferLine."Source No." <> '' then
                        SetServiceReserv(TransferLine."Source Subtype",
                                                  TransferLine."Source No.");
                end;
            end;
            //EDMS 21.07.08 <<
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnCalculateRemainingQty', '', false, false)]
    local procedure OnCalculateRemainingQtyTransfer(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; var RemainingQty: Decimal; var RemainingQtyBase: Decimal)
    var
        TransferLine: Record "Transfer Line";
    begin
        if ReservEntry."Source Type" = 5741 then begin
            SourceRecRef.SetTable(TransferLine);
            TransferLine.GetRemainingQty(RemainingQty, RemainingQtyBase, ReservEntry."Source Subtype");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnGetSourceRecordValue', '', false, false)]
    local procedure OnGetSourceRecordValueTransfer(var ReservEntry: Record "Reservation Entry"; ReturnOption: Option; var ReturnQty: Decimal; var SourceRecRef: RecordRef)
    begin
        if ReservEntry."Source Type" = 5741 then
            ReturnQty := GetSourceValue(ReservEntry, SourceRecRef, ReturnOption);
    end;

    procedure GetSourceValue(ReservEntry: Record "Reservation Entry"; var SourceRecRef: RecordRef; ReturnOption: Option "Net Qty. (Base)","Gross Qty. (Base)"): Decimal
    var
        TransLine: Record "Transfer Line";
    begin
        TransLine.Get(ReservEntry."Source ID", ReservEntry."Source Ref. No.");
        SourceRecRef.GetTable(TransLine);
        case ReturnOption of
            ReturnOption::"Net Qty. (Base)":
                exit(TransLine."Outstanding Qty. (Base)");
            ReturnOption::"Gross Qty. (Base)":
                exit(TransLine."Quantity (Base)");
        end;
    end;

    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnUpdateStatistics', '', false, false)]
        local procedure OnUpdateStatisticsTransfer(CalcReservEntry: Record "Reservation Entry"; var ReservSummEntry: Record "Entry Summary"; AvailabilityDate: Date; Positive: Boolean; var TotalQuantity: Decimal)
        var
            CalcSumValue: Decimal;
        begin
            if ReservSummEntry."Entry No." in [101, 102] then
                UpdateStatistics(
                    CalcReservEntry, ReservSummEntry, AvailabilityDate, ReservSummEntry."Entry No." - 101, Positive, TotalQuantity);
        end;*/

    procedure UpdateStatistics(CalcReservEntry: Record "Reservation Entry"; var TempEntrySummary: Record "Entry Summary" temporary; AvailabilityDate: Date; Direction: Option; Positive: Boolean; var TotalQuantity: Decimal)
    var
        TransLine: Record "Transfer Line";
        AvailabilityFilter: Text;
        Text006: label 'Item No. %1 must not be changed when a quantity is reserved to Item Legder Entry!';
    begin
        if not TransLine.ReadPermission then
            exit;

        AvailabilityFilter := CalcReservEntry.GetAvailabilityFilter(AvailabilityDate, Positive);
        case Direction of
            0: // Outbound
                TransLine.FilterOutboundLinesForReservation(CalcReservEntry, AvailabilityFilter, Positive);
            1: // Inbound
                TransLine.FilterInboundLinesForReservation(CalcReservEntry, AvailabilityFilter, Positive);
        end;
        if TransLine.FindSet then
            repeat
                case Direction of
                    0:
                        begin
                            TransLine.CalcFields("Reserved Qty. Outbnd. (Base)");
                            TempEntrySummary."Total Reserved Quantity" -= TransLine."Reserved Qty. Outbnd. (Base)";
                            TotalQuantity -= TransLine."Outstanding Qty. (Base)";
                        end;
                    1:
                        begin
                            TransLine.CalcFields("Reserved Qty. Inbnd. (Base)");
                            TempEntrySummary."Total Reserved Quantity" += TransLine."Reserved Qty. Inbnd. (Base)";
                            TotalQuantity += TransLine."Outstanding Qty. (Base)";
                        end;
                end;
            until TransLine.Next() = 0;

        if TotalQuantity = 0 then
            exit;

        if (TotalQuantity > 0) = Positive then begin
            TempEntrySummary."Table ID" := DATABASE::"Transfer Line";
            TempEntrySummary."Summary Type" :=
                CopyStr(
                StrSubstNo('%1, %2', TransLine.TableCaption, SelectStr(Direction + 1, Text006)),
                1, MaxStrLen(TempEntrySummary."Summary Type"));
            TempEntrySummary."Total Quantity" := TotalQuantity;
            TempEntrySummary."Total Available Quantity" := TempEntrySummary."Total Quantity" - TempEntrySummary."Total Reserved Quantity";
            if not TempEntrySummary.Insert() then
                TempEntrySummary.Modify;
        end;
    end;

    procedure UpdateServLineEDMSStats(var ReservEntrySummary: Record "Entry Summary"; AvailabilityDate: Date; i: Integer; var CalcSumValue: Decimal; CalcReservEntry: Record "Reservation Entry")
    begin
        if CalcServiceLineEDMS.ReadPermission
        then begin
            InitFilterEDMS(i, AvailabilityDate);
            if CalcServiceLineEDMS.FindSet then
                repeat
                    CalcServiceLineEDMS.CalcFields("Reserved Qty. (Base)");
                    ReservEntrySummary."Total Reserved Quantity" -= CalcServiceLineEDMS."Reserved Qty. (Base)";
                    CalcSumValue += CalcServiceLineEDMS."Outstanding Qty. (Base)";
                until CalcServiceLineEDMS.Next = 0;

            if CalcSumValue <> 0 then
                if (ReservationManagement.IsPositive() = (CalcSumValue < 0)) and (i <> 230) or
                   (ReservationManagement.IsPositive() = (CalcSumValue > 0)) and (i = 230)
                then begin
                    ReservEntrySummary."Table ID" := Database::"Service Line EDMS";
                    ReservEntrySummary."Summary Type" :=
                      CopyStr(
                        StrSubstNo('%1', CalcServiceLineEDMS.TableCaption),
                        1, MaxStrLen(ReservEntrySummary."Summary Type"));
                    if i = 230 then
                        ReservEntrySummary."Total Quantity" := CalcSumValue
                    else
                        ReservEntrySummary."Total Quantity" := -CalcSumValue;
                    ReservEntrySummary."Total Available Quantity" :=
                      ReservEntrySummary."Total Quantity" - ReservEntrySummary."Total Reserved Quantity";
                    if not ReservEntrySummary.Insert then
                        ReservEntrySummary.Modify;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnLookupDocument', '', false, false)]
    local procedure MyProcedure(SourceType: Integer; SourceID: Code[20])
    var
        TransHeader: Record "Transfer Header";
    begin
        if SourceType = 5741 then begin
            TransHeader.Reset();
            TransHeader.SetRange("No.", SourceID);
            PAGE.RunModal(PAGE::"Transfer Order", TransHeader);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnFilterReservFor', '', false, false)]
    local procedure OnFilterReservForTransfer(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; Direction: Integer; var CaptionText: Text)
    var
        TransferLine: Record "Transfer Line";
    begin
        if ReservEntry."Source Type" = 5741 then begin
            SourceRecRef.SetTable(TransferLine);
            TransferLine.SetReservationFilters(ReservEntry, "Transfer Direction".FromInteger(Direction));
            CaptionText := TransferLine.GetSourceCaption;
        end;
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnBeforeLookupDocument', '', false, false)]
    local procedure OnBeforeLookupDocumentSTD(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer; var IsHandled: Boolean);
    Var
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        ServiceHeaderEDMS: Record "Service Header EDMS";
    begin
        case SourceType of
            DATABASE::"Sales Line":
                begin
                    SalesHeader.Reset;
                    SalesHeader.SetRange("Document Type", SourceSubtype);
                    SalesHeader.SetRange("No.", SourceID);
                    if SalesHeader.FindFirst then;

                    case SalesHeader."Document Profile" of

                        //30.10.2012 EDMS >>

                        SalesHeader."document profile"::"Vehicles Trade":
                            begin
                                SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::"Vehicles Trade");
                                case SourceSubtype of
                                    0:
                                        Page.Run(Page::"Sales Quote", SalesHeader);
                                    1:
                                        Page.Run(Page::"Sales Order", SalesHeader);
                                    2:
                                        Page.Run(Page::"Sales Invoice", SalesHeader);
                                    3:
                                        Page.Run(Page::"Sales Credit Memo", SalesHeader);
                                end;
                            end;

                        //30.10.2012 EDMS <<

                        SalesHeader."document profile"::"Spare Parts Trade":
                            case SourceSubtype of
                                0:
                                    Page.Run(Page::"Sales Quote", SalesHeader);
                                1:
                                    Page.Run(Page::"Sales Order", SalesHeader);
                                2:
                                    Page.Run(Page::"Sales Invoice", SalesHeader);
                                3:
                                    Page.Run(Page::"Sales Credit Memo", SalesHeader);
                            end;

                        //30.10.2012 EDMS >>

                        SalesHeader."document profile"::Service:
                            begin
                                case SourceSubtype of
                                    0:
                                        Page.Run(Page::"Sales Quote", SalesHeader);
                                    1:
                                        Page.Run(Page::"Sales Order", SalesHeader);
                                    2:
                                        begin
                                            SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::Service);
                                            Page.Run(Page::"Sales Invoice", SalesHeader);
                                        end;
                                    3:
                                        begin
                                            SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::Service);
                                            Page.Run(Page::"Sales Credit Memo", SalesHeader);
                                        end;
                                end;
                            end;
                    end;
                end;
            DATABASE::"Purchase Line":
                begin
                    PurchHeader.Reset;
                    PurchHeader.SetRange("Document Type", SourceSubtype);
                    PurchHeader.SetRange("No.", SourceID);
                    if PurchHeader.FindFirst then;
                    case PurchHeader."Document Profile" of
                        PurchHeader."document profile"::"Spare Parts Trade":
                            case SourceSubtype of
                                0:
                                    Page.Run(Page::"Purchase Quote", PurchHeader);
                                1:
                                    Page.Run(Page::"Purchase Order", PurchHeader);
                                2:
                                    Page.Run(Page::"Purchase Invoice", PurchHeader);
                                3:
                                    Page.Run(Page::"Purchase Credit Memo", PurchHeader);
                            end;


                        //30.10.2012 EDMS >>

                        PurchHeader."document profile"::"Vehicles Trade":
                            begin
                                PurchHeader.SetRange("Document Profile", PurchHeader."document profile"::"Vehicles Trade");
                                case SourceSubtype of
                                    1:
                                        Page.Run(Page::"Purchase Quote", PurchHeader);
                                    2:
                                        Page.Run(Page::"Purchase Order", PurchHeader);
                                    3:
                                        Page.Run(Page::"Purchase Invoice", PurchHeader);
                                    4:
                                        Page.Run(Page::"Purchase Credit Memo", PurchHeader);
                                end;
                            end;
                        PurchHeader."document profile"::Service:
                            case SourceSubtype of
                                3:
                                    begin
                                        PurchHeader.SetRange("Document Profile", PurchHeader."document profile"::"Vehicles Trade");
                                        Page.Run(Page::"Purchase Invoice", PurchHeader);
                                    end;
                            end;

                    //30.10.2012 EDMS <<
                    end;
                end;
            Database::"Service Line EDMS": //08.07.08 EDMS P1
                begin
                    ServiceHeaderEDMS.Reset;
                    ServiceHeaderEDMS.SetRange("Document Type", SourceSubtype);
                    ServiceHeaderEDMS.SetRange("No.", SourceID);
                    if SourceSubtype = 0 then
                        Page.RunModal(Page::"Service Quote EDMS", ServiceHeaderEDMS)
                    else
                        Page.RunModal(Page::"Service Order EDMS", ServiceHeaderEDMS);
                end;

        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnAutoReserveOnBeforeStopReservation', '', false, false)]
    local procedure OnAutoReserveOnBeforeStopReservationSTD(var CalcReservEntry: Record "Reservation Entry"; var FullAutoReservation: Boolean; var AvailabilityDate: Date; var MaxQtyToReserve: Decimal; var MaxQtyToReserveBase: Decimal; var StopReservation: Boolean);
    begin
        //09.07.08 EDMS P1 - Added EDMS >>
        if CalcReservEntry."Source Type" in [Database::"Service Line EDMS"] then
            StopReservation := not (CalcReservEntry."Source Subtype" in [1, 2]); // Only order and return order
                                                                                 //09.07.08 EDMS P1 - Added EDMS <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnAfterAutoReserveOneLine', '', false, false)]
    local procedure OnAfterAutoReserveOneLineSTD(var Sender: Codeunit "Reservation Management"; ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; Search: Text[1]; NextStep: Integer; CalcReservEntry: Record "Reservation Entry"; CalcReservEntry2: Record "Reservation Entry"; Positive: Boolean);
    Var
        ReservSummaryType: Enum "Reservation Summary Type";
        QtyThisLine: Decimal;
        QtyThisLineBase: Decimal;
        ReservQty: Decimal;
        CallTrackingSpecification: Record "Tracking Specification";
    begin
        ReservSummaryType := "Reservation Summary Type".FromInteger(ReservSummEntryNo);
        case ReservSummaryType.AsInteger() of
            220, 230: // Service Line EDMS
                begin
                    InitFilterEDMS(ReservSummEntryNo, AvailabilityDate); //FIXME BC16 Upgrade
                    if CalcServiceLineEDMS.Find(Search) then
                        repeat
                            CalcServiceLineEDMS.CalcFields("Reserved Qty. (Base)");
                            QtyThisLineBase := CalcServiceLineEDMS."Outstanding Qty. (Base)";
                            QtyThisLine := CalcServiceLineEDMS."Outstanding Qty. (Base)";
                            if ReservSummEntryNo = 230 then // Return Order
                                ReservQty := -CalcServiceLineEDMS."Reserved Qty. (Base)"
                            else
                                ReservQty := CalcServiceLineEDMS."Reserved Qty. (Base)";
                            if (Positive = (QtyThisLine > 0)) and (ReservSummEntryNo <> 230) or
                              (Positive = (QtyThisLine < 0)) and (ReservSummEntryNo = 230)
                            then
                                QtyThisLine := 0;
                            if QtyThisLine <> 0 then begin
                                if Abs(QtyThisLine - ReservQty) > Abs(RemainingQtyToReserve) then
                                    QtyThisLine := RemainingQtyToReserve
                                else
                                    QtyThisLine := QtyThisLine - ReservQty;
                                Sender.CopySign(RemainingQtyToReserve, QtyThisLine);

                                //EDMS 12.25.2013 >>
                                CreateTrackingSpecification(CallTrackingSpecification,
                                  Database::"Service Line EDMS",
                                  CalcServiceLineEDMS."Document Type",
                                  CalcServiceLineEDMS."Document No.",
                                  '',
                                  0,
                                  CalcServiceLineEDMS."Line No.",
                                  CalcServiceLineEDMS."Variant Code",
                                  CalcServiceLineEDMS."Location Code",
                                  CalcReservEntry."Serial No.", CalcReservEntry."Lot No.",
                                  CalcServiceLineEDMS."Qty. per Unit of Measure");
                                //EDMS 12.25.2013 <<

                                CallCreateReservation(RemainingQtyToReserve, RemainingQtyToReserveBase, ReservQty,
                                  Description, 0D, QtyThisLine, QtyThisLineBase, CallTrackingSpecification, Sender);

                            end;
                        until (CalcServiceLineEDMS.Next(NextStep) = 0) or (RemainingQtyToReserve = 0);
                end;
        end;
    End;

    procedure CallCreateReservation(var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; ReservQty: Decimal; Description: Text[100]; ExpectedDate: Date; QtyThisLine: Decimal; QtyThisLineBase: Decimal; TrackingSpecification: Record "Tracking Specification"; var Sender: Codeunit "Reservation Management") ReservationCreated: Boolean
    Var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        if QtyThisLineBase = 0 then
            exit;
        if Abs(QtyThisLineBase - ReservQty) > 0 then begin
            if Abs(QtyThisLineBase - ReservQty) > Abs(RemainingQtyToReserveBase) then begin
                QtyThisLine := RemainingQtyToReserve;
                QtyThisLineBase := RemainingQtyToReserveBase;
            end else begin
                QtyThisLineBase := QtyThisLineBase - ReservQty;
                QtyThisLine := Round(RemainingQtyToReserve / RemainingQtyToReserveBase * QtyThisLineBase, UOMMgt.QtyRndPrecision);
            end;
            Sender.CopySign(RemainingQtyToReserveBase, QtyThisLineBase);
            Sender.CopySign(RemainingQtyToReserve, QtyThisLine);
            Sender.CreateReservation(Description, ExpectedDate, QtyThisLine, QtyThisLineBase, TrackingSpecification);
            RemainingQtyToReserve := RemainingQtyToReserve - QtyThisLine;
            RemainingQtyToReserveBase := RemainingQtyToReserveBase - QtyThisLineBase;
            ReservationCreated := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnAfterSetValueArray', '', false, false)]
    local procedure OnAfterSetValueArraySTD(EntryStatus: Option; var ValueArray: array[30] of Integer; var ArrayCounter: Integer);
    begin
        case EntryStatus of
            0:
                begin // Reservation
                    //23.07.08 EDMS P1 >>
                    if SpecSummEntryNo <> 0 then begin
                        ValueArray[1] := SpecSummEntryNo;
                        ArrayCounter := 1
                    end
                    //23.07.08 EDMS P1 <<
                    else begin
                        ValueArray[18] := 220; //18.07.2008 EDMS P1
                        ValueArray[19] := 230; //18.07.2008 EDMS P1		    
                        ArrayCounter := 19; //18.10.2012 EDMS P1 - changed to 19
                    end;
                end;
            1:
                begin
                    ValueArray[21] := 220; //18.07.2008 EDMS P1
                    ValueArray[22] := 230; //18.07.2008 EDMS P1		    
                    ArrayCounter := 22; //18.10.2012 EDMS P1 - changed to 22
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnLookupLine', '', false, false)]
    local procedure OnLookupLineSTD(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer);
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        case SourceType of
            Database::"Service Line EDMS": //08.07.08 EDMS P1
                begin
                    ServiceLineEDMS.Reset;
                    ServiceLineEDMS.SetRange("Document Type", SourceSubtype);
                    ServiceLineEDMS.SetRange("Document No.", SourceID);
                    ServiceLineEDMS.SetRange("Line No.", SourceRefNo);
                    Page.Run(0, ServiceLineEDMS);
                end;

        end;
    END;




}

