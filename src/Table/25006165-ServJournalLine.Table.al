//>>DELTA 01 RC (15/02/2022) Correction clee primaire
Table 25006165 "Serv. Journal Line"
{
    // 06.10.2017 EB.AKR Warranty
    //   Added fields:
    //     51212 "Labor Type"
    //     51240 "Initial Service Order No."
    // 
    // 12.06.2013 EDMS P8
    //   * Merged code with NAV2009
    // 
    // 2012.07.31 EDMS, P8
    //   * changed type of field 'Variable Field Run 1' - now it is decimal
    //   * added fields: 'Variable Field Run 2', 'Variable Field Run 3', 'Document Line No.', 'Plan No.'
    // 
    // 2012.04.12 EDMS P8
    //   * removed field "Resource No."(580)
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management, added fields:
    //   *   Vehicle Axle Code
    //   *   Tire Position Code
    //   *   Tire Code
    //   *   Tire Entry
    // 
    // 14.12.2011 EDMS P8
    //   * MATH DIVIDE must checked for zero before act
    // 
    // 07.11.2011 EDMS P8
    //   * VALIDATION triggers are recoded
    // 
    // 28.01.2010 EDMSB P2
    //   * Added field "Standard Time", "Campaign No.", "Amount Including VAT (LCY)"
    // 
    // 20.10.2008. EDMS P2
    //   * Added field "Deal Type Code"
    // 
    // 05.03.2008 EDMS P2
    //   * Added fields "Package No."
    //                  "Package Version No."
    //                  "Package Version Spec. Line No."
    // 
    // * Serial No. - onvalidate
    // Working with dimensions is disabled (need to think about how to realize it)
    // See another validates also

    Caption = 'Serv. Journal Line';

    fields
    {
        field(10; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Serv. Journal Template";
        }
        field(20; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Serv. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(40; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Usage,Sale,Info';
            OptionMembers = Usage,Sale,Info;
        }
        field(50; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Order,Invoice,Credit Memo,Blanket Order,Return Order,Payment,Refund';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order",Payment,Refund;
        }
        field(60; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(70; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                Validate("Document Date", "Posting Date");
                if "Posting Date" <> xRec."Posting Date" then begin
                    InitRates;
                    "Amount (LCY)" := ROUND(Amount / FCYRate, LCYRoundingPrecision);
                    "Line Discount Amount (LCY)" := ROUND("Line Discount Amount" / FCYRate, LCYRoundingPrecision);
                    "Inv. Discount Amount (LCY)" := ROUND("Inv. Discount Amount" / FCYRate, LCYRoundingPrecision);
                end;
            end;
        }
        field(80; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            begin
                Veh.Get("Vehicle Serial No.");
                Veh.CalcFields("Model Commercial Name");

                Description := Veh."Model Commercial Name";

                Veh.TestField(Blocked, false);

                "Make Code" := Veh."Make Code";
                "Model Code" := Veh."Model Code";
                "Model Version No." := Veh."Model Version No.";

                if Item.Get("Model Version No.") then begin
                    "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                    Validate("Unit of Measure Code", Item."Base Unit of Measure");
                end;
                /*
                  CreateDim(
                    DATABASE::Make,"Make Code",
                    DATABASE::Model,"Model Code",
                    DATABASE::Job,"Job No.");
                */

            end;
        }
        field(90; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(100; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(110; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));

            trigger OnLookup()
            var
                recItem: Record Item;
                LookupMgt: Codeunit LookUpManagement;
            begin
                recItem.Reset;
                if LookupMgt.LookUpModelVersion(recItem, "Model Version No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", recItem."No.");
            end;
        }
        field(115; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle";
        }
        field(120; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(130; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(140; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            var
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
                Validate(Quantity);
            end;
        }
        field(150; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                Validate("Unit Cost");
                Validate("Unit Price");

                UpdateQtyHours(0);
            end;
        }
        field(160; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                InitRates;
                "Total Cost" := ROUND(Quantity * "Unit Cost", LCYRoundingPrecision);
            end;
        }
        field(170; "Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';

            trigger OnValidate()
            begin
                InitRates;
                if "Unit Cost" = 0 then
                    if Quantity <> 0 then
                        "Unit Cost" := ROUND("Total Cost" / Quantity, LCYRoundingPrecisionUnit);
            end;
        }
        field(180; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                InitRates;
                Amount := ROUND(Quantity * "Unit Price", RoundingPrecision);
                if FCYRate <> 0 then
                    "Amount (LCY)" := ROUND(Amount / FCYRate, LCYRoundingPrecision);
            end;
        }
        field(190; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';

            trigger OnValidate()
            begin
                InitRates;
                if "Unit Price" = 0 then begin
                    if Quantity <> 0 then
                        "Unit Price" := ROUND(Amount / Quantity, RoundingPrecisionUnit);
                    if FCYRate <> 0 then
                        "Amount (LCY)" := ROUND(Amount / FCYRate, LCYRoundingPrecision);
                end;
            end;
        }
        field(191; "Discount %"; Decimal)
        {
            Caption = 'Discount %';

            trigger OnValidate()
            begin
                InitRates;
                "Line Discount Amount" := ROUND(Quantity * "Discount %", RoundingPrecision);
                if FCYRate <> 0 then
                    "Line Discount Amount (LCY)" := ROUND("Line Discount Amount" / FCYRate, LCYRoundingPrecision);
            end;
        }
        field(192; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            begin
                InitRates;
                if "Discount %" = 0 then
                    if Quantity <> 0 then begin
                        "Discount %" := ROUND(("Line Discount Amount" / Quantity) * 100, RoundingPrecisionUnit);
                        if FCYRate <> 0 then
                            "Line Discount Amount (LCY)" := ROUND("Line Discount Amount" / FCYRate, LCYRoundingPrecision);
                    end;
            end;
        }
        field(193; "Line Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';

            trigger OnValidate()
            begin
                InitRates;
                if ("Discount %" = 0) or ("Line Discount Amount" = 0) then begin
                    "Line Discount Amount" := ROUND("Line Discount Amount (LCY)" * FCYRate, LCYRoundingPrecision);
                    if Quantity <> 0 then
                        "Discount %" := ROUND(("Line Discount Amount" / Quantity) * 100, RoundingPrecisionUnit);
                end;
            end;
        }
        field(195; "Inv. Discount Amount"; Decimal)
        {
            Caption = 'Inv. Discount Amount';

            trigger OnValidate()
            begin
                InitRates;
                if FCYRate <> 0 then
                    "Inv. Discount Amount (LCY)" := ROUND("Inv. Discount Amount" / FCYRate, LCYRoundingPrecision);
            end;
        }
        field(196; "Inv. Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Inv. Discount Amount (LCY)';

            trigger OnValidate()
            begin
                InitRates;
                if "Line Discount Amount" = 0 then
                    "Line Discount Amount" := ROUND("Line Discount Amount (LCY)" * FCYRate, LCYRoundingPrecision);
            end;
        }
        field(197; "Amount Including VAT (LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
        }
        field(198; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(199; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';

            trigger OnValidate()
            begin
                InitRates;
                if Amount = 0 then
                    Amount := ROUND("Amount (LCY)" * FCYRate, LCYRoundingPrecision);
                if "Unit Price" = 0 then
                    if Quantity <> 0 then
                        "Unit Price" := ROUND(Amount / Quantity, RoundingPrecisionUnit);
            end;
        }
        field(200; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(210; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(220; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(230; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(240; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(250; "Recurring Method"; Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(260; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(270; "Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
        }
        field(280; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(290; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(300; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(310; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(320; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(330; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(340; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service,Resource';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service",Resource;
        }
        field(350; "No."; Code[20])
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
            if (Type = const("External Service")) "External Service";

            trigger OnLookup()
            var
                Item: Record Item;
                Labor: Record "Service Labor";
                ExternalService: Record "External Service";
                GLAccount: Record "G/L Account";
                ServiceHeader: Record "Service Header EDMS";
                StandardText: Record "Standard Text";
                LookUpMgt: Codeunit LookUpManagement;
            begin
                // ,G/L Account,Item,Labor,External Service
                case Type of
                    Type::" ":
                        begin
                            StandardText.Reset;
                            if LookUpMgt.LookUpStandardText(StandardText, "No.") then
                                Validate("No.", StandardText.Code);
                        end;

                    Type::"G/L Account":
                        begin
                            GLAccount.Reset;
                            if LookUpMgt.LookUpGLAccount(GLAccount, "No.") then
                                Validate("No.", GLAccount."No.");
                        end;

                    Type::Item:
                        begin
                            Item.Reset;
                            if LookUpMgt.LookUpItemREZ(Item, "No.") then
                                Validate("No.", Item."No.");
                        end;

                    Type::Labor:
                        begin
                            Labor.Reset;
                            Labor.SetCurrentkey("Make Code");
                            Labor.SetFilter("Make Code", '''''|%1', "Make Code");
                            if LookUpMgt.LookUpLabor(Labor, "No.") then
                                Validate("No.", Labor."No.");
                        end;

                    Type::"External Service":
                        begin
                            ExternalService.Reset;
                            if LookUpMgt.LookUpExternalService(ExternalService, "No.") then
                                Validate("No.", ExternalService."No.");
                        end;
                end;
            end;

            trigger OnValidate()
            var
                ItemTranslation: Record "Item Translation";
                StandardText: Record "Standard Text";
                Language: Record Language;
                ServicePostEDMS: codeunit "Service-Post EDMS";
            begin
                case Type of
                    Type::" ":
                        begin
                            StandardText.Get("No.");
                            Description := StandardText.Description;
                        end;

                    Type::"G/L Account":
                        begin
                            GLAcc.Get("No.");
                            GLAcc.CheckGLAcc;
                            GLAcc.TestField("Direct Posting", true);
                            Description := GLAcc.Name;

                            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                            if "Gen. Bus. Posting Group" = '' then
                                "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                        end;

                    Type::Item:
                        begin
                            GetItem;
                            Item.TestField(Blocked, false);
                            Item.TestField("Inventory Posting Group");
                            Item.TestField("Gen. Prod. Posting Group");
                            Language.SetCurrentkey("Windows Language ID");
                            Language.SetRange("Windows Language ID", WindowsLanguage);
                            Language.FindFirst;
                            //>>DELTA 01 
                            if ItemTranslation.Get(Item."No.", '', Language.Code) then
                                Description := ItemTranslation.Description
                            else
                                Description := Item.Description;

                            GetUnitCost;
                            "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";

                            "Unit of Measure Code" := Item."Sales Unit of Measure";
                        end;

                    Type::Labor:
                        begin
                            Labor.Get("No.");
                            Labor.TestField(Blocked, false);
                            Labor.TestField("Gen. Prod. Posting Group");
                            Labor.TestField("VAT Prod. Posting Group");

                            Description := Labor.Description;
                            //Get description from Service Labor Text
                            GetDescriptionFromLaborText("No.", "Vehicle Serial No.");

                            "Unit of Measure Code" := Labor."Unit of Measure Code";
                            "Gen. Prod. Posting Group" := Labor."Gen. Prod. Posting Group";

                            ServiceSetup.Get;
                            if not ServiceSetup."Quantity Equals Standard Time" then
                                Validate(Quantity, 1)
                            else
                                GetStandardTime;
                        end;

                    Type::"External Service":
                        begin
                            ExternalService.Get("No.");
                            ExternalService.TestField(Blocked, false);
                            ExternalService.TestField("Gen. Prod. Posting Group");
                            ExternalService.TestField("VAT Prod. Posting Group");
                            Description := ExternalService.Description;
                            "Gen. Prod. Posting Group" := ExternalService."Gen. Prod. Posting Group";
                            "Unit of Measure Code" := ExternalService."Unit of Measure Code";
                        end;
                end;
                if Type <> Type::" " then begin
                    Validate("Gen. Prod. Posting Group");
                    Validate("Unit of Measure Code");
                end;

                CreateDim(
                  ServicePostEDMS.EDMSTypeToTableID5(Type), "No.",
                  0, '',
                  0, '',
                  0, '');

                GetVehicleVariableFields("Vehicle Serial No.");
            end;
        }
        field(360; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Customer.Get("Customer No.") then
                    if "Gen. Bus. Posting Group" = '' then
                        "Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
            end;
        }
        field(361; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Customer.Get("Bill-to Customer No.") then
                    "Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
            end;
        }
        field(362; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                InitRates;
                if FCYRate <> 0 then
                    if "Unit Price" = 0 then begin
                        "Amount (LCY)" := ROUND(Amount / FCYRate, LCYRoundingPrecision);
                        "Line Discount Amount (LCY)" := ROUND("Line Discount Amount" / FCYRate, LCYRoundingPrecision);
                        "Inv. Discount Amount (LCY)" := ROUND("Inv. Discount Amount" / FCYRate, LCYRoundingPrecision);
                        "Amount Including VAT (LCY)" := ROUND("Amount Including VAT" / FCYRate, LCYRoundingPrecision);
                    end;
            end;
        }
        field(390; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(400; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(410; "Pre-Assigned No."; Code[20])
        {
            Caption = 'Previous Document No.';
        }
        field(420; "Service Receiver"; Code[20])
        {
            Caption = 'Service Receiver';
            TableRelation = "Salesperson/Purchaser";
        }
        field(430; "Service Order Type"; Code[10])
        {
            Caption = 'Service Order Type';
            TableRelation = "Service Order Type";
        }
        field(440; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            TableRelation = "Service Header"."No." where("Document Type" = const(Order));
        }
        field(450; "Cust. Ledger Entry No."; Integer)
        {
            Caption = 'Cust. Ledger Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(460; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
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
        field(570; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006165,570';
        }
        field(580; "Variable Field Run 2"; Decimal)
        {
            CaptionClass = '7,25006165,580';
        }
        field(590; "Variable Field Run 3"; Decimal)
        {
            CaptionClass = '7,25006165,590';
        }
        field(51212; "Labor Type"; Option)
        {
            Caption = 'Labor Type';
            OptionCaption = 'Labor,Travel Time,Travel Distance,Travel Other,Meal Allowance,Other';
            OptionMembers = Labor,"Travel Time","Travel Distance","Travel Other","Meal Allowance",Other;
        }
        field(51240; "Initial Service Order No."; Code[20])
        {
            Caption = 'Initial Service Order No.';
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
        }
        field(25006005; "Minutes Per UoM"; Decimal)
        {
            Caption = 'Minutes Per UoM';

            trigger OnValidate()
            begin
                UpdateQtyHours(0);
            end;
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
        field(25006150; "Standard Time"; Decimal)
        {
            Caption = 'Standard Time';
            DecimalPlaces = 0 : 5;
        }
        field(25006210; "Package No."; Code[250])
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
            CaptionClass = '7,25006165,25006800';

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
            CaptionClass = '7,25006165,25006801';

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
            CaptionClass = '7,25006165,25006802';

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
        field(25006820; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            Description = 'at begin holds line No. of order only';
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
        }
        field(25007250; "Plan Stage Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = "Vehicle Service Plan Stage".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                     "Plan No." = field("Plan No."));
        }
        field(25007251; "Service Address Code"; Code[10])
        {
            Caption = 'Service Address Code';
            TableRelation = "Ship-to Address";
        }
        field(25007252; "Service Address"; Text[100])
        {
            Caption = 'Service Address';
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // 26.10.2012 EDMS <<
        /*
        DimMgt.DeleteJnlLineDim(
          DATABASE::"Serv. Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0);
        */
        // 26.10.2012 EDMS <<

    end;

    trigger OnInsert()
    begin
        LockTable;
        ServJnlTemplate.Get("Journal Template Name");
        ServJnlBatch.Get("Journal Template Name", "Journal Batch Name");

        ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
        // 26.10.2012 EDMS >>
        /*
        DimMgt.InsertJnlLineDim(
          DATABASE::"Serv. Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        */
        // 26.10.2012 EDMS <<

    end;

    var
        ServJnlTemplate: Record "Serv. Journal Template";
        ServJnlBatch: Record "Serv. Journal Batch";
        ServJnlLine: Record "Serv. Journal Line";
        Veh: Record Vehicle;
        Customer: Record Customer;
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        Labor: Record "Service Labor";
        UnitOfMeasure: Record "Unit of Measure";
        ResFindUnitCost: Codeunit "Resource-Find Cost";
        ResFindUnitPrice: Codeunit "Resource-Find Price";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        GLSetupRead: Boolean;
        Item: Record Item;
        cuVFMgt: Codeunit "Variable Field Management";
        cuLookupMgt: Codeunit LookUpManagement;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ExternalService: Record "External Service";
        Currency: Record Currency;
        RoundingPrecision: Decimal;
        LCYRoundingPrecision: Decimal;
        RoundingPrecisionUnit: Decimal;
        LCYRoundingPrecisionUnit: Decimal;
        FCYRate: Decimal;


    procedure EmptyLine(): Boolean
    begin
        exit(Type = Type::" ");
    end;


    procedure SetUpNewLine(LastServJnlLine: Record "Serv. Journal Line")
    begin
        ServJnlTemplate.Get("Journal Template Name");
        ServJnlBatch.Get("Journal Template Name", "Journal Batch Name");
        ServJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        ServJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if ServJnlLine.FindFirst then begin
            "Posting Date" := LastServJnlLine."Posting Date";
            "Document Date" := LastServJnlLine."Posting Date";
            "Document No." := LastServJnlLine."Document No.";
        end else begin
            "Posting Date" := WorkDate;
            "Document Date" := WorkDate;
            if ServJnlBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                "Document No." := NoSeriesMgt.PeekNextNo(ServJnlBatch."No. Series", "Posting Date");
            end;
        end;
        "Recurring Method" := LastServJnlLine."Recurring Method";
        "Source Code" := ServJnlTemplate."Source Code";
        "Reason Code" := ServJnlBatch."Reason Code";
        "Posting No. Series" := ServJnlBatch."Posting No. Series";
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20])
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        Dimsource: List of [Dictionary of [Integer, code[20]]];
    begin
        /*  TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;*/
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Type1, No1);
        DimMgt.AddDimSource(Dimsource, Type2, No2);
        DimMgt.AddDimSource(Dimsource, Type3, No3);
        DimMgt.GetDefaultDimID(
          Dimsource, "Source Code",
          "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure InitRates()
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        GetGLSetup;
        LCYRoundingPrecision := GLSetup."Amount Rounding Precision";
        LCYRoundingPrecisionUnit := GLSetup."Unit-Amount Rounding Precision";
        if Currency.Get("Currency Code") then begin
            RoundingPrecision := Currency."Amount Rounding Precision";
            RoundingPrecisionUnit := Currency."Unit-Amount Rounding Precision";
        end;
        if RoundingPrecision = 0 then begin
            RoundingPrecision := LCYRoundingPrecision;
            RoundingPrecisionUnit := LCYRoundingPrecisionUnit
        end;
        if not (("Currency Code" = '') or ("Currency Code" = GLSetup."LCY Code")) then
            FCYRate := CurrencyExchangeRate.ExchangeRate("Posting Date", "Currency Code")
        else
            FCYRate := 1;
        if FCYRate = 0 then
            FCYRate := 1;
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(cuVFMgt);
        exit(cuVFMgt.IsVFActive(Database::"Serv. Journal Line", intFieldNo));
    end;

    local procedure GetItem()
    begin
        TestField("No.");
        if "No." <> Item."No." then
            Item.Get("No.");
    end;

    local procedure GetUnitCost()
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        GetItem;
        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
        Validate("Unit Cost", Item."Unit Cost" * "Qty. per Unit of Measure");
    end;


    procedure GetStandardTime()
    var
        ServiceLaborStandardTime: Record "Service Labor Standard Time";
        Vehicle: Record Vehicle;
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        FieldRef1: FieldRef;
        FieldRef2: FieldRef;
        VFUsage1: Record "Variable Field Usage";
        VFUsage2: Record "Variable Field Usage";
        LookUpMgt: Codeunit LookUpManagement;
        VariableField: Record "Variable Field";
    begin
        Vehicle.Reset;
        if "Vehicle Serial No." <> '' then
            Vehicle.Get("Vehicle Serial No.");

        ServiceLaborStandardTime.SetFilter("Labor No.", "No.");
        if ServiceLaborStandardTime.IsEmpty then
            exit;

        ServiceLaborStandardTime.SetFilter("Make Code", '''''|%1', "Make Code");
        ServiceLaborStandardTime.SetFilter("Model Code", '''''|%1', Vehicle."Model Code");

        ServiceLaborStandardTime.SetFilter("Prod. Year From", '..%1', Vehicle."Production Year");
        ServiceLaborStandardTime.SetFilter("Prod. Year To", '''''|%1..', Vehicle."Production Year");

        RecordRef2.Open(Database::Vehicle);
        RecordRef2.GetTable(Vehicle);

        RecordRef1.Open(Database::"Service Labor Standard Time");

        VFUsage1.Reset;
        VFUsage1.SetRange("Table No.", Database::"Service Labor Standard Time");
        if VFUsage1.FindFirst then
            repeat
                VFUsage2.Reset;
                VFUsage2.SetCurrentkey("Variable Field Code");
                VFUsage2.SetRange("Table No.", Database::Vehicle);
                VFUsage2.SetRange("Variable Field Code", VFUsage1."Variable Field Code");
                if VFUsage2.FindFirst then begin
                    VariableField.Get(VFUsage1."Variable Field Code");
                    if VariableField."Use In Filtering" then begin
                        FieldRef1 := RecordRef2.Field(VFUsage2."Field No.");
                        RecordRef1.SetView(ServiceLaborStandardTime.GetView);
                        FieldRef2 := RecordRef1.Field(VFUsage1."Field No.");
                        FieldRef2.SetFilter('''''|%1', Format(FieldRef1.Value));
                        ServiceLaborStandardTime.SetView(RecordRef1.GetView);
                    end;
                end;
            until VFUsage1.Next = 0;

        if ServiceLaborStandardTime.Count > 1 then begin
            if LookUpMgt.LookUpLaborStandardTime(ServiceLaborStandardTime, "Make Code", "No.", 0) then begin
                Validate(Quantity, ServiceLaborStandardTime."Standard Time (Hours)");
            end;
        end else begin
            if ServiceLaborStandardTime.FindFirst then begin
                Validate(Quantity, ServiceLaborStandardTime."Standard Time (Hours)");
            end;
        end;
    end;


    procedure GetDescriptionFromLaborText(LaborNo: Code[20]; VehicleSerialNo: Code[20])
    var
        VariableFieldUsage: Record "Variable Field Usage";
        ServLaborText: Record "Service Labor Text";
        VehicleLoc: Record Vehicle;
        VariableValue: Text[30];
    begin
        ServLaborText.Reset;
        ServLaborText.SetRange("Service Labor No.", LaborNo);

        if not VehicleLoc.Get(VehicleSerialNo) then
            exit;

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Labor Text");
        VariableFieldUsage.SetRange("Field No.", 25006800);
        if VariableFieldUsage.FindFirst then begin
            VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
            if VariableValue <> '' then
                ServLaborText.SetRange("Variable Field 25006800", VariableValue);
        end;

        VariableFieldUsage.SetRange("Field No.", 25006801);
        if VariableFieldUsage.FindFirst then begin
            VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
            if VariableValue <> '' then
                ServLaborText.SetRange("Variable Field 25006801", VariableValue);
        end;

        if ServLaborText.FindFirst then begin
            Description := ServLaborText.Description;
        end;
    end;


    procedure GetVariableValue(Vehicle: Record Vehicle; "Field": Text[30]) FieldValue: Text[30]
    var
        RecordRef1: RecordRef;
        FieldRef1: FieldRef;
        VariableFieldUsage: Record "Variable Field Usage";
    begin
        FieldValue := '';

        if Field = '' then
            exit;

        RecordRef1.Open(Database::Vehicle);
        RecordRef1.GetTable(Vehicle);
        VariableFieldUsage.Reset;
        VariableFieldUsage.SetCurrentkey("Variable Field Code");
        VariableFieldUsage.SetRange("Table No.", Database::Vehicle);
        VariableFieldUsage.SetRange("Variable Field Code", Field);

        if VariableFieldUsage.FindFirst then begin
            FieldRef1 := RecordRef1.Field(VariableFieldUsage."Field No.");
            FieldValue := FieldRef1.Value;
        end;
        RecordRef1.SetTable(Vehicle);
    end;


    procedure GetVehicleVariableFields(VehicleSerialNo: Code[20])
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        VehicleLoc: Record Vehicle;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        VariableValue: Text[30];
    begin
        if not VehicleLoc.Get(VehicleSerialNo) then
            exit;
        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Line EDMS");
        if VariableFieldUsage.FindFirst then begin
            repeat
                VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
                if VariableValue <> '' then begin
                    case VariableFieldUsage."Field No." of
                        25006800:
                            "Variable Field 25006800" := VariableValue;
                        25006801:
                            "Variable Field 25006801" := VariableValue;
                        25006802:
                            "Variable Field 25006802" := VariableValue;
                    end;
                end;
            until VariableFieldUsage.Next = 0;
        end;
    end;


    procedure UpdateQtyHours(CalledByFieldNo: Integer)
    begin
        if CalledByFieldNo = 0 then
            CalledByFieldNo := CurrFieldNo;

        case Type of
            Type::Item:
                begin
                    exit;
                end;
            Type::"External Service", Type::Labor:
                begin
                    if CalledByFieldNo in [FieldNo("Unit of Measure Code"), FieldNo(Quantity), FieldNo("Minutes Per UoM"),
                        FieldNo("No.")] then begin
                        if CalledByFieldNo in [FieldNo("Unit of Measure Code"), FieldNo("No.")] then begin
                            if UnitOfMeasure.Get("Unit of Measure Code") then
                                "Minutes Per UoM" := UnitOfMeasure."Minutes Per UoM";
                        end;
                        "Quantity (Hours)" := (Quantity * "Minutes Per UoM") / 60;
                    end;
                end;
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1 %2 %3', "Journal Template Name", "Journal Batch Name", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;
}

