pageextension 25006086 "Purchase Order Archive" extends "Purchase Order Archive"//5167
{
    layout
    {

        modify(PurchLinesArchive)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(PurchLinesArchive)
        {
            part(PurchLinesArchiveVeh; "Purch. Quote Arch. Sub. (Veh.)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                              "Version No." = field("Version No.");
                Visible = VehicleTradeDocument;
            }
        }
    }
    trigger OnOpenPage()
    begin
        IsBuyFromCountyVisible := FormatAddress.UseCounty(Rec."Buy-from Country/Region Code");
        IsPayToCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");

        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        SparePartDocument := Rec."Document Profile" = Rec."document profile"::"Spare Parts Trade";
        //EDMS >> 
    end;

    var
        FormatAddress: Codeunit "Format Address";
        IsBuyFromCountyVisible: Boolean;
        IsPayToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        SparePartDocument: Boolean;
}