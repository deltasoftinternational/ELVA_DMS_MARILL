Table 25006196 "Service WIP Total"
{
    DrillDownPageID = "Service Mechanic Header Tasks";
    LookupPageID = "Service Mechanic Header Tasks";

    fields
    {
        field(5; "Entry No."; Integer)
        {
        }
        field(10; "Document No."; Code[20])
        {
        }
        field(15; "Posting Date"; Date)
        {
        }
        field(20; "Service Order No."; Code[20])
        {
        }
        field(30; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(40; "Sell-to Customer Name"; Text[30])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(50; "Posted Cost Adjustment"; Decimal)
        {
            CalcFormula = sum("Service WIP Entry"."WIP Entry Amount" where("Document No." = field("Document No."),
                                                                            "Entry Type" = const("Accrued Costs")));
            FieldClass = FlowField;
        }
        field(60; "Posted Sales Adjustment"; Decimal)
        {
            CalcFormula = sum("Service WIP Entry"."WIP Entry Amount" where("Document No." = field("Document No."),
                                                                            "Entry Type" = const("Accrued Sales")));
            FieldClass = FlowField;
        }
        field(70; Reversed; Boolean)
        {
        }
        field(75; "Reverse Posting Date"; Date)
        {
        }
        field(80; Consolidated; Boolean)
        {
        }
        field(90; "Item C. Amt. (Posted)"; Decimal)
        {
            CalcFormula = sum("Service WIP Entry"."WIP Entry Amount" where("Entry Type" = const("Accrued Costs"),
                                                                            "Document No." = field("Document No."),
                                                                            Type = const(Item),
                                                                            Reversed = const(false)));
            Caption = 'Item Cost Amt. (Posted)';
            FieldClass = FlowField;
        }
        field(100; "Item S. Amt. (Posted)"; Decimal)
        {
            CalcFormula = sum("Service WIP Entry"."WIP Entry Amount" where("Entry Type" = const("Accrued Sales"),
                                                                            "Document No." = field("Document No."),
                                                                            Type = const(Item),
                                                                            Reversed = const(false)));
            Caption = 'Item Sales Amt. (Posted)';
            FieldClass = FlowField;
        }
        field(110; "Labor C. Amt. (Posted)"; Decimal)
        {
            CalcFormula = sum("Service WIP Entry"."WIP Entry Amount" where("Entry Type" = const("Accrued Costs"),
                                                                            "Document No." = field("Document No."),
                                                                            Type = const(Labor),
                                                                            Reversed = const(false)));
            Caption = 'Labor Cost Amt. (Posted)';
            FieldClass = FlowField;
        }
        field(120; "Labor S. Amt. (Posted)"; Decimal)
        {
            CalcFormula = sum("Service WIP Entry"."WIP Entry Amount" where("Entry Type" = const("Accrued Sales"),
                                                                            "Document No." = field("Document No."),
                                                                            Type = const(Labor),
                                                                            Reversed = const(false)));
            Caption = 'Labor Sales Amt. (Posted)';
            FieldClass = FlowField;
        }
        field(130; "Ext.S. C. Amt. (Posted)"; Decimal)
        {
            CalcFormula = sum("Service WIP Entry"."WIP Entry Amount" where("Entry Type" = const("Accrued Costs"),
                                                                            "Document No." = field("Document No."),
                                                                            Type = const("External Service"),
                                                                            Reversed = const(false)));
            Caption = 'Ext.S. Cost Amt. (Posted)';
            FieldClass = FlowField;
        }
        field(140; "Ext.S. S. Amt. (Posted)"; Decimal)
        {
            CalcFormula = sum("Service WIP Entry"."WIP Entry Amount" where("Entry Type" = const("Accrued Sales"),
                                                                            "Document No." = field("Document No."),
                                                                            Type = const("External Service"),
                                                                            Reversed = const(false)));
            Caption = 'Ext.S. Sales Amt. (Posted)';
            FieldClass = FlowField;
        }
        field(150; "Cost Amt. (Posted)"; Decimal)
        {
            CalcFormula = sum("Service WIP Entry"."WIP Entry Amount" where("Entry Type" = const("Accrued Costs"),
                                                                            "Document No." = field("Document No."),
                                                                            Reversed = const(false)));
            Caption = 'Cost Amt. (Posted)';
            FieldClass = FlowField;
        }
        field(160; "Sales Amt. (Posted)"; Decimal)
        {
            CalcFormula = sum("Service WIP Entry"."WIP Entry Amount" where("Entry Type" = const("Accrued Sales"),
                                                                            "Document No." = field("Document No."),
                                                                            Reversed = const(false)));
            Caption = 'Sales Amt. (Posted)';
            FieldClass = FlowField;
        }
        field(170; "WIP Totals"; Integer)
        {
            CalcFormula = count("Service WIP Total" where("Service Order No." = field("Service Order No.")));
            Editable = true;
            FieldClass = FlowField;
        }
        field(180; "Reverse Document No."; Code[20])
        {
        }
        field(190; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(200; "Bill-to Name"; Text[50])
        {
            Caption = 'Bill-to Name';
        }
        field(210; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(220; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(230; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(240; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(250; VIN; Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(260; "Vehicle Registration No."; Code[11])
        {
            Caption = 'Vehicle Registration No.';
        }
        field(270; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(280; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(290; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(300; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Service Order No.", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

