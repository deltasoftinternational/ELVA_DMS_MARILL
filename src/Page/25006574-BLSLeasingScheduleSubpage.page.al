page 25006574 "BLS Leasing Schedule Subpage"
{

    Editable = false;
    PageType = ListPart;
    SourceTable = "BLS Leasing Schedule Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                ShowCaption = false;
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                }
                field("Begining Balance"; Rec."Begining Balance")
                {
                    ApplicationArea = All;
                }
                field("Ending Balance"; Rec."Ending Balance")
                {
                    ApplicationArea = All;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Amount"; Rec."Interest Amount")
                {
                    ApplicationArea = All;
                }
                field("Lease Amount"; Rec."Lease Amount")
                {
                    ApplicationArea = All;
                }
                /*
                field("Add. Service Amount Incl. VAT"; Rec."Add. Service Amount Incl. VAT")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                */
                field(SalesDocumentType; SalesDocumentType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Document Type';
                    OptionCaption = ' ,Invoice,Credit Memo,Posted Invoice,Posted Credit Memo';
                }
                field(GetSalesDocumentNo; Rec.GetSalesDocumentNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Document No.';

                    trigger OnDrillDown()
                    begin
                        case SalesDocumentType of
                            Salesdocumenttype::Invoice, Salesdocumenttype::"Credit Memo":
                                begin
                                    SalesHeader.Reset;
                                    SalesHeader.SetRange("No.", Rec.GetSalesDocumentNo);
                                    if SalesDocumentType = Salesdocumenttype::Invoice then
                                        Page.Run(Page::"Sales Invoice", SalesHeader)
                                    else
                                        Page.Run(Page::"Sales Credit Memo", SalesHeader);
                                end;
                            Salesdocumenttype::"Posted Invoice":
                                begin
                                    SalesInvHeader.Reset;
                                    SalesInvHeader.SetRange("No.", Rec.GetSalesDocumentNo);
                                    Page.Run(Page::"Posted Sales Invoice", SalesInvHeader);
                                end;
                            Salesdocumenttype::"Posted Credit Memo":
                                begin
                                    SalesCreditMemo.Reset;
                                    SalesCreditMemo.SetRange("No.", Rec.GetSalesDocumentNo);
                                    Page.Run(Page::"Posted Sales Credit Memo", SalesCreditMemo);
                                end;
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create New Schedule")
            {
                Caption = 'Create New Schedule';

                trigger OnAction()
                begin
                    Rec.CreateNewSchedule;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SalesDocumentType := Rec.GetSalesDocumentType;
    end;

    var
        SalesDocumentType: Option " ",Invoice,"Credit Memo","Posted Invoice","Posted Credit Memo";
        SalesDocumentNo: Code[20];
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCreditMemo: Record "Sales Cr.Memo Header";

}

