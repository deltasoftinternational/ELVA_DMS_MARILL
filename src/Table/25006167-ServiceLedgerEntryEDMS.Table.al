Table 25006167 "Service Ledger Entry EDMS"
{
    // 11.06.2015 EB.P30 #T041
    //   Added fields:
    //     "Resource Cost Amount"
    //     "Quantity (Hours)"
    //   Added functions:
    //     GetResourceTextFieldValue
    //     ShowDetLedgEntries
    // 
    // 12.05.2015 EB.P30 #T030
    //   Added field:
    //     "Resource Cost Amount"
    // 
    // 12.06.2013 EDMS P8
    //   * Code merge with NAV2009
    // 
    // 2012.07.31 EDMS, P8
    //   * changed type of field 'Variable Field Run 1' - now it is decimal
    // 
    // 28.01.2010 EDMSB P2
    //   * Added field "Standard Time", "Campaign No.", "Labor Group Code", "Labor Subgroup Code", "Amount Including VAT (LCY)"
    //   * Added key "Campaign No.,Entry Type,Type"
    // 
    // 20.10.2008. EDMS P2
    //   * Added field "Deal Type Code"
    // 
    // 10.05.2008. EDMS P2
    //   * Added key "Make Code,Model Code,Model Version No.,Posting Date"
    // 
    // 05.03.2008 EDMS P2
    //   * Added fields "Package No."
    //                  "Package Version No."
    //                  "Package Version Spec. Line No."
    // 
    // 26.07.2007. EDMS P2
    //   * Added key "Payment Method Code,Entry Type,Document Type,Document No."
    // 
    // 10.07.2007. EDMS P2
    //   * Added key "Entry Type,Resource No.,Type,Payment Method Code,No.,Posting Date"

    Caption = 'Service Ledger Entry EDMS';
    DrillDownPageID = "Service Ledger Entries EDMS";
    LookupPageID = "Service Ledger Entries EDMS";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Usage,Sale,Info';
            OptionMembers = Usage,Sale,Info;
        }
        field(30; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Order,Invoice,Credit Memo,Blanket Order,Return Order,Payment,Refund';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order",Payment,Refund;
        }
        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(50; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(60; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(70; "Make Code"; Code[20])
        {
            Caption = 'Make code';
            TableRelation = Make;
        }
        field(80; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(90; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));
        }
        field(100; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(110; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(120; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(130; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(140; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(150; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service,Resource';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service",Resource;
        }
        field(160; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(" ")) "Standard Text"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(Labor)) "Service Labor"."No."
            else
            if (Type = const("Ext. Service")) "External Service";
        }
        field(170; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(175; "Amount Including VAT (LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
        }
        field(180; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(185; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(190; "Total Cost"; Decimal)
        {
            Caption = 'Cost Amount';
        }
        field(200; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
        }
        field(205; "Inv. Discount Amount"; Decimal)
        {
            Caption = 'Inv. Discount Amount';
        }
        field(206; "Line Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';
        }
        field(207; "Inv. Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Inv. Discount Amount (LCY)';
        }
        field(210; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(220; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(230; "Charged Qty."; Decimal)
        {
            Caption = 'Charged Qty.';
        }
        field(240; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
        }
        field(250; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(260; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(270; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
        }
        field(280; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(290; "Service Order Type"; Code[10])
        {
            Caption = 'Service Order Type';
            TableRelation = "Service Order Type";
        }
        field(300; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            TableRelation = "Service Ledger Entry EDMS"."Document No." where("Document Type" = const(Order));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(310; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(320; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(330; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(340; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(350; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(360; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(370; Open; Boolean)
        {
            Caption = 'Open';
            Description = 'A check mark in this field indicates that the entry is open. The entry is open until a linked sales invoice has been posted.';
        }
        field(380; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(390; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(400; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(410; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(420; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(430; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(440; "Pre-Assigned No."; Code[20])
        {
            Caption = 'Previous Document No.';
        }
        field(450; "Service Receiver"; Code[20])
        {
            Caption = 'Service Receiver';
            TableRelation = "Salesperson/Purchaser";
        }
        field(460; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(470; "Remaining Amount"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Cust. Ledger Entry No." = field("Cust. Ledger Entry No."),
                                                                         "Posting Date" = field("Date Filter")));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(480; "Cust. Ledger Entry No."; Integer)
        {
            Caption = 'Cust. Ledger Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(481; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(490; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(500; "Serv. Order Remaining Amt"; Decimal)
        {
            CalcFormula = sum("Service Ledger Entry EDMS".Amount where("Service Order No." = field("Document No."),
                                                                        "Document Type" = filter(<> Order)));
            Caption = 'Serv. Order Remaining Amt';
            FieldClass = FlowField;
        }
        field(510; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(570; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006167,570';
        }
        field(580; "Variable Field Run 2"; Decimal)
        {
            CaptionClass = '7,25006167,580';
        }
        field(590; "Variable Field Run 3"; Decimal)
        {
            CaptionClass = '7,25006167,590';
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006005; "Minutes Per UoM"; Decimal)
        {
            Caption = 'Minutes Per UoM';
        }
        field(25006006; "Quantity (Hours)"; Decimal)
        {
            Caption = 'Quantity (Hours)';
        }
        field(25006030; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006040; "Labor Group Code"; Code[10])
        {
            Caption = 'Labor Group Code';
            TableRelation = "Service Labor Group".Code;
        }
        field(25006050; "Labor Subgroup Code"; Code[10])
        {
            Caption = 'Labor Subgroup Code';
            TableRelation = "Service Labor Subgroup".Code where("Group Code" = field("Labor Group Code"));
        }
        field(25006150; "Standard Time"; Decimal)
        {
            Caption = 'Standard Time';
            DecimalPlaces = 0 : 5;
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
        field(25006276; "Warranty Claim No."; Code[20])
        {
            Caption = 'Warranty Claim No.';
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
        field(25006630; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006167,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006167,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006167,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006810; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006820; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            Description = 'at begin holds line No. of posted order only';
            TableRelation = "Posted Serv. Order Line"."Line No." where("Document No." = field("Document No."));
        }
        field(25007240; "Plan No."; Code[10])
        {
            Caption = 'Plan No.';
            TableRelation = "Vehicle Service Plan"."No." where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(25007245; "Plan Stage Recurrence"; Integer)
        {
            Caption = 'Plan Stage Recurrence';
            TableRelation = "Vehicle Service Plan Stage".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                     "Plan No." = field("Plan No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(25007250; "Plan Stage Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = "Vehicle Service Plan Stage".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                     "Plan No." = field("Plan No."),
                                                                     Recurrence = field("Plan Stage Recurrence"));
        }
        field(25007255; "Parent Vehicle Serial No."; Code[20])
        {
            Caption = 'Parent Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";
        }
        field(25007260; "Resource Cost Amount"; Decimal)
        {
            CalcFormula = sum("Det. Serv. Ledger Entry EDMS"."Cost Amount" where("Service Ledger Entry No." = field("Entry No.")));
            Caption = 'Resource Cost Amount';
            FieldClass = FlowField;
        }
        field(25007270; "Finished Hours"; Decimal)
        {
            CalcFormula = sum("Det. Serv. Ledger Entry EDMS"."Finished Quantity (Hours)" where("Service Ledger Entry No." = field("Entry No.")));
            FieldClass = FlowField;
        }
        field(25007271; "Service Address Code"; Code[20])
        {
            Caption = 'Service Address Code';
            TableRelation = "Ship-to Address";
        }
        field(25007272; "Service Address"; Text[50])
        {
            Caption = 'Service Address';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Posting Date")
        {
        }
        key(Key3; "Service Order No.", "Document Type")
        {
            SumIndexFields = Amount;
        }
        key(Key4; "Document Type", "Document No.", "Posting Date")
        {
        }
        key(Key5; "Document Type", "Service Order No.", "Bill-to Customer No.")
        {
        }
        key(Key6; "Vehicle Serial No.", "Entry Type", "Posting Date")
        {
        }
        key(Key7; "Entry Type", Type, "Payment Method Code", "No.", "Posting Date")
        {
        }
        key(Key8; "Payment Method Code", "Entry Type", "Document Type", "Document No.")
        {
        }
        key(Key9; "Make Code", "Model Code", "Model Version No.", "Posting Date")
        {
        }
        key(Key10; "Vehicle Serial No.", "Entry Type", "Variable Field Run 1")
        {
        }
        key(Key11; "Campaign No.", "Entry Type", Type)
        {
        }
        key(Key12; "Vehicle Serial No.", "Posting Date", "Entry Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        cuVFMgt: Codeunit "Variable Field Management";
        cuLookupMgt: Codeunit LookUpManagement;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(cuVFMgt);
        exit(cuVFMgt.IsVFActive(Database::"Service Ledger Entry EDMS", intFieldNo));
    end;


    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Entry No."));
    end;


    procedure GetResourceTextFieldValue() ResourcesNo: Text[250]
    var
        DetServLedgEntry: Record "Det. Serv. Ledger Entry EDMS";
    begin
        DetServLedgEntry.Reset;
        DetServLedgEntry.SetRange("Service Ledger Entry No.", "Entry No.");
        if DetServLedgEntry.FindSet then
            repeat
                ResourcesNo += DetServLedgEntry."Resource No." + ',';
            until DetServLedgEntry.Next = 0;
        if StrLen(ResourcesNo) > 1 then
            ResourcesNo := CopyStr(ResourcesNo, 1, StrLen(ResourcesNo) - 1);
    end;


    procedure ShowDetLedgEntries()
    var
        DetLedgEntry: Record "Det. Serv. Ledger Entry EDMS";
    begin
        DetLedgEntry.Reset;
        DetLedgEntry.SetRange("Service Ledger Entry No.", "Entry No.");
        if (Type = Type::Labor) then
            Page.RunModal(Page::"Det. Serv. Ledger Entries EDMS", DetLedgEntry);
    end;
}

