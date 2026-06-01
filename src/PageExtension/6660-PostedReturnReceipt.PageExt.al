pageextension 25006450 "Posted Return Receipt" extends "Posted Return Receipt"//6660
{
    layout
    {
        addafter("Sell-to Contact No.")
        {

            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
        addafter("No. Printed")
        {
            field(PhoneNo; Rec."Phone No.")
            {
                ApplicationArea = Basic;
                Editable = false;
                Importance = Additional;
            }
            field(MobilePhoneNo; Rec."Mobile Phone No.")
            {
                ApplicationArea = Basic;
                Editable = false;
                Importance = Additional;
            }
        }
        modify(ReturnRcptLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(ReturnRcptLines)
        {
            part(ReturnRcptLinesVehicle; "Posted Return Receipt Subf. V")
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
            group(ActionGroup25006003)
            {
                Caption = '&Print';
                Image = Print;
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ReturnReceiptLine: Record "Return Receipt Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        ReturnReceiptLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 11, DocReport);
                        DocMgt.SelectReturnReceiptDocReport(DocReport, Rec, ReturnReceiptLine, false);
                    end;
                }
                action(EmailEDMS)
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ReturnReceiptLine: Record "Return Receipt Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        ReturnReceiptLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 11, DocReport);
                        DocMgt.SelectReturnReceiptDocReport(DocReport, Rec, ReturnReceiptLine, true);
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
        IsBillToCountyVisible: Boolean;
        IsSellToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;

    local procedure ActivateFields()
    begin
        IsSellToCountyVisible := FormatAddress.UseCounty(Rec."Sell-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
        IsBillToCountyVisible := FormatAddress.UseCounty(Rec."Bill-to Country/Region Code");
    end;
}