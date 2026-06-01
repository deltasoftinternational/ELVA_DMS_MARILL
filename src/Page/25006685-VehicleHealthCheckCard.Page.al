Page 25006685 "Vehicle Health Check Card"
{
    // 14/08/2018 EB.P30 GH
    //   Modified functions:
    //     UpdateLine
    //     RequestCheckChange
    //     RequestRadioChange
    //     RequestTextChange
    //     RequestRefreshPage
    // 
    // 13/08/2018 EB.P30 GH
    //   Modified field:
    //     "Sell-to Customer Name"
    //      Removed code in trigger OnLookup
    // 
    // 09/08/2018 EB.P30 GH
    //   Added field:
    //     "No. of Archived Versions"
    //   Added action:
    //     ArchiveDocument
    // 
    // 27/03/2018 GP1 P30
    //   Added action:
    //     CopyAuthLinesToJobsheet
    // 
    // 02/01/2018 EB.P30 GP1
    //   Added field:
    //     "Vehicle Serial No."
    // 
    // 26/10/2017 GP1
    //   Added action:
    //     "Lookup Service Address"
    // 
    // 22.10.2015 NAV2016 Merge
    //   Approvals removed
    // 12.08.2015 EB.P30 P393.T0056 EAMS1.00
    //   Changed property 'Editable' to FALSE for field "Quote No."
    // 
    // 23.04.2015 EDMS P21
    //   Modified triggers:
    //     VIN - OnLookup
    // 
    // 26.02.2015 EDMS P21
    //   Modified trigger:
    //     <Action25> - OnAction
    //   Added field:
    //     "Quote No."
    // 
    // 20.02.2015 EDMS P21
    //   Added field:
    //     "Model Version No."
    //   Modified trigger:
    //     OnAfterGetCurrRecord
    //   Modified Editable property for fields:
    //     "Make Code"
    //     "Model Code"
    // 
    // 10.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Set Visible TRUE for page action:
    //     Create Quote
    //   Added page action:
    //     Vehicle Quotes
    // 
    // 06.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added page action:
    //     Create Quote
    //   Added code to trigger:
    //     <Action1101904040> - OnAction()     (Split Document)
    // 
    // 16.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     "Contract No."
    // 
    // 16.04.2014 Elva Baltic P7 # MMG7.00
    //   * Field "Shipping Agent Code" added
    // 
    // 08.04.2014 Elva Baltic P7 #RX MMG7.00
    //   * Field "Bill-to Bank Acc. No." added
    // 
    // 04.04.2014 Elva Baltic P15 # MMG7.00
    //   * Added check for the current Posting Date before Invoice Printing Out
    // 
    // 04.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Importance=Promoted set for "Location Code" field
    // 
    // 03.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Importance=Standard set for field "Posting Date"
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added fields
    //     ShortcutDimCode[3]..[8]
    //     "Invoice No."
    //   Added Code to
    //     OnAfterGetRecord()
    // 
    // 30.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Importance set to Promoted for field "Vehicle Registration No."
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     OnDeleteRecord
    // 
    // 26.03.2014 Elva Baltic P18 #RX026 MMG7.00
    //   Added Fields To Details group
    //     "First Allocation Date"
    //     "First Allocation Time"
    // 
    // 25.03.2014 Elva Baltic P18 #RX025 MMG7.00
    //   Added New Page Actions
    //     Vehicle Comments
    //     Bill-To Customer Comments
    //     Sell-To Customer Comments
    // 
    // 24.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Internal
    //   Added Page Action:
    //     UpdateItemUnitPrice
    //   Added functions:
    //     UpdateItemUnitPrice()
    //     CheckItemPriceLastUpdateTime()
    //   Added Code to:
    //     <Action75> - OnAction()    (Post)
    //     <Action76> - OnAction()    (Post and Print)
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Fixed "Document Info" FactBox link
    // 
    // 22.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   *"Deal Type" field moved to the general tab
    //   *Visible=Fasles set to Prepayment and Foreign Trade tabs
    //   *Changed FactBox order
    //   *The following fields set Visible=FALSE:
    //    - Description
    //    - "Responsibility Center"
    //    - "No. of Archived Versions"
    //    - "Planned Service Date"
    //   *Importance property set to Standard for fields:
    //    - Order Date
    //    - Order Time
    //    - Phone No.
    //    - "Sell-to Contact No."
    //    - "Sell-to Contact"
    //   *Importance property set to Additional for fields:
    //    - Posting Date
    //   *Added print actions: Service Order, Invoice, Item Order
    // 
    // 20.03.2014 Elva Baltic P7 #R165 MMG7.00
    //   * Fields Added:
    //     -Bank No.
    //     -Bank Name
    //     -Bank Account No.
    //     -IBAN
    //     -Bank Branch No.
    //     -SWIFT Code
    // 
    // 18.03.2014 Elva Baltic P18 #RX003 MMG7.00
    //   Added group "LV Invoice"
    // 
    // 13.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Field "Payment Method" moved to General Tab
    // 
    // 11.03.2014 Elva Baltic P7 #F107 MMG7.00
    //   * New function added - generate Prepayment
    //   * New field added generated invoice count
    // 
    // 07.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified trigger:
    //     <Action1101904013> - OnAction() (Create Transfer Order)
    //     Message was added to function ServTransfMgt.CreateTransferOrder
    // 
    // 03.03.2014 MMG7.1.00 P7 #R114
    //   * New function use FakePrepayment.
    // 
    // 22.01.2014 MMG7.1.00 P8 F029
    //   * New function use FakePrepayment.
    // 
    // 12.08.2013 EDMS P8
    //   * REMOVED MILLISECONDS
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3
    // 
    // 23.12.2011 EDMS P8
    //   * Add function: split document

    Caption = 'Vehicle Health Check Card';
    LinksAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Print';
    RefreshOnActivate = true;
    SourceTable = "Service Header EDMS";
    SourceTableView = where("Document Type" = filter(VHC));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;

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
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Serial No.';
                    Visible = VehicleSerialNoVisible;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(VehicleDescriptionCtrl; VehicleDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Description';
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                }
                field(Customer; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer';
                    Importance = Promoted;
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        MiniCustomerMgt: Codeunit "Customer Mgt.";
                        CustNo: Code[20];
                    begin
                    end;
                }
                field(Address; Rec."Sell-to Address")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address';
                    Importance = Additional;
                }
                field(Address2; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address 2';
                    Importance = Additional;
                }
                field(PostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code';
                    Importance = Additional;
                }
                field(City; Rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                    Caption = 'City';
                    Importance = Additional;
                }
                field(Contact; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contact';
                    Importance = Standard;
                }
                field(MobilePhoneNo; Rec."Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = PhoneNo;
                    ShowMandatory = true;
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(OrderTime; Rec."Order Time")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(VHCStatus; Rec."VHC Status")
                {
                    ApplicationArea = Basic;
                }
                field(NoofArchivedVersions; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
            }
            part(Comments; "Service Comment List EDMS")
            {
                ApplicationArea = All;
                SubPageLink = Type = const("Warranty Doc"),
                              "No." = field("No.");
            }
            group(CheckListLines)
            {
                Caption = 'Check List Lines';
                usercontrol(CheckList; CheckListAddIn)
                {
                    ApplicationArea = Basic;

                    trigger ControlAddInReady()
                    begin
                        UpdateLines;
                    end;

                    trigger RequestRefreshPage(ActLineNo: Integer)
                    var
                        AddInData: Text;
                        Buffer: Record "Checklist Buffer" temporary;
                    begin
                        if ProcessChecklistHeader."VHC No." <> '' then begin
                            GHCheckListAddInManagement.FillCheckList(ProcessChecklistHeader, Buffer);
                            GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, ActLineNo);
                            CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                        end;
                    end;

                    trigger RequestTextChange(LineNo: Integer; CommentText: Text)
                    var
                        ChecklistLine: Record "Process Checklist Line";
                        Buffer: Record "Checklist Buffer" temporary;
                        AddInData: Text;
                    begin
                        /*
                        //MESSAGE('Line No.: '+FORMAT(LineNo)+' Text Value: '+CommentText);
                        ChecklistLine.GET("No.",LineNo);
                        ChecklistLine.VALIDATE("Value Description",COPYSTR(CommentText,1,MAXSTRLEN(ChecklistLine."Value Description")));
                        ChecklistLine.MODIFY(TRUE);
                        SetChecklistInProgress;
                        */
                        if ProcessChecklistHeader."VHC No." <> '' then begin
                            GHCheckListAddInManagement.FillCheckList(ProcessChecklistHeader, Buffer);
                            GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
                            CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                        end;

                    end;

                    trigger RequestRadioChange(LineNo: Integer; RadioValue: Text)
                    var
                        ChecklistLine: Record "Process Checklist Line";
                        Buffer: Record "Checklist Buffer" temporary;
                        AddInData: Text;
                    begin
                        /*
                        //MESSAGE('RequestRadioChange\Line No.: '+FORMAT(LineNo)+' Radio Value: '+FORMAT(RadioValue));
                        ChecklistLine.GET("No.",LineNo);
                        ChecklistLine.VALIDATE("Value Bool",TRUE);
                        ChecklistLine.MODIFY(TRUE);
                        //Unselect others
                        ChecklistLine.SETRANGE("Process Checklist No.","No.");
                        ChecklistLine.SETRANGE("Parent Line No.",ChecklistLine."Parent Line No.");
                        ChecklistLine.SETFILTER("Line No.",'<>%1',ChecklistLine."Line No.");
                        ChecklistLine.MODIFYALL("Value Bool",FALSE);
                        SetChecklistInProgress;
                        */
                        if ProcessChecklistHeader."VHC No." <> '' then begin
                            GHCheckListAddInManagement.FillCheckList(ProcessChecklistHeader, Buffer);
                            GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
                            CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                        end;

                    end;

                    trigger RequestCheckChange(LineNo: Integer; CheckValue: Text)
                    var
                        ChecklistLine: Record "Process Checklist Line";
                        Buffer: Record "Checklist Buffer" temporary;
                        AddInData: Text;
                    begin
                        /*
                        //MESSAGE('RequestCheckChange\Line No.: '+FORMAT(LineNo)+' Check Value: '+FORMAT(CheckValue));
                        ChecklistLine.GET("No.",LineNo);
                        ChecklistLine.VALIDATE("Value Bool",NOT ChecklistLine."Value Bool");
                        ChecklistLine.MODIFY(TRUE);
                        SetChecklistInProgress;
                        */
                        if ProcessChecklistHeader."VHC No." <> '' then begin              // 14/08/2018 EB.P30 GH
                            GHCheckListAddInManagement.FillCheckList(ProcessChecklistHeader, Buffer);
                            GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
                            CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                        end;

                    end;

                    trigger RequestAssistEditButton(LineNo: Integer)
                    begin
                        //MESSAGE('Line No.: '+FORMAT(LineNo));
                    end;

                    trigger RequestButton(LineNo: Integer)
                    begin
                        //MESSAGE('Line No.: '+FORMAT(LineNo));
                    end;


                }
            }
            part(ServiceLines; "Vehicle Health Check Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type");
            }
        }
        area(factboxes)
        {
            part("Vehicle Pictures"; "Object Picture FactBox")
            {
                ApplicationArea = All;
                Caption = 'Vehicle Pictures';
                SubPageLink = "Source Type" = const(Database::Vehicle),
                              "Source Subtype" = const("0"),
                              "Source ID" = field("Vehicle Serial No."),
                              "Source Ref. No." = const(0);
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
            }
            part(Control19; "Service Document FactBox EDMS")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
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
                action("<Action62>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action1101904005>")
                {
                    ApplicationArea = Basic;
                    Caption = 'V&ehicle Card';
                    Image = EditLines;
                }
                action(Action63)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const("Warranty Doc"),
                                  "No." = field("No.");
                    Visible = false;
                }
            }
        }
        area(processing)
        {
            group(Print)
            {
                Caption = 'Print';
                action("<Action169>")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ServLine: Record "Service Line EDMS";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        //DocPrint.PrintSalesHeader(Rec);
                        ServLine.Reset;
                        DocMgt.PrintCurrentDoc(3, 3, 15, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine, false);
                    end;
                }
                action(EmailAction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = SendEmailPDF;
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
                        DocMgt.PrintCurrentDoc(3, 3, 15, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine, true);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                action(CopyAuthLinesToJobsheet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Authorized Lines to Jobsheet';
                    Image = "Order";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        GHFeatureMgt: Codeunit "Checklist Features Mgt.";
                    begin
                        GHFeatureMgt.CopyVHCAuthorisedLinesToOrder(Rec);
                        CurrPage.Update;
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
            }
            group(Lookup)
            {
                Caption = 'Lookup';
                action(ShowVehicleInspection)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Vehicle Inspection';
                    Image = BulletList;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        GHFeatureMgt: Codeunit "Checklist Features Mgt.";
                    begin
                        GHFeatureMgt.ShowVehicleInspectionFromVHC(Rec);
                    end;
                }
                action(InsertServicePackage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Package';
                    Image = CopyFromTask;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        rec.InsertServPackage
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'P&osting';
            }
            group(ActionGroup223)
            {
                Caption = '&Print';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        MakeModelEditable := Rec."Vehicle Serial No." = '';        // 20.02.2015 EDMS P21
    end;

    trigger OnAfterGetRecord()
    begin
        Resources := Rec.GetResourceTextFieldValue;
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
        Rec.CheckCreditMaxBeforeInsert;
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
        ServiceMgtSetup.Get;
        IsVisibleServiceAddress := ServiceMgtSetup."Show Service Address";
        VehicleSerialNoVisible := ServiceMgtSetup."Vehicle No. Promoted";

        ProcessChecklistHeader.Reset;
        ProcessChecklistHeader.SetRange("VHC No.", Rec."No.");
        if ProcessChecklistHeader.FindFirst then;
    end;

    var
        Text000: label 'Unable to execute this function while in view only mode.';
        ServPostYNPrepmt: Codeunit "Rent-Post";
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
        Err002: label 'Please enter customer first';
        Text106: label 'No information available for this car';
        IsVisibleServiceAddress: Boolean;
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        VehicleSerialNoVisible: Boolean;
        GHCheckListAddInManagement: Codeunit "Checklist AddIn Management";
        ProcessChecklistHeader: Record "Process Checklist Header";


    procedure UpdateAllowed(): Boolean
    begin
        if CurrPage.Editable = false then
            Error(Text000);
        exit(true);
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure PricesIncludingVATOnAfterValid()
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
        rec.Modify;
        Message(Text103);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order","Return Order";
        EDMSMGT: Codeunit "Vehicle Proposal Mgt. EDMS";
    begin
        DocNoVisible := EDMSMGT.ServiceDocumentNoIsVisible(Doctype::Order, rec."No.");
    end;

    local procedure VehicleDescription(): Text
    begin
        Rec.CalcFields("Model Commercial Name");
        exit(Rec."Make Code" + ' ' + Rec."Model Code");
    end;

    local procedure OrderParts()
    var
        ServiceLine: Record "Service Line EDMS";
    begin
        /*
        ServiceLine.Reset;
        ServiceLine.FilterGroup(2);
        ServiceLine.SetRange("Document Type", "Document Type");
        ServiceLine.SetRange("Document No.", "No.");
        ServiceLine.SetRange(Type, ServiceLine.Type::Item);
        ServiceLine.SetFilter("No.", '<>%1', '');
        ServiceLine.SetFilter(Quantity, '>%1', 0);
        ServiceLine.FilterGroup(0);
        IF PAGE.RUNMODAL(PAGE::"Parts Order Confirmation", ServiceLine) = ACTION::Yes THEN
            Page.RunModal(Page::"Vehicle Health Check Lines", ServiceLine);
        */
    end;


    local procedure UpdateLines()
    var
        AddInData: Text;
        Buffer: Record "Checklist Buffer" temporary;
    begin
        if ProcessChecklistHeader."VHC No." <> '' then begin              // 14/08/2018 EB.P30 GH
            GHCheckListAddInManagement.FillCheckList(ProcessChecklistHeader, Buffer);
            GHCheckListAddInManagement.CheckListControlAddInReady(AddInData);
            CurrPage.CheckList.RecieveInitCheckListData(AddInData);
        end;
    end;

    local procedure CaptionText(): Text
    begin
        //EXIT(STRSUBSTNO('%1 %2 %3 %4',Type,"Template Code","Vehicle Registration No.",VehicleDescription));
    end;

    local procedure SetChecklistInProgress()
    begin
        if ProcessChecklistHeader."Process Status" <> ProcessChecklistHeader."process status"::"In Progress" then
            ProcessChecklistHeader.Validate("Process Status", ProcessChecklistHeader."process status"::"In Progress");
    end;

    local procedure SetChecklistComplete()
    var
        ProcessChecklistHeader: Record "Process Checklist Header";
    begin
        if ProcessChecklistHeader."Process Status" <> ProcessChecklistHeader."process status"::Completed then begin
            ProcessChecklistHeader.Validate("Process Status", ProcessChecklistHeader."process status"::Completed);
            CurrPage.Update;
        end;
        /*
        ProcessChecklistHeader.GET("No.");
        IF ProcessChecklistHeader."Process Status" <> ProcessChecklistHeader."Process Status"::Completed THEN BEGIN
          ProcessChecklistHeader.VALIDATE("Process Status","Process Status"::Completed);
          ProcessChecklistHeader.MODIFY(TRUE);
        END;
        CurrPage.UPDATE;
        */

    end;
}

