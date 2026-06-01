Page 25006385 "Service WIP Entries"
{
    PageType = List;
    SourceTable = "Service WIP Entry";

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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(FinishedQty; Rec."Finished Qty.")
                {
                    ApplicationArea = Basic;
                }
                field(GLAccountNo; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(GLBalAccountNo; Rec."G/L Bal. Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(WIPEntryAmount; Rec."WIP Entry Amount")
                {
                    ApplicationArea = Basic;
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(WIPMethod; Rec."WIP Method")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                }
                field(ReverseDate; Rec."Reverse Date")
                {
                    ApplicationArea = Basic;
                }
                field(ReverseDocumentNo; Rec."Reverse Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(DimensionSetID; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Reversed, false);
    end;
}

