tableextension 25006146 "Transfer Route" extends "Transfer Route" //5742
{
    // 29.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Added fields:
    //     "Default Vehicle Status-to"
    //   New GetVehicleStatusCode
    fields
    {
        field(25006000; "Default Vehicle Status-to"; Code[20])
        {
            Caption = 'Default Vehicle Status-to';
            TableRelation = "Vehicle Status".Code;
        }

    }
    procedure GetVehicleStatusCode(TransferFromCode: Code[10]; TransferToCode: Code[10]) RetValue: Code[20]
    begin
        if Get(TransferFromCode, TransferToCode) then
            RetValue := "Default Vehicle Status-to";
        exit(RetValue);
    end;

}