pageextension 25006094 "Posted Transfer Receipt Lines" extends "Posted Transfer Receipt Lines"//5759
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
            field(VehicleStatusCode; Rec."Vehicle Status Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}