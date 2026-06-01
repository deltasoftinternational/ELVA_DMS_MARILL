tableextension 25006031 "Sales Invoice Line" extends "Sales Invoice Line" //113
{
    // 13.06.2019 EB.P30 EDMS
    //   Modified field:
    //     "Line Type" Added option Resource
    // 
    // 02.08.2018 EB.P30 EDMS Rent
    //   Modified field "Document Profile":
    //     Added option "Rent"
    //   Added field:
    //     25006600 "Rent Order No."
    //     25006601 "Rent Order Line No."
    //     25006602 "Rent Item No."
    //     25006603 "Rent Order Sales Line No."
    //     25006604 "Rent Asset No."
    // 
    // 05.02.2018 EB.P30 EDMS POD1.22
    //   Added field:
    //     25006680 "Contract No."
    // 
    // 25.01.2016 EB.P30 #T031
    //   Modified field "Vehicle Body Color Code" lenght to 20 characters
    // 
    // 08.04.2013 EDMS P8
    //   * Deleted fields: 'Mechanic No.', 'Transfer Item Ledger Entry No.'
    // 
    // 23.01.2013 EDMS P8
    //   * Changed type of field: Resources
    // 
    // 16.01.2008 EDMS P3
    //   * Added function ApplyDealDocuments
    // 
    // 28.12.2007 EDMS P5
    //         * Changed property "OptionString" for field "Type"
    //           from  ",G/L Account,Item,Resource,Fixed Asset,Charge (Item)"
    //           to " ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service"
    // 
    //         * Changed property "TableRelation" for field "No."
    //           from "IF (Type=CONST(G/L Account)) "G/L Account"
    //               ELSE IF (Type=CONST(Item)) Item
    //               ELSE IF (Type=CONST(Resource)) Resource
    //               ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //               ELSE IF (Type=CONST("Charge (Item)")) "Item Charge""
    //           to "IF (Type=CONST(G/L Account)) "G/L Account"
    //               ELSE IF (Type=CONST(Item)) Item
    //               ELSE IF (Type=CONST(Resource)) Resource
    //               ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //               ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
    //               ELSE IF (Type=CONST(External Service)) "External Service EDMS""
    // 
    //         * Added new field
    //           25006130 "Ext. Service Tracking No."
    // 
    // 09-02-2007 Elva Baltic J.Fedorovich
    //    * Added field 25006377 - EDMS No. (also in nonposted line)

    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service,Rent';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service,Rent;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006002; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(25006006; Group; Boolean)
        {
            Caption = 'Group';
        }
        field(25006007; "Group ID"; Integer)
        {
            Caption = 'Group ID';
        }
        field(25006008; "Group Description"; Text[100])
        {
            CalcFormula = lookup("Sales Invoice Line".Description where("Document No." = field("Document No."),
                                                                         "Line No." = field("Group ID")));
            Caption = 'Group Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006010; "Item No. for Print"; Code[20])
        {
            Caption = 'Item No. for Print';
            TableRelation = Item;
            ValidateTableRelation = false;
        }
        field(25006015; Prepayment; Boolean)
        {
            Caption = 'Prepayment';
        }
        field(25006020; "Item Description for Print"; Text[30])
        {
            Caption = 'Item Description for Print';
        }
        field(25006030; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006050; "Resources (Serv.)"; Code[100])
        {
            Caption = 'Resources (Serv.)';
        }
        field(25006060; "Standard Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(25006128; "Real Time (Hours)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time (Hours)';
        }
        field(25006130; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = if (Type = filter("External Service")) "External Serv. Tracking No."."External Serv. Tracking No." where("External Service No." = field("No."));
        }
        field(25006135; "Service Order No. EDMS"; Code[20])
        {
            Caption = 'Service Order No. EDMS';
            Description = 'Only Service';
        }
        field(25006137; "Service Order Line No. EDMS"; Integer)
        {
            Caption = 'Service Order Line No. EDMS';
        }
        field(25006140; "Order Line Type No."; Code[20])
        {
            Caption = 'Order Line Type No.';
            Description = 'Only Service';
            TableRelation = if ("Line Type" = const(Comment)) "Standard Text"
            else
            if ("Line Type" = const("G/L Account")) "G/L Account"
            else
            if ("Line Type" = const(Item)) Item
            else
            if ("Line Type" = const(Labor)) "Service Labor"
            else
            if ("Line Type" = const("Ext. Service")) "External Service";
        }
        field(25006150; "Called to Customer Date"; Date)
        {
            Caption = 'Called to Customer Date';
        }
        field(25006155; "Real Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time';
            Description = 'Only Service';
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Registration No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006210; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
            TableRelation = "Service Package"."No.";
        }
        field(25006300; "Package Version No."; Integer)
        {
            Caption = 'Package Version No.';
            Editable = false;
            TableRelation = "Service Package Version"."Version No." where("Package No." = field("Package No."));
        }
        field(25006310; "Package Version Spec. Line No."; Integer)
        {
            Caption = 'Package Version Spec. Line No.';
            Editable = false;
            NotBlank = true;
            TableRelation = "Service Package Version Line"."Line No." where("Package No." = field("Package No."),
                                                                             "Version No." = field("Package Version No."));
        }
        field(25006370; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006371; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006372; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Comment,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item),Fixed Asset,Resource';
            OptionMembers = Comment,"G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)","Fixed Asset",Resource;
        }
        field(25006373; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006374; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));
        }
        field(25006375; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No." where("Serial No." = field("Vehicle Serial No."));
        }
        field(25006376; "Vehicle Assembly ID"; Code[20])
        {
            Caption = 'Vehicle Assembly ID';
        }
        field(25006377; "Service No."; Code[20])
        {
            Caption = 'Service No.';
            TableRelation = if ("Line Type" = const(Comment)) "Standard Text"
            else
            if ("Line Type" = const(Labor)) "Service Labor"
            else
            if ("Line Type" = const("Ext. Service")) "External Service";
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";

            trigger OnLookup()
            var
                recVehAccCycle: Record "Vehicle Accounting Cycle";
            begin
                recVehAccCycle.Reset;
                if cuLookUpMgt.LookUpVehicleAccCycle(recVehAccCycle, "Vehicle Serial No.", "Vehicle Accounting Cycle No.") then;
            end;
        }
        field(25006380; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006386; "Vehicle Body Color Code"; Code[20])
        {
            Caption = 'Vehicle Body Color Code';
            TableRelation = "Body Color";
        }
        field(25006388; "Vehicle Interior Code"; Code[10])
        {
            Caption = 'Vehicle Interior Code';
            TableRelation = "Vehicle Interior";
        }
        field(25006389; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,113,25006389';
        }
        field(25006390; "Vehicle Trade-In Line"; Boolean)
        {
            Caption = 'Vehicle Trade-In Line';
        }
        field(25006391; "Applies-to Veh. Serial No."; Code[20])
        {
            Caption = 'Applies-to Veh. Serial No.';
        }
        field(25006392; "Applies-to Veh. Cycle No."; Code[20])
        {
            Caption = 'Applies-to Veh. Cycle No.';
        }
        field(25006578; "Include In Veh. Sales Amt."; Boolean)
        {
            Caption = 'Include In Veh. Sales Amt.';
        }
        field(25006600; "Rent Order No."; Code[20])
        {
            Caption = 'Rent Order No.';
            DataClassification = ToBeClassified;
            Description = 'Only for Rent';
        }
        field(25006601; "Rent Order Line No."; Integer)
        {
            Caption = 'Rent Order Line No.';
            DataClassification = ToBeClassified;
        }
        field(25006602; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';
            DataClassification = ToBeClassified;
        }
        field(25006603; "Rent Order Sales Line No."; Integer)
        {
            Caption = 'Rent Order Sales Line No.';
            DataClassification = ToBeClassified;
        }
        field(25006604; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            DataClassification = ToBeClassified;
        }
        field(25006680; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
        }
        field(25006710; "Amount Enter In Line No."; Integer)
        {
            Caption = 'Amount Enter In Line No.';
            TableRelation = "Sales Invoice Line"."Line No." where("Document No." = field("Document No."));
        }
        field(25006730; "Print in Order"; Boolean)
        {
            Caption = 'Print in Order';
        }
        field(25006740; "Backorder Date"; Date)
        {
            Caption = 'Backorder Date';
        }
        field(25006996; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,113,25006996';
        }
        field(25006997; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,113,25006997';
        }
        field(25006850; "Leasing Schedule No."; Code[20])
        {
            Caption = 'Leasing Schedule No.';
        }
        field(25006851; "Leasing Schedule Line No."; Integer)
        {
            Caption = 'Leasing Schedule Line No.';
        }

    }
    keys
    {  /*
        key(Key10; Type, "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.")
        {
        }*/
        key(Key11; "Service Order No. EDMS", "Service Order Line No. EDMS")
        {
        }
    }
    procedure ApplyDealDocuments()
    var
        DealDocApplication: Page "Deal Document Application";
        CustLedgEntry: Record "Cust. Ledger Entry";
        SalesInvHeader: Record "Sales Invoice Header";
        DCLedgEntry: Record "Cust. Ledg. Entry Link";
    begin
        SalesInvHeader.Get("Document No.");
        DCLedgEntry.SetCurrentkey("Document Type", "Document No.", "Posting Date", "Document Line No.");
        DCLedgEntry.SetRange("Document Type", CustLedgEntry."document type"::Invoice);
        DCLedgEntry.SetRange("Document No.", "Document No.");
        DCLedgEntry.SetRange("Posting Date", SalesInvHeader."Posting Date");
        DCLedgEntry.SetRange("Document Line No.", "Line No.");
        if DCLedgEntry.FindFirst then begin
            DealDocApplication.SetApplication(1, DCLedgEntry."Entry No.", 6,
              DCLedgEntry."Document No.", DCLedgEntry."Document Line No.");
            DealDocApplication.RunModal
        end else
            Error(Text100, DCLedgEntry.TableCaption)
    end;

    var
        cuLookUpMgt: Codeunit LookUpManagement;
        Text100: label '%1 doesn''t exist for this line.';
}