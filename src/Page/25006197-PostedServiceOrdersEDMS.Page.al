Page 25006197 "Posted Service Orders EDMS"
{
    // 13.05.2014 Elva Baltic P21 #S0100 MMG7.00
    //   Modified triggers:
    //     OnAfterGetRecord
    //     <Action32> - OnAction()
    //   Modified function:
    //     GetSatisfaction
    // 
    // 14.04.2014 Elva Baltic P18 #RX029 MMG7.00
    //   Modified Procedure
    //     CommentsExist()
    // 
    // 27.03.2014 Elva Baltic P18 #RX029 MMG7.00
    //   Added field "Phone No."
    //   Added function & field
    //     GetSatisfaction()
    //     CommentsExist()

    ApplicationArea = Basic;
    Caption = 'Posted Service Orders';
    CardPageID = "Posted Service Order EDMS";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Serv. Order Header";
    UsageCategory = History;

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
                field("Initial Service Order No."; Rec."Initial Service Order No.")
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
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;

                    trigger OnDrillDown()
                    begin
                        Rec.SetRange("No.");
                        Page.RunModal(Page::"Posted Sales Invoice", Rec)
                    end;
                }
                field(AmountIncludingVAT; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic;

                    trigger OnDrillDown()
                    begin
                        Rec.SetRange("No.");
                        Page.RunModal(Page::"Posted Sales Invoice", Rec)
                    end;
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
                field(BilltoPostCode; rec."Bill-to Post Code")
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
                field(ServiceAdvisor; rec."Service Advisor")
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
                field(NoPrinted; Rec."No. Printed")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
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
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Control7; Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                }
                field(ScheduleStartDate; DateTimeMgt.Datetime2Date(Rec."Schedule Start Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Start Date';
                }
                field(ScheduleStartTime; DateTimeMgt.Datetime2Time(Rec."Schedule Start Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Start Time';
                }
                field(ScheduleEndDate; DateTimeMgt.Datetime2Date(Rec."Schedule End Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule End Date';
                }
                field(ScheduleEndTime; DateTimeMgt.Datetime2Time(Rec."Schedule End Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule End Time';
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
                SubPageLink = "Table ID" = CONST(25006149),
                              "No." = FIELD("No.");
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
            group("<Action19>")
            {
                Caption = '&Order';
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
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Posted Service Order EDMS", Rec)
                    end;
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Posted Serv. Order Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        // 13.05.2014 Elva Baltic P21 #S0100 MMG7.00 >>
                        ServiceCommentLine.Reset;
                        ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Posted Service Order");
                        ServiceCommentLine.SetRange("No.", Rec."No.");
                        if ServiceCommentLine.FindFirst then;
                        if Page.RunModal(Page::"Service Comment Sheet EDMS", ServiceCommentLine) = Action::LookupOK then begin
                            Comments := CommentsExist;
                        end;
                        // 13.05.2014 Elva Baltic P21 #S0100 MMG7.00 <<
                    end;
                }
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
            }
        }
        area(processing)
        {
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocMgt: Codeunit DocumentManagementDMS;
                    DocReport: Record "Document Report";
                begin
                    //CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    //SalesInvHeader.PrintRecords(TRUE);

                    DocMgt.PrintCurrentDoc(3, 3, 8, DocReport);
                    DocMgt.SelectPostServDocReport(DocReport, Rec)
                end;
            }
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Comments := CommentsExist;                                // 13.05.2014 Elva Baltic P21 #S0100 MMG7.00
        Rec.CalcFields("Schedule Start Date Time", "Schedule End Date Time");
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
        SalesInvHeader: Record "Sales Invoice Header";
        Comments: Boolean;
        ServiceCommentLine: Record "Service Comment Line EDMS";
        UserMgt: Codeunit "User Setup Management";
        UserMgtEDMS: Codeunit "UserProfileManagement";
        DateTimeMgt: Codeunit "Datetime Mgt.";


    procedure CommentsExist(): Boolean
    var
        ServiceComment: Record "Service Comment Line EDMS";
    begin
        ServiceComment.Reset;
        ServiceComment.SetRange(Type, ServiceComment.Type::"Posted Service Order");
        ServiceComment.SetRange("No.", Rec."No.");
        if ServiceComment.FindFirst then
            exit(true);

        exit(false); // 14.04.2014 Elva Baltic P18 #RX029 MMG7.00
    end;
}

