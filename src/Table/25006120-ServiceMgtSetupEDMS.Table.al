Table 25006120 "Service Mgt. Setup EDMS"
{
    // 10.10.2016 EB.P7 #WSH16
    //   Removed field"On Task Start" (moved to resource)
    // 
    // 04.04.2014 Elva Baltic P15 # MMG7.00
    //   * added field - "Def. Translation Language Code"
    // 
    // 2012.07.31 EDMS P8
    //   * Added fields: "Notify Before (VF Run 1)", Notify Before (VF Run 2), Notify Before (VF Run 3)
    // 
    // 19.01.2009. EDMS P2
    //   * Added field "Check Vehicle Sales Date"
    // 
    // 30.05.2008. EDMS P2
    //   * Added field "Transfer Qty. in Service"
    // 
    // 26.05.2008. EDMS P2
    //   * Added field "Control Alloc. Status on Post"
    // 
    // 07.01.2008. EDMS P2
    //   * Added field "Linked Entries Tracking"
    // 
    // 03.01.2008. EDMS P2
    //   * Added field "Split Allocation Tracking"
    // 
    // 27.12.2007. EDMS P2
    //   * Added field "Base Calendar Code"
    // 
    // 26.11.2007. EDMS P2
    //   * Added field "Control Lines In Serv. Order"
    // 
    // 29.08.2007. EDMS P2
    //   * Added new field "Quantity Equal Standard Time"
    // 
    // 24.08.2007. EDMS P2
    //   * Added field "Control Kilometrage"
    // 
    // 15.08.2007. EDMS P2
    //   * Added field "Autom. Apply Credit Memo"

    Caption = 'Service Mgt. Setup EDMS';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Quote Nos."; Code[20])
        {
            Caption = 'Quote Nos.';
            TableRelation = "No. Series";
        }
        field(30; "Order Nos."; Code[20])
        {
            Caption = 'Order Nos.';
            TableRelation = "No. Series";
        }
        field(33; "Posted Order Nos."; Code[20])
        {
            Caption = 'Posted Order Nos.';
            TableRelation = "No. Series";
        }
        field(35; "Return Order Nos."; Code[20])
        {
            Caption = 'Return Order Nos.';
            TableRelation = "No. Series";
        }
        field(38; "Posted Return Order Nos."; Code[20])
        {
            Caption = 'Posted Return Order Nos.';
            TableRelation = "No. Series";
        }
        field(60; "Labor Nos."; Code[20])
        {
            Caption = 'Labor Nos.';
            TableRelation = "No. Series";
        }
        field(90; "Service Package Nos."; Code[20])
        {
            Caption = 'Service Package Nos.';
            TableRelation = "No. Series";
        }
        field(94; "Service Plan Nos."; Code[20])
        {
            Caption = 'Service Plan Nos.';
            TableRelation = "No. Series";
        }
        field(96; "Recall Campaign Nos."; Code[20])
        {
            Caption = 'Recall Campaign Nos.';
            TableRelation = "No. Series";
        }
        field(98; "Warranty Nos."; Code[20])
        {
            Caption = 'Warranty Nos.';
            TableRelation = "No. Series";
        }
        field(100; "Invoice Nos."; Code[20])
        {
            Caption = 'Invoice Nos.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if Rec."Invoice Nos." <> '' then
                    Message(Txt301);
            end;
        }
        field(110; "External Service Nos."; Code[20])
        {
            Caption = 'External Service Nos.';
            TableRelation = "No. Series";
        }
        field(140; "Credit Warnings"; Option)
        {
            Caption = 'Credit Warnings';
            OptionCaption = 'Both Warnings,Credit Limit,Overdue Balance,No Warning';
            OptionMembers = "Both Warnings","Credit Limit","Overdue Balance","No Warning";
        }
        field(200; "Credit Memo Nos."; Code[20])
        {
            Caption = 'Credit Memo Nos.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if Rec."Credit Memo Nos." <> '' then
                    Message(Txt302);
            end;
        }
        field(210; "Posted Credit Memo Nos."; Code[20])
        {
            Caption = 'Posted Credit Memo Nos.';
            TableRelation = "No. Series";
        }
        field(220; "Order Nos. from Quote"; Code[20])
        {
            Caption = 'Order Nos. from Quote';
            TableRelation = "No. Series";
        }
        field(230; "Posted Invoice Nos."; Code[20])
        {
            Caption = 'Posted Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(310; "Ext. Doc. No. Mandatory"; Boolean)
        {
            Caption = 'Ext. Doc. No. Mandatory';
        }
        field(320; "Cust. Price Group Mandatory"; Boolean)
        {
            Caption = 'Cust. Price Group Mandatory';
        }
        field(350; "Prices Including VAT In Inv."; Boolean)
        {
            Caption = 'Prices Including VAT In Inv.';
        }
        field(360; "Use Order No. as Posting No."; Boolean)
        {
            Caption = 'Use Order No. as Posting No.';
        }
        field(370; "Use Order No. for Inv.&Cr.Memo"; Boolean)
        {
            Caption = 'Use Order No. for Inv.&Cr.Memo';
        }
        field(380; "Posted Prepmt. Inv. Nos."; Code[20])
        {
            Caption = 'Posted Prepmt. Inv. Nos.';
            TableRelation = "No. Series";
        }
        field(390; "Posted Prepmt. Cr. Memo Nos."; Code[20])
        {
            Caption = 'Posted Prepmt. Cr. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(395; "Service Booking Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(400; "Check Prepmt. when Posting"; Boolean)
        {
            Caption = 'Check Prepmt. when Posting';
        }
        field(410; "Service Schedule Active"; Boolean)
        {
            Caption = 'Service Schedule Active';
            Description = 'means is used calendar or not';
        }
        field(1000; "Show Line Grouping"; Boolean)
        {
            Caption = 'Show Line Grouping';
        }
        field(5000; "Control Package Consistency"; Boolean)
        {
            Caption = 'Control Package Consistency';
        }
        field(10500; "Deal Type Mandatory"; Boolean)
        {
            Caption = 'Deal Type Mandatory';
        }
        field(10600; "Archive Quotes and Orders"; Boolean)
        {
            Caption = 'Archive Quotes and Orders';
        }
        field(20100; "Inbound Transfer Line Filling"; Option)
        {
            Caption = 'Inbound Transfer Line Filling';
            Description = 'Service Transfer';
            OptionCaption = 'Manual,Prompt,Automatic';
            OptionMembers = Manual,Prompt,Automatic;
        }
        field(20120; "Outbound Transfer Line Filling"; Option)
        {
            Caption = 'Outbound Transfer Line Filling';
            Description = 'Service Transfer';
            OptionCaption = 'Manual,Prompt,Automatic';
            OptionMembers = Manual,Prompt,Automatic;
        }
        field(20200; "Def. Service Location Code"; Code[20])
        {
            Caption = 'Def. Service Location Code';
            Description = 'Service Transfer';
            TableRelation = Location;
        }
        field(20220; "Def. Spare Part Location Code"; Code[20])
        {
            Caption = 'Def. Spare Part Location Code';
            Description = 'Service Transfer';
            TableRelation = Location;
        }
        field(20230; "Def. In-Transit Location Code"; Code[20])
        {
            Caption = 'Def. In-Transit Location Code';
            Description = 'Service Transfer';
            TableRelation = Location;
        }
        field(20250; "Transfer On Return"; Option)
        {
            Caption = 'Transfer On Return';
            Description = 'Service Transfer';
            OptionCaption = 'Manual,Create Transfer Order,Create&Post Transfer Order';
            OptionMembers = Manual,"Create Transfer Order","Create&Post Transfer Order";
        }
        field(20300; "Fully Transfered Mandatory"; Boolean)
        {
            Caption = 'Fully Transfered Mandatory';
        }
        field(20340; "Inbound Transf. Auto-Reserve"; Boolean)
        {
            Caption = 'Inbound Transf. Auto-Reserve';
        }
        field(30000; "Item No. Replacement Warnings"; Boolean)
        {
            Caption = 'Item No. Replacement Warnings';
        }
        field(30200; "Recall Campaign Warnings"; Boolean)
        {
            Caption = 'Recall Campaign Warnings';
        }
        field(30210; "Log Service Plan Mgt. Process"; Boolean)
        {
            Caption = 'Log Service Plan Mgt. Process';
        }
        field(30310; "Check Transfered Qty.On Delete"; Option)
        {
            Caption = 'Check Transfered Qty.On Delete';
            OptionCaption = 'No,Confirm,Restrict';
            OptionMembers = No,Confirm,Restrict;
        }
        field(30320; "Def. Translation Language Code"; Code[10])
        {
            Caption = 'Default Translation Language Code';
            TableRelation = Language;
        }
        field(30330; "Posting Date Warnings"; Boolean)
        {
            Caption = 'Posting Date Warnings';
        }
        field(25006001; "Def. Ordering Price Type Code"; Code[10])
        {
            Caption = 'Def. Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006010; "Offer Link Vehicle and Contact"; Boolean)
        {
            Caption = 'Offer Link Vehicle and Contact';
        }
        field(25006015; "Payment Method Mandatory"; Boolean)
        {
            Caption = 'Payment Method Mandatory';
        }
        field(25006020; "Link Relationship Code"; Code[10])
        {
            Caption = 'Link Relationship Code';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006030; "Prev Owner Relationship Code"; Code[10])
        {
            Caption = 'Previous Owner Link Relationship Code';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006300; "AutoApply Credit Memo"; Boolean)
        {
            Caption = 'AutoApply Credit Memo';
        }
        field(25006310; "Check VF Run 1 on Release"; Boolean)
        {
            CaptionClass = '7,25006120,25006310';
        }
        field(25006311; "Check VF Run 2 on Release"; Boolean)
        {
            CaptionClass = '7,25006120,25006311';
        }
        field(25006312; "Check VF Run 3 on Release"; Boolean)
        {
            CaptionClass = '7,25006120,25006312';
        }
        field(25006320; "Quantity Equals Standard Time"; Boolean)
        {
            Caption = 'Quantity Equals Standard Time';
        }
        field(25006330; "Make and Model Mandatory"; Boolean)
        {
            Caption = 'Make and Model Mandatory';
        }
        field(25006340; "Check Vehicle Sales Date"; Boolean)
        {
            Caption = 'Check Vehicle Sales Date';
        }
        field(25006350; "Copy Comments Serv. Plan"; Boolean)
        {
            Caption = 'Copy Comments Serv. Plan';
        }
        field(25006360; "Create To-do After Posting"; Boolean)
        {
            Caption = 'Create To-do After Posting';
        }
        field(25006370; "To-do Date Formula"; DateFormula)
        {
            Caption = 'To-do Date Formula';
        }
        field(25006375; "To-do Interaction Template"; Code[20])
        {
            Caption = 'To-do Interaction Template';
            TableRelation = "Interaction Template";
        }
        field(25006380; "Notify Before (Date Formula)"; DateFormula)
        {
            Caption = 'Notify Before (Date Formula)';
            Description = 'Serv. Plan';
        }
        field(25006390; "Notify Before (VF Run 1)"; Decimal)
        {
            CaptionClass = '7,25006120,25006390';
            Description = 'Serv. Plan';
        }
        field(25006391; "Notify Before (VF Run 2)"; Decimal)
        {
            CaptionClass = '7,25006120,25006391';
            Description = 'Serv. Plan';
        }
        field(25006392; "Notify Before (VF Run 3)"; Decimal)
        {
            CaptionClass = '7,25006120,25006392';
            Description = 'Serv. Plan';
        }
        field(25006400; "Service Plan Notification"; Boolean)
        {
            Caption = 'Service Plan Notification';
            Description = 'Serv. Plan';
        }
        field(25006410; "Serv. Plan Cont. Relationship"; Code[20])
        {
            Caption = 'Serv. Plan Cont. Relationship';
            Description = 'Serv. Plan - used for auto generation of serv. doc';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006411; "PDI Cont. Relationship"; Code[20])
        {
            Caption = 'PDI Cont. Relationship';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006412; "Notify About Components"; Boolean)
        {
            Caption = 'Notify About Components';
        }
        field(25006413; "Service Comment Line Type"; Code[20])
        {
            Caption = 'Service Comment Line Type';
            TableRelation = "Service Comment Line Type";
        }
        field(25006414; "Control Veh. Reg. No. Dubl."; Option)
        {
            Caption = 'Control Vehicle Registration No. Duplicates';
            OptionMembers = Warning,No,Yes;
        }
        field(25006415; "Default Location Code"; Code[20])
        {
        }
        field(25006417; "Default Idle Event"; Code[20])
        {
            TableRelation = "Serv. Standard Event";
        }
        field(25006418; "Resource No. Mandatory"; Boolean)
        {
        }
        field(25006419; "Auto Apply Replacements"; Boolean)
        {
            Caption = 'Automatically Apply Replacements';
        }
        field(25006420; "Map Websource Code"; Code[20])
        {
            Caption = 'Map Websource Code';
            TableRelation = "Web Source";
        }
        field(25006421; "Map Zoom Level"; Integer)
        {
            Caption = 'Map Zoom Level';
        }
        field(25006422; "Enable Stock Avail. Selection"; Boolean)
        {
            Caption = 'Enable Stock Availability Selection';
            DataClassification = ToBeClassified;
        }
        field(25006430; "Service Cost Handling"; Option)
        {
            Caption = 'Service Cost Handling';
            DataClassification = ToBeClassified;
            OptionCaption = 'Show from Labor Cost,Show from Resource Cost,Post from Labor Cost,Post from Resource Cost';
            OptionMembers = "Show from Labor Cost","Show from Resource Cost","Post from Labor Cost","Post from Resource Cost";
        }
        field(25006950; "Def. MOT Deal Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Deal Type";
        }
        field(25006960; "Def. Repair Deal Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Deal Type";
        }
        field(25006970; "Def. Servicing Deal Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Deal Type";
        }
        field(25006971; "GDPR Tool Promoted"; Boolean)
        {
            Caption = 'GDPR Tool Promoted';
            DataClassification = ToBeClassified;
        }
        field(25006980; "Maintanance Lookup Provider"; Option)
        {
            Caption = 'Maintanance Lookup Provider';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,AutoGuru,CarWeb';
            OptionMembers = " ",AutoGuru,CarWeb;
        }
        field(25006981; "Repair Lookup Provider"; Option)
        {
            Caption = 'Repair Lookup Provider';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,AutoGuru,CarWeb';
            OptionMembers = " ",AutoGuru,CarWeb;
        }
        field(25006982; "Def. Maintanance Labor No."; Code[20])
        {
            Caption = 'Default Maintanance Labor No.';
            DataClassification = ToBeClassified;
            TableRelation = "Service Labor";
        }
        field(25006983; "Def. Repair Labor No."; Code[20])
        {
            Caption = 'Default Repair Labor No.';
            DataClassification = ToBeClassified;
            TableRelation = "Service Labor";
        }
        field(25006984; "Def. Item No."; Code[20])
        {
            Caption = 'Default Maintanance and Repair Item';
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(25006985; "Show Service Address"; Boolean)
        {
            Caption = 'Show Service Address';
            DataClassification = ToBeClassified;
        }
        field(25006986; "Allow Unposted Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25006987; "Post if Paid"; Boolean)
        {
            Caption = 'Post if Paid';
            DataClassification = ToBeClassified;
        }
        field(25006988; "Def. Labor No."; Code[20])
        {
            Caption = 'Default Labour No';
            DataClassification = ToBeClassified;
            TableRelation = "Service Labor";
        }
        field(25006989; "Vehicle No. Promoted"; Boolean)
        {
            Caption = 'Vehicle No. Promoted';
            DataClassification = ToBeClassified;
        }
        field(25006990; "Archive Service Order on Del."; Boolean)
        {
            Caption = 'Archive Service Order on Delete';
            DataClassification = ToBeClassified;
        }
        field(25006991; "Register Sales By Resource"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25006992; "Ext. Serv. Tracking Mandatory"; Boolean)
        {
            Caption = 'Ext. Serv. Tracking Mandatory';
            DataClassification = ToBeClassified;
        }
        field(25006993; "VHC Nos."; Code[20])
        {
            Caption = 'VHC Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(25006994; "VHC Upcoming Rem. Date Formula"; DateFormula)
        {
            Caption = 'VHC Upcoming Reminder Date Formula';
            DataClassification = ToBeClassified;
        }
        field(25006995; "VHC Tiles Promoted for Advisor"; Boolean)
        {
            Caption = 'VHC Tiles Promoted for Advisor';
            DataClassification = ToBeClassified;
        }
        field(25006996; "Archive Quote on Delete"; Boolean)
        {
            Caption = 'Archive Quote on Delete';
            DataClassification = ToBeClassified;
        }
        field(25006997; "Archive VHC on Delete"; Boolean)
        {
            Caption = 'Archive VHC on Delete';
            DataClassification = ToBeClassified;
        }
        field(25006998; "Average Hourly Rate"; Decimal)
        {
            Caption = 'Average Hourly Rate';
            DataClassification = ToBeClassified;
        }
        field(25006999; "Work Status Ready for Collect."; Text[250])
        {
            Caption = 'Work Status Ready for Collection Filter';
            DataClassification = ToBeClassified;
        }
        field(25007000; "Control Mechanic Time Entry"; Boolean)
        {
            Caption = 'Control Mechanic Time Entry';
            DataClassification = ToBeClassified;
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
        Txt301: label 'Don''t forget to relate this Num. serie with Posted Sales Invoice Num. serie';
        Txt302: label 'Don''t forget to relate this Num. serie with Posted Sales Credit Memo Num. serie';
        VFMgt: Codeunit "Variable Field Management";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Service Mgt. Setup EDMS", intFieldNo));
    end;
}

