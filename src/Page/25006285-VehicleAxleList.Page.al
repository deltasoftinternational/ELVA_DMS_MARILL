Page 25006285 "Vehicle Axle List"
{
    Caption = 'Vehicle Axle List';
    PageType = List;
    SourceTable = "Vehicle Axle";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101904006; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

