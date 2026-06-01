Table 25006600 "Rent Mgt. Setup"
{
    Caption = 'Rent Management Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
        }
        field(20; "Rent Item Nos."; Code[20])
        {
            Caption = 'Rent Item Nos.';
            TableRelation = "No. Series";
        }
        field(30; "Rent Package Nos."; Code[20])
        {
            Caption = 'Rent Package Nos.';
            TableRelation = "No. Series";
        }
        field(40; "Quote Nos."; Code[20])
        {
            Caption = 'Quote Nos.';
            TableRelation = "No. Series";
        }
        field(50; "Order Nos."; Code[20])
        {
            Caption = 'Order Nos.';
            TableRelation = "No. Series";
        }
        field(60; "Posted Order Nos."; Code[20])
        {
            Caption = 'Posted Order Nos.';
            TableRelation = "No. Series";
        }
        field(70; "Return Order Nos."; Code[20])
        {
            Caption = 'Return Order Nos.';
            TableRelation = "No. Series";
        }
        field(80; "Posted Return Order Nos."; Code[20])
        {
            Caption = 'Posted Return Order Nos.';
            TableRelation = "No. Series";
        }
        field(90; "Invoice Nos."; Code[20])
        {
            Caption = 'Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(100; "Credit Memo Nos."; Code[20])
        {
            Caption = 'Credit Memo Nos.';
            TableRelation = "No. Series";
        }
        field(110; "Posted Invoice Nos."; Code[20])
        {
            Caption = 'Posted Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(111; "Posted Credit Memo Nos."; Code[20])
        {
            Caption = 'Posted Credit Memo Nos.';
            TableRelation = "No. Series";
        }
        field(120; "Rent Shipment Nos."; Code[20])
        {
            Caption = 'Rent Shipment Nos.';
            TableRelation = "No. Series";
        }
        field(130; "Posted Rent Shpt. Nos."; Code[20])
        {
            Caption = 'Posted Rent Shipment Nos.';
            TableRelation = "No. Series";
        }
        field(140; "Default Cust. Location Code"; Code[20])
        {
            Caption = 'Default Cust. Location Code';
            TableRelation = Location;
        }
        field(150; "Advance Payment Resource Code"; Code[20])
        {
            Caption = 'Advance Payment Resource Code';
            TableRelation = Resource;
        }
        field(160; "Deposit Resource Code"; Code[20])
        {
            Caption = 'Deposit Resource Code';
            TableRelation = Resource;
        }
        field(170; "Credit Warnings"; Option)
        {
            Caption = 'Credit Warnings';
            OptionMembers = "Both Warnings","Credit Limit","Overdue Balance","No Warning";
        }
        field(180; "PstDoc. Num. equal Doc. Num."; Boolean)
        {
            Caption = 'Posted Document Numbers equal Doc. Num.';
        }
        field(190; "Availability Location Code"; Code[20])
        {
            Caption = 'Availability Location Code';
            TableRelation = Location;
        }
        field(200; "Default 4 Weeks Rent Period"; Code[20])
        {
            Caption = 'Default 4 Weeks Rent Period';
            TableRelation = "Rent Period".Code;
        }
        field(210; "Default Weekly Rent Period"; Code[20])
        {
            Caption = 'Default Weekly Rent Period';
            TableRelation = "Rent Period".Code;
        }
        field(220; "Default Daily Rent Period"; Code[20])
        {
            Caption = 'Default Daily Rent Period';
            TableRelation = "Rent Period".Code;
        }
        field(230; "Rent Asset Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(240; "Sales Inv. Line Decr. Text 1"; Text[50])
        {
            Caption = 'Sales Invoice Line Description Text 1';
            DataClassification = ToBeClassified;
        }
        field(241; "Sales Inv. Line Decr. Text 2"; Text[50])
        {
            Caption = 'Sales Invoice Line Description Text 2';
            DataClassification = ToBeClassified;
        }
        field(242; "Sales Inv. Line Decr. Text 3"; Text[50])
        {
            Caption = 'Sales Invoice Line Description Text 3';
            DataClassification = ToBeClassified;
        }
        field(243; "Variable Field Run 1"; Code[10])
        {
            CaptionClass = '7,25006600,243';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(244; "Variable Field Run 2"; Code[10])
        {
            CaptionClass = '7,25006600,244';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(245; "Variable Field Run 3"; Code[10])
        {
            CaptionClass = '7,25006600,245';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(246; "S. Inv. Line Extra Per. Descr."; Text[50])
        {
            Caption = 'Sales Invoice Line Extra Period Description';
            DataClassification = ToBeClassified;
        }
        field(247; "Overtime Calculation"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Total Period,Current Period';
            OptionMembers = " ","Total Period","Current Period";
        }
        field(248; "Invoice Only with Rent Asset"; Boolean)
        {
            Caption = 'Invoice Only with Rent Asset';
            DataClassification = ToBeClassified;
        }
        field(249; "Sales Inv. Line Decr. Text 4"; Text[50])
        {
            Caption = 'Sales Invoice Line Description Text 4';
            DataClassification = ToBeClassified;
        }
        field(250; "Rent Capacity Start Time"; Time)
        {
            Caption = 'Rent Capacity Start Time';
        }
        field(251; "Rent Capacity End Time"; Time)
        {
            Caption = 'Rent Capacity End Time';
        }
        field(252; "Default Capacity Period"; Option)
        {
            OptionMembers = Default,Day,WorkWeek,Month,Week;
            Caption = 'Default Capacity Period';
        }
        field(260; "Deal Type Mandatory"; Boolean)
        {
            Caption = 'Deal Type Mandatory';
        }
        field(270; "Rent Service Location Code"; Code[20])
        {
            Caption = 'Rent Service Location Code';
            TableRelation = Location;
        }
        field(280; "Default Rent Type"; Option)
        {
            Caption = 'Default Rent Type';
            OptionCaption = 'Set End Date,Open End Date';
            OptionMembers = "Set End Date","Open End Date";
        }
        field(25006310; "Check VF Run 1 on Release"; Boolean)
        {
            CaptionClass = '7,25006600,25006310';
        }
        field(25006311; "Check VF Run 2 on Release"; Boolean)
        {
            CaptionClass = '7,25006600,25006311';
        }
        field(25006312; "Check VF Run 3 on Release"; Boolean)
        {
            CaptionClass = '7,25006600,25006312';
        }
        field(25006313; "Auto Post Rent Invoices"; Boolean)
        {
            Caption = 'Automatically Post Rent Invoices';
        }
        field(25006314; "Rent Period Calc. Type"; Option)
        {
            Caption = 'Rent Period Calc. Type';
            OptionCaption = 'Standard Period,Calendar Period';
            OptionMembers = "Standard Period","Calendar Period";
        }
        field(25006315; "Veh.Cust.Change on RentTransf."; Boolean)
        {
            Caption = 'Vehicle Customer Change on Rent Transfer';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
    var
        VFMgt: Codeunit "Variable Field Management";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Mgt. Setup", intFieldNo));
    end;
}

