pageextension 25006088 "Item Substitution Entry" extends "Item Substitution Entry"//5716
{
    layout
    {
        addbefore("Variant Code")
        {
            field(No; Rec."No.")
            {
                ApplicationArea = Basic;
            }
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Variant Code")
        {
            field(ReplacementInfo; Rec."Replacement Info.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Condition)
        {
            field(PostingDate; Rec."Posting Date")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(SupersedingQuantity; Rec."Superseding Quantity")
            {
                ApplicationArea = Basic;
            }
            field(ConditionGroup; Rec."Condition Group")
            {
                ApplicationArea = Basic;
            }
            field(EntryType; Rec."Entry Type")
            {
                ApplicationArea = Basic;
            }
        }
        modify(Interchangeable)
        {
            Visible = false;
        }
        addafter(Interchangeable)
        {
            field("EDMS Interchangeable"; Rec."EDMS Interchangeable")
            {
                ApplicationArea = All;
            }

        }
    }
}