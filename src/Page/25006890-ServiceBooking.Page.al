Page 25006890 "Service Booking"
{
    Caption = 'Service Booking';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Print,Transfer';
    RefreshOnActivate = true;
    SourceTable = "Service Header EDMS";
    SourceTableView = where("Document Type" = filter(Booking));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(DealType; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoAddress; Rec."Sell-to Address")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(SelltoAddress2; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(SelltoPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(SelltoCity; Rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(SelltoContactNo; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                }
                field(SelltoContact; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                }
                field(MobilePhoneNo; Rec."Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(NoofArchivedVersions; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
                field(PlannedServiceDate; Rec."Planned Service Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // 23.04.2015 EDMS P21 >>
                        Rec.OnLookupVIN;
                        SelltoCustomerNoOnAfterValidat;
                        // 23.04.2015 EDMS P21 <<
                    end;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.OnLookupVehicleRegistrationNo;
                        SelltoCustomerNoOnAfterValidat;
                    end;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Editable = MakeModelEditable;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    Editable = MakeModelEditable;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun3Visible;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                }
                field(OrderTime; Rec."Order Time")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                }
                field(WorkStatusCode; Rec."Work Status Code")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(QuoteNo; Rec."Quote No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(TCardContainerEntryNo; Rec."TCard Container Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(BookingResourceNo; Rec."Booking Resource No.")
                {
                    ApplicationArea = Basic;
                }
            }
            part(ServiceLines; "Service Booking Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field(BilltoContactNo; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(BilltoName; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoAddress; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(BilltoAddress2; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(BilltoPostCode; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(BilltoCity; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoContact; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.validateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(PaymentDiscount; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerPriceGroup; Rec."Customer Price Group")
                {
                    ApplicationArea = Basic;
                }
                field(PricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(ForeignTrade)
            {
                Caption = 'Foreign Trade';
                Visible = false;
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter(rec."Currency Code", rec."Currency Factor", rec."Posting Date");
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                            rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }
                field(EU3PartyTrade; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionSpecification; Rec."Transaction Specification")
                {
                    ApplicationArea = Basic;
                }
                field(TransportMethod; Rec."Transport Method")
                {
                    ApplicationArea = Basic;
                }
                field(ExitPoint; Rec."Exit Point")
                {
                    ApplicationArea = Basic;
                }
                field("Area"; rec.Area)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("<Posting Date2>"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedStartingDate; Rec."Requested Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedStartingTime; Rec."Requested Starting Time")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedFinishingDate; Rec."Requested Finishing Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedFinishingTime; Rec."Requested Finishing Time")
                {
                    ApplicationArea = Basic;
                }
                field(ArrivalDate; Rec."Arrival Date")
                {
                    ApplicationArea = Basic;
                }
                field(ArrivalTime; Rec."Arrival Time")
                {
                    ApplicationArea = Basic;
                }
                field(FinishedQuantityHours; Rec."Finished Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(RemainingQuantityHours; Rec."Remaining Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(PlanningPolicy; Rec."Planning Policy")
                {
                    ApplicationArea = Basic;
                }
                field("<No. of Archived Versions2>"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                }
                field(InitiatorCode; Rec."Initiator Code")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleStatusCode; Rec."Vehicle Status Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleItemChargeNo; Rec."Vehicle Item Charge No.")
                {
                    ApplicationArea = Basic;
                }
                field(WarrantyClaimNo; Rec."Warranty Claim No.")
                {
                    ApplicationArea = Basic;
                }
                field(Resources; Resources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        rec.RelatedResourcesList(Resources);
                        Resources := rec.GetResourceTextFieldValue;
                    end;

                    trigger OnValidate()
                    begin
                        rec.SetResourceTextFieldValue(Resources);
                        Resources := rec.GetResourceTextFieldValue;
                    end;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Editable = MakeModelEditable;
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                Visible = false;
                field(Control228; Rec."Prepayment %")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        Prepayment37OnAfterValidate;
                    end;
                }
                field(CompressPrepayment; Rec."Compress Prepayment")
                {
                    ApplicationArea = Basic;
                }
                field(PrepmtPaymentTermsCode; Rec."Prepmt. Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field(PrepaymentDueDate; Rec."Prepayment Due Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(PrepmtPaymentDiscount; Rec."Prepmt. Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(PrepmtPmtDiscountDate; Rec."Prepmt. Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';
                Visible = false;
                field(ScheduleStartDate; DateTimeMgt.Datetime2Date(rec."Schedule Start Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Start Date';
                    Editable = false;
                }
                field(ScheduleStartTime; DateTimeMgt.Datetime2Time(rec."Schedule Start Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Start Time';
                    Editable = false;
                }
                field(ScheduleEndDate; DateTimeMgt.Datetime2Date(rec."Schedule End Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule End Date';
                    Editable = false;
                }
                field(ScheduleEndTime; DateTimeMgt.Datetime2Time(rec."Schedule End Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule End Time';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Order")
            {
                Caption = 'O&rder';
                action("<Action61>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        //CalcInvDiscForHeader;
                        Commit;
                        Page.RunModal(Page::"Service Order Statistics EDMS", Rec);
                    end;
                }
                action("<Action62>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = field("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action1101904005>")
                {
                    ApplicationArea = Basic;
                    Caption = 'V&ehicle Card';
                    Image = EditLines;
                    RunObject = Page "Vehicle List";
                    RunPageLink = "Serial No." = field("Vehicle Serial No.");
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const("Service Order"),
                                  "No." = field("No.");
                }
                action(VehicleComment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const(Vehicle),
                                  "No." = field("Vehicle Serial No.");
                }
                action(BillToCustomerComment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bill-To Customer Comments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Customer),
                                  "No." = field("Bill-to Customer No.");
                }
                action(SelllToCustomerComment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sell-To Customer Comments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Customer),
                                  "No." = field("Sell-to Customer No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action(VehicleQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Quotes';
                    Image = Quote;
                    RunObject = Page "Service Quotes EDMS";
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No.");
                }
            }
            group(Schedule)
            {
                Caption = 'Schedule';
                action("<Action1101904014>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Allocation Entries';
                    Image = EntriesList;

                    trigger OnAction()
                    var
                        ServLaborAllocation: Record "Serv. Labor Allocation Entry";
                        ScheduleMgt: Codeunit "Service Schedule Mgt.";
                    begin
                        ServLaborAllocation.Reset;
                        ScheduleMgt.FindServAllocationEntries(ServLaborAllocation, rec."Document Type", rec."No.");
                        Page.RunModal(Page::"Serv. Labor Allocation Entries", ServLaborAllocation);
                    end;
                }
                action("<Action1101904015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Application Entries';
                    Image = EntriesList;

                    trigger OnAction()
                    var
                        ServLaborAllocAplication: Record "Serv. Labor Alloc. Application";
                        ScheduleMgt: Codeunit "Service Schedule Mgt.";
                    begin
                        ServLaborAllocAplication.Reset;
                        ScheduleMgt.FindServAllocAplicationEntries(ServLaborAllocAplication, rec."Document Type", rec."No.");
                        Page.RunModal(Page::"Serv. Labor Alloc. Application", ServLaborAllocAplication);
                    end;
                }
            }
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
                action(Pictures)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pictures';
                    Image = Picture;
                    RunObject = Page Pictures;
                    RunPageLink = "Source Type" = const(Database::Vehicle),
                                  "Source Subtype" = const("0"),
                                  "Source ID" = field("Vehicle Serial No."),
                                  "Source Ref. No." = const(0);
                    RunPageMode = View;
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                action(CopyDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;

                    trigger OnAction()
                    begin
                        CopyServDoc.SetServOrdHeader(Rec);
                        CopyServDoc.RunModal;
                        Clear(CopyServDoc);
                    end;
                }
                action(ArchiveDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archi&ve Document';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        // ArchiveManagement.ArchiveServiceDocument(Rec);
                        EDMSMGT.ArchiveServiceDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(CreateQuote)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Quote';
                    Image = Quote;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SericeLinesCheck: Record "Service Line EDMS";
                    begin
                        //Check if has lines
                        SericeLinesCheck.SetRange("Document Type", Rec."Document Type");
                        SericeLinesCheck.SetRange("Document No.", Rec."No.");
                        if not SericeLinesCheck.FindSet() then
                            Error(NoLinesErr);

                        ServiceSplittingLine.LockTable;
                        ServiceSplittingLine.Reset;
                        ServiceSplittingLine.DeleteDocQuote(Rec."Document Type", Rec."No.");
                        ServiceSplittingLine.CreateLinesForQuote(Rec);

                        ServiceSplittingLine.Reset;
                        ServiceSplittingLine.SetRange(Line, true);
                        ServiceSplittingLine.SetRange("Document Type", Rec."Document Type");
                        ServiceSplittingLine.SetRange("Document No.", Rec."No.");
                        ServiceSplittingLine.SetRange("Temp. Document No.", 0);
                        Page.Run(Page::"Create Service Quote", ServiceSplittingLine);
                    end;
                }
                action(SendSMS)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send SMS';
                    Image = SendTo;

                    trigger OnAction()
                    var
                        SendSMS: Page "Send SMS Message";
                        UserSetup: Record "User Setup";
                        SalespersonCode: Code[10];
                    begin
                        if UserSetup.Get(UserId) then;
                        if UserSetup."Salespers./Purch. Code" <> '' then
                            SalespersonCode := UserSetup."Salespers./Purch. Code"
                        else
                            SalespersonCode := Rec."Service Advisor";

                        SendSMS.SetDocumentNo(Rec."No.");
                        SendSMS.SetDocumentType(2);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.Run;
                    end;
                }
            }
            group(Plan)
            {
                Caption = 'Plan';
                action("<Action1101904031>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Service Schedule";
                    RunPageLink = "Document Type" = field("Document Type"),
                                  "No." = field("No.");
                    RunPageOnRec = true;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "Service Schedule";
                    begin
                        //ServiceSchedule.SetServiceHeader(Rec);
                        //ServiceSchedule.RUN;
                    end;
                }
            }
            group(ServicePackages)
            {
                Caption = 'Service Packages';
                action(InsertServicePackage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert Service Package';
                    Image = CopyFromTask;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.InsertServPackage
                    end;
                }
                action(InsertPackRecall)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert Recall Compaign Package';
                    Image = CopyFromTask;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.InsertServPackageRecall;
                    end;
                }
                action(InsertServicePlanPackage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert Service Plan Package';
                    Image = CopyFromTask;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.InsertServPackagePlaned;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        MakeModelEditable := Rec."Vehicle Serial No." = '';        // 20.02.2015 EDMS P21
    end;

    trigger OnAfterGetRecord()
    begin
        Resources := rec.GetResourceTextFieldValue;
        Rec.CalcFields("Schedule Start Date Time", "Schedule End Date Time");
        //EVALUATE("Order Time", COPYSTR(FORMAT("Order Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'), 1, 8));  //12.08.2013 EDMS P8
        //MESSAGE('IsVFRun1Visible='+FORMAT(IsVFRun1Visible));

        Rec.ShowShortcutDimCode(ShortcutDimCode); // 31.03.2014 Elva Baltic P18 MMG7.00
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        LostSaleMgt.OnServHeaderDelete(Rec);

        // 28.03.2014 Elva Baltic P21 >>
        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", Rec."Document Type");
        ServiceLine.SetRange("Document No.", Rec."No.");
        if ServiceLine.FindFirst then
            repeat
                ServiceLine.DeleteAssignedTransfLine;
            until ServiceLine.Next = 0;
        // 28.03.2014 Elva Baltic P21 <<

        CurrPage.SaveRecord;
        exit(Rec.ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec.CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetSalesFilter;
        Clear(Resources);
        Rec.SetResourceTextFieldValue(Resources);
    end;

    trigger OnOpenPage()
    begin
        if UserMgtEDMS.GetServiceFilterEDMS <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgtEDMS.GetServiceFilterEDMS);
            Rec.FilterGroup(0);
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate - 1);

        SetDocNoVisible;
    end;

    var
        Text000: label 'Unable to execute this function while in view only mode.';
        ServPostYNPrepmt: Codeunit "Serv.-Post Prepayment Yes/No";
        CopyServDoc: Report "Copy Service Document EDMS";
        ReportPrint: Codeunit "Test Report-Print";
        ArchiveManagement: Codeunit ArchiveManagement;
        EDMSMGT: codeunit "Vehicle Proposal Mgt. EDMS";
        UserMgt: Codeunit "User Setup Management";
        UserMgtEDMS: Codeunit "UserProfileManagement";
        ApprovalEntries: Page "Approval Entries";
        ChangeExchangeRate: Page "Change Exchange Rate";
        Text001: label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: label 'There are unpaid Prepayment Invoices related to %1 %2.';
        Text101: label 'Transfer Order is successfully created.';
        Text102: label 'System changed values in Service Line field Planned Service Date.';
        ServInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        LostSaleMgt: Codeunit "Lost Sales Management";
        ServiceSplittingLine: Record "Service Splitting Line";
        [InDataSet]
        Resources: Text[250];
        ServiceLine: Record "Service Line EDMS";
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        Err001: label 'Order already has the invoice.';
        Text103: label 'Item Unit Price is successfully updated!';
        Text104: label 'Please update Item Unit Price!';
        ShortcutDimCode: array[8] of Code[20];
        Text105: label 'Posting Date is not Today! Do you want to continue?';
        DocNoVisible: Boolean;
        [InDataSet]
        MakeModelEditable: Boolean;
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        NoLinesErr: label 'There should be document lines to create Quote document.';


    procedure UpdateAllowed(): Boolean
    begin
        if CurrPage.Editable = false then
            Error(Text000);
        exit(true);
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.ServiceLines.Page.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
        //CurrPage."Service Document FactBox EDMS".PAGE.UpdateForm(TRUE);
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.ServiceLines.Page.UpdateForm(true);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.ServiceLines.Page.UpdateForm(true);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.ServiceLines.Page.UpdateForm(true);
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.Update;
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        CurrPage.ServiceLines.Page.UpdateForm(true);
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.Update;
    end;


    procedure UpdateItemUnitPrice()
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        ServiceLineEDMS.Reset;
        ServiceLineEDMS.SetRange("Document Type", Rec."Document Type");
        ServiceLineEDMS.SetRange("Document No.", Rec."No.");
        ServiceLineEDMS.SetRange(Type, ServiceLineEDMS.Type::Item);
        if ServiceLineEDMS.Find('-') then
            repeat
                ServiceLineEDMS.Validate(Quantity);
                ServiceLineEDMS.Modify;
            until ServiceLineEDMS.Next = 0;
        Rec.Modify;
        Message(Text103);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order","Return Order",Booking;
        EDMSMGT: Codeunit "Vehicle Proposal Mgt. EDMS";
    begin
        DocNoVisible := EDMSMGT.ServiceDocumentNoIsVisible(Doctype::Booking, rec."No.");
    end;


}

