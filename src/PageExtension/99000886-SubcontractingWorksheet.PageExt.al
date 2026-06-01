pageextension 25006150 "Subcontracting Worksheet" extends "Subcontracting Worksheet"//99000886
{

    actions
    {
        modify(CarryOutActionMessage)
        {
            Visible = false;
        }
        addafter(CarryOutActionMessage)
        {
            action(DMSCarryOutActionMessage)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Carry &Out Action Message';
                Ellipsis = true;
                Image = CarryOutActionMessage;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';

                trigger OnAction()
                begin
                    CarryOutActionMsg();
                end;
            }
        }
    }

    var
        myInt: Integer;

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
    end;

    [IntegrationEvent(false, false)]
    local procedure DMSOnBeforeCarryOutActionMsg(var RequisitionLine: Record "Requisition Line"; var IsHandled: Boolean);
    begin
    end;
}