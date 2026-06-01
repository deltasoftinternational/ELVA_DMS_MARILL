Table 25006150 "Posted Serv. Order Line"
{
    // 06.12.2017 EB.P7 #T007
    //   Removed field "Product Subgroup Code"
    // 
    // 04.10.2017 EB.AKR Warranty
    //   Added field:
    //     51212:"Labor Type"
    // 
    // 12.05.2015 EB.P30 #T030
    //   Added field:
    //     "Resource Cost Amount"
    // 
    // 19.06.2014 Elva Baltic P8 #F0005 EDMS7.10
    //   * Increased size of Resources field
    // 
    // 22.05.2014 EDMS P8
    //   * MERGE with last changes
    // 
    // 2012.09.14 EDMS P8
    //   * Added fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management, added fields:
    //   *   Vehicle Axle Code
    //   *   Tire Position Code
    //   *   Tire Code
    //   *   Tire Entry
    //   *   Vehicle Serial No.
    // 
    // 05.08.2008. EDMS P2
    //   * Added functions
    //        FilterPstdDocLineValueEntries
    //        CalcVATAmountLines
    // 
    // 05.04.2008. EDMS P2
    //   * Added new field Finished Quantity (Hours)
    // 
    // //09-02-2007 EDMS P3
    //   Added new fields: Job. No.   (Nonposted line also)
    // //15-02-2007 EDMS P3
    //   Changed field  25006700 From Ordering Price Type Code (Option) To Ordering Price Type Code (Code10)

    Caption = 'Posted Serv. Order Line';
    PasteIsValid = false;

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Posted Serv. Order Header"."No.";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Comment,G/L Account,Item,Labor,External Service,Resource';
            OptionMembers = Comment,"G/L Account",Item,Labor,"External Service",Resource;
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(Comment)) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item where("Make Code" = field("Make Code"))
            else
            if (Type = const(Labor)) "Service Labor" where("Make Code" = field("Make Code"))
            else
            if (Type = const("External Service")) "External Service";
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(13; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
        }
        field(25; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(29; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(30; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(32; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(42; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            Editable = false;
            TableRelation = "Customer Price Group";
        }
        field(67; "Profit %"; Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer."No.";
        }
        field(69; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
        }
        field(71; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
        }
        field(72; "Purch. Order Line No."; Integer)
        {
            Caption = 'Purch. Order Line No.';
            Editable = false;
            TableRelation = if ("Drop Shipment" = const(true)) "Purchase Line"."Line No." where("Document No." = field("Purchase Order No."));
        }
        field(73; "Drop Shipment"; Boolean)
        {
            Caption = 'Drop Shipment';
            Editable = true;
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(77; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(80; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            Editable = false;
            TableRelation = "Sales Line"."Line No." where("Document No." = field("Document No."));
        }
        field(85; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(86; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(87; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(89; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(90; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(91; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(95; "Reserved Quantity"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry".Quantity where("Source Type" = const(25006150),
                                                                   "Source ID" = field("Document No."),
                                                                   "Source Ref. No." = field("Line No."),
                                                                   "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(96; Reserve; Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(99; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(100; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(103; "Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount';
        }
        field(104; "VAT Difference"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(106; "VAT Identifier"; Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("No."));
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5405; Planned; Boolean)
        {
            Caption = 'Planned';
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            "Unit of Measure";
        }
        field(5415; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(5495; "Reserved Qty. (Base)"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Source Type" = const(25006150),
                                                                            "Source ID" = field("Document No."),
                                                                            "Source Ref. No." = field("Line No."),
                                                                            "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(5702; "Substitution Available"; Boolean)
        {
            CalcFormula = exist("Item Substitution" where(Type = const(Item),
                                                           "No." = field("No."),
                                                           "Substitute Type" = const(Item)));
            Caption = 'Substitution Available';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5703; "Originally Ordered No."; Code[20])
        {
            Caption = 'Originally Ordered No.';
            TableRelation = if (Type = const(Item)) Item;
        }
        field(5704; "Originally Ordered Var. Code"; Code[10])
        {
            Caption = 'Originally Ordered Var. Code';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("Originally Ordered No."));
        }
        field(5706; "Unit of Measure (Cross Ref.)"; Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(5709; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5710; Nonstock; Boolean)
        {
            Caption = 'Nonstock';
            Editable = false;
        }
        field(5711; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
        }
        field(5712; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
        }
        field(5713; "Special Order"; Boolean)
        {
            Caption = 'Special Order';
            Editable = false;
        }
        field(5714; "Special Order Purchase No."; Code[20])
        {
            Caption = 'Special Order Purchase No.';
        }
        field(5715; "Special Order Purch. Line No."; Integer)
        {
            Caption = 'Special Order Purch. Line No.';
            TableRelation = if ("Special Order" = const(true)) "Purchase Line"."Line No." where("Document No." = field("Special Order Purchase No."));
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(5794; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7002; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(51212; "Labor Type"; Option)
        {
            Caption = 'Labor Type';
            OptionCaption = 'Labor,Travel Time,Travel Distance,Travel Other,Meal Allowance,Other';
            OptionMembers = Labor,"Travel Time","Travel Distance","Travel Other","Meal Allowance",Other;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006005; "Minutes Per UoM"; Decimal)
        {
            Caption = 'Minutes Per UoM';
            Editable = false;
        }
        field(25006006; "Quantity (Hours)"; Decimal)
        {
            Caption = 'Quantity (Hours)';
            Editable = false;
        }
        field(25006015; Prepayment; Boolean)
        {
            Caption = 'Prepayment';
        }
        field(25006030; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006100; "Vehicle Axle Code"; Code[10])
        {
            Caption = 'Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(25006110; "Tire Position Code"; Code[10])
        {
            Caption = 'Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                "Axle Code" = field("Vehicle Axle Code"));
        }
        field(25006120; "Tire Code"; Code[20])
        {
            Caption = 'Tire Code';
            TableRelation = Tire.Code;
        }
        field(25006125; "Tire Operation Type"; Option)
        {
            Caption = 'Tire Operation Type';
            OptionCaption = ' ,Put on,Take off,Position Change';
            OptionMembers = " ","Put on","Take off","Position Change";
        }
        field(25006126; "New Vehicle Axle Code"; Code[10])
        {
            Caption = 'New Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(25006127; "New Tire Position Code"; Code[10])
        {
            Caption = 'New Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                "Axle Code" = field("Vehicle Axle Code"));
        }
        field(25006128; "Tire Description"; Text[250])
        {
            CalcFormula = lookup(Tire.Description where(Code = field("Tire Code")));
            Caption = 'Tire Description';
            FieldClass = FlowField;
        }
        field(25006130; "Ext. Service Tracking No."; Code[20])
        {
            Caption = 'Ext. Service Tracking No.';
            TableRelation = if (Type = filter("External Service")) "External Serv. Tracking No."."External Serv. Tracking No." where("External Service No." = field("No."));
        }
        field(25006140; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(25006150; "Standard Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(25006160; "Standard Time Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Standard Time Line No.';
            Editable = false;
        }
        field(25006190; "Cause Code"; Code[20])
        {
            Caption = 'Cause Code';
        }
        field(25006200; "Package Type"; Option)
        {
            Caption = 'Package Type';
            OptionCaption = 'Package,Service Package,Instruction';
            OptionMembers = Package,"Service Package",Instruction;
        }
        field(25006210; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            TableRelation = "Service Package"."No.";
        }
        field(25006220; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006250; "Service Work Shift Code"; Code[10])
        {
            Caption = 'Service Work Shift Code';
            TableRelation = "Service Package";
        }
        field(25006290; Number; Decimal)
        {
            BlankZero = true;
            Caption = 'Number';
            DecimalPlaces = 0 : 2;
        }
        field(25006300; "Package Version No."; Integer)
        {
            Caption = 'Package Version No.';
            TableRelation = "Service Package Version"."Version No." where("Package No." = field("Package No."));
        }
        field(25006310; "Package Version Spec. Line No."; Integer)
        {
            Caption = 'Package Version Spec. Line No.';
            NotBlank = true;
            TableRelation = "Service Package Version Line"."Line No." where("Package No." = field("Package No."),
                                                                             "Version No." = field("Package Version No."));
        }
        field(25006373; VIN; Code[20])
        {
            Caption = 'VIN';
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006440; "Fixed Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Fixed Price';
            Editable = false;
        }
        field(25006520; "Purchase Receipt"; Code[20])
        {
            Caption = 'Purchase Receipt';
            Editable = false;
        }
        field(25006530; "Purch. Rcpt. Line"; Integer)
        {
            Caption = 'Purch. Rcpt. Line';
            Editable = false;
        }
        field(25006600; "Payer Part %"; Decimal)
        {
            Caption = 'Payer Part %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type';
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006150,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Recall Campaign Types", FieldNo("Variable Field 25006800"),
                  '', "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006150,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Recall Campaign Types", FieldNo("Variable Field 25006801"),
                  '', "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006150,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Recall Campaign Types", FieldNo("Variable Field 25006802"),
                  '', "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25007110; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." where("Bill-to Customer No." = field("Bill-to Customer No."));
        }
        field(25007120; Resources; Code[250])
        {
            Caption = 'Resources';
        }
        field(25007130; "Transfer Document No."; Code[20])
        {
            Caption = 'Transfer Document No.';
        }
        field(25007150; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No." where("Bill-to Customer No." = field("Bill-to Customer No."));
        }
        field(25007180; Split; Boolean)
        {
            Caption = 'Split';
        }
        field(25007200; "Finished Quantity (Hours)"; Decimal)
        {
            CalcFormula = sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" where("Document No." = field("Document No."),
                                                                                                  "Document Line No." = field("Line No.")));
            Caption = 'Finished Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007210; "Remaining Quantity (Hours)"; Decimal)
        {
            CalcFormula = sum("Serv. Labor Alloc. Application"."Remaining Quantity (Hours)" where("Document No." = field("Document No."),
                                                                                                   "Document Line No." = field("Line No.")));
            Caption = 'Remaining Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007240; "Plan No."; Code[10])
        {
            Caption = 'Plan No.';
            TableRelation = "Vehicle Service Plan"."No." where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(25007245; "Plan Stage Recurrence"; Integer)
        {
            Caption = 'Plan Stage Recurrence';
        }
        field(25007250; "Plan Stage Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = "Vehicle Service Plan Stage".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                     "Plan No." = field("Plan No."));
        }
        field(25007260; "Resource Cost Amount"; Decimal)
        {
            Caption = 'Resource Cost Amount';
        }
        //DELTA 01
        field(25007282; "Transfer From Location Code"; Code[20])
        {
            Caption = 'Transfer From Location Code';

        }
        //DELTA 01
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
            SumIndexFields = Amount, "Amount Including VAT";
        }
        key(Key2; Resources, Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "Capable to Promise";
    begin
    end;

    trigger OnInsert()
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
    end;

    var
        VFMgt: Codeunit "Variable Field Management";
        LookUpMgt: Codeunit LookUpManagement;
        DimMgt: Codeunit DimensionManagement;


    procedure FilterPstdDocLineValueEntries(var ValueEntry: Record "Value Entry")
    var
        SalesInvHdr: Record "Sales Invoice Header";
    begin
        SalesInvHdr.Reset;
        SalesInvHdr.SetCurrentkey("Service Order No.", "Service Document");
        SalesInvHdr.SetRange("Service Order No.", "Document No.");
        SalesInvHdr.SetRange("Service Document", true);
        if SalesInvHdr.FindFirst then;

        ValueEntry.Reset;
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.", SalesInvHdr."No.");
        ValueEntry.SetRange("Document Type", ValueEntry."document type"::"Sales Invoice");
        ValueEntry.SetRange("Document Line No.", "Line No.");
    end;


    procedure CalcVATAmountLines(var PostServOrd: Record "Posted Serv. Order Header"; var VATAmountLine: Record "VAT Amount Line")
    begin
        VATAmountLine.DeleteAll;
        SetRange("Document No.", PostServOrd."No.");
        if FindSet then
            repeat
                VATAmountLine.Init;
                VATAmountLine."VAT Identifier" := "VAT Identifier";
                VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                VATAmountLine."Tax Group Code" := "Tax Group Code";
                VATAmountLine."VAT %" := "VAT %";
                VATAmountLine."VAT Base" := Amount;
                VATAmountLine."VAT Amount" := "Amount Including VAT" - Amount;
                VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                VATAmountLine."Line Amount" := "Line Amount";
                if "Allow Invoice Disc." then
                    VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                //VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                VATAmountLine.Quantity := "Quantity (Base)";
                VATAmountLine."Calculated VAT Amount" := "Amount Including VAT" - Amount - "VAT Difference";
                VATAmountLine."VAT Difference" := "VAT Difference";
                VATAmountLine.InsertLine;
            until Next = 0;
    end;


    procedure ShowItemTrackingLines()
    var
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
    begin
        //ItemTrackingMgt.CallPostedItemTrackingForm3(RowID1); //from merge
        ItemTrackingDocMgt.ShowItemTrackingForInvoiceLine(RowID1);
    end;


    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        SalesInvLine: Record "Sales Invoice Line";
        PostedServHdr: Record "Posted Serv. Order Header";
    begin
        if not PostedServHdr.Get("Document No.") then
            exit;
        SalesInvLine.SetCurrentkey("Service Order No. EDMS", "Service Order Line No. EDMS");
        SalesInvLine.SetRange("Service Order No. EDMS", PostedServHdr."Order No.");
        SalesInvLine.SetRange("Service Order Line No. EDMS", "Line No.");
        if not SalesInvLine.FindFirst then
            exit;

        exit(ItemTrackingMgt.ComposeRowID(Database::"Sales Invoice Line",
          0, SalesInvLine."Document No.", '', 0, SalesInvLine."Line No."));
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Recall Campaign Types", intFieldNo));
    end;


    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', TableCaption, "Document No.", "Line No."));
    end;
}

