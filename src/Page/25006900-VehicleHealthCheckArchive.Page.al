Page 25006900 "Vehicle Health Check Archive"
{
    Caption = 'Vehicle Health Check Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Print';
    RefreshOnActivate = true;
    SourceTable = "Service Header Archive EDMS";
    SourceTableView = where("Document Type" = filter("Order"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(VehicleRegistrationNo; rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field(VehicleSerialNo; rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Serial No.';
                    Visible = VehicleSerialNoVisible;
                }
                field(Vehicle_Description; VehicleDescription())
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Description';
                }
                field(VariableFieldRun1; rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                }
                field(Customer; rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer';
                    Importance = Promoted;
                    ShowMandatory = true;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GHFeaturesMgt: Codeunit "Checklist Features Mgt.";
                        Customer: Record Customer;
                        CustNo: Code[20];
                    begin
                    end;

                    trigger OnValidate()
                    var
                        MiniCustomerMgt: Codeunit "Customer Mgt.";
                        CustNo: Code[20];
                    begin
                    end;
                }
                field(Address; rec."Sell-to Address")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address';
                    Importance = Additional;
                }
                field(Address2; rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address 2';
                    Importance = Additional;
                }
                field(PostCode; rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code';
                    Importance = Additional;
                }
                field(City; rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                    Caption = 'City';
                    Importance = Additional;
                }
                field(Contact; rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contact';
                    Importance = Standard;
                }
                field(MobilePhoneNo; rec."Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = PhoneNo;
                    ShowMandatory = true;
                }
                field(PhoneNo; rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                }
                field(EMail; rec."E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(OrderDate; rec."Order Date")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(OrderTime; rec."Order Time")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(LocationCode; rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(ServiceAdvisor; rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(VHCStatus; rec."VHC Status")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Comments; "Serv. Arch. Comment Sheet")
            {
                SubPageLink = Type = const("Posted Service Order"),
                              "No." = field("No."),
                              "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                              "Version No." = field("Version No.");
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
                        GHCheckListAddInManagement.FillCheckListArch(ProcessChecklistHeaderArch, Buffer);
                        GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, ActLineNo);
                        CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                    end;

                    trigger RequestTextChange(LineNo: Integer; CommentText: Text)
                    var
                        ChecklistLine: Record "Process Checklist Line";
                        Buffer: Record "Checklist Buffer" temporary;
                        AddInData: Text;
                    begin
                        GHCheckListAddInManagement.FillCheckListArch(ProcessChecklistHeaderArch, Buffer);
                        GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
                        CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                    end;

                    trigger RequestRadioChange(LineNo: Integer; RadioValue: Text)
                    var
                        ChecklistLine: Record "Process Checklist Line";
                        Buffer: Record "Checklist Buffer" temporary;
                        AddInData: Text;
                    begin
                        GHCheckListAddInManagement.FillCheckListArch(ProcessChecklistHeaderArch, Buffer);
                        GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
                        CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                    end;

                    trigger RequestCheckChange(LineNo: Integer; CheckValue: Text)
                    var
                        ChecklistLine: Record "Process Checklist Line";
                        Buffer: Record "Checklist Buffer" temporary;
                        AddInData: Text;
                    begin
                        GHCheckListAddInManagement.FillCheckListArch(ProcessChecklistHeaderArch, Buffer);
                        GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
                        CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                    end;

                    trigger RequestAssistEditButton(LineNo: Integer)
                    begin
                    end;

                    trigger RequestButton(LineNo: Integer)
                    begin
                    end;
                }
            }
            part(ServiceLines; "VHC Arch. Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type"),
                              "Version No." = field("Version No."),
                              "Doc. No. Occurrence" = field("Doc. No. Occurrence");
            }
        }
        area(factboxes)
        {
            part("Vehicle Pictures"; "Object Picture FactBox")
            {
                Caption = 'Vehicle Pictures';
                SubPageLink = "Source Type" = const(Database::Vehicle),
                              "Source Subtype" = const("0"),
                              "Source ID" = field("Vehicle Serial No."),
                              "Source Ref. No." = const(0);
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
            }
            part(Control19; "Service Document FactBox EDMS")
            {
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
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action(Action1000000002)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Serv. Arch. Comment Sheet";
                    RunPageLink = Type = const("Posted Service Order"),
                                  "No." = field("No."),
                                  "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                  "Version No." = field("Version No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Schedule Start Date Time", "Schedule End Date Time");
    end;

    trigger OnInit()
    begin
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetServiceFilterEDMS <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetServiceFilterEDMS);
            Rec.FilterGroup(0);
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate - 1);

        SetDocNoVisible;
        ServiceMgtSetup.Get;
        IsVisibleServiceAddress := ServiceMgtSetup."Show Service Address";
        VehicleSerialNoVisible := ServiceMgtSetup."Vehicle No. Promoted";

        ProcessChecklistHeaderArch.Reset;
        ProcessChecklistHeaderArch.SetRange("VHC No.", Rec."No.");
        ProcessChecklistHeaderArch.SetRange("VHC Doc. No. Occurrence", rec."Doc. No. Occurrence");
        ProcessChecklistHeaderArch.SetRange("VHC Version No.", rec."Version No.");
        if ProcessChecklistHeaderArch.FindFirst then;
    end;

    var
        // UserMgt: Codeunit "User Setup Management";
        UserMgt: Codeunit "UserProfileManagement";
        ApprovalEntries: Page "Approval Entries";
        ServInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        LostSaleMgt: Codeunit "Lost Sales Management";
        [InDataSet]
        Resources: Text[250];
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ShortcutDimCode: array[8] of Code[20];
        DocNoVisible: Boolean;
        IsVisibleServiceAddress: Boolean;
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        VehicleSerialNoVisible: Boolean;
        GHCheckListAddInManagement: Codeunit "Checklist AddIn Management";
        ProcessChecklistHeaderArch: Record "Process Checklist Header Arch.";

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
        rec.CalcFields("Model Commercial Name");
        exit(rec."Make Code" + ' ' + rec."Model Code");
    end;

    local procedure CaptionText(): Text
    begin
    end;

    local procedure UpdateLines()
    var
        AddInData: Text;
        Buffer: Record "Checklist Buffer" temporary;
    begin
        GHCheckListAddInManagement.FillCheckListArch(ProcessChecklistHeaderArch, Buffer);
        GHCheckListAddInManagement.CheckListControlAddInReady(AddInData);
        CurrPage.CheckList.RecieveInitCheckListData(AddInData);
    end;
}

