Page 25006529 "Vehicle Reservation"
{
    Caption = 'Vehicle Reservation';
    DataCaptionExpression = CaptionText;
    DeleteAllowed = false;
    PageType = Worksheet;
    SourceTable = "Vehicle Reserv. Entry Summary";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(MakeCode; ReservEntry."Make Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Make Code';
                    Editable = false;
                }
                field(ModelCode; ReservEntry."Model Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Model Code';
                    Editable = false;
                }
                field(ModelVersionNo; ReservEntry."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Model Version No.';
                    Editable = false;
                }
                field(VehicleSerialNo; ReservEntry."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Serial No.';
                    Editable = false;
                }
                field(LocationCode; ReservEntry."Location Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Location Code';
                    Editable = false;
                }
                field(QtyToReserveBase; QtyToReserveBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity to Reserve';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field(QtyReservedBase; QtyReservedBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reserved Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field(UnreservedQuantity; QtyToReserveBase - QtyReservedBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unreserved Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
            }
            repeater(Control1)
            {
                Editable = false;
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceBatchName; Rec."Source Batch Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceRefNo; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Reserved; Rec.Reserved)
                {
                    ApplicationArea = Basic;
                }
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
                action("Auto Reserve")
                {
                    ApplicationArea = Basic;
                    Caption = '&Auto Reserve';
                    Image = AutoReserve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        AutoReserve;
                    end;
                }
                action(ReservefromCurrentLine)
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve from Current Line';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        ReservMgt.AutoReserveOneLine(Rec);
                        UpdateReservFrom;
                    end;
                }
                action(CancelReservation)
                {
                    ApplicationArea = Basic;
                    Caption = '&Cancel Reservation';
                    Image = Cancel;

                    trigger OnAction()
                    var
                        ReservEntry3: Record "Vehicle Reservation Entry";
                        RecordsFound: Boolean;
                    begin
                        Clear(ReservEntry2);
                        ReservEntry2 := ReservEntry;
                        ReservMgt.SetPointerFilter(ReservEntry2);
                        if ReservEntry2.FindSet then
                            repeat
                                ReservEntry3.Get(ReservEntry2."Entry No.", not ReservEntry2.Positive);
                                if RelatesToSummEntry(ReservEntry3, Rec) then begin
                                    ReservEngineMgt.CloseReservEntry2(ReservEntry2);
                                    RecordsFound := true;
                                end;
                            until ReservEntry2.Next = 0;

                        if RecordsFound then
                            UpdateReservFrom
                        else
                            Error(Text005);
                    end;
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        ReservSummEntry := Rec;
        if not ReservSummEntry.Find(Which) then
            exit(false);
        Rec := ReservSummEntry;
        Rec.CalcFields(Reserved);
        exit(true);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        ReservSummEntry := Rec;
        CurrentSteps := ReservSummEntry.Next(Steps);
        if CurrentSteps <> 0 then
            Rec := ReservSummEntry;
        Rec.CalcFields(Reserved);
        exit(CurrentSteps);
    end;

    trigger OnOpenPage()
    begin
        FormIsOpen := true;
        ReservEntry.CalcFields("Make Code", "Model Code");
    end;

    var
        Text000: label 'Fully reserved.';
        Text001: label 'Full automatic Reservation not possible.\Reserve manually.';
        Text002: label 'There is nothing available to reserve.';
        Text003: label 'Do you want to cancel all reservations in the %1?';
        Text005: label 'There are no reservations to cancel.';
        ReservEntry: Record "Vehicle Reservation Entry";
        ReservEntry2: Record "Vehicle Reservation Entry";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ReqLine: Record "Requisition Line";
        TransLine: Record "Transfer Line";
        ReservSummEntry: Record "Vehicle Reserv. Entry Summary" temporary;
        ReservMgt: Codeunit "Veh. Reservation Management";
        ReservEngineMgt: Codeunit "Veh. Reservation Engine Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        ReserveReqLine: Codeunit "Req. Line-Reserve";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
        ReserveTransLine: Codeunit "Transfer Line-Reserve";
        CreateReservEntry: Codeunit "Create Veh. Reserv. Entry";
        CurrentSteps: Integer;
        CaptionText: Text[130];
        FormIsOpen: Boolean;
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        QtyReserved: Decimal;
        QtyReservedBase: Decimal;
        QtyPerUOM: Decimal;
        FullAutoReservation: Boolean;


    procedure SetSalesLine(var CurrentSalesLine: Record "Sales Line")
    begin
        CurrentSalesLine.TestField("Job No.", '');
        CurrentSalesLine.TestField("Drop Shipment", false);
        CurrentSalesLine.TestField(Type, CurrentSalesLine.Type::Item);
        CurrentSalesLine.TestField("Shipment Date");

        SalesLine := CurrentSalesLine;
        ReservEntry."Source Type" := Database::"Sales Line";
        ReservEntry."Source Subtype" := SalesLine."Document Type";
        ReservEntry."Source ID" := SalesLine."Document No.";
        ReservEntry."Source Ref. No." := SalesLine."Line No.";

        ReservEntry."Model Version No." := SalesLine."No.";
        ReservEntry."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
        ReservEntry."Location Code" := SalesLine."Location Code";

        CaptionText := ReserveSalesLine.Caption(SalesLine);
        UpdateReservFrom;
    end;


    procedure SetReqLine(var CurrentReqLine: Record "Requisition Line")
    begin
        CurrentReqLine.TestField("Sales Order No.", '');
        CurrentReqLine.TestField("Sales Order Line No.", 0);
        CurrentReqLine.TestField("Sell-to Customer No.", '');
        CurrentReqLine.TestField(Type, CurrentReqLine.Type::Item);
        CurrentReqLine.TestField("Model Version No.");

        ReqLine := CurrentReqLine;

        ReservEntry."Source Type" := Database::"Requisition Line";
        ReservEntry."Source ID" := ReqLine."Worksheet Template Name";
        ReservEntry."Source Batch Name" := ReqLine."Journal Batch Name";
        ReservEntry."Source Ref. No." := ReqLine."Line No.";

        ReservEntry."Model Version No." := ReqLine."No.";
        ReservEntry."Vehicle Serial No." := ReqLine."Vehicle Serial No.";
        ReservEntry."Location Code" := ReqLine."Location Code";

        CaptionText := ReserveReqLine.Caption(ReqLine);
        UpdateReservFrom;
    end;


    procedure SetPurchLine(var CurrentPurchLine: Record "Purchase Line")
    begin
        CurrentPurchLine.TestField("Job No.", '');
        CurrentPurchLine.TestField("Drop Shipment", false);
        CurrentPurchLine.TestField(Type, CurrentPurchLine.Type::Item);
        CurrentPurchLine.TestField("Expected Receipt Date");

        PurchLine := CurrentPurchLine;
        ReservEntry."Source Type" := Database::"Purchase Line";
        ReservEntry."Source Subtype" := PurchLine."Document Type";
        ReservEntry."Source ID" := PurchLine."Document No.";
        ReservEntry."Source Ref. No." := PurchLine."Line No.";

        ReservEntry."Model Version No." := PurchLine."No.";
        ReservEntry."Vehicle Serial No." := PurchLine."Vehicle Serial No.";
        ReservEntry."Location Code" := PurchLine."Location Code";

        CaptionText := ReservePurchLine.Caption(PurchLine);
        UpdateReservFrom;
    end;


    procedure SetItemJnlLine(var CurrentItemJnlLine: Record "Item Journal Line")
    begin
        CurrentItemJnlLine.TestField("Drop Shipment", false);
        CurrentItemJnlLine.TestField("Posting Date");

        ItemJnlLine := CurrentItemJnlLine;
        ReservEntry."Source Type" := Database::"Item Journal Line";
        ReservEntry."Source Subtype" := ItemJnlLine."Entry Type";
        ReservEntry."Source ID" := ItemJnlLine."Journal Template Name";
        ReservEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
        ReservEntry."Source Ref. No." := ItemJnlLine."Line No.";

        ReservEntry."Model Version No." := ItemJnlLine."Item No.";
        ReservEntry."Vehicle Serial No." := ItemJnlLine."Vehicle Serial No.";
        ReservEntry."Location Code" := ItemJnlLine."Location Code";

        CaptionText := ReserveItemJnlLine.Caption(ItemJnlLine);
        UpdateReservFrom;
    end;


    procedure SetTransLine(CurrentTransLine: Record "Transfer Line"; Direction: Option Outbound,Inbound)
    begin
        ClearAll;

        TransLine := CurrentTransLine;
        ReservEntry."Source Type" := Database::"Transfer Line";
        ReservEntry."Source Subtype" := Direction;
        ReservEntry."Source ID" := CurrentTransLine."Document No.";
        ReservEntry."Source Ref. No." := CurrentTransLine."Line No.";

        ReservEntry."Model Version No." := CurrentTransLine."Item No.";
        ReservEntry."Vehicle Serial No." := CurrentTransLine."Vehicle Serial No.";
        case Direction of
            Direction::Outbound:
                begin
                    ReservEntry."Location Code" := CurrentTransLine."Transfer-from Code";
                end;
            Direction::Inbound:
                begin
                    ReservEntry."Location Code" := CurrentTransLine."Transfer-to Code";
                end;
        end;

        CaptionText := ReserveTransLine.Caption(TransLine);
        UpdateReservFrom;
    end;


    procedure SetReservEntry(ReservEntry2: Record "Vehicle Reservation Entry")
    begin
        ReservEntry := ReservEntry2;
        UpdateReservMgt;
    end;


    procedure FilterReservEntry(var FilterReservEntry: Record "Vehicle Reservation Entry"; FromReservSummEntry: Record "Vehicle Reserv. Entry Summary")
    begin
        FilterReservEntry.SetRange("Model Version No.", ReservEntry."Model Version No.");

        case FromReservSummEntry.Sequence of
            1:
                begin // Item Ledger Entry
                    FilterReservEntry.SetRange("Source Type", Database::"Item Ledger Entry");
                    FilterReservEntry.SetRange("Source Subtype", 0);
                end;
            11, 12, 13, 14, 15, 16:
                begin // Purchase Line
                    FilterReservEntry.SetRange("Source Type", Database::"Purchase Line");
                    FilterReservEntry.SetRange("Source Subtype", FromReservSummEntry.Sequence - 11);
                end;
            21:
                begin // Requisition Line
                    FilterReservEntry.SetRange("Source Type", Database::"Requisition Line");
                    FilterReservEntry.SetRange("Source Subtype", 0);
                end;
            31, 32, 33, 34, 35, 36:
                begin // Sales Line
                    FilterReservEntry.SetRange("Source Type", Database::"Sales Line");
                    FilterReservEntry.SetRange("Source Subtype", FromReservSummEntry.Sequence - 31);
                end;
            41, 42, 43, 44, 45:
                begin // Item Journal Line
                    FilterReservEntry.SetRange("Source Type", Database::"Item Journal Line");
                    FilterReservEntry.SetRange("Source Subtype", FromReservSummEntry.Sequence - 41);
                end;
            61, 62, 63, 64:
                begin // prod. order
                    FilterReservEntry.SetRange("Source Type", Database::"Prod. Order Line");
                    FilterReservEntry.SetRange("Source Subtype", FromReservSummEntry.Sequence - 61);
                end;
            71, 72, 73, 74:
                begin // prod. order
                    FilterReservEntry.SetRange("Source Type", Database::"Prod. Order Component");
                    FilterReservEntry.SetRange("Source Subtype", FromReservSummEntry.Sequence - 71);
                end;
            91:
                begin // Planning Component
                    FilterReservEntry.SetRange("Source Type", Database::"Planning Component");
                    FilterReservEntry.SetRange("Source Subtype", 0);
                end;
            101, 102:
                begin // Transfer Line
                    FilterReservEntry.SetRange("Source Type", Database::"Transfer Line");
                    FilterReservEntry.SetRange("Source Subtype", FromReservSummEntry.Sequence - 101);
                end;
            110:
                begin // Service Invoice Line
                    FilterReservEntry.SetRange("Source Type", Database::"Service Invoice Line");
                    FilterReservEntry.SetRange("Source Subtype", 0);
                end;
        end;

        FilterReservEntry.SetRange("Location Code", ReservEntry."Location Code");
        FilterReservEntry.SetRange("Vehicle Serial No.", ReservEntry."Vehicle Serial No.");
        FilterReservEntry.SetRange(Positive, ReservMgt.IsPositive);
    end;


    procedure RelatesToSummEntry(var FilterReservEntry: Record "Vehicle Reservation Entry"; FromReservSummEntry: Record "Vehicle Reserv. Entry Summary"): Boolean
    begin
        case FromReservSummEntry.Sequence of
            1: // Item Ledger Entry
                exit((FilterReservEntry."Source Type" = Database::"Item Ledger Entry") and
                  (FilterReservEntry."Source Subtype" = 0));
            11, 12, 13, 14, 15, 16: // Purchase Line
                exit((FilterReservEntry."Source Type" = Database::"Purchase Line") and
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry.Sequence - 11));
            21: // Requisition Line
                exit((FilterReservEntry."Source Type" = Database::"Requisition Line") and
                  (FilterReservEntry."Source Subtype" = 0));
            31, 32, 33, 34, 35, 36: // Sales Line
                exit((FilterReservEntry."Source Type" = Database::"Sales Line") and
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry.Sequence - 31));
            41, 42, 43, 44, 45: // Item Journal Line
                exit((FilterReservEntry."Source Type" = Database::"Item Journal Line") and
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry.Sequence - 41));
            101, 102: // Transfer Line
                exit((FilterReservEntry."Source Type" = Database::"Transfer Line") and
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry.Sequence - 101));
        end;
    end;


    procedure UpdateReservFrom()
    var
        VehicleReservationEntry: Record "Vehicle Reservation Entry";
    begin

        case ReservEntry."Source Type" of
            Database::"Sales Line":
                begin
                    SalesLine.Find;
                    SalesLine.CalcFields(Reserved);
                end;
            Database::"Requisition Line":
                begin
                    ReqLine.Find;
                    ReqLine.CalcFields(Reserved);
                end;
            Database::"Purchase Line":
                begin
                    PurchLine.Find;
                    PurchLine.CalcFields(Reserved);
                end;
            Database::"Item Journal Line":
                begin
                    ItemJnlLine.Find;
                    ItemJnlLine.CalcFields(Reserved);
                end;
            Database::"Transfer Line":
                begin
                    TransLine.Find;
                    QtyToReserve := TransLine.Quantity;
                    QtyToReserveBase := TransLine."Quantity (Base)";
                    QtyReserved := TransLine.GetReservedQtyVeh(ReservEntry."Source Batch Name", true, ReservEntry."Source Subtype", true);
                    QtyReservedBase := QtyReserved;
                    QtyPerUOM := TransLine."Qty. per Unit of Measure";
                end;
        end;

        UpdateReservMgt;
        ReservMgt.UpdateStatistics(ReservSummEntry);
        //ReservMgt.UpdateStatistics(Rec);

        if FormIsOpen then
            CurrPage.Update;
    end;


    procedure UpdateReservFromOriginal()
    var
        EntrySummary: Record "Entry Summary";
        QtyPerUOM: Decimal;
        QtyReservedIT: Decimal;
    begin
        /*
        IF NOT FormIsOpen THEN
          GetSerialLotNo(ItemTrackingQtyToReserve,ItemTrackingQtyToReserveBase);
        
        CASE ReservEntry."Source Type" OF
          DATABASE::"Sales Line":
            BEGIN
              SalesLine.FIND;
              SalesLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN BEGIN
                SalesLine."Reserved Quantity" := -SalesLine."Reserved Quantity";
                SalesLine."Reserved Qty. (Base)" := -SalesLine."Reserved Qty. (Base)";
              END;
              QtyReserved := SalesLine."Reserved Quantity";
              QtyReservedBase := SalesLine."Reserved Qty. (Base)";
              QtyToReserve := SalesLine."Outstanding Quantity";
              QtyToReserveBase := SalesLine."Outstanding Qty. (Base)";
              QtyPerUOM := SalesLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Requisition Line":
            BEGIN
              ReqLine.FIND;
              ReqLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ReqLine."Reserved Quantity";
              QtyReservedBase := ReqLine."Reserved Qty. (Base)";
              QtyToReserve := ReqLine.Quantity;
              QtyToReserveBase := ReqLine."Quantity (Base)";
              QtyPerUOM := ReqLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Purchase Line":
            BEGIN
              PurchLine.FIND;
              PurchLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN BEGIN
                PurchLine."Reserved Quantity" := -PurchLine."Reserved Quantity";
                PurchLine."Reserved Qty. (Base)" := -PurchLine."Reserved Qty. (Base)";
              END;
              QtyReserved := PurchLine."Reserved Quantity";
              QtyReservedBase := PurchLine."Reserved Qty. (Base)";
              QtyToReserve := PurchLine."Outstanding Quantity";
              QtyToReserveBase := PurchLine."Outstanding Qty. (Base)";
              QtyPerUOM := PurchLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Item Journal Line":
            BEGIN
              ItemJnlLine.FIND;
              ItemJnlLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ItemJnlLine."Reserved Quantity";
              QtyReservedBase := ItemJnlLine."Reserved Qty. (Base)";
              QtyToReserve := ItemJnlLine.Quantity;
              QtyToReserveBase := ItemJnlLine."Quantity (Base)";
              QtyPerUOM := ItemJnlLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Prod. Order Line":
            BEGIN
              ProdOrderLine.FIND;
              ProdOrderLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ProdOrderLine."Reserved Quantity";
              QtyReservedBase := ProdOrderLine."Reserved Qty. (Base)";
              QtyToReserve := ProdOrderLine."Remaining Quantity";
              QtyToReserveBase := ProdOrderLine."Remaining Qty. (Base)";
              QtyPerUOM := ProdOrderLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Prod. Order Component":
            BEGIN
              ProdOrderComp.FIND;
              ProdOrderComp.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ProdOrderComp."Reserved Quantity";
              QtyReservedBase := ProdOrderComp."Reserved Qty. (Base)";
              QtyToReserve := ProdOrderComp."Remaining Quantity";
              QtyToReserveBase := ProdOrderComp."Remaining Qty. (Base)";
              QtyPerUOM := ProdOrderComp."Qty. per Unit of Measure";
            END;
          DATABASE::"Assembly Header":
            BEGIN
              AssemblyHeader.FIND;
              AssemblyHeader.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := AssemblyHeader."Reserved Quantity";
              QtyReservedBase := AssemblyHeader."Reserved Qty. (Base)";
              QtyToReserve := AssemblyHeader."Remaining Quantity";
              QtyToReserveBase := AssemblyHeader."Remaining Quantity (Base)";
              QtyPerUOM := AssemblyHeader."Qty. per Unit of Measure";
            END;
          DATABASE::"Assembly Line":
            BEGIN
              AssemblyLine.FIND;
              AssemblyLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := AssemblyLine."Reserved Quantity";
              QtyReservedBase := AssemblyLine."Reserved Qty. (Base)";
              QtyToReserve := AssemblyLine."Remaining Quantity";
              QtyToReserveBase := AssemblyLine."Remaining Quantity (Base)";
              QtyPerUOM := AssemblyLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Planning Component":
            BEGIN
              PlanningComponent.FIND;
              PlanningComponent.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := PlanningComponent."Reserved Quantity";
              QtyReservedBase := PlanningComponent."Reserved Qty. (Base)";
              QtyToReserve := PlanningComponent.Quantity;
              QtyToReserveBase := PlanningComponent."Quantity (Base)";
              QtyPerUOM := PlanningComponent."Qty. per Unit of Measure";
            END;
          DATABASE::"Transfer Line":
            BEGIN
              TransLine.FIND;
              IF ReservEntry."Source Subtype" = 0 THEN BEGIN // Outbound
                TransLine.CALCFIELDS("Reserved Quantity Outbnd.","Reserved Qty. Outbnd. (Base)");
                QtyReserved := TransLine."Reserved Quantity Outbnd.";
                QtyReservedBase := TransLine."Reserved Qty. Outbnd. (Base)";
                QtyToReserve := TransLine."Outstanding Quantity";
                QtyToReserveBase := TransLine."Outstanding Qty. (Base)";
              END ELSE BEGIN // Inbound
                TransLine.CALCFIELDS("Reserved Quantity Inbnd.","Reserved Qty. Inbnd. (Base)");
                QtyReserved := TransLine."Reserved Quantity Inbnd.";
                QtyReservedBase := TransLine."Reserved Qty. Inbnd. (Base)";
                QtyToReserve := TransLine."Outstanding Quantity";
                QtyToReserveBase := TransLine."Outstanding Qty. (Base)";
              END;
              QtyPerUOM := TransLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Service Line":
            BEGIN
              ServiceLine.FIND;
              ServiceLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ServiceLine."Reserved Quantity";
              QtyReservedBase := ServiceLine."Reserved Qty. (Base)";
              QtyToReserve := ServiceLine."Outstanding Quantity";
              QtyToReserveBase := ServiceLine."Outstanding Qty. (Base)";
              QtyPerUOM := ServiceLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Job Planning Line":
            BEGIN
              JobPlanningLine.FIND;
              JobPlanningLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := JobPlanningLine."Reserved Quantity";
              QtyReservedBase := JobPlanningLine."Reserved Qty. (Base)";
              QtyToReserve := JobPlanningLine."Remaining Qty.";
              QtyToReserveBase := JobPlanningLine."Remaining Qty. (Base)";
              QtyPerUOM := JobPlanningLine."Qty. per Unit of Measure";
            END;
          //20.03.2013 EDMS >>
          DATABASE::"Service Line EDMS":
            BEGIN
              ServiceLineEDMS.FIND;
              ServiceLineEDMS.CALCFIELDS("Reserved Qty. (Base)");
              IF ServiceLineEDMS."Document Type" = ServiceLineEDMS."Document Type"::"Return Order" THEN
                ServiceLineEDMS."Reserved Qty. (Base)" := -ServiceLineEDMS."Reserved Qty. (Base)";
              QtyReserved := ServiceLineEDMS."Reserved Qty. (Base)";
              QtyToReserve := ServiceLineEDMS."Outstanding Qty. (Base)";
            END;
          //20.03.2013 EDMS <<
        END;
        
        UpdateReservMgt;
        ReservMgt.UpdateStatistics(
          Rec,ReservEntry."Shipment Date",HandleItemTracking);
        
        IF HandleItemTracking THEN BEGIN
          EntrySummary := Rec;
          QtyReservedBase := 0;
          IF FINDSET THEN
            REPEAT
              QtyReservedBase += ReservedThisLine(Rec);
            UNTIL NEXT = 0;
          QtyReservedIT := ROUND(QtyReservedBase / QtyPerUOM,0.00001);
          IF ABS(QtyReserved - QtyReservedIT) > 0.00001 THEN
            QtyReserved := QtyReservedIT;
          QtyToReserveBase := ItemTrackingQtyToReserveBase;
          IF ABS(ItemTrackingQtyToReserve - QtyToReserve) > 0.00001 THEN
            QtyToReserve := ItemTrackingQtyToReserve;
          Rec := EntrySummary;
        END;
        
        UpdateNonSpecific; // Late Binding
        
        IF FormIsOpen THEN
          CurrPage.UPDATE;
        */

    end;


    procedure UpdateReservMgt()
    begin
        Clear(ReservMgt);
        case ReservEntry."Source Type" of
            Database::"Sales Line":
                ReservMgt.SetSalesLine(SalesLine);
            Database::"Requisition Line":
                ReservMgt.SetReqLine(ReqLine);
            Database::"Purchase Line":
                ReservMgt.SetPurchLine(PurchLine);
            Database::"Item Journal Line":
                ReservMgt.SetItemJnlLine(ItemJnlLine);
            Database::"Transfer Line":
                ReservMgt.SetTransferLine(TransLine, ReservEntry."Source Subtype");
        end;
    end;


    procedure ReservedThisLine(ReservSummEntry2: Record "Vehicle Reserv. Entry Summary" temporary) ReservedQuantity: Decimal
    var
        ReservEntry3: Record "Reservation Entry";
    begin
        Clear(ReservEntry2);

        ReservEntry2.SetCurrentkey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        ReservedQuantity := 0;

        FilterReservEntry(ReservEntry2, ReservSummEntry2);
        if ReservEntry2.FindSet then
            repeat
                ReservEntry3.Get(ReservEntry2."Entry No.", not ReservEntry2.Positive);
                if (ReservEntry3."Source Type" = ReservEntry."Source Type") and
                   (ReservEntry3."Source Subtype" = ReservEntry."Source Subtype") and
                   (ReservEntry3."Source ID" = ReservEntry."Source ID") and
                   (ReservEntry3."Source Batch Name" = ReservEntry."Source Batch Name") and
                   (ReservEntry3."Source Ref. No." = ReservEntry."Source Ref. No.")
                then
                    ReservedQuantity += ReservEntry2.Quantity * CreateReservEntry.SignFactor(ReservEntry2);
            until ReservEntry2.Next = 0;

        exit(ReservedQuantity);
    end;


    procedure AutoReserve()
    begin
        if Abs(QtyToReserveBase) - Abs(QtyReservedBase) = 0 then
            Error(Text000);

        ReservMgt.AutoReserve(
          FullAutoReservation, ReservEntry.Description,
          QtyToReserve - QtyReserved);
        if not FullAutoReservation then
            Message(Text001);
        UpdateReservFrom;
    end;
}

