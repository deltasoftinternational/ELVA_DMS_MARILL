pageextension 25006076 "Default Dimensions-Multiple" extends "Default Dimensions-Multiple"//542
{
    var
        TempDefaultDim2: Record "Default Dimension" temporary;


    procedure SetMultiBLSService(var Service: Record "BLS Service")
    begin
        TempDefaultDim2.DeleteAll;

        if Service.Find('-') then
            repeat
                CopyDefaultDimToDefaultDim(Database::"BLS Service", Service.Code);
            until Service.Next = 0;
    end;


    procedure SetMultiBLSObject(var BLSObject: Record "BLS Object")
    begin
        TempDefaultDim2.DeleteAll;

        if BLSObject.Find('-') then
            repeat
                CopyDefaultDimToDefaultDim(Database::"BLS Object", BLSObject.Code);
            until BLSObject.Next = 0;
    end;
}