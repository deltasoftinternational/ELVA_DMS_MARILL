pageextension 25006071 "Req. Worksheet" extends "Req. Worksheet" //291
{
    layout
    {
        modify("Transfer-from Code")
        {
            Editable = true;
        }
        addafter("Blanket Purch. Order Exists")
        {
            field(DocumentProfile; Rec."Document Profile")
            {
                ApplicationArea = Basic;
            }
            field(ReservedQuantity; Rec."Reserved Quantity")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(ReservedFor; ReservationManagementEDMS.CreateForText2(ReservationEntry))
            {
                ApplicationArea = Basic;
                Caption = 'Reserved For';
                Visible = false;
            }
            field(ReservationCustomerNo; Rec.GetReservForInfo(Returnvalue::CustomerNo))
            {
                ApplicationArea = Basic;
                Caption = 'Reservation Customer No.';
                TableRelation = Customer;
                Visible = false;
            }
            field(ReservationCustomerName; Rec.GetReservForInfo(Returnvalue::CustomerName))
            {
                ApplicationArea = Basic;
                Caption = 'Reservation Customer Name';
                Visible = false;
            }
            field(ReservationVIN; Rec.GetReservForInfo(Returnvalue::VIN))
            {
                ApplicationArea = Basic;
                Caption = 'Reservation VIN';
                TableRelation = Vehicle.VIN;
                Visible = false;
            }
            field(ReservationDealType; Rec.GetReservForInfo(Returnvalue::DealType))
            {
                ApplicationArea = Basic;
                Caption = 'Reservation Deal Type Code';
                TableRelation = "Deal Type";
                Visible = false;
            }
            field(ReservationOrderingPriceType; Rec.GetReservForInfo(Returnvalue::OrderingPriceType))
            {
                ApplicationArea = Basic;
                Caption = 'Reservation Ordering Price Type Code';
                TableRelation = "Ordering Price Type";
                Visible = false;
            }
            field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(NetWeight; Rec."Net Weight")
            {
                ApplicationArea = Basic;
            }
            field(OrderQtyWeight; Rec."Order Qty. Weight")
            {
                ApplicationArea = Basic;
            }
            field(PurchaseTransportMethod; Rec."Purchase Transport Method")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Control1903326807)
        {
            part(Control11; "Item Line Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No."),
                              "Variant Filter" = field("Variant Code"),
                              "Location Filter" = field("Location Code");
            }
            part(Control15; "Stockkeping Unit FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Item No." = field("No."),
                              "Variant Code" = field("Variant Code"),
                              "Location Code" = field("Location Code");
            }
            part(Control13; "Reservation Entry FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Worksheet Template Name" = field("Worksheet Template Name"),
                              "Journal Batch Name" = field("Journal Batch Name"),
                              "Line No." = field("Line No.");
            }
            systempart(Control41; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control39; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
    actions
    {
        modify(Action75)
        {
            Visible = false;
        }
        addafter(Action53)
        {
            action(GetService)
            {
                ApplicationArea = Basic;
                Caption = 'Get &Service Orders';
                Image = "Order";

                trigger OnAction()
                begin
                    GetServiceOrders.SetReqWkshLine(Rec, 1);
                    GetServiceOrders.RunModal;
                    Clear(GetServiceOrders);
                end;
            }
            action("<Action75>")
            {
                AccessByPermission = TableData "Sales Shipment Header" = R;
                ApplicationArea = Planning;
                Caption = 'Sales &Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category5;
                Enabled = Rec."Sales Order No." <> '';
                ToolTip = 'View the sales order that is the source of the line. This applies only to drop shipments and special orders.';

                trigger OnAction()
                begin
                    //18.01.2013 EDMS P8 >>
                    if Rec."Sales Order No." <> '' then begin
                        SalesHeader.SetRange("No.", Rec."Sales Order No.");
                        SalesOrder.SetTableview(SalesHeader);
                        SalesOrder.Editable := false;
                        SalesOrder.Run;
                    end;
                    if Rec."Service Order No." <> '' then begin
                        ServiceHeader.SetRange("No.", Rec."Service Order No.");
                        ServiceOrder.SetTableview(ServiceHeader);
                        ServiceOrder.Editable := false;
                        ServiceOrder.Run;
                    end;
                    //18.01.2013 EDMS P8 <<
                end;
            }
        }
        modify(CarryOutActionMessage)
        { Visible = false; }
        addafter(CarryOutActionMessage)
        {
            action(DMSCarryOutActionMessage)
            {
                ApplicationArea = Planning;
                Caption = 'Carry &Out Action Message';
                Ellipsis = true;
                Image = CarryOutActionMessage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';

                trigger OnAction()
                begin
                    CarryOutActionMsg();
                    CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                    CurrPage.Update(false);
                end;
            }
        }
        modify(CalculatePlan)
        {
            Visible = false;
        }
        addafter(CalculatePlan)
        {
            action(DMSCalculatePlan)
            {
                ApplicationArea = Planning;
                Caption = 'Calculate Plan';
                Ellipsis = true;
                Image = CalculatePlan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Use a batch job to help you calculate a supply plan for items and stockkeeping units that have the Replenishment System field set to Purchase or Transfer.';

                trigger OnAction()
                begin
                    CalculatePlan.SetTemplAndWorksheet(Rec."Worksheet Template Name", Rec."Journal Batch Name");
                    CalculatePlan.RunModal;
                    Clear(CalculatePlan);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        // 08.04.2014 Elva Baltic P21 >>
        if (Rec."Location Code" = '') and (UserProfile."Default Location Code" <> '') then
            Rec.Validate("Location Code", UserProfile."Default Location Code");
        // 08.04.2014 Elva Baltic P21 <<
    end;

    trigger OnOpenPage()
    var
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        JnlSelected: Boolean;
        ReservationManagementEDMS: Codeunit "Reservation Management EDMS";
    begin
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();
        OpenedFromBatch := (Rec."Journal Batch Name" <> '') and (Rec."Worksheet Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            ReqJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        DMSOnBeforeTemplateSelection(Rec, CurrentJnlBatchName);
        ReqJnlManagement.WkshTemplateSelection(PAGE::"Req. Worksheet", false, Enum::"Req. Worksheet Template Type"::"Req.", Rec, JnlSelected);
        if not JnlSelected then
            Error('');

        DMSOnBeforeOpenReqWorksheet(CurrentJnlBatchName);
        ReqJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);

        // 08.04.2014 Elva Baltic P21 >>
        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
            if UserProfile."Default Location Code" <> '' then
                Rec.SetFilter("Location Code", UserProfile."Default Req. Location Filter");
        // 08.04.2014 Elva Baltic P21 <<

        Rec.CalcFields("Reservation Entry No.");

        Rec.CalcFields("Reservation Entry No.");

        // 31.03.2014 Elva Baltic P21 >>
        Clear(ReservationEntry);
        if ReservationEntry.Get(ReservationManagementEDMS.GetReservForEntryNo(Rec."Worksheet Template Name", Rec."Line No.", Database::"Requisition Line", 0, 0, Rec."Journal Batch Name"), false) then;
        // 31.03.2014 Elva Baltic P21 <<

    end;

    var
        ServiceHeader: Record "Service Header EDMS";
        SalesOrder: Page "Sales Order";
        SalesHeader: Record "Sales Header";
        ServiceOrder: Page "Service Order EDMS";
        ReqJnlManagement: Codeunit ReqJnlManagement;

        GetServiceOrders: Report "Get Service Orders";
        ExtendedPriceEnabled: Boolean;
        OpenedFromBatch: Boolean;
        CurrentJnlBatchName: Code[10];
        CalculatePlan: Report "EDMS Calculate Plan-Req. Wksh.";


    protected var
        ReservationEntry: Record "Reservation Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType;
        UserProfile: Record "Branch Profile Setup";
        UserProfileMgt: Codeunit UserProfileManagement;
        ReservationManagementEDMS: Codeunit "Reservation Management EDMS";

    local procedure CarryOutActionMsg()
    var
        CarryOutActionMsgReq: Report "EDMS CarryOut Action Msg.-Req.";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        DMSOnBeforeCarryOutActionMsg(Rec, IsHandled);
        if IsHandled then
            exit;

        CarryOutActionMsgReq.SetReqWkshLine(Rec);
        CarryOutActionMsgReq.RunModal;
        CarryOutActionMsgReq.GetReqWkshLine(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure DMSOnBeforeCarryOutActionMsg(var RequisitionLine: Record "Requisition Line"; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure DMSOnBeforeTemplateSelection(var RequisitionLine: Record "Requisition Line"; CurrentJnlBatchName: Code[10])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure DMSOnBeforeOpenReqWorksheet(var CUrrentJnlBatchName: Code[10])
    begin
    end;
}