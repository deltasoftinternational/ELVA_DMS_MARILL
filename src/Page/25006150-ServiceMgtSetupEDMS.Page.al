Page 25006150 "Service Mgt. Setup EDMS"
{
    // 10.10.2016 EB.P7 #WSH16
    //   Removed field"On Task Start" (moved to resource)
    // 
    // 04.04.2014 Elva Baltic P15 # MMG7.00
    //   * added field - "Def. Translation Language Code"
    // 
    // 22.01.2014 MMG7.1.00 P8 F029
    //   * Added fields: "Adv. Prepayment Account"
    // 
    // 28.01.2010 EDMS P2
    //   * Opened fields "Create To-do After Posting"
    //                  "To-do Date Formula"
    //                  "Serv. Plan Notify Date Formula"
    //                  "Serv. Plan Notify Kilometrage"
    //                  "Offer Link Vehicle and Contact"
    //                  "Link Relationship Code"
    // 
    // 19.01.2009. EDMS P2
    //   * Opened field "Check Vehicle Sales Date"

    ApplicationArea = Basic;
    Caption = 'Service Setup';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Service Mgt. Setup EDMS";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CheckVFRun1onRelease; Rec."Check VF Run 1 on Release")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                    ToolTip = 'Specifies if first vehicle counter field is mandatory in service orders.';
                }
                field(CheckVFRun2onRelease; Rec."Check VF Run 2 on Release")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun2Visible;
                    ToolTip = 'Specifies if second vehicle counter field is mandatory in service orders.';
                }
                field(CheckVFRun3onRelease; Rec."Check VF Run 3 on Release")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun3Visible;
                    ToolTip = 'Specifies if third vehicle counter field is mandatory in service orders.';
                }
                field(CheckPrepmtwhenPosting; Rec."Check Prepmt. when Posting")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you cannot post an order that has an unpaid prepayment amount.';
                }
                field(QuantityEqualsStandardTime; Rec."Quantity Equals Standard Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should copy standard hours value automatically to quantity field in service lines.';
                }
                field(ControlPackageConsistency; Rec."Control Package Consistency")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should control service package consistency once they are entered in service documents. If this control is enabled, then special package price and reference to service package is removed once any line added from this package is deleted.';
                }
                field(DefOrderingPriceTypeCode; Rec."Def. Ordering Price Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code of ordering price type to use as default value in every service line.';
                }
                //field(AutoApplyCreditMemo; "AutoApply Credit Memo")
                //{
                //    ApplicationArea = Basic;
                //}
                //field(PricesIncludingVATInInv; "Prices Including VAT In Inv.")
                //{
                //    ApplicationArea = Basic;
                //}
                field(ArchiveQuotesandOrders; Rec."Archive Quotes and Orders")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if quotes should be automatically archived once orders made and if orders hould be archived before posting';
                }
                field(ExtDocNoMandatory; Rec."Ext. Doc. No. Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if it is mandatory to fill External Document No. field in service documents before posting.';
                }
                field(CustPriceGroupMandatory; Rec."Cust. Price Group Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if it is mandaory to customer price group in service douments.';
                }
                field(DealTypeMandatory; Rec."Deal Type Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if it is mandaory to fill Deal Type field in service documents before posting.';
                }
                field(PaymentMethodMandatory; Rec."Payment Method Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if it is mandaory to fill Payment Method field in service documents before posting.';
                }
                field(MakeandModelMandatory; Rec."Make and Model Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if it is mandaory to make and model specified in service document.';
                }
                field(ItemNoReplacementWarnings; Rec."Item No. Replacement Warnings")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if it is mandaory to fill Deal Type field in service documents before posting.';
                }
                field(AutoApplyReplacements; Rec."Auto Apply Replacements")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specify if replacements should be automatically applied in service lines. Note: automatically can be applied only replacement if an old item is inserted and there is no stock left for it.';
                }
                field(RecallCampaignWarnings; Rec."Recall Campaign Warnings")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should show message on pending recalls on the vehicle once it is inserted in service document.';
                }
                field(CheckVehicleSalesDate; Rec."Check Vehicle Sales Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if it is mandaory to have vehicle sales date in service documents.';
                }
                field(OfferLinkVehicleandContact; Rec."Offer Link Vehicle and Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should offer to link vehicle with customer added in service documents.';
                }
                field(LinkRelationshipCode; Rec."Link Relationship Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what relationship code to use when linking contact to vehicle.';
                }
                field("Prev Owner Relationship Code"; Rec."Prev Owner Relationship Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what relationship code to use for old owners when linking contact to vehicle.';
                }
                //field(CopyCommentsServPlan; "Copy Comments Serv. Plan")
                //{
                //    ApplicationArea = Basic;
                //}
                field(ServiceScheduleActive; Rec."Service Schedule Active")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if service schedule is enabled.';
                }
                field(ServPlanContRelationship; Rec."Serv. Plan Cont. Relationship")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which contact relationship codu to use to check related customer when service orders are created from service plans.';
                }
                //field(PDIContRelationship; "PDI Cont. Relationship")
                //{
                //    ApplicationArea = Basic;
                //}
                field(DefTranslationLanguageCode; Rec."Def. Translation Language Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies for labors if to use translation from specific language instead of standard labor card description in service lines.';
                }
                field(ControlVehRegNoDubl; Rec."Control Veh. Reg. No. Dubl.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should check for duplicates in vehicles based on registration number.';
                }
                field(DefaultIdleEvent; Rec."Default Idle Event")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an idle event if system should fill all idle mechanic time with standard event allocations.';
                }
                field(ResourceNoMandatory; Rec."Resource No. Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if mechanic time registration is mandatore to post service orders.';
                }
                field(MapWebsourceCode; Rec."Map Websource Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which web source code to use for map visualization.';
                }
                field(MapZoomLevel; Rec."Map Zoom Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what should be default zoom level to use for maps in service.';
                }
                field(EnableStockAvailSelection; Rec."Enable Stock Avail. Selection")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specify if system should show Stock Availability Selection screen. It is displayed only if there is insufficient stock in current Location and there is available stock in other Location marked to be used as Parts Location.';
                }
                field(ServiceCostHandling; Rec."Service Cost Handling")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies source for cost of labor works in service and if it should be only calculated or also posted to G/L.';
                }
                field(ControlMechanicTimeEntry; Rec."Control Mechanic Time Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should control correctness of mechanic time registration.';
                }
                field("Posting Date Warnings"; Rec."Posting Date Warnings")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Enable warnings if posting date is not today.';
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                field(InboundTransferLineFilling; Rec."Inbound Transfer Line Filling")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how system should fill lines in transfer orders when items are transfered to service.';
                }
                field(OutboundTransferLineFilling; Rec."Outbound Transfer Line Filling")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how system should fill lines in transfer orders when items are transfered back from service to warehouse.';
                }
                field(DefServiceLocationCode; Rec."Def. Service Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies default service location code. It is used if there is no default value based on user branch profile setup.';
                }
                field(DefSparePartLocationCode; Rec."Def. Spare Part Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies default spare parts location code. It is used if there is no default value based on user branch profile setup.';
                }
                field("Def. Transit Location Code"; Rec."Def. In-Transit Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies default transit location code. It is used if there is no transfer routes defined between service and parts locations when transfer is created from service.';
                }
                field(TransferOnReturn; Rec."Transfer On Return")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should create transfer order once service return order is posted. Items in service location have positive balance after service return order is posted. If create transfer order option is selected then after posting system will create transfer order with all items in service return. If option to post is selected, then it will post that trasfer as well. Note: post option will not work properly if there is warehouse handling required in any of locations in the transfer.';
                }
                field(FullyTransferedMandatory; Rec."Fully Transfered Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system will verify that all items are available and reserved to specific service order before posting.';
                }
                field(CheckTransferedQtyOnDelete; Rec."Check Transfered Qty.On Delete")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies restrictions required on deleting an item line in service if it has reserved quantities.';
                }
                field(InboundTransfAutoReserve; Rec."Inbound Transf. Auto-Reserve")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should automatically reserve all items in warehouse once transfer order to service is created.';
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field(LaborNos; Rec."Labor Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to service labors.';
                }
                field(ServicePackageNos; Rec."Service Package Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to service packages.';
                }
                field(ExternalServiceNos; Rec."External Service Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to external services.';
                }
                field(WarrantyNos; Rec."Warranty Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to vehicle warranties.';
                }
                field(ServicePlanNos; Rec."Service Plan Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to vehicle service plans.';
                }
                field(QuoteNos; Rec."Quote Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to service quotes.';
                }
                field(OrderNos; Rec."Order Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to service orders.';
                }
                field(PostedOrderNos; Rec."Posted Order Nos.")
                {
                    ApplicationArea = Basic;
                    Enabled = PostedOrderNosEnable;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted service orders.';
                }
                field(ReturnOrderNos; Rec."Return Order Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to service return orders.';
                }
                field(PostedReturnOrderNos; Rec."Posted Return Order Nos.")
                {
                    ApplicationArea = Basic;
                    Enabled = PostedReturnOrderNosEnable;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted service return orders.';
                }
                field(RecallCampaignNos; Rec."Recall Campaign Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to vehicle recall campaigns.';
                }
                field(InvoiceNos; Rec."Invoice Nos.")
                {
                    ApplicationArea = Basic;
                    //Enabled = InvoiceNosEnable; test
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to sales invoices created with service profile.';
                }
                field(PostedInvoiceNos; Rec."Posted Invoice Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted sales invoices with service profile.';
                }
                field(CreditMemoNos; Rec."Credit Memo Nos.")
                {
                    ApplicationArea = Basic;
                    //Enabled = CreditMemoNosEnable;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to sales credit memos created with service profile.';
                }
                field(PostedCreditMemoNos; Rec."Posted Credit Memo Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted sales credit memos with service profile.';
                }
                field(OrderNosfromQuote; Rec."Order Nos. from Quote")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to service orders that where created from quotes.';
                }
                field(PostedPrepmtInvNos; Rec."Posted Prepmt. Inv. Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted prepayment invoices created from service orders.';
                }
                field(PostedPrepmtCrMemoNos; Rec."Posted Prepmt. Cr. Memo Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted prepayment credit memos created from service orders.';
                }
                field(UseOrderNoasPostingNo; Rec."Use Order No. as Posting No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if same document number assigned for service order should be used also for posted service order.';

                    trigger OnValidate()
                    begin
                        PostedOrderNosEnable := not Rec."Use Order No. as Posting No.";
                        PostedReturnOrderNosEnable := not Rec."Use Order No. as Posting No.";
                    end;
                }
                field(UseOrderNoforInvCrMemo; Rec."Use Order No. for Inv.&Cr.Memo")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if same document number assigned for service order should be used also for sales invoices or credit memos.';

                    trigger OnValidate()
                    begin
                        InvoiceNosEnable := not Rec."Use Order No. for Inv.&Cr.Memo";
                        CreditMemoNosEnable := not Rec."Use Order No. for Inv.&Cr.Memo";
                    end;
                }
                field(ServiceBookingNos; Rec."Service Booking Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to service bookings.';
                }
            }
            group(ServicePlan)
            {
                Caption = 'Service Plan';
                field(ServicePlanNotification; Rec."Service Plan Notification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if there should be notifications on pending service plans in service orders.';
                }
                field(NotifyBeforeDateFormula; Rec."Notify Before (Date Formula)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many days in advance there should be service plan notifications.';
                }
                field(NotifyBeforeVFRun1; Rec."Notify Before (VF Run 1)")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                    ToolTip = 'Specifies how far in advance there should be service plan notifications based on vehicle counters.';
                }
                field(NotifyBeforeVFRun2; Rec."Notify Before (VF Run 2)")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun2Visible;
                    ToolTip = 'Specifies how far in advance there should be service plan notifications based on vehicle counters.';
                }
                field(NotifyBeforeVFRun3; Rec."Notify Before (VF Run 3)")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun3Visible;
                    ToolTip = 'Specifies how far in advance there should be service plan notifications based on vehicle counters.';
                }
                field(NotifyAboutComponents; Rec."Notify About Components")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if there should be notifications on pending service plans on components when main unit is in service order.';
                }
                field(LogServicePlanMgtProcess; Rec."Log Service Plan Mgt. Process")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should add in log how expected service dates are calculated in service plans.';
                }
            }
            group(Todo)
            {
                Caption = 'To-do';
                field(CreateTodoAfterPosting; Rec."Create To-do After Posting")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if system should automatically create a to-do when service order is posted.';
                }
                field(TodoDateFormula; Rec."To-do Date Formula")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies after how many days from posting date there should be a to-do after service order is posted.';
                }
                field(TodoInteractionTemplate; Rec."To-do Interaction Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what interaction template system should use when creating to-dos.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CreditMemoNosEnable := true;
        InvoiceNosEnable := true;
        PostedReturnOrderNosEnable := true;
        PostedOrderNosEnable := true;

        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Notify Before (VF Run 1)"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Notify Before (VF Run 2)"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Notify Before (VF Run 3)"));
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
        OnActivateForm;

        SetVariableFields;
    end;

    var
        [InDataSet]
        PostedOrderNosEnable: Boolean;
        [InDataSet]
        PostedReturnOrderNosEnable: Boolean;
        [InDataSet]
        InvoiceNosEnable: Boolean;
        [InDataSet]
        CreditMemoNosEnable: Boolean;
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;

    local procedure OnActivateForm()
    begin
        PostedOrderNosEnable := not Rec."Use Order No. as Posting No.";
        PostedReturnOrderNosEnable := not Rec."Use Order No. as Posting No.";
        InvoiceNosEnable := not Rec."Use Order No. for Inv.&Cr.Memo";
        CreditMemoNosEnable := not Rec."Use Order No. for Inv.&Cr.Memo";
    end;


    procedure SetVariableFields()
    begin
        //Variable Fields
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Notify Before (VF Run 1)"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Notify Before (VF Run 2)"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Notify Before (VF Run 3)"));
    end;
}

