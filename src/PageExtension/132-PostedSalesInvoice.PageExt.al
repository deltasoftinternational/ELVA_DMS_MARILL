pageextension 25006043 "Posted Sales Invoice" extends "Posted Sales Invoice" //132
{
    // 02.08.2018 EB.P30 EDMS Rent
    //   Added field:
    //     25006600 "Rent Order No."
    // 
    // 30.08.2017 EB.P30 Vehicle Assembly to Posted
    //   Added Action:
    //     VehicleAssembly
    // 
    // 27.05.2016 EB.P30 EDMS
    //   Added actions:
    //     Print
    //     Email
    // 
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 23.01.2013 EDMS P8
    //   * Added field: Resources
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

        modify(SalesInvLines)
        {
            Visible = not VehicleTradeDocument;
        }

        addafter(SalesInvLines)
        {
            part(SalesInvLinesVehicle; "Posted Sales Invoice Subf. V")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }

        addafter("Payment Method Code")
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
                    Editable = false;
                }
                field(ServiceOrderNo; Rec."Service Order No.")
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
                }
                field(Resources; Rec.Resources)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        addafter(DocAttach)
        {
            action(BLSLeasingSchedule)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Leasing Schedule';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'View leasing schedule for the order.';

                trigger OnAction()
                var
                    BLSLeasingScheduleHeader: record "BLS Leasing Schedule Header";
                //LeaseScheduleCard: page "BLS Leasing Schedule Card";
                begin
                    BLSLeasingScheduleHeader.Reset();
                    BLSLeasingScheduleHeader.SetRange("Sales Doc. Type", BLSLeasingScheduleHeader."Sales Doc. Type"::"Posted Invoice");
                    BLSLeasingScheduleHeader.SetRange("Sales Doc. No.", Rec."No.");
                    if BLSLeasingScheduleHeader.Count() = 1 then begin
                        BLSLeasingScheduleHeader.FindFirst();
                        //LeaseScheduleCard.SetRecord(BLSLeasingScheduleHeader);
                        //LeaseScheduleCard.SetTableView(BLSLeasingScheduleHeader);
                        //LeaseScheduleCard.Run();
                        page.run(Page::"BLS Leasing Schedule Card", BLSLeasingScheduleHeader);
                    end else
                        if BLSLeasingScheduleHeader.Count() > 1 then begin
                            BLSLeasingScheduleHeader.FindSet();
                            page.run(Page::"BLS Leasing Schedule List", BLSLeasingScheduleHeader);
                        end else
                            Error(NoLeasingScheduleErr);
                end;
            }
        }

        addafter(ChangePaymentService)
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
                RunPageLink = "Source ID" = const(112),
                                  "Source No." = field("No.");
                Visible = VehicleTradeDocument;
            }
            action(ProcessChecklists)
            {
                ApplicationArea = Basic;
                Caption = 'Process Checklists';
                Image = CheckList;
                RunObject = Page "Process Checklist List";
                RunPageLink = "Source Type" = const(112),
                                  "Source ID" = field("No.");
            }
        }

        addafter(Invoice)
        {
            group(ActionGroup25006008)
            {
                Caption = '&Print';
                Image = Print;
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesInvLine: Record "Sales Invoice Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        SalesInvLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 9, DocReport);
                        DocMgt.SelectSalesInvDocReport(DocReport, Rec, SalesInvLine, false);
                    end;
                }
                action("&Email")
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesInvLine: Record "Sales Invoice Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        SalesInvLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 9, DocReport);
                        DocMgt.SelectSalesInvDocReport(DocReport, Rec, SalesInvLine, true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        //EDMS <<
    end;

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        NoLeasingScheduleErr: Label 'There are no Leasing Schedule for this invoice';

}
