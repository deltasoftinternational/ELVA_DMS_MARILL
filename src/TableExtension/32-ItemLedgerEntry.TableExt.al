tableextension 25006008 "Item Ledger Entry" extends "Item Ledger Entry" //32
{
    // 06.12.2017 EB.P7 #T007
    //   Removed field "Product Subgroup Code"
    // 
    // 29.01.2010 EDMS P2
    //   * Added key "Campaign No.,Entry Type" 
    // 
    // 19.09.2007. EDMS P2
    //   * Added SumIndexField Quantity to key "Location Code,Serial No.,Item Type,Posting Date"
    // 
    // 20.06.2007. EDMS P2
    //   * Added key Location Code, Serial No., Item Type, Posting Date
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = " ",Item,"Model Version";
        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006004; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                recItem.SetCurrentkey("Item Type", "Make Code", "Model Code");
                recItem.SetRange("Item Type", recItem."item type"::"Model Version");
                recItem.SetRange("Make Code", "Make Code");
                recItem.SetRange("Model Code", "Model Code");
                if Page.RunModal(Page::"Item List", recItem) = Action::LookupOK then //30.10.2012 EDMS
                 begin
                    Validate("Model Version No.", recItem."No.");
                end;
            end;
        }
        field(25006005; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Serial No.")));
            Caption = 'VIN';
            FieldClass = FlowField;
            TableRelation = Vehicle;
        }
        field(25006007; "Value Entry Reason Code"; Code[10])
        {
            CalcFormula = lookup("Value Entry"."Reason Code" where("Item Ledger Entry No." = field("Entry No.")));
            Caption = 'Value Entry Reason Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006008; "Value Entry Document No."; Code[20])
        {
            CalcFormula = lookup("Value Entry"."Document No." where("Item Ledger Entry No." = field("Entry No.")));
            Caption = 'Value Entry Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006009; "Value Entry Salespers. Code"; Code[20])
        {
            CalcFormula = lookup("Value Entry"."Salespers./Purch. Code" where("Item Ledger Entry No." = field("Entry No.")));
            Caption = 'Value Entry Salespers. Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006010; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006025; "External Document No. 2"; Code[20])
        {
            Caption = 'External Document No. 2';
        }
        field(25006030; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006160; "Transfer Source Type"; Integer)
        {
            Caption = 'Transfer Source Type';
            Editable = false;
        }
        field(25006166; "Transfer Source Subtype"; Option)
        {
            Caption = 'Transfer Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Registration No." where("Serial No." = field("Serial No.")));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006200; "Transfer Source No."; Code[20])
        {
            Caption = 'Transfer Source No.';
            TableRelation = if ("Transfer Source Type" = const(25006145)) "Service Header EDMS"."No." where("Document Type" = field("Transfer Source Subtype"),
                                                                                                           "No." = field("Transfer Source No."));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";

            trigger OnLookup()
            var
                recVehAccCycleNo: Record "Vehicle Accounting Cycle";
                cuLookupMgt: Codeunit LookUpManagement;
            begin
                recVehAccCycleNo.Reset;
                if cuLookupMgt.LookUpVehicleAccCycle(recVehAccCycleNo, "Serial No.", "Vehicle Accounting Cycle No.") then;
            end;
        }
        field(25006382; Reserved; Boolean)
        {
            CalcFormula = exist("Vehicle Reservation Entry" where("Source Type" = const(32),
                                                                   "Source Ref. No." = field("Entry No.")));
            Caption = 'Reserved';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006690; "Exchange Unit"; Boolean)
        {
            CalcFormula = lookup(Item."Exchange Unit" where("No." = field("Item No.")));
            Caption = 'Exchange Unit';
            Editable = false;
            FieldClass = FlowField;
        }

    }

    keys
    {
        //  Create a mixed key from BaseApp & extension !!!
        /*
        key(Key22; "Serial No.", "Vehicle Accounting Cycle No.", "Item Type")
        {
        }
        */
        key(Key23; "Item Type")
        {
        }
        /*
        key(Key24; "Location Code", "Serial No.", "Item Type", "Posting Date")
        {
            SumIndexFields = Quantity;
        }
        key(Key25; "Campaign No.", "Entry Type")
        {
        }
        */

        key(Key26; "Document No.", "Posting Date")
        {
        }

        key(Key30; "Serial No.")
        {
            //>>DELTA 01
            Enabled = true;
            SumIndexFields = Quantity;
            MaintainSIFTIndex = true;
            MaintainSQLIndex = true;
            //<<DELTA 01

        }
    }

}