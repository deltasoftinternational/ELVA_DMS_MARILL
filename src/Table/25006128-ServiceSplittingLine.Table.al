Table 25006128 "Service Splitting Line"
{
    // 30.11.2023 EB.KN
    //   Modified procedure:
    //     ProceedDocSplit
    //       * Add restrictions not to split if no lines in new documents
    //       * Add restrictions not to split if item is in transfer
    //
    // 18.12.2014 Elva Baltic P21 #E0003
    //   Modified procedure:
    //     CreateNewAllocApp
    // 
    // 12.12.2014 EB.P8
    //   New concept of split - lighter
    // 
    // 10.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified function:
    //     CreateQuote
    // 
    // 06.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     50010 "Create Quote"
    //   Added functions:
    //     CreateLinesForQuote
    //     CreateQuote
    //     DeleteDocQuote
    //   Modified function:
    //     ProceedDocSplit
    //     ChangeIncludeInfo
    //     GetAdjustedQtyShare (fix error with division by zero)
    // 
    // 04.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified functions:
    //     ProceedDocSplit (correct error with amounts, discounts lost)
    // 
    // 21.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified functions:
    //     ProceedDocSplit
    //     ApplyInsertAsWholeDoc
    //     ApplyInsertAsHeaderByServDoc
    //   Added field:
    //     50000 Include
    // 
    // 02.07.2013 EDMS P8
    //   * fix in main process
    // 
    // 08.04.2013 EDMS P8
    //   * FIX in ProceedDocSplit
    // 
    // Concept for process "Document split":
    //   Split Lines should repeat source document and not able delete or add manually!
    // 
    // "Temp. Document No." - is used to hold add split documents for the same one

    Caption = 'Service Splitting Line';
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Return Order';
            OptionMembers = Quote,"Order","Return Order";
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if "Temp. Document No." = GetSourceTempDocNo then
                    Error(Text008);
                GetCust("Sell-to Customer No.");
                if Cust."Bill-to Customer No." <> '' then
                    Validate("Bill-to Customer No.", Cust."Bill-to Customer No.")
                else begin
                    if "Bill-to Customer No." = "Sell-to Customer No." then
                        SkipBillToContact := true;
                    Validate("Bill-to Customer No.", "Sell-to Customer No.");
                    SkipBillToContact := false;
                end;
                UpdateLines(FieldCaption("Sell-to Customer No."), CurrFieldNo <> 0);
            end;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Description = 'Source Document No.';
            TableRelation = "Service Header EDMS"."No." where("Document Type" = field("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(Labor)) "Service Labor"
            else
            if (Type = const("External Service")) "External Service";
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(8; "Temp. Document No."; Integer)
        {
            Caption = 'Temp. Document No.';
            Editable = false;

            trigger OnValidate()
            begin
                if "Temp. Document No." = 0 then begin
                    //  ServiceSplittingLine := Rec;

                    if Line then begin
                        if "Document No." = '' then begin
                            ServiceSplittingLine.Reset;
                            if ServiceSplittingLine.FindLast then begin
                                "Document No." := ServiceSplittingLine."Document No.";
                                "Temp. Document No." := ServiceSplittingLine."Temp. Document No.";
                            end;
                        end else begin
                            ServiceSplittingLine.Reset;
                            //ServiceSplittingLine.SETRANGE(Line, FALSE);
                            ServiceSplittingLine.SetRange("Document Type", "Document Type");
                            ServiceSplittingLine.SetRange("Document No.", "Document No.");
                            if ServiceSplittingLine.FindLast then
                                "Temp. Document No." := ServiceSplittingLine."Temp. Document No.";
                        end;
                    end else begin
                        if "Document No." = '' then begin
                            ServiceSplittingLine.Reset;
                            if ServiceSplittingLine.FindLast then begin
                                "Document No." := ServiceSplittingLine."Document No.";
                            end;
                        end;
                        ServiceSplittingLine.Reset;
                        //ServiceSplittingLine.SETRANGE(Line, FALSE);
                        ServiceSplittingLine.SetRange("Document Type", "Document Type");
                        ServiceSplittingLine.SetRange("Document No.", "Document No.");
                        if ServiceSplittingLine.FindLast then
                            "Temp. Document No." := ServiceSplittingLine."Temp. Document No.";
                        "Temp. Document No." += 10000;
                    end;
                    if "Temp. Document No." = 0 then
                        "Temp. Document No." := 10000;
                end;
            end;
        }
        field(9; "Temp. Line No."; Integer)
        {
            Caption = 'Temp. Line No.';
            Editable = false;

            trigger OnValidate()
            begin
                if "Temp. Line No." = 0 then begin
                    ServiceSplittingLine.Reset;
                    ServiceSplittingLine.SetRange("Document Type", "Document Type");
                    ServiceSplittingLine.SetRange("Document No.", "Document No.");
                    ServiceSplittingLine.SetRange("Temp. Document No.", "Temp. Document No.");
                    if ServiceSplittingLine.FindLast then
                        "Temp. Line No." := ServiceSplittingLine."Temp. Line No.";
                    "Temp. Line No." += 10000;
                end;
            end;
        }
        field(10; Line; Boolean)
        {
            Caption = 'Line';
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(13; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(16; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
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
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                if "Temp. Document No." = GetSourceTempDocNo then
                    Error(Text008);
                GetCust("Bill-to Customer No.");
                "Currency Code" := Cust."Currency Code";
                UpdateLines(FieldCaption("Bill-to Customer No."), CurrFieldNo <> 0);
            end;
        }
        field(69; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            Editable = false;
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
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if "Temp. Document No." = GetSourceTempDocNo then
                    Error(Text008);
                UpdateLines(FieldCaption("Currency Code"), CurrFieldNo <> 0);
            end;
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
        field(101; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(103; "Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            Caption = 'Line Amount';
        }
        field(104; "VAT Difference"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(105; "Inv. Disc. Amount to Invoice"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            Editable = false;
        }
        field(106; "VAT Identifier"; Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(109; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(110; "Prepmt. Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Line Amount"));
            Caption = 'Prepmt. Line Amount';
            MinValue = 0;
        }
        field(111; "Prepmt. Amt. Inv."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Amt. Inv."));
            Caption = 'Prepmt. Amt. Inv.';
            Editable = false;
        }
        field(112; "Prepmt. Amt. Incl. VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Incl. VAT';
            Editable = false;
        }
        field(113; "Prepayment Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount';
            Editable = false;
        }
        field(114; "Prepmt. VAT Base Amt."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. VAT Base Amt.';
            Editable = false;
        }
        field(115; "Prepayment VAT %"; Decimal)
        {
            Caption = 'Prepayment VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(116; "Prepmt. VAT Calc. Type"; Option)
        {
            Caption = 'Prepmt. VAT Calc. Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(117; "Prepayment VAT Identifier"; Code[10])
        {
            Caption = 'Prepayment VAT Identifier';
            Editable = false;
        }
        field(118; "Prepayment Tax Area Code"; Code[20])
        {
            Caption = 'Prepayment Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(119; "Prepayment Tax Liable"; Boolean)
        {
            Caption = 'Prepayment Tax Liable';
        }
        field(120; "Prepayment Tax Group Code"; Code[10])
        {
            Caption = 'Prepayment Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(121; "Prepmt Amt to Deduct"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt to Deduct"));
            Caption = 'Prepmt Amt to Deduct';
            MinValue = 0;
        }
        field(122; "Prepmt Amt Deducted"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt Deducted"));
            Caption = 'Prepmt Amt Deducted';
            Editable = false;
        }
        field(123; "Prepayment Line"; Boolean)
        {
            Caption = 'Prepayment Line';
            Editable = false;
        }
        field(124; "Prepmt. Amount Inv. Incl. VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. Incl. VAT';
            Editable = false;
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
        field(5416; "Outstanding Qty. (Base)"; Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
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
        field(5712; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(5917; "Qty. to Consume"; Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Consume';
            DecimalPlaces = 0 : 5;
        }
        field(5918; "Quantity Consumed"; Decimal)
        {
            Caption = 'Quantity Consumed';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5919; "Qty. to Consume (Base)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Consume (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(5920; "Qty. Consumed (Base)"; Decimal)
        {
            Caption = 'Qty. Consumed (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
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
        field(7100; "Quantity Share % 1"; Decimal)
        {
            Caption = 'Quantity Share % 1';

            trigger OnValidate()
            begin
                "New Quantity 1" := ROUND(Quantity * "Quantity Share % 1" / 100, 0.001)
            end;
        }
        field(7110; "New Quantity 1"; Decimal)
        {
            Caption = 'New Quantity 1';

            trigger OnValidate()
            begin
                "Quantity Share % 1" := "New Quantity 1" / Quantity * 100
            end;
        }
        field(7120; "Quantity Share % 2"; Decimal)
        {
            Caption = 'Quantity Share % 2';

            trigger OnValidate()
            begin
                "New Quantity 2" := ROUND(Quantity * "Quantity Share % 2" / 100, 0.001)
            end;
        }
        field(7130; "New Quantity 2"; Decimal)
        {
            Caption = 'New Quantity 2';

            trigger OnValidate()
            begin
                "Quantity Share % 2" := "New Quantity 2" / Quantity * 100
            end;
        }
        field(7140; "Quantity Share % 3"; Decimal)
        {
            Caption = 'Quantity Share % 3';

            trigger OnValidate()
            begin
                "New Quantity 3" := ROUND(Quantity * "Quantity Share % 3" / 100, 0.001)
            end;
        }
        field(7150; "New Quantity 3"; Decimal)
        {
            Caption = 'New Quantity 3';

            trigger OnValidate()
            begin
                "Quantity Share % 3" := "New Quantity 3" / Quantity * 100
            end;
        }
        field(7160; "Quantity Share %"; Decimal)
        {
            Caption = 'Quantity Share %';
            MinValue = 0;

            trigger OnValidate()
            begin
                "New Quantity" := ROUND(Quantity * "Quantity Share %" / 100, 0.00001);
                DecimalTemp := ROUND(Quantity * "Quantity Share %" / 100, 0.00001);
                if "Quantity Share %" > 0 then begin
                    "Amount Share %" := 0;
                    "New Amount" := 0;
                end;
                UpdateLines(FieldCaption("Quantity Share %"), CurrFieldNo <> 0);
                /*
                IF NOT Line THEN BEGIN
                  IF "Quantity Share %" <> xRec."Quantity Share %" THEN BEGIN
                    IF CONFIRM(Text0001, TRUE) THEN BEGIN
                      ServiceSplittingLine.RESET;
                      ServiceSplittingLine.SETRANGE(Line, TRUE);
                      ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
                      ServiceSplittingLine.SETRANGE("Temp. Document No.", "Temp. Document No.");
                      IF ServiceSplittingLine.FINDFIRST THEN BEGIN
                        REPEAT
                          ServiceSplittingLine.VALIDATE("Quantity Share %", "Quantity Share %");
                          ServiceSplittingLine.MODIFY;
                        UNTIL ServiceSplittingLine.NEXT = 0;
                      END;
                    END;
                  END;
                END;
                */

            end;
        }
        field(7170; "New Quantity"; Decimal)
        {
            Caption = 'New Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Quantity > 0 then
                    Validate("Quantity Share %", ROUND(100 * "New Quantity" / Quantity, 0.00001))
                else
                    Validate("Quantity Share %", 0);
            end;
        }
        field(7180; "Amount Share %"; Decimal)
        {
            Caption = 'Amount Share';
            MinValue = 0;

            trigger OnValidate()
            begin
                //logic taken from Sales Line:
                GetHeader;
                "New Amount" := ROUND(Amount * "Amount Share %" / 100, Currency."Amount Rounding Precision");
                if "Amount Share %" > 0 then begin
                    "Quantity Share %" := 0;
                    "New Quantity" := 0;
                end;
                UpdateLines(FieldCaption("Amount Share %"), CurrFieldNo <> 0);
            end;
        }
        field(7190; "New Amount"; Decimal)
        {
            Caption = 'New Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                if Amount > 0 then begin
                    GetHeader;
                    Validate("Amount Share %", ROUND(100 * "New Amount" / Amount, Currency."Amount Rounding Precision"));
                end else
                    Validate("Amount Share %", 0);
            end;
        }
        field(7200; "New Document No."; Code[20])
        {
            Caption = 'New Document No.';
            Description = 'supposed to be filled only at processing';
        }
        field(7210; Include; Boolean)
        {
            Caption = 'Include';

            trigger OnValidate()
            begin
                if Include then begin
                    Validate("New Quantity", Quantity);
                    ChangeIncludeInfo(0);
                end else begin
                    Validate("New Quantity", 0);
                    ChangeIncludeInfo(Quantity);
                end;
            end;
        }
        field(7220; "Create Quote"; Boolean)
        {
            Caption = 'Create Quote';
        }
        field(60000; "External No."; Code[20])
        {
            Caption = 'External No.';
        }
        field(90200; "Planned Service Date"; Date)
        {
            Caption = 'Planned Service Date';
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006014; "Product Subgroup Code"; Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = "Product Subgroup".Code where("Item Category Code" = field("Item Category Code"),
                                                           "Product Group Code" = field("Product Group Code"));
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
        field(25006130; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = if (Type = filter("External Service")) "External Serv. Tracking No."."External Serv. Tracking No." where("External Service No." = field("No."));
        }
        field(25006150; "Standard Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time (Hours)';
            DecimalPlaces = 0 : 5;
        }
        field(25006160; "Standard Time Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Standard Time Line No.';
            Editable = false;
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = lookup("Service Header EDMS"."Vehicle Registration No." where("Document Type" = field("Document Type"),
                                                                                         "No." = field("Document No.")));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006190; "Model Code"; Code[20])
        {
            CalcFormula = lookup("Service Header EDMS"."Model Code" where("Document Type" = field("Document Type"),
                                                                           "No." = field("Document No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Model.Code;
        }
        field(25006210; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
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
        field(25006373; VIN; Code[20])
        {
            CalcFormula = lookup("Service Header EDMS".VIN where("Document Type" = field("Document Type"),
                                                                  "No." = field("Document No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006600; "Sell-to Customer Bill %"; Decimal)
        {
            Caption = 'Sell-to Customer Bill %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(25006610; "Sell-to Customer Bill Amount"; Decimal)
        {
            Caption = 'Sell-to Customer Bill Amount';
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006800; "DMS Variable Field 25006800"; Code[20])
        {
        }
        field(25006801; "DMS Variable Field 25006801"; Code[20])
        {
        }
        field(25006802; "DMS Variable Field 25006802"; Code[20])
        {
        }
        field(25007110; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." where("Bill-to Customer No." = field("Bill-to Customer No."));
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
        field(25007190; Status; Code[10])
        {
            Caption = 'Status';
            TableRelation = "Service Work Status EDMS";
        }
        field(25007195; "BOM Item No."; Code[20])
        {
            Caption = 'BOM Item No.';
            TableRelation = Item;
        }
        field(25007220; "Sell-to Customer Name"; Text[100])
        {
            CalcFormula = lookup("Service Header EDMS"."Sell-to Customer Name" where("Sell-to Customer No." = field("Sell-to Customer No.")));
            Caption = 'Sell-to Customer Name';
            FieldClass = FlowField;
        }
        field(25007230; "Bill-to Name"; Text[100])
        {
            CalcFormula = lookup("Service Header EDMS"."Bill-to Name" where("Bill-to Customer No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to Name';
            FieldClass = FlowField;
        }
        field(25007240; "Document Amount"; Decimal)
        {
            CalcFormula = sum("Service Splitting Line".Amount where("Document Type" = field("Document Type"),
                                                                     "Document No." = field("Document No."),
                                                                     "Temp. Document No." = field("Temp. Document No."),
                                                                     Include = const(true)));
            Caption = 'Document Amount';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Temp. Document No.", Line, "Temp. Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
        key(Key2; Line, "Document Type", "Document No.", "Temp. Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "Capable to Promise";
        ServiceHeader: Record "Service Header EDMS";
        recSalesLine: Record "Sales Line";
        recSalesHeader: Record "Sales Header";
        recServOrderAlloc: Record "Serv. Labor Alloc. Application";
        recResourceAlloc: Record "Serv. Labor Allocation Entry";
        //SIEAssgnt: Record "SIE Assignment";
        ItemJnlLine: Record "Item Journal Line";
    begin
        if not Line then begin
            ServiceSplittingLine.Reset;
            ServiceSplittingLine.SetRange(Line, true);
            ServiceSplittingLine.SetRange("Document Type", "Document Type");
            ServiceSplittingLine.SetRange("Document No.", "Document No.");
            ServiceSplittingLine.SetRange("Temp. Document No.", "Temp. Document No.");
            ServiceSplittingLine.DeleteAll;
        end;
    end;

    trigger OnInsert()
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        Validate("Temp. Document No.");
        Validate("Temp. Line No.");
    end;

    var
        ServiceSplittingLine: Record "Service Splitting Line";
        Text0001: label 'Would you like to copy that value to lines?';
        ServiceSplittingHeader: Record "Service Splitting Line";
        Currency: Record Currency;
        Text0002: label 'There is problem no initialise %1.';
        Text0003: label 'There is nothing to process.';
        Text0004: label 'Is not possible to find %1 record with %2.';
        GLSetup: Record "General Ledger Setup";
        DecimalTemp: Decimal;
        ServiceHdr: Record "Service Header EDMS";
        Text007: label 'Exist Service Labor Allocation entry, which is not finished.';
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        Text008: label 'The field in that record is not allowed modify.';
        Cust: Record Customer;
        SkipBillToContact: Boolean;
        Text031: label 'You have modified %1.\\';
        Text032: label 'Do you want to update the lines?';
        Text103: label 'Would you like to delete created split prepare lines?';
        Text104: label 'There is difference in amounts: in source document %1 %3, in split %2 %3. Are you sure to continue?';
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
        TransferLineReserve: Codeunit "Transfer Line-Reserve";
        Text105: label 'Exist Return Transfer Order, which is not posted!';
        Text106: label 'Service Line No. %1 Transfered Quantity must be equal to zero!';
        Text107: label 'Service Quote No. %1 was created! ';
        Text108: label 'Created from Service Order No.%1';
        Text109: label 'Resource is assigned to Labor No. %1!';
        Text110: label 'Item No. %1 exist assigned Transfer Line!';
        Text111: label 'There are no lines selected for new documents. Nothing to create!';
        Text112: label 'There are reservations in transfer order. Item %1, Line No. %2 can not be moved!';

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        ServPricesIncVar: Integer;
        ServHeader: Record "Service Header EDMS";
    begin
        if not ServHeader.Get("Document Type", "Document No.") then begin
            ServHeader."No." := '';
            ServHeader.Init;
        end;
        if ServHeader."Prices Including VAT" then
            ServPricesIncVar := 1
        else
            ServPricesIncVar := 0;
        Clear(ServHeader);
        exit('2,' + Format(ServPricesIncVar) + ',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        Field.Get(Database::"Service Splitting Line", FieldNumber);
        exit(Field."Field Caption");
    end;


    procedure ApplyInsertAsWholeDoc()
    var
        ServiceSplittingLineL: Record "Service Splitting Line";
        TempDocNo: Integer;
    begin
        ServiceSplittingLineL.Reset;
        ServiceSplittingLineL.SetRange("Document Type", "Document Type");
        ServiceSplittingLineL.SetRange("Document No.", "Document No.");
        ServiceSplittingLineL.SetRange("Temp. Document No.", "Temp. Document No.");
        if ServiceSplittingLineL.FindFirst then begin
            Validate("Temp. Document No.", 0);
            TempDocNo := "Temp. Document No.";
            repeat
                Init;
                TransferFields(ServiceSplittingLineL);
                "Temp. Document No." := TempDocNo;
                Validate("Temp. Line No.", 0);
                Include := false;                                                           // 21.03.2014 Elva Baltic P21
                Insert;
            until ServiceSplittingLineL.Next = 0;
            ServiceSplittingLineL.SetRange("Temp. Document No.", TempDocNo);
            ServiceSplittingLineL.SetRange(Line, false);
            if ServiceSplittingLineL.FindFirst then begin
                ServiceSplittingLineL.Validate("Quantity Share %", 0);
                ServiceSplittingLineL.Validate("Amount Share %", 0);
                ServiceSplittingLineL.Include := false;                                     // 21.03.2014 Elva Baltic P21
                ServiceSplittingLineL.Modify;
            end;
        end;
    end;


    procedure ApplyInsertAsHeaderByServDoc(DocType: Integer; DocNo: Code[20])
    var
        ServiceHeader: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        ServiceSplittingLineL: Record "Service Splitting Line";
        TempDocNo: Integer;
        TempLineNo: Integer;
    begin
        if ServiceHeader.Get(DocType, DocNo) then begin
            ServiceLine.Reset;
            ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
            ServiceLine.SetRange("Document No.", ServiceHeader."No.");
            if ServiceLine.FindFirst then begin
                ServiceSplittingLineL.Init;
                CopyFldsServH2SplitLine(ServiceHeader, ServiceSplittingLineL);
                ServiceSplittingLineL.Validate(Line, false);
                ServiceSplittingLineL.Validate("Line No.", 0);
                ServiceSplittingLineL.Validate("Document Type", DocType);
                ServiceSplittingLineL.Validate("Document No.", DocNo);
                ServiceSplittingLineL.Validate("Temp. Document No.", 0);
                ServiceSplittingLineL."Temp. Line No." := 0;
                ServiceSplittingLineL.Insert(true);
                TempDocNo := ServiceSplittingLineL."Temp. Document No.";
                repeat
                    ServiceSplittingLineL.Init;
                    CopyFldsServL2SplitLine(ServiceLine, ServiceSplittingLineL);
                    ServiceSplittingLineL."Temp. Document No." := TempDocNo;
                    ServiceSplittingLineL."Temp. Line No." := 0;
                    ServiceSplittingLineL.Line := true;
                    // Only Original Document Lines must be with Include = TRUE            // 21.03.2014 Elva Baltic P21
                    if ServiceSplittingLineL."Temp. Document No." = 10000 then             // 21.03.2014 Elva Baltic P21
                        ServiceSplittingLineL.Include := true;                               // 21.03.2014 Elva Baltic P21
                    ServiceSplittingLineL.Insert(true);
                until ServiceLine.Next = 0;
                Get(ServiceSplittingLineL."Document Type", ServiceSplittingLineL."Document No.", ServiceSplittingLineL."Temp. Document No.",
                  true, ServiceSplittingLineL."Temp. Line No.");
            end;
        end;
    end;


    procedure ProceedDocSplit()
    var
        ServiceHeader: Record "Service Header EDMS";
        ServiceHeader2: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        ServiceLine2: Record "Service Line EDMS";
        ServiceLineDest: Record "Service Line EDMS";
        ServiceLineSourceTmp: Record "Service Line EDMS" temporary;
        FirstTempDocumentNo: Integer;
        PreviousTempDocumentNo: Integer;
        NewDestAllocationEntryNo: Integer;
        MessageText: Text[250];
        Text101: label 'There are created additional documents with %1: %2';
        DocNoFilterString: Text[100];
        DocNoFilterString2: Text[100];
        SourceDocHours: Decimal;
        ServiceAllocEntry: Record "Serv. Labor Allocation Entry";
        ServAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary;
        ServAllocEntrySrcTmp: Record "Serv. Labor Allocation Entry" temporary;
        ServAllocAppTmp: Record "Serv. Labor Alloc. Application" temporary;
        ServAllocAppSrcTmp: Record "Serv. Labor Alloc. Application" temporary;
        ServAllocEntryRemainTmp: Record "Serv. Labor Allocation Entry" temporary;
        ServAllocAppRemainTmp: Record "Serv. Labor Alloc. Application" temporary;
        ServAllocApp: Record "Serv. Labor Alloc. Application" temporary;
        ServAllocAppOfEntryTmp: Record "Serv. Labor Alloc. Application" temporary;
        SplittingHeaderRecNo: Integer;
        ServiceSplittingLineSource: Record "Service Splitting Line";
        ServiceSplittingLineDest: Record "Service Splitting Line";
        ServiceSplittingLineCheck: Record "Service Splitting Line";
        ShareToAdjustQtySrc: Decimal;
        ShareToAdjustQtyDest: Decimal;
        ShareOfLineInAlloc: Decimal;
        NewDocNo: Code[20];
        NewLineNo: Integer;
        NewLineQtyShare: Decimal;
        SrcAmt: Decimal;
        DstAmt: Decimal;
        DiffAmt: Decimal;
        LoopCurrCnt: Integer;
        SeparateFunctPars: Text[30];
        TransfHeader: Record "Transfer Header";
        TransferExist: Boolean;
        TransfHeader2: Record "Transfer Header";
        OldTransfLine: Record "Transfer Line";
        NewTransfLine: Record "Transfer Line";
        TrackingSpec: Record "Tracking Specification";
        NewInvoiceNo: Code[20];
        ServAllocApplNoAlloc: Record "Serv. Labor Alloc. Application";
        OrigDocNo: Code[20];
        ServiceSplittingLineNoAlloc: Record "Service Splitting Line";
        OrigDocType: Integer;
        ServAllocApplNoAllocToModify: Record "Serv. Labor Alloc. Application";
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
    begin
        //at first do compare values

        //prepare source service line
        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", "Document Type");
        ServiceLine.SetRange("Document No.", "Document No.");
        ServiceLine.SetRange(Type, ServiceLine.Type::Labor);
        ServiceLineSourceTmp.Reset;
        ServiceLineSourceTmp.DeleteAll;
        ServAllocEntrySrcTmp.Reset;
        ServAllocEntrySrcTmp.DeleteAll;
        ServAllocAppSrcTmp.Reset;
        ServAllocAppSrcTmp.DeleteAll;
        if ServiceLine.FindFirst then
            repeat
                ServiceLineSourceTmp := ServiceLine;
                ServiceLineSourceTmp.Insert;
            until ServiceLine.Next = 0;

        //12.12.2014 EB.P8 >>
        //ServiceAllocEntry.RESET;
        //ServiceAllocEntry.SETCURRENTKEY("Source Type", "Source Subtype", "Source ID");
        //ServiceAllocEntry.SETRANGE("Source Type", ServiceAllocEntry."Source Type"::"Service Document");
        //ServiceAllocEntry.SETRANGE("Source Subtype", ServiceAllocEntry."Source Subtype"::Order);
        //ServiceAllocEntry.SETRANGE("Source ID", "Document No.");
        ////Pending,In Progress,Finished,On Hold
        //ServiceAllocEntry.SETFILTER(Status, '%1|%2', ServiceAllocEntry.Status::"In Progress", ServiceAllocEntry.Status::"On Hold");
        //IF ServiceAllocEntry.FINDFIRST THEN
        //  ERROR(Text007);
        //12.12.2014 EB.P8 <<

        if not ServiceHeader.Get("Document Type", "Document No.") then
            Error(Text0002, ServiceHeader.TableCaption);

        // 21.03.2014 Elva Baltic P21 >>
        TransferExist := false;
        TransfHeader.Reset;
        TransfHeader.SetCurrentkey("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransfHeader.SetRange("Source Type", Database::"Service Header EDMS");
        TransfHeader.SetRange("Source Subtype", 1);
        TransfHeader.SetRange("Source No.", ServiceHeader."No.");
        TransfHeader.SetRange("Document Profile", TransfHeader."document profile"::Service);
        if TransfHeader.FindFirst then begin
            repeat
                if TransfHeader."Transfer-from Code" = ServiceHeader."Location Code" then
                    Error(Text105);
            until TransfHeader.Next = 0;
            TransferExist := true;
        end;
        // 21.03.2014 Elva Baltic P21 <<

        // 30.11.2023 EB.KN >>
        // Check if there are any lines selected to go to new documents
        ServiceSplittingLineCheck.Reset;
        ServiceSplittingLineCheck.SetRange(Line, true);
        ServiceSplittingLineCheck.SetRange("Document Type", "Document Type");
        ServiceSplittingLineCheck.SetRange("Document No.", "Document No.");
        ServiceSplittingLineCheck.SetFilter("Temp. Document No.", '<>10000');
        ServiceSplittingLineCheck.SetRange(Include, true);
        if not ServiceSplittingLineCheck.FindFirst then
            Error(Text111);
        // 30.11.2023 EB.KN <<

        //12.12.2014 EB.P8
        //here it seems no need to check for reservations, because it will ceck in delete process
        //...

        ServiceSplittingHeader.Reset;
        ServiceSplittingHeader.SetRange(Line, false);
        ServiceSplittingHeader.SetRange("Document Type", "Document Type");
        ServiceSplittingHeader.SetRange("Document No.", "Document No.");

        // that part creates all "Service Header EDMS" + "Service Line EDMS"
        // and put correcr quantities
        ServiceSplittingLine.Reset;
        ServiceSplittingLine.SetRange(Line, true);
        ServiceSplittingLine.SetRange("Document Type", "Document Type");
        ServiceSplittingLine.SetRange("Document No.", "Document No.");
        ServiceSplittingLine.SetFilter("Temp. Document No.", '<>%1', 0);                                     // 06.05.2014 Elva Baltic P21
        if not ServiceSplittingLine.FindFirst then
            Error(Text0003);
        FirstTempDocumentNo := ServiceSplittingLine."Temp. Document No.";
        PreviousTempDocumentNo := FirstTempDocumentNo;
        DocNoFilterString := '''' + ServiceSplittingLine."Document No." + '''';
        DocNoFilterString2 := ''; // it stores the same filter but only without original document
        repeat
            // 21.03.2014 Elva Baltic P21 >>
            // Modification of Original document is transfered after new document creation due to reservation
            /*
            IF FirstTempDocumentNo = ServiceSplittingLine."Temp. Document No." THEN BEGIN

              // just modify values of lines - for original document
              IF NOT ServiceLine.GET(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
                  ServiceSplittingLine."Line No.") THEN
                ERROR(Text0004, ServiceLine.TABLECAPTION, FORMAT(ServiceSplittingLine."Document Type") + ', ' +
                  ServiceSplittingLine."Document No." + ', ' + FORMAT(ServiceSplittingLine."Line No."));

              ServiceLine.VALIDATE(Quantity, ServiceSplittingLine."New Quantity");
              ServiceLine.MODIFY;

            // modify allocation
            END ELSE BEGIN
            */
            // 21.03.2014 Elva Baltic P21 <<

            if FirstTempDocumentNo <> ServiceSplittingLine."Temp. Document No." then begin
                if PreviousTempDocumentNo <> ServiceSplittingLine."Temp. Document No." then begin
                    // NEED CREATE HEADER RECORD AT FIRST
                    ServiceHeader2.Init;
                    ServiceHeader2.Validate("Document Type", ServiceHeader."Document Type");
                    ServiceHeader2."No." := '';
                    ServiceHeader2."No. Series" := '';
                    ServiceHeader2.Insert(true);

                    CopyHeaderComments(ServiceHeader, ServiceHeader2);

                    ServiceSplittingHeader.SetRange("Temp. Document No.", ServiceSplittingLine."Temp. Document No.");
                    ServiceSplittingHeader.FindFirst;
                    ServiceSplittingHeader."New Document No." := ServiceHeader2."No.";
                    ServiceSplittingHeader.Modify;

                    ServiceHeader2.TransferFields(ServiceHeader, false);
                    if ServiceHeader."Posting No." <> '' then
                        ServiceHeader2.Validate("Posting No.", ServiceHeader2."No.");

                    ServiceHeader2."No." := ServiceSplittingHeader."New Document No.";
                    ServiceHeader2.SetSkipVehicleChoose(true);  //02.07.2013 EDMS P8
                    if ServiceHeader."Sell-to Customer No." <> ServiceSplittingHeader."Sell-to Customer No." then begin
                        ServiceHeader2."Sell-to Customer No." := '';
                        ServiceHeader2."Bill-to Customer No." := '';
                        ServiceHeader2.Validate("Sell-to Customer No.", ServiceSplittingHeader."Sell-to Customer No.");
                    end;
                    if ServiceHeader2."Bill-to Customer No." <> ServiceSplittingHeader."Bill-to Customer No." then begin
                        ServiceHeader2."Bill-to Customer No." := '';
                        ServiceHeader2.Validate("Bill-to Customer No.", ServiceSplittingHeader."Bill-to Customer No.");
                    end;
                    if ServiceHeader."Currency Code" <> ServiceSplittingHeader."Currency Code" then begin
                        ServiceHeader2."Currency Code" := '';
                        ServiceHeader2.Validate("Currency Code", ServiceSplittingHeader."Currency Code");
                    end;
                    ServiceHeader2.Modify(true);
                    PreviousTempDocumentNo := ServiceSplittingLine."Temp. Document No.";
                    if MessageText <> '' then
                        MessageText += ', ';
                    MessageText += Format(ServiceHeader2."No.");
                    DocNoFilterString += '|''' + ServiceHeader2."No." + '''';
                    if DocNoFilterString2 <> '' then
                        DocNoFilterString2 += '|';
                    DocNoFilterString2 += '''' + ServiceHeader2."No." + '''';
                end;
                // create lines
                if not ServiceLine.Get(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
                       ServiceSplittingLine."Line No.") then
                    Error(Text0004, ServiceLine.TableCaption, Format(ServiceSplittingLine."Document Type") + ', ' +
                          ServiceSplittingLine."Document No." + ', ' + Format(ServiceSplittingLine."Line No."));
                // IF (ServiceSplittingLine.Type = 0) OR                                            // 06.05.2014 Elva Baltic P21
                if ServiceSplittingLine.Include                                                     // 15.09.2015 EB.P30
                                                                                                    // (ServiceSplittingLine.Type = 0) AND                                            // 06.05.2014 Elva Baltic P21
                                                                                                    // OR (ServiceSplittingLine."New Quantity" <> 0)                                  // 15.09.2015 EB.P30
                then begin

                    //IF ServiceLine.CalcTransferedQuantity <> 0 THEN                                   // 21.03.2014 Elva Baltic P21
                    //  ERROR(Text106, ServiceLine."Line No.");                                         // 21.03.2014 Elva Baltic P21

                    // 30.11.2023 EB.KN >>
                    // Restriction on item movement to new order, if it is in transfer process
                    If ServiceLine.Type = ServiceLine.Type::Item then begin
                        ReservEntry.Reset;
                        ReservEntry.SetRange("Source Type", Database::"Service Line EDMS");
                        ReservEntry.SetRange("Source Subtype", 1);
                        ReservEntry.SetRange("Source ID", ServiceHeader."No.");
                        ReservEntry.SetRange("Source Ref. No.", ServiceLine."Line No.");
                        ReservEntry.SetRange("Reservation Status", ReservEntry."reservation status"::Reservation);
                        if ReservEntry.Find('-') then
                            repeat
                                ReservEntry2.Reset;
                                ReservEntry2.Get(ReservEntry."Entry No.", true);
                                if ReservEntry2."Source Type" = Database::"Transfer Line" then begin
                                    Error(Text112, ServiceLine."No.", ServiceLine."Line No.");
                                end;
                            until ReservEntry.Next = 0;
                    end;
                    // 30.11.2023 EB.KN <<

                    ServiceLine2.Init;
                    ServiceLine2.TransferFields(ServiceLine, false);
                    ServiceLine2."Document Type" := ServiceSplittingHeader."Document Type";
                    ServiceLine2."Document No." := ServiceSplittingHeader."New Document No.";
                    ServiceLine2."Line No." := ServiceSplittingLine."Line No.";
                    ServiceLine2."Sell-to Customer No." := ServiceSplittingHeader."Sell-to Customer No.";
                    ServiceLine2."Bill-to Customer No." := ServiceSplittingHeader."Bill-to Customer No.";
                    ServiceLine2."Currency Code" := ServiceSplittingHeader."Currency Code";
                    // 04.04.2014 Elva Baltic P21 >>
                    ServiceLine2."Gen. Bus. Posting Group" := ServiceHeader2."Gen. Bus. Posting Group";
                    ServiceLine2.Validate("VAT Bus. Posting Group", ServiceHeader2."VAT Bus. Posting Group");
                    /*
                    ServiceLine2.VALIDATE("No.", ServiceSplittingLine."No.");
                    ServiceLine2.VALIDATE("Location Code", ServiceSplittingLine."Location Code");
                    ServiceLine2.VALIDATE(Quantity, ServiceSplittingLine."New Quantity");
                    //ServiceLine2.VALIDATE("Unit Price", ServiceSplittingLine."Unit Price");
                    */
                    // 04.04.2014 Elva Baltic P21 <<
                    ServiceLine2.Description := ServiceSplittingLine.Description;
                    ServiceLine2.Insert(true);
                    // set doc link to new created
                    ServiceSplittingLine."New Document No." := ServiceSplittingHeader."New Document No.";
                    ServiceSplittingLine.Modify;

                    // 15.10.2015 EB.P30 >>
                    ReservEntry.Reset;
                    ReservEntry.SetRange("Source Type", Database::"Service Line EDMS");
                    ReservEntry.SetRange("Source Subtype", 1);
                    ReservEntry.SetRange("Source ID", ServiceHeader."No.");
                    ReservEntry.SetRange("Source Ref. No.", ServiceLine2."Line No.");
                    ReservEntry.SetRange("Reservation Status", ReservEntry."reservation status"::Reservation);
                    if ReservEntry.Find('-') then
                        repeat
                            ReservEntry2.Reset;
                            ReservEntry2.Get(ReservEntry."Entry No.", true);
                            if ReservEntry2."Source Type" = Database::"Item Ledger Entry" then begin
                                ReservEntry."Source ID" := ServiceLine2."Document No.";
                                ReservEntry."Source Ref. No." := ServiceLine2."Line No.";
                                ReservEntry.Modify;
                            end;
                        until ReservEntry.Next = 0;
                    // 15.10.2015 EB.P30 <<

                end;
            end;
        until ServiceSplittingLine.Next = 0;
        ServiceSplittingHeader.SetRange("Temp. Document No.");

        // 21.03.2014 Elva Baltic P21 >>
        // Create Transfer Orders for New Service Orders
        if TransferExist then begin
            ServiceHeader2.Reset;
            ServiceHeader2.SetRange("Document Type", ServiceHeader."Document Type");
            ServiceHeader2.SetFilter("No.", DocNoFilterString2);
            if ServiceHeader2.FindFirst then
                repeat
                    ServiceTransferMgt.CreateTransferOrderForSplit(ServiceHeader2);
                until ServiceHeader2.Next = 0;
        end;

        // Now adjust labor allocations of source document and create for new documents
        // Here main loop for all allocation events, idea is for each allocation go through split documents
        //  by define what line went to the new one. In details: For an allocation get all applications into temporary table then loop it,
        //   remove that application from temp
        //   find service line and depending on which document it is, do following:
        //    in case old document line - nothing;
        //    in case new document - create, as copy, new allocation and redefine application and
        //      check in temp is there other applications that should move onto new alloc (if yes then remove it and...).
        //      If on old allocation not left applications then delete it - better by OnDelete event.
        //    in case not found line, on header level - copy allocation and all applications;
        // lets review all records meaning:
        // ServiceSplittingHeader real data only filtered
        // ServAllocEntrySrcTmp temp data, rigth before the loop will fill it (all allocations assigned to source doc)
        // ServAllocAppSrcTmp temp data, rigth before the loop will fill it (all applications assigned to source doc)
        // ServAllocAppOfEntryTmp temp data, will be filled in loop it (all applications assigned to certain allocation)
        // ServiceSplittingLineSource real data, will be filtered in loop by previous split doc + first app of current alloc
        // ServiceSplittingLineDest real data, will be filtered in loop by current split doc + first app of current alloc
        // ServiceLineDest real data, will be positioned in loop by current split doc + first app of current alloc
        FindAllocationsOfLabor(ServiceSplittingHeader."Document Type", ServiceSplittingHeader."Document No.",
          -1, ServAllocEntrySrcTmp, ServAllocAppSrcTmp, 2, '1');
        if ServAllocEntrySrcTmp.FindFirst then begin
            repeat
                ServiceSplittingHeader.FindFirst;
                SplittingHeaderRecNo := 0;
                GetApplicationForAllocEntry(ServAllocEntrySrcTmp."Entry No.", ServAllocAppOfEntryTmp);
                if ServAllocAppOfEntryTmp.FindFirst then begin  // THERE could be situations that allocation has no applications
                    FindFirstForApp(ServiceSplittingLineSource, ServAllocAppOfEntryTmp, ServiceSplittingHeader."Temp. Document No.");


                    SeparateFunctPars := '';
                    //we are not interested in first document - source document
                    if ServiceSplittingHeader.Next > 0 then begin
                        SplittingHeaderRecNo += 1;
                        repeat  // here loop through ServiceSplittingHeader-s
                            SplittingHeaderRecNo += 1;
                            GetApplicationForAllocEntry(ServAllocEntrySrcTmp."Entry No.", ServAllocAppOfEntryTmp);  // repair content of that record for any reason
                            if ServAllocAppOfEntryTmp.FindFirst then begin
                                NewDestAllocationEntryNo := 0;
                                repeat // LOOP through ServAllocAppOfEntryTmp
                                    if ServAllocAppOfEntryTmp."Document Line No." = 0 then begin // MEAN header
                                        CreateNewAllocApp(ServAllocEntrySrcTmp, ServAllocAppOfEntryTmp, ServiceSplittingHeader."Document Type",
                                        ServiceSplittingHeader."New Document No.", 0, NewDestAllocationEntryNo);
                                    end else begin // MEAN service line but not header
                                        if FindFirstForApp(ServiceSplittingLineDest, ServAllocAppOfEntryTmp,
                                        ServiceSplittingHeader."Temp. Document No.") then begin  // that should return one record
                                                                                                 // prepare destination part
                                            if ServiceSplittingLineDest."Line No." > 0 then // MEAN RECORD IS CORRECT
                                                if ServiceSplittingLineDest.Include then begin
                                                    if ServiceLineDest.Get(ServiceSplittingLineDest."Document Type", ServiceSplittingLineDest."Document No.",
                                                    ServiceSplittingLineDest."Line No.") then
                                                        CreateNewAllocApp(ServAllocEntrySrcTmp, ServAllocAppOfEntryTmp, ServiceSplittingHeader."Document Type",
                                                        ServiceSplittingHeader."New Document No.", ServiceLineDest."Line No.", NewDestAllocationEntryNo);
                                                end;
                                        end;
                                    end;
                                until ServAllocAppOfEntryTmp.Next = 0;
                            end;
                        until ServiceSplittingHeader.Next = 0;
                    end;
                end;
            until ServAllocEntrySrcTmp.Next = 0;
        end;


        // Find Allocation Application Entries where Allocation Entry = 0
        ServiceSplittingHeader.FindFirst;
        OrigDocNo := ServiceSplittingHeader."Document No.";
        OrigDocType := ServiceSplittingHeader."Document Type";
        SplittingHeaderRecNo := 0;
        if ServiceSplittingHeader.Next > 0 then begin
            SplittingHeaderRecNo += 1;
            repeat  // here loop through ServiceSplittingHeader-s
                SplittingHeaderRecNo += 1;
                ServiceSplittingLineNoAlloc.Reset;
                ServiceSplittingLineNoAlloc.SetRange("Document No.", OrigDocNo);
                ServiceSplittingLineNoAlloc.SetRange("Document Type", OrigDocType);
                ServiceSplittingLineNoAlloc.SetRange(Line, true);
                ServiceSplittingLineNoAlloc.SetRange("New Document No.", ServiceSplittingHeader."New Document No.");
                ServiceSplittingLineNoAlloc.SetRange(Include, true);
                if ServiceSplittingLineNoAlloc.FindFirst then
                    repeat
                        ServAllocApplNoAlloc.Reset;
                        ServAllocApplNoAlloc.SetRange("Allocation Entry No.", 0);
                        ServAllocApplNoAlloc.SetRange("Document No.", OrigDocNo);
                        ServAllocApplNoAlloc.SetRange("Document Type", OrigDocType);
                        ServAllocApplNoAlloc.SetRange("Document Line No.", ServiceSplittingLineNoAlloc."Line No.");
                        if ServAllocApplNoAlloc.FindFirst then
                            repeat
                                ServAllocApplNoAllocToModify.Init;
                                ServAllocApplNoAllocToModify.TransferFields(ServAllocApplNoAlloc);
                                ServAllocApplNoAllocToModify."Document No." := ServiceSplittingLineNoAlloc."New Document No.";
                                ServAllocApplNoAllocToModify."Document Line No." := ServiceSplittingLineNoAlloc."Line No.";
                                ServAllocApplNoAllocToModify.Insert;
                            until ServAllocApplNoAlloc.Next = 0;
                    until ServiceSplittingLineNoAlloc.Next = 0;
            until ServiceSplittingHeader.Next = 0;
        end;


        // modify values of lines - for original document
        ServiceSplittingLine.Reset;
        ServiceSplittingLine.SetRange(Line, true);
        ServiceSplittingLine.SetRange("Document Type", "Document Type");
        ServiceSplittingLine.SetRange("Document No.", "Document No.");
        ServiceSplittingLine.SetRange("Temp. Document No.", FirstTempDocumentNo);
        if ServiceSplittingLine.FindFirst then
            repeat
                if not ServiceLine.Get(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
                                       ServiceSplittingLine."Line No.") then
                    Error(Text0004, ServiceLine.TableCaption, Format(ServiceSplittingLine."Document Type") + ', ' +
                          ServiceSplittingLine."Document No." + ', ' + Format(ServiceSplittingLine."Line No."));

                // IF ServiceSplittingLine."New Quantity" = 0 THEN BEGIN                                            // 06.05.2014 Elva Baltic P21
                if not ServiceSplittingLine.Include then begin                                                      // 06.05.2014 Elva Baltic P21
                    if (ServiceSplittingLine.Type = ServiceSplittingLine.Type::Item) and TransferExist then begin     // 06.05.2014 Elva Baltic P21
                                                                                                                      // Finding Old Transfer Line
                        if ServiceTransferMgt.FindTransferLine(ServiceLine, OldTransfLine) then begin
                            // Finding New Transfer Line
                            ServiceLine2.Reset;
                            ServiceLine2.SetRange("Document Type", ServiceSplittingLine."Document Type");
                            ServiceLine2.SetFilter("Document No.", DocNoFilterString2);
                            ServiceLine2.SetRange("Line No.", ServiceSplittingLine."Line No.");
                            if ServiceLine2.FindFirst then begin
                                if ServiceTransferMgt.FindTransferLine(ServiceLine2, NewTransfLine) then
                                    // Transfering Old Transfer Line reservation to New Transfer Line reservation
                                    TransferLineReserve.TransferTransferToTransfer(OldTransfLine, NewTransfLine, ServiceLine2.Quantity,
                                                                     0, TrackingSpec);
                            end;
                        end;
                        // Delete Transfer Lines from Original Transfer Order
                        ServiceTransferMgt.DeleteTransferLine(ServiceLine);
                    end;
                    ServiceLine.Delete(true);
                end;
            // 04.04.2014 Elva Baltic P21 >>
            /*
            ELSE BEGIN
              ServiceLine.VALIDATE(Quantity, ServiceSplittingLine."New Quantity");
              ServiceLine.MODIFY;
            END;
            */
            // 04.04.2014 Elva Baltic P21 <<
            until ServiceSplittingLine.Next = 0;

        /*
        // adjust reservations
        IF ServiceSplittingLine.FINDFIRST THEN BEGIN
          ServiceLine.RESET;
          ServiceLine.SETRANGE("Document Type", ServiceSplittingLine."Document Type");
          ServiceLine.SETFILTER("Document No.", DocNoFilterString);
          ServiceLine.SETRANGE(Type, ServiceSplittingLine.Type::Item);
          IF ServiceLine.FINDFIRST THEN BEGIN
            REPEAT
              IF ServiceLine."Document No." <> ServiceSplittingLine."Document No." THEN
              // do not proceed line of original document
                IF ServiceLine.Reserve <> ServiceLine.Reserve::Never THEN  //02.07.2013 EDMS P8
                  ServiceLine.AutoReserve;
            UNTIL ServiceLine.NEXT = 0;
          END;
        END;
        */
        // 21.03.2014 Elva Baltic P21 <<


        Message(Text101, ServiceHeader2.FieldCaption("No."), MessageText);
        DeleteDocSplit;

    end;


    procedure CalcShareToAdjustQty(var ServAllocAppPar: Record "Serv. Labor Alloc. Application"; var ServiceSplittingLine: Record "Service Splitting Line"; var ServiceLine: Record "Service Line EDMS") ShareToAdjustQty: Decimal
    var
        MainLineQtyShare: Decimal;
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        QtyTotalOfApp: Decimal;
        MainAllocQty: Decimal;
        MainLineQty: Decimal;
    begin
        // it supposed to be ServAllocAppPar - temporary
        QtyTotalOfApp := 0;
        ShareToAdjustQty := 1;
        ServAllocAppPar.FindFirst;
        MainLineQtyShare := ServiceSplittingLine."Quantity Share %";
        ServLaborAllocationEntry.Get(ServAllocAppPar."Allocation Entry No.");
        MainAllocQty := ServLaborAllocationEntry."Quantity (Hours)";
        if ServiceLine.Get(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
            ServAllocAppPar."Document Line No.") then
            MainLineQty := ServiceLine.GetTimeQty;
        if ServAllocAppPar.Count > 1 then begin
            repeat
                if ServiceLine.Get(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
                    ServAllocAppPar."Document Line No.") then
                    QtyTotalOfApp += ServiceLine.GetTimeQty;
            until ServAllocAppPar.Next = 0;
            ShareToAdjustQty := (MainAllocQty - (MainLineQty * MainAllocQty / QtyTotalOfApp) *
              (100 - MainLineQtyShare) / 100) / MainAllocQty;
        end;
        //return value not in percents, but simple decimal
        exit(ShareToAdjustQty * 100);
    end;


    procedure FindAllocationsOfLabor(DocType: Integer; DocNo: Code[20]; LineNo: Integer; var ServAllocEntryTmp: Record "Serv. Labor Allocation Entry" temporary; var ServAllocAppTmp: Record "Serv. Labor Alloc. Application" temporary; TimeLine: Integer; ParamStr: Text[30])
    var
        ServiceAllocEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocApp: Record "Serv. Labor Alloc. Application";
        doAvoidSplitEntries: Boolean;
    begin
        // ParamStr: first char is digit-flag, doAvoidSplitEntries("Applies-to Entry No.")
        ServAllocEntryTmp.Reset;
        ServAllocEntryTmp.DeleteAll;
        ServAllocAppTmp.Reset;
        ServAllocAppTmp.DeleteAll;
        if StrLen(ParamStr) > 0 then
            Evaluate(doAvoidSplitEntries, CopyStr(ParamStr, 1, 1));


        ServLaborAllocApp.Reset;
        ServLaborAllocApp.SetRange("Document Type", DocType);
        ServLaborAllocApp.SetRange("Document No.", DocNo);
        ServLaborAllocApp.SetRange("Document Line No.", LineNo);
        if LineNo < 0 then
            ServLaborAllocApp.SetRange("Document Line No.");
        if TimeLine = 2 then
            ServLaborAllocApp.SetRange("Time Line")
        else
            if TimeLine = 1 then
                ServLaborAllocApp.SetRange("Time Line", true)
            else
                ServLaborAllocApp.SetRange("Time Line", false);
        if ServLaborAllocApp.FindFirst then begin
            repeat
                if ServiceAllocEntry.Get(ServLaborAllocApp."Allocation Entry No.") then begin
                    if (doAvoidSplitEntries and (ServiceAllocEntry."Applies-to Entry No." = 0)) or
                        (not doAvoidSplitEntries) then begin
                        if not ServAllocEntryTmp.Get(ServLaborAllocApp."Allocation Entry No.") then begin
                            ServAllocEntryTmp := ServiceAllocEntry;
                            ServAllocEntryTmp.Insert;
                        end;
                        ServAllocAppTmp := ServLaborAllocApp;
                        ServAllocAppTmp.Insert;
                    end;
                end;
            until ServLaborAllocApp.Next = 0;
        end
    end;


    procedure DeleteDocSplit()
    var
        ServiceHeader: Record "Service Header EDMS";
        ServiceHeader2: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        ServiceLine2: Record "Service Line EDMS";
        FirstTempDocumentNo: Integer;
        LastTempDocumentNo: Integer;
    begin
        ServiceSplittingLine.Reset;
        ServiceSplittingLine.SetRange(Line, false);
        ServiceSplittingLine.SetRange("Document Type", "Document Type");
        ServiceSplittingLine.SetRange("Document No.", "Document No.");
        ServiceSplittingLine.DeleteAll(true);
    end;

    local procedure GetHeader()
    begin
        TestField("Document No.");
        if ServiceSplittingHeader.Line or ("Document Type" <> ServiceSplittingHeader."Document Type") or
            ("Temp. Document No." <> ServiceSplittingHeader."Temp. Document No.") then begin
            ServiceSplittingHeader.SetRange(Line, false);
            ServiceSplittingHeader.SetRange("Document Type", "Document Type");
            ServiceSplittingHeader.SetRange("Temp. Document No.", "Temp. Document No.");
            if ServiceSplittingHeader.FindFirst then
                Currency.InitRoundingPrecision
            else begin
                if ServiceSplittingHeader."Currency Code" = '' then
                    Currency.InitRoundingPrecision
                else begin
                    //ServiceSplittingHeader.TESTFIELD("Currency Factor");
                    Currency.Get(ServiceSplittingHeader."Currency Code");
                    Currency.TestField("Amount Rounding Precision");
                end;
            end;
        end;
    end;


    procedure GetSourceTempDocNo(): Integer
    var
        ServiceSplittingLine: Record "Service Splitting Line";
    begin
        ServiceSplittingLine.SetRange("Document Type", "Document Type");
        ServiceSplittingLine.SetRange("Document No.", "Document No.");
        ServiceSplittingLine.SetRange(Line, false);
        ServiceSplittingLine.FindFirst;
        exit(ServiceSplittingLine."Temp. Document No.");
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        if not (("Document Type" = "document type"::Quote) and (CustNo = '')) then begin
            if CustNo <> Cust."No." then
                Cust.Get(CustNo);
        end else
            Clear(Cust);
    end;


    procedure GetApplicationForAllocEntry(EntryNo: Integer; var ServAllocAppOfEntryTmp: Record "Serv. Labor Alloc. Application")
    var
        ServAllocApp: Record "Serv. Labor Alloc. Application";
    begin
        ServAllocAppOfEntryTmp.Reset;
        ServAllocAppOfEntryTmp.DeleteAll;
        ServAllocApp.Reset;
        ServAllocApp.SetRange("Allocation Entry No.", EntryNo);
        if ServAllocApp.FindFirst then
            repeat
                ServAllocAppOfEntryTmp := ServAllocApp;
                ServAllocAppOfEntryTmp.Insert
            until ServAllocApp.Next = 0;
    end;


    procedure GetQtyShareOfLineInAlloc(var ServAllocApp: Record "Serv. Labor Alloc. Application"; var ServiceLine: Record "Service Line EDMS"; DocType: Integer; DocNo: Code[20]; LineNo: Integer) ShareOfLine: Decimal
    var
        QtyTotalOfApp: Decimal;
        MainAllocQty: Decimal;
        MainLineQty: Decimal;
        QtyOfApp: Integer;
        ServiceLineFilt: Record "Service Line EDMS";
        ServAllocAppFilt: Record "Serv. Labor Alloc. Application";
        ServiceLinePosit: Text[250];
        ServAllocAppPosit: Text[250];
    begin
        ServiceLinePosit := ServiceLine.GetPosition;
        ServiceLineFilt.CopyFilters(ServiceLine);
        ServAllocAppPosit := ServAllocApp.GetPosition;
        ServAllocAppFilt.CopyFilters(ServAllocApp);

        QtyTotalOfApp := 0;
        ShareOfLine := 1;
        if ServAllocApp.FindFirst then begin
            ServiceLine.Get(DocType, DocNo, LineNo);
            MainLineQty := ServiceLine.GetTimeQty;
            repeat
                if ServiceLine.Get(DocType, DocNo, ServAllocApp."Document Line No.") then
                    QtyTotalOfApp += ServiceLine.GetTimeQty;
                QtyOfApp += 1;
            until ServAllocApp.Next = 0;
            ShareOfLine := MainLineQty / QtyTotalOfApp;
        end;
        ServiceLine.CopyFilters(ServiceLineFilt);
        ServiceLine.SetPosition(ServiceLinePosit);
        ServAllocApp.CopyFilters(ServAllocAppFilt);
        ServAllocApp.SetPosition(ServAllocAppPosit);
        exit(ShareOfLine * 100);
    end;


    procedure GetAdjustedQtyShare(var ServiceSplittingLine: Record "Service Splitting Line"; var ServiceLine: Record "Service Line EDMS"; var ServAllocApp: Record "Serv. Labor Alloc. Application"; var ServAllocEntry: Record "Serv. Labor Allocation Entry"; DocType: Integer; DocNo: Code[20]; LineNo: Integer; EntryNo: Integer; TempDocNo: Integer) RetValue: Decimal
    var
        ServiceSplittingLineFilt: Record "Service Splitting Line";
        ServiceLineFilt: Record "Service Line EDMS";
        ServAllocAppFilt: Record "Serv. Labor Alloc. Application";
        ServAllocEntryFilt: Record "Serv. Labor Allocation Entry";
        ServiceSplittingLinePosit: Text[250];
        ServiceLinePosit: Text[250];
        ServAllocAppPosit: Text[250];
        ServAllocEntryPosit: Text[250];
        AllocationQty: Decimal;
        ShareQtyTotal: Decimal;
        ResultQty: Decimal;
        LinesTotalQty: Decimal;
    begin
        //return percentage
        ServiceSplittingLinePosit := ServiceSplittingLine.GetPosition;
        ServiceSplittingLineFilt.CopyFilters(ServiceSplittingLine);
        ServiceLinePosit := ServiceLine.GetPosition;
        ServiceLineFilt.CopyFilters(ServiceLine);
        ServAllocAppPosit := ServAllocApp.GetPosition;
        ServAllocAppFilt.CopyFilters(ServAllocApp);
        ServAllocEntryPosit := ServAllocEntry.GetPosition;
        ServAllocEntryFilt.CopyFilters(ServAllocEntry);


        ServAllocEntry.Get(EntryNo);
        AllocationQty := ServAllocEntry."Quantity (Hours)";
        ServAllocApp.SetRange("Allocation Entry No.", EntryNo);
        ServAllocApp.FindFirst;
        repeat

            ServiceSplittingLine.SetRange("Document Type", DocType);
            ServiceSplittingLine.SetRange("Document No.", DocNo);
            ServiceSplittingLine.SetRange("Temp. Document No.", TempDocNo);
            if ServAllocApp."Document Line No." > 0 then begin
                ServiceSplittingLine.SetRange(Line, true);
                ServiceSplittingLine.SetRange("Line No.", ServAllocApp."Document Line No.");
                ServiceLine.Get(DocType, DocNo, ServAllocApp."Document Line No.");
                ServiceSplittingLine.FindFirst;
                LinesTotalQty += ServiceLine.GetTimeQty;
                ShareQtyTotal += ServiceLine.GetTimeQty * ServiceSplittingLine."Quantity Share %" / 100;
            end else begin
                ServiceSplittingLine.SetRange(Line, false);
                ServiceSplittingLine.SetRange("Line No.");
                ServiceSplittingLine.FindFirst;
                LinesTotalQty := AllocationQty;
                ShareQtyTotal := AllocationQty * ServiceSplittingLine."Quantity Share %" / 100;
            end;
        until ServAllocApp.Next = 0;
        if LinesTotalQty = 0 then
            ResultQty := AllocationQty
        else
            ResultQty := (AllocationQty / LinesTotalQty) * ShareQtyTotal;

        if AllocationQty <> 0 then                                          // 06.05.2014 Elva Baltic P21
            RetValue := ResultQty / AllocationQty * 100
        else                                                                // 06.05.2014 Elva Baltic P21
            RetValue := 0;                                                    // 06.05.2014 Elva Baltic P21

        ServiceSplittingLine.CopyFilters(ServiceSplittingLineFilt);
        ServiceSplittingLine.SetPosition(ServiceSplittingLinePosit);
        ServiceLine.CopyFilters(ServiceLineFilt);
        ServiceLine.SetPosition(ServiceLinePosit);
        ServAllocApp.CopyFilters(ServAllocAppFilt);
        ServAllocApp.SetPosition(ServAllocAppPosit);
        ServAllocEntry.CopyFilters(ServAllocEntryFilt);
        ServAllocEntry.SetPosition(ServAllocEntryPosit);
        exit(RetValue);
    end;


    procedure UpdateLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        ChangeLogMgt: Codeunit "Change Log Management";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        Question: Text[250];
    begin
        if Line then exit;
        if not (ChangedFieldName in
          [FieldCaption("Sell-to Customer No."),
          FieldCaption("Location Code"),
          FieldCaption("Bill-to Customer No."),
          FieldCaption("Currency Code"),
          FieldCaption("Quantity Share %")]) then
            exit;

        if AskQuestion then begin
            Question := StrSubstNo(
                Text031 +
                Text032, ChangedFieldName);
            if GuiAllowed then
                if not Dialog.Confirm(Question, true) then
                    exit;
        end;

        ServiceSplittingLine.LockTable;
        ServiceSplittingLine.Reset;
        ServiceSplittingLine.SetRange(Line, true);
        ServiceSplittingLine.SetRange("Document Type", "Document Type");
        ServiceSplittingLine.SetRange("Document No.", "Document No.");
        ServiceSplittingLine.SetRange("Temp. Document No.", "Temp. Document No.");
        if ServiceSplittingLine.FindSet then
            repeat
                case ChangedFieldName of
                    FieldCaption("Sell-to Customer No."):
                        ServiceSplittingLine.Validate("Sell-to Customer No.", "Sell-to Customer No.");
                    FieldCaption("Location Code"):
                        ServiceSplittingLine.Validate("Location Code", "Location Code");
                    FieldCaption("Bill-to Customer No."):
                        ServiceSplittingLine.Validate("Bill-to Customer No.", "Bill-to Customer No.");
                    FieldCaption("Currency Code"):
                        ServiceSplittingLine.Validate("Currency Code", "Currency Code");
                    FieldCaption("Quantity Share %"):
                        ServiceSplittingLine.Validate("Quantity Share %", "Quantity Share %");
                end;
                ServiceSplittingLine.Modify(true);
            until ServiceSplittingLine.Next = 0;
    end;


    procedure CreateSplitingForDoc(var ServiceHeaderPar: Record "Service Header EDMS")
    begin
        ServiceSplittingLine.Reset;
        ServiceSplittingLine.SetRange(Line, false);
        ServiceSplittingLine.SetRange("Document Type", ServiceHeaderPar."Document Type");
        ServiceSplittingLine.SetRange("Document No.", ServiceHeaderPar."No.");
        if not ServiceSplittingLine.FindFirst then
            ApplyInsertAsHeaderByServDoc(ServiceHeaderPar."Document Type", ServiceHeaderPar."No.");
        if ServiceSplittingLine.Count < 2 then begin
            ApplyInsertAsHeaderByServDoc(ServiceHeaderPar."Document Type", ServiceHeaderPar."No.");
            DocsShareMakeFirstFull;
        end;
        if ServiceSplittingLine.FindFirst then begin
            Get(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
              ServiceSplittingLine."Temp. Document No.", ServiceSplittingLine.Line, ServiceSplittingLine."Temp. Line No.");
        end;
    end;


    procedure CreateSpliting()
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        Evaluate("Document Type", GetFilter("Document Type"));
        "Document No." := GetFilter("Document No.");
        ServiceHeader.Get("Document Type", "Document No.");
        CreateSplitingForDoc(ServiceHeader);
    end;


    procedure DocsShareMakeEqual()
    var
        RecCount: Integer;
        TotalUsedPercent: Decimal;
    begin
        if ServiceSplittingLine.FindFirst then begin
            RecCount := ServiceSplittingLine.Count;
            TotalUsedPercent := 0;
            repeat
                ServiceSplittingLine.Validate("Quantity Share %", ROUND(100 / RecCount, 0.01));
                ServiceSplittingLine.Modify;
                TotalUsedPercent += ServiceSplittingLine."Quantity Share %";
            until ServiceSplittingLine.Next = 0;
            if TotalUsedPercent <> 100 then begin
                ServiceSplittingLine.FindLast;
                ServiceSplittingLine.Validate("Quantity Share %", ServiceSplittingLine."Quantity Share %" + (100 - TotalUsedPercent));
                ServiceSplittingLine.Modify;
            end;
        end;
    end;


    procedure DocsShareMakeFirstFull()
    var
        RecCount: Integer;
        TotalUsedPercent: Decimal;
    begin
        if ServiceSplittingLine.FindFirst then begin
            RecCount := ServiceSplittingLine.Count;
            ServiceSplittingLine.Validate("Quantity Share %", 100);
            ServiceSplittingLine.Modify;
            if ServiceSplittingLine.Next <> 0 then
                repeat
                    ServiceSplittingLine.Validate("Quantity Share %", 0);
                    ServiceSplittingLine.Modify;
                until ServiceSplittingLine.Next = 0;
        end;
    end;


    procedure OpenFormForServDoc(var ServiceHeaderPar: Record "Service Header EDMS")
    var
        FormRunResult: action;
    begin
        SetRange(Line, false);
        SetRange("Document Type", ServiceHeaderPar."Document Type");
        SetRange("Document No.", ServiceHeaderPar."No.");
        Page.Run(Page::"Service Splitting", Rec);
        //FormRunResult := PAGE.RUNMODAL(PAGE::"Service Splitting", Rec);
        SetRange(Line, false);
        SetRange("Document Type", ServiceHeaderPar."Document Type");
        SetRange("Document No.", ServiceHeaderPar."No.");

        //IF FINDFIRST THEN
        //IF FormRunResult IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
        //ProceedDocSplit;
        //  END ELSE
        //  IF CONFIRM(Text103, TRUE) THEN BEGIN
        //  DeleteDocSplit;
        //END;
    end;


    procedure CheckDocTotalAmount(var SourceDocAmount: Decimal; var DestDocAmount: Decimal) AmountDiff: Decimal
    var
        ServiceHeaderTmp: Record "Service Header EDMS" temporary;
        ServiceLineTmp: Record "Service Line EDMS" temporary;
        ServiceLine: Record "Service Line EDMS";
        CurrLineNo: Integer;
        LinesCount: Integer;
    begin
        SourceDocAmount := 0;
        if ServiceHdr.Get("Document Type", "Document No.") then begin
            ServiceHdr.CalcFields(Amount);
            if ServiceHdr."Currency Factor" = 0 then
                ServiceHdr."Currency Factor" := 1;
            //  SourceDocAmount := ROUND(ServiceHdr.Amount/ServiceHdr."Currency Factor");
            ServiceLine.Reset;
            ServiceLine.SetRange("Document Type", ServiceHdr."Document Type");
            ServiceLine.SetRange("Document No.", ServiceHdr."No.");
            if ServiceLine.FindFirst then
                repeat
                    SourceDocAmount += ROUND(ServiceLine."Line Amount" / ServiceHdr."Currency Factor");
                until ServiceLine.Next = 0;

            ServiceHeaderTmp.Reset;
            ServiceHeaderTmp.DeleteAll;
            ServiceHeaderTmp := ServiceHdr;
            ServiceHeaderTmp.Insert;
            ServiceLineTmp.Reset;
            ServiceLineTmp.DeleteAll;

            ServiceSplittingHeader.Reset;
            ServiceSplittingHeader.SetRange(Line, false);
            ServiceSplittingHeader.SetRange("Document Type", "Document Type");
            ServiceSplittingHeader.SetRange("Document No.", "Document No.");
            ServiceSplittingLine.Reset;
            ServiceSplittingLine.SetRange(Line, true);
            ServiceSplittingLine.SetRange("Document Type", "Document Type");
            ServiceSplittingLine.SetRange("Document No.", "Document No.");
            if not ServiceSplittingLine.FindFirst then
                Error(Text0003);
            LinesCount := ServiceSplittingLine.Count;
            DestDocAmount := 0;
            CurrLineNo := 0;
            repeat
                if not ServiceLine.Get(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
                      ServiceSplittingLine."Line No.") then
                    Error(Text0004, ServiceLine.TableCaption, Format(ServiceSplittingLine."Document Type") + ', ' +
                      ServiceSplittingLine."Document No." + ', ' + Format(ServiceSplittingLine."Line No."));

                ServiceSplittingHeader.SetRange("Temp. Document No.", ServiceSplittingLine."Temp. Document No.");
                ServiceSplittingHeader.FindFirst;

                ServiceLineTmp.Init;
                ServiceLineTmp.TransferFields(ServiceLine, false);
                ServiceLineTmp."Document Type" := ServiceSplittingHeader."Document Type";
                ServiceLineTmp."Document No." := ServiceSplittingHeader."Document No.";
                CurrLineNo += 10000;
                ServiceLineTmp."Line No." := CurrLineNo;
                ServiceLineTmp."Sell-to Customer No." := ServiceSplittingHeader."Sell-to Customer No.";
                ServiceLineTmp."Bill-to Customer No." := ServiceSplittingHeader."Bill-to Customer No.";
                ServiceLineTmp."Currency Code" := ServiceSplittingHeader."Currency Code";
                ServiceLineTmp.Validate("No.", ServiceSplittingLine."No.");
                ServiceLineTmp.Validate("Location Code", ServiceSplittingLine."Location Code");
                ServiceLineTmp.Validate(Quantity, ServiceSplittingLine."New Quantity");
                ServiceLineTmp.Validate("Unit Price", ServiceSplittingLine."Unit Price");
                ServiceLineTmp.Insert(true);
                //    ServiceLineTmp.MODIFY(TRUE);

                ServiceHeaderTmp.Validate("Currency Code", ServiceSplittingHeader."Currency Code");
                if ServiceHeaderTmp."Currency Factor" = 0 then
                    ServiceHeaderTmp."Currency Factor" := 1;

                DestDocAmount += ROUND(ServiceLineTmp."Line Amount" / ServiceHeaderTmp."Currency Factor");
            until ServiceSplittingLine.Next = 0;
            AmountDiff := SourceDocAmount - DestDocAmount;
        end else
            Error(Text0004, ServiceHdr.TableCaption, Format("Document Type") + ', ' + "Document No.");
        exit(AmountDiff);
    end;


    procedure FindFirstForApp(var ServiceSplittingLinePar: Record "Service Splitting Line"; ServLaborAllocApplicationPar: Record "Serv. Labor Alloc. Application"; TempDocNo: Integer): Boolean
    begin
        ServiceSplittingLinePar.SetRange("Document Type", ServLaborAllocApplicationPar."Document Type");
        ServiceSplittingLinePar.SetRange("Document No.", ServLaborAllocApplicationPar."Document No.");
        ServiceSplittingLinePar.SetRange("Temp. Document No.", TempDocNo);
        if ServLaborAllocApplicationPar."Document Line No." > 0 then begin
            ServiceSplittingLinePar.SetRange(Line, true);
            ServiceSplittingLinePar.SetRange("Line No.", ServLaborAllocApplicationPar."Document Line No.");
        end else begin
            ServiceSplittingLinePar.SetRange(Line, false);
            ServiceSplittingLinePar.SetRange("Line No.");
        end;
        exit(ServiceSplittingLinePar.FindFirst);
    end;


    procedure CopyFldsServL2SplitLine(ServiceLinePar: Record "Service Line EDMS"; var ServiceSplittingLinePar: Record "Service Splitting Line"): Integer
    begin
        ServiceSplittingLinePar."Document Type" := ServiceLinePar."Document Type";
        ServiceSplittingLinePar."Document No." := ServiceLinePar."Document No.";
        ServiceSplittingLinePar."Sell-to Customer No." := ServiceLinePar."Sell-to Customer No.";
        ServiceSplittingLinePar."Line No." := ServiceLinePar."Line No.";
        ServiceSplittingLinePar.Type := ServiceLinePar.Type;
        ServiceSplittingLinePar."No." := ServiceLinePar."No.";
        ServiceSplittingLinePar."Location Code" := ServiceLinePar."Location Code";
        ServiceSplittingLinePar.Description := ServiceLinePar.Description;
        ServiceSplittingLinePar."Description 2" := ServiceLinePar."Description 2";
        ServiceSplittingLinePar."Unit of Measure" := ServiceLinePar."Unit of Measure";
        ServiceSplittingLinePar.Quantity := ServiceLinePar.Quantity;
        ServiceSplittingLinePar."Outstanding Quantity" := ServiceLinePar."Outstanding Quantity";
        ServiceSplittingLinePar."Unit Price" := ServiceLinePar."Unit Price";
        ServiceSplittingLinePar."Unit Cost (LCY)" := ServiceLinePar."Unit Cost (LCY)";
        ServiceSplittingLinePar."VAT %" := ServiceLinePar."VAT %";
        ServiceSplittingLinePar."Line Discount %" := ServiceLinePar."Line Discount %";
        ServiceSplittingLinePar."Line Discount Amount" := ServiceLinePar."Line Discount Amount";
        ServiceSplittingLinePar.Amount := ServiceLinePar.Amount;
        ServiceSplittingLinePar."Amount Including VAT" := ServiceLinePar."Amount Including VAT";
        ServiceSplittingLinePar."Allow Invoice Disc." := ServiceLinePar."Allow Invoice Disc.";
        ServiceSplittingLinePar."Shortcut Dimension 1 Code" := ServiceLinePar."Shortcut Dimension 1 Code";
        ServiceSplittingLinePar."Shortcut Dimension 2 Code" := ServiceLinePar."Shortcut Dimension 2 Code";
        ServiceSplittingLinePar."Bill-to Customer No." := ServiceLinePar."Bill-to Customer No.";
        ServiceSplittingLinePar."Inv. Discount Amount" := ServiceLinePar."Inv. Discount Amount";
        ServiceSplittingLinePar."Gen. Bus. Posting Group" := ServiceLinePar."Gen. Bus. Posting Group";
        ServiceSplittingLinePar."Gen. Prod. Posting Group" := ServiceLinePar."Gen. Prod. Posting Group";
        ServiceSplittingLinePar."VAT Calculation Type" := ServiceLinePar."VAT Calculation Type";
        ServiceSplittingLinePar."VAT Bus. Posting Group" := ServiceLinePar."VAT Bus. Posting Group";
        ServiceSplittingLinePar."VAT Prod. Posting Group" := ServiceLinePar."VAT Prod. Posting Group";
        ServiceSplittingLinePar."Currency Code" := ServiceLinePar."Currency Code";
        ServiceSplittingLinePar.Reserve := ServiceLinePar.Reserve;
        ServiceSplittingLinePar."VAT Base Amount" := ServiceLinePar."VAT Base Amount";
        ServiceSplittingLinePar."Unit Cost" := ServiceLinePar."Unit Cost";
        ServiceSplittingLinePar."System-Created Entry" := ServiceLinePar."System-Created Entry";
        ServiceSplittingLinePar."Line Amount" := ServiceLinePar."Line Amount";
        ServiceSplittingLinePar."VAT Difference" := ServiceLinePar."VAT Difference";
        ServiceSplittingLinePar."Inv. Disc. Amount to Invoice" := ServiceLinePar."Inv. Disc. Amount to Invoice";
        ServiceSplittingLinePar."VAT Identifier" := ServiceLinePar."VAT Identifier";
        ServiceSplittingLinePar."Prepayment %" := ServiceLinePar."Prepayment %";
        ServiceSplittingLinePar."Prepmt. Line Amount" := ServiceLinePar."Prepmt. Line Amount";
        ServiceSplittingLinePar."Prepmt. Amt. Inv." := ServiceLinePar."Prepmt. Amt. Inv.";
        ServiceSplittingLinePar."Prepmt. Amt. Incl. VAT" := ServiceLinePar."Prepmt. Amt. Incl. VAT";
        ServiceSplittingLinePar."Prepayment Amount" := ServiceLinePar."Prepayment Amount";
        ServiceSplittingLinePar."Prepmt. VAT Base Amt." := ServiceLinePar."Prepmt. VAT Base Amt.";
        ServiceSplittingLinePar."Prepayment VAT %" := ServiceLinePar."Prepayment VAT %";
        ServiceSplittingLinePar."Prepmt. VAT Calc. Type" := ServiceLinePar."Prepmt. VAT Calc. Type";
        ServiceSplittingLinePar."Prepayment VAT Identifier" := ServiceLinePar."Prepayment VAT Identifier";
        ServiceSplittingLinePar."Prepayment Tax Area Code" := ServiceLinePar."Prepayment Tax Area Code";
        ServiceSplittingLinePar."Prepayment Tax Liable" := ServiceLinePar."Prepayment Tax Liable";
        ServiceSplittingLinePar."Prepayment Tax Group Code" := ServiceLinePar."Prepayment Tax Group Code";
        ServiceSplittingLinePar."Prepmt Amt to Deduct" := ServiceLinePar."Prepmt Amt to Deduct";
        ServiceSplittingLinePar."Prepmt Amt Deducted" := ServiceLinePar."Prepmt Amt Deducted";
        ServiceSplittingLinePar."Prepayment Line" := ServiceLinePar."Prepayment Line";
        ServiceSplittingLinePar."Prepmt. Amount Inv. Incl. VAT" := ServiceLinePar."Prepayment Amount Incl. VAT";
        ServiceSplittingLinePar."Variant Code" := ServiceLinePar."Variant Code";
        ServiceSplittingLinePar."Bin Code" := ServiceLinePar."Bin Code";
        ServiceSplittingLinePar."Qty. per Unit of Measure" := ServiceLinePar."Qty. per Unit of Measure";
        ServiceSplittingLinePar.Planned := ServiceLinePar.Planned;
        ServiceSplittingLinePar."Unit of Measure Code" := ServiceLinePar."Unit of Measure Code";
        ServiceSplittingLinePar."Quantity (Base)" := ServiceLinePar."Quantity (Base)";
        ServiceSplittingLinePar."Outstanding Qty. (Base)" := ServiceLinePar."Outstanding Qty. (Base)";
        ServiceSplittingLinePar."Responsibility Center" := ServiceLinePar."Responsibility Center";
        ServiceSplittingLinePar."Unit of Measure (Cross Ref.)" := ServiceLinePar."Unit of Measure (Cross Ref.)";
        ServiceSplittingLinePar."Item Category Code" := ServiceLinePar."Item Category Code";
        ServiceSplittingLinePar.Nonstock := ServiceLinePar.Nonstock;
        ServiceSplittingLinePar."Product Group Code" := ServiceLinePar."Product Group Code";
        ServiceSplittingLinePar."Requested Delivery Date" := ServiceLinePar."Requested Delivery Date";
        ServiceSplittingLinePar."Promised Delivery Date" := ServiceLinePar."Promised Delivery Date";
        ServiceSplittingLinePar."Qty. to Consume" := ServiceLinePar."Qty. to Consume";
        ServiceSplittingLinePar."Quantity Consumed" := ServiceLinePar."Quantity Consumed";
        ServiceSplittingLinePar."Qty. to Consume (Base)" := ServiceLinePar."Qty. to Consume (Base)";
        ServiceSplittingLinePar."Qty. Consumed (Base)" := ServiceLinePar."Qty. Consumed (Base)";
        ServiceSplittingLinePar."Allow Line Disc." := ServiceLinePar."Allow Line Disc.";
        ServiceSplittingLinePar."Customer Disc. Group" := ServiceLinePar."Customer Disc. Group";
        ServiceSplittingLinePar."External No." := ServiceLinePar."External No.";
        ServiceSplittingLinePar."Planned Service Date" := ServiceLinePar."Planned Service Date";
        ServiceSplittingLinePar."Deal Type Code" := ServiceLinePar."Deal Type Code";
        ServiceSplittingLinePar."Product Subgroup Code" := "Product Subgroup Code";
        ServiceSplittingLinePar.Prepayment := Prepayment;
        ServiceSplittingLinePar."Campaign No." := ServiceLinePar."Campaign No.";
        ServiceSplittingLinePar."External Serv. Tracking No." := ServiceLinePar."External Serv. Tracking No.";
        ServiceSplittingLinePar."Standard Time" := ServiceLinePar."Standard Time";
        ServiceSplittingLinePar."Standard Time Line No." := ServiceLinePar."Standard Time Line No.";
        ServiceSplittingLinePar."Vehicle Registration No." := ServiceLinePar."Vehicle Registration No.";
        ServiceSplittingLinePar."Model Code" := ServiceLinePar."Model Code";
        ServiceSplittingLinePar."Package No." := ServiceLinePar."Package No.";
        ServiceSplittingLinePar."Make Code" := ServiceLinePar."Make Code";
        ServiceSplittingLinePar."Service Work Shift Code" := ServiceLinePar."Service Work Shift Code";
        ServiceSplittingLinePar."Package Version No." := ServiceLinePar."Package Version No.";
        ServiceSplittingLinePar."Package Version Spec. Line No." := ServiceLinePar."Package Version Spec. Line No.";
        ServiceSplittingLinePar.VIN := ServiceLinePar.VIN;
        ServiceSplittingLinePar."Vehicle Accounting Cycle No." := ServiceLinePar."Vehicle Accounting Cycle No.";
        ServiceSplittingLinePar."Sell-to Customer Bill %" := "Sell-to Customer Bill %";
        ServiceSplittingLinePar."Sell-to Customer Bill Amount" := "Sell-to Customer Bill Amount";
        ServiceSplittingLinePar."Ordering Price Type Code" := ServiceLinePar."Ordering Price Type Code";
        ServiceSplittingLinePar."DMS Variable Field 25006800" := "DMS Variable Field 25006800";
        ServiceSplittingLinePar."DMS Variable Field 25006801" := "DMS Variable Field 25006801";
        ServiceSplittingLinePar."DMS Variable Field 25006802" := "DMS Variable Field 25006802";
        ServiceSplittingLinePar."Contract No." := ServiceLinePar."Contract No.";
        ServiceSplittingLinePar."Job No." := ServiceLinePar."Job No.";
        ServiceSplittingLinePar.Split := ServiceLinePar.Split;
        ServiceSplittingLinePar.Status := ServiceLinePar.Status;
        ServiceSplittingLinePar."BOM Item No." := ServiceLinePar."BOM Item No.";
        ServiceSplittingLinePar."Sell-to Customer Name" := ServiceLinePar."Sell-to Customer Name";
        ServiceSplittingLinePar."Bill-to Name" := ServiceLinePar."Bill-to Name";
        exit(0);
    end;


    procedure CopyFldsServH2SplitLine(ServiceHeaderPar: Record "Service Header EDMS"; var ServiceSplittingLinePar: Record "Service Splitting Line"): Integer
    begin
        ServiceSplittingLinePar.Init;
        ServiceSplittingLinePar."Document Type" := ServiceHeaderPar."Document Type";
        ServiceSplittingLinePar."Document No." := ServiceHeaderPar."No.";
        ServiceSplittingLinePar."Sell-to Customer No." := ServiceHeaderPar."Sell-to Customer No.";
        ServiceSplittingLinePar."Line No." := 0;
        ServiceSplittingLinePar.Type := 0;
        ServiceSplittingLinePar."No." := '';
        ServiceSplittingLinePar."Location Code" := ServiceHeaderPar."Location Code";
        ServiceSplittingLinePar.Description := ServiceHeaderPar.Description;
        ServiceSplittingLinePar.Amount := ServiceHeaderPar.Amount;
        ServiceSplittingLinePar."Amount Including VAT" := ServiceHeaderPar."Amount Including VAT";
        ServiceSplittingLinePar."Allow Invoice Disc." := ServiceHeaderPar."Allow Line Disc.";
        ServiceSplittingLinePar."Shortcut Dimension 1 Code" := ServiceHeaderPar."Shortcut Dimension 1 Code";
        ServiceSplittingLinePar."Shortcut Dimension 2 Code" := ServiceHeaderPar."Shortcut Dimension 2 Code";
        ServiceSplittingLinePar."Bill-to Customer No." := ServiceHeaderPar."Bill-to Customer No.";
        ServiceSplittingLinePar."Inv. Discount Amount" := ServiceHeaderPar."Invoice Discount Value";
        ServiceSplittingLinePar."Gen. Bus. Posting Group" := ServiceHeaderPar."Gen. Bus. Posting Group";
        ServiceSplittingLinePar."Gen. Prod. Posting Group" := ServiceHeaderPar."Gen. Prod. Posting Group";
        ServiceSplittingLinePar."Currency Code" := ServiceHeaderPar."Currency Code";
        ServiceSplittingLinePar."Prepayment %" := ServiceHeaderPar."Prepayment %";
        ServiceSplittingLinePar."Responsibility Center" := ServiceHeaderPar."Responsibility Center";
        ServiceSplittingLinePar."Customer Disc. Group" := ServiceHeaderPar."Customer Disc. Group";
        ServiceSplittingLinePar."External No." := ServiceHeaderPar."External Document No.";
        ServiceSplittingLinePar."Planned Service Date" := ServiceHeaderPar."Planned Service Date";
        ServiceSplittingLinePar."Deal Type Code" := ServiceHeaderPar."Deal Type";
        ServiceSplittingLinePar."Campaign No." := ServiceHeaderPar."Campaign No.";
        ServiceSplittingLinePar."External Serv. Tracking No." := "External Serv. Tracking No.";
        ServiceSplittingLinePar."Vehicle Registration No." := ServiceHeaderPar."Vehicle Registration No.";
        ServiceSplittingLinePar."Model Code" := ServiceHeaderPar."Model Code";
        ServiceSplittingLinePar."Make Code" := ServiceHeaderPar."Make Code";
        ServiceSplittingLinePar.VIN := ServiceHeaderPar.VIN;
        ServiceSplittingLinePar."Vehicle Accounting Cycle No." := ServiceHeaderPar."Vehicle Accounting Cycle No.";
        ServiceSplittingLinePar.Split := Split;
        ServiceSplittingLinePar."Sell-to Customer Name" := ServiceHeaderPar."Sell-to Customer Name";
        ServiceSplittingLinePar."Bill-to Name" := ServiceHeaderPar."Bill-to Name";
        exit(0);
    end;


    procedure ChangeIncludeInfo(NewQty: Decimal)
    begin
        ServiceSplittingLine.Reset;
        ServiceSplittingLine.SetRange("Document Type", "Document Type");
        ServiceSplittingLine.SetRange("Document No.", "Document No.");
        ServiceSplittingLine.SetRange("Line No.", "Line No.");
        ServiceSplittingLine.SetFilter("Temp. Document No.", '<>%1&<>%2', "Temp. Document No.", 0);
        ServiceSplittingLine.SetRange(Include, Include);
        if ServiceSplittingLine.FindFirst then begin
            ServiceSplittingLine.Validate("New Quantity", NewQty);
            ServiceSplittingLine.Include := not Include;
            ServiceSplittingLine.Modify;
        end;
    end;


    procedure CreateLinesForQuote(ServiceHeader: Record "Service Header EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
    begin
        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        if ServiceLine.FindSet then
            repeat
                ServiceSplittingLine.Init;
                CopyFldsServL2SplitLine(ServiceLine, ServiceSplittingLine);
                ServiceSplittingLine.Line := true;
                ServiceSplittingLine."Temp. Line No." := ServiceLine."Line No.";
                ServiceSplittingLine.Insert;
            until ServiceLine.Next = 0;
    end;


    procedure CreateQuote()
    var
        ServiceHeaderQ: Record "Service Header EDMS";
        ServiceHeader: Record "Service Header EDMS";
        NextLineNo: Integer;
        ServiceLineQ: Record "Service Line EDMS";
        ServiceLine: Record "Service Line EDMS";
        ServiceAllocEntry: Record "Serv. Labor Allocation Entry";
        TransferLine: Record "Transfer Line";
    begin
        if not ServiceHeader.Get("Document Type", "Document No.") then
            Error(Text0002, ServiceHeader.TableCaption);

        ServiceAllocEntry.Reset;
        ServiceAllocEntry.SetCurrentkey("Source Type", "Source Subtype", "Source ID");
        ServiceAllocEntry.SetRange("Source Type", ServiceAllocEntry."source type"::"Service Document");
        ServiceAllocEntry.SetRange("Source Subtype", ServiceAllocEntry."source subtype"::Order);
        ServiceAllocEntry.SetRange("Source ID", "Document No.");
        ServiceAllocEntry.SetFilter(Status, '%1|%2', ServiceAllocEntry.Status::"In Progress", ServiceAllocEntry.Status::"On Hold");
        if ServiceAllocEntry.FindFirst then
            Error(Text007);

        NextLineNo := 10000;
        ServiceSplittingLine.Reset;
        ServiceSplittingLine.SetRange("Document Type", "Document Type");
        ServiceSplittingLine.SetRange("Document No.", "Document No.");
        ServiceSplittingLine.SetRange(Line, true);
        ServiceSplittingLine.SetRange("Create Quote", true);
        if ServiceSplittingLine.FindSet then begin
            ServiceHeaderQ.Init;
            ServiceHeaderQ."Document Type" := ServiceHeaderQ."document type"::Quote;
            ServiceHeaderQ.Insert(true);
            ServiceHeaderQ.TransferFields(ServiceHeader, false);
            ServiceHeaderQ.Modify;

            ServiceLineQ.Init;
            ServiceLineQ."Document Type" := ServiceHeaderQ."Document Type";
            ServiceLineQ."Document No." := ServiceHeaderQ."No.";
            ServiceLineQ."Line No." := NextLineNo;
            ServiceLineQ.Description := StrSubstNo(Text108, ServiceHeader."No.");
            ServiceLineQ.Insert;
            repeat
                if not ServiceLine.Get(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.", ServiceSplittingLine."Temp. Line No.") then
                    Error(Text0004, ServiceLine.TableCaption, Format(ServiceSplittingLine."Document Type") + ', ' +
                          ServiceSplittingLine."Document No." + ', ' + Format(ServiceSplittingLine."Line No."));

                if ServiceLine.Type = ServiceLine.Type::Item then begin
                    if ServiceLine.CalcTransferedQuantity <> 0 then
                        Error(Text106, ServiceLine."Line No.");

                    if ServiceTransferMgt.FindTransferLine(ServiceLine, TransferLine) then
                        Error(Text110, ServiceLine."No.");
                end;

                if ServiceLine.Type = ServiceLine.Type::Labor then
                    if ServiceLine.GetResourceTextFieldValue <> '' then
                        Error(Text109, ServiceLine."No.");

                NextLineNo := NextLineNo + 10000;
                ServiceLineQ.Init;
                ServiceLineQ := ServiceLine;
                ServiceLineQ."Document Type" := ServiceHeaderQ."Document Type";
                ServiceLineQ."Document No." := ServiceHeaderQ."No.";
                ServiceLineQ."Line No." := NextLineNo;
                ServiceLineQ.Insert(true);
                ServiceLine.Delete(true);
            until ServiceSplittingLine.Next = 0;

            Message(Text107, ServiceHeaderQ."No.");
            DeleteDocQuote(ServiceHeader."Document Type", ServiceHeader."No.");
        end else
            Error(Text0003);
    end;


    procedure DeleteDocQuote(DocType: Option Quote,"Order","Return Order"; DocNo: Code[20])
    begin
        ServiceSplittingLine.Reset;
        ServiceSplittingLine.SetRange(Line, true);
        ServiceSplittingLine.SetRange("Document Type", "Document Type");
        ServiceSplittingLine.SetRange("Document No.", "Document No.");
        ServiceSplittingLine.SetRange("Temp. Document No.", 0);
        ServiceSplittingLine.DeleteAll;
    end;


    procedure CreateNewAllocApp(ServLaborAllocationEntryPar: Record "Serv. Labor Allocation Entry"; ServLaborAllocApplicationPar: Record "Serv. Labor Alloc. Application"; DocType: Integer; DocNo: Code[20]; LineNo: Integer; var NewAllocEntryNoPar: Integer)
    begin
        //ServiceScheduleMgt.CreateNewAllocEntry(StartingDateTime,ResourceNo,Hours,SourceType,SourceID,LineNo,ReasonCode,PlanningPolicy,FinishedHours,RemainingHours,Status)
        if NewAllocEntryNoPar = 0 then
            NewAllocEntryNoPar := ServiceScheduleMgt.CreateNewAllocEntry(ServLaborAllocationEntryPar."Start Date-Time", ServLaborAllocationEntryPar."Resource No.",
              ServLaborAllocationEntryPar."Quantity (Hours)", DocType, DocNo, LineNo, ServLaborAllocationEntryPar."Reason Code",
              ServLaborAllocationEntryPar."Planning Policy", ServLaborAllocApplicationPar."Finished Quantity (Hours)",
              ServLaborAllocApplicationPar."Remaining Quantity (Hours)", ServLaborAllocationEntryPar.Status)
        else
            ServiceScheduleMgt.CreateAppEntry(NewAllocEntryNoPar, DocType, DocNo, LineNo, ServLaborAllocationEntryPar."Resource No.",
              // ServLaborAllocApplicationPar."Finished Quantity (Hours)", ServLaborAllocApplicationPar."Remaining Quantity (Hours)", TRUE);   // 18.12.2014 Elva Baltic P21 #E0003
              ServLaborAllocApplicationPar."Finished Quantity (Hours)", ServLaborAllocApplicationPar."Remaining Quantity (Hours)", false);     // 18.12.2014 Elva Baltic P21 #E0003
    end;

    local procedure CopyHeaderComments(ServiceHeaderSpl: Record "Service Header EDMS"; ServiceHeaderNew: Record "Service Header EDMS")
    var
        ServCommentLine: Record "Service Comment Line EDMS";
        ServCommentLine2: Record "Service Comment Line EDMS";
    begin
        ServCommentLine.Reset;
        if ServiceHeaderSpl."Document Type" = ServiceHeaderSpl."document type"::Order then
            ServCommentLine.SetRange(Type, ServCommentLine.Type::"Service Order")
        else
            exit;
        ServCommentLine.SetRange("No.", ServiceHeaderSpl."No.");
        if ServCommentLine.Find('-') then
            repeat
                ServCommentLine.CalcFields("Extended Comment (BLOB)");
                ServCommentLine2.Init;
                ServCommentLine2.TransferFields(ServCommentLine);
                ServCommentLine2."No." := ServiceHeaderNew."No.";
                ServCommentLine2.Insert;
            until ServCommentLine.Next = 0;
    end;
}

