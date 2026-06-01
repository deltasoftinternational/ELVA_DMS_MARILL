Table 25006019 "Vehicle Serial No. Buffer"
{
    Caption = 'Vehicle Serial No. Buffer';
    LookupPageID = "Vehicle Serial No. Buffer";

    fields
    {
        field(10; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
        }
        field(20; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(30; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(50; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(60; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        fAssignSerialNo
    end;


    procedure fAssignSerialNo()
    var
        cuNoSeriesMgt: Codeunit "No. Series";
        recPurchaseLine: Record "Purchase Line";
        codSerialNos: Code[20];
        codNewSerialNo: Code[20];
        tcDMS001: label '%1 is already assigned.';
    begin
        if "Serial No." <> '' then
            Error(tcDMS001, FieldCaption("Serial No."));

        codSerialNos := 'AUTOSN';
        codNewSerialNo := cuNoSeriesMgt.GetNextNo(codSerialNos, WorkDate(), true);
        if codNewSerialNo <> '' then begin
            Validate("Serial No.", codNewSerialNo);
        end;
    end;
}

