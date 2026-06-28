page 25006446 "Closed Warranty Document Subf"
{
    ApplicationArea = All;
    Caption = 'Closed Warranty Document Subform';
    PageType = ListPart;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Warranty Document Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control25006014)
            {
                field(InitialServiceOrderNo; Rec."Initial Service Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderNo; Rec."Service Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderLineNo; Rec."Service Order Line No.")
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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(AmountIncludingVAT; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(StandardTime; Rec."Standard Time")
                {
                    ApplicationArea = Basic;
                }
                field(SymptomCode; Rec."Symptom Code")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(LaborType; Rec."Labor Type")
                {
                    ApplicationArea = Basic;
                }
                field(CostAdjustmentFactor; Rec."Cost Adjustment Factor")
                {
                    ApplicationArea = Basic;
                }
                field(AdjustedAmount; Rec."Adjusted Amount")
                {
                    ApplicationArea = Basic;
                }
                field(ReplacementPartSerialNo; Rec."Replacement Part Serial No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control25006026)
            {
                ShowCaption = false;
                group(Control25006025)
                {
                    ShowCaption = false;
                    field("Total Amount"; WarrDocHeadAmounts."Total Amount")
                    {
                        ApplicationArea = Basic;
                        DrillDown = false;
                        Editable = false;
                    }
                    field("Total Adjusted Amount"; WarrDocHeadAmounts."Total Adjusted")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                }
                group(Control25006022)
                {
                    ShowCaption = false;
                    field("Total Approved"; WarrDocHeadAmounts."Total Approved")
                    {
                        ApplicationArea = Basic;
                        DrillDown = false;
                        Editable = false;
                    }
                    field("Total Rejected"; WarrDocHeadAmounts."Total Rejected")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
    }

    var
        WarrantyDocumentHeader: Record "Warranty Document Header";
        WarrDocHeadAmounts: Record "Warranty Document Header";

    trigger OnAfterGetCurrRecord()
    begin
        WarrDocHeadAmounts.get(Rec."Document No.");
        WarrDocHeadAmounts.CalcFields("Total Amount", "Total Adjusted", "Total Approved", "Total Rejected");
    end;
}
