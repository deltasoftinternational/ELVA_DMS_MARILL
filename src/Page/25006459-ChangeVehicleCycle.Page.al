Page 25006459 "Change Vehicle Cycle"
{
    Caption = 'Change Vehicle Cycle';

    layout
    {
        area(content)
        {
            field(ID1; ID1)
            {
                ApplicationArea = Basic;
                Caption = 'Info 1';
                Editable = false;
            }
            field(ID2; ID2)
            {
                ApplicationArea = Basic;
                Caption = 'Info 2';
                Editable = false;
            }
            field(ID3; ID3)
            {
                ApplicationArea = Basic;
                Caption = 'Info 3';
                Editable = false;
            }
            field(ID4; ID4)
            {
                ApplicationArea = Basic;
                Caption = 'Info 4';
                Editable = false;
            }
            field(SerialNo; SerialNo)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Serial No.';
                Editable = false;
            }
            field(CurrCycle; CurrCycle)
            {
                ApplicationArea = Basic;
                Caption = 'Current Cycle No.';
                Editable = false;
            }
            field(NewCycle; NewCycle)
            {
                ApplicationArea = Basic;
                Caption = 'New Cycle No.';

                trigger OnLookup(var Text: Text): Boolean
                var
                    VehCycle: Record "Vehicle Accounting Cycle";
                    LookUpMgt: Codeunit LookUpManagement;
                begin
                    VehCycle.Reset;
                    if LookUpMgt.LookUpVehicleAccCycle(VehCycle, SerialNo, CurrCycle) then
                        NewCycle := VehCycle."No.";
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        NewCycle := CurrCycle;
    end;

    var
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ID1: Code[20];
        ID2: Code[20];
        ID3: Code[20];
        ID4: Code[20];


    procedure SetData(ID1L: Code[20]; ID2L: Code[20]; ID3L: Code[20]; ID4L: Code[20]; SerialNoL: Code[20]; CurrCycleL: Code[20])
    begin
        SerialNo := SerialNoL;
        CurrCycle := CurrCycleL;
        ID1 := ID1L;
        ID2 := ID2L;
        ID3 := ID3L;
        ID4 := ID4L;
    end;


    procedure GetData(var SerialNoL: Code[20]; var CurrCycleL: Code[20]; var NewCycleL: Code[20])
    begin
        SerialNoL := SerialNo;
        CurrCycleL := CurrCycle;
        NewCycleL := NewCycle;
    end;
}

