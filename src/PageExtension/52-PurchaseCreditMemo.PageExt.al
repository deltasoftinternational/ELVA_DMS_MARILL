pageextension 25006209 "Purchase Credit Memo" extends "Purchase Credit Memo"//52
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {

            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
            field("Deal Type Code"; Rec."Deal Type Code")
            {
                ToolTip = 'Specifies the Deal Type Code that describes the type of document.';
                Importance = Additional;
                ApplicationArea = All;
            }
        }
        modify(PurchLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(PurchLines)
        {
            part(PurchLinesVehicle; "Purch. Cr. Memo Subform (Veh.)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
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
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 3, DocReport);
                        DocMgt.SelectPurchHdrDocReport(DocReport, Rec, PurchLine, false);
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
                        PurchLine: Record "Purchase Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        PurchLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 3, DocReport);
                        DocMgt.SelectPurchHdrDocReport(DocReport, Rec, PurchLine, true);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
        EnvironmentInfo: Codeunit "Environment Information";
    begin
        SetDocNoVisible;
        IsOfficeAddin := OfficeMgt.IsAvailable;
        IsSaaS := EnvironmentInfo.IsSaaS;

        if UserMgt.GetPurchasesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter);
            Rec.FilterGroup(0);
        end;
        //EDMS >>
        Rec.FilterGroup(3);
        DocumentProfileFilter := Rec.GetFilter("Document Profile");
        Rec.FilterGroup(0);
        //EDMS <<
        if (Rec."No." <> '') and (Rec."Buy-from Vendor No." = '') then
            DocumentIsPosted := (not Rec.Get(Rec."Document Type", Rec."No."));

        Rec.SetRange("Date Filter", 0D, WorkDate());

        ActivateFields;
        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        SparePartDocument := Rec."Document Profile" = Rec."document profile"::"Spare Parts Trade";
        ServiceDocument := Rec."Document Profile" = Rec."document profile"::Service;
        //EDMS >>
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        DocProfileMgt: Codeunit "Document Profile Mgt. EDMS";
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;

        if (not DocNoVisible) and (Rec."No." = '') then
            Rec.SetBuyFromVendorFromFilter;

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

    var
        UserMgt: Codeunit "User Setup Management";
        FormatAddress: Codeunit "Format Address";

        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        ServiceDocument: Boolean;

        DocumentProfileFilter: Text[250];
        DocNoVisible: Boolean;
        IsOfficeAddin: Boolean;
        CreateIncomingDocFromEmailAttachment: Boolean;
        CreateIncomingDocumentVisible: Boolean;
        IsSaaS: Boolean;
        DocumentIsPosted: Boolean;
        IsBuyFromCountyVisible: Boolean;
        IsPayToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;


    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Quote, Rec."No.");
    end;

    local procedure ActivateFields()
    begin
        IsBuyFromCountyVisible := FormatAddress.UseCounty(Rec."Buy-from Country/Region Code");
        IsPayToCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;
}