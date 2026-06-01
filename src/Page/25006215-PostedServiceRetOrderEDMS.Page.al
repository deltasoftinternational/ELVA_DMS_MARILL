Page 25006215 "Posted Service Ret.Order EDMS"
{
    // 18.01.2017 EB.P7 Upgrade 2017
    //   Removed functionality from "Credit Cards Transaction Lo&g Entries" action
    //   because of standard page removed.
    // 
    // 23.02.2015 EDMS P21
    //   Added field:
    //     "Model Version No."
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3

    Caption = 'Posted Service Return Order';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Posted Serv. Ret. Order Header";

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
                    Editable = false;
                    Importance = Promoted;
                }
                field(YourReference; Rec."Your Reference")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field(SelltoContactNo; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SelltoAddress; Rec."Sell-to Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SelltoAddress2; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SelltoPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SelltoCity; Rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SelltoContact; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ReturnOrderNo; Rec."Return Order No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(VIN; Rec.VIN)
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
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(NoPrinted; Rec."No. Printed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
            }
            part(ServiceLines; "Posted Serv.R.Order Subf. EDMS")
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
                    Editable = false;
                    Importance = Promoted;
                }
                field(BilltoContactNo; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(BilltoName; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(BilltoAddress; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(BilltoAddress2; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(BilltoPostCode; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(BilltoCity; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(BilltoContact; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(ForeignTrade)
            {
                Caption = 'Foreign Trade';
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        ChangeExchangeRate.Editable(false);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                            Rec."Currency Factor" := ChangeExchangeRate.GetParameter;
                            Rec.Modify;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field(EU3PartyTrade; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';
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
            }
            group(ServiceAddress)
            {
                Caption = 'Service Address';
                field(ServiceAddressCode; Rec."Service Address Code")
                {
                    ApplicationArea = Basic;
                }
                field(Control25006007; Rec."Service Address")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(25006154),
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
            group(Invoice)
            {
                Caption = '&Invoice';
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
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Posted Serv.R.Order Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const("Posted Service Return Order"),
                                  "No." = field("No.");
                }
                action("<Action112>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        PostedApprovalEntries.Setfilters(Database::"Sales Invoice Header", Rec."No.");
                        PostedApprovalEntries.Run;
                    end;
                }
                separator(Action171)
                {
                }
                action(CreditCardsTransactionLogEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Credit Cards Transaction Lo&g Entries';
                    Image = Translations;
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
                begin
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.PrintRecords(true);
                end;
            }
            action("<Action59>")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    rec.Navigate;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
    end;

    var
        SalesInvHeader: Record "Sales Invoice Header";
        PostedApprovalEntries: Page "Posted Approval Entries";
        ChangeExchangeRate: Page "Change Exchange Rate";
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
}

