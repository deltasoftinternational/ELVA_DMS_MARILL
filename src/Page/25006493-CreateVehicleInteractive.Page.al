Page 25006493 "Create Vehicle-Interactive"
{
    Caption = 'Create Vehicle-Interactive';
    PageType = Card;

    layout
    {
        area(content)
        {
            field(MakeCode; MakeCode)
            {
                ApplicationArea = Basic;
                Caption = 'Make Code';
                Editable = false;
            }
            field(ModelCode; ModelCode)
            {
                ApplicationArea = Basic;
                Caption = 'Model Code';
                Editable = false;
            }
            field(ModelVersionNo; ModelVersionNo)
            {
                ApplicationArea = Basic;
                Caption = 'Model Version No.';
                Editable = false;
            }
            field(SerialNo; SerialNo)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Serial No.';
                Editable = false;
            }
            field(NewVIN; NewVIN)
            {
                ApplicationArea = Basic;
                Caption = 'VIN';
            }
        }
    }

    actions
    {
    }

    var
        NewVIN: Code[20];
        MakeCode: Code[20];
        ModelCode: Code[20];
        ModelVersionNo: Code[20];
        SerialNo: Code[20];
        BodyColorCode: Code[10];
        InteriorCode: Code[10];


    procedure fGetNewVin(): Code[20]
    begin
        exit(NewVIN);
    end;


    procedure fSetData(MakeCode1: Code[20]; ModelCode1: Code[20]; ModelVersionNo1: Code[20]; SerialNo1: Code[20]; BodyColorCode1: Code[10]; InteriorCode1: Code[10])
    begin
        MakeCode := MakeCode1;
        ModelCode := ModelCode1;
        ModelVersionNo := ModelVersionNo1;
        SerialNo := SerialNo1;
        BodyColorCode := BodyColorCode1;
        InteriorCode := InteriorCode1;
    end;
}

