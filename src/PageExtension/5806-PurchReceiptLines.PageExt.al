pageextension 25006098 "Purch. Receipt Lines" extends "Purch. Receipt Lines"//5806
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
            field(ModelCode; Rec."Model Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(ModelVersionNo; Rec."Model Version No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}