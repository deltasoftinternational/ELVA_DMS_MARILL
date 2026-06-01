Codeunit 25006774 "Integration Message-Finalize"
{
    TableNo = "Integration Message EDMS";

    trigger OnRun()
    begin
        Check(Rec);
        Process(Rec);
    end;

    var
        IntegrationSetup: Record "Integration Setup EDMS";
        IntegrationMethod: Record "Integration Method EDMS";
        IntegrationConnector: Record "Integration Connector EDMS";
        IntegrationConnectorSetup: Record "Integration Connector Setup";

    local procedure Check(var MessageHeader: Record "Integration Message EDMS")
    begin
        MessageHeader.TestField("Connector Code");
        MessageHeader.TestField("Method Code");
        MessageHeader.TestField(Status, MessageHeader.Status::Waiting);

        IntegrationSetup.Get;
        IntegrationSetup.TestField("Integration Is Active", true);
        IntegrationSetup.TestField("Company Name", COMPANYNAME);

        IntegrationMethod.Get(MessageHeader."Method Code");
        IntegrationMethod.TestField("Is Active", true);

        IntegrationConnector.Get(MessageHeader."Connector Code");

        // IntegrationConnector.TESTFIELD("Connection Address");
        // IntegrationConnector.TESTFIELD("User ID");
        // IntegrationConnector.TESTFIELD(Password);

        IntegrationConnectorSetup.Get(MessageHeader."Connector Code", MessageHeader."Method Code");
        IntegrationConnectorSetup.TestField("Response Handler Codeunit ID");
    end;

    local procedure Process(var MessageHeader: Record "Integration Message EDMS")
    var
        MessageLine1: Record "Integration Message Line EDMS";
        MessageLine2: Record "Integration Message Line EDMS";
        ItemPurchDocMgt: Codeunit "Item Purch. Doc. Mgt. EDMS";
    begin
        case MessageHeader."Method Code" of
            'I310':
                ItemPurchDocMgt.SubmitPurchOrderResp(MessageHeader);
            else
                Error('Unknown method code.');
        end;
    end;
}

