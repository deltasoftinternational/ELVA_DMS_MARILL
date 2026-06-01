Page 25006893 "Service Booking List"
{
    Caption = 'Service Booking Worksheet';
    CardPageID = "Service Booking";
    Editable = true;
    PageType = CardPart;
    PromotedActionCategories = 'New,Process,Report,Print';
    SourceTable = "Service Header EDMS";
    SourceTableView = where("Document Type" = const(Booking));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
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
                field(TotalWorkHours; Rec."Total Work (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(DealType; Rec."Deal Type")
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(WorkStatusCode; Rec."Work Status Code")
                {
                    ApplicationArea = Basic;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(TCardContainerEntryNo; Rec."TCard Container Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BookingResourceNo; Rec."Booking Resource No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
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
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.Run;
                    end;
                }
            }
            group(Create)
            {
                Caption = 'Create';
                action("<Action168>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Make &Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        Codeunit.Run(Codeunit::"Service Booking to Order (Y/N)", Rec);
                    end;
                }
                action("<Action1102601015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&reate Contact';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        if Rec.CheckContactCreated(false) then
                            CurrPage.Update(true);
                    end;
                }
                action("<Action1102701015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&reate Customer';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        if rec.CheckCustomerCreated(false) then
                            CurrPage.Update(true);
                    end;
                }
                action("<Action1102801015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&reate Vehicle';
                    Image = New;

                    trigger OnAction()
                    begin
                        if Rec.CheckVehicleCreated(false) then
                            CurrPage.Update(true);
                    end;
                }
            }
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


    procedure PageUpdate()
    begin
        CurrPage.Update(false);
    end;
}

