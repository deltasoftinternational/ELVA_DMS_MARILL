pageextension 25006459 "Sales Quotes" extends "Sales Quotes" //9300
{
    layout
    {
        addafter("Quote Valid Until Date")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}