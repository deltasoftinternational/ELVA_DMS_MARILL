pageextension 25006011 "General Journal" extends "General Journal" //39
{
    layout
    {
        addafter("Account No.")
        {
            field(PostingGroup; Rec."Posting Group")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Comment)
        {
            field(VehicleSerialNo; Rec."Vehicle Serial No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(VIN; Rec.VIN)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(SourceType; Rec."Source Type")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(SourceNo; Rec."Source No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}