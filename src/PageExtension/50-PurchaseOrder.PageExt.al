pageextension 25006204 "Purchase Order" extends "Purchase Order"//50
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
        addafter("Job Queue Status")
        {
            field(DealTypeCode; Rec."Deal Type Code")
            {
                ApplicationArea = Basic;
            }
            field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
            {
                ApplicationArea = Basic;
            }
            field(DocumentVendorStatus; Rec."Document Vendor Status")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(DMSIntegrationStatus; Rec."DMS Integration Status")
            {
                ApplicationArea = Basic;
            }
        }
        modify(PurchLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(PurchLines)
        {
            part(PurchLinesVehicle; "Purchase Order Subform (Veh.)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                Visible = VehicleTradeDocument;
            }
        }
        addafter("Promised Receipt Date")
        {
            field(Correction; Rec.Correction)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Attached Documents List")
        {
            part(Control25006005; "Integration Message Info Sub")
            {
                Caption = 'DMS Integration Info (Header)';
                SubPageLink = "Source Type" = const(38),
                              "Source Subtype" = field("Document Type"),
                              "Source ID" = field("No.");
            }
            part(Control25006004; "Integration Message Params Sub")
            {
                Caption = 'DMS Integration Params (Header)';
                SubPageLink = "Source Type" = const(38),
                              "Source Subtype" = field("Document Type"),
                              "Source ID" = field("No.");
                Visible = false;
            }
            part(Control25006007; "Integration Message Info Sub")
            {
                Caption = 'DMS Integration Info (Line)';
                Provider = PurchLines;
                SubPageLink = "Source Type" = const(39),
                              "Source Subtype" = field("Document Type"),
                              "Source ID" = field("Document No.");
            }
            part(Control25006006; "Integration Message Params Sub")
            {
                Caption = 'DMS Integration Params (Line)';
                Provider = PurchLines;
                SubPageLink = "Source Type" = const(39),
                              "Source Subtype" = field("Document Type"),
                              "Source ID" = field("Document No.");
                Visible = false;
            }
        }
        addafter(WorkflowStatus)
        {
            part(Control10023; "Purch. Reservation FactBox")
            {
                Provider = PurchLines;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
                Visible = false;
            }
        }
    }
    actions
    {
        addafter("Get &Sales Order")
        {
            action(getservord)
            {
                ApplicationArea = Basic;
                Caption = 'Get &Service Orders';

                trigger OnAction()
                var
                    DistIntegration: Codeunit "Dist. Integration";
                    PurchHeader: Record "Purchase Header";
                    "ApplicationEventMgt": Codeunit "Application Event Management";
                begin
                    PurchHeader.Copy(Rec);
                    ApplicationEventMgt.GetSpecialServiceOrders(PurchHeader);
                    Rec := PurchHeader;
                end;
            }
            action(ShowOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Show &Order';
            }
        }
        addafter(Warehouse)
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
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No.");
                }
            }
        }

        addlast(processing)
        {
            group(DMSPrint)
            {
                action("<Action1101904032>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PurchaseLine: Record "Purchase Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        PurchaseLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 1, DocReport);
                        DocMgt.SelectPurchHdrDocReport(DocReport, Rec, PurchaseLine, false);
                    end;
                }
                action(Action1101904033)
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PurchaseLine: Record "Purchase Line";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        PurchaseLine.Reset;
                        DocMgt.PrintCurrentDoc(Rec."Document Profile", 2, 1, DocReport);
                        DocMgt.SelectPurchHdrDocReport(DocReport, Rec, PurchaseLine, true);
                    end;
                }
            }
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
                        ItemIntegrationMgt: Codeunit "Item Mgt. EDMS";
                    begin
                        ItemIntegrationMgt.GetPriceForPurchDoc(Rec);
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
                        ItemIntegrationMgt: Codeunit "Item Mgt. EDMS";
                    begin
                        // ItemIntegrationMgt.GetAvailabilityForItems(Rec);
                    end;
                }
                action(SubmitOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Submit Order';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ShowIntegrationActionSubmitItemPO;

                    trigger OnAction()
                    var
                        Item: Record Item;
                        ItemPurchDocIntegrationMgt: Codeunit "Item Purch. Doc. Mgt. EDMS";
                    begin
                        ItemPurchDocIntegrationMgt.SubmitPurchOrderYN(Rec);
                    end;
                }
            }

        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RecordId);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);
        StatusStyleTxt := Rec.GetStatusStyleText();
        SetDMSIntegrationActionsVisibility;   // EB.ASM EDMS.Integration
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        DocProfileMgt: Codeunit "Document Profile Mgt. EDMS";
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;

        if (not DocNoVisible) and (Rec."No." = '') then
            Rec.SetBuyFromVendorFromFilter;

        CalculateCurrentShippingAndPayToOption;
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
    var
        EnvironmentInfo: Codeunit "Environment Information";
    begin
        SetDocNoVisible;
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
        //EDMS >>
    end;



    var
        UserMgt: Codeunit "User Setup Management";
        FormatAddress: Codeunit "Format Address";

        IsSaaS: Boolean;
        DocumentIsPosted: Boolean;

        [InDataSet]
        StatusStyleTxt: Text;
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
        ShowIntegrationActionGetPrice: Boolean;
        ShowIntegrationActionGetAvailability: Boolean;
        ShowIntegrationActionSubmitItemPO: Boolean;
        [InDataSet]
        JobQueueVisible: Boolean;
        HasIncomingDocument: Boolean;
        VendorInvoiceNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ShouldSearchForVendByName: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        ShowWorkflowStatus: Boolean;
        DocNoVisible: Boolean;
        IsBuyFromCountyVisible: Boolean;
        IsPayToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        JobQueueVisible := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        SetExtDocNoMandatoryCondition;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        ShouldSearchForVendByName := Rec.ShouldSearchForVendorByName(Rec."Buy-from Vendor No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get();
        VendorInvoiceNoMandatory := PurchasesPayablesSetup."Ext. Doc. No. Mandatory"
    end;

    local procedure SetDMSIntegrationActionsVisibility()
    var
        DMSIntegrationMgt: Codeunit "Integration Management EDMS";
        ActionCode: array[10] of Code[20];
        ActionIsEnabled: array[10] of Boolean;
    begin
        if ActionCode[1] = '' then
            DMSIntegrationMgt.InitMethodAliasArrayBySource(ActionCode,
                                                         Database::"Purchase Header", Rec."document type"::Order.AsInteger(),
                                                         Page::"Purchase Order", 0);

        DMSIntegrationMgt.IsEnabledActionsByArr10(DMSIntegrationMgt.GetConnectorCodeByVendor(Rec."Buy-from Vendor No."),
                                                  ActionCode, ActionIsEnabled);
        ShowIntegrationActionGetPrice := ActionIsEnabled[1];
        ShowIntegrationActionGetAvailability := ActionIsEnabled[2];
        ShowIntegrationActionSubmitItemPO := ActionIsEnabled[3];
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Order, Rec."No.");
    end;

    local procedure ActivateFields()
    begin
        IsBuyFromCountyVisible := FormatAddress.UseCounty(Rec."Buy-from Country/Region Code");
        IsPayToCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;

    local procedure CalculateCurrentShippingAndPayToOption()
    begin
        case true of
            Rec."Sell-to Customer No." <> '':
                ShipToOptions := ShipToOptions::"Customer Address";
            Rec."Location Code" <> '':
                ShipToOptions := ShipToOptions::Location;
            else
                if Rec.ShipToAddressEqualsCompanyShipToAddress then
                    ShipToOptions := ShipToOptions::"Default (Company Address)"
                else
                    ShipToOptions := ShipToOptions::"Custom Address";
        end;

        case true of
            (Rec."Pay-to Vendor No." = Rec."Buy-from Vendor No.") and Rec.BuyFromAddressEqualsPayToAddress:
                PayToOptions := PayToOptions::"Default (Vendor)";
            (Rec."Pay-to Vendor No." = Rec."Buy-from Vendor No.") and (not Rec.BuyFromAddressEqualsPayToAddress):
                PayToOptions := PayToOptions::"Custom Address";
            Rec."Pay-to Vendor No." <> Rec."Buy-from Vendor No.":
                PayToOptions := PayToOptions::"Another Vendor";
        end;
    end;

}



