pageextension 25006014 "Sales Order" extends "Sales Order" //42
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(DealTypeCode; Rec."Deal Type Code")
            {
                ApplicationArea = Basic;
            }
            field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
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
        addafter("Job Queue Status")
        {
            field(ContractNo; Rec."Contract No.")
            {
                ApplicationArea = Basic;
            }
            field("Document Status"; Rec."Document Status")
            {
                ApplicationArea = All;
            }
        }
        addafter("Work Description")
        {
            field(Control25006002; Rec."Phone No.")
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
            part(SalesLinesVehicle; "Sales Order Subform (Veh.)")
            {
                ApplicationArea = All;
                Editable = DynamicEditable;
                Enabled = Rec."Sell-to Customer No." <> '';
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
                Visible = VehicleTradeDocument;
            }
        }
        addafter("Direct Debit Mandate ID")
        {
            field(Correction; Rec.Correction)
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Control1900201301)
        {
            group(Control1101904001)
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
        addafter(DocAttach)
        {
            action(ItemOrderOverview)
            {
                ApplicationArea = Basic;
                Caption = 'Item Order Overview';
                Image = ItemInvoice;

                trigger OnAction()
                var
                    ItemOrderOverview: Page "Item Order Overview";
                begin
                    ItemOrderOverview.SetSourceType2(1);
                    ItemOrderOverview.SetDocumentFilter(Rec."No.");
                    ItemOrderOverview.Run;
                    ItemOrderOverview.FindRec;
                end;
            }
            action(AvailabilityByLocation)
            {
                ApplicationArea = Basic;
                Caption = 'Availability by Location';
                Image = ItemAvailbyLoc;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show a list of items grouped by location.';

                trigger OnAction()
                var
                    ItemByLocation: Page "Items by Location EDMS";
                begin
                    ItemByLocation.SetParams(Database::"Sales Header", Rec."Document Type", Rec."No.");
                    ItemByLocation.RunModal;
                end;
            }
        }
        addafter(Invoices)
        {
            action(BLSLeasingSchedule)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Leasing Schedule';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Category12;
                ToolTip = 'View leasing schedule for the order.';

                trigger OnAction()
                var
                    BLSLeasingScheduleHeader: record "BLS Leasing Schedule Header";
                begin
                    BLSLeasingScheduleHeader.Reset();
                    BLSLeasingScheduleHeader.SetRange("Sales Doc. Type", BLSLeasingScheduleHeader."Sales Doc. Type"::Order);
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
                            BLSLeasingScheduleHeader."Sales Doc. Type" := BLSLeasingScheduleHeader."Sales Doc. Type"::Order;
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
        addafter(IncomingDocument)
        {
            action("<Action1101904040>")
            {
                ApplicationArea = Basic;
                Caption = 'Split Document';
                Ellipsis = true;
                Image = Splitlines;

                trigger OnAction()
                begin
                    SalesSplittingLine.OpenFormForDoc(Rec);
                end;
            }
            action(RefreshCosts)
            {
                ApplicationArea = Basic;
                Caption = 'Refresh Costs';
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemCostManagement: Codeunit "Item Cost Management";
                begin
                    ItemCostManagement.RefreshCostsSale(Rec);
                    CurrPage.Update;
                end;
            }
            action(CreateContract)
            {
                ApplicationArea = All;
                Caption = 'Create Contract';
                Image = AddContacts;

                trigger OnAction()
                var
                    DocManagementDMS: Codeunit DocumentManagementDMS;
                begin
                    DocManagementDMS.CreateContractFromSalesOrder(Rec);
                    CurrPage.Update;
                end;
            }
        }
        addbefore(SendApprovalRequest)
        {
            action("Prepayment-Change Bill-to Cust.")
            {
                ApplicationArea = Basic;
                Caption = 'Prepayment-Change Bill-to Cust.';
                Image = Prepayment;

                trigger OnAction()
                var
                    SalesPostPrepayment: Codeunit "Sales-Post Prepayments";
                    SalesPostEventManagement: Codeunit "Sales Post Event Management";
                begin
                    Clear(SalesPostPrepayment);
                    SalesPostEventManagement.ChangeBillToCustomer(Rec);
                end;
            }
        }
        addbefore("Work Order")
        {
            action(OrderConfirmation)
            {
                ApplicationArea = Basic;
                Caption = 'Order Confirmation';
                Ellipsis = true;
                Image = Print;
                Visible = false;

                trigger OnAction()
                begin
                    DocPrint.PrintSalesOrder(Rec, Usage::"Order Confirmation");
                end;
            }
        }
        modify("Work Order")
        {
            Visible = false;
        }
        modify("Pick Instruction")
        {
            Visible = false;
        }
        addafter("Pick Instruction")
        {
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
                    DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 1, DocReport);
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
                    DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 1, DocReport);
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
            action(EmailAndSign)
            {
                ApplicationArea = Basic;
                Caption = 'Email & Sign';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SignManagement: Codeunit "Sign Management";
                begin
                    SignManagement.CallSignAndEmailPageSales(Rec);
                end;
            }
        }
        addafter(OrderConfirmation)
        {
            group(DMSIntegration)
            {
                Caption = 'DMS Integration';
                action(GetPrice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Price';
                    Image = Price;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ShowIntegrationActionGetPrice;

                    trigger OnAction()
                    var
                        ItemIntegrationMgt: Codeunit "Integration Message Mgt. EDMS";
                    begin
                        //ItemIntegrationMgt.GetPriceForSalesDoc(Rec);
                    end;
                }
                action(GetAvailability)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Availability';
                    Image = AvailableToPromise;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ShowIntegrationActionGetAvailability;

                    trigger OnAction()
                    var
                        Item: Record Item;
                        ItemIntegrationMgt: Codeunit "Integration Message Mgt. EDMS";
                    begin
                        // ItemIntegrationMgt.GetAvailabilityForItems(Rec);
                    end;
                }
            }
        }

    }
    trigger OnAfterGetCurrRecord()
    begin
        DynamicEditable := CurrPage.Editable;
        SetDMSIntegrationActionsVisibility;   // ASMX
    end;

    trigger OnAfterGetRecord()
    begin
        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        SparePartDocument := Rec."Document Profile" = Rec."document profile"::"Spare Parts Trade";
        //EDMS >>
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        LostSaleMgt.OnSalesHeaderDelete(Rec); //EDMS
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        DocProfileMgt: Codeunit "Document Profile Mgt. EDMS";
    begin
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
        //EDMS >>
        rec.FilterGroup(3);
        DocumentProfileFilter := Rec.GetFilter("Document Profile");
        rec.FilterGroup(0);
        //EDMS <<
    end;


    var
        SalesSplittingLine: Record "Sales Splitting Line";
        SalesInvHeader: Record "Sales Header";
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        SparePartDocument: Boolean;
        DynamicEditable: Boolean;
        DocumentProfileFilter: Text[250];
        LostSaleMgt: Codeunit "Lost Sales Management";
        DMSIntegrationMgt: Codeunit "Integration Management EDMS";
        ShowIntegrationActionGetPrice: Boolean;
        ShowIntegrationActionGetAvailability: Boolean;
        DocPrint: Codeunit "Document-Print";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";

    local procedure SetDMSIntegrationActionsVisibility()
    var
        ActionCode: array[10] of Code[20];
        ActionIsEnabled: array[10] of Boolean;
    begin
        if ActionCode[1] = '' then begin
            ActionCode[1] := 'ITEM_GET_PRICE';
            ActionCode[2] := 'ITEM_GET_AVAILABLE';
        end;

        // DMSIntegrationMgt.IsEnabledActionsByArr10(DMSIntegrationMgt.GetConnectorCodeByVendor("Buy-from Vendor No."),
        //                                           ActionCode, ActionIsEnabled);
        ActionIsEnabled[1] := DMSIntegrationMgt.IsIntegrationActive;
        ShowIntegrationActionGetPrice := ActionIsEnabled[1];
        ShowIntegrationActionGetAvailability := ActionIsEnabled[2];
    end;

}