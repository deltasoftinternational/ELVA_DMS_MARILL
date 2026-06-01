Page 25006384 "Service WIP Totals FactBox"
{
    PageType = ListPart;
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
            }
        }
    }

    actions
    {
    }
}

