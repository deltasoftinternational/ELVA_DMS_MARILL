pageextension 25006013 "Sales Quote" extends "Sales Quote" //41
{
    layout
    {
        addafter("External Document No.")
        {
            field(DealTypeCode; Rec."Deal Type Code")
            {
                ApplicationArea = Basic;
            }
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

                    CurrPage.Update;
                end;
            }
        }
        addafter("Your Reference")
        {
            field(QuoteApplicableToDate; Rec."Quote Applicable To Date")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Assigned User ID")
        {
            field("Contract No."; Rec."Contract No.")
            {
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
            part(SalesLinesVeh; "Sales Quote Subform (Veh.)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }
        addafter("Foreign Trade")
        {
            group(Control1101904005)
            {
                Caption = 'Vehicle';
                Visible = SparePartDocument;
                field("<Vehicle Serial No.2>"; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field("<VIN2>"; Rec.VIN)
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
        addafter(Dimensions)
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
                begin
                    BLSLeasingScheduleHeader.Reset();
                    BLSLeasingScheduleHeader.SetRange("Sales Doc. Type", BLSLeasingScheduleHeader."Sales Doc. Type"::Quote);
                    BLSLeasingScheduleHeader.SetRange("Sales Doc. No.", Rec."No.");
                    if BLSLeasingScheduleHeader.Count() = 1 then begin
                        BLSLeasingScheduleHeader.FindFirst();
                        page.run(Page::"BLS Leasing Schedule Card", BLSLeasingScheduleHeader);
                    end else
                        if BLSLeasingScheduleHeader.Count() > 1 then begin
                            BLSLeasingScheduleHeader.FindSet();
                            page.run(Page::"BLS Leasing Schedule List", BLSLeasingScheduleHeader);
                        end else begin
                            Rec.CalcFields("Amount Including VAT");
                            BLSLeasingScheduleHeader.Init();
                            BLSLeasingScheduleHeader.Validate("Customer No.", Rec."Bill-to Customer No.");
                            BLSLeasingScheduleHeader.Validate("Sales Amount", Rec."Amount Including VAT");
                            BLSLeasingScheduleHeader."Sales Doc. Type" := BLSLeasingScheduleHeader."Sales Doc. Type"::Quote;
                            BLSLeasingScheduleHeader."Sales Doc. No." := Rec."No.";
                            BLSLeasingScheduleHeader.Insert(true);
                            Rec.Modify();
                            page.run(Page::"BLS Leasing Schedule Card", BLSLeasingScheduleHeader);
                        end;
                end;
            }
        }
        addafter(History)
        {
            group(Vehicle)
            {
                Caption = '&Vehicle';
                action(ProcessChecklists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Checklists';
                    Image = CheckList;
                    RunObject = Page "Process Checklist List";
                    RunPageLink = "Source Profile" = field("Document Profile"),
                                  "Source Type" = const(36),
                                  "Source Subtype" = field("Document Type"),
                                  "Source ID" = field("No.");
                }
            }
        }
        addafter("Archive Document")
        {
            action(CopyDocumenttoServiceQuote)
            {
                ApplicationArea = Basic;
                Caption = 'Copy Document to Service Quote';
                Image = Copy;

                trigger OnAction()
                var
                    ServiceQuote: Record "Service Header EDMS";
                begin
                    DocumentManagementDMS.CopySalesQuoteToServQuote(ServiceQuote, Rec."No.");
                end;
            }
            action(QuoteAnalysis)
            {
                ApplicationArea = Basic;
                Caption = 'Quote Analysis';
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    QuoteAnalysis: Page "Sales Offer Analysis";
                begin
                    QuoteAnalysis.SetParams(Rec."No.", 0);
                    QuoteAnalysis.Run;
                end;
            }

        }
        addafter(IncomingDocument)
        {
            group("<Action223>")
            {
                Caption = '&Print';
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesLine: Record "Sales Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        SalesLine.Reset;
                        DocMgt.PrintCurrentDoc(rec."Document Profile", 1, 0, DocReport);
                        DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine, false);
                    end;
                }
                action("&Email")
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesLine: Record "Sales Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        SalesLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 0, DocReport);
                        DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine, true);
                    end;
                }
                action(PrintAndSign)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print & Sign';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Category9;
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
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        SparePartDocument := Rec."Document Profile" = Rec."document profile"::"Spare Parts Trade";
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        LostSaleMgt.OnSalesHeaderDelete(Rec); //EDMS
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.DefineProfileRange;
        //EDMS >>
        case DocumentProfileFilter of
            Format(Rec."document profile"::"Vehicles Trade"):
                begin
                    Rec."Document Profile" := rec."document profile"::"Vehicles Trade";
                    VehicleTradeDocument := true;
                end;
            Format(Rec."document profile"::"Spare Parts Trade"):
                begin
                    Rec."Document Profile" := Rec."document profile"::"Spare Parts Trade";
                    SparePartDocument := true;
                end;
        end;
    end;

    trigger OnOpenPage()
    begin
        //EDMS >>
        Rec.FilterGroup(3);
        DocumentProfileFilter := Rec.GetFilter("Document Profile");
        Rec.FilterGroup(0);
        //EDMS <<
    end;

    var
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        [InDataSet]
        BilltoCustomerTemplateCodeEnab: Boolean;
        [InDataSet]
        SelltoCustomerTemplateCodeEnab: Boolean;
        [InDataSet]
        "Sell-to Customer No.Enable": Boolean;
        [InDataSet]
        "Bill-to Customer No.Enable": Boolean;
        TextDlg001: label 'Default,Spare Parts Trade,Vehicles Trade';
        Text000: label 'Unable to run this function while in View mode.';
        DocumentProfileFilter: Text[250];
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        SparePartDocument: Boolean;
        LostSaleMgt: Codeunit "Lost Sales Management";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        DocumentManagementDMS: Codeunit DocumentManagementDMS;

    local procedure UpdateAllowed(): Boolean
    begin
        if CurrPage.Editable = false then begin
            Message(Text000);
            exit(false);
        end;
        exit(true);
    end;
}
