Page 25006525 "Vehicle Opt. Ledger Entries"
{
    // 12.07.2004 EDMS P1
    //   * Created

    Caption = 'Vehicle Opt. Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Vehicle Opt. Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
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
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(OptionType; Rec."Option Type")
                {
                    ApplicationArea = Basic;
                }
                field(OptionSubtype; Rec."Option Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalCode; Rec."External Code")
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
                field(Standard; Rec.Standard)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic;
                }
                field(ClosedbyEntryNo; Rec."Closed by Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(CostAmountLCY; Rec."Cost Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(SalesPriceLCY; Rec."Sales Price (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(SalesDiscount; Rec."Sales Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(SalesDiscountAmountLCY; Rec."Sales Discount Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(SalesAmountLCY; Rec."Sales Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
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
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    frmNavigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    frmNavigate.Run;
                end;
            }
        }
    }

    var
        frmNavigate: Page Navigate;
}

