Page 25006388 "Service WIP Totals"
{
    PageType = List;
    SourceTable = "Service WIP Total";

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
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderNo; Rec."Service Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostedCostAdjustment; Rec."Posted Cost Adjustment")
                {
                    ApplicationArea = Basic;
                }
                field(PostedSalesAdjustment; Rec."Posted Sales Adjustment")
                {
                    ApplicationArea = Basic;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                }
                field(ReversePostingDate; Rec."Reverse Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Consolidated; Rec.Consolidated)
                {
                    ApplicationArea = Basic;
                }
                field(ItemCAmtPosted; Rec."Item C. Amt. (Posted)")
                {
                    ApplicationArea = Basic;
                }
                field(ItemSAmtPosted; Rec."Item S. Amt. (Posted)")
                {
                    ApplicationArea = Basic;
                }
                field(LaborCAmtPosted; Rec."Labor C. Amt. (Posted)")
                {
                    ApplicationArea = Basic;
                }
                field(LaborSAmtPosted; Rec."Labor S. Amt. (Posted)")
                {
                    ApplicationArea = Basic;
                }
                field(ExtSCAmtPosted; Rec."Ext.S. C. Amt. (Posted)")
                {
                    ApplicationArea = Basic;
                }
                field(ExtSSAmtPosted; Rec."Ext.S. S. Amt. (Posted)")
                {
                    ApplicationArea = Basic;
                }
                field(CostAmtPosted; Rec."Cost Amt. (Posted)")
                {
                    ApplicationArea = Basic;
                }
                field(SalesAmtPosted; Rec."Sales Amt. (Posted)")
                {
                    ApplicationArea = Basic;
                }
                field(WIPTotals; Rec."WIP Totals")
                {
                    ApplicationArea = Basic;
                }
                field(ReverseDocumentNo; Rec."Reverse Document No.")
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
            group(ActionGroup25)
            {
                action("Reverse WIP G/L Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reverse WIP G/L Entries';

                    trigger OnAction()
                    var
                        PostReversWIP: Report "Service WIP Reverse";
                        ServiceWIPTotals: Record "Service WIP Total";
                    begin
                        ServiceWIPTotals.Reset;
                        if Rec.GetFilters <> '' then
                            ServiceWIPTotals.CopyFilters(Rec)
                        else
                            ServiceWIPTotals.SetRange("Document No.", Rec."Document No.");
                        PostReversWIP.SetTableview(ServiceWIPTotals);
                        PostReversWIP.RunModal;
                    end;
                }
            }
        }
        area(navigation)
        {
            group(ActionGroup27)
            {
                action("Show G/L Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show G/L Entries';

                    trigger OnAction()
                    var
                        GLEntries: Record "G/L Entry";
                        GLEntriesPage: Page "General Ledger Entries";
                        SourceCodeSetup: Record "Source Code Setup";
                    begin
                        SourceCodeSetup.Get;
                        GLEntries.Reset;
                        GLEntries.SetFilter("Document No.", '%1|%2', Rec."Document No.", Rec."Reverse Document No.");
                        GLEntries.SetRange("Source Code", SourceCodeSetup."Service G/L WIP EDMS");
                        GLEntriesPage.SetTableview(GLEntries);
                        GLEntriesPage.RunModal;
                    end;
                }
                action("Show WIP Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show WIP Entries';
                    RunObject = Page "Service WIP Entries";
                    RunPageLink = "Document No." = field("Document No.");

                    trigger OnAction()
                    var
                        WIPEntries: Page "Service WIP Entries";
                    begin
                    end;
                }
                action("Show Posted WIP Service Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Posted WIP Service Lines';
                    RunObject = Page "Service Mechanic Line Tasks";
                    //RunPageLink = "Shipment Date"=field("Document No."); //FIXME
                }
            }
        }
    }
}

