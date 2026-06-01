pageextension 25006018 "Req. Worksheet Templates" extends "Req. Worksheet Templates"//293
{
    layout
    {
        modify("Page ID")
        {
            Visible = true;
        }
        modify("Page Caption")
        {
            Visible = true;
        }
        addafter("Page Caption")
        {
            field(DocumentProfile; Rec."Document Profile")
            {
                ApplicationArea = Basic;

            }
        }
    }
}