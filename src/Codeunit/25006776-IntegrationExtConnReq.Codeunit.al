Codeunit 25006776 "Integration Ext. Conn. Req."
{
    TableNo = "Integration Message EDMS";

    trigger OnRun()
    begin
        Check(Rec);
        Process(Rec);

        // IF Warning THEN
        //  Rec.FinishHandling(2);
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
    begin
        MessageLine1.PrepareLinesOnMessage(MessageHeader);
        MessageLine1.FindFirst;

        // Fill data for document header

        if MessageLine2.PrepareLinesOnLine(MessageLine1) then
            repeat
            // Fill data for document line
            until MessageLine2.Next = 0;
    end;
}

