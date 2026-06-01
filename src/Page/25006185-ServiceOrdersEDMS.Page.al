Page 25006185 "Service Orders EDMS"
{
    // 07.04.2022 EDMS EB.KN
    //   Added Field:
    //      Customer Vehicle ID
    //
    // 14.03.2019 EDMS.KN
    //   * Added fields
    //     Initial Service Order No.
    //     Document Status
    //     Order Date
    //     Service Advisor
    //     Payment Mothod Code
    // 
    // 22.10.2015 NAV2016 Merge
    //   Approvals removed
    // 
    // 2014.09.15 EDMS P7
    //   * tcp error fix. Schedule page run moved from code to properties
    // 
    // 2012.05.08 EDMS P8
    //   * Added column Resources

    ApplicationArea = Basic;
    Caption = 'Service Orders';
    CardPageID = "Service Order EDMS";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Print';
    SourceTable = "Service Header EDMS";
    SourceTableView = where("Document Type" = const(Order));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(InitialServiceOrderNo; Rec."Initial Service Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
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
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(DealType; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentStatus; Rec."Document Status")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SelltoCountryRegionCode; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SelltoContact; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BilltoName; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BilltoPostCode; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BilltoCountryRegionCode; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BilltoContact; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RequestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CampaignNo; Rec."Campaign No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentDiscount; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Resources; Resources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';
                    Editable = false;
                }
                field(ScheduleStartDate; DateTimeMgt.Datetime2Date(Rec."Schedule Start Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Start Date';
                    Editable = false;
                    Visible = false;
                }
                field(ScheduleStartTime; DateTimeMgt.Datetime2Time(Rec."Schedule Start Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Start Time';
                    Editable = false;
                    Visible = false;
                }
                field(ScheduleEndDate; DateTimeMgt.Datetime2Date(Rec."Schedule End Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule End Date';
                    Editable = false;
                    Visible = false;
                }
                field(ScheduleEndTime; DateTimeMgt.Datetime2Time(Rec."Schedule End Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule End Time';
                    Editable = false;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the sum of amounts in the Line Amount field on the purchase order lines.';
                }
                field(AmountIncludingVAT; Rec."Amount Including VAT")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';
                }
                field("Customer Vehicle ID"; Rec."Customer Vehicle ID")
                {
                    ToolTip = 'Specifies the Customer Vehicle identification number.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(25006145),
                              "No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type");
            }
            part(Control25006000; "Vehicle MapView FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Vehicle Serial No.");
            }
            part(Control1101904004; "Service Document FactBox EDMS")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
                Visible = true;
            }
            part(Control1902018507; "Customer Serv. Statis. FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Bill-to Customer No.");
                Visible = true;
            }
            part("Vehicle Pictures"; "Object Picture FactBox")
            {
                ApplicationArea = All;
                Caption = 'Vehicle Pictures';
                SubPageLink = "Source Type" = const(Database::Vehicle),
                              //"Source Subtype" = const("0"),
                              "Vehicle Serial No." = field("Vehicle Serial No.");
                //"Source Ref. No." = const(0);
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Sell-to Customer No.");
                Visible = true;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
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
                action("<Action1102601006>")
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
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = field("Document Type"),
                                  "No." = field("No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'A&pprovals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        ApprovalEntries.SetRecordFilters(Database::"Service Header EDMS", Rec."Document Type", Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
            }
            group(Transfers)
            {
                Caption = 'Transfers';
                action("<Action1101904028>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Orders';
                    Image = Documents;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupOrdTransf(Rec)
                    end;
                }
                action("<Action1101904029>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Shipments';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupTransferShipment(Rec)
                    end;
                }
                action("<Action1101904030>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Receipts';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupTransferReceipt(Rec)
                    end;
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                action("<Action1102601011>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Prepayment Order No." = field("No.");
                    RunPageView = sorting("Prepayment Order No.");
                }
                action("<Action1102601012>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "Prepayment Order No." = field("No.");
                    RunPageView = sorting("Prepayment Order No.");
                }
            }
            group(Schedule)
            {
                Caption = 'Schedule';
                action(ScheduleAllocationEntries)
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
                        ScheduleMgt.FindServAllocationEntries(ServLaborAllocation, Rec."Document Type", Rec."No.");
                        Page.RunModal(Page::"Serv. Labor Allocation Entries", ServLaborAllocation);
                    end;
                }
                action(ScheduleApplicationEntries)
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
                        ScheduleMgt.FindServAllocAplicationEntries(ServLaborAllocAplication, Rec."Document Type", Rec."No.");
                        Page.RunModal(Page::"Serv. Labor Alloc. Application", ServLaborAllocAplication);
                    end;
                }
            }
            group(Vehicle)
            {
                Caption = 'Vehicle';
                action("<Page Object Picture>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Pictures';
                    Image = Picture;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page Pictures;
                    RunPageLink = "Source Type" = const(25006145),
                                  "Source Subtype" = field("Document Type"),
                                  "Source ID" = field("No.");
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        // 1st par 25006005 - Vehicle
                        //PictureMgt.ShowObjectPictures(25006005,0,"Serial No.",0)
                    end;
                }
                action("<Page Vehicle Picture>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Pictures';
                    Image = Picture;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page Pictures;
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No.");
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        // 1st par 25006005 - Vehicle
                        //PictureMgt.ShowObjectPictures(25006005,0,"Serial No.",0)
                    end;
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                action(Action21)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "Release Service Document EDMS";
                    begin
                        ReleaseServiceDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "Release Service Document EDMS";
                    begin
                        ReleaseServiceDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                action("<Action1101904007>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Order Overview';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    var
                        ItemOrderOverview: Page "Item Order Overview";
                    begin
                        ItemOrderOverview.SetSourceType2(2); //Service
                        ItemOrderOverview.SetDocumentFilter(Rec."No.");
                        ItemOrderOverview.SetFilters;
                        ItemOrderOverview.FindRec;
                        ItemOrderOverview.Run;
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
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Service Schedule";

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "Service Schedule";
                    begin
                        //ServiceSchedule.SetServiceHeader(Rec);
                        //ServiceSchedule.RUN;
                    end;
                }
                action(OrderPromising)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Promising';
                    Image = OrderPromising;

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "Order Promising Line" temporary;
                    begin
                        OrderPromisingLine.SetRange("Source Type", OrderPromisingLine."source type"::Job);
                        OrderPromisingLine.SetRange("Source ID", Rec."No.");
                        Page.RunModal(page::"Order Promising Lines EDMS", OrderPromisingLine);
                    end;
                }
            }
            group(Request)
            {
                Caption = 'Request';
                action("<Action1102601046>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN;
                    end;
                }
                action("<Action1102601047>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'P&osting';
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //  IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //    ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //  ELSE BEGIN
                        //    IF ApprovalMgt.TestServPayment(Rec) THEN
                        //      ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //    ELSE
                        Codeunit.Run(Codeunit::"Service-Post (Yes/No) EDMS", Rec);
                        //  END;
                        //END;
                    end;
                }
                action(PostandPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //  IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //    ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //  ELSE BEGIN
                        //    IF ApprovalMgt.TestServPayment(Rec) THEN
                        //      ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //    ELSE
                        Codeunit.Run(Codeunit::"Service-Post+Print EDMS", Rec);
                        //  END;
                        //END;
                    end;
                }
            }
            group(Print)
            {
                Caption = '&Print';
                action(Action23)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServLine: Record "Service Line EDMS";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        ServLine.Reset;
                        DocMgt.PrintCurrentDoc(3, 3, 1, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine, false);
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
                        ServLine: Record "Service Line EDMS";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        ServLine.Reset;
                        DocMgt.PrintCurrentDoc(3, 3, 1, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine, true);
                    end;
                }
            }
        }
        area(reporting)
        {
        }
    }

    trigger OnAfterGetRecord()
    begin
        Resources := ServiceScheduleMgt.GetRelatedResources(Rec."Document Type", Rec."No.", ServiceLine.Type::Labor, 0, 0);
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
        IsVisibleFactBox1 := ((not IsVFRun1Visible) and (not IsVFRun2Visible) and (not IsVFRun3Visible));
        IsVisibleFactBox2 := ((IsVFRun1Visible) and (not IsVFRun2Visible) and (not IsVFRun3Visible));
        Rec.CalcFields("Schedule Start Date Time", "Schedule End Date Time");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(Resources);
    end;

    trigger OnOpenPage()
    begin
        if UserMgtEDMS.GetServiceFilterEDMS <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgtEDMS.GetServiceFilterEDMS);
            Rec.FilterGroup(0);
        end;
    end;

    var
        Text001: label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: label 'There are unpaid Prepayment Invoices related to %1 %2.';
        ServInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        ServiceLine: Record "Service Line EDMS";
        ApprovalEntries: Page "Approval Entries";
        [InDataSet]
        Resources: Text[250];
        UserMgt: Codeunit "User Setup Management";
        UserMgtEDMS: Codeunit "UserProfileManagement";
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        [InDataSet]
        IsVisibleFactBox1: Boolean;
        [InDataSet]
        IsVisibleFactBox2: Boolean;
        DateTimeMgt: Codeunit "Datetime Mgt.";
}

