codeunit 25006144 "Capable to Promise EDMS"
{
    // 14.02.2019 EB.P30 EDMS
    //   Added function:
    //     CreateReqLineFromSalesLine
    // 
    // 07.09.2018 EB.P30 EDMS
    //   Modified function
    //     CreateReqLine
    // 
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified GetDefaultBin, removed UserProfile and UserProfileMgt variables.
    // 
    // 01.09.2014 EDMS P8
    //   * Hotfix - to get right reservation from requisition line link
    // 
    // 22.05.2014 EDMS P8
    //   * MERGE with last changes
    // 
    // 07.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified function:
    //     CreateReqLinesFromTransfer
    // 
    // 27.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified function:
    //     CreateReqLinesFromTransfer
    // 
    // 07.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     CreateReqLinesFromTransfer
    // 
    // 06.08.2008 EDMS P1 - Elva DMS Service Integration
    //  *Added new parameter OrderPromisingType to RemoveReqLines
    //  *Added new parameter Order Promising Type to CalcCapableToPromise
    //  *Added new parameter Order Promising Type to SetOrderPromisingParameters


    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Calculation with date #1######';
        OrderPromisingSetup: Record "Order Promising Setup";
        CompanyInfo: Record "Company Information";
        UOMMgt: Codeunit "Unit of Measure Management";
        OrderPromisingType: Integer;
        OrderPromisingID: Code[20];
        LastEarlyDate: Date;
        LastLateDate: Date;
        OrderPromisingEnd: Date;
        OrderPromisingStart: Date;
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        OrderPromisingLineNo: Integer;
        OrderPromisingLineToSave: Integer;
        SourceLineNo: Integer;
        Text001: label '%1 Requisition Line was created! %2 %3, %4 %5.';
        Text002: label 'Do you want to create order promising?';
        ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        FromTrackingSpecification: Record "Tracking Specification";
        ServiceLineEDMSReserve: Codeunit "Service Line EDMS-Reserve";

    local procedure ValidateCapableToPromise(var ReqLine: Record "Requisition Line"; ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; NeededDate: Date; NeededQty: Decimal; UnitOfMeasure: Code[10]; PeriodType: Option Day,Week,Month,Quarter,Year; var DueDateOfReqLine: Date): Boolean
    var
        CumulativeATP: Decimal;
        ReqQty: Decimal;
        Ok: Boolean;
    begin
        Clear(ReqLine);

        CumulativeATP :=
          GetCumulativeATP(ItemNo, VariantCode, LocationCode, NeededDate, UnitOfMeasure, PeriodType);

        if CumulativeATP < 0 then begin
            if CumulativeATP + NeededQty <= 0 then
                ReqQty := NeededQty
            else
                ReqQty := -CumulativeATP;
            CreateReqLine(ItemNo, VariantCode, LocationCode, ReqQty, UnitOfMeasure, NeededDate, 1, ReqLine);
            OrderPromisingLineNo := OrderPromisingLineNo + 1;
            if ReqLine."Starting Date" < OrderPromisingStart then
                exit(false);
        end;
        Ok := CheckDerivedDemandCTP(ReqLine, PeriodType);
        if ReqLine."No." <> '' then begin
            if Ok then
                DueDateOfReqLine := ReqLine."Due Date"
        end else
            DueDateOfReqLine := NeededDate;
        exit(Ok);
    end;

    procedure CalcCapableToPromise(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; NeededDate: Date; NeededQty: Decimal; UnitOfMeasure: Code[10]; "Order Promising Type": Integer; var LocOrderPromisingID: Code[20]; LocSourceLineNo: Integer; var LastValidLine: Integer; PeriodType: Option Day,Week,Month,Quarter,Year; PeriodLengthFormula: DateFormula): Date
    var
        RequisitionLine: Record "Requisition Line";
        CalculationDialog: Dialog;
        CalculationStartDate: Date;
        CapableToPromiseDate: Date;
        IsValid: Boolean;
        StopCalculation: Boolean;
        DueDateOfReqLine: Date;
    begin
        if NeededQty = 0 then
            exit(NeededDate);
        //06.08.2008 EDMS P1 - Elva DMS Service Integration + Upgrade to 2017>>
        //RemoveReqLines(LocOrderPromisingID,LocSourceLineNo,LastValidLine,FALSE);
        //SetOrderPromisingParameters(LocOrderPromisingID,LocSourceLineNo,PeriodLengthFormula);
        RemoveReqLines("Order Promising Type", LocOrderPromisingID, LocSourceLineNo, LastValidLine, false);
        SetOrderPromisingParameters("Order Promising Type", LocOrderPromisingID, LocSourceLineNo, PeriodLengthFormula);
        //06.08.2008 EDMS P1 - Elva DMS Service Integration + Upgrade to 2017<<

        CapableToPromiseDate := 0D;
        CalculationStartDate := NeededDate;
        if CalculationStartDate = 0D then
            CalculationStartDate := OrderPromisingStart;
        OrderPromisingLineToSave := OrderPromisingLineNo;
        if not
           ValidateCapableToPromise(
             RequisitionLine, ItemNo, VariantCode, LocationCode, CalculationStartDate,
             NeededQty, UnitOfMeasure, PeriodType, DueDateOfReqLine)
        then begin
            StopCalculation := false;
            LastEarlyDate := CalculationStartDate;
            LastLateDate := OrderPromisingEnd;
            CalculationStartDate := OrderPromisingEnd;
            CalculationDialog.Open(Text000);
            repeat
                CalculationDialog.Update(1, Format(CalculationStartDate));
                RemoveReqLines("Order Promising Type", LocOrderPromisingID, LocSourceLineNo, OrderPromisingLineToSave, false); //06.08.2008 EDMS P1 +Upgrade to 2017
                IsValid :=
                  ValidateCapableToPromise(
                    RequisitionLine, ItemNo, VariantCode, LocationCode, CalculationStartDate,
                    NeededQty, UnitOfMeasure, PeriodType, DueDateOfReqLine);
                if IsValid then begin
                    CapableToPromiseDate := CalculationStartDate;
                    StopCalculation := GetNextCalcStartDate(CalculationStartDate, 0);
                end else
                    StopCalculation := GetNextCalcStartDate(CalculationStartDate, 1);
            until StopCalculation;
            if not IsValid and (CapableToPromiseDate > 0D) then begin
                RemoveReqLines("Order Promising Type", LocOrderPromisingID, LocSourceLineNo, OrderPromisingLineToSave, false); //06.08.2008 EDMS P1 + Upagrade to 2017
                ValidateCapableToPromise(
                  RequisitionLine, ItemNo, VariantCode, LocationCode, CapableToPromiseDate,
                  NeededQty, UnitOfMeasure, PeriodType, DueDateOfReqLine);
            end;
            CalculationDialog.Close;
        end else
            CapableToPromiseDate := CalculationStartDate;

        if CapableToPromiseDate <> DueDateOfReqLine then
            CapableToPromiseDate := DueDateOfReqLine;

        LastValidLine := GetNextOrderPromisingLineNo;
        if CapableToPromiseDate = 0D then
            RemoveReqLines("Order Promising Type", LocOrderPromisingID, LocSourceLineNo, OrderPromisingLineNo, false); //06.08.2008 EDMS P1 + Upgrade to 2017
        exit(CapableToPromiseDate);
    end;

    local procedure GetNextCalcStartDate(var CalculationStartDate: Date; Direction: Option Backwards,Forwards): Boolean
    var
        BestResult: Boolean;
    begin
        BestResult := false;
        if Direction = Direction::Backwards then begin
            LastLateDate := CalculationStartDate;
            if LastLateDate - LastEarlyDate > 1 then
                CalculationStartDate := CalculationStartDate - Round((LastLateDate - LastEarlyDate) / 2, 1, '>')
            else
                BestResult := true;
        end else begin
            LastEarlyDate := CalculationStartDate;
            if LastLateDate - LastEarlyDate > 1 then
                CalculationStartDate := CalculationStartDate + Round((LastLateDate - LastEarlyDate) / 2, 1, '>')
            else
                BestResult := true;
        end;
        exit(BestResult);
    end;

    local procedure CreateReqLine(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; Quantity: Decimal; Unit: Code[10]; DueDate: Date; Direction: Option Forward,Backward; var ReqLine: Record "Requisition Line")
    var
        SalesLine: Record "Sales Line";
        LeadTimeMgt: Codeunit "Lead-Time Management";
        PlngLnMgt: Codeunit "Planning Line Management";
        ReqWkshTemplate: Record "Req. Wksh. Template";
        ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType;
    begin
        ReqLine.Init();
        ReqLine."Order Promising Type" := OrderPromisingType; //06.08.2008 EDMS P1
        ReqLine."Order Promising ID" := OrderPromisingID;
        ReqLine."Order Promising Line ID" := SourceLineNo;
        ReqLine."Order Promising Line No." := OrderPromisingLineNo;
        ReqLine."Worksheet Template Name" := OrderPromisingSetup."Order Promising Template";
        ReqLine."Journal Batch Name" := OrderPromisingSetup."Order Promising Worksheet";
        GetNextReqLineNo(ReqLine);
        ReqLine.Type := ReqLine.Type::Item;
        ReqLine."Location Code" := LocationCode;
        ReqLine.Validate("No.", ItemNo);
        ReqLine.Validate("Variant Code", VariantCode);
        ReqWkshTemplate.Get(OrderPromisingSetup."Order Promising Template");//10.11.2011 EDMS P8
        ReqLine."Document Profile" := ReqWkshTemplate."Document Profile"; //10.11.2011 EDMS P8

        ReqLine."Ordering Price Type Code" := ReqLine.GetReservForInfo(Returnvalue::OrderingPriceType); // 07.09.2018 EB.P30 EDMS

        //17.10.2007. EDMS P2 >>
        GetDefaultBin(ReqLine);
        //17.10.2007. EDMS P2 <<

        ReqLine."Action Message" := ReqLine."Action Message"::New;
        ReqLine."Accept Action Message" := false;
        ReqLine.Validate("Ending Date",
          LeadTimeMgt.GetPlannedEndingDate(ItemNo, LocationCode, VariantCode, DueDate, ReqLine."Vendor No.", ReqLine."Ref. Order Type"));
        ReqLine."Ending Time" := 235959T;
        ReqLine.Validate(Quantity, Quantity);
        ReqLine.Validate("Unit of Measure Code", Unit);
        if ReqLine."Starting Date" = 0D then
            ReqLine."Starting Date" := WorkDate;
        OnBeforeReqLineInsert(ReqLine);
        ReqLine.Insert(true);
        PlngLnMgt.Calculate(ReqLine, Direction, true, true, 0);
        if ReqLine."Order Promising Type" = ReqLine."order promising type"::Sales then //06.08.2008 EDMS P1
            if SalesLine.Get(SalesLine."Document Type"::Order, ReqLine."Order Promising ID", ReqLine."Order Promising Line ID") then
                ReqLine.Validate("Ordering Price Type Code", SalesLine."Ordering Price Type Code");       // 04.03.2019 EB.P30 EDMS
        if SalesLine."Drop Shipment" then begin
            ReqLine."Sales Order No." := SalesLine."Document No.";
            ReqLine."Sales Order Line No." := SalesLine."Line No.";
            ReqLine."Sell-to Customer No." := SalesLine."Sell-to Customer No.";
            ReqLine."Purchasing Code" := SalesLine."Purchasing Code";
        end;
        OnBeforeReqLineModify(ReqLine);
        ReqLine.Modify();
    end;

    local procedure CheckDerivedDemandCTP(ReqLine: Record "Requisition Line"; PeriodType: Option Day,Week,Month,Quarter,Year): Boolean
    begin
        if ReqLine."Replenishment System" = ReqLine."Replenishment System"::Transfer then
            exit(CheckTransferShptCTP(ReqLine, PeriodType));

        exit(CheckCompsCapableToPromise(ReqLine, PeriodType));
    end;

    local procedure CheckCompsCapableToPromise(ReqLine: Record "Requisition Line"; PeriodType: Option Day,Week,Month,Quarter,Year): Boolean
    var
        PlanningComponent: Record "Planning Component";
        ReqLine2: Record "Requisition Line";
        CompReqLine: Record "Requisition Line";
        TrackingSpecification: Record "Tracking Specification";
        PlngComponentReserve: Codeunit "Plng. Component-Reserve";
        IsValidDate: Boolean;
        DueDateOfReqLine: Date;
    begin
        PlanningComponent.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        PlanningComponent.SetRange("Worksheet Batch Name", ReqLine."Journal Batch Name");
        PlanningComponent.SetRange("Worksheet Line No.", ReqLine."Line No.");
        if PlanningComponent.FindSet then
            repeat
                if (PlanningComponent."Supplied-by Line No." = 0) and PlanningComponent.Critical then begin
                    if ValidateCapableToPromise(
                         CompReqLine, PlanningComponent."Item No.", PlanningComponent."Variant Code", PlanningComponent."Location Code", PlanningComponent."Due Date",
                         PlanningComponent."Expected Quantity", PlanningComponent."Unit of Measure Code", PeriodType, DueDateOfReqLine)
                    then begin
                        TrackingSpecification.InitTrackingSpecification(DATABASE::"Requisition Line", 0, CompReqLine."Worksheet Template Name", CompReqLine."Journal Batch Name", 0, CompReqLine."Line No.", CompReqLine."Variant Code", CompReqLine."Location Code", CompReqLine."Qty. per Unit of Measure");
                        PlngComponentReserve.BindToTracking(PlanningComponent, TrackingSpecification, CompReqLine.Description, CompReqLine."Due Date", CompReqLine.Quantity, CompReqLine."Quantity (Base)");
                    end
                    else begin
                        OrderPromisingLineNo := OrderPromisingLineNo - 1;
                        exit(false);
                    end;
                end else
                    if PlanningComponent."Supplied-by Line No." > 0 then
                        if ReqLine2.Get(ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name", PlanningComponent."Supplied-by Line No.") then begin
                            IsValidDate := CheckDerivedDemandCTP(ReqLine2, PeriodType);
                            if not IsValidDate or (ReqLine2."Starting Date" < OrderPromisingStart) then
                                exit(false);
                        end;
            until PlanningComponent.Next() = 0;
        exit(true);
    end;

    local procedure CheckTransferShptCTP(ReqLine: Record "Requisition Line"; PeriodType: Option Day,Week,Month,Quarter,Year): Boolean
    var
        Item: Record Item;
        RequisitionLine: Record "Requisition Line";
        DueDateOfReqLine: Date;
    begin
        ReqLine.TestField("Replenishment System", ReqLine."Replenishment System"::Transfer);
        Item.Get(ReqLine."No.");
        if Item.Critical then
            if not
               ValidateCapableToPromise(
                 RequisitionLine, ReqLine."No.", ReqLine."Variant Code", ReqLine."Transfer-from Code", ReqLine."Transfer Shipment Date",
                 ReqLine.Quantity, ReqLine."Unit of Measure Code", PeriodType, DueDateOfReqLine)
            then begin
                OrderPromisingLineNo := OrderPromisingLineNo - 1;
                exit(false);
            end;
        exit(true);
    end;

    local procedure GetNextReqLineNo(var ReqLine: Record "Requisition Line")
    var
        ReqLine2: Record "Requisition Line";
    begin
        ReqLine2.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        ReqLine2.SetRange("Journal Batch Name", ReqLine."Journal Batch Name");
        if ReqLine2.FindLast then
            ReqLine."Line No." := ReqLine2."Line No." + 10000
        else
            ReqLine."Line No." := 10000;
    end;

    local procedure SetOrderPromisingParameters("Order Promising Type": Integer; var LocOrderPromisingID: Code[20]; LocSourceLineNo: Integer; PeriodLengthFormula: DateFormula)
    var
        NoSeriesMgt: Codeunit "No. Series";
    begin
        CompanyInfo.Get();
        OrderPromisingSetup.Get();
        OrderPromisingSetup.TestField("Order Promising Template");
        OrderPromisingSetup.TestField("Order Promising Worksheet");
        if LocOrderPromisingID = '' then begin
            LocOrderPromisingID := NoSeriesMgt.GetNextNo(OrderPromisingSetup."Order Promising Nos.", WorkDate, true);
            OrderPromisingLineNo := 1;
        end else
            OrderPromisingLineNo := GetNextOrderPromisingLineNo;
        OrderPromisingType := "Order Promising Type"; //06.08.2008 EDMS P1
        OrderPromisingID := LocOrderPromisingID;
        SourceLineNo := LocSourceLineNo;
        OrderPromisingStart := CalcDate(OrderPromisingSetup."Offset (Time)", WorkDate);
        OrderPromisingEnd := CalcDate(PeriodLengthFormula, OrderPromisingStart);
    end;

    procedure RemoveReqLines(OrderPromisingType: Integer; OrderPromisingID: Code[20]; SourceLineNo: Integer; LastGoodLineNo: Integer; FilterOnNonAccepted: Boolean)
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.SetCurrentKey("Order Promising ID", "Order Promising Line ID", "Order Promising Line No.");
        ReqLine.SetRange("Order Promising Type", OrderPromisingType); //06.08.2008 EDMS P1
        ReqLine.SetRange("Order Promising ID", OrderPromisingID);
        if SourceLineNo <> 0 then
            ReqLine.SetRange("Order Promising Line ID", SourceLineNo);
        if LastGoodLineNo <> 0 then
            ReqLine.SetFilter("Order Promising Line No.", '>=%1', LastGoodLineNo);
        if FilterOnNonAccepted then
            ReqLine.SetRange("Accept Action Message", false);
        if ReqLine.Find('-') then
            repeat
                ReqLine.DeleteMultiLevel;
                ReqLine.Delete(true);
            until ReqLine.Next() = 0;
    end;

    local procedure GetCumulativeATP(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; DueDate: Date; UnitOfMeasureCode: Code[10]; PeriodType: Option Day,Week,Month,Quarter,Year): Decimal
    var
        Item: Record Item;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        AvailToPromise: Codeunit "Available to Promise";
        CumulativeATP: Decimal;
    begin
        Item.Get(ItemNo);
        Item.SetRange("Variant Filter", VariantCode);
        Item.SetRange("Location Filter", LocationCode);
        Item.SetRange("Date Filter", 0D, DueDate);

        CumulativeATP :=
          AvailToPromise.CalcQtyAvailableToPromise(
            Item, GrossRequirement, ScheduledReceipt, DueDate,
            PeriodType, CompanyInfo."Check-Avail. Period Calc.");

        if UnitOfMeasureCode = Item."Base Unit of Measure" then
            exit(CumulativeATP);

        ItemUnitOfMeasure.Get(ItemNo, UnitOfMeasureCode);
        exit(Round(CumulativeATP / ItemUnitOfMeasure."Qty. per Unit of Measure", UOMMgt.QtyRndPrecision));
    end;

    local procedure GetDefaultBin(var ReqLine: Record "Requisition Line")
    var
        WMSManagement: Codeunit "WMS Management";
        SalesSetup: Record "Sales & Receivables Setup";
        Location: Record Location;
    begin
        if ReqLine.Type <> ReqLine.Type::Item then
            exit;

        ReqLine."Bin Code" := '';

        if (ReqLine."Location Code" <> '') and (ReqLine."No." <> '') then begin
            GetLocation(ReqLine."Location Code", Location);
            if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then
                WMSManagement.GetDefaultBin(ReqLine."No.", ReqLine."Variant Code", ReqLine."Location Code", ReqLine."Bin Code");
        end;
    end;

    local procedure GetNextOrderPromisingLineNo(): Integer
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.SetCurrentKey("Order Promising ID");
        ReqLine.SetRange("Order Promising ID", OrderPromisingID);
        if ReqLine.FindLast then
            exit(ReqLine."Order Promising Line No." + 1);

        exit(1);
    end;

    procedure ReassignRefOrderNos(OrderPromisingID: Code[20])
    var
        MfgSetup: Record "Manufacturing Setup";
        RequisitionLine: Record "Requisition Line";
        NoSeriesMgt: Codeunit "No. Series";
        NewRefOrderNo: Code[20];
        LastRefOrderNo: Code[20];
    begin
        RequisitionLine.SetCurrentKey("Ref. Order Type", "Ref. Order Status", "Ref. Order No.", "Ref. Line No.");
        RequisitionLine.SetRange("Order Promising ID", OrderPromisingID);
        RequisitionLine.SetRange("Ref. Order Type", RequisitionLine."Ref. Order Type"::"Prod. Order");
        RequisitionLine.SetRange("Ref. Order Status", RequisitionLine."Ref. Order Status"::Planned);
        RequisitionLine.SetFilter("Ref. Order No.", '<>%1', '');
        if not RequisitionLine.FindLast then
            exit;
        LastRefOrderNo := RequisitionLine."Ref. Order No.";

        MfgSetup.Get();
        MfgSetup.TestField("Planned Order Nos.");

        RequisitionLine.SetFilter("Ref. Order No.", '<>%1&<=%2', '', LastRefOrderNo);
        RequisitionLine.Find('-');
        repeat
            RequisitionLine.SetRange("Ref. Order No.", RequisitionLine."Ref. Order No.");
            RequisitionLine.FindLast;
            NewRefOrderNo := '';
            NewRefOrderNo := NoSeriesMgt.GetNextNo(MfgSetup."Planned Order Nos.", RequisitionLine."Due Date", true);
            RequisitionLine.ModifyAll("Ref. Order No.", NewRefOrderNo);
            RequisitionLine.SetFilter("Ref. Order No.", '<>%1&<=%2', '', LastRefOrderNo);
        until RequisitionLine.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReqLineInsert(var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReqLineModify(var RequisitionLine: Record "Requisition Line")
    begin
    end;

    local procedure GetLocation(LocationCode: Code[10]; var Location: Record Location)
    begin
        if LocationCode = '' then
            Clear(Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    [Scope('OnPrem')]
    procedure CreateReqLinesFromTransfer(TransHeader: Record "Transfer Header"; ShowMessage: Boolean; LineNo: Integer)
    var
        TransLine: Record "Transfer Line";
        TrackingSpecification: Record "Tracking Specification";
        ReqQty: Decimal;
        ReqLine: Record "Requisition Line";
        ReservMgt: Codeunit "Reservation Management EDMS";
        ReserveTransferLine: Codeunit "Transfer Line-Reserve EDMS";
        ReservEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        LineCount: Integer;
        SKU: Record "Stockkeeping Unit";
        GetPlanningParameters: Codeunit "Planning-Get Parameters";
    begin
        if ShowMessage then
            if not Confirm(Text002) then
                exit;

        OrderPromisingSetup.Get;
        OrderPromisingSetup.TestField("Order Promising Template");
        OrderPromisingSetup.TestField("Order Promising Worksheet");

        TransLine.Reset;
        TransLine.SetRange("Document No.", TransHeader."No.");
        TransLine.SetRange("Derived From Line No.", 0);
        if LineNo <> 0 then                                                                                              // 27.03.2014 Elva Baltic P21
            TransLine.SetRange("Line No.", LineNo);                                                                                  // 27.03.2014 Elva Baltic P21
        if TransLine.FindSet then begin
            repeat
                // Need to check if possible to reserve from ILE, PO, etc. (autoreserve) before creating Requisition Line
                TransLine.CalcFields("Reserved Quantity Outbnd.");
                ReqQty := TransLine.Quantity - TransLine."Reserved Quantity Outbnd." - TransLine."Quantity Shipped";
                if ReqQty > 0 then begin
                    CreateReqLine(TransLine."Item No.", TransLine."Variant Code", TransLine."Transfer-from Code", ReqQty, TransLine."Unit of Measure Code", TransLine."Shipment Date", 1, ReqLine);
                    ReqLine."Ref. Order No." := TransLine."Document No.";
                    ReqLine."Ref. Order Type" := ReqLine."ref. order type"::Transfer;
                    ReqLine."Ref. Line No." := TransLine."Line No.";
                    // ReqLine."Accept Action Message" := TRUE;                                                                // 07.04.2014 Elva Baltic P21
                    ReqLine.Modify;

                    ReservMgt.SetReqLine(ReqLine);
                    ReserveTransferLine.SetBinding(ReservEntry.Binding::"Order-to-Order");
                    ReservEntry."Source Type" := Database::"Transfer Line";
                    //22.05.2014 EDMS P8 >>
                    TrackingSpecification.Init;
                    //TrackingSpecification."Source Type" := 2;  //' ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Service,Job'
                    TrackingSpecification."Source Type" := Database::"Requisition Line";  //01.09.2014 EDMS P8
                    TrackingSpecification."Source Subtype" := 0;
                    TrackingSpecification."Source ID" := ReqLine."Worksheet Template Name";
                    TrackingSpecification."Source Batch Name" := ReqLine."Journal Batch Name";
                    TrackingSpecification."Source Prod. Order Line" := 0;
                    TrackingSpecification."Source Ref. No." := ReqLine."Line No.";
                    TrackingSpecification."Variant Code" := ReqLine."Variant Code";
                    TrackingSpecification."Location Code" := ReqLine."Location Code";
                    TrackingSpecification."Serial No." := '';
                    TrackingSpecification."Lot No." := '';
                    TrackingSpecification."Qty. per Unit of Measure" := ReqLine."Qty. per Unit of Measure";

                    ReserveTransferLine.CreateReservationSetFrom(
                      TrackingSpecification);
                    //22.05.2014 EDMS P8 <<
                    //>>DELTA RC
                    // ReserveTransferLine.CreateReservation(
                    //   TransLine,
                    //   ReqLine.Description,
                    //   ReqLine."Due Date",
                    //   ReqQty,
                    //   ReqLine."Quantity (Base)",
                    //   '', '', 0);
                    ReserveTransferLine.CreateReservation(
                      TransLine,
                      ReqLine.Description,
                      ReqLine."Due Date",
                      ReqQty,
                      ReqLine."Quantity (Base)", ReservEntry, 0);

                    //<<DELTA RC

                    LineCount += 1;
                    // 14.02.2019 EB.P30 >>
                    ReqLine.Validate("Ordering Price Type Code", ReqLine.GetReservForInfo(Returnvalue::OrderingPriceType));
                    ReqLine.Modify;
                    // 14.02.2019 EB.P30 <<
                end;
            until TransLine.Next = 0;
            if ShowMessage then
                Message(Text001, LineCount, ReqLine.FieldCaption(ReqLine."Worksheet Template Name"), OrderPromisingSetup."Order Promising Template",
                  ReqLine.FieldCaption(ReqLine."Journal Batch Name"), OrderPromisingSetup."Order Promising Worksheet");
        end;
    end;


    procedure CreateReqLineFromSalesLine(SalesLine: Record "Sales Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        ReqQty: Decimal;
        ReqLine: Record "Requisition Line";
        ReservMgt: Codeunit "Reservation Management EDMS";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        ReservEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        LineCount: Integer;
        SKU: Record "Stockkeeping Unit";
        GetPlanningParameters: Codeunit "Planning-Get Parameters";
    begin
        if not Confirm(Text002) then
            exit;

        OrderPromisingSetup.Get;
        OrderPromisingSetup.TestField("Order Promising Template");
        OrderPromisingSetup.TestField("Order Promising Worksheet");

        SalesLine.CalcFields("Reserved Quantity");
        ReqQty := SalesLine.Quantity - SalesLine."Reserved Quantity" - SalesLine."Quantity Shipped";
        if ReqQty > 0 then begin
            CreateReqLine(SalesLine."No.", SalesLine."Variant Code", SalesLine."Location Code", ReqQty, SalesLine."Unit of Measure Code", SalesLine."Shipment Date", 1, ReqLine);
            ReqLine."Ref. Order No." := SalesLine."Document No.";
            ReqLine."Ref. Order Type" := ReqLine."ref. order type"::Purchase;
            ReqLine."Ref. Line No." := SalesLine."Line No.";
            ReqLine.Modify;

            ReservMgt.SetReqLine(ReqLine);
            ReserveSalesLine.SetBinding(ReservEntry.Binding::"Order-to-Order");
            ReservEntry."Source Type" := Database::"Sales Line";
            TrackingSpecification.Init;
            TrackingSpecification."Source Type" := Database::"Requisition Line";
            TrackingSpecification."Source Subtype" := 0;
            TrackingSpecification."Source ID" := ReqLine."Worksheet Template Name";
            TrackingSpecification."Source Batch Name" := ReqLine."Journal Batch Name";
            TrackingSpecification."Source Prod. Order Line" := 0;
            TrackingSpecification."Source Ref. No." := ReqLine."Line No.";
            TrackingSpecification."Variant Code" := ReqLine."Variant Code";
            TrackingSpecification."Location Code" := ReqLine."Location Code";
            TrackingSpecification."Serial No." := '';
            TrackingSpecification."Lot No." := '';
            TrackingSpecification."Qty. per Unit of Measure" := ReqLine."Qty. per Unit of Measure";

            ReserveSalesLine.CreateReservationSetFrom(
               TrackingSpecification);


            //>>DELTA RC
            // ReserveSalesLine.CreateReservation(
            //    SalesLine,
            //    ReqLine.Description,
            //    ReqLine."Due Date",
            //    ReqQty,
            //    ReqLine."Quantity (Base)",
            //    '', '');

            ReserveSalesLine.CreateReservation(
                               SalesLine,
                               ReqLine.Description,
                               ReqLine."Due Date",
                               ReqQty,
                               ReqLine."Quantity (Base)", ReservEntry);

            //<<DELTA RC

            LineCount += 1;
            ReqLine.Validate("Ordering Price Type Code", ReqLine.GetReservForInfo(Returnvalue::OrderingPriceType));
            ReqLine.Modify;
        end;
        Message(Text001, LineCount, ReqLine.FieldCaption(ReqLine."Worksheet Template Name"), OrderPromisingSetup."Order Promising Template",
            ReqLine.FieldCaption(ReqLine."Journal Batch Name"), OrderPromisingSetup."Order Promising Worksheet");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AvailabilityManagement, 'OnAfterCaseCalcCapableToPromise', '', false, false)]
    local procedure CalcCapableToPromiseServiceEDMS(var OrderPromisingLine: Record "Order Promising Line"; var CompanyInfo: Record "Company Information"; var OrderPromisingID: Code[20]; var LastValidLine: Integer);
    var
        ServiceLine2: Record "Service Line EDMS";
        CapableToPromise: codeunit "Capable to Promise";
        QtyReservedTotal: Decimal;
        OldCTPQty: Decimal;
        FeasibleDate: Date;
    begin
        case OrderPromisingLine."Source Type" of
            OrderPromisingLine."Source Type"::"Service Order EDMS":
                begin
                    Clear(OrderPromisingLine."Earliest Shipment Date");
                    Clear(OrderPromisingLine."Planned Delivery Date");
                    ServiceLine2.Get(OrderPromisingLine."Source Subtype", OrderPromisingLine."Source ID", OrderPromisingLine."Source Line No.");
                    ServiceLine2.CalcFields("Reserved Quantity");
                    QtyReservedTotal := ServiceLine2."Reserved Quantity";
                    CapableToPromise.RemoveReqLines(ServiceLine2."Document No.", ServiceLine2."Line No.", 0, false);
                    ServiceLine2.CalcFields("Reserved Quantity");
                    OldCTPQty := QtyReservedTotal - ServiceLine2."Reserved Quantity";
                    FeasibleDate :=
                      CapableToPromise.CalcCapableToPromiseDate(
                        OrderPromisingLine."Item No.", OrderPromisingLine."Variant Code", OrderPromisingLine."Location Code",
                        OrderPromisingLine."Original Shipment Date",
                        OrderPromisingLine."Unavailable Quantity" + OldCTPQty, OrderPromisingLine."Unit of Measure Code",
                        OrderPromisingID, OrderPromisingLine."Source Line No.",
                        LastValidLine, CompanyInfo."Check-Avail. Time Bucket",
                        CompanyInfo."Check-Avail. Period Calc.");
                    if FeasibleDate <> OrderPromisingLine."Original Shipment Date" then
                        OrderPromisingLine.Validate("Earliest Shipment Date", FeasibleDate)
                    else
                        OrderPromisingLine.Validate("Earliest Shipment Date", OrderPromisingLine."Original Shipment Date");
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AvailabilityManagement, 'OnCreateReservationsAfterFirstCASE', '', false, false)]
    local procedure CreateReservationsServiceEDMSForRequisitionFirstCase(var OrderPromisingLine: Record "Order Promising Line"; var NeededQty: Decimal; var NeededQtyBase: Decimal);
    var
        ServiceLine2: Record "Service Line EDMS";
    begin
        case OrderPromisingLine."Source Type" of
            OrderPromisingLine."Source Type"::"Service Order EDMS":
                begin
                    ServiceLine2.Get(OrderPromisingLine."Source Subtype",
                                          OrderPromisingLine."Source ID", OrderPromisingLine."Source Line No.");

                    ServiceLine2.CalcFields("Reserved Quantity", "Reserved Qty. (Base)");
                    NeededQty := ServiceLine2."Outstanding Quantity" - ServiceLine2."Reserved Quantity";
                    NeededQtyBase := ServiceLine2."Outstanding Qty. (Base)" - ServiceLine2."Reserved Qty. (Base)";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AvailabilityManagement, 'OnCreateReservationsAfterSecondCASE', '', false, false)]
    local procedure CreateReservationsServiceEDMSForRequisitionSecondCase(var OrderPromisingLine: Record "Order Promising Line"; var ReqLine: Record "Requisition Line"; var ReservQty: Decimal; var ReservQtyBase: Decimal);
    var
        ServiceLine2: Record "Service Line EDMS";
        TempServiceLine: Record "Service Line EDMS" temporary;
        ReservMgt: Codeunit "Reservation Management";
        FullAutoReservation: Boolean;
        SourceRecRef: RecordRef;
    begin
        case OrderPromisingLine."Source Type" of
            OrderPromisingLine."Source Type"::"Service Order EDMS":
                begin
                    ServiceLine2.Get(OrderPromisingLine."Source Subtype",
                                          OrderPromisingLine."Source ID", OrderPromisingLine."Source Line No.");
                    if (ServiceLine2.Reserve = ServiceLine2.Reserve::Never) and not ServiceLine2."Drop Shipment" then begin
                        ServiceLine2.Reserve := ServiceLine2.Reserve::Optional;
                        ServiceLine2.Modify();
                        TempServiceLine := ServiceLine2;
                        if TempServiceLine.Insert() then;
                    end;
                    BindToRequisition(ServiceLine2, ReqLine, ReservQty, ReservQtyBase);

                    ServiceLine2.CalcFields("Reserved Quantity", "Reserved Qty. (Base)");
                    if ServiceLine2.Quantity <> ServiceLine2."Reserved Quantity" then begin
                        SourceRecRef.GetTable(ServiceLine2);
                        ReservMgt.SetReservSource(SourceRecRef);
                        ReservMgt.AutoReserve(
                          FullAutoReservation, '', ServiceLine2."Shipment Date",
                          ServiceLine2.Quantity - ServiceLine2."Reserved Quantity",
                          ServiceLine2."Quantity (Base)" - ServiceLine2."Reserved Qty. (Base)");
                    end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Order Promising Line", 'OnAfterValidateEvent', 'Earliest Shipment Date', false, false)]

    local procedure UpdateEarliestShipmentDateFromService(CurrFieldNo: Integer; var Rec: Record "Order Promising Line"; var xRec: Record "Order Promising Line")
    var
        ServiceLine: Record "Service Line EDMS";
    begin
        case Rec."Source Type" of
            Rec."Source Type"::"Service Order EDMS":
                if Rec."Earliest Shipment Date" <> 0D then begin
                    ServiceLine.Get(Rec."Source Subtype", Rec."Source ID", Rec."Source Line No.");
                    ServiceLine.SuspendStatusCheck(true);
                    ServiceLine.Validate("Shipment Date", Rec."Earliest Shipment Date");
                    Rec."Planned Delivery Date" := ServiceLine."Planned Delivery Date";
                end;
        end;
    end;

    procedure BindToRequisition(ServiceLine: Record "Service Line EDMS"; ReqLine: Record "Requisition Line"; ReservQty: Decimal; ReservQtyBase: Decimal)
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservationEntry: Record "Reservation Entry";
    begin
        if ServiceLine.Reserve = ServiceLine.Reserve::Never then
            exit;
        ServiceLineEDMSReserve.SetBinding(ReservationEntry.Binding::"Order-to-Order");
        TrackingSpecification.InitTrackingSpecification(
          DATABASE::"Requisition Line",
          0, ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name", 0, ReqLine."Line No.",
          ReqLine."Variant Code", ReqLine."Location Code", ReqLine."Qty. per Unit of Measure");
        ServiceLineEDMSReserve.CreateReservationSetFrom(TrackingSpecification);
        CreateBindingReservation(ServiceLine, ReqLine.Description, ReqLine."Due Date", ReservQty, ReservQtyBase);
    end;

    procedure CreateBindingReservation(ServiceLine: Record "Service Line EDMS"; Description: Text[100]; ExpectedReceiptDate: Date; Quantity: Decimal; QuantityBase: Decimal)
    var
        DummyReservEntry: Record "Reservation Entry";
    begin
        ServiceLineEDMSReserve.CreateReservation(ServiceLine, Description, ExpectedReceiptDate, Quantity, QuantityBase, DummyReservEntry);
    end;
}

