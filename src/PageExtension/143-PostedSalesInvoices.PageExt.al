pageextension 25006061 "Posted Sales Invoices" extends "Posted Sales Invoices"   //143
{
    layout
    {
        addlast(Control1)
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
            field("Deal Type Code"; Rec."Deal Type Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Pre-Assigned No."; Rec."Pre-Assigned No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of the sales document that the posted invoice was created for.';
            }
        }
    }
}