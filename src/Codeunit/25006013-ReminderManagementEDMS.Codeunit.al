Codeunit 25006013 "Reminder Management EDMS"
{

    trigger OnRun()
    var
        LicensePermission: Record "License Permission";
    begin
        if not UserSetup.Get(UserId) then exit;

        //Check for SIE
        /*
         if UserSetup."SIE management" then begin
           LicensePermission.SetRange("Object Type",LicensePermission."object type"::Codeunit);
           LicensePermission.SetRange("Object Number",Codeunit::"SIE Management");
           LicensePermission.SetFilter("Execute Permission",'<>%1',LicensePermission."execute permission"::" ");
           if not LicensePermission.IsEmpty then
             SIEMgt.CheckReminders
         end
         */
    end;

    var
        UserSetup: Record "User Setup";
    //SIEMgt: Codeunit "SIE Management";
}

