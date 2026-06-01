pageextension 25006080 "Interaction Log Entries" extends "Interaction Log Entries"//5076
{
    layout
    {
        addafter(Comment)
        {
            field(VehicleSerialNo; Rec."Vehicle Serial No.")
            {
                ApplicationArea = Basic;
            }
            field(VIN; Rec.VIN)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
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
            field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addlast(content)
        {
            group(Control78)
            {
                field(ContactName; Rec."Contact Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contact Name';
                    DrillDown = false;
                }
                field(ContactCompanyName; Rec."Contact Company Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                }
                field("<Make Code 2>"; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field("<VIN 2>"; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}