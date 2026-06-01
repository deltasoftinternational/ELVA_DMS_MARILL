Page 25006492 "Purch. Vehicle Assembly"
{
    AutoSplitKey = true;
    Caption = 'Purch. Vehicle Assembly';
    DataCaptionFields = "Assembly ID", "Line No.";
    PageType = List;
    SourceTable = "Vehicle Assembly Line";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(AssemblyID; Rec."Assembly ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                    Visible = false;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(SalesPrice; Rec."Sales Price")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Make Code" := recGlobPurchLine."Make Code";
        Rec."Model Code" := recGlobPurchLine."Model Code";
        Rec."Model Version No." := recGlobPurchLine."Model Version No.";
    end;

    var
        recGlobPurchLine: Record "Purchase Line";


    procedure fSetPurchLine(recPurchLine: Record "Purchase Line")
    begin
        recGlobPurchLine := recPurchLine;
    end;
}

