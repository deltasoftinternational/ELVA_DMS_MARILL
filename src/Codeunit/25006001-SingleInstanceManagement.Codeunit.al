Codeunit 25006001 "SingleInstanceManagement"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified SetUserProfile, removed User Profile Setup variable
    // 
    // 12.06.2015 EB.P7 #Scheduler 3.0
    //   CurrentUserID global variable added
    //   Functions SetCurrentUserId, GetCurrentUserId,
    //     SetCurrentPeriod,GetCurrentPeriod, SetCurrentDate, GetCurrentDate added
    // 
    // 06.05.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Changes in SetUserProfile

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        bDocItemStatFrmOpen: Boolean;
        codDocItemStatItemNo: Code[20];
        UserProfileID: Code[30];
        CurrentUserID: Code[50];
        CurrentPeriod: Option "None",Day,Week;
        CurrentDate: Date;
        OwnOptionTemp: Record "Own Option" temporary;
        ManufacturerOptionTemp: Record "Manufacturer Option" temporary;
        ServiceHeaderTemp: Record "Service Header EDMS" temporary;
        GlobalEntryNo: Integer;
        DateFilter: Date;
        LineResources: Text[250];
        MustQuestForProfile: Boolean;
        UserProfileMgt: Codeunit UserProfileManagement;
        PageHasToRefresh: Boolean;
        TimeJournalFlag: Boolean;


    procedure SetDocItemStatFrmOpen(bNewValue: Boolean)
    begin
        bDocItemStatFrmOpen := bNewValue;
    end;


    procedure GetDoctItemStatFrmOpen(): Boolean
    begin
        exit(bDocItemStatFrmOpen);
    end;


    procedure SetUserProfile(NewValue: Code[30]; RunModeFlags: Integer)
    var
        User: Record User;
        UserSetup: Record "User Setup";
        UserPersonalization: Record "User Personalization";
        StatusArray: array[10] of Integer;
    begin
        // RunModeFlags = 11, what statuses are taken in account readen from right to left (store value to UserSetup, store value to UserPersonalization)
        AdjustFlagsToArray(RunModeFlags, StatusArray);
        UserProfileID := NewValue;
        //06.05.2014 Elva Baltic P8 #F037 MMG7.00 >>
        if IsIntInArrayTen(0, StatusArray) then
            if UserSetup.Get(UserId) then
                if UserSetup."Profile ID" = '' then begin
                    UserSetup."Profile ID" := UserProfileID;
                    UserSetup.Modify;
                end;
        if IsIntInArrayTen(1, StatusArray) then begin
            User.Reset;
            User.SetRange("User Name", UpperCase(UserId));
            if User.FindFirst then
                if UserPersonalization.Get(User."User Security ID") then
                    if UserPersonalization."Profile ID" = '' then begin
                        UserPersonalization."Profile ID" := UserProfileID;
                        UserPersonalization.Modify;
                    end;
        end;
        //06.05.2014 Elva Baltic P8 #F037 MMG7.00 <<
    end;


    procedure GetUserProfile(): Code[30]
    begin
        exit(UserProfileMgt.CurrProfileID());
    end;


    procedure SetDocItemStatItemNo(bNewValue: Code[20])
    begin
        codDocItemStatItemNo := bNewValue;
    end;


    procedure GetDoctItemStatItemNo(): Code[20]
    begin
        exit(codDocItemStatItemNo);
    end;


    procedure SetOwnOption(var OwnOption1: Record "Own Option")
    begin
        OwnOptionTemp.Reset;
        OwnOptionTemp.DeleteAll;
        if OwnOption1.FindFirst then
            repeat
                OwnOptionTemp := OwnOption1;
                OwnOptionTemp.Insert
            until OwnOption1.Next = 0;
    end;


    procedure GetOwnOption(var OwnOption: Record "Own Option")
    begin
        if OwnOptionTemp.FindFirst then
            repeat
                OwnOption := OwnOptionTemp;
                OwnOption.Insert
            until OwnOptionTemp.Next = 0;
    end;


    procedure SetManufacturerOption(var ManufacturerOption1: Record "Manufacturer Option")
    begin
        ManufacturerOptionTemp.Reset;
        ManufacturerOptionTemp.DeleteAll;
        if ManufacturerOption1.FindFirst then
            repeat
                ManufacturerOptionTemp := ManufacturerOption1;
                ManufacturerOptionTemp.Insert;
            until ManufacturerOption1.Next = 0;
    end;


    procedure GetManufacturerOption(var ManufacturerOption: Record "Manufacturer Option")
    begin
        if ManufacturerOptionTemp.FindFirst then
            repeat
                ManufacturerOption := ManufacturerOptionTemp;
                ManufacturerOption.Insert;
            until ManufacturerOptionTemp.Next = 0;
    end;


    procedure SetCurrAllocation(EntryNo: Integer)
    begin
        GlobalEntryNo := EntryNo;
    end;


    procedure ClearCurrAllocation()
    begin
        GlobalEntryNo := 0;
    end;


    procedure GetAllocationEntryNo(): Integer
    begin
        exit(GlobalEntryNo);
    end;


    procedure SetDateFilter(DateFilter1: Date)
    begin
        DateFilter := DateFilter1;
    end;


    procedure GetDateFilter(): Date
    begin
        exit(DateFilter)
    end;


    procedure SetServiceHeader(var ServiceHeader1: Record "Service Header EDMS")
    begin
        ServiceHeaderTemp.Reset;
        ServiceHeaderTemp.DeleteAll;
        ServiceHeaderTemp := ServiceHeader1;
        ServiceHeaderTemp.Insert;
    end;


    procedure GetServiceHeader(var ServiceHeader: Record "Service Header EDMS"): Boolean
    var
        FindRec: Boolean;
    begin
        FindRec := false;
        if ServiceHeaderTemp.FindFirst then
            if ServiceHeader.Get(ServiceHeaderTemp."Document Type", ServiceHeaderTemp."No.") then
                FindRec := true;
        exit(FindRec)
    end;


    procedure SetLineResources(LineResourcesPar: Text[250])
    begin
        LineResources := LineResourcesPar;
    end;


    procedure GetLineResources(): Text[250]
    begin
        exit(LineResources);
    end;


    procedure SetMustQuestForProfile(Value: Boolean)
    begin
        MustQuestForProfile := Value;
    end;


    procedure GetMustQuestForProfile(): Boolean
    begin
        exit(MustQuestForProfile);
    end;


    procedure SetCurrentUserId(UserIdToSet: Code[50])
    begin
        CurrentUserID := UserIdToSet;
    end;


    procedure GetCurrentUserId(): Code[50]
    begin
        if CurrentUserID = '' then
            SetCurrentUserId(UserId);
        exit(CurrentUserID);
    end;


    procedure SetCurrentPeriod(Period: Option "None",Day,Week)
    begin
        CurrentPeriod := Period;
    end;


    procedure GetCurrentPeriod(): Integer
    begin
        exit(CurrentPeriod);
    end;


    procedure SetCurrentDate(CurrDate: Date)
    begin
        CurrentDate := CurrDate;
    end;


    procedure GetCurrentDate(): Date
    begin
        if CurrentDate = 0D then
            SetCurrentDate(WorkDate);
        exit(CurrentDate);
    end;


    procedure SetPageHasToRefresh(HasToRefresh: Boolean)
    begin
        PageHasToRefresh := HasToRefresh;
    end;


    procedure GetPageHasToRefresh(): Boolean
    begin
        exit(PageHasToRefresh);
    end;


    procedure SetTimeJournalFlag(TimeJournalFlagToSet: Boolean)
    begin
        TimeJournalFlag := TimeJournalFlagToSet;
    end;


    procedure GetTimeJournalFlag(): Boolean
    begin
        exit(TimeJournalFlag);
    end;


    procedure "--SMALL TECHN--"()
    begin
    end;


    procedure CutNextDigit(var Flags: Integer) RetValue: Integer
    begin
        RetValue := Flags MOD 10;
        Flags := Flags DIV 10;
        exit(RetValue);
    end;


    procedure AdjustFlagsToArray(Flags: Integer; var ArrayDMS: array[10] of Integer)
    var
        i: Integer;
    begin
        for i := 1 to 10 do begin
            if (CutNextDigit(Flags) > 0) then
                ArrayDMS[i] := i - 1
            else
                ArrayDMS[i] := -1;
        end;
    end;


    procedure IsIntInArrayTen(CheckValue: Integer; var ArrayDMS: array[10] of Integer) RetValue: Boolean
    var
        i: Integer;
    begin
        for i := 1 to 10 do begin
            if (CheckValue = ArrayDMS[i]) then
                RetValue := true;
        end;

        exit(RetValue);
    end;
}

