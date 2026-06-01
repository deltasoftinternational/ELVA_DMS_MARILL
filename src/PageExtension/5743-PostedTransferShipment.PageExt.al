pageextension 25006091 "Posted Transfer Shipment" extends "Posted Transfer Shipment"//5743
{
    layout
    {
        modify(TransferShipmentLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(Shipment)
        {
            part(TransferShipmentLinesVehicle; "Pstd Trnsfr Shpt. Subf. (Veh.)")
            {
                SubPageLink = "Document No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }
        addafter("Foreign Trade")
        {
            group(Service)
            {
                field(DocumentProfile; Rec."Document Profile")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,,,Service';
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(SourceNo; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        IsFromCountyVisible := FormatAddress.UseCounty(Rec."Trsf.-from Country/Region Code");
        IsToCountyVisible := FormatAddress.UseCounty(Rec."Trsf.-to Country/Region Code");

        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        //EDMS >>
    end;

    var
        FormatAddress: Codeunit "Format Address";
        IsFromCountyVisible: Boolean;
        IsToCountyVisible: Boolean;
        [InDataSet]
        VehicleTradeDocument: Boolean;
}