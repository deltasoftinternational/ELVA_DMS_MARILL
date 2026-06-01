Page 25006090 "Contract Vehicles"
{
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Set Visible FALSE to fields:
    //     "Contract Type"
    //     "Contract No."
    // 
    // 07.04.2014 Elva Baltic P15 # MMG7.00
    //   * initial creation

    Caption = 'Contract Vehicles';
    SourceTable = "Contract Vehicle";
    ApplicationArea = Basic;
    PageType = List;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000007)
            {
                field(ContractType; Rec."Contract Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehMakeCode; Rec."Veh. Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehModelCode; Rec."Veh. Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehModelVersionNo; Rec."Veh. Model Version No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field("Rent Asset No."; Rec."Rent Asset No.")
                {
                    ToolTip = 'Specifies the Rent Asset related to this vehicle.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                action(CreateRentAsset)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Rent Asset';
                    Image = Item;

                    trigger OnAction()
                    begin
                        Rec.CreateRentAsset;
                    end;
                }
            }
        }
    }
}

