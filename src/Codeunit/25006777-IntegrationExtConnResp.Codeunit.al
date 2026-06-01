Codeunit 25006777 "Integration Ext. Conn. Resp."
{
    TableNo = "Integration Message EDMS";

    trigger OnRun()
    begin
        if Rec.ID = 0 then
            Rec.FindLast;

        Check(Rec);
        Process(Rec);
    end;

    var
        IntegrationConnector: Record "Integration Connector EDMS";
        IntegrationConnectorSetup: Record "Integration Connector Setup";

    local procedure Check(var MessageHeader: Record "Integration Message EDMS")
    begin
        IntegrationConnector.Get(MessageHeader."Connector Code");
        // IntegrationConnector.TESTFIELD("Connection Address");
        // IntegrationConnector.TESTFIELD("User ID");
        // IntegrationConnector.TESTFIELD(Password);

        IntegrationConnectorSetup.Get(MessageHeader."Connector Code", MessageHeader."Method Code");
    end;

    local procedure Process(var MessageHeader: Record "Integration Message EDMS")
    var
        MessageLine1: Record "Integration Message Line EDMS";
        MessageLine2: Record "Integration Message Line EDMS";
        PurchHeader: Record "Purchase Header";
    begin
        MessageLine1.PrepareLinesOnMessage(MessageHeader);
        MessageLine1.FindFirst;

        MessageLine1."Response Status" := MessageLine1."response status"::OK;
        MessageLine1.Modify;
        Commit;
        // Fill data for document header
        /*
        IF MessageLine2.PrepareLinesOnLine(MessageLine1) THEN
          REPEAT
            // Fill data for document line
          UNTIL MessageLine2.NEXT = 0;
        */

        MessageHeader.FinishHandling(0);

    end;
}

