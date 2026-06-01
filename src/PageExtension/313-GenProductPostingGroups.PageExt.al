pageextension 25006072 "Gen. Product Posting Groups" extends "Gen. Product Posting Groups" //313
{
    layout
    {
        addafter("Auto Insert Default")
        {
            field("Split Value Entries"; Rec."Split Value Entries")
            {
                ApplicationArea = All;
            }
        }
    }
}