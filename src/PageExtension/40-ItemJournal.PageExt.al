pageextension 25006012 "Item Journal" extends "Item Journal" //40
{
    layout
    {
        addafter("External Document No.")
        {
            field(MakeCode; Rec."Make Code")
            {
                ApplicationArea = Basic;
            }
            field(ModelCode; Rec."Model Code")
            {
                ApplicationArea = Basic;
            }
            field(ModelVersionNo; Rec."Model Version No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Item No.")
        {
            field(VIN; Rec.VIN)
            {
                ApplicationArea = Basic;
            }
            field(VehicleSerialNo; Rec."Vehicle Serial No.")
            {
                ApplicationArea = Basic;
            }
            field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
            {
                ApplicationArea = Basic;
            }
            field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
