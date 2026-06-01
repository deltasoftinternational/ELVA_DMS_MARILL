pageextension 25006046 "Posted Purchase Invoice" extends "Posted Purchase Invoice" //138
{
    // 30.08.2017 EB.P30 Vehicle Assembly to Posted
    //   Added Action:
    //     VehicleAssembly
    layout
    {
        modify(PurchInvLines)
        {
            Visible = not VehicleTradeDocument;
        }

        addafter(PurchInvLines)
        {
            part(PurchInvLinesVehicle; "Posted Purch. Inv. Subf. (Veh)")
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
                RunPageLink = "Source ID" = const(122),
                                  "Source No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }
        modify(Print)
        {
            Visible = false;
        }

        addafter(Print)
        {
            group(ActionGroup25006000)
            {
                Caption = 'Print';
                action(EDMSPrint)
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
                        PurchInvLine: Record "Purch. Inv. Line";
                    begin
                        PurchInvLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 9, DocReport);
                        DocMgt.SelectPurchInvDocReport(DocReport, Rec, PurchInvLine, false);
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
                        PurchInvLine: Record "Purch. Inv. Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        PurchInvLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 9, DocReport);
                        DocMgt.SelectPurchInvDocReport(DocReport, Rec, PurchInvLine, true);
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
