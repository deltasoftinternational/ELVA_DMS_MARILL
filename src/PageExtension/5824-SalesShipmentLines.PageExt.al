pageextension 25006100 "Sales Shipment Lines" extends "Sales Shipment Lines"//5824
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