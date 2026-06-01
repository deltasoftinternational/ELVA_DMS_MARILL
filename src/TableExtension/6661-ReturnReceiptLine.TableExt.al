tableextension 25006375 "Return Receipt Line" extends "Return Receipt Line"  //6661 
{
    // 13.06.2019 EB.P30 EDMS
    //   Modified field:
    //     "Line Type" Added option Resource
    // 
    // 22.10.2015 NAV2016 Merge
    //   ShowItemSalesCrMemoLines, ShowLineComments set to public
    // 
    // 08.04.2013 EDMS P8
    //   * Deleted fields: 'Mechanic No.', 'Transfer Item Ledger Entry No.'
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
        modify("No.")
        {
            Caption = 'No.';
            TableRelation = if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const("External Service")) "External Service";
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
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
        field(25006050; "Resource No. (Serv.)"; Code[20])
        {
            Caption = 'Resource No. (Serv.)';
            TableRelation = Resource;
        }
        field(25006128; "Real Time (Hours)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time (Hours)';
        }
        field(25006130; "Ext. Service Tracking No."; Code[20])
        {
            Caption = 'Ext. Service Tracking No.';
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
            OptionCaption = 'Comment,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item),Resource';
            OptionMembers = Comment,"G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)",Resource;
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
        }
        field(25006376; "Vehicle Assembly ID"; Code[20])
        {
            Caption = 'Vehicle Assembly ID';
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
    }

    var
        cuLookUpMgt: Codeunit LookUpManagement;
}
