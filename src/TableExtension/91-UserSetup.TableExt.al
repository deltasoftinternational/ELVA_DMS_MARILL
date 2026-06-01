tableextension 25006016 "User Setup" extends "User Setup" //91
{
    // 29.08.2018 EB.P7
    //   Added field:
    //     "Ask Work Finished"
    // 
    // 02.05.2017 EB.P7 Sign
    //   Added field:
    //     "Signed Document Path"
    // 
    // 14.04.2016 EB.P30
    //   Added field: Register Statistics
    // 
    // 15.03.2016 EB.P7 Branches
    //   Added field: Branch Code
    // 
    // 08.06.2015 EB.P7 #Schedule3.0
    //   Added field: Resource No.
    // 
    // 16.02.2015 EB.P7 #SingleInst.
    //   Disabled Profile ID field trigger.
    // 
    // 07.05.2014 Elva Baltic P8 #xxx MMG7.00
    //   * Change field name 'Default User Profile Code' into 'Profile ID' and relate with Profile table instead of T25006067.
    // 
    // 30.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Set default profile should go to system vars
    // 
    // 21.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "Allow Cancel Service Reserv."
    //     "Allow Block Customer"
    // 
    // 16.04.2013 EDMS P8
    //   * removed unused fields 'Allow Posting Transfer' and 'Allow Posting Credit Memo'
    // 
    // 05.12.2011 EDMS P8
    //   * Added fields:
    //       Veh. Sales Amount Appr. Limit
    //       Spare Parts Sales Appr. Limit
    //       Veh. Service Approval Limit
    //       Unlimited Veh. Sales Approval
    //       Unlimited Spare Parts Sales
    //       Unlimited Veh. Service Appr.
    // 
    // 15.06.2007. EDMS P2
    //   * Added new key Salesperson/Purch.Code
    fields
    {
        field(25006000; "Profile ID"; Code[30])
        {
            Caption = 'Company Profile ID';
            TableRelation = "all Profile";
        }
        field(25006010; "SP Sales Disc. Group Code"; Code[10])
        {
            Caption = 'SP Sales Disc. Group Code';
            TableRelation = "Spare Part Sales Disc. Group";
        }
        field(25006020; "Service Resp. Ctr. Filter EDMS"; Code[10])
        {
            Caption = 'Service Resp. Ctr. Filter EDMS';
            TableRelation = "Responsibility Center";
        }
        field(25006060; "Allow Posting Only Today"; Boolean)
        {
            Caption = 'Allow Posting Only Today';
        }
        field(25006080; "Allow Return Not Only Today"; Boolean)
        {
            Caption = 'Allow Return Not Only Today';
        }
        field(25006090; "Starting Form ID"; Integer)
        {
            Caption = 'Starting Form ID';
        }
        field(25006100; "Schedule Add-In Log Path"; Text[250])
        {
            Caption = 'Schedule Add-In Log Path';
        }
        field(25006110; "Schedule Add-In Log Active"; Boolean)
        {
            Caption = 'Schedule Add-In Log Active';
        }
        field(25006580; "Item Markup Restriction Group"; Code[20])
        {
            Caption = 'Item Markup Restriction Group';
            TableRelation = "Item Markup Restriction Group";
        }
        field(25006585; "Veh. Acc. Cycle Change Funct."; Boolean)
        {
            Caption = 'Veh. Acc. Cycle Change Funct.';
        }
        field(25006595; "Allow Use Service Schedule"; Option)
        {
            Caption = 'Allow Use Service Schedule';
            OptionCaption = ' ,View Only,Time Registration,Planning,All ';
            OptionMembers = " ","View Only","Time Registration",Planning,"All ";
        }
        field(25006625; "Cancel Only Own Reservation"; Boolean)
        {
            Caption = 'Cancel Only Own Reservation';
        }
        field(25006635; "SIE management"; Boolean)
        {
            Caption = 'SIE management';
        }
        field(25006700; "Cust. Credit Control"; Boolean)
        {
            Caption = 'Cust. Credit Control';
        }
        field(25006712; "Veh. Service Approval Limit"; Integer)
        {
            BlankZero = true;
            Caption = 'Veh. Service Approval Limit';

            trigger OnValidate()
            begin
                if "Unlimited Veh. Service Appr." and ("Veh. Service Approval Limit" <> 0) then
                    Error(Text003, FieldCaption("Veh. Service Approval Limit"), FieldCaption("Unlimited Veh. Service Appr."));
                if "Veh. Service Approval Limit" < 0 then
                    Error(Text005);
            end;
        }
        field(25006713; "Unlimited Veh. Sales Approval"; Boolean)
        {
            Caption = 'Unlimited Veh. Sales Approval';

            trigger OnValidate()
            begin
                if "Unlimited Veh. Sales Approval" then
                    "Veh. Sales Amount Appr. Limit" := 0;
            end;
        }
        field(25006714; "Unlimited Spare Parts Sales"; Boolean)
        {
            Caption = 'Unlimited Spare Parts Sales';

            trigger OnValidate()
            begin
                if "Unlimited Spare Parts Sales" then
                    "Spare Parts Sales Appr. Limit" := 0;
            end;
        }
        field(25006715; "Unlimited Veh. Service Appr."; Boolean)
        {
            Caption = 'Unlimited Veh. Service Appr.';

            trigger OnValidate()
            begin
                if "Unlimited Veh. Service Appr." then
                    "Veh. Service Approval Limit" := 0;
            end;
        }
        field(25006716; "Veh. Purch. Amount Appr. Limit"; Integer)
        {
            BlankZero = true;
            Caption = 'Veh. Purch. Amount Appr. Limit';

            trigger OnValidate()
            begin
                if "Unlimited Veh. Purch. Approval" and ("Veh. Purch. Amount Appr. Limit" <> 0) then
                    Error(Text003, FieldCaption("Veh. Purch. Amount Appr. Limit"), FieldCaption("Unlimited Veh. Purch. Approval"));
                if "Veh. Purch. Amount Appr. Limit" < 0 then
                    Error(Text005);
            end;
        }
        field(25006717; "Spare Parts Purch. Appr. Limit"; Integer)
        {
            BlankZero = true;
            Caption = 'Spare Parts Purch. Appr. Limit';

            trigger OnValidate()
            begin
                if "Unlimited Spare Parts Purch." and ("Spare Parts Purch. Appr. Limit" <> 0) then
                    Error(Text003, FieldCaption("Spare Parts Purch. Appr. Limit"), FieldCaption("Unlimited Spare Parts Purch."));
                if "Spare Parts Purch. Appr. Limit" < 0 then
                    Error(Text005);
            end;
        }
        field(25006718; "Unlimited Veh. Purch. Approval"; Boolean)
        {
            Caption = 'Unlimited Veh. Purch. Approval';

            trigger OnValidate()
            begin
                if "Unlimited Veh. Purch. Approval" then
                    "Veh. Purch. Amount Appr. Limit" := 0;
            end;
        }
        field(25006719; "Unlimited Spare Parts Purch."; Boolean)
        {
            Caption = 'Unlimited Spare Parts Purch.';

            trigger OnValidate()
            begin
                if "Unlimited Spare Parts Purch." then
                    "Spare Parts Purch. Appr. Limit" := 0;
            end;
        }
        field(25006720; "Veh. Sales Amount Appr. Limit"; Integer)
        {
            Caption = 'Veh. Sales Amount Appr. Limit';

            trigger OnValidate()
            begin
                if "Unlimited Veh. Sales Approval" and ("Veh. Sales Amount Appr. Limit" <> 0) then
                    Error(Text003, FieldCaption("Veh. Sales Amount Appr. Limit"), FieldCaption("Unlimited Veh. Sales Approval"));
                if "Veh. Sales Amount Appr. Limit" < 0 then
                    Error(Text005);
            end;
        }
        field(25006721; "Spare Parts Sales Appr. Limit"; Integer)
        {
            Caption = 'Spare Parts Sales Appr. Limit';

            trigger OnValidate()
            begin
                if "Unlimited Spare Parts Sales" and ("Spare Parts Sales Appr. Limit" <> 0) then
                    Error(Text003, FieldCaption("Spare Parts Sales Appr. Limit"), FieldCaption("Unlimited Spare Parts Sales"));
                if "Spare Parts Sales Appr. Limit" < 0 then
                    Error(Text005);
            end;
        }
        field(25006730; "Allow Block Customer"; Boolean)
        {
            Caption = 'Allow Block Customer';
        }
        field(25006740; "Allow Cancel Service Reserv."; Boolean)
        {
            Caption = 'Allow Cancel Service Reserv.';
        }
        field(25006750; "Resource No."; Code[20])
        {
            TableRelation = Resource;
        }
        field(25006760; "Branch Code"; Code[20])
        {
            TableRelation = Branch;
        }
        field(25006770; "Register Statistics"; Boolean)
        {
            Caption = 'Register Statistics';
        }
        field(25006780; "Signed Document Path"; Text[250])
        {
            Caption = 'Signed Document Path';
        }
        field(25009611; "Ask Work Finished"; Boolean)
        {
            Caption = 'Ask If All Work Finished';
            DataClassification = ToBeClassified;
        }

        field(25006790; "SP Doc. Profile Enabled"; Boolean)
        {
            Caption = 'Spare Part Document Profile Enabled';
        }

        field(25006791; "Veh. Doc. Profile Enabled"; Boolean)
        {
            Caption = 'Vehicle Document Profile Enabled';
        }

        field(25006792; "Serv. Doc. Profile Enabled"; Boolean)
        {
            Caption = 'Service Document Profile Enabled';
        }

        field(25006793; "Rent Doc. Profile Enabled"; Boolean)
        {
            Caption = 'Rent Document Profile Enabled';
        }

        field(25006794; "Empty Doc. Profile Enabled"; Boolean)
        {
            Caption = 'Empty Document Profile Enabled';
        }

        field(25006795; "Default Doc. Profile"; Option)
        {
            Caption = 'Default Doc. Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service,Rent';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service,Rent;

        }


    }

    var
        Text001: Label 'The %1 Salesperson/Purchaser code is already assigned to another User ID %2.';
        Text003: Label 'You cannot have both a %1 and %2. ';
        Text005: Label 'You cannot have approval limits less than zero.';

}