pageextension 25006030 "Item Category Card" extends "Item Category Card"//5733
{
    layout
    {
        addlast(content)
        {
            group(DMSIntegration)
            {
                Caption = 'DMS Integration';
                field(IntegrationConnectorCode; Rec."Integration Connector Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}