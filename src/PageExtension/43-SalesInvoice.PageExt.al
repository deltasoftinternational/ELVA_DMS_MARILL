pageextension 25006015 "Sales Invoice" extends "Sales Invoice" //43
{
    layout
    {
        addafter("External Document No.")
        {
            field(DocumentProfile2; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
            field("Deal Type Code"; Rec."Deal Type Code")
            {
                ToolTip = 'Specifies the Deal Type Code that describes the type of document.';
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Contract No."; Rec."Contract No.")
            {
                ToolTip = 'Specifies the Contract this document is related to.';
                ApplicationArea = All;
            }
            field("Document Status"; Rec."Document Status")
            {
                ApplicationArea = All;
            }
        }
        addafter("Work Description")
        {
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
        modify(SalesLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(SalesLines)
        {
            part(SalesLinesVeh; "Sales Invoice Subform (Veh.)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                Visible = VehicleTradeDocument;
                UpdatePropagation = Both;
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
        addafter("Foreign Trade")
        {
            group(Service)
            {
                Caption = 'Service';
                field(DocumentProfile; Rec."Document Profile")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderNo; Rec."Service Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Order No.';
                }
                field(VehicleItemChargeNo; Rec."Vehicle Item Charge No.")
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
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }

    }
    actions
    {
        addafter("P&osting")
        {
            group(ActionGroup25006004)
            {
                Caption = '&Print';
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesLine: Record "Sales Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        SalesLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 2, DocReport);
                        DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine, false);
                    end;
                }
                action(Email)
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesLine: Record "Sales Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        SalesLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 2, DocReport);
                        DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine, true);
                    end;
                }
                action(PrintAndSign)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print & Sign';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Category7;
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
    trigger OnAfterGetRecord()
    begin
        VehicleTradeDocument := rec."Document Profile" = rec."document profile"::"Vehicles Trade";
        SparePartDocument := rec."Document Profile" = rec."document profile"::"Spare Parts Trade";
        ServiceDocument := rec."Document Profile" = rec."document profile"::Service;
        if ServiceDocument then
            if UserMgtEDMS.GetServiceFilterEDMS <> '' then begin
                rec.FilterGroup(2);
                rec.SetRange("Responsibility Center", UserMgtEDMS.GetServiceFilterEDMS);
                rec.FilterGroup(0);
            end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //EDMS >>
        case DocumentProfileFilter of
            Format(rec."document profile"::"Vehicles Trade"):
                begin
                    rec."Document Profile" := rec."document profile"::"Vehicles Trade";
                    VehicleTradeDocument := true;
                end;
            Format(rec."document profile"::"Spare Parts Trade"):
                begin
                    rec."Document Profile" := rec."document profile"::"Spare Parts Trade";
                    SparePartDocument := true;
                end;
            Format(rec."document profile"::Service):
                begin
                    rec."Document Profile" := rec."document profile"::Service;
                    ServiceDocument := true;
                end;
        end;
        //EDMS >>
    end;

    trigger OnOpenPage()
    begin
        //EDMS >>
        rec.FilterGroup(3);
        DocumentProfileFilter := rec.GetFilter("Document Profile");
        rec.FilterGroup(0);
        //EDMS <<
    end;

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        ServiceDocument: Boolean;
        DocumentProfileFilter: Text[250];
        UserMgtEDMS: Codeunit "UserProfileManagement";
}