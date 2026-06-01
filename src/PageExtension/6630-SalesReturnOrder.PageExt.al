pageextension 25006102 "Sales Return Order" extends "Sales Return Order"//6630
{
    layout
    {
        modify("Sell-to Customer Name")
        {
            Visible = false;
        }
        addafter("Sell-to Customer Name")
        {
            /*   field("DMS Sell-to Customer Name"; Rec."Sell-to Customer Name")
               {
                   ApplicationArea = SalesReturnOrder;
                   Caption = 'Customer Name';
                   Importance = Promoted;
                   ShowMandatory = true;
                   ToolTip = 'Specifies the name of the customer.';

                   trigger OnValidate()
                   begin
                       Rec.SelltoCustomerNoOnAfterValidate(Rec, xRec);

                       if ApplicationAreaMgmtFacade.IsFoundationEnabled then
                           SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);

                       CurrPage.Update;
                   end;
               }*/

            field(DocumentProfile; Rec."Document Profile")
            {
                ApplicationArea = Basic;
                trigger OnValidate()
                begin
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

                    CurrPage.Update();
                end;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    exit(Rec.LookupSellToCustomerName(Text));
                end;
            }
        }
        addafter(Status)
        {
            field("Document Status"; Rec."Document Status")
            {
                ApplicationArea = All;
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
            field(DealTypeCode; Rec."Deal Type Code")
            {
                ApplicationArea = Basic;
            }
        }
        modify(SalesLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(SalesLines)
        {
            part(SalesLinesVeh; "Sales Return Order Subf.(Veh.)")
            {
                ApplicationArea = All;
                Caption = 'Vehicle Lines';
                SubPageLink = "Document No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }
        addafter("Transaction Specification")
        {
            field(PaymentTermsCode; Rec."Payment Terms Code")
            {
                ApplicationArea = Basic, Suite;
                Importance = Promoted;
                ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
            }
            field(PaymentMethodCode; Rec."Payment Method Code")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
            }
        }
        addafter("Foreign Trade")
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                Visible = SparePartDocument;
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
        addafter(AttachAsPDF)
        {
            group(ActionGroup25006010)
            {
                Caption = '&Print';
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
                        SalesLine: Record "Sales Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        SalesLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 5, DocReport);
                        DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine, false);
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
                        SalesLine: Record "Sales Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        SalesLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 5, DocReport);
                        DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine, true);
                    end;
                }
                action(PrintAndSign)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print & Sign';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SignManagement: Codeunit "Sign Management";
                    begin
                        SignManagement.CallSignAndPrintPageSales(Rec);
                    end;
                }
            }

        }

    }



    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetSalesFilter;
        if (not DocNoVisible) and (Rec."No." = '') then
            Rec.SetSellToCustomerFromFilter;
        //EDMS >>
        case DocumentProfileFilter of
            Format(Rec."document profile"::"Vehicles Trade"):
                begin
                    Rec."Document Profile" := rec."document profile"::"Vehicles Trade";
                    VehicleTradeDocument := true;
                end;
            Format(Rec."document profile"::"Spare Parts Trade"):
                begin
                    Rec."Document Profile" := rec."document profile"::"Spare Parts Trade";
                    SparePartDocument := true;
                end;
        end;
        //EDMS >>
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FilterGroup(0);
        end;

        ActivateFields;

        SetDocNoVisible;
        //EDMS >>
        Rec.FilterGroup(3);
        DocumentProfileFilter := Rec.GetFilter("Document Profile");
        Rec.FilterGroup(0);
        //EDMS <<
        if (Rec."No." <> '') and (Rec."Sell-to Customer No." = '') then
            DocumentIsPosted := (not Rec.Get(Rec."Document Type", Rec."No."));

        VehicleTradeDocument := rec."Document Profile" = rec."document profile"::"Vehicles Trade";
        SparePartDocument := rec."Document Profile" = rec."document profile"::"Spare Parts Trade";
    end;

    var
        FormatAddress: Codeunit "Format Address";
        DocumentIsPosted: Boolean;
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
        IsBillToCountyVisible: Boolean;
        IsSellToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;
        UserMgt: Codeunit "User Setup Management";
        DocNoVisible: Boolean;

    local procedure ActivateFields()
    begin
        IsBillToCountyVisible := FormatAddress.UseCounty(Rec."Bill-to Country/Region Code");
        IsSellToCountyVisible := FormatAddress.UseCounty(Rec."Sell-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::"Return Order", Rec."No.");
    end;

}
