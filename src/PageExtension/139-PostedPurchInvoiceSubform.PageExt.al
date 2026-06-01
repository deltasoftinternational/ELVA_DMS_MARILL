pageextension 25006058 "Posted Purch. Invoice Subform" extends "Posted Purch. Invoice Subform"//139
{
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field(ExternalServTrackingNo; Rec."External Serv. Tracking No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}