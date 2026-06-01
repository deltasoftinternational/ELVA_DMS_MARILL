Table 25006876 "Branch Profile Setup"
{
    // 07.05.2014 Elva Baltic P8 #xxx MMG7.00
    //   * Relate with Profile table
    // 
    // 19.03.2014 Elva Baltic P18
    //   Increased length of field "Default Location Filter" 20->100
    // 
    // 18.03.2014 Elva baltic P8 #E0008 MMG7.00
    //   * Add lookup to F530
    // 
    // 17.10.2007. EDMS P2
    //   * Added field "Don't Show Accounting Groups"

    Caption = 'Branch Profile Setup';
    LookupPageID = "Branch Profile Setup";

    fields
    {
        field(5; "Branch Code"; Code[30])
        {
            TableRelation = Branch;
        }
        field(10; "Profile ID"; Code[30])
        {
            Caption = 'Profile ID';
            //TableRelation = Profile;
        }
        field(20; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(30; "Default Deal Type Code"; Code[10])
        {
            Caption = 'Default Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(40; "Default Make Code"; Code[20])
        {
            Caption = 'Default Make Code';
            TableRelation = Make;
        }
        field(50; "Default Location Code"; Code[10])
        {
            Caption = 'Default Location Code';
            TableRelation = Location;
        }
        field(100; "Def. Service Location Code"; Code[20])
        {
            Caption = 'Def. Service Location Code';
            TableRelation = Location;
        }
        field(120; "Def. Spare Part Location Code"; Code[20])
        {
            Caption = 'Def. Spare Part Location Code';
            TableRelation = Location;
        }
        field(160; "Default Location Filter"; Code[100])
        {
            Caption = 'Default Location Filter';
            TableRelation = Location;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(161; "Default Req. Location Filter"; Code[100])
        {
            Caption = 'Default Requisition Location Filter';
            TableRelation = Location;
            ValidateTableRelation = false;
        }
        field(170; "Default Vendor No."; Code[20])
        {
            Caption = 'Default Vendor No.';
            TableRelation = Vendor;
        }
        field(180; "Default Vehicle Status"; Code[20])
        {
            Caption = 'Default Vehicle Status';
            TableRelation = "Vehicle Status".Code;
        }
        field(200; "Don't Use Vehicle Assembly"; Boolean)
        {
            Caption = 'Don''t Use Vehicle Assembly ';
        }
        field(250; "Show Vehicle Count"; Boolean)
        {
            Caption = 'Show Vehicle Count';
        }
        field(260; "Make Code Filter"; Text[50])
        {
            Caption = 'Make Code Filter';
        }
        field(270; "Default Payment Method"; Code[10])
        {
            Caption = 'Default Payment Method';
            TableRelation = "Payment Method";
        }
        field(280; "Default Shipping Agent Code"; Code[10])
        {
            Caption = 'Default Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(300; "Sales Line Markup Check"; Option)
        {
            Caption = 'Sales Line Markup Check';
            Description = 'Need to delete';
            OptionCaption = 'None,Message,Warning';
            OptionMembers = "None",Message,Warning;
        }
        field(310; "Sales Line Min Markup %"; Decimal)
        {
            Caption = 'Sales Line Min Markup %';
            Description = 'Need to delete';
        }
        field(400; "Spec. Service Setup"; Boolean)
        {
            Caption = 'Spec. Service Setup';
            Description = 'Service for Veh. Trade';
        }
        field(410; "Spec. Servic Branch Profile"; Code[30])
        {
            Caption = 'Spec. Branch Profile';
            Description = 'Service for Veh. Trade';
            TableRelation = "Branch Profile Setup"."Profile ID" where("Branch Code" = field("Spec. Branch Code"));
        }
        field(415; "Spec. Branch Code"; Code[30])
        {
            Description = 'Service for Veh. Trade';
            TableRelation = Branch;
        }
        field(420; "Spec. Order Receiver"; Code[20])
        {
            Caption = 'Spec. Order Receiver';
            Description = 'Service for Veh. Trade';
            TableRelation = "Salesperson/Purchaser";
        }
        field(510; "Vehicle Sales Disc. Check"; Boolean)
        {
            Caption = 'Vehicle Sales Disc. Check';
        }
        field(520; "Vehicle Max Sales Disc.%"; Decimal)
        {
            Caption = 'Vehicle Max Sales Disc.%';
        }
        field(530; "Service Schedule View Code"; Code[10])
        {
            Caption = 'Service Schedule View Code';
            TableRelation = "Schedule View";
        }
        field(50020; "New Vehicle Stat. After Sale"; Code[20])
        {
            Caption = 'New Vehicle Status After Sale';
            TableRelation = "Vehicle Status";
        }
        field(25006950; "Default TCard Container No."; Integer)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            TableRelation = "TCard Container"."No." where("Location Code" = field("Def. Service Location Code"));

            trigger OnValidate()
            var
                TCardContainer: Record "TCard Container";
            begin
            end;
        }
        field(25006960; "Service Location Filter"; Code[100])
        {
            Caption = 'Service Location Filter';
            DataClassification = ToBeClassified;
            TableRelation = Location;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(25006965; "Purchase Location Filter"; Code[100])
        {
            Caption = 'Purchase Location Filter';
            DataClassification = ToBeClassified;
            TableRelation = Location;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "Profile ID", "Branch Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserProfileMgt: Codeunit UserProfileManagement;


    procedure fIsCurrentWorkplace(recWorkplace: Record "Branch Profile Setup"): Boolean
    begin
        if UserProfileMgt.CurrProfileID = recWorkplace."Profile ID" then
            exit(true)
        else
            exit(false);
    end;
}

