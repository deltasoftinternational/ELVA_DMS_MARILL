pageextension 25006084 "Sales Quote Archive" extends "Sales Quote Archive"//5162
{
    layout
    {
        addafter(Status)
        {
            field(VehicleSerialNo; Rec."Vehicle Serial No.")
            {
                ApplicationArea = Basic;
                Visible = SparePartDocument;
            }
            field(VIN; Rec.VIN)
            {
                ApplicationArea = Basic;
                Visible = SparePartDocument;
            }
            field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
            {
                ApplicationArea = Basic;
            }
            field(PhoneNo; Rec."Phone No.")
            {
                ApplicationArea = Basic;
                Importance = Additional;
            }
            field(MobilePhoneNo; Rec."Mobile Phone No.")
            {
                ApplicationArea = Basic;
                Importance = Additional;
            }
        }
        modify(SalesLinesArchive)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(SalesLinesArchive)
        {
            part(SalesLinesArchVeh; "Sales Quote Arch. Subf. (Veh.)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                              "Version No." = field("Version No.");
                Visible = VehicleTradeDocument;
            }
        }
        addafter("Tax Area Code")
        {
            field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = Basic;
                Visible = SparePartDocument;
            }
            field(DealTypeCode; Rec."Deal Type Code")
            {
                ApplicationArea = Basic;
                Visible = SparePartDocument;
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            action("Quote Analysis")
            {
                ApplicationArea = Basic;
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    QuoteAnalysis: Page "Sales Offer Analysis Archive";
                begin
                    QuoteAnalysis.SetParams(Rec."No.", 0, Rec."Version No.");
                    QuoteAnalysis.Run;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        IsSellToCountyVisible := FormatAddress.UseCounty(Rec."Sell-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
        IsBillToCountyVisible := FormatAddress.UseCounty(Rec."Bill-to Country/Region Code");

        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        SparePartDocument := Rec."Document Profile" = Rec."document profile"::"Spare Parts Trade";
        //EDMS >> 
    end;

    var
        IsShipToCountyVisible: Boolean;
        IsSellToCountyVisible: Boolean;
        IsBillToCountyVisible: Boolean;
        FormatAddress: Codeunit "Format Address";
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        SparePartDocument: Boolean;
}