pageextension 25006045 "Posted Purchase Receipt" extends "Posted Purchase Receipt" //136
{
    // 30.08.2017 EB.P30 Vehicle Assembly to Posted
    //   Added Action:
    //     VehicleAssembly
    layout
    {
        modify(PurchReceiptLines)
        {
            Visible = not VehicleTradeDocument;
        }

        addafter(PurchReceiptLines)
        {
            part(PurchReceiptLinesVehicle; "Posted Purch. Rcpt. Subf.(Veh)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }
    }

    actions
    {
        addafter(Approvals)
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
                RunPageLink = "Source ID" = const(120),
                                  "Source No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }

        modify("&Print")
        {
            Visible = false;
        }

        addafter("&Navigate")
        {
            group(ActionGroup25006002)
            {
                Caption = 'Print';
                action("&EDMSPrint")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                        PurchRcptLine: Record "Purch. Rcpt. Line";
                    begin
                        PurchRcptLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 11, DocReport);
                        DocMgt.SelectPurchRcptDocReport(DocReport, Rec, PurchRcptLine, false);
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
                        PurchRcptLine: Record "Purch. Rcpt. Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        PurchRcptLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 11, DocReport);
                        DocMgt.SelectPurchRcptDocReport(DocReport, Rec, PurchRcptLine, true);
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