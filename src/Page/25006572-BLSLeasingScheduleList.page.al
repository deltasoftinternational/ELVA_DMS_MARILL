page 25006572 "BLS Leasing Schedule List"
{

    Caption = 'Leasing Schedule List';
    CardPageID = "BLS Leasing Schedule Card";
    Editable = false;
    PageType = List;
    SourceTable = "BLS Leasing Schedule Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Amount"; Rec."Loan Amount")
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
                }
                field("Term Of Lease, Months"; Rec."Term Of Lease, Months")
                {
                    ApplicationArea = All;
                }
                field("Interest, % (Monthly)"; Rec."Interest, % (Monthly)")
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
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Lease Amount (Mounthly)"; Rec."Lease Amount (Mounthly)")
                {
                    ApplicationArea = All;
                }
                field("Service Amount (Mounthly)"; Rec."Service Amount (Mounthly)")
                {
                    ApplicationArea = All;
                }
                field("Total Amount (Mounthly)"; Rec."Total Amount (Mounthly)")
                {
                    ApplicationArea = All;
                }
                field("Interest Amount"; Rec."Interest Amount")
                {
                    ApplicationArea = All;
                }
                field("Finance Value"; Rec."Finance Value")
                {
                    ApplicationArea = All;
                }
                field("Service Amount"; Rec."Service Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
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
    }

    trigger OnOpenPage()
    begin
        //SETRANGE(Status, Status::Open);
    end;
}

