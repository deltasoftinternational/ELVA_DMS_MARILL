pageextension 25006059 "Posted Purchase Credit Memo" extends "Posted Purchase Credit Memo"//140
{
    layout
    {
        modify(PurchCrMemoLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(PurchCrMemoLines)
        {
            part(PurchCrMemoLinesVehicle; "Posted Purch.Cr.Memo Sbf.(Veh)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            group(ActionGroup25006001)
            {
                Caption = 'Print';
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
                    begin
                        PurchCrMemoLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 10, DocReport);
                        DocMgt.SelectPurchCrMemoDocReport(DocReport, Rec, PurchCrMemoLine, false);
                    end;
                }
                action(Email)
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        PurchCrMemoLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 10, DocReport);
                        DocMgt.SelectPurchCrMemoDocReport(DocReport, Rec, PurchCrMemoLine, true);
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        Rec.SetSecurityFilterOnRespCenter;
        IsOfficeAddin := OfficeMgt.IsAvailable;

        ActivateFields;

        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        //EDMS >>
    end;

    var
        FormatAddress: Codeunit "Format Address";
        [InDataSet]
        VehicleTradeDocument: Boolean;
        IsOfficeAddin: Boolean;
        IsBuyFromCountyVisible: Boolean;
        IsPayToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;

    local procedure ActivateFields()
    begin
        IsBuyFromCountyVisible := FormatAddress.UseCounty(Rec."Buy-from Country/Region Code");
        IsPayToCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;
}