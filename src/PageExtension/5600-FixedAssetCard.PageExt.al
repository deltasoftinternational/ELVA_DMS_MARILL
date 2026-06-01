pageextension 25006026 "Fixed Asset Card" extends "Fixed Asset Card"//5600
{
    layout
    {
        addbefore(Maintenance)
        {
            field(Control31; Rec."FA Posting Group")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Maintenance)
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(FuelType; Rec."Fuel Type")
                {
                    ApplicationArea = Basic;
                }
                field(SalesDate; Rec."Sales Date")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}