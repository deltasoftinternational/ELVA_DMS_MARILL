pageextension 25006044 "Posted Sales Credit Memo" extends "Posted Sales Credit Memo" //134
{
    // 02.08.2018 EB.P30 EDMS Rent
    //   Added field:
    //     25006600 "Rent Order No."
    // 
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }

        addafter("Work Description")
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

        modify(SalesCrMemoLines)
        {
            Visible = not VehicleTradeDocument;
        }

        addafter(SalesCrMemoLines)
        {
            part(SalesCrMemoLinesVehicle; "Posted Sales Cr. Memo Subf. V")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }

        addafter("EU 3-Party Trade")
        {
            field(RentOrderNo; Rec."Rent Order No.")
            {
                ApplicationArea = Basic;
                Importance = Additional;
            }
        }

        addafter("Shipping and Billing")
        {
            group(Service)
            {
                Caption = 'Service';
                field(DocumentProfile; Rec."Document Profile")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ServiceReturnOrderNo; Rec."Service Return Order No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        addafter(ActivityLog)
        {
            group(ActionGroup25006004)
            {
                Caption = '&Print';
                Image = Print;
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                        SalesCrMemoLine: Record "Sales Cr.Memo Line";
                    begin
                        SalesCrMemoLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 10, DocReport);
                        DocMgt.SelectCrMemoDocReport(DocReport, Rec, SalesCrMemoLine, false);
                    end;
                }
                action(Email)
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesCrMemoLine: Record "Sales Cr.Memo Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        SalesCrMemoLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 10, DocReport);
                        DocMgt.SelectCrMemoDocReport(DocReport, Rec, SalesCrMemoLine, true);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        //EDMS >>
    end;

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
}