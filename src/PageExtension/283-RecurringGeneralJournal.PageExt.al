pageextension 25006070 "Recurring General Journal" extends "Recurring General Journal" //283
{
    layout
    {
        addafter(ShortcutDimCode4)
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
            field(MakeCode; Rec."Make Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Reverse Date Calculation")
        {
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