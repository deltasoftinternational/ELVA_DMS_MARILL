pageextension 25006006 "Vendor Card" extends "Vendor Card" //26
{
    layout
    {
        addafter(Receiving)
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
        addafter("Prices Including VAT")
        {
            field("Non Stock Item Price List Code"; Rec."Non Stock Item Price List Code")
            {
                ApplicationArea = all;
            }
        }
    }
}