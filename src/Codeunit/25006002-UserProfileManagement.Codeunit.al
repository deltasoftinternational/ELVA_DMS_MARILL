Codeunit 25006002 "UserProfileManagement"
{
    // 07.05.2014 Elva Baltic P8 #xxx MMG7.00
    //   * Correct use of UserSetup."Profile ID"


    trigger OnRun()
    begin
    end;

    var
        SingleInstanceMgt: Codeunit SingleInstanceManagement;

        Text000: Label 'The user name %1 does not exist.';
        Text001: Label 'You are renaming an existing user. This will also update all related records. Are you sure that you want to rename the user?';
        Text002: Label 'The account %1 already exists.';
        UserLocation: Code[10];
        ServUserRespCenter: Code[10];
        UserRespCenter: Code[10];
        UserSetup: Record "User Setup";
        CompanyInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";

        EDMSText000: Label 'customer';
        EDMSText001: Label 'vendor';
        EDMSText002: Label 'This %1 is related to %2 %3. Your identification is setup to process from %2 %4.';
        EDMSText003: Label 'This document will be processed in your %2.';



    procedure CurrProfileID() RetValue: Code[30]
    var
        UserPersonalization: Record "User Personalization";
        //SIDConversion: Record "SID - Account ID";
        User: Record User;
        UserSetup: Record "User Setup";
    begin
        User.Reset;
        User.SetRange("User Name", UpperCase(UserId));
        if User.FindFirst then begin
            UserPersonalization.Reset;
            UserPersonalization.SetRange("User SID", User."User Security ID"); //30.10.2012 EDMS
            UserPersonalization.FindFirst;
            exit(UserPersonalization."Profile ID");
        end else
            exit(GetDefaultUserProfile);
    end;


    procedure CurrBranchNo() RetValue: Code[30]
    var
        UserSetup: Record "User Setup";
        User: Record User;
    begin
        User.Reset;
        User.SetRange("User Name", UpperCase(UserId));
        if User.FindFirst then begin
            if UserSetup.Get(UserId) then
                exit(UserSetup."Branch Code");
        end;
    end;


    procedure InitUserProfileSetup("Profile": Record "All Profile")
    var
        BranchProfileSetup: Record "Branch Profile Setup";
    begin
        BranchProfileSetup.Reset;
        if not BranchProfileSetup.Get(Profile."Profile ID") then begin
            BranchProfileSetup.Init;
            BranchProfileSetup."Profile ID" := Profile."Profile ID";
            BranchProfileSetup.Description := Profile.Description;
            BranchProfileSetup.Insert(true);
        end;
        Commit;
    end;

    local procedure GetDefaultUserProfile(): Code[30]
    var
        "Profile": Record "all Profile";
    begin
        Profile.SetRange("Default Role Center", true);
        if Profile.FindFirst then
            exit(Profile."Profile ID");
    end;


    procedure GetUserFullName(UserID: Code[50]): Text[80]
    var
        Users: Record User;
    begin
        Users.SetRange(Users."User Name", UserID);
        if Users.FindFirst then
            exit(Users."Full Name");
    end;

    procedure LookupUserID(VAR UserName: Code[50]): Boolean
    var
        SID: GUID;
    begin
        exit(LookupUser(UserName, SID));
    end;


    procedure LookupUser(VAR UserName: Code[50]; VAR SID: GUID): Boolean
    var
        User: Record User;
    begin
        User.RESET;
        User.SETCURRENTKEY("User Name");
        User."User Name" := UserName;
        IF User.FIND('=><') THEN;
        IF PAGE.RUNMODAL(PAGE::Users, User) = ACTION::LookupOK THEN BEGIN
            UserName := User."User Name";
            SID := User."User Security ID";
            EXIT(TRUE);
        END;

        exit(FALSE);
    end;

    procedure ValidateUserID(UserName: Code[50])
    var
        User: Record User;
    begin
        IF UserName <> '' THEN BEGIN
            User.SETCURRENTKEY("User Name");
            User.SETRANGE("User Name", UserName);
            IF NOT User.FINDFIRST THEN BEGIN
                User.RESET;
                IF NOT User.ISEMPTY THEN
                    ERROR(Text000, UserName);
            END;
        END;
    end;


    //>> ----ADDED FOR CU 5700 ---------<<

    procedure GetServiceFilterEDMS(): Code[10]
    begin
        exit(GetServiceFilter2EDMS(UserId));
    end;

    procedure GetServiceFilter2EDMS(UserCode: Code[50]): Code[10]
    begin

        CompanyInfo.Get;
        ServUserRespCenter := CompanyInfo."Responsibility Center";
        UserLocation := CompanyInfo."Location Code";
        if (UserSetup.Get(UserCode)) and (UserCode <> '') then
            if UserSetup."Service Resp. Ctr. Filter EDMS" <> '' then
                ServUserRespCenter := UserSetup."Service Resp. Ctr. Filter EDMS";

        exit(ServUserRespCenter);
    end;


    procedure GetRespCenterEDMS(AccRespCenter: Code[10]): Code[10]
    var
        AccType: Text[50];
        IsHandled: Boolean;
    begin

        AccType := EDMSText000;
        UserRespCenter := GetServiceFilterEDMS;

        if (AccRespCenter <> '') and
           (UserRespCenter <> '') and
           (AccRespCenter <> UserRespCenter)
        then
            Message(
              EDMSText002 +
              EDMSText003,
              AccType, RespCenter.TableCaption, AccRespCenter, UserRespCenter);
        if UserRespCenter = '' then
            exit(AccRespCenter);

        exit(UserRespCenter);
    end;


    procedure CheckRespCenterEDMS(AccRespCenter: Code[10]): Boolean
    begin
        exit(CheckRespCenterEDMS(AccRespCenter, UserId));
    end;

    procedure CheckRespCenterEDMS(AccRespCenter: Code[10]; UserCode: Code[50]): Boolean
    var
        IsHandled: Boolean;
        Result: Boolean;
    begin
        UserRespCenter := GetServiceFilter2EDMS(UserCode);

        if (UserRespCenter <> '') and
           (AccRespCenter <> UserRespCenter)
        then
            exit(false);
        exit(true);
    end;

    procedure GetLocationEDMS(AccLocation: Code[10]; RespCenterCode: Code[10]) LocationCode: Code[10]
    var

    begin
        UserRespCenter := GetServiceFilterEDMS;

        if UserRespCenter <> '' then
            RespCenterCode := UserRespCenter;
        if RespCenter.Get(RespCenterCode) then
            if RespCenter."Location Code" <> '' then
                UserLocation := RespCenter."Location Code";
        if AccLocation <> '' then
            exit(AccLocation);

        exit(UserLocation);
    end;


    procedure PopulateProfiles(var TempAllProfile: Record "All Profile" temporary)
    var
        AllProfile: Record "All Profile";
        DescriptionFilterTxt: Label 'Navigation menu only.';
        UserCreatedAppNameTxt: Label '(User-created)';
    begin
        TempAllProfile.Reset();
        TempAllProfile.DeleteAll();
        AllProfile.SetRange(Enabled, true);
        AllProfile.SetFilter(Description, '<> %1', DescriptionFilterTxt);
        if AllProfile.FindSet() then
            repeat
                TempAllProfile := AllProfile;
                if IsNullGuid(TempAllProfile."App ID") then
                    TempAllProfile."App Name" := UserCreatedAppNameTxt;
                TempAllProfile.Insert();
            until AllProfile.Next() = 0;
    end;

}

