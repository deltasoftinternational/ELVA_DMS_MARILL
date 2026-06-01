page 25006573 "BLS Leasing Schedule Card"
{

    Caption = 'Leasing Schedule Card';
    PageType = Card;
    SourceTable = "BLS Leasing Schedule Header";
    PopulateAllFields = True;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        Rec.AssistEdit(xRec);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Sales Doc. Type"; Rec."Sales Doc. Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sales Doc. No."; Rec."Sales Doc. No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ContractCategoryCode; Rec."Contract Category Code")
                {
                    ApplicationArea = All;
                }
                group(Vehicle)
                {

                    Caption = 'Vehicle';
                    field("Vehicle Serial No."; Rec."Vehicle Serial No.")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field("Veh. Make Code"; Rec."Veh. Make Code")
                    {
                        ApplicationArea = All;
                        Editable = MakeModelEditable;
                    }
                    field("Veh. Model Code"; Rec."Veh. Model Code")
                    {
                        ApplicationArea = All;
                        Editable = MakeModelEditable;
                    }
                    field("Veh. Model Version No."; Rec."Veh. Model Version No.")
                    {
                        ApplicationArea = All;
                        Editable = MakeModelEditable;
                    }
                    field(VIN; Rec.VIN)
                    {
                        ApplicationArea = All;
                    }
                    field("Machine Hours"; Rec."Machine Hours")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Amounts)
                {
                    Caption = 'Amounts';
                    field("Currency Code"; Rec."Currency Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Amounts Including VAT"; Rec."Amounts Including VAT")
                    {
                        ApplicationArea = All;
                        Visible = false;
                    }
                    field("Sales Amount"; Rec."Sales Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Down Payment %"; Rec."Down Payment %")
                    {
                        ApplicationArea = All;
                    }
                    field("Down Payment Amount"; Rec."Down Payment Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Loan Amount"; Rec."Loan Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Residual %"; Rec."Residual %")
                    {
                        ApplicationArea = All;
                    }
                    field("Residual Value"; Rec."Residual Value")
                    {
                        ApplicationArea = All;
                    }
                    field("Repayment Amount"; Rec."Repayment Amount")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Term Of Lease, Months"; Rec."Term Of Lease, Months")
                    {
                        ApplicationArea = All;
                    }
                    field("Interest, % (Annual)"; Rec."Interest, % (Annual)")
                    {
                        ApplicationArea = All;
                    }
                    field("Starting Date"; Rec."Starting Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Ending Date"; Rec."Ending Date")
                    {
                        ApplicationArea = All;
                    }
                    field("Schedule Type"; Rec."Schedule Type")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Monthly)
                {
                    Caption = 'Monthly';
                    field("Lease Amount (Mounthly)"; Rec."Lease Amount (Mounthly)")
                    {
                        ApplicationArea = All;
                        Caption = 'Lease Amount';
                        Editable = false;
                    }
                    field("Service Amount (Mounthly)"; Rec."Service Amount (Mounthly)")
                    {
                        ApplicationArea = All;
                        Caption = 'Service Amount';
                    }
                    field("Total Amount (Mounthly)"; Rec."Total Amount (Mounthly)")
                    {
                        ApplicationArea = All;
                        Caption = 'Total Amount';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                }
                group(Totals1)
                {
                    Caption = 'Totals';
                    field("Interest Amount"; Rec."Interest Amount")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Finance Value"; Rec."Finance Value")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Service Amount"; Rec."Service Amount")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Total Amount"; Rec."Total Amount")
                    {
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                group(Leasing)
                {
                    Caption = 'Leasing';
                    field("Leasing Service Code"; Rec."Leasing Service Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Leas. VAT Prod. Posting Group"; Rec."Leas. VAT Prod. Posting Group")
                    {
                        ApplicationArea = All;
                    }
                    field("Leasing VAT %"; Rec."Leasing VAT %")
                    {
                        ApplicationArea = All;
                    }
                    field("Leasing Interest Service Code"; Rec."Leasing Interest Service Code")
                    {
                        ApplicationArea = All;
                    }
                    field("L. Interest VAT Pr. Post. Gr."; Rec."L. Interest VAT Pr. Post. Gr.")
                    {
                        ApplicationArea = All;
                    }
                    field("Lease Base"; Rec."Lease Base")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Lease VAT Amount"; Rec."Lease VAT Amount")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Lease Amount Incl. VAT"; Rec."Lease Amount Incl. VAT")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
                /*
                group("Additional Service")
                {
                    Caption = 'Additional Service';
                    field("Additional Service Code"; Rec."Additional Service Code")
                    {
                        ApplicationArea = All;
                    }
                    field("AddSer VAT Prod. Posting Group"; Rec."AddSer VAT Prod. Posting Group")
                    {
                        ApplicationArea = All;
                    }
                    field("Additional Service VAT %"; Rec."Additional Service VAT %")
                    {
                        ApplicationArea = All;
                    }
                    field("Add. Service Base"; Rec."Add. Service Base")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Add. Service VAT Amount"; Rec."Add. Service VAT Amount")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Add. Service Amount Incl. VAT"; Rec."Add. Service Amount Incl. VAT")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
                */
                group(Totals)
                {
                    Caption = 'Totals';
                    field("Total Base"; Rec."Total Base")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Total VAT Amount"; Rec."Total VAT Amount")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Total Amount Incl. VAT"; Rec."Total Amount Incl. VAT")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
            }
            part(Lines; 25006574)
            {
                ApplicationArea = All;
                Caption = 'Lines';
                Editable = false;
                SubPageLink = "Leasing Schedule No." = FIELD("No.");
            }
            part(ServLines; 25006576)
            {
                ApplicationArea = All;
                Caption = 'Additional Service Lines';
                SubPageLink = "Leasing Schedule No." = FIELD("No.");
            }
        }

        area(factboxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(25006757),
                              "No." = FIELD("No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Schedule")
            {
                Caption = 'Calculate Schedule';
                Image = CalculateCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Rec.CreateScheduleLines;
                end;
            }
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = Basic;

                    trigger OnAction()
                    var
                    begin
                        Rec.Release;
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = Basic;

                    trigger OnAction()
                    var
                    begin
                        Rec.Reopen;
                    end;
                }
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = Basic;

                trigger OnAction()
                var
                    Rec2: Record "BLS Leasing Schedule Header";
                begin
                    Rec2.RESET;
                    Rec2.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"BLS Leasing Schedule", TRUE, FALSE, Rec2);
                end;
            }
            action(CreateNewSchedule)
            {
                Caption = 'Create New Schedule';
                Image = New;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ApplicationArea = All;
                RunObject = Page "BLS Leasing Schedule Card";
                RunPageLink = "Sales Doc. Type" = FIELD("Sales Doc. Type"),
                              "Sales Doc. No." = FIELD("Sales Doc. No."),
                              "Customer No." = field("Customer No."),
                              "Sales Amount" = field("Sales Amount");

                RunPageMode = Create;
                /*
                trigger OnAction()
                var
                    Rec2: Record "BLS Leasing Schedule Header";
                begin
                    Rec2.RESET;
                    Rec2.SETRANGE("No.", "No.");
                    REPORT.RUNMODAL(REPORT::"BLS Leasing Schedule", TRUE, FALSE, Rec2);
                end;
                */
            }
        }
        area(navigation)
        {
            action("Show Contract")
            {
                Caption = 'Show Contract';
                Image = Document;
                Promoted = true;
                PromotedCategory = "Report";
                ApplicationArea = Basic;

                trigger OnAction()
                var
                    DMSContract: Record Contract;
                begin
                    Rec.TESTFIELD("Contract No.");
                    DMSContract.GET(Rec."Contract No.");
                    PAGE.RUN(PAGE::Contract, DMSContract);

                end;
            }
        }
    }
    var
        MakeModelEditable: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        MakeModelEditable := Rec."Vehicle Serial No." = '';
    end;
}

