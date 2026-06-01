pageextension 25006104 "Purchase Return Order" extends "Purchase Return Order"//6640
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field(DealTypeCode; Rec."Deal Type Code")
            {
                ApplicationArea = Basic;
            }
        }
        modify(PurchLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(PurchLines)
        {
            part(PurchLinesVehicle; "Purch.Return Order Subf.(Veh.)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
                Visible = VehicleTradeDocument;
            }
        }
    }
    actions
    {
        addafter("P&osting")
        {
            group(ActionGroup25006002)
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
                        PurchLine: Record "Purchase Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        PurchLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 5, DocReport);
                        DocMgt.SelectPurchHdrDocReport(DocReport, Rec, PurchLine, false);
                    end;
                }
                action(EmailEDMS)
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PurchLine: Record "Purchase Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        PurchLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 5, DocReport);
                        DocMgt.SelectPurchHdrDocReport(DocReport, Rec, PurchLine, true);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        DocProfileMgt: Codeunit "Document Profile Mgt. EDMS";
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;
        if (not DocNoVisible) and (Rec."No." = '') then
            rec.SetBuyFromVendorFromFilter;

        //EDMS >>
        Rec."Document Profile" := DocProfileMgt.GetDefaultDocProfile();
        case Rec."Document Profile" of
            Rec."Document Profile"::"Vehicles Trade":
                begin
                    VehicleTradeDocument := true;
                end;
            Rec."Document Profile"::"Spare Parts Trade":
                begin
                    SparePartDocument := true;
                end;
        end;
        //EDMS >>
    end;

    trigger OnOpenPage()
    begin
        SetDocNoVisible;

        if UserMgt.GetPurchasesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter);
            Rec.FilterGroup(0);
        end;
        if (Rec."No." <> '') and (Rec."Buy-from Vendor No." = '') then
            DocumentIsPosted := (not Rec.Get(Rec."Document Type", Rec."No."));

        ActivateFields;
        //EDMS >>
        Rec.FilterGroup(3);
        DocumentProfileFilter := Rec.GetFilter("Document Profile");
        Rec.FilterGroup(0);
        //EDMS <<
        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        SparePartDocument := Rec."Document Profile" = Rec."document profile"::"Spare Parts Trade";
        //EDMS >>
    end;

    var

        UserMgt: Codeunit "User Setup Management";

        FormatAddress: Codeunit "Format Address";
        [InDataSet]
        VehicleTradeDocument: Boolean;
        DocNoVisible: Boolean;
        DocumentIsPosted: Boolean;
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
        IsBuyFromCountyVisible: Boolean;
        IsPayToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;

    local procedure ActivateFields()
    begin
        IsBuyFromCountyVisible := FormatAddress.UseCounty(Rec."Buy-from Country/Region Code");
        IsPayToCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::"Return Order", Rec."No.");
    end;

}
