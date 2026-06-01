tableextension 25006125 "Campaign" extends "Campaign"  //5071
{
    DrillDownPageID = "Campaign List";
    fields
    {
        field(25006010; "Campaign Applies to All"; Boolean)
        {
            Caption = 'Campaign Applies to All';
        }
        field(25006020; "Activated (Sales)"; Boolean)
        {
            Caption = 'Activated (Sales)';
            Editable = false;
        }
    }

    keys
    {
        key(Key3; "Activated (Sales)")
        {
        }
    }
}