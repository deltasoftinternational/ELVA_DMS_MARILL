pageextension 25006096 "Revaluation Journal" extends "Revaluation Journal"//5803
{
    layout
    {

        addlast(Control1)
        {
            field(VehicleSerialNo; Rec."Vehicle Serial No.")
            {
                ApplicationArea = Basic;
            }
            field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
            {
                ApplicationArea = Basic;
            }
            field(VIN; Rec.VIN)
            {
                ApplicationArea = Basic;
            }
        }
    }
}