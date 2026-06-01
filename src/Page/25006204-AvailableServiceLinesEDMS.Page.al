Page 25006204 "Available - Service Lines EDMS"
{
    // 02.06.2014 EDMS P8
    //   * merge stuff

    Caption = 'Available - Service Lines';
    DataCaptionExpression = CaptionText;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions = TableData "Service Line" = rm;
    SourceTable = "Service Line EDMS";
    SourceTableView = sorting(Type, "No.", "Variant Code", "Location Code", "Document Type", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(OutstandingQtyBase; Rec."Outstanding Qty. (Base)")
                {
                    ApplicationArea = Basic;
                }
                field(ReservedQtyBase; Rec."Reserved Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(QtyToReserveBase; QtyToReserveBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Available Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field(ReservedThisLineCntrl; ReservedThisLine)
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Reserved Quantity';
                    DecimalPlaces = 0 : 5;

                    trigger OnDrillDown()
                    begin
                        ReservEntry2.Reset;
                        ReserveServLine.FilterReservFor(ReservEntry2, Rec);
                        ReservEntry2.SetRange("Reservation Status", ReservEntry2."reservation status"::Reservation);
                        ReservationMgtEDMS.MarkReservConnection(ReservEntry2, ReservEntry);
                        Page.RunModal(Page::"Reservation Entries", ReservEntry2);
                        UpdateReservFrom;
                        CurrPage.Update;
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Reserve)
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        ReservEntry.LockTable;
                        UpdateReservMgt;
                        ReservationMgtEDMS.ServiceLineEDMSUpdateValues(Rec, QtyToReserve, QtyReservedThisLine);
                        ReservationMgtEDMS.CalculateRemainingQty(NewQtyReservedThisLine, NewQtyReservedThisLineBase);
                        ReservationMgtEDMS.CopySign(NewQtyReservedThisLine, QtyToReserve);
                        if NewQtyReservedThisLine <> 0 then
                            if Abs(NewQtyReservedThisLine) > Abs(QtyToReserve) then
                                CreateReservation(QtyToReserve, QtyToReserveBase)
                            else
                                CreateReservation(NewQtyReservedThisLine, NewQtyReservedThisLineBase)
                        else
                            Error(Text000);
                    end;
                }
                action(CancelReservation)
                {
                    ApplicationArea = Basic;
                    Caption = '&Cancel Reservation';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        if not Confirm(Text001, false) then
                            exit;

                        ReservEntry2.Copy(ReservEntry);
                        ReserveServLine.FilterReservFor(ReservEntry2, Rec);

                        if ReservEntry2.Find('-') then begin
                            UpdateReservMgt;
                            repeat
                                ReservEngineMgt.CloseReservEntry(ReservEntry2, true, false);  //02.06.2014 EDMS P8
                            until ReservEntry2.Next = 0;

                            UpdateReservFrom;
                        end;
                    end;
                }
                action(ShowDocument)
                {
                    ApplicationArea = Basic;
                    Caption = '&Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        ServHeader.Get(Rec."Document Type", Rec."Document No.");
                        case Rec."Document Type" of
                            Rec."document type"::Quote:
                                Page.Run(Page::"Service Quote EDMS", ServHeader);
                            Rec."document type"::Order:
                                Page.Run(Page::"Service Order EDMS", ServHeader);
                            Rec."document type"::"Return Order":
                                Page.Run(Page::"Service Return Order EDMS", ServHeader);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ReservationMgtEDMS.ServiceLineEDMSUpdateValues(Rec, QtyToReserve, QtyReservedThisLine);
    end;

    trigger OnOpenPage()
    begin
        ReservEntry.TestField("Source Type");

        Rec.SetRange("Document Type", CurrentSubType);
        Rec.SetRange(Type, rec.Type::Item);
        Rec.SetRange("No.", ReservEntry."Item No.");
        Rec.SetRange("Variant Code", ReservEntry."Variant Code");
        Rec.SetRange("Job No.", '');
        Rec.SetRange("Drop Shipment", false);
        Rec.SetRange("Location Code", ReservEntry."Location Code");

        Rec.SetFilter("Planned Service Date", ReservationMgtEDMS.GetAvailabilityFilter(ReservEntry."Shipment Date"));

        case CurrentSubType of
            1:
                if ReservationMgtEDMS.IsPositive() then
                    Rec.SetFilter("Quantity (Base)", '<0')
                else
                    Rec.SetFilter("Quantity (Base)", '>0');
            2:
                if not ReservationMgtEDMS.IsPositive() then
                    Rec.SetFilter("Quantity (Base)", '<0')
                else
                    Rec.SetFilter("Quantity (Base)", '>0');
        end;

        if ServSpecEDMS then begin
            Rec.SetRange("Document Type", ServSpecDocType);
            Rec.SetRange("Document No.", ServSpecDocNo);
        end;
    end;

    var
        Text000: label 'Fully reserved.';
        Text001: label 'Do you want to cancel the reservation?';
        Text002: label 'The available quantity is %1.';
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        ServHeader: Record "Service Header EDMS";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ReqLine: Record "Requisition Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningComponent: Record "Planning Component";
        TransLine: Record "Transfer Line";
        ServiceLine: Record "Service Line EDMS";
        JobPlanningLine: Record "Job Planning Line";
        AssemblyLine: Record "Assembly Line";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
        AssemblyHeaderReserve: Codeunit "Assembly Header-Reserve";
        //ReservMgt: Codeunit "Reservation Management";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        ReserveReqLine: Codeunit "Req. Line-Reserve";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
        ReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        ReserveProdOrderComp: Codeunit "Prod. Order Comp.-Reserve";
        ReservePlanningComponent: Codeunit "Plng. Component-Reserve";
        ReserveTransLine: Codeunit "Transfer Line-Reserve";
        ReserveServLine: Codeunit "Service Line EDMS-Reserve";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        QtyReservedThisLine: Decimal;
        QtyReservedThisLineBase: Decimal;
        NewQtyReservedThisLine: Decimal;
        NewQtyReservedThisLineBase: Decimal;
        CaptionText: Text[80];
        CurrentSubType: Option;
        ServSpecEDMS: Boolean;
        ServSpecDocType: Integer;
        ServSpecDocNo: Code[20];
        ReserveServiceLineEDMS: Codeunit "Service Line EDMS-Reserve";
        SourceRecRef: RecordRef;

    procedure SetSource(CurrentSourceRecRef: RecordRef; CurrentReservEntry: Record "Reservation Entry"; Direction: Enum "Transfer Direction")
    begin
        Clear(ReservationMgtEDMS);

        SourceRecRef := CurrentSourceRecRef;
        ReservEntry := CurrentReservEntry;

        ReservationMgtEDMS.TestItemType(SourceRecRef);
        ReservationMgtEDMS.SetReservSource(SourceRecRef, Direction);
        CaptionText := ReservationMgtEDMS.FilterReservFor(SourceRecRef, ReservEntry, Direction);
    end;


    procedure SetSalesLine(var CurrentSalesLine: Record "Sales Line"; CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentSalesLine.TestField(Type, CurrentSalesLine.Type::Item);
        SalesLine := CurrentSalesLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetSalesLine(SalesLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        SalesLine.SetReservationFilters(ReservEntry);
        CaptionText := ReserveSalesLine.Caption(SalesLine);
    end;


    procedure SetReqLine(var CurrentReqLine: Record "Requisition Line"; CurrentReservEntry: Record "Reservation Entry")
    begin
        ReqLine := CurrentReqLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetReqLine(ReqLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        ReqLine.SetReservationFilters(ReservEntry);
        CaptionText := ReserveReqLine.Caption(ReqLine);
    end;


    procedure SetPurchLine(var CurrentPurchLine: Record "Purchase Line"; CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentPurchLine.TestField(Type, CurrentPurchLine.Type::Item);
        PurchLine := CurrentPurchLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetPurchLine(PurchLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        PurchLine.SetReservationFilters(ReservEntry);
        CaptionText := ReservePurchLine.Caption(PurchLine);
    end;


    procedure SetItemJnlLine(var CurrentItemJnlLine: Record "Item Journal Line"; CurrentReservEntry: Record "Reservation Entry")
    begin
        ItemJnlLine := CurrentItemJnlLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetItemJnlLine(ItemJnlLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        ItemJnlLine.SetReservationFilters(ReservEntry);
        //ReserveItemJnlLine.FilterReservFor(ReservEntry, ItemJnlLine);
        CaptionText := ReserveItemJnlLine.Caption(ItemJnlLine);
    end;


    procedure SetProdOrderLine(var CurrentProdOrderLine: Record "Prod. Order Line"; CurrentReservEntry: Record "Reservation Entry")
    begin
        ProdOrderLine := CurrentProdOrderLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetProdOrderLine(ProdOrderLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        // ReserveProdOrderLine.FilterReservFor(ReservEntry, ProdOrderLine);
        ProdOrderLine.SetReservationFilters(ReservEntry);
        CaptionText := ReserveProdOrderLine.Caption(ProdOrderLine);
    end;


    procedure SetProdOrderComponent(var CurrentProdOrderComp: Record "Prod. Order Component"; CurrentReservEntry: Record "Reservation Entry")
    begin
        ProdOrderComp := CurrentProdOrderComp;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetProdOrderComponent(ProdOrderComp);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        //ReserveProdOrderComp.FilterReservFor(ReservEntry, ProdOrderComp);
        ProdOrderComp.SetReservationFilters(ReservEntry);
        CaptionText := ReserveProdOrderComp.Caption(ProdOrderComp);
    end;


    procedure SetPlanningComponent(var CurrentPlanningComponent: Record "Planning Component"; CurrentReservEntry: Record "Reservation Entry")
    begin
        PlanningComponent := CurrentPlanningComponent;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetPlanningComponent(PlanningComponent);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        //ReservePlanningComponent.FilterReservFor(ReservEntry, PlanningComponent);
        PlanningComponent.SetReservationFilters(ReservEntry);
        CaptionText := ReservePlanningComponent.Caption(PlanningComponent);
    end;


    procedure SetTransferLine(var CurrentTransLine: Record "Transfer Line"; CurrentReservEntry: Record "Reservation Entry"; Direction: Option Outbound,Inbound)
    begin
        TransLine := CurrentTransLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetTransferLine(TransLine, Direction);
        ReservationMgtEDMS.GetServiceReserv(ServSpecEDMS, ServSpecDocType, ServSpecDocNo);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        //ReserveTransLine.FilterReservFor(ReservEntry, TransLine, Direction);
        TransLine.SetReservationFilters(ReservEntry, Direction);
        CaptionText := ReserveTransLine.Caption(TransLine);
    end;


    procedure SetJobPlanningLine(var CurrentJobPlanningLine: Record "Job Planning Line"; CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentJobPlanningLine.TestField(Type, CurrentJobPlanningLine.Type::Item);
        JobPlanningLine := CurrentJobPlanningLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetJobPlanningLine(JobPlanningLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        // JobPlanningLineReserve.FilterReservFor(ReservEntry, JobPlanningLine);
        JobPlanningLine.SetReservationFilters(ReservEntry);
        CaptionText := JobPlanningLineReserve.Caption(JobPlanningLine);
    end;


    procedure CreateReservation(ReserveQuantity: Decimal; ReserveQuantityBase: Decimal)
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        if Abs(Rec."Outstanding Qty. (Base)") + Rec."Reserved Qty. (Base)" < ReserveQuantityBase then
            Error(Text002, Abs(Rec."Outstanding Qty. (Base)") + Rec."Reserved Qty. (Base)");

        Rec.TestField(Type, Rec.Type::Item);
        Rec.TestField("No.", ReservEntry."Item No.");
        Rec.TestField("Variant Code", ReservEntry."Variant Code");
        Rec.TestField("Location Code", ReservEntry."Location Code");

        TrackingSpecification.Init;
        TrackingSpecification."Source Type" := Database::"Service Line EDMS";
        TrackingSpecification."Source Subtype" := Rec."Document Type";
        TrackingSpecification."Source ID" := Rec."Document No.";
        TrackingSpecification."Source Batch Name" := '';
        TrackingSpecification."Source Prod. Order Line" := 0;
        TrackingSpecification."Source Ref. No." := Rec."Line No.";
        TrackingSpecification."Variant Code" := Rec."Variant Code";
        TrackingSpecification."Location Code" := Rec."Location Code";
        TrackingSpecification."Serial No." := '';
        TrackingSpecification."Lot No." := '';
        TrackingSpecification."Qty. per Unit of Measure" := Rec."Qty. per Unit of Measure";
        ReservationMgtEDMS.CreateReservation(
          ReservEntry.Description,
          Rec."Posting Date",
          ReserveQuantity,
          ReserveQuantityBase,
          TrackingSpecification);

        UpdateReservFrom;
        /*
        IF ABS("Outstanding Qty. (Base)") + "Reserved Qty. (Base)" < ReserveQuantity THEN
          ERROR(Text002,ABS("Outstanding Qty. (Base)") + "Reserved Qty. (Base)");
        
        TESTFIELD("Job No.",'');
        TESTFIELD("Drop Shipment",FALSE);
        TESTFIELD("No.",ReservEntry."Item No.");
        TESTFIELD("Variant Code",ReservEntry."Variant Code");
        TESTFIELD("Location Code",ReservEntry."Location Code");
        
        ReservMgt.CreateReservation(
          ReservEntry.Description,
          "Planned Service Date",
          ReserveQuantity,
          DATABASE::"Service Line EDMS",
          "Document Type",
          "Document No.",
          '',
          0,
          "Line No.",
          "Variant Code",
          "Location Code",
          '',
          '',
          "Qty. per Unit of Measure");
        
        UpdateReservFrom;
        */

    end;


    procedure UpdateReservFrom()
    begin
        case ReservEntry."Source Type" of
            Database::"Sales Line":
                begin
                    SalesLine.Find;
                    SetSalesLine(SalesLine, ReservEntry);
                end;
            Database::"Requisition Line":
                begin
                    ReqLine.Find;
                    SetReqLine(ReqLine, ReservEntry);
                end;
            Database::"Purchase Line":
                begin
                    PurchLine.Find;
                    SetPurchLine(PurchLine, ReservEntry);
                end;
            Database::"Prod. Order Line":
                begin
                    ProdOrderLine.Find;
                    SetProdOrderLine(ProdOrderLine, ReservEntry);
                end;
            Database::"Prod. Order Component":
                begin
                    ProdOrderComp.Find;
                    SetProdOrderComponent(ProdOrderComp, ReservEntry);
                end;
            Database::"Planning Component":
                begin
                    PlanningComponent.Find;
                    SetPlanningComponent(PlanningComponent, ReservEntry);
                end;
            Database::"Transfer Line":
                begin
                    TransLine.Find;
                    SetTransferLine(TransLine, ReservEntry, ReservEntry."Source Subtype");
                end;
            Database::"Job Planning Line":
                begin
                    JobPlanningLine.Find;
                    SetJobPlanningLine(JobPlanningLine, ReservEntry);
                end;
        end;
    end;


    procedure UpdateReservMgt()
    begin
        Clear(ReservationMgtEDMS);
        case ReservEntry."Source Type" of
            Database::"Sales Line":
                ReservationMgtEDMS.SetSalesLine(SalesLine);
            Database::"Requisition Line":
                ReservationMgtEDMS.SetReqLine(ReqLine);
            Database::"Purchase Line":
                ReservationMgtEDMS.SetPurchLine(PurchLine);
            Database::"Item Journal Line":
                ReservationMgtEDMS.SetItemJnlLine(ItemJnlLine);
            Database::"Prod. Order Line":
                ReservationMgtEDMS.SetProdOrderLine(ProdOrderLine);
            Database::"Prod. Order Component":
                ReservationMgtEDMS.SetProdOrderComponent(ProdOrderComp);
            Database::"Planning Component":
                ReservationMgtEDMS.SetPlanningComponent(PlanningComponent);
            Database::"Transfer Line":
                ReservationMgtEDMS.SetTransferLine(TransLine, ReservEntry."Source Subtype");
        end;
    end;


    procedure ReservedThisLine(): Decimal
    begin
        ReservEntry2.Reset;
        ReserveServLine.FilterReservFor(ReservEntry2, Rec);
        ReservEntry2.SetRange("Reservation Status", ReservEntry2."reservation status"::Reservation);
        exit(ReservationMgtEDMS.MarkReservConnection(ReservEntry2, ReservEntry));
    end;


    procedure SetCurrentSubType(SubType: Option)
    begin
        CurrentSubType := SubType;
    end;


    procedure SetAssemblyLine(var CurrentAsmLine: Record "Assembly Line"; CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentAsmLine.TestField(Type, CurrentAsmLine.Type::Item);
        AssemblyLine := CurrentAsmLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetAssemblyLine(AssemblyLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        AssemblyLineReserve.FilterReservFor(ReservEntry, AssemblyLine);
        CaptionText := AssemblyLineReserve.Caption(AssemblyLine);
    end;


    procedure SetAssemblyHeader(var CurrentAsmHeader: Record "Assembly Header"; CurrentReservEntry: Record "Reservation Entry")
    begin
        AssemblyHeader := CurrentAsmHeader;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetAssemblyHeader(AssemblyHeader);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        AssemblyHeaderReserve.FilterReservFor(ReservEntry, AssemblyHeader);
        CaptionText := AssemblyHeaderReserve.Caption(AssemblyHeader);
    end;


    procedure SetServiceLineEDMS(var CurrentServiceLine: Record "Service Line EDMS"; CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentServiceLine.TestField(Type, CurrentServiceLine.Type::Item);
        ServiceLine := CurrentServiceLine;
        ReservEntry := CurrentReservEntry;

        Clear(ReservationMgtEDMS);
        ReservationMgtEDMS.SetServLineEDMS(ServiceLine);
        //ReservMgt.GetServiceReserv(ServSpecEDMS,ServSpecDocType,ServSpecDocNo);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, true);
        ReserveServiceLineEDMS.FilterReservFor(ReservEntry, ServiceLine);
        CaptionText := ReserveServiceLineEDMS.Caption(ServiceLine);
        //wwww
        //CurrentSalesLine.TESTFIELD(Type,CurrentSalesLine.Type::Item);
        //SalesLine := CurrentSalesLine;
        //ReservEntry := CurrentReservEntry;

        //CLEAR(ReservMgt);
        //ReservMgt.SetSalesLine(SalesLine);
        //ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
        //ReserveSalesLine.FilterReservFor(ReservEntry,SalesLine);
        //CaptionText := ReserveSalesLine.Caption(SalesLine);
    end;
}

