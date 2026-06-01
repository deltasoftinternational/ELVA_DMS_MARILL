tableextension 25006062 "Purch. Rcpt. Line" extends "Purch. Rcpt. Line" //121
{
    // 22.10.2015 NAV2016 Merge
    //   ShowItemPurchInvLines set to Ppublic
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

    fields
    {
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
        }
        // field(25006006; "Vendor Order No."; Code[20])
        // {
        //     Caption = 'Vendor Order No.';
        // }
        field(25006130; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = if (Type = filter("External Service")) "External Serv. Tracking No."."External Serv. Tracking No." where("External Service No." = field("No."));
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Registration No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
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
            OptionCaption = 'Comment,Vehicle,Own Option,Item,Charge (Item),Resource';
            OptionMembers = Comment,Vehicle,"Own Option",Item,"Charge (Item)",Resource;
        }
        field(25006373; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
        }
        field(25006374; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                recItem.Reset;
                if cuLookupMgt.LookUpModelVersion(recItem, "No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", recItem."No.");
            end;
        }
        field(25006375; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
            begin
                recVehicle.Reset;
                if cuLookupMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") then;
            end;
        }
        field(25006376; "Vehicle Assembly No."; Code[20])
        {
            Caption = 'Vehicle Assembly No.';
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
                if cuLookupMgt.LookUpVehicleAccCycle(recVehAccCycle, "Vehicle Serial No.", "Vehicle Accounting Cycle No.") then;
            end;
        }
        field(25006380; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006700; "Ordering Price Type Code"; Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }

        modify("No.")
        {
            TableRelation = if (Type = const("External Service")) "External Service";
        }
    }
    keys
    {
        //  Create a mixed key from BaseApp & extension !!!
        /*
        key(Key8; Type, "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.")
        {
        }
        */
    }
    var
        cuLookupMgt: Codeunit LookUpManagement;

}