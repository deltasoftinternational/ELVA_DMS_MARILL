Page 25006687 "Vehicle Health Checks"
{
    // 02/11/2017 GP1 P30
    //   Modified actions:
    //     "P&ost"
    //     "Post and &Print"
    //     "Post and Email"
    // 
    // 22.10.2015 NAV2016 Merge
    //   Approvals removed
    // 
    // 2014.09.15 EDMS P7
    //   * tcp error fix. Schedule page run moved from code to properties
    // 
    // 2012.05.08 EDMS P8
    //   * Added column Resources

    Caption = 'Vehice Health Checks';
    CardPageID = "Vehicle Health Check Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Print';
    SourceTable = "Service Header EDMS";
    SourceTableView = where("Document Type" = const(VHC));

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
                field(VehicleNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle No.';
                    Visible = false;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(CustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer No.';
                }
                field(CustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Name';
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VHCStatus; Rec."VHC Status")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
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
                              "Source Subtype" = const("0"),
                              "Source ID" = field("Vehicle Serial No."),
                              "Source Ref. No." = const(0);
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
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const("Warranty Doc"),
                                  "No." = field("No.");
                }
            }
            group(Vehicle)
            {
                Caption = 'Vehicle';
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
                        //SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.Run;
                    end;
                }
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
            }
            group(Print)
            {
                Caption = '&Print';
                Visible = false;
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
    var
        UserProfileMgt: Codeunit UserProfileManagement;
        BranchProfileSetup: Record "Branch Profile Setup";
    begin
        if UserMgtEDMS.GetServiceFilterEDMS <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgtEDMS.GetServiceFilterEDMS);
            Rec.FilterGroup(0);
        end;

        if UserProfileMgt.CurrProfileID <> '' then
            if BranchProfileSetup.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
                if BranchProfileSetup."Service Location Filter" <> '' then
                    Rec.SetFilter("Location Code", BranchProfileSetup."Service Location Filter");
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
        UserMgtEDMS: Codeunit "UserProfileManagement";
}

