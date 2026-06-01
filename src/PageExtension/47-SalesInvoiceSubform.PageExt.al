pageextension 25006049 "Sales Invoice Subform" extends "Sales Invoice Subform"//47
{
    layout
    {
        addafter("VAT Prod. Posting Group")
        {
            field(ExternalServTrackingNo; Rec."External Serv. Tracking No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}