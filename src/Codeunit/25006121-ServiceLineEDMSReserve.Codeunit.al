Codeunit 25006121 "Service Line EDMS-Reserve"
{
    // 11.07.2013 EDMS P8
    //   * partial reserve fix
    // 
    // 08.07.08 EDMS P1 - EDMS Service Management integration

    Permissions = TableData "Reservation Entry" = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Codeunit is not initialized correctly.';
        Text001: label 'Reserved quantity cannot be greater than %1';
        Text002: label 'must be filled in when a quantity is reserved';
        Text003: label 'must not be changed when a quantity is reserved';
        Location: Record Location;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        //ReservMgt: Codeunit "Reservation Management";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        SetFromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry";
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
        Text004: label 'must not be filled in when a quantity is reserved';
        OverruleItemTracking: Boolean;
        FromTrackingSpecification: Record "Tracking Specification";
        CodeunitInitErr: Label 'Codeunit is not initialized correctly.';
        ReservedQtyTooLargeErr: Label 'Reserved quantity cannot be greater than %1.', Comment = '%1: not reserved quantity on Sales Line';

    procedure CreateReservation(ServiceLineEDMS: Record "Service Line EDMS"; Description: Text[100]; ExpectedReceiptDate: Date; Quantity: Decimal; QuantityBase: Decimal; ForReservEntry: Record "Reservation Entry")
    var
        ShipmentDate: Date;
        SignFactor: Integer;
        IsHandled: Boolean;
    begin
        //if FromTrackingSpecification."Source Type" = 0 then
        //    Error(CodeunitInitErr);

        ServiceLineEDMS.TestField(Type, ServiceLineEDMS.Type::Item);
        ServiceLineEDMS.TestField("No.");
        ServiceLineEDMS.TestField("Planned Service Date");

        ServiceLineEDMS.CalcFields("Reserved Qty. (Base)");
        if Abs(ServiceLineEDMS."Outstanding Qty. (Base)") < Abs(ServiceLineEDMS."Reserved Qty. (Base)") + QuantityBase then
            Error(
              ReservedQtyTooLargeErr,
              Abs(ServiceLineEDMS."Outstanding Qty. (Base)") - Abs(ServiceLineEDMS."Reserved Qty. (Base)"));

        IsHandled := false;
        OnCreateReservationOnBeforeTestVariantCode(ServiceLineEDMS, FromTrackingSpecification, IsHandled);
        if not IsHandled then
            ServiceLineEDMS.TestField("Variant Code", FromTrackingSpecification."Variant Code");
        ServiceLineEDMS.TestField("Location Code", FromTrackingSpecification."Location Code");

        if ServiceLineEDMS."Document Type" = ServiceLineEDMS."Document Type"::"Return Order" then
            SignFactor := 1
        else
            SignFactor := -1;

        if QuantityBase * SignFactor < 0 then
            ShipmentDate := ServiceLineEDMS."Shipment Date"
        else begin
            ShipmentDate := ExpectedReceiptDate;
            ExpectedReceiptDate := ServiceLineEDMS."Shipment Date";
        end;

        CreateReservEntry.CreateReservEntryFor(
          DATABASE::"Service Line EDMS", ServiceLineEDMS."Document Type",
          ServiceLineEDMS."Document No.", '', 0, ServiceLineEDMS."Line No.", ServiceLineEDMS."Qty. per Unit of Measure",
          Quantity, QuantityBase, ForReservEntry);
        CreateReservEntry.CreateReservEntryFrom(FromTrackingSpecification);
        CreateReservEntry.CreateReservEntry(
          ServiceLineEDMS."No.", ServiceLineEDMS."Variant Code", ServiceLineEDMS."Location Code",
          Description, ExpectedReceiptDate, ShipmentDate, 0);

        FromTrackingSpecification."Source Type" := 0;
    end;

    [Obsolete('Replaced by CreateReservation(SalesLine, Description, ExpectedReceiptDate, Quantity, QuantityBase, ForReservEntry)', '16.0')]

    procedure CreateReservation(var ServiceLine: Record "Service Line EDMS"; Description: Text[50]; ExpectedReceiptDate: Date; Quantity: Decimal; ForSerialNo: Code[20]; ForLotNo: Code[20])
    var
        ShipmentDate: Date;
        lReservationEntry: Record "Reservation Entry";
        lFromTrackingSpecification: Record "Tracking Specification";
    begin
        if SetFromType = 0 then
            Error(Text000);

        ServiceLine.TestField(Type, ServiceLine.Type::Item);
        ServiceLine.TestField("No.");

        ServiceLine.CalcFields("Reserved Qty. (Base)");
        if ServiceLine.Quantity < ServiceLine."Reserved Qty. (Base)" then
            Error(
              Text001,
              ServiceLine.Quantity);

        ServiceLine.TestField("Variant Code", SetFromVariantCode);
        ServiceLine.TestField("Location Code", SetFromLocationCode);

        if Quantity > 0 then
            ShipmentDate := ServiceLine."Planned Service Date"
        else begin
            ShipmentDate := ExpectedReceiptDate;
            ExpectedReceiptDate := ServiceLine."Planned Service Date";
        end;
        lReservationEntry."Serial No." := ForSerialNo;
        lReservationEntry."Lot No." := ForLotNo;
        CreateReservEntry.CreateReservEntryFor(
          Database::"Service Line EDMS", ServiceLine."Document Type",
          ServiceLine."Document No.", '', 0, ServiceLine."Line No.",
          ServiceLine."Qty. per Unit of Measure", Quantity, Quantity, lReservationEntry);
        //ServiceLine."Qty. per Unit of Measure",Quantity,ServiceLine."Quantity (Base)",ForSerialNo,ForLotNo);  //11.07.2013 EDMS P8
        lFromTrackingSpecification."Source Type" := SetFromType;
        lFromTrackingSpecification."Source Subtype" := SetFromSubtype;
        lFromTrackingSpecification."Source ID" := SetFromID;
        lFromTrackingSpecification."Source ID" := SetFromID;
        lFromTrackingSpecification."Source Batch Name" := SetFromBatchName;
        lFromTrackingSpecification."Source Prod. Order Line" := SetFromProdOrderLine;
        lFromTrackingSpecification."Source Ref. No." := SetFromRefNo;
        lFromTrackingSpecification."Qty. per Unit of Measure" := SetFromQtyPerUOM;
        lFromTrackingSpecification."Serial No." := SetFromSerialNo;
        CreateReservEntry.CreateReservEntryFrom(lFromTrackingSpecification);
        /* CreateReservEntry.CreateReservEntryFrom(
           SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromProdOrderLine, SetFromRefNo,
           SetFromQtyPerUOM, SetFromSerialNo, SetFromLotNo);*/
        CreateReservEntry.CreateReservEntry(
          ServiceLine."No.", ServiceLine."Variant Code", ServiceLine."Location Code",
          Description, ExpectedReceiptDate, ShipmentDate);

        SetFromType := 0;
    end;

    procedure CreateReservationSetFrom(TrackingSpecification: Record "Tracking Specification")
    begin
        FromTrackingSpecification := TrackingSpecification;
    end;

    procedure Caption(ServiceLineEDMS: Record "Service Line EDMS") CaptionText: Text
    begin
        CaptionText := ServiceLineEDMS.GetSourceCaption;
    end;

    procedure FindReservEntry(ServiceLineEDMS: Record "Service Line EDMS"; var ReservEntry: Record "Reservation Entry"): Boolean
    begin
        ReservEntry.InitSortingAndFilters(false);
        ServiceLineEDMS.SetReservationFilters(ReservEntry);
        exit(ReservEntry.FindLast);
    end;

    procedure ReservEntryExist(ServiceLineEDMS: Record "Service Line EDMS"): Boolean
    begin
        exit(ServiceLineEDMS.ReservEntryExist);
    end;

    procedure DeleteLineConfirm(var ServiceLineEDMS: Record "Service Line EDMS"): Boolean
    begin
        if not ServiceLineEDMS.ReservEntryExist then
            exit(true);

        ReservationMgtEDMS.SetReservSource(ServiceLineEDMS);
        if ReservationMgtEDMS.DeleteItemTrackingConfirm then
            DeleteItemTracking := true;

        exit(DeleteItemTracking);
    end;

    procedure DeleteLine(var ServiceLineEDMS: Record "Service Line EDMS")
    begin
        if not ReservEntryExist(ServiceLineEDMS) then
            exit;

        ReservationMgtEDMS.SetReservSource(ServiceLineEDMS);
        ReservationMgtEDMS.SetServLineEDMS(ServiceLineEDMS);
        if DeleteItemTracking then
            ReservationMgtEDMS.SetItemTrackingHandling(1); // Allow Deletion
        ReservationMgtEDMS.DeleteReservEntries(true, 0);
        DeleteInvoiceSpecFromLine(ServiceLineEDMS);
        ServiceLineEDMS.CalcFields("Reserved Qty. (Base)");
    end;


    procedure FilterReservFor(var FilterReservEntry: Record "Reservation Entry"; ServiceLine: Record "Service Line EDMS")
    begin
        FilterReservEntry.SetRange("Source Type", Database::"Service Line EDMS");
        FilterReservEntry.SetRange("Source Subtype", ServiceLine."Document Type");
        FilterReservEntry.SetRange("Source ID", ServiceLine."Document No.");
        FilterReservEntry.SetRange("Source Batch Name", '');
        FilterReservEntry.SetRange("Source Prod. Order Line", 0);
        FilterReservEntry.SetRange("Source Ref. No.", ServiceLine."Line No.");
    end;


    procedure ReservQuantity(ServLine: Record "Service Line EDMS") QtyToReserve: Decimal
    begin
        case ServLine."Document Type" of
            ServLine."document type"::Quote,
            ServLine."document type"::Order:
                //ServLine."Document Type"::Invoice:
                QtyToReserve := ServLine.Quantity;
        end;
    end;


    procedure VerifyChange(var NewServiceLine: Record "Service Line EDMS"; var OldServiceLine: Record "Service Line EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
        TempReservEntry: Record "Reservation Entry";
        ShowError: Boolean;
        HasError: Boolean;
    begin
        if (NewServiceLine.Type <> NewServiceLine.Type::Item) and (OldServiceLine.Type <> OldServiceLine.Type::Item) then
            exit;

        if NewServiceLine."Line No." = 0 then
            if not ServiceLine.Get(NewServiceLine."Document Type", NewServiceLine."Document No.", NewServiceLine."Line No.") then
                exit;

        NewServiceLine.CalcFields("Reserved Qty. (Base)");
        ShowError := NewServiceLine."Reserved Qty. (Base)" <> 0;

        if (NewServiceLine."Planned Service Date" = 0D) and (OldServiceLine."Planned Service Date" <> 0D) then
            if ShowError then
                NewServiceLine.FieldError("Planned Service Date", Text002)
            else
                HasError := true;

        if NewServiceLine.Type <> OldServiceLine.Type then
            if ShowError then
                NewServiceLine.FieldError(Type, Text003)
            else
                HasError := true;

        if NewServiceLine."No." <> OldServiceLine."No." then
            if ShowError then
                NewServiceLine.FieldError("No.", Text003)
            else
                HasError := true;

        if NewServiceLine."Variant Code" <> OldServiceLine."Variant Code" then
            if ShowError then
                NewServiceLine.FieldError("Variant Code", Text003)
            else
                HasError := true;

        if NewServiceLine."Location Code" <> OldServiceLine."Location Code" then
            if ShowError then
                NewServiceLine.FieldError("Location Code", Text003)
            else
                HasError := true;

        if (NewServiceLine."Bin Code" <> OldServiceLine."Bin Code") then
            if ShowError then
                NewServiceLine.FieldError("Bin Code", Text004)
            else
                HasError := true;

        if NewServiceLine."Line No." <> OldServiceLine."Line No." then
            HasError := true;

        if HasError then
            if (NewServiceLine."No." <> OldServiceLine."No.") or
               FindReservEntry(NewServiceLine, TempReservEntry)
            then begin
                if NewServiceLine."No." <> OldServiceLine."No." then begin
                    ReservationMgtEDMS.SetServLineEDMS(OldServiceLine);
                    ReservationMgtEDMS.DeleteReservEntries(true, 0);
                    ReservationMgtEDMS.SetServLineEDMS(NewServiceLine);
                end else begin
                    ReservationMgtEDMS.SetServLineEDMS(NewServiceLine);
                    ReservationMgtEDMS.DeleteReservEntries(true, 0);
                end;
                ReservationMgtEDMS.AutoTrack(NewServiceLine."Outstanding Qty. (Base)");
            end;

        if HasError //OR (NewServiceLine."Planned Service Date" <> NewServiceLine."Planned Service Date")
        then begin
            AssignForPlanning(NewServiceLine);
            if (NewServiceLine."No." <> OldServiceLine."No.") or
               (NewServiceLine."Variant Code" <> OldServiceLine."Variant Code") or
               (NewServiceLine."Location Code" <> OldServiceLine."Location Code")
            then
                AssignForPlanning(OldServiceLine);
        end;
    end;


    procedure VerifyQuantity(var NewServiceLine: Record "Service Line EDMS"; var OldServiceLine: Record "Service Line EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
    begin

        if NewServiceLine.Type <> NewServiceLine.Type::Item then
            exit;
        if NewServiceLine."Line No." = OldServiceLine."Line No." then
            if NewServiceLine."Quantity (Base)" = OldServiceLine."Quantity (Base)" then
                exit;
        if NewServiceLine."Line No." = 0 then
            if not ServiceLine.Get(NewServiceLine."Document Type", NewServiceLine."Document No.", NewServiceLine."Line No.") then
                exit;
        ReservationMgtEDMS.SetServLineEDMS(NewServiceLine);
        if NewServiceLine."Qty. per Unit of Measure" <> OldServiceLine."Qty. per Unit of Measure" then
            ReservationMgtEDMS.ModifyUnitOfMeasure;
        if NewServiceLine."Outstanding Qty. (Base)" * OldServiceLine."Outstanding Qty. (Base)" < 0 then
            ReservationMgtEDMS.DeleteReservEntries(false, 0)
        else
            ReservationMgtEDMS.DeleteReservEntries(false, NewServiceLine."Outstanding Qty. (Base)");
        ReservationMgtEDMS.ClearSurplus;
        ReservationMgtEDMS.AutoTrack(NewServiceLine."Outstanding Qty. (Base)");
        AssignForPlanning(NewServiceLine);
    end;


    procedure AssignForPlanning(var ServiceLine: Record "Service Line EDMS")
    var
        PlanningAssignment: Record "Planning Assignment";
        ServiceHeader: Record "Service Header EDMS";
    begin
        if ServiceLine."Document Type" <> ServiceLine."document type"::Order then
            exit;
        if ServiceLine.Type <> ServiceLine.Type::Item then
            exit;
        if ServiceLine."No." <> '' then
            ServiceHeader.Get(ServiceLine."Document Type", ServiceLine."Document No.");
        PlanningAssignment.ChkAssignOne(ServiceLine."No.", ServiceLine."Variant Code", ServiceLine."Location Code", ServiceLine."Planned Service Date");
    end;


    procedure RenameLine(var NewServiceLine: Record "Service Line EDMS"; var OldServiceLine: Record "Service Line EDMS")
    begin
        ReservEngineMgt.RenamePointer(Database::"Service Line EDMS",
          OldServiceLine."Document Type",
          OldServiceLine."Document No.",
          '',
          0,
          OldServiceLine."Line No.",
          NewServiceLine."Document Type",
          NewServiceLine."Document No.",
          '',
          0,
          NewServiceLine."Line No.");
    end;




    procedure CallItemTracking(var ServiceLine: Record "Service Line EDMS")
    var
        TrackingSpecification: Record "Tracking Specification";
        ServiceHeader: Record "Service Header EDMS";
        ItemTrackingForm: Page "Item Tracking Lines";
    begin
        InitTrackingSpecification(ServiceLine, TrackingSpecification);
        ServiceHeader.Get(ServiceLine."Document Type", ServiceLine."Document No.");
        ItemTrackingForm.SetSourceSpec(TrackingSpecification, ServiceHeader."Posting Date");


        ItemTrackingForm.SetInbound(
          ((ServiceLine."Document Type" in [ServiceLine."document type"::"Return Order"]) and
           (ServiceLine."Quantity (Base)" > 0)) or
          ((ServiceLine."Document Type" in [ServiceLine."document type"::Order]) and
           (ServiceLine."Quantity (Base)" < 0)));

        ItemTrackingForm.RunModal;
    end;


    procedure InitTrackingSpecification(var ServiceLine: Record "Service Line EDMS"; var TrackingSpecification: Record "Tracking Specification")
    begin
        TrackingSpecification.Init;
        TrackingSpecification."Source Type" := Database::"Service Line EDMS";
        TrackingSpecification."Item No." := ServiceLine."No.";
        TrackingSpecification."Location Code" := ServiceLine."Location Code";
        TrackingSpecification.Description := ServiceLine.Description;
        TrackingSpecification."Variant Code" := ServiceLine."Variant Code";
        TrackingSpecification."Source Subtype" := ServiceLine."Document Type";
        TrackingSpecification."Source ID" := ServiceLine."Document No.";
        TrackingSpecification."Source Batch Name" := '';
        TrackingSpecification."Source Prod. Order Line" := 0;
        TrackingSpecification."Source Ref. No." := ServiceLine."Line No.";
        TrackingSpecification."Quantity (Base)" := ServiceLine."Quantity (Base)";
        TrackingSpecification."Qty. to Invoice (Base)" := ServiceLine."Quantity (Base)";
        TrackingSpecification."Qty. to Invoice" := ServiceLine.Quantity;
        TrackingSpecification."Quantity Invoiced (Base)" := ServiceLine."Quantity (Base)";

        TrackingSpecification."Qty. per Unit of Measure" := ServiceLine."Qty. per Unit of Measure";
        TrackingSpecification."Bin Code" := ServiceLine."Bin Code";

        if ServiceLine."Document Type" in [ServiceLine."document type"::"Return Order"] then begin
            TrackingSpecification."Qty. to Handle (Base)" := ServiceLine."Quantity (Base)";
            TrackingSpecification."Quantity Handled (Base)" := ServiceLine."Quantity (Base)";
            TrackingSpecification."Qty. to Handle" := ServiceLine.Quantity;
        end else begin
            TrackingSpecification."Qty. to Handle (Base)" := ServiceLine."Quantity (Base)";
            TrackingSpecification."Quantity Handled (Base)" := ServiceLine."Quantity (Base)";
            TrackingSpecification."Qty. to Handle" := ServiceLine.Quantity;
        end;
    end;


    procedure TransServLineToServLine(var OldServLine: Record "Service Line EDMS"; var NewServLine: Record "Service Line EDMS"; TransferQty: Decimal)
    var
        OldReservEntry: Record "Reservation Entry";
        Status: Option Reservation,Tracking,Surplus,Prospect;
    begin
        if not FindReservEntry(OldServLine, OldReservEntry) then
            exit;

        OldReservEntry.Lock;

        NewServLine.TestField("No.", OldServLine."No.");
        NewServLine.TestField("Variant Code", OldServLine."Variant Code");
        NewServLine.TestField("Location Code", OldServLine."Location Code");

        for Status := Status::Reservation to Status::Prospect do begin
            if TransferQty = 0 then
                exit;
            OldReservEntry.SetRange("Reservation Status", Status);
            if OldReservEntry.FindSet then
                repeat
                    OldReservEntry.TestField("Item No.", OldServLine."No.");
                    OldReservEntry.TestField("Variant Code", OldServLine."Variant Code");
                    OldReservEntry.TestField("Location Code", OldServLine."Location Code");

                    TransferQty := CreateReservEntry.TransferReservEntry(Database::"Service Line EDMS",
                        NewServLine."Document Type", NewServLine."Document No.", '', 0,
                        NewServLine."Line No.", NewServLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);

                until (OldReservEntry.Next = 0) or (TransferQty = 0);
        end;
    end;


    procedure RetrieveInvoiceSpecification(var ServLine: Record "Service Line EDMS"; var TempInvoicingSpecification: Record "Tracking Specification" temporary; Consume: Boolean) OK: Boolean
    var
        SourceSpecification: Record "Tracking Specification";
    begin
        if ServLine.Type <> ServLine.Type::Item then
            exit;
        InitTrackingSpecification(ServLine, SourceSpecification);
        OK := ItemTrackingMgt.RetrieveInvoiceSpecWithService(SourceSpecification, TempInvoicingSpecification, Consume);
        //END;
    end;

    local procedure RetrieveInvoiceSpecification2(var ServLine: Record "Service Line EDMS"; var TempInvoicingSpecification: Record "Tracking Specification" temporary) OK: Boolean
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
    begin
        // Used for combined shipment:
        if ServLine.Type <> ServLine.Type::Item then
            exit;
        if not FindReservEntry(ServLine, ReservEntry) then
            exit;
        ReservEntry.FindSet;
        repeat
            ReservEntry.TestField("Reservation Status", ReservEntry."reservation status"::Prospect);
            ReservEntry.TestField("Item Ledger Entry No.");
            TrackingSpecification.Get(ReservEntry."Item Ledger Entry No.");
            TempInvoicingSpecification := TrackingSpecification;
            TempInvoicingSpecification."Qty. to Invoice (Base)" :=
              ReservEntry."Qty. to Invoice (Base)";
            TempInvoicingSpecification."Qty. to Invoice" :=
              ROUND(ReservEntry."Qty. to Invoice (Base)" / ReservEntry."Qty. per Unit of Measure", 0.00001);
            TempInvoicingSpecification."Buffer Status" := TempInvoicingSpecification."buffer status"::Modify;
            TempInvoicingSpecification.Insert;
            ReservEntry.Delete;
        until ReservEntry.Next = 0;

        OK := TempInvoicingSpecification.FindFirst;
    end;


    procedure DeleteInvoiceSpecFromHeader(var ServHeader: Record "Service Header EDMS")
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TrackingSpecification.SetCurrentkey("Source ID", "Source Type",
          "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
        TrackingSpecification.SetRange("Source Type", Database::"Service Line EDMS");
        TrackingSpecification.SetRange("Source Subtype", ServHeader."Document Type");
        TrackingSpecification.SetRange("Source ID", ServHeader."No.");
        TrackingSpecification.SetRange("Source Batch Name", '');
        TrackingSpecification.SetRange("Source Prod. Order Line", 0);
        if TrackingSpecification.FindSet then
            repeat
                TrackingSpecification.Delete;
            until TrackingSpecification.Next = 0;
    end;

    local procedure DeleteInvoiceSpecFromLine(ServLine: Record "Service Line EDMS")
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TrackingSpecification.SetCurrentkey("Source ID", "Source Type",
          "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
        TrackingSpecification.SetRange("Source ID", ServLine."Document No.");
        TrackingSpecification.SetRange("Source Type", Database::"Service Line EDMS");
        TrackingSpecification.SetRange("Source Subtype", ServLine."Document Type");
        TrackingSpecification.SetRange("Source Batch Name", '');
        TrackingSpecification.SetRange("Source Prod. Order Line", 0);
        TrackingSpecification.SetRange("Source Ref. No.", ServLine."Line No.");
        if TrackingSpecification.FindSet then
            repeat
                TrackingSpecification.Delete;
            until TrackingSpecification.Next = 0;
    end;


    procedure TransServLineToItemJnlLine(var ServLine: Record "Service Line EDMS"; var ItemJnlLine: Record "Item Journal Line"; TransferQty: Decimal; var CheckApplFromItemEntry: Boolean): Decimal
    var
        OldReservEntry: Record "Reservation Entry";
    begin
        if not FindReservEntry(ServLine, OldReservEntry) then
            exit(TransferQty);

        OldReservEntry.Lock;

        if OverruleItemTracking then
            if (ItemJnlLine."Serial No." <> '') or (ItemJnlLine."Lot No." <> '') then begin
                CreateReservEntry.SetNewTrackingFromItemJnlLine(ItemJnlLine);
                CreateReservEntry.SetOverruleItemTracking(true);
                // Try to match against Item Tracking on the service order line:
                OldReservEntry.SetRange("Serial No.", ItemJnlLine."Serial No.");
                OldReservEntry.SetRange("Lot No.", ItemJnlLine."Lot No.");
                if OldReservEntry.IsEmpty then
                    exit(TransferQty);
            end;


        ItemJnlLine.TestField("Item No.", ServLine."No.");
        ItemJnlLine.TestField("Variant Code", ServLine."Variant Code");
        ItemJnlLine.TestField("Location Code", ServLine."Location Code");

        if TransferQty = 0 then
            exit;

        if ItemJnlLine."Invoiced Quantity" <> 0 then
            CreateReservEntry.SetUseQtyToInvoice(true);

        if ReservEngineMgt.InitRecordSet(OldReservEntry) then begin
            repeat
                OldReservEntry.TestField("Item No.", ServLine."No.");
                OldReservEntry.TestField("Variant Code", ServLine."Variant Code");
                OldReservEntry.TestField("Location Code", ServLine."Location Code");

                if CheckApplFromItemEntry then begin
                    OldReservEntry.TestField("Appl.-from Item Entry");
                    CreateReservEntry.SetApplyFromEntryNo(OldReservEntry."Appl.-from Item Entry");
                end;

                TransferQty := CreateReservEntry.TransferReservEntry(Database::"Item Journal Line",
                    ItemJnlLine."Entry Type".AsInteger(), ItemJnlLine."Journal Template Name",
                    ItemJnlLine."Journal Batch Name", 0, ItemJnlLine."Line No.",
                    ItemJnlLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);

            until (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) or (TransferQty = 0);
            CheckApplFromItemEntry := false;
        end;
        exit(TransferQty);
    end;


    procedure UpdateItemTrackingAfterPosting(var ServHeader: Record "Service Header EDMS")
    var
        ReservEntry: Record "Reservation Entry";
    begin
        // Used for updating Quantity to Handle and Quantity to Invoice after posting
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, false);
        ReservEntry.SetRange("Source Type", Database::"Service Line EDMS");
        ReservEntry.SetRange("Source Subtype", ServHeader."Document Type");
        ReservEntry.SetRange("Source ID", ServHeader."No.");
        ReservEntry.SetRange("Source Batch Name", '');
        ReservEntry.SetRange("Source Prod. Order Line", 0);
        if ReservEntry.FindSet then
            repeat
                ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
                ReservEntry."Qty. to Invoice (Base)" := ReservEntry."Quantity (Base)";
                ReservEntry.Modify;


            until ReservEntry.Next = 0;
    end;


    procedure SetBinding(Binding: Option " ","Order-to-Order")
    begin
        CreateReservEntry.SetBinding(Binding);
    end;


    procedure TransServLineToSalesLine(var OldServLine: Record "Service Line EDMS"; var NewSalesLine: Record "Sales Line"; TransferQty: Decimal)
    var
        OldReservEntry: Record "Reservation Entry";
        Status: Option Reservation,Tracking,Surplus,Prospect;
    begin
        if not FindReservEntry(OldServLine, OldReservEntry) then
            exit;

        OldReservEntry.Lock;

        NewSalesLine.TestField("No.", OldServLine."No.");
        NewSalesLine.TestField("Variant Code", OldServLine."Variant Code");
        NewSalesLine.TestField("Location Code", OldServLine."Location Code");

        for Status := Status::Reservation to Status::Prospect do begin
            if TransferQty = 0 then
                exit;
            OldReservEntry.SetRange("Reservation Status", Status);
            if OldReservEntry.FindSet then
                repeat
                    OldReservEntry.TestField("Item No.", OldServLine."No.");
                    OldReservEntry.TestField("Variant Code", OldServLine."Variant Code");
                    OldReservEntry.TestField("Location Code", OldServLine."Location Code");

                    TransferQty := CreateReservEntry.TransferReservEntry(Database::"Sales Line",
                        NewSalesLine."Document Type".AsInteger(), NewSalesLine."Document No.", '', 0,
                        NewSalesLine."Line No.", NewSalesLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);

                until (OldReservEntry.Next = 0) or (TransferQty = 0);
        end;
    end;

    local procedure SetReservSourceFor(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; var CaptionText: Text)
    var
        ServieceLineEDMS: Record "Service Line EDMS";
    begin
        SourceRecRef.SetTable(ServieceLineEDMS);
        ServieceLineEDMS.TestField(Type, ServieceLineEDMS.Type::Item);
        ServieceLineEDMS.TestField("Planned Service Date");

        ServieceLineEDMS.SetReservationEntry(ReservEntry);

        CaptionText := ServieceLineEDMS.GetSourceCaption;
    end;

    local procedure EntryStartNo(): Integer
    begin
        exit(220);
    end;

    local procedure MatchThisEntry(EntryNo: Integer): Boolean
    begin
        exit(EntryNo in [220, 230]); //Service Line EDMS
    end;

    local procedure MatchThisTable(TableID: Integer): Boolean
    begin
        exit(TableID = 25006146); // DATABASE::"Service Line EDMS"
    end;

    [EventSubscriber(ObjectType::Page, Page::Reservation, 'OnSetReservSource', '', false, false)]
    local procedure OnSetReservSource(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; var CaptionText: Text)
    begin
        if MatchThisTable(SourceRecRef.Number) then
            SetReservSourceFor(SourceRecRef, ReservEntry, CaptionText);
    end;

    [EventSubscriber(ObjectType::Page, Page::Reservation, 'OnDrillDownTotalQuantity', '', false, false)]
    local procedure OnDrillDownTotalQuantity(SourceRecRef: RecordRef; ReservEntry: Record "Reservation Entry"; EntrySummary: Record "Entry Summary"; Location: Record Location; MaxQtyToReserve: Decimal)
    var
        AvailableServiceLinesEDMS: page "Available - Service Lines EDMS";
    begin
        if MatchThisEntry(EntrySummary."Entry No.") then begin
            Clear(AvailableServiceLinesEDMS);
            AvailableServiceLinesEDMS.SetCurrentSubType(EntrySummary."Entry No." - EntryStartNo());
            AvailableServiceLinesEDMS.SetSource(SourceRecRef, ReservEntry, ReservEntry."Source Subtype");
            AvailableServiceLinesEDMS.RunModal;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Reservation, 'OnFilterReservEntry', '', false, false)]
    local procedure OnFilterReservEntry(var FilterReservEntry: Record "Reservation Entry"; ReservEntrySummary: Record "Entry Summary")
    begin
        if MatchThisEntry(ReservEntrySummary."Entry No.") then begin
            FilterReservEntry.SetRange("Source Type", DATABASE::"Service Line EDMS");
            FilterReservEntry.SetRange("Source Subtype", ReservEntrySummary."Entry No." - EntryStartNo());
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Reservation, 'OnAfterRelatesToSummEntry', '', false, false)]
    local procedure OnRelatesToEntrySummary(var FilterReservEntry: Record "Reservation Entry"; FromEntrySummary: Record "Entry Summary"; var IsHandled: Boolean)
    begin
        if MatchThisEntry(FromEntrySummary."Entry No.") then
            IsHandled :=
                (FilterReservEntry."Source Type" = DATABASE::"Service Line EDMS") and
                (FilterReservEntry."Source Subtype" = FromEntrySummary."Entry No." - EntryStartNo());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnCreateReservation', '', false, false)]
    local procedure OnCreateReservation(SourceRecRef: RecordRef; TrackingSpecification: Record "Tracking Specification"; ForReservEntry: Record "Reservation Entry"; Description: Text[100]; ExpectedDate: Date; Quantity: Decimal; QuantityBase: Decimal)

    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if MatchThisTable(ForReservEntry."Source Type") then begin
            CreateReservationSetFrom(TrackingSpecification);
            SourceRecRef.SetTable(ServiceLineEDMS);
            CreateReservation(ServiceLineEDMS, Description, ExpectedDate, Quantity, QuantityBase, ForReservEntry);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management EDMS", 'OnCreateReservation', '', false, false)]
    local procedure OnCreateReservationEDMS(SourceRecRef: RecordRef; TrackingSpecification: Record "Tracking Specification"; ForReservEntry: Record "Reservation Entry"; Description: Text[100]; ExpectedDate: Date; Quantity: Decimal; QuantityBase: Decimal)

    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if MatchThisTable(ForReservEntry."Source Type") then begin
            CreateReservationSetFrom(TrackingSpecification);
            SourceRecRef.SetTable(ServiceLineEDMS);
            CreateReservation(ServiceLineEDMS, Description, ExpectedDate, Quantity, QuantityBase, ForReservEntry);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnLookupDocument', '', false, false)]
    local procedure OnLookupDocument(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20])
    var
        ServiceHeaderEDMS: Record "Service Header EDMS";
    begin
        if MatchThisTable(SourceType) then begin
            ServiceHeaderEDMS.Reset();
            ServiceHeaderEDMS.SetRange("Document Type", SourceSubtype);
            ServiceHeaderEDMS.SetRange("No.", SourceID);
            case SourceSubtype of
                0:
                    PAGE.RunModal(PAGE::"Service Quote EDMS", ServiceHeaderEDMS);
                1:
                    PAGE.RunModal(PAGE::"Service Order EDMS", ServiceHeaderEDMS);
                2:
                    PAGE.RunModal(PAGE::"Service Return Order EDMS", ServiceHeaderEDMS);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management EDMS", 'OnLookupDocument', '', false, false)]
    local procedure OnLookupDocumentEDMS(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20])
    var
        ServiceHeaderEDMS: Record "Service Header EDMS";
    begin
        if MatchThisTable(SourceType) then begin
            ServiceHeaderEDMS.Reset();
            ServiceHeaderEDMS.SetRange("Document Type", SourceSubtype);
            ServiceHeaderEDMS.SetRange("No.", SourceID);
            case SourceSubtype of
                0:
                    PAGE.RunModal(PAGE::"Service Quote EDMS", ServiceHeaderEDMS);
                1:
                    PAGE.RunModal(PAGE::"Service Order EDMS", ServiceHeaderEDMS);
                2:
                    PAGE.RunModal(PAGE::"Service Return Order EDMS", ServiceHeaderEDMS);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnLookupLine', '', false, false)]
    local procedure OnLookupLine(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if MatchThisTable(SourceType) then begin
            ServiceLineEDMS.Reset();
            ServiceLineEDMS.SetRange("Document Type", SourceSubtype);
            ServiceLineEDMS.SetRange("Document No.", SourceID);
            ServiceLineEDMS.SetRange("Line No.", SourceRefNo);
            PAGE.Run(PAGE::"Service Lines Prep EDMS", ServiceLineEDMS);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management EDMS", 'OnLookupLine', '', false, false)]
    local procedure OnLookupLineEDMS(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if MatchThisTable(SourceType) then begin
            ServiceLineEDMS.Reset();
            ServiceLineEDMS.SetRange("Document Type", SourceSubtype);
            ServiceLineEDMS.SetRange("Document No.", SourceID);
            ServiceLineEDMS.SetRange("Line No.", SourceRefNo);
            PAGE.Run(PAGE::"Service Lines Prep EDMS", ServiceLineEDMS);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnFilterReservFor', '', false, false)]
    local procedure OnFilterReservFor(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; var CaptionText: Text)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if MatchThisTable(SourceRecRef.Number) then begin
            SourceRecRef.SetTable(ServiceLineEDMS);
            ServiceLineEDMS.SetReservationFilters(ReservEntry);
            CaptionText := ServiceLineEDMS.GetSourceCaption;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management EDMS", 'OnFilterReservFor', '', false, false)]
    local procedure OnFilterReservForEDMS(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; var CaptionText: Text)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if MatchThisTable(SourceRecRef.Number) then begin
            SourceRecRef.SetTable(ServiceLineEDMS);
            ServiceLineEDMS.SetReservationFilters(ReservEntry);
            CaptionText := ServiceLineEDMS.GetSourceCaption;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnCalculateRemainingQty', '', false, false)]
    local procedure OnCalculateRemainingQty(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; var RemainingQty: Decimal; var RemainingQtyBase: Decimal)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if MatchThisTable(ReservEntry."Source Type") then begin
            SourceRecRef.SetTable(ServiceLineEDMS);
            ServiceLineEDMS.GetRemainingQty(RemainingQty, RemainingQtyBase);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management EDMS", 'OnCalculateRemainingQty', '', false, false)]
    local procedure OnCalculateRemainingQtyEDMS(SourceRecRef: RecordRef; var ReservEntry: Record "Reservation Entry"; var RemainingQty: Decimal; var RemainingQtyBase: Decimal)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if MatchThisTable(ReservEntry."Source Type") then begin
            SourceRecRef.SetTable(ServiceLineEDMS);
            ServiceLineEDMS.GetRemainingQty(RemainingQty, RemainingQtyBase);
        end;
    end;

    local procedure GetSourceValue(ReservEntry: Record "Reservation Entry"; var SourceRecRef: RecordRef; ReturnOption: Option "Net Qty. (Base)","Gross Qty. (Base)"): Decimal
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        ServiceLineEDMS.Get(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.");
        SourceRecRef.GetTable(ServiceLineEDMS);
        case ReturnOption of
            ReturnOption::"Net Qty. (Base)":
                exit(ServiceLineEDMS."Outstanding Qty. (Base)");
            ReturnOption::"Gross Qty. (Base)":
                exit(ServiceLineEDMS."Quantity (Base)");
        end;
    end;
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnGetSourceRecordValue', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management EDMS", 'OnGetSourceRecordValue', '', false, false)]
    local procedure OnGetSourceRecordValueEDMS(var ReservEntry: Record "Reservation Entry"; ReturnOption: Option; var ReturnQty: Decimal; var SourceRecRef: RecordRef)
    begin
        if MatchThisTable(ReservEntry."Source Type") then
            ReturnQty := GetSourceValue(ReservEntry, SourceRecRef, ReturnOption);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnGetSourceRecordValue', '', false, false)]
    local procedure OnGetSourceRecordValue(var ReservEntry: Record "Reservation Entry"; ReturnOption: Option; var ReturnQty: Decimal; var SourceRecRef: RecordRef)
    begin
        if MatchThisTable(ReservEntry."Source Type") then
            ReturnQty := GetSourceValue(ReservEntry, SourceRecRef, ReturnOption);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnUpdateStatistics', '', false, false)]
    local procedure OnUpdateStatistics(CalcReservEntry: Record "Reservation Entry"; var ReservSummEntry: Record "Entry Summary"; AvailabilityDate: Date; Positive: Boolean; var TotalQuantity: Decimal)
    var
        CalcSumValue: Decimal;
    begin
        if ReservSummEntry."Entry No." in [220, 320] then
            UpdateStatistics(
             CalcReservEntry, ReservSummEntry, AvailabilityDate, ReservSummEntry."Entry No." - 31, Positive, TotalQuantity);
    end;

    procedure UpdateStatistics(CalcReservEntry: Record "Reservation Entry"; var TempEntrySummary: Record "Entry Summary" temporary; AvailabilityDate: Date; DocumentType: Option; Positive: Boolean; var TotalQuantity: Decimal)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
        AvailabilityFilter: Text;
    begin

        if not ServiceLineEDMS.ReadPermission then
            exit;

        AvailabilityFilter := CalcReservEntry.GetAvailabilityFilter(AvailabilityDate, Positive);
        ServiceLineEDMS.FilterLinesForReservation(CalcReservEntry, DocumentType, AvailabilityFilter, Positive);
        if ServiceLineEDMS.FindSet then
            repeat
                ServiceLineEDMS.CalcFields("Reserved Qty. (Base)");
                TempEntrySummary."Total Reserved Quantity" -= ServiceLineEDMS."Reserved Qty. (Base)";
                TotalQuantity += ServiceLineEDMS."Outstanding Qty. (Base)";
            until ServiceLineEDMS.Next = 0;

        if TotalQuantity = 0 then
            exit;

        if (Positive = (TotalQuantity < 0)) and (DocumentType <> ServiceLineEDMS."Document Type"::"Return Order") or
    (Positive = (TotalQuantity > 0)) and (DocumentType = ServiceLineEDMS."Document Type"::"Return Order")
then begin
            TempEntrySummary."Table ID" := DATABASE::"Sales Line";
            TempEntrySummary."Summary Type" :=
                CopyStr(
                StrSubstNo('%1, %2', ServiceLineEDMS.TableCaption, ServiceLineEDMS."Document Type"),
                1, MaxStrLen(TempEntrySummary."Summary Type"));
            if DocumentType = ServiceLineEDMS."Document Type"::"Return Order" then
                TempEntrySummary."Total Quantity" := TotalQuantity
            else
                TempEntrySummary."Total Quantity" := -TotalQuantity;
            TempEntrySummary."Total Available Quantity" := TempEntrySummary."Total Quantity" - TempEntrySummary."Total Reserved Quantity";
            if not TempEntrySummary.Insert() then
                TempEntrySummary.Modify;
        end;
    end;




    [EventSubscriber(ObjectType::Page, PAGE::Reservation, 'OnGetQtyPerUOMFromSourceRecRef', '', false, false)]
    local procedure OnGetQtyPerUOMFromSourceRecRef(SourceRecRef: RecordRef; var QtyPerUOM: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if MatchThisTable(SourceRecRef.Number) then begin
            SourceRecRef.SetTable(ServiceLineEDMS);
            ServiceLineEDMS.Find;
            QtyPerUOM := ServiceLineEDMS.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
        end;
    end;


    [EventSubscriber(ObjectType::Page, PAGE::Reservation, 'OnGetQtyPerUOMFromSourceRecRef', '', false, false)]
    local procedure OnGetQtyPerUOMFromSourceRecRefEDMS(SourceRecRef: RecordRef; var QtyPerUOM: Decimal; var QtyReserved: Decimal; var QtyReservedBase: Decimal; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if MatchThisTable(SourceRecRef.Number) then begin
            SourceRecRef.SetTable(ServiceLineEDMS);
            ServiceLineEDMS.Find;
            QtyPerUOM := ServiceLineEDMS.GetReservationQty(QtyReserved, QtyReservedBase, QtyToReserve, QtyToReserveBase);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReservQuantity(SalesLine: Record "Sales Line"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeBindToProdOrder(SalesLine: Record "Sales Line"; ProdOrderLine: Record "Prod. Order Line"; ReservQty: Decimal; ReservQtyBase: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateReservationOnBeforeTestVariantCode(ServiceLineEDMS: Record "Service Line EDMS"; FromTrackingSpecification: Record "Tracking Specification"; var IsHandled: Boolean)
    begin
    end;

}

