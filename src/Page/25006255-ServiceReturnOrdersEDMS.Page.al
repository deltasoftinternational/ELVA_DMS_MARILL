Page 25006255 "Service Return Orders EDMS"
{
    // 22.10.2015 NAV2016 Merge
    //   Approvals removed

    ApplicationArea = Basic;
    Caption = 'Service Return Orders';
    CardPageID = "Service Return Order EDMS";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Print';
    SourceTable = "Service Header EDMS";
    SourceTableView = where("Document Type" = const("Return Order"));
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
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
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
                field(PaymentDiscount; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
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
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                    Visible = false;
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

            part(Control1101904004; "Service Document FactBox EDMS")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
                Visible = true;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Bill-to Customer No.");
                Visible = true;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Sell-to Customer No.");
                Visible = true;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
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
                    RunPageLink = Type = const("Service Return Order"),
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
                        SendSMS.SetDocumentType(3);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.Run;
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
                        ServInfoPaneMgt.LookupRetOrdTransf(Rec)
                    end;
                }
                action("<Action1101904029>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Shipments';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupRetTransferShipment(Rec)
                    end;
                }
                action("<Action1101904030>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Receipts';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupRetTransferReceipt(Rec)
                    end;
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                action(Action8)
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

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "Service Schedule";
                    begin
                        ServiceSchedule.Run;
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
                        // IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //   IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //     ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //   ELSE BEGIN
                        //     IF ApprovalMgt.TestServPayment(Rec) THEN
                        //       ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //     ELSE
                        Codeunit.Run(Codeunit::"Service-Post (Yes/No) EDMS", Rec);
                        //   END;
                        // END;
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
                        // IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //   IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //     ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //   ELSE BEGIN
                        //     IF ApprovalMgt.TestServPayment(Rec) THEN
                        //       ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //     ELSE
                        Codeunit.Run(Codeunit::"Service-Post+Print EDMS", Rec);
                        //   END;
                        // END;
                    end;
                }
            }
            group(Print)
            {
                Caption = '&Print';
                Image = Print;
                action(Action25006004)
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
                        DocMgt.PrintCurrentDoc(3, 3, 0, DocReport);
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
                        DocMgt.PrintCurrentDoc(3, 3, 0, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine, true);
                    end;
                }
            }
        }
    }

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
        ApprovalEntries: Page "Approval Entries";
        UserMgt: Codeunit "User Setup Management";
        UserMgtEDMS: Codeunit "UserProfileManagement";
}

