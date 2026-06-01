Page 25006409 "Warranty Reimbursement Entries"
{
    // 06.10.2017 EB.AKR Warranty
    //   Added Field:
    //     "Labor Type"

    ApplicationArea = Basic;
    Caption = 'Warranty Reimbursement Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Warranty Reimbursment Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(WarrantyDocumentNo; Rec."Warranty Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(WarrantyDocumentLineNo; Rec."Warranty Document Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(LaborType; Rec."Labor Type")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DebitCode; Rec."Debit Code")
                {
                    ApplicationArea = Basic;
                }
                field(DebitDescription; Rec."Debit Description")
                {
                    ApplicationArea = Basic;
                }
                field(RejectCode; Rec."Reject Code")
                {
                    ApplicationArea = Basic;
                }
                field(RejectDescription; Rec."Reject Description")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(DebitCodeType; Rec."Debit Code Type")
                {
                    ApplicationArea = Basic;
                }
                field(CoverageId; Rec.CoverageId)
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
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
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

