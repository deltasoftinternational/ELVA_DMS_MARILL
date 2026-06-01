pageextension 25006092 "Posted Transfer Receipt" extends "Posted Transfer Receipt"//5745
{
    layout
    {
        modify(TransferReceiptLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addbefore("Transfer-from")
        {
            part(TransferReceiptLinesVehicle; "Pstd Trnsfr Rcpt. Subf. (Veh.)")
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
        VehicleTradeDocument := Rec."Document Profile" = rec."document profile"::"Vehicles Trade";
        //EDMS >>
    end;

    var
        FormatAddress: Codeunit "Format Address";
        IsFromCountyVisible: Boolean;
        IsToCountyVisible: Boolean;

        [InDataSet]
        VehicleTradeDocument: Boolean;
}