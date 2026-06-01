Page 25006087 "Get Vehicle to Charge"
{
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Added LVI captions
    // 
    // 16.01.2014 EDMS P15
    //   * Initial edition

    Caption = 'Get Vehicle to Charge';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(VehicleSerialNo; VehicleSerialNo)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Serial No.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    Vehicle.Reset;
                    if LookUpMgt.LookUpVehicleAMT(Vehicle, VehicleSerialNo) then begin
                        Text := Vehicle."Serial No.";
                        exit(true)
                    end;
                end;

                trigger OnValidate()
                begin
                    VehicleAccCycleNo := '';
                    if VehicleSerialNo <> '' then
                        if Vehicle.Get(VehicleSerialNo) then begin
                            Vehicle.CalcFields("Default Vehicle Acc. Cycle No.");
                            VehicleAccCycleNo := Vehicle."Default Vehicle Acc. Cycle No.";
                        end;
                    CurrPage.Update;
                end;
            }
            field(VehAccCycleNo; VehicleAccCycleNo)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Accounting Cycle No.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    recVehAccCycle.Reset;
                    if LookUpMgt.LookUpVehicleAccCycle(recVehAccCycle, VehicleSerialNo, '') then begin
                        Text := recVehAccCycle."No.";
                        exit(true);
                    end;
                end;
            }
            field(Positive; Positive)
            {
                ApplicationArea = Basic;
                Caption = 'Positive';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Positive := true;
    end;

    var
        VehicleSerialNo: Code[20];
        VehicleAccCycleNo: Code[20];
        LookUpMgt: Codeunit LookUpManagement;
        Vehicle: Record Vehicle;
        recVehAccCycle: Record "Vehicle Accounting Cycle";
        Positive: Boolean;


    procedure GetVehicleParams(var VehSerNo: Code[20]; var VehAccCycleNo: Code[20]; var VehOperationPositive: Boolean)
    begin
        VehSerNo := VehicleSerialNo;
        VehAccCycleNo := VehicleAccCycleNo;
        VehOperationPositive := Positive;
    end;
}

