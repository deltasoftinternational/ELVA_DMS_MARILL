pageextension 25006200 "Reservation Entries" extends "Reservation Entries"//497
{
    actions
    {
        modify(CancelReservation)
        {
            Visible = false;
        }
        addafter(CancelReservation)
        {
            action(DMSCancelReservation)
            {
                AccessByPermission = TableData Item = R;
                ApplicationArea = Reservation;
                Caption = 'Cancel Reservation';
                Image = Cancel;
                ToolTip = 'Cancel the selected reservation entry.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Scope = Repeater;
                trigger OnAction()
                var
                    ReservEntry: Record "Reservation Entry";
                    UserSetup: Record "User Setup";
                    ServTransferMgt: Codeunit "Service Transfer Mgt.";
                begin
                    CurrPage.SetSelectionFilter(ReservEntry);
                    if ReservEntry.Find('-') then
                        repeat
                            ReservEntry.TestField("Reservation Status", Rec."Reservation Status"::Reservation);
                            ReservEntry.TestField("Disallow Cancellation", false);
                            DMSOnCancelReservationOnBeforeConfirm(ReservEntry);
                            //21.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                            Clear(ServTransferMgt);
                            if ServTransferMgt.IsServiceLocation(ReservEntry."Location Code") then begin
                                UserSetup.Reset;
                                UserSetup.Get(UserId);
                                UserSetup.TestField("Allow Cancel Service Reserv.");
                            end;
                            //21.04.2014 Elva Baltic P1 #RX MMG7.00 <<
                            if Confirm(
                                 CancelReservationQst, false, ReservEntry."Quantity (Base)",
                                 ReservEntry."Item No.", ReservEngineMgt.CreateForText(Rec),
                                 ReservEngineMgt.CreateFromText(Rec))
                            then begin
                                ReservEngineMgt.CancelReservation(ReservEntry);
                                Commit();
                            end;
                        until ReservEntry.Next() = 0;
                end;
            }
        }
    }
    var
        CancelReservationQst: Label 'Cancel reservation of %1 of item number %2, reserved for %3 from %4?';

    // procedure LookupReserved(ReservEntry: Record "Reservation Entry")
    // var
    //     SalesLine: Record "Sales Line";
    //     ReqLine: Record "Requisition Line";
    //     PurchLine: Record "Purchase Line";
    //     ItemJnlLine: Record "Item Journal Line";
    //     ItemLedgEntry: Record "Item Ledger Entry";
    //     ProdOrderLine: Record "Prod. Order Line";
    //     ProdOrderComp: Record "Prod. Order Component";
    //     PlanningComponent: Record "Planning Component";
    //     ServLine: Record "Service Line";
    //     JobPlanningLine: Record "Job Planning Line";
    //     TransLine: Record "Transfer Line";
    //     AssemblyHeader: Record "Assembly Header";
    //     AssemblyLine: Record "Assembly Line";
    //     InvtDocLine: Record "Invt. Document Line";
    //     ServiceLineEDMS: Record "Service Line EDMS";
    // begin
    //     case ReservEntry."Source Type" of
    //         DATABASE::"Sales Line":
    //             begin
    //                 SalesLine.Reset();
    //                 SalesLine.SetRange("Document Type", ReservEntry."Source Subtype");
    //                 SalesLine.SetRange("Document No.", ReservEntry."Source ID");
    //                 SalesLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 PAGE.RunModal(PAGE::"Sales Lines", SalesLine);
    //             end;
    //         DATABASE::"Requisition Line":
    //             begin
    //                 ReqLine.Reset();
    //                 ReqLine.SetRange("Worksheet Template Name", ReservEntry."Source ID");
    //                 ReqLine.SetRange("Journal Batch Name", ReservEntry."Source Batch Name");
    //                 ReqLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 PAGE.RunModal(PAGE::"Requisition Lines", ReqLine);
    //             end;
    //         DATABASE::"Purchase Line":
    //             begin
    //                 PurchLine.Reset();
    //                 PurchLine.SetRange("Document Type", ReservEntry."Source Subtype");
    //                 PurchLine.SetRange("Document No.", ReservEntry."Source ID");
    //                 PurchLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 PAGE.RunModal(PAGE::"Purchase Lines", PurchLine);
    //             end;
    //         DATABASE::"Item Journal Line":
    //             begin
    //                 ItemJnlLine.Reset();
    //                 ItemJnlLine.SetRange("Journal Template Name", ReservEntry."Source ID");
    //                 ItemJnlLine.SetRange("Journal Batch Name", ReservEntry."Source Batch Name");
    //                 ItemJnlLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 ItemJnlLine.SetRange("Entry Type", ReservEntry."Source Subtype");
    //                 PAGE.RunModal(PAGE::"Item Journal Lines", ItemJnlLine);
    //             end;
    //         DATABASE::"Item Ledger Entry":
    //             begin
    //                 ItemLedgEntry.Reset();
    //                 ItemLedgEntry.SetRange("Entry No.", ReservEntry."Source Ref. No.");
    //                 PAGE.RunModal(0, ItemLedgEntry);
    //             end;
    //         DATABASE::"Prod. Order Line":
    //             begin
    //                 ProdOrderLine.Reset();
    //                 ProdOrderLine.SetRange(Status, ReservEntry."Source Subtype");
    //                 ProdOrderLine.SetRange("Prod. Order No.", ReservEntry."Source ID");
    //                 ProdOrderLine.SetRange("Line No.", ReservEntry."Source Prod. Order Line");
    //                 PAGE.RunModal(0, ProdOrderLine);
    //             end;
    //         DATABASE::"Prod. Order Component":
    //             begin
    //                 ProdOrderComp.Reset();
    //                 ProdOrderComp.SetRange(Status, ReservEntry."Source Subtype");
    //                 ProdOrderComp.SetRange("Prod. Order No.", ReservEntry."Source ID");
    //                 ProdOrderComp.SetRange("Prod. Order Line No.", ReservEntry."Source Prod. Order Line");
    //                 ProdOrderComp.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 PAGE.RunModal(0, ProdOrderComp);
    //             end;
    //         DATABASE::"Planning Component":
    //             begin
    //                 PlanningComponent.Reset();
    //                 PlanningComponent.SetRange("Worksheet Template Name", ReservEntry."Source ID");
    //                 PlanningComponent.SetRange("Worksheet Batch Name", ReservEntry."Source Batch Name");
    //                 PlanningComponent.SetRange("Worksheet Line No.", ReservEntry."Source Prod. Order Line");
    //                 PlanningComponent.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 PAGE.RunModal(0, PlanningComponent);
    //             end;
    //         DATABASE::"Transfer Line":
    //             begin
    //                 TransLine.Reset();
    //                 TransLine.SetRange("Document No.", ReservEntry."Source ID");
    //                 TransLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 TransLine.SetRange("Derived From Line No.", ReservEntry."Source Prod. Order Line");
    //                 PAGE.RunModal(0, TransLine);
    //             end;
    //         DATABASE::"Service Line":
    //             begin
    //                 ServLine.SetRange("Document Type", ReservEntry."Source Subtype");
    //                 ServLine.SetRange("Document No.", ReservEntry."Source ID");
    //                 ServLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 PAGE.RunModal(0, ServLine);
    //             end;
    //         DATABASE::"Job Planning Line":
    //             begin
    //                 JobPlanningLine.SetRange(Status, ReservEntry."Source Subtype");
    //                 JobPlanningLine.SetRange("Job No.", ReservEntry."Source ID");
    //                 JobPlanningLine.SetRange("Job Contract Entry No.", ReservEntry."Source Ref. No.");
    //                 PAGE.RunModal(0, JobPlanningLine);
    //             end;
    //         DATABASE::"Assembly Header":
    //             begin
    //                 AssemblyHeader.SetRange("Document Type", ReservEntry."Source Subtype");
    //                 AssemblyHeader.SetRange("No.", ReservEntry."Source ID");
    //                 PAGE.RunModal(0, AssemblyHeader);
    //             end;
    //         DATABASE::"Assembly Line":
    //             begin
    //                 AssemblyLine.SetRange("Document Type", ReservEntry."Source Subtype");
    //                 AssemblyLine.SetRange("Document No.", ReservEntry."Source ID");
    //                 AssemblyLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 PAGE.RunModal(0, AssemblyLine);
    //             end;
    //         DATABASE::"Invt. Document Line":
    //             begin
    //                 InvtDocLine.SetRange("Document Type", ReservEntry."Source Subtype");
    //                 InvtDocLine.SetRange("Document No.", ReservEntry."Source ID");
    //                 InvtDocLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 PAGE.RunModal(0, InvtDocLine);
    //             end;
    //         // 31.03.2014 Elva Baltic P21 #F182 MMG7.00 >>
    //         Database::"Service Line EDMS":
    //             begin
    //                 ServiceLineEDMS.SetRange("Document Type", ReservEntry."Source Subtype");
    //                 ServiceLineEDMS.SetRange("Document No.", ReservEntry."Source ID");
    //                 ServiceLineEDMS.SetRange("Line No.", ReservEntry."Source Ref. No.");
    //                 Page.RunModal(0, ServiceLineEDMS);
    //             end;
    //     // 31.03.2014 Elva Baltic P21 #F182 MMG7.00 <<		    
    //     end;

    //     OnAfterLookupReserved(ReservEntry);
    // end;

    [IntegrationEvent(false, false)]
    local procedure DMSOnCancelReservationOnBeforeConfirm(var ReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure DMSOnAfterLookupReserved(var ReservEntry: Record "Reservation Entry")
    begin
    end;

}