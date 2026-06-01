pageextension 25006057 "Purch. Cr. Memo Subform" extends "Purch. Cr. Memo Subform"//98
{
    layout
    {
        addafter(ShortcutDimCode8)
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
        }
    }
}