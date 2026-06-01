Page 25006096 "Purch. Reservation FactBox"
{
    // 08.09.2014 Elva Baltic P8 #S0006 EDMS
    //   * Created as copy from P25006081

    Caption = 'Reservation Entry Details';
    PageType = CardPart;
    SourceTable = "Purchase Line";

    layout
    {
        area(content)
        {
            field(EntryNo; Rec."Reservation Entry No.")
            {
                ApplicationArea = Basic;
                Caption = 'Entry No.';
            }

            field(ReservedFor; ReservationManagementEDMS.CreateForText2(ReservationEntry))
            {
                ApplicationArea = Basic;
                Caption = 'Reserved For';
                Editable = false;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    LookupReservedFor;
                end;
            }
            field(ReservationCustomerNo; Rec.GetReservForInfo(Returnvalue::CustomerNo))
            {
                ApplicationArea = Basic;
                Caption = 'Reservation Customer No.';
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowCustomeCard;
                end;
            }
            field(ReservationCustomerName; Rec.GetReservForInfo(Returnvalue::CustomerName))
            {
                ApplicationArea = Basic;
                Caption = 'Reservation Customer Name';

                trigger OnDrillDown()
                begin
                    ShowCustomeCard;
                end;
            }
            field(ReservationVIN; Rec.GetReservForInfo(Returnvalue::VIN))
            {
                ApplicationArea = Basic;
                Caption = 'Reservation VIN';
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowVINList;
                end;
            }
            field(ReservationDealType; Rec.GetReservForInfo(Returnvalue::DealType))
            {
                ApplicationArea = Basic;
                Caption = 'Reservation Deal Type Code';
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowDealTypes;
                end;
            }
            field(ReservationOrderingPriceType; Rec.GetReservForInfo(Returnvalue::OrderingPriceType))
            {
                ApplicationArea = Basic;
                Caption = 'Reservation Ordering Price Type Code';

                trigger OnDrillDown()
                begin
                    ShowOrderingPriceType;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        ReservationManagementEDMS: Codeunit "Reservation Management EDMS";
    begin
        Rec.CalcFields("Reservation Entry No.");
        Clear(ReservationEntry);
        if ReservationEntry.Get(ReservationManagementEDMS.GetReservForEntryNo(Rec."Document No.", Rec."Line No.", Database::"Purchase Line", rec."Document Type", 0, ''), false) then;
    end;

    var
        ReservationEntry: Record "Reservation Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReservationManagementEDMS: codeunit "Reservation Management EDMS";
        ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType;
        Customer: Record Customer;
        Vehicle: Record Vehicle;
        DealType: Record "Deal Type";
        OrderingPriceType: Record "Ordering Price Type";


    procedure LookupReservedFor()
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.Get(ReservationEntry."Entry No.", false);
        LookupReserved(ReservEntry);
    end;


    procedure LookupReservedFrom()
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.Get(ReservationEntry."Entry No.", true);
        LookupReserved(ReservEntry);
    end;


    procedure LookupReserved(ReservEntry: Record "Reservation Entry")
    var
        SalesLine: Record "Sales Line";
        ReqLine: Record "Requisition Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningComponent: Record "Planning Component";
        ServLine: Record "Service Line";
        JobPlanningLine: Record "Job Planning Line";
        TransLine: Record "Transfer Line";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        case ReservEntry."Source Type" of
            Database::"Sales Line":
                begin
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", ReservEntry."Source Subtype");
                    SalesLine.SetRange("Document No.", ReservEntry."Source ID");
                    SalesLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(Page::"Sales Lines", SalesLine);
                end;
            Database::"Requisition Line":
                begin
                    ReqLine.Reset;
                    ReqLine.SetRange("Worksheet Template Name", ReservEntry."Source ID");
                    ReqLine.SetRange("Journal Batch Name", ReservEntry."Source Batch Name");
                    ReqLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(Page::"Requisition Lines", ReqLine);
                end;
            Database::"Purchase Line":
                begin
                    PurchLine.Reset;
                    PurchLine.SetRange("Document Type", ReservEntry."Source Subtype");
                    PurchLine.SetRange("Document No.", ReservEntry."Source ID");
                    PurchLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(Page::"Purchase Lines", PurchLine);
                end;
            Database::"Item Journal Line":
                begin
                    ItemJnlLine.Reset;
                    ItemJnlLine.SetRange("Journal Template Name", ReservEntry."Source ID");
                    ItemJnlLine.SetRange("Journal Batch Name", ReservEntry."Source Batch Name");
                    ItemJnlLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    ItemJnlLine.SetRange("Entry Type", ReservEntry."Source Subtype");
                    Page.RunModal(Page::"Item Journal Lines", ItemJnlLine);
                end;
            Database::"Item Ledger Entry":
                begin
                    ItemLedgEntry.Reset;
                    ItemLedgEntry.SetRange("Entry No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(0, ItemLedgEntry);
                end;
            Database::"Prod. Order Line":
                begin
                    ProdOrderLine.Reset;
                    ProdOrderLine.SetRange(Status, ReservEntry."Source Subtype");
                    ProdOrderLine.SetRange("Prod. Order No.", ReservEntry."Source ID");
                    ProdOrderLine.SetRange("Line No.", ReservEntry."Source Prod. Order Line");
                    Page.RunModal(0, ProdOrderLine);
                end;
            Database::"Prod. Order Component":
                begin
                    ProdOrderComp.Reset;
                    ProdOrderComp.SetRange(Status, ReservEntry."Source Subtype");
                    ProdOrderComp.SetRange("Prod. Order No.", ReservEntry."Source ID");
                    ProdOrderComp.SetRange("Prod. Order Line No.", ReservEntry."Source Prod. Order Line");
                    ProdOrderComp.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(0, ProdOrderComp);
                end;
            Database::"Planning Component":
                begin
                    PlanningComponent.Reset;
                    PlanningComponent.SetRange("Worksheet Template Name", ReservEntry."Source ID");
                    PlanningComponent.SetRange("Worksheet Batch Name", ReservEntry."Source Batch Name");
                    PlanningComponent.SetRange("Worksheet Line No.", ReservEntry."Source Prod. Order Line");
                    PlanningComponent.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(0, PlanningComponent);
                end;
            Database::"Transfer Line":
                begin
                    TransLine.Reset;
                    TransLine.SetRange("Document No.", ReservEntry."Source ID");
                    TransLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    TransLine.SetRange("Derived From Line No.", ReservEntry."Source Prod. Order Line");
                    Page.RunModal(0, TransLine);
                end;
            Database::"Service Line":
                begin
                    ServLine.SetRange("Document Type", ReservEntry."Source Subtype");
                    ServLine.SetRange("Document No.", ReservEntry."Source ID");
                    ServLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(0, ServLine);
                end;
            Database::"Job Planning Line":
                begin
                    JobPlanningLine.SetRange(Status, ReservEntry."Source Subtype");
                    JobPlanningLine.SetRange("Job No.", ReservEntry."Source ID");
                    JobPlanningLine.SetRange("Job Contract Entry No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(0, JobPlanningLine);
                end;
            Database::"Assembly Header":
                begin
                    AssemblyHeader.SetRange("Document Type", ReservEntry."Source Subtype");
                    AssemblyHeader.SetRange("No.", ReservEntry."Source ID");
                    Page.RunModal(0, AssemblyHeader);
                end;
            Database::"Assembly Line":
                begin
                    AssemblyLine.SetRange("Document Type", ReservEntry."Source Subtype");
                    AssemblyLine.SetRange("Document No.", ReservEntry."Source ID");
                    AssemblyLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(0, AssemblyLine);
                end;
            // 31.03.2014 Elva Baltic P21 #F182 MMG7.00 >>
            Database::"Service Line EDMS":
                begin
                    ServiceLineEDMS.SetRange("Document Type", ReservEntry."Source Subtype");
                    ServiceLineEDMS.SetRange("Document No.", ReservEntry."Source ID");
                    ServiceLineEDMS.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(0, ServiceLineEDMS);
                end;
        // 31.03.2014 Elva Baltic P21 #F182 MMG7.00 <<
        end;
    end;


    procedure ShowCustomeCard()
    begin
        if Customer.Get(Rec.GetReservForInfo(Returnvalue::CustomerNo)) then
            Page.Run(Page::"Customer Card", Customer);
    end;


    procedure ShowVINList()
    begin
        Vehicle.Reset;
        Vehicle.SetCurrentkey(VIN);
        Vehicle.SetRange(VIN, Rec.GetReservForInfo(Returnvalue::VIN));
        Page.Run(Page::"Vehicle List", Vehicle);
    end;


    procedure ShowDealTypes()
    begin
        if DealType.Get(Rec.GetReservForInfo(Returnvalue::DealType)) then
            Page.Run(Page::"Deal Types", DealType);
    end;


    procedure ShowOrderingPriceType()
    begin
        if OrderingPriceType.Get(Rec.GetReservForInfo(Returnvalue::OrderingPriceType)) then
            Page.Run(Page::"Ordering Price Types", OrderingPriceType);
    end;
}

