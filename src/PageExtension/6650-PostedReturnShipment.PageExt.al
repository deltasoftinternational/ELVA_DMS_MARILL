pageextension 25006108 "Posted Return Shipment" extends "Posted Return Shipment"//6650
{
    layout
    {
        addafter("Buy-from Contact No.")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
        modify(ReturnShptLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(ReturnShptLines)
        {
            part(ReturnShptLinesVehicle; "Posted Ret. Shpmt Subf.(Veh.)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }
    }
    actions
    {
        addafter("Update Document")
        {
            group(ActionGroup25006000)
            {
                Caption = 'Print';
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ReturnShipmentLine: Record "Return Shipment Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        ReturnShipmentLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 12, DocReport);
                        DocMgt.SelectRetShipmentDocReport(DocReport, Rec, ReturnShipmentLine, false);
                    end;
                }
                action(Email)
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ReturnShipmentLine: Record "Return Shipment Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        ReturnShipmentLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 12, DocReport);
                        DocMgt.SelectRetShipmentDocReport(DocReport, Rec, ReturnShipmentLine, true);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetSecurityFilterOnRespCenter;

        ActivateFields;

        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        //EDMS >>        
    end;

    var

        [InDataSet]

        VehicleTradeDocument: Boolean;
        FormatAddress: Codeunit "Format Address";
        IsShipToCountyVisible: Boolean;
        IsPayFromCountyVisible: Boolean;
        IsBuyFromCountyVisible: Boolean;

    local procedure ActivateFields()
    begin
        IsBuyFromCountyVisible := FormatAddress.UseCounty(Rec."Buy-from Country/Region Code");
        IsPayFromCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;
}

