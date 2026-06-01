pageextension 25006081 "Create Interaction" extends "Create Interaction"//5077
{
    layout
    {
        addafter("Wizard Contact Name")
        {
            field(VehicleSerialNo; Rec."Vehicle Serial No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}