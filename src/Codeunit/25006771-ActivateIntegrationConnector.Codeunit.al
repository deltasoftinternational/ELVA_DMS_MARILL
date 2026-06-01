Codeunit 25006771 "Activate Integration Connector"
{
    // #Owner EDMS.Integration

    TableNo = "Integration Connector EDMS";

    trigger OnRun()
    begin
        IntegrationConnector.Copy(Rec);
        CheckConnector;
        Rec := IntegrationConnector;
    end;

    var
        IntegrationConnector: Record "Integration Connector EDMS";

    local procedure CheckConnector()
    begin
        // Check configuration
        IntegrationConnector.TestField("Dealer ID");
    end;
}

