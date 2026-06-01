tableextension 25006027 "Purchase Header" extends "Purchase Header" //38
{
    // #Include EDMS.Integration
    // 
    // 27.01.2019 EBS.ASM EDMS.Integration
    //   Added field:
    //     25006770 "Document Vendor Status"
    // 
    // 08.05.2017 EB.P7
    //   Modified function fSetUserDefaultValues
    // 
    // 16.03 2016 EB.P7 Branch Setup
    //   Modified fSetUserDefaultValues(), Usert Profile Setup to Branch Profile Setup
    //   Modified GetDefaultVendor(), Usert Profile Setup to Branch Profile Setup
    // 
    // 12.06.2015 EB.P30 #T042
    //   Modified function:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Dela Type - OnValidate
    // 
    // 
    // 16.04.2015 EB.P7 #Merge
    //   CreateDimSetForPrepmtAccDefaultDim() Modified to Call CreateDim with suficient params.
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedure:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 09.06.2014 Elva Baltic P8 #F0001 EDMS7.10
    //   Added field:
    //     "Ordering Price Type Code"
    // 
    // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00
    //   Added Code To "Vehicle Serial No. - OnValidate()"
    // 
    // 25.10.2013 EDMS P8
    //   * Added use of Vehicle default dimension
    // 
    // 13.06.2007. EDMS P2
    fields
    {
        //DELTA BCH 29/11/2021
        field(58000; "Purchase Request"; Boolean)
        {
            Caption = 'Purchase Request';
        }
        //DELTA BCH 29/11/2021
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";

            trigger OnValidate()
            var
                tcDMS001: label 'Do you want to change lines too?';
                recPurchLine: Record "Purchase Line";
            begin
                //12.06.2015 EB.P30 #042 >>
                TestField(Status, Status::Open);

                recPurchLine.Reset;
                recPurchLine.SetRange("Document Type", "Document Type");
                recPurchLine.SetRange("Document No.", "No.");
                if recPurchLine.FindSet(true, false) then
                    if Confirm(tcDMS001) then
                        repeat
                            recPurchLine.Validate("Deal Type Code", "Deal Type Code");
                            recPurchLine.Modify;
                        until recPurchLine.Next = 0;

                CreateDimFromDefaultDim(Rec.FieldNo("Deal Type code"));
                //CreateDim(
                // Database::Vendor, "Pay-to Vendor No.",
                // Database::"Salesperson/Purchaser", "Purchaser Code",
                // Database::Campaign, "Campaign No.",
                // Database::"Responsibility Center", "Responsibility Center"

                //);
            end;
        }
        field(25006020; "Auto Created Doc"; Boolean)
        {
            Caption = 'Auto Created Document';
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
                if "Vehicle Registration No." = '' then begin
                    Validate("Vehicle Serial No.", '');
                    exit;
                end;

                Vehicle.Reset;
                Vehicle.SetCurrentkey("Registration No.");
                Vehicle.SetRange("Registration No.", "Vehicle Registration No.");
                if Vehicle.FindFirst then begin
                    if "Vehicle Serial No." <> Vehicle."Serial No." then
                        Validate("Vehicle Serial No.", Vehicle."Serial No.")
                end else
                    Message(StrSubstNo(Text100, "Vehicle Registration No."), '');
            end;
        }
        field(25006378; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Not for Vehicle Trade';

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
                if "Vehicle Serial No." = '' then begin
                    "Vehicle Registration No." := '';
                end else begin
                    if Vehicle.Get("Vehicle Serial No.") then
                        "Vehicle Registration No." := Vehicle."Registration No.";
                end;

                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 >>
                /*                CreateDim(
                                  Database::Vendor, "Pay-to Vendor No.",
                                  Database::"Salesperson/Purchaser", "Purchaser Code",
                                  Database::Campaign, "Campaign No.",
                                  Database::"Responsibility Center", "Responsibility Center");
                                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 <<*/
                CreateDimFromDefaultDim(Rec.FieldNo("Vehicle Serial No."));
            end;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Description = 'Only For Service or Spare Parts Trade';
            Editable = true;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006700; "Ordering Price Type Code"; Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006770; "Document Vendor Status"; Option)
        {
            Caption = 'Document Vendor Status';
            DataClassification = ToBeClassified;
            Description = 'EDMS.Integration';
            OptionCaption = ' ,Sent,Confirmed,Rejected';
            OptionMembers = " ",Sent,Confirmed,Rejected;
        }
        field(25006771; "DMS Integration Status"; Option)
        {
            Caption = 'DMS Integration Status';
            DataClassification = ToBeClassified;
            Description = 'EDMS.Integration';
            OptionCaption = ' ,Waiting,OK,Error,Action';
            OptionMembers = " ",Waiting,OK,Error,"Action";
        }

    }
    keys
    {
        key(Key10; "Document Profile")
        {
        }
    }
    var
        CheckDefaultVendor: Boolean;
        cuSingleInstanceMgt: Codeunit SingleInstanceManagement;
        tcDMS001: label 'Update lines too?';
        ErrVendNoIINPayer: label 'Vendor %1 is not %2. You mustn''t enter %3! ';
        ErrIINJustAmSign: label 'For credit memo IIN just. amount must be negative!';
        Text100: label 'There is no vehicle with Registration No. %1';

    procedure fSetUserDefaultValues()
    var
        recUserSetup: Record "User Setup";
        recWorkPlace: Record "Branch Profile Setup";
        UserProfileMgt: Codeunit UserProfileManagement;
    begin
        recUserSetup.Reset;
        if recUserSetup.Get(UserId) then begin
            if recUserSetup."Salespers./Purch. Code" <> '' then
                Validate("Purchaser Code", recUserSetup."Salespers./Purch. Code");
        end;
        if UserProfileMgt.CurrProfileID <> '' then begin
            if recWorkPlace.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
                if recWorkPlace."Default Location Code" <> '' then
                    Validate("Location Code", recWorkPlace."Default Location Code");
                if "Deal Type Code" = '' then
                    if recWorkPlace."Default Deal Type Code" <> '' then
                        Validate("Deal Type Code", recWorkPlace."Default Deal Type Code");
            end;
        end;
    end;


    procedure GetDefaultVendor()
    var
        recWorkPlace: Record "Branch Profile Setup";
        UserProfileMgt: Codeunit UserProfileManagement;
    begin
        if UserProfileMgt.CurrProfileID <> '' then begin
            if recWorkPlace.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
                if "Buy-from Vendor No." = '' then begin
                    if recWorkPlace."Default Vendor No." <> '' then
                        Validate("Buy-from Vendor No.", recWorkPlace."Default Vendor No.");
                end;
            end;
        end;
    end;

    procedure OnLookupVehicleRegistrationNo()
    var
        LookUpMgt: Codeunit LookUpManagement;
        Vehicle: Record Vehicle;
    begin
        if "Vehicle Registration No." <> '' then begin
            Vehicle.Reset;
            Vehicle.SetCurrentkey("Registration No.");
            Vehicle.SetRange("Registration No.", "Vehicle Registration No.");
            if Vehicle.FindFirst then;
            Vehicle.SetRange("Registration No.");
        end;

        if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then
            Validate("Vehicle Serial No.", Vehicle."Serial No.");
    end;

    procedure SetDefaultVendor()
    begin
        CheckDefaultVendor := true;
    end;

    procedure GetCheckDefaultVendor(): Boolean
    begin
        exit(CheckDefaultVendor);
    end;

}
