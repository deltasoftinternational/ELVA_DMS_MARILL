pageextension 25006475 "Recurring Req. Worksheet" extends "Recurring Req. Worksheet"//296 

{

    actions
    {
        modify("Carry &Out Action Message")
        {
            Visible = false;
        }
        addafter("Carry &Out Action Message")
        {
            action("DMS Carry &Out Action Message")
            {
                ApplicationArea = Planning;
                Caption = 'Carry &Out Action Message';
                Ellipsis = true;
                Image = CarryOutActionMessage;
                ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';

                trigger OnAction()
                begin
                    MakePurchaseOrder();
                    CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                    CurrPage.Update(false);
                end;
            }
        }
        modify("Calculate Plan")
        {
            visible = false;
        }
        addafter("Calculate Plan")
        {
            action("DMS Calculate Plan")
            {
                ApplicationArea = Planning;
                Caption = 'Calculate Plan';
                Ellipsis = true;
                Image = CalculatePlan;
                ToolTip = 'Use a batch job to help you calculate a supply plan for items and stockkeeping units that have the Replenishment System field set to Purchase or Transfer.';

                trigger OnAction()
                begin
                    ReorderItems.SetTemplAndWorksheet(Rec."Worksheet Template Name", Rec."Journal Batch Name");
                    ReorderItems.RunModal;
                    Clear(ReorderItems);
                end;
            }
        }
    }
    var
        ReorderItems: Report "EDMS Calculate Plan-Req. Wksh.";


    local procedure MakePurchaseOrder()
    var
        MakePurchOrder: Report "EDMS CarryOut Action Msg.-Req.";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        DMSOnBeforeMakePurchaseOrder(Rec, IsHandled);
        if IsHandled then
            exit;

        MakePurchOrder.SetReqWkshLine(Rec);
        MakePurchOrder.RunModal;
        MakePurchOrder.GetReqWkshLine(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure DMSOnBeforeMakePurchaseOrder(var RequisitionLine: Record "Requisition Line"; var IsHandled: Boolean)
    begin
    end;
}