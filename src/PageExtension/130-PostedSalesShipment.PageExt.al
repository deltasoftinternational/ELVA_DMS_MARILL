pageextension 25006000 "Posted Sales Shipment" extends "Posted Sales Shipment" //130
{
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

        modify(SalesShipmLines)
        {
            Visible = not VehicleTradeDocument;
        }

        addafter(SalesShipmLines)
        {
            part(SalesShipmLinesVehicle; "Posted Sales Shpt. Subf. V")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }

    }

    actions
    {
        addafter(PrintCertificateofSupply)
        {
            action(VehicleAssembly)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Assembly';
                Image = AssemblyOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Posted Veh. Assembly";
                RunPageLink = "Source ID" = const(110),
                                  "Source No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }

        modify("&Navigate")
        {
            Promoted = True;
            PromotedCategory = Process;
        }

        addafter("Update Document")
        {
            action(Action25006005)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(SalesShptHeader);
                    SalesShptHeader.PrintRecords(true);
                end;
            }
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
                        SalesShipmentLine: Record "Sales Shipment Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        SalesShipmentLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 12, DocReport);
                        DocMgt.SelectShipmentDocReport(DocReport, Rec, SalesShipmentLine, false);
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
                        SalesShipmentLine: Record "Sales Shipment Line";
                        //DocMgt: Codeunit DocumentManagementDMS; //FIXME BC16 Upgrade
                        DocReport: Record "Document Report";
                    begin
                        SalesShipmentLine.Reset;
                        //DocMgt.PrintCurrentDoc("Document Profile", 1, 12, DocReport);
                        //DocMgt.SelectShipmentDocReport(DocReport, Rec, SalesShipmentLine, true);
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
        SalesShptHeader: Record "Sales Shipment Header";
        VehicleTradeDocument: Boolean;
}