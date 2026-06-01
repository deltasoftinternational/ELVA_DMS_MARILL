Codeunit 25006875 "Booking Management"
{

    trigger OnRun()
    begin
    end;

    var
        LocationCode: Code[20];


    procedure GetDefaultLocationCode(): Code[20]
    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        UserProfile: Record "Branch Profile Setup";
        ServiceLocation: Code[20];
        UserProfileMgt: Codeunit UserProfileManagement;
    begin
        ServiceSetup.Get;
        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
            if UserProfile.Get(UserProfile."Spec. Servic Branch Profile", UserProfile."Spec. Branch Code") then begin
                ServiceLocation := UserProfile."Def. Service Location Code";
                if ServiceLocation = '' then
                    ServiceLocation := ServiceSetup."Def. Service Location Code";
            end else begin
                ServiceLocation := UserProfile."Def. Service Location Code";
                if ServiceLocation = '' then
                    ServiceLocation := ServiceSetup."Def. Service Location Code";
            end;
        end else
            ServiceLocation := ServiceSetup."Def. Service Location Code";
        exit(ServiceLocation);
    end;


    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;
}

