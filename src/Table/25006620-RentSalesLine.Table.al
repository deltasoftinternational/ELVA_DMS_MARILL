Table 25006620 "Rent Sales Line"
{

    fields
    {
        field(10; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = Quote,"Order";
        }
        field(20; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(40; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(60; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),External Service';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)","External Service";
        }
        field(70; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item where("Item Type" = filter(" " | Item))
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const("External Service")) "External Service";

            trigger OnValidate()
            begin
                case Type of
                    Type::" ":
                        begin
                            StdTxt.Get("No.");
                            Description := StdTxt.Description;
                        end;
                    Type::"G/L Account":
                        begin
                            GLAcc.Get("No.");
                            GLAcc.CheckGLAcc;
                            Description := GLAcc.Name;
                            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                            "Tax Group Code" := GLAcc."Tax Group Code";
                        end;
                    Type::Item:
                        begin
                            GetItem;
                            Description := Item.Description;
                            "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                            "Tax Group Code" := Item."Tax Group Code";
                            "Unit of Measure Code" := Item."Sales Unit of Measure";
                        end;
                    Type::Resource:
                        begin
                            Res.Get("No.");
                            Description := Res.Name;
                            "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
                            "Tax Group Code" := Res."Tax Group Code";
                        end;
                    Type::"Fixed Asset":
                        begin
                            FA.Get("No.");
                            FA.TestField(Inactive, false);
                            FA.TestField(Blocked, false);
                            Description := FA.Description;
                            GetFAPostingGroup;
                        end;
                    Type::"Charge (Item)":
                        begin
                            ItemCharge.Get("No.");
                            Description := ItemCharge.Description;
                            "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
                            "Tax Group Code" := ItemCharge."Tax Group Code";
                        end;
                end;

                if Type <> Type::" " then begin
                    if Type <> Type::"Fixed Asset" then
                        Validate("VAT Prod. Posting Group");
                    Validate("Unit of Measure Code");
                    UpdateUnitPrice(FieldNo("No."));
                    UpdateAmounts;
                end;

                CallCreateDim;
            end;
        }
        field(80; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(90; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(95; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(100; "Attached to Rent Line No."; Integer)
        {
            Caption = 'Attached to Rent Line No.';
            Editable = false;
        }
        field(105; "Attach. to Rent Sales Line No."; Integer)
        {
            Caption = 'Attached to Rent Sales Line No.';
        }
        field(111; "Prepmt. Amt. Inv."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Amt. Inv."));
            Caption = 'Prepmt. Amt. Inv.';
            Editable = false;
        }
        field(120; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                UpdateAmounts;
            end;
        }
        field(130; "Quantity Shipped"; Decimal)
        {
            Caption = 'Quantity Shipped';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(140; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(150; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            Editable = false;
        }
        field(160; "Return Qty. to Receive"; Decimal)
        {
            Caption = 'Return Qty. to Receive';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
            end;
        }
        field(170; "Return Qty. Received"; Decimal)
        {
            Caption = 'Return Qty. Received';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(180; "Return Receipt No."; Code[20])
        {
            Caption = 'Return Receipt No.';
            Editable = false;
        }
        field(190; "Purch. Order Line No."; Integer)
        {
            Caption = 'Purch. Order Line No.';
            Editable = false;
        }
        field(200; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
            begin
            end;
        }
        field(210; Reserve; Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;

            trigger OnValidate()
            begin
                if Reserve <> Reserve::Never then begin
                    TestField(Type, Type::Item);
                    TestField("No.");
                end;
                CalcFields("Reserved Qty. (Base)");
                if (Reserve = Reserve::Never) and ("Reserved Qty. (Base)" > 0) then
                    TestField("Reserved Qty. (Base)", 0);

                if xRec.Reserve = Reserve::Always then begin
                    GetItem;
                    if Item.Reserve = Item.Reserve::Always then
                        TestField(Reserve, Reserve::Always);
                end;
            end;
        }
        field(220; "Planned Shipment Date"; Date)
        {
            Caption = 'Planned Shipment Date';
        }
        field(230; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
        }
        field(240; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateDates;
            end;
        }
        field(250; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateDates;
            end;
        }
        field(260; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Requested Delivery Date" <> xRec."Requested Delivery Date") and
                   ("Promised Delivery Date" <> 0D)
                then
                    Error(
                      Text028,
                      FieldCaption("Requested Delivery Date"),
                      FieldCaption("Promised Delivery Date"));

                if "Requested Delivery Date" <> 0D then
                    Validate("Planned Delivery Date", "Requested Delivery Date")
                else begin
                    GetRentHeader;
                    Validate("Shipment Date", RentHeader."Shipment Date");
                end;
            end;
        }
        field(270; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Promised Delivery Date" <> 0D then
                    Validate("Planned Delivery Date", "Promised Delivery Date")
                else
                    Validate("Requested Delivery Date");
            end;
        }
        field(280; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(290; "Job Contract Entry No."; Integer)
        {
            Caption = 'Job Contract Entry No.';
            Editable = false;

            trigger OnValidate()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
                JobPlanningLine.SetRange("Job Contract Entry No.", "Job Contract Entry No.");
                JobPlanningLine.Find('-');
            end;
        }
        field(300; Nonstock; Boolean)
        {
            Caption = 'Nonstock';
            Editable = false;
        }
        field(310; "Special Order"; Boolean)
        {
            Caption = 'Special Order';
            Editable = false;
        }
        field(320; "Reserved Qty. (Base)"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Source ID" = field("Document No."),
                                                                            "Source Ref. No." = field("Line No."),
                                                                            "Source Type" = const(37),
                                                                            "Source Subtype" = field("Document Type"),
                                                                            "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure");
                CalcFields("Reserved Quantity");
                Planned := "Reserved Quantity" = "Outstanding Quantity";
            end;
        }
        field(330; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(340; "Reserved Quantity"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry".Quantity where("Source ID" = field("Document No."),
                                                                   "Source Ref. No." = field("Line No."),
                                                                   "Source Type" = const(37),
                                                                   "Source Subtype" = field("Document Type"),
                                                                   "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(350; Planned; Boolean)
        {
            Caption = 'Planned';
            Editable = false;
        }
        field(360; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                TestStatusOpen;
                Validate("Line Discount %");
            end;
        }
        field(370; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(380; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen;
                "Line Discount Amount" :=
                  ROUND(
                    ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100, Currency."Amount Rounding Precision");
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(390; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            begin
                TestStatusOpen;
                TestField(Quantity);
                if ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") <> 0 then
                    "Line Discount %" :=
                      ROUND(
                        "Line Discount Amount" / ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") * 100,
                        0.00001)
                else
                    "Line Discount %" := 0;
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(400; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            Editable = false;

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(410; "Inv. Disc. Amount to Invoice"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            Editable = false;
        }
        field(420; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Allow Invoice Disc." <> xRec."Allow Invoice Disc.") and
                   (not "Allow Invoice Disc.")
                then begin
                    "Inv. Discount Amount" := 0;
                    "Inv. Disc. Amount to Invoice" := 0;
                    UpdateAmounts;
                end;
            end;
        }
        field(430; "Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            Caption = 'Line Amount';

            trigger OnValidate()
            begin
                TestField(Type);
                TestField(Quantity);
                TestField("Unit Price");
                GetRentHeader;
                "Line Amount" := ROUND("Line Amount", Currency."Amount Rounding Precision");
                Validate(
                  "Line Discount Amount", ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Amount");
            end;
        }
        field(440; "VAT Difference"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(450; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                GenPostingSetup: Record "General Posting Setup";
                GLAcc: Record "G/L Account";
                GenLedgSetup: Record "General Ledger Setup";
                SalesSetup: Record "Sales & Receivables Setup";
            begin
            end;
        }
        field(460; "Prepmt. Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Line Amount"));
            Caption = 'Prepmt. Line Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen;
                TestField("Line Amount");
                if "Prepmt. Line Amount" < "Prepmt. Amt. Inv." then
                    FieldError("Prepmt. Line Amount", StrSubstNo(Text044, "Prepmt. Amt. Inv."));
                if "Prepmt. Line Amount" > "Line Amount" then
                    FieldError("Prepmt. Line Amount", StrSubstNo(Text043, "Line Amount"));
                Validate("Prepayment %", ROUND("Prepmt. Line Amount" * 100 / "Line Amount", 0.00001));
            end;
        }
        field(470; "Outstanding Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Outstanding Amount';
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(485; "Shipped Not Invoiced"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Shipped Not Invoiced';
            Editable = false;

            trigger OnValidate()
            var
                Currency2: Record Currency;
            begin
            end;
        }
        field(490; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(500; "VAT Identifier"; Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(510; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateAmounts;
            end;
        }
        field(520; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;

            trigger OnValidate()
            begin
                Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                case "VAT Calculation Type" of
                    "vat calculation type"::"Normal VAT",
                    "vat calculation type"::"Reverse Charge VAT":
                        begin
                            "VAT Base Amount" :=
                              ROUND(Amount * (1 - RentHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              ROUND(Amount + "VAT Base Amount" * "VAT %" / 100, Currency."Amount Rounding Precision");
                        end;
                    "vat calculation type"::"Full VAT":
                        if Amount <> 0 then
                            FieldError(Amount,
                              StrSubstNo(
                                Text009, FieldCaption("VAT Calculation Type"),
                                "VAT Calculation Type"));
                    "vat calculation type"::"Sales Tax":
                        begin
                            RentHeader.TestField("VAT Base Discount %", 0);
                            "VAT Base Amount" := ROUND(Amount, Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              Amount +
                              SalesTaxCalculate.CalculateTax(
                                "Tax Area Code", "Tax Group Code", "Tax Liable", RentHeader."Posting Date",
                                "VAT Base Amount", "Quantity (Base)", RentHeader."Currency Factor");
                            if "VAT Base Amount" <> 0 then
                                "VAT %" :=
                                  ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                            else
                                "VAT %" := 0;
                            "Amount Including VAT" := ROUND("Amount Including VAT", Currency."Amount Rounding Precision");
                        end;
                end;
            end;
        }
        field(530; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(540; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;

            trigger OnValidate()
            begin
                "Amount Including VAT" := ROUND("Amount Including VAT", Currency."Amount Rounding Precision");
                case "VAT Calculation Type" of
                    "vat calculation type"::"Normal VAT",
                    "vat calculation type"::"Reverse Charge VAT":
                        begin
                            Amount :=
                              ROUND(
                                "Amount Including VAT" /
                                (1 + (1 - RentHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                                Currency."Amount Rounding Precision");
                            "VAT Base Amount" :=
                              ROUND(Amount * (1 - RentHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                        end;
                    "vat calculation type"::"Full VAT":
                        begin
                            Amount := 0;
                            "VAT Base Amount" := 0;
                        end;
                    "vat calculation type"::"Sales Tax":
                        begin
                            RentHeader.TestField("VAT Base Discount %", 0);
                            Amount :=
                              SalesTaxCalculate.ReverseCalculateTax(
                                "Tax Area Code", "Tax Group Code", "Tax Liable", RentHeader."Posting Date",
                                "Amount Including VAT", "Quantity (Base)", RentHeader."Currency Factor");
                            if Amount <> 0 then
                                "VAT %" :=
                                  ROUND(100 * ("Amount Including VAT" - Amount) / Amount, 0.00001)
                            else
                                "VAT %" := 0;
                            Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                            "VAT Base Amount" := Amount;
                        end;
                end;
            end;
        }
        field(550; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(560; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(580; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';

            trigger OnValidate()
            begin
                if "Unit Cost (LCY)" <> xRec."Unit Cost (LCY)" then
                    CheckAssocPurchOrder(FieldCaption("Unit Cost (LCY)"));

                if (CurrFieldNo = FieldNo("Unit Cost (LCY)")) and
                   (Type = Type::Item) and ("No." <> '') and ("Quantity (Base)" <> 0)
                then begin
                    GetItem;
                    if (Item."Costing Method" = Item."costing method"::Standard) and not IsShipment then begin
                        Error(
                          Text038,
                          FieldCaption("Unit Cost (LCY)"), Item.FieldCaption("Costing Method"),
                          Item."Costing Method", FieldCaption(Quantity));
                    end;
                end;

                GetRentHeader;
                if RentHeader."Currency Code" <> '' then begin
                    Currency.TestField("Unit-Amount Rounding Precision");
                    "Unit Cost" :=
                      ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          GetDate, RentHeader."Currency Code",
                          "Unit Cost (LCY)", RentHeader."Currency Factor"),
                        Currency."Unit-Amount Rounding Precision")
                end else
                    "Unit Cost" := "Unit Cost (LCY)";
            end;
        }
        field(590; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(595; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(600; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(610; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(620; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField("Job Contract Entry No.", 0);
                TestField("Qty. per Unit of Measure", 1);
                Validate(Quantity, "Quantity (Base)");
                UpdateUnitPrice(FieldNo("Quantity (Base)"));
            end;
        }
        field(630; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
        }
        field(640; "Special Order Purch. Line No."; Integer)
        {
            Caption = 'Special Order Purch. Line No.';
            TableRelation = if ("Special Order" = const(true)) "Purchase Line"."Line No." where("Document Type" = const(Order),
                                                                                               "Document No." = field("Special Order Purchase No."));
        }
        field(650; "Special Order Purchase No."; Code[20])
        {
            Caption = 'Special Order Purchase No.';
            TableRelation = if ("Special Order" = const(true)) "Purchase Header"."No." where("Document Type" = const(Order));
        }
        field(660; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(670; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(680; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(690; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(700; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Shipping Agent Code" <> xRec."Shipping Agent Code" then
                    Validate("Shipping Agent Service Code", '');
            end;
        }
        field(710; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Shipping Agent Service Code" <> xRec."Shipping Agent Service Code" then
                    Evaluate("Shipping Time", '<>');

                if "Drop Shipment" then begin
                    Evaluate("Shipping Time", '<0D>');
                    UpdateDates;
                end else begin
                    if ShippingAgentServices.Get("Shipping Agent Code", "Shipping Agent Service Code") then
                        "Shipping Time" := ShippingAgentServices."Shipping Time"
                    else begin
                        GetRentHeader;
                        "Shipping Time" := RentHeader."Shipping Time";
                    end;
                end;

                if ShippingAgentServices."Shipping Time" <> xRec."Shipping Time" then
                    Validate("Shipping Time", "Shipping Time");
            end;
        }
        field(720; "Drop Shipment"; Boolean)
        {
            Caption = 'Drop Shipment';
            Editable = true;
        }
        field(730; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';

            trigger OnLookup()
            var
                WMSManagement: Codeunit "WMS Management";
                BinCode: Code[20];
            begin
            end;

            trigger OnValidate()
            var
                WMSManagement: Codeunit "WMS Management";
            begin
            end;
        }
        field(740; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            var
                NewLocationCode: Code[20];
            begin
            end;
        }
        field(750; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(760; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            if (Type = const(Resource)) "Resource Unit of Measure".Code where("Resource No." = field("No."))
            else
            "Unit of Measure";

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }
        field(790; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
        }
        field(800; "Invoice Posted"; Boolean)
        {
            Caption = 'Invoice Posted';
        }
        field(810; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(820; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(830; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                Validate("VAT Prod. Posting Group");
            end;
        }
        field(840; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                "VAT Difference" := 0;
                "VAT %" := VATPostingSetup."VAT %";
                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                "VAT Identifier" := VATPostingSetup."VAT Identifier";
                case "VAT Calculation Type" of
                    "vat calculation type"::"Reverse Charge VAT",
                  "vat calculation type"::"Sales Tax":
                        "VAT %" := 0;
                    "vat calculation type"::"Full VAT":
                        begin
                            TestField(Type, Type::"G/L Account");
                            VATPostingSetup.TestField("Sales VAT Account");
                            TestField("No.", VATPostingSetup."Sales VAT Account");
                        end;
                end;
                if RentHeader."Prices Including VAT" and (Type in [Type::Item, Type::Resource]) then
                    "Unit Price" :=
                      ROUND(
                        "Unit Price" * (100 + "VAT %") / (100 + xRec."VAT %"),
                        Currency."Unit-Amount Rounding Precision");
            end;
        }
        field(860; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;
        }
        field(870; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
            end;
        }
        field(880; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
        }
        field(890; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
        }
        field(900; "Document Profile"; Integer)
        {
            Caption = 'Document Profile';
        }
        field(910; "Appl.-to Item Entry"; Integer)
        {
            Caption = 'Appl.-to Item Entry';
        }
        field(920; "Job No."; Code[10])
        {
            Caption = 'Job No.';
        }
        field(930; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
        }
        field(940; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';

            trigger OnValidate()
            begin
                CallCreateDim;
            end;
        }
        field(950; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(960; "Deal Type"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(970; Deposit; Boolean)
        {
            Caption = 'Deposit';
        }
        field(980; Prepayment; Boolean)
        {
            Caption = 'Prepayment';
        }
        field(985; "Extra Charge Line"; Boolean)
        {
            Caption = 'Extra Charge Line';
            DataClassification = ToBeClassified;
        }
        field(990; Canceled; Boolean)
        {
            Caption = 'Canceled';
            DataClassification = ToBeClassified;
        }
        field(991; "Cancels Line No."; Integer)
        {
            Caption = 'Cancels Line No.';
            DataClassification = ToBeClassified;
        }
        field(1100; "VF Run 1 From"; Decimal)
        {
            CaptionClass = '7,25006620,1100';
            DataClassification = ToBeClassified;
        }
        field(1110; "VF Run 1 To"; Decimal)
        {
            CaptionClass = '7,25006620,1110';
            DataClassification = ToBeClassified;
        }
        field(1120; "VF Run 2 From"; Decimal)
        {
            CaptionClass = '7,25006620,1120';
            DataClassification = ToBeClassified;
        }
        field(1130; "VF Run 2 To"; Decimal)
        {
            CaptionClass = '7,25006620,1130';
            DataClassification = ToBeClassified;
        }
        field(1140; "VF Run 3 From"; Decimal)
        {
            CaptionClass = '7,25006620,1140';
            DataClassification = ToBeClassified;
        }
        field(1150; "VF Run 3 To"; Decimal)
        {
            CaptionClass = '7,25006620,1150';
            DataClassification = ToBeClassified;
        }
        field(1160; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(1170; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = ToBeClassified;
        }
        field(1180; Days; Integer)
        {
            Caption = 'Days';
            DataClassification = ToBeClassified;
        }
        field(1190; "Rent Ledger Entry No."; Integer)
        {
            CalcFormula = lookup("Rent Ledger Entry"."Entry No." where("Rent Order No." = field("Document No."),
                                                                        "Rent Order Sales Line No." = field("Line No.")));
            Caption = 'Rent Ledger Entry No.';
            FieldClass = FlowField;
        }
        field(1191; "Rent Ledg. Entry Document Type"; Option)
        {
            CalcFormula = lookup("Rent Ledger Entry"."Document Type" where("Rent Order No." = field("Document No."),
                                                                            "Rent Order Sales Line No." = field("Line No.")));
            Caption = 'Rent Ledger Entry Document Type';
            FieldClass = FlowField;
            OptionCaption = ',Shipment,Receipt,Positive Adjmt.,Negative Adjmt.,Rent Order,Posted Sales Invoice,Posted Sales Cr.Memo';
            OptionMembers = ,Shipment,Receipt,"Positive Adjmt.","Negative Adjmt.","Rent Order","Posted Sales Invoice","Posted Sales Cr.Memo";
        }
        field(1192; "Rent Ledg. Entry Document No."; Code[20])
        {
            CalcFormula = lookup("Rent Ledger Entry"."Document No." where("Rent Order No." = field("Document No."),
                                                                           "Rent Order Sales Line No." = field("Line No.")));
            Caption = 'Rent Ledger Entry Document No.';
            FieldClass = FlowField;
        }
        field(1600; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            DataClassification = ToBeClassified;
            TableRelation = Vehicle;
        }
        field(1610; "Rent Asset Quantity"; Decimal)
        {
            Caption = 'Rent Asset Quantity';
            Editable = false;
        }
        field(1620; "Periods"; Decimal)
        {
            Caption = 'Periods';
            trigger OnValidate()
            begin
                Validate(Quantity, Periods * "Rent Asset Quantity");
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Amount Including VAT", Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        LastInvoicedDate: Date;
    begin
        if Invoiced then
            Error(Err002);

        //Update Rent Line Quantity to invoice fields
        if RentLine.Get("Document Type", "Document No.", "Attached to Rent Line No.") and Not ("Extra Charge Line") then begin
            RentLine."Quantity Invoiced" := RentLine."Quantity Invoiced" - Periods;
            SalesLineInvQty := 0;
            RentSalesLine.Reset;
            RentSalesLine.SetRange("Document Type", "Document Type");
            RentSalesLine.SetRange("Document No.", "Document No.");
            RentSalesLine.SetRange("Attached to Rent Line No.", "Attached to Rent Line No.");
            RentSalesLine.SetFilter("Line No.", '<>%1', "Line No.");

            if RentSalesLine.FindFirst then
                repeat
                    if LastInvoicedDate < RentSalesLine."End Date" then
                        LastInvoicedDate := RentSalesLine."End Date";
                    SalesLineInvQty += RentSalesLine.Periods;
                until RentSalesLine.Next = 0;

            RentLine."Qty. to Invoice" := RentLine.Quantity - SalesLineInvQty;
            RentLine."Last Date Invoiced" := LastInvoicedDate;
            RentLine.Modify;
        end;
    end;

    trigger OnInsert()
    begin
        "To Invoice" := true;
        GetRentHeader;
        "Location Code" := RentHeader."Location Code";
        "Deal Type" := RentHeader."Deal Type";
        "Responsibility Center" := RentHeader."Responsibility Center";
    end;

    trigger OnModify()
    var
        RentSalesLineToCheck: Record "Rent Sales Line";
    begin
        if Invoiced and "Extra Charge Line" then
            Error(Err001);

        if Invoiced then begin
            if (CurrFieldNo = FieldNo("VF Run 1 To")) or (CurrFieldNo = FieldNo("VF Run 2 To")) or (CurrFieldNo = FieldNo("VF Run 2 To")) then begin
                RentSalesLineToCheck.Reset;
                RentSalesLineToCheck.SetRange("Document Type", "Document Type");
                RentSalesLineToCheck.SetRange("Document No.", "Document No.");
                RentSalesLineToCheck.SetRange("Extra Charge Line", true);
                RentSalesLineToCheck.SetRange("Attach. to Rent Sales Line No.", "Line No.");
                if RentSalesLineToCheck.FindFirst then
                    Error(Err001);
            end else begin
                if (CurrFieldNo = FieldNo("VF Run 1 From")) or (CurrFieldNo = FieldNo("VF Run 2 From")) or (CurrFieldNo = FieldNo("VF Run 2 From")) then begin
                    RentSalesLineToCheck.Reset;
                    RentSalesLineToCheck.SetRange("Document Type", "Document Type");
                    RentSalesLineToCheck.SetRange("Document No.", "Document No.");
                    RentSalesLineToCheck.SetRange("Attached to Rent Line No.", "Attached to Rent Line No.");
                    RentSalesLineToCheck.SetFilter("Line No.", '<%1', "Line No.");
                    if RentSalesLineToCheck.FindFirst then
                        Error(Err001);
                end else
                    Error(Err001);
            end;
        end;
    end;

    trigger OnRename()
    begin
        if Invoiced then
            Error(Err003);
    end;

    var
        UserSetup: Record "User Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        RentLine: Record "Rent Line";
        RentSalesLine: Record "Rent Sales Line";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        RentHeader: Record "Rent Header";
        Currency: Record Currency;
        StatusCheckSuspended: Boolean;
        AddOnIntegrMgt: Codeunit AddOnIntegrManagement;
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        HideValidationDialog: Boolean;
        HasBeenShown: Boolean;
        Text000: label 'You cannot delete the order line because it is associated with purchase order %1 line %2.';
        Text001: label 'You cannot rename a %1.';
        Text002: label 'You cannot change %1 because the order line is associated with purchase order %2 line %3.';
        Text003: label 'must not be less than %1';
        Text005: label 'You cannot invoice more than %1 units.';
        Text006: label 'You cannot invoice more than %1 base units.';
        Text007: label 'You cannot ship more than %1 units.';
        Text008: label 'You cannot ship more than %1 base units.';
        Text009: label ' must be 0 when %1 is %2.';
        Text011: label 'Automatic reservation is not possible.\Reserve items manually?';
        Text012: label 'Change %1 from %2 to %3?';
        Text014: label '%1 %2 is before Work Date %3';
        Text016: label '%1 is required for %2 = %3.';
        Text017: label '\The entered information will be disregarded by warehouse operations.';
        Text018: label 'must not be specified when %1 = %2';
        Text020: label 'You cannot return more than %1 units.';
        Text021: label 'You cannot return more than %1 base units.';
        Text023: label '%1 %2 cannot be found in the %3 or %4 table.';
        Text024: label '%1 and %2 cannot both be empty when %3 is used.';
        Text025: label 'No %1 has been posted for %2 %3 and %4 %5.';
        Text026: label 'You cannot change %1 if the item charge has already been posted.';
        Text028: label 'You cannot change the %1 when the %2 has been filled in.';
        Text029: label 'must be positive';
        Text030: label 'must be negative';
        Text031: label 'You must either specify %1 or %2.';
        Text032: label 'You must select a %1 that applies to a range of entries when the related service contract is %2.';
        Text033: label 'You cannot modify the %1 field if the %2 and/or %3 fields are empty.';
        Text034: label 'The value of %1 field must be a whole number for the item included in the service item group if the %2 field in the Service Item Groups window contains a check mark.';
        Text035: label 'Warehouse ';
        Text036: label 'Inventory ';
        Text037: label 'You cannot change %1 when %2 is %3 and %4 is positive.';
        Text038: label 'You cannot change %1 when %2 is %3 and %4 is negative.';
        Text039: label '%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.';
        Text040: label 'You must use form %1 to enter %2, if item tracking is used.';
        Text041: label 'You must cancel the existing approval for this document to be able to change the %1 field.';
        Text042: label 'When posting the Applied to Ledger Entry %1 will be opened first';
        Text043: label 'cannot be %1';
        Text044: label 'cannot be less than %1';
        Text045: label 'cannot be more than %1';
        Text046: label 'You cannot return more than the %1 units that you have shipped for %2 %3.';
        Text047: label 'must be positive when %1 is not 0.';
        Text048: label 'You cannot use item tracking on a %1 created from a %2.';
        Text049: label 'Barcode No. %1 is not existing in the Item.';
        tcSER001: label 'Customer''s Request';
        tcSER002: label 'Requisition Worksheet';
        tcSER003: label 'Purchase Order';
        tcSER004: label 'In Stock';
        tcSER005: label 'In Stock - Informed';
        tcSER006: label 'Partly in Stock';
        EDMS001: label 'Vehicle %1 exist in other sales order.';
        Text100: label 'Cannnot put-in/take-out item with SIE assignments! Use SIE assignments.';
        Text101: label 'No Quantity';
        Text102: label '%1 cannot be greater than %2!';
        Text103: label 'There are linked deal documents. All links will be deleted. Are you sure you want to change this line?';
        Text104: label 'Automatic reservation is not possible.\Reserve vehicle manually?';
        PlannedShipmentDateCalculated: Boolean;
        PlannedDeliveryDateCalculated: Boolean;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        ShippingAgentServices: Record "Shipping Agent Services";
        StdTxt: Record "Standard Text";
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Resource: Record Resource;
        Res: Record Resource;
        FA: Record "Fixed Asset";
        ItemCharge: Record "Item Charge";
        Err001: label 'Can not modify line. Line already invoiced.';
        Err002: label 'Can not delete line. Line already invoiced.';
        Err003: label 'Can not rename line. Line already invoiced.';
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        VATPostingSetup: Record "VAT Posting Setup";
        SalesLineInvQty: Decimal;
        DimMgt: Codeunit DimensionManagement;
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        RentSetup: Record "Rent Mgt. Setup";
        RentItem: Record "Rent Item";
        RentPriceCalcMgt: Codeunit "Rent Price & Disc. Calc. Mgt.";
        VFMgt: Codeunit "Variable Field Management";
        RentSalesLineHasExtrChargeErr: label 'There is already an extra charge line for Rent Sales Line No. %1, Rent Item No. %2';


    procedure SetRentHeader(NewRentHeader: Record "Rent Header")
    begin
        RentHeader := NewRentHeader;

        if RentHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            RentHeader.TestField("Currency Factor");
            Currency.Get(RentHeader."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
    end;

    local procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;
        GetRentHeader;
        if Type in [Type::Item, Type::"Fixed Asset"] then
            RentHeader.TestField(Status, RentHeader.Status::Open);
    end;

    local procedure GetRentHeader()
    begin
        TestField("Document No.");
        if ("Document Type" <> RentHeader."Document Type") or ("Document No." <> RentHeader."No.") then begin
            RentHeader.Get("Document Type", "Document No.");
            if RentHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                RentHeader.TestField("Currency Factor");
                Currency.Get(RentHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer)
    begin
    end;

    local procedure GetItem()
    begin
        TestField("No.");
        if "No." <> Item."No." then
            Item.Get("No.");
    end;


    procedure UpdateDates()
    begin
        if CurrFieldNo = 0 then begin
            PlannedShipmentDateCalculated := false;
            PlannedDeliveryDateCalculated := false;
        end;
        if "Promised Delivery Date" <> 0D then
            Validate("Promised Delivery Date")
        else
            if "Requested Delivery Date" <> 0D then
                Validate("Requested Delivery Date")
            else begin
                Validate("Shipment Date");
                Validate("Planned Delivery Date");
            end;
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        SalesPricesIncVar: Integer;
    begin
        if not RentHeader.Get("Document Type", "Document No.") then begin
            RentHeader."No." := '';
            RentHeader.Init;
        end;
        if RentHeader."Prices Including VAT" then
            SalesPricesIncVar := 1
        else
            SalesPricesIncVar := 0;
        Clear(RentHeader);
        exit('2,' + Format(SalesPricesIncVar) + ',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        Field.Get(Database::"Rent Sales Line", FieldNumber);
        exit(Field."Field Caption");
    end;


    procedure UpdateAmounts()
    begin
        GetRentHeader;
        CheckDiscount;

        if "Line Amount" <> xRec."Line Amount" then
            "VAT Difference" := 0;
        if "Line Amount" <> ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Discount Amount" then begin
            "Line Amount" := ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Discount Amount";
            "VAT Difference" := 0;
        end;
        if RentHeader.Status = RentHeader.Status::Released then
            UpdateVATAmounts;


        if "Prepayment %" <> 0 then begin
            if Quantity < 0 then
                FieldError(Quantity, StrSubstNo(Text047, FieldCaption("Prepayment %")));
            if "Unit Price" < 0 then
                FieldError("Unit Price", StrSubstNo(Text047, FieldCaption("Prepayment %")));
        end;
        if CurrFieldNo <> FieldNo("Prepmt. Line Amount") then                                                       //20.08.2014 EBMSM01 P11
            "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100, Currency."Amount Rounding Precision");
        if "Prepmt. Line Amount" < "Prepmt. Amt. Inv." then
            FieldError("Prepmt. Line Amount", StrSubstNo(Text044, "Prepmt. Amt. Inv."));
    end;


    procedure CheckDiscount()
    var
        SalesDiscount: Record "SP Sales Disc. Group Items";
        Ishandled: Boolean;
        errorexit: Boolean;
    begin
        if not (Type in [Type::Item]) then
            exit;
        errorexit := true;
        if UserSetup.Get(UserId) then begin
            if UserSetup."SP Sales Disc. Group Code" <> '' then begin
                SalesDiscount.Reset;
                SalesDiscount.SetRange("Sales Disc. Group Code", UserSetup."SP Sales Disc. Group Code");
                SalesDiscount.SetRange(Type, SalesDiscount.Type::"Item Category");
                OnbeforefilterCheckDiscount(rec, SalesDiscount, Ishandled);
                if not Ishandled then
                    SalesDiscount.SetFilter("No.", '%1|%2', '', "Item Category Code");
                OnbeforeCheckDiscount(rec, SalesDiscount, errorexit);
                if errorexit then
                    if SalesDiscount.FindLast then begin
                        if "Line Discount %" > SalesDiscount."Max. Discount %" then
                            Error(Text102, FieldCaption("Line Discount %"), SalesDiscount."Max. Discount %");
                    end;
            end;
        end;
    end;

    local procedure UpdateVATAmounts()
    var
        SalesLine2: Record "Sales Line";
        TotalLineAmount: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalQuantityBase: Decimal;
    begin
        SalesLine2.SetRange("Document Type", "Document Type");
        SalesLine2.SetRange("Document No.", "Document No.");
        SalesLine2.SetFilter("Line No.", '<>%1', "Line No.");
        if "Line Amount" = 0 then
            if xRec."Line Amount" >= 0 then
                SalesLine2.SetFilter(Amount, '>%1', 0)
            else
                SalesLine2.SetFilter(Amount, '<%1', 0)
        else
            if "Line Amount" > 0 then
                SalesLine2.SetFilter(Amount, '>%1', 0)
            else
                SalesLine2.SetFilter(Amount, '<%1', 0);
        SalesLine2.SetRange("VAT Identifier", "VAT Identifier");
        SalesLine2.SetRange("Tax Group Code", "Tax Group Code");

        if "Line Amount" = "Inv. Discount Amount" then begin
            Amount := 0;
            "VAT Base Amount" := 0;
            "Amount Including VAT" := 0;
            if "Line No." <> 0 then
                if Modify then
                    if SalesLine2.FindLast then begin
                        SalesLine2.UpdateAmounts;
                        SalesLine2.Modify;
                    end;
        end else begin
            TotalLineAmount := 0;
            TotalInvDiscAmount := 0;
            TotalAmount := 0;
            TotalAmountInclVAT := 0;
            TotalQuantityBase := 0;
            if ("VAT Calculation Type" = "vat calculation type"::"Sales Tax") or
               (("VAT Calculation Type" in
                 ["vat calculation type"::"Normal VAT", "vat calculation type"::"Reverse Charge VAT"]) and ("VAT %" <> 0))
            then begin
                if SalesLine2.FindSet then
                    repeat
                        TotalLineAmount := TotalLineAmount + SalesLine2."Line Amount";
                        TotalInvDiscAmount := TotalInvDiscAmount + SalesLine2."Inv. Discount Amount";
                        TotalAmount := TotalAmount + SalesLine2.Amount;
                        TotalAmountInclVAT := TotalAmountInclVAT + SalesLine2."Amount Including VAT";
                        TotalQuantityBase := TotalQuantityBase + SalesLine2."Quantity (Base)";
                    until SalesLine2.Next = 0;
            end;

            if RentHeader."Prices Including VAT" then
                case "VAT Calculation Type" of
                    "vat calculation type"::"Normal VAT",
                    "vat calculation type"::"Reverse Charge VAT":
                        begin
                            Amount :=
                              ROUND(
                                (TotalLineAmount - TotalInvDiscAmount + "Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                                Currency."Amount Rounding Precision") -
                              TotalAmount;
                            "VAT Base Amount" :=
                              ROUND(
                                Amount * (1 - RentHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              TotalLineAmount + "Line Amount" +
                              ROUND(
                                (TotalAmount + Amount) * (RentHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                                Currency."Amount Rounding Precision", Currency.VATRoundingDirection) -
                              TotalAmountInclVAT;
                        end;
                    "vat calculation type"::"Full VAT":
                        begin
                            Amount := 0;
                            "VAT Base Amount" := 0;
                        end;
                    "vat calculation type"::"Sales Tax":
                        begin
                            RentHeader.TestField("VAT Base Discount %", 0);
                            Amount :=
                              SalesTaxCalculate.ReverseCalculateTax(
                                "Tax Area Code", "Tax Group Code", "Tax Liable", RentHeader."Posting Date",
                                TotalAmountInclVAT + "Amount Including VAT", TotalQuantityBase + "Quantity (Base)",
                                RentHeader."Currency Factor") -
                              TotalAmount;
                            if Amount <> 0 then
                                "VAT %" :=
                                  ROUND(100 * ("Amount Including VAT" - Amount) / Amount, 0.00001)
                            else
                                "VAT %" := 0;
                            Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                            "VAT Base Amount" := Amount;
                        end;
                end
            else
                case "VAT Calculation Type" of
                    "vat calculation type"::"Normal VAT",
                    "vat calculation type"::"Reverse Charge VAT":
                        begin
                            Amount := ROUND("Line Amount" - "Inv. Discount Amount", Currency."Amount Rounding Precision");
                            "VAT Base Amount" :=
                              ROUND(Amount * (1 - RentHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              TotalAmount + Amount +
                              ROUND(
                                (TotalAmount + Amount) * (1 - RentHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                                Currency."Amount Rounding Precision", Currency.VATRoundingDirection) -
                              TotalAmountInclVAT;
                        end;
                    "vat calculation type"::"Full VAT":
                        begin
                            Amount := 0;
                            "VAT Base Amount" := 0;
                            "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount";
                        end;
                    "vat calculation type"::"Sales Tax":
                        begin
                            Amount := ROUND("Line Amount" - "Inv. Discount Amount", Currency."Amount Rounding Precision");
                            "VAT Base Amount" := Amount;
                            "Amount Including VAT" :=
                              TotalAmount + Amount +
                              ROUND(
                                SalesTaxCalculate.CalculateTax(
                                  "Tax Area Code", "Tax Group Code", "Tax Liable", RentHeader."Posting Date",
                                  (TotalAmount + Amount), (TotalQuantityBase + "Quantity (Base)"),
                                  RentHeader."Currency Factor"), Currency."Amount Rounding Precision") -
                              TotalAmountInclVAT;
                            if "VAT Base Amount" <> 0 then
                                "VAT %" :=
                                  ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                            else
                                "VAT %" := 0;
                        end;
                end;
        end;
    end;


    procedure CheckAssocPurchOrder(TheFieldCaption: Text[250])
    begin
        if TheFieldCaption = '' then begin // If sales line is being deleted
            if "Purch. Order Line No." <> 0 then
                Error(
                  Text000,
                  "Purchase Order No.",
                  "Purch. Order Line No.");
            if "Special Order Purch. Line No." <> 0 then
                Error(
                  Text000,
                  "Special Order Purchase No.",
                  "Special Order Purch. Line No.");
        end;
        if "Purch. Order Line No." <> 0 then
            Error(
              Text002,
              TheFieldCaption,
              "Purchase Order No.",
              "Purch. Order Line No.");
        if "Special Order Purch. Line No." <> 0 then
            Error(
              Text002,
              TheFieldCaption,
              "Special Order Purchase No.",
              "Special Order Purch. Line No.");
    end;


    procedure IsShipment(): Boolean
    begin
        exit(SignedXX("Quantity (Base)") < 0);
    end;


    procedure SignedXX(Value: Decimal): Decimal
    begin
        case "Document Type" of
            "document type"::Quote,
          "document type"::Order:
                exit(-Value);
        end;
    end;


    procedure GetDate(): Date
    begin
        if ("Document Type" in ["document type"::Quote]) and
           (RentHeader."Posting Date" = 0D)
        then
            exit(WorkDate);
        exit(RentHeader."Posting Date");
    end;

    local procedure UpdateUnitPrice(CalledByFieldNo: Integer)
    var
        TmpSalesLine: Record "Sales Line" temporary;
        TmpSalesHeader: Record "Sales Header" temporary;
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        GetRentHeader;
        TestField("Qty. per Unit of Measure");

        case Type of
            Type::Item, Type::Resource, Type::"External Service":
                begin
                    Clear(TmpSalesHeader);
                    Clear(TmpSalesLine);
                    TmpSalesHeader.Init;
                    TmpSalesHeader."No." := 'DummyNo';
                    TmpSalesHeader."Sell-to Customer No." := RentHeader."Sell-to Customer No.";
                    TmpSalesLine.Init;
                    TmpSalesLine."Sell-to Customer No." := RentHeader."Sell-to Customer No.";
                    TmpSalesLine."Document No." := TmpSalesHeader."No.";
                    TmpSalesLine."Document Type" := TmpSalesHeader."Document Type";
                    TmpSalesLine.Type := Type;
                    TmpSalesLine."No." := "No.";
                    // "Document Date" Rent Header, Location Code Rent Sales Line, "Bill-to Customer No."
                    PriceCalcMgt.FindSalesLinePrice(TmpSalesHeader, TmpSalesLine, CalledByFieldNo);
                    "Unit Price" := TmpSalesLine."Unit Price";
                end;
        end;
        Validate("Unit Price");
    end;


    procedure CalcVATAmountLines(QtyType: Option General,Invoicing,Shipping; var RentHeader: Record "Rent Header"; var RentSalesLine: Record "Rent Sales Line"; var VATAmountLine: Record "VAT Amount Line")
    var
        PrevVatAmountLine: Record "VAT Amount Line";
        Currency: Record Currency;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        QtyFactor: Decimal;
        SalesSetup: Record "Sales & Receivables Setup";
        RentSalesLine3: Record "Rent Sales Line";
        RoundingLineInserted: Boolean;
        TotalVATAmount: Decimal;
    begin
        if RentHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(RentHeader."Currency Code");

        VATAmountLine.DeleteAll;

        RentSalesLine.SetRange("Document Type", RentHeader."Document Type");
        RentSalesLine.SetRange("Document No.", RentHeader."No.");
        RentSalesLine.SetFilter(Type, '>0');
        RentSalesLine.SetFilter(Quantity, '<>0');

        SalesSetup.Get;
        if RentSalesLine.FindSet then
            repeat
                if RentSalesLine."VAT Calculation Type" in
                   [RentSalesLine."vat calculation type"::"Reverse Charge VAT", RentSalesLine."vat calculation type"::"Sales Tax"]
                then
                    RentSalesLine."VAT %" := 0;


                if not VATAmountLine.Get(
                  RentSalesLine."VAT Identifier", RentSalesLine."VAT Calculation Type", RentSalesLine."Tax Group Code", false, RentSalesLine."Line Amount" >= 0)
                then begin
                    VATAmountLine.Init;
                    VATAmountLine."VAT Identifier" := RentSalesLine."VAT Identifier";
                    VATAmountLine."VAT Calculation Type" := RentSalesLine."VAT Calculation Type";
                    VATAmountLine."Tax Group Code" := RentSalesLine."Tax Group Code";
                    VATAmountLine."VAT %" := RentSalesLine."VAT %";
                    VATAmountLine.Modified := true;
                    VATAmountLine.Positive := RentSalesLine."Line Amount" >= 0;
                    VATAmountLine.Insert;
                end;

                case QtyType of
                    Qtytype::General:
                        begin
                            VATAmountLine.Quantity := VATAmountLine.Quantity + RentSalesLine."Quantity (Base)";
                            VATAmountLine."Line Amount" := VATAmountLine."Line Amount" + RentSalesLine."Line Amount";
                            if RentSalesLine."Allow Invoice Disc." then
                                VATAmountLine."Inv. Disc. Base Amount" :=
                                  VATAmountLine."Inv. Disc. Base Amount" + RentSalesLine."Line Amount";
                            VATAmountLine."Invoice Discount Amount" :=
                              VATAmountLine."Invoice Discount Amount" + RentSalesLine."Inv. Discount Amount";
                            VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + RentSalesLine."VAT Difference";

                            VATAmountLine.Modify;
                        end;
                end;
                if RoundingLineInserted then
                    TotalVATAmount := TotalVATAmount + RentSalesLine."Amount Including VAT" - RentSalesLine.Amount + RentSalesLine."VAT Difference";
            until RentSalesLine.Next = 0;
        RentSalesLine.SetRange(Type);
        RentSalesLine.SetRange(Quantity);

        if VATAmountLine.FindSet then
            repeat
                if (PrevVatAmountLine."VAT Identifier" <> VATAmountLine."VAT Identifier") or
                   (PrevVatAmountLine."VAT Calculation Type" <> VATAmountLine."VAT Calculation Type") or
                   (PrevVatAmountLine."Tax Group Code" <> VATAmountLine."Tax Group Code") or
                   (PrevVatAmountLine."Use Tax" <> VATAmountLine."Use Tax")
                then
                    PrevVatAmountLine.Init;
                if RentHeader."Prices Including VAT" then begin
                    case VATAmountLine."VAT Calculation Type" of
                        VATAmountLine."vat calculation type"::"Normal VAT",
                        VATAmountLine."vat calculation type"::"Reverse Charge VAT":
                            begin
                                VATAmountLine."VAT Base" :=
                                  ROUND(
                                    (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") / (1 + VATAmountLine."VAT %" / 100),
                                    Currency."Amount Rounding Precision") - VATAmountLine."VAT Difference";
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(
                                    PrevVatAmountLine."VAT Amount" +
                                    (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" - VATAmountLine."VAT Base" - VATAmountLine."VAT Difference") *
                                    (1 - RentHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Base" + VATAmountLine."VAT Amount";
                                if VATAmountLine.Positive then
                                    PrevVatAmountLine.Init
                                else begin
                                    PrevVatAmountLine := VATAmountLine;
                                    PrevVatAmountLine."VAT Amount" :=
                                      (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" - VATAmountLine."VAT Base" - VATAmountLine."VAT Difference") *
                                      (1 - RentHeader."VAT Base Discount %" / 100);
                                    PrevVatAmountLine."VAT Amount" :=
                                      PrevVatAmountLine."VAT Amount" -
                                      ROUND(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                end;
                            end;
                        VATAmountLine."vat calculation type"::"Full VAT":
                            begin
                                VATAmountLine."VAT Base" := 0;
                                VATAmountLine."VAT Amount" := VATAmountLine."VAT Difference" + VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Amount";
                            end;
                        VATAmountLine."vat calculation type"::"Sales Tax":
                            begin
                                VATAmountLine."Amount Including VAT" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Base" :=
                                  ROUND(
                                    SalesTaxCalculate.ReverseCalculateTax(
                                      RentHeader."Tax Area Code", VATAmountLine."Tax Group Code", RentHeader."Tax Liable",
                                      RentHeader."Posting Date", VATAmountLine."Amount Including VAT", VATAmountLine.Quantity, RentHeader."Currency Factor"),
                                    Currency."Amount Rounding Precision");
                                VATAmountLine."VAT Amount" := VATAmountLine."VAT Difference" + VATAmountLine."Amount Including VAT" - VATAmountLine."VAT Base";
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmountLine."VAT %" := 0
                                else
                                    VATAmountLine."VAT %" := ROUND(100 * VATAmountLine."VAT Amount" / VATAmountLine."VAT Base", 0.00001);
                            end;
                    end;
                end else begin
                    case VATAmountLine."VAT Calculation Type" of
                        VATAmountLine."vat calculation type"::"Normal VAT",
                        VATAmountLine."vat calculation type"::"Reverse Charge VAT":
                            begin
                                VATAmountLine."VAT Base" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(
                                    PrevVatAmountLine."VAT Amount" +
                                    VATAmountLine."VAT Base" * VATAmountLine."VAT %" / 100 * (1 - RentHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" + VATAmountLine."VAT Amount";
                                if VATAmountLine.Positive then
                                    PrevVatAmountLine.Init
                                else begin
                                    PrevVatAmountLine := VATAmountLine;
                                    PrevVatAmountLine."VAT Amount" :=
                                      VATAmountLine."VAT Base" * VATAmountLine."VAT %" / 100 * (1 - RentHeader."VAT Base Discount %" / 100);
                                    PrevVatAmountLine."VAT Amount" :=
                                      PrevVatAmountLine."VAT Amount" -
                                      ROUND(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                end;
                            end;
                        VATAmountLine."vat calculation type"::"Full VAT":
                            begin
                                VATAmountLine."VAT Base" := 0;
                                VATAmountLine."VAT Amount" := VATAmountLine."VAT Difference" + VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Amount";
                            end;
                        VATAmountLine."vat calculation type"::"Sales Tax":
                            begin
                                VATAmountLine."VAT Base" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Amount" :=
                                  SalesTaxCalculate.CalculateTax(
                                    RentHeader."Tax Area Code", VATAmountLine."Tax Group Code", RentHeader."Tax Liable",
                                    RentHeader."Posting Date", VATAmountLine."VAT Base", VATAmountLine.Quantity, RentHeader."Currency Factor");
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmountLine."VAT %" := 0
                                else
                                    VATAmountLine."VAT %" := ROUND(100 * VATAmountLine."VAT Amount" / VATAmountLine."VAT Base", 0.00001);
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(VATAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Base" + VATAmountLine."VAT Amount";
                            end;
                    end;
                end;
                if RoundingLineInserted then
                    TotalVATAmount := TotalVATAmount - VATAmountLine."VAT Amount";
                VATAmountLine."Calculated VAT Amount" := VATAmountLine."VAT Amount" - VATAmountLine."VAT Difference";

                VATAmountLine.Modify;
            until VATAmountLine.Next = 0;

        if RoundingLineInserted and (TotalVATAmount <> 0) then
            if VATAmountLine.Get(RentSalesLine."VAT Identifier", RentSalesLine."VAT Calculation Type",
                 RentSalesLine."Tax Group Code", false, RentSalesLine."Line Amount" >= 0)
            then begin
                VATAmountLine."VAT Amount" := VATAmountLine."VAT Amount" + TotalVATAmount;
                VATAmountLine."Amount Including VAT" := VATAmountLine."Amount Including VAT" + TotalVATAmount;
                VATAmountLine."Calculated VAT Amount" := VATAmountLine."Calculated VAT Amount" + TotalVATAmount;
                VATAmountLine.Modify;
            end;
    end;


    procedure UpdateVATOnLines(QtyType: Option General,Invoicing,Shipping; var RentHeader: Record "Rent Header"; var RentSalesLine: Record "Rent Sales Line"; var VATAmountLine: Record "VAT Amount Line")
    var
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        RecRef: RecordRef;
        xRecRef: RecordRef;
        ChangeLogMgt: Codeunit "Change Log Management";
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        VATDifference: Decimal;
        InvDiscAmount: Decimal;
        LineAmountToInvoice: Decimal;
        WHTDifference: Decimal;
        WHTAmount: Decimal;
    begin
        if QtyType = Qtytype::Shipping then
            exit;
        if RentHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(RentHeader."Currency Code");

        TempVATAmountLineRemainder.DeleteAll;

        RentSalesLine.SetRange("Document Type", RentHeader."Document Type");
        RentSalesLine.SetRange("Document No.", RentHeader."No.");
        RentSalesLine.SetFilter(Type, '>0');
        RentSalesLine.SetFilter(Quantity, '<>0');
        case QtyType of
            Qtytype::Invoicing:
                RentSalesLine.SetFilter("Qty. to Invoice", '<>0');
            Qtytype::Shipping:
                RentSalesLine.SetFilter("Qty. to Ship", '<>0');
        end;
        RentSalesLine.LockTable;
        if RentSalesLine.FindSet then
            repeat
                VATAmountLine.Get(RentSalesLine."VAT Identifier", RentSalesLine."VAT Calculation Type", RentSalesLine."Tax Group Code", false, RentSalesLine."Line Amount" >= 0);
                if VATAmountLine.Modified then begin
                    xRecRef.GetTable(RentSalesLine);
                    if not TempVATAmountLineRemainder.Get(
                      RentSalesLine."VAT Identifier", RentSalesLine."VAT Calculation Type", RentSalesLine."Tax Group Code", false, RentSalesLine."Line Amount" >= 0)
                    then begin
                        TempVATAmountLineRemainder := VATAmountLine;
                        TempVATAmountLineRemainder.Init;
                        TempVATAmountLineRemainder.Insert;
                    end;

                    if QtyType = Qtytype::General then
                        LineAmountToInvoice := RentSalesLine."Line Amount"
                    else
                        LineAmountToInvoice :=
                          ROUND(RentSalesLine."Line Amount" * RentSalesLine."Qty. to Invoice" / RentSalesLine.Quantity, Currency."Amount Rounding Precision");

                    if RentSalesLine."Allow Invoice Disc." then begin
                        if VATAmountLine."Inv. Disc. Base Amount" = 0 then
                            InvDiscAmount := 0
                        else begin
                            TempVATAmountLineRemainder."Invoice Discount Amount" :=
                              TempVATAmountLineRemainder."Invoice Discount Amount" +
                              VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice /
                              VATAmountLine."Inv. Disc. Base Amount";
                            InvDiscAmount :=
                              ROUND(
                                TempVATAmountLineRemainder."Invoice Discount Amount", Currency."Amount Rounding Precision");
                            TempVATAmountLineRemainder."Invoice Discount Amount" :=
                              TempVATAmountLineRemainder."Invoice Discount Amount" - InvDiscAmount;
                        end;
                        if QtyType = Qtytype::General then begin
                            RentSalesLine."Inv. Discount Amount" := InvDiscAmount;
                        end else
                            RentSalesLine."Inv. Disc. Amount to Invoice" := InvDiscAmount;
                    end else
                        InvDiscAmount := 0;

                    if QtyType = Qtytype::General then
                        if RentHeader."Prices Including VAT" then begin
                            if (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" = 0) or
                               (RentSalesLine."Line Amount" = 0)
                            then begin
                                VATAmount := 0;
                                NewAmountIncludingVAT := 0;
                            end else begin
                                VATAmount :=
                                  TempVATAmountLineRemainder."VAT Amount" +
                                  VATAmountLine."VAT Amount" *
                                  (RentSalesLine."Line Amount" - RentSalesLine."Inv. Discount Amount") /
                                  (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                                NewAmountIncludingVAT :=
                                  TempVATAmountLineRemainder."Amount Including VAT" +
                                  VATAmountLine."Amount Including VAT" *
                                  (RentSalesLine."Line Amount" - RentSalesLine."Inv. Discount Amount") /
                                  (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");

                            end;
                            NewAmount :=
                              ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision") -
                              ROUND(VATAmount, Currency."Amount Rounding Precision");
                            NewVATBaseAmount :=
                              ROUND(
                                NewAmount * (1 - RentHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");


                        end else begin
                            if RentSalesLine."VAT Calculation Type" = RentSalesLine."vat calculation type"::"Full VAT" then begin
                                VATAmount := RentSalesLine."Line Amount" - RentSalesLine."Inv. Discount Amount";
                                NewAmount := 0;
                                NewVATBaseAmount := 0;
                            end else begin
                                NewAmount := RentSalesLine."Line Amount" - RentSalesLine."Inv. Discount Amount";
                                NewVATBaseAmount :=
                                  ROUND(
                                    NewAmount * (1 - RentHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision");
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmount := 0
                                else
                                    VATAmount :=
                                      TempVATAmountLineRemainder."VAT Amount" +
                                      VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                            end;
                            NewAmountIncludingVAT := NewAmount + ROUND(VATAmount, Currency."Amount Rounding Precision");
                        end
                    else begin
                        if (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") = 0 then
                            VATDifference := 0
                        else begin
                            VATDifference :=
                              TempVATAmountLineRemainder."VAT Difference" +
                              VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) /
                              (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                        end;

                        if LineAmountToInvoice = 0 then
                            RentSalesLine."VAT Difference" := 0
                        else
                            RentSalesLine."VAT Difference" := ROUND(VATDifference, Currency."Amount Rounding Precision");

                    end;
                    if (QtyType = Qtytype::General) and (RentHeader.Status = RentHeader.Status::Released) then begin
                        RentSalesLine.Amount := NewAmount;
                        RentSalesLine."Amount Including VAT" := ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        RentSalesLine."VAT Base Amount" := NewVATBaseAmount;
                    end;
                    RentSalesLine.Modify;
                    RecRef.GetTable(RentSalesLine);
                    ChangeLogMgt.LogModification(RecRef);

                    TempVATAmountLineRemainder."Amount Including VAT" :=
                      NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                    TempVATAmountLineRemainder."VAT Difference" := VATDifference - RentSalesLine."VAT Difference";
                    TempVATAmountLineRemainder.Modify;
                end;
            until RentSalesLine.Next = 0;
        RentSalesLine.SetRange(Type);
        RentSalesLine.SetRange(Quantity);
        RentSalesLine.SetRange("Qty. to Invoice");
        RentSalesLine.SetRange("Qty. to Ship");
    end;

    local procedure GetFAPostingGroup()
    var
        LocalGLAcc: Record "G/L Account";
        FASetup: Record "FA Setup";
        FAPostingGr: Record "FA Posting Group";
        FADeprBook: Record "FA Depreciation Book";
    begin
        if (Type <> Type::"Fixed Asset") or ("No." = '') then
            exit;

        FAPostingGr.Get(FADeprBook."FA Posting Group");
        FAPostingGr.TestField("Acq. Cost Acc. on Disposal");
        LocalGLAcc.Get(FAPostingGr."Acq. Cost Acc. on Disposal");
        LocalGLAcc.CheckGLAcc;
        LocalGLAcc.TestField("Gen. Prod. Posting Group");
        "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
        "Tax Group Code" := LocalGLAcc."Tax Group Code";
        Validate("VAT Prod. Posting Group", LocalGLAcc."VAT Prod. Posting Group");
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimMgt.EditDimensionSet(
                              "Dimension Set ID", StrSubstNo('%1 %2', "Document Type", "No."),
                              "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
        end;
    end;


    procedure CallCreateDim()
    Var
        ServicePostEDMS: Codeunit "Service-Post EDMS";
    begin
        CreateDim(
          ServicePostEDMS.EDMSTypeToTableID6(Type), "No.",
          Database::"Rent Item", "Rent Item No."
          );
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
        RentHeader: Record "Rent Header";
        NewDimSetID: Integer;
        Dimsource: List of [Dictionary of [Integer, code[20]]];
    begin
        OldDimSetID := "Dimension Set ID";
        SourceCodeSetup.Get;
        /*  TableID[1] := Type1;
          No[1] := No1;
          TableID[2] := Type2;
          No[2] := No2;*/

        RentHeader.Get("Document Type", "Document No.");
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Type1, No1);
        DimMgt.AddDimSource(Dimsource, Type2, No2);
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(Dimsource, SourceCodeSetup."Rent Management",
                             "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
                              RentHeader."Dimension Set ID", Database::Customer);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure GetSalesDocument(var DocumentType: Option " ",Invoice,"Credit Memo","Posted Invoice","Posted Credit Memo"; var DocumentNo: Code[20])
    var
        SalesLine: Record "Sales Line";
    begin
        CalcFields("Rent Ledger Entry No.");
        if "Rent Ledger Entry No." > 0 then begin
            CalcFields("Rent Ledg. Entry Document Type", "Rent Ledg. Entry Document No.");
            case "Rent Ledg. Entry Document Type" of
                "rent ledg. entry document type"::"Posted Sales Invoice":
                    DocumentType := Documenttype::"Posted Invoice";
                "rent ledg. entry document type"::"Posted Sales Cr.Memo":
                    DocumentType := Documenttype::"Posted Credit Memo";
            end;
            DocumentNo := "Rent Ledg. Entry Document No.";
        end else begin
            SalesLine.Reset;
            SalesLine.SetRange("Rent Order No.", "Document No.");
            SalesLine.SetRange("Rent Order Sales Line No.", "Line No.");
            if SalesLine.FindFirst then begin
                DocumentType := SalesLine."Document Type";
                DocumentNo := SalesLine."Document No.";
            end;
            case SalesLine."Document Type" of
                SalesLine."document type"::Invoice:
                    DocumentType := Documenttype::Invoice;
                SalesLine."document type"::"Credit Memo":
                    DocumentType := Documenttype::"Credit Memo";
            end;
        end;
    end;

    procedure Invoiced(): Boolean
    var
        SalesDocNo: Code[20];
        SalesDocType: Option;
    begin
        CalcFields("Rent Ledger Entry No.");
        if "Rent Ledger Entry No." > 0 then
            exit(true);
        GetSalesDocument(SalesDocType, SalesDocNo);
        if SalesDocNo <> '' then
            exit(true);

        exit(false);
    end;

    procedure GetSalesDocumentType(): Integer
    var
        DocumentType: Option " ",Invoice,"Credit Memo","Posted Invoice","Posted Credit Memo";
        DocumentNo: Code[20];
    begin
        GetSalesDocument(DocumentType, DocumentNo);
        exit(DocumentType);
    end;

    procedure GetSalesDocumentNo(): Code[20]
    var
        DocumentType: Option " ",Invoice,"Credit Memo","Posted Invoice","Posted Credit Memo";
        DocumentNo: Code[20];
    begin
        GetSalesDocument(DocumentType, DocumentNo);
        exit(DocumentNo);
    end;


    procedure CreateExtraChargeLines()
    var
        ActualDays: Integer;
        OrderDays: Integer;
        RentPeriod: Record "Rent Period";
        ExtraDays: Integer;
        TempRentItemSalesPrice: Record "Rent Item Sales Price" temporary;
        DaysInPeriod: Integer;
        ExtraRentPeriod: Record "Rent Period";
        ExtraPeriods: Integer;
        ExtraRun: Decimal;
        ExtraResourceNo: Code[20];
        RentAsset: Record "Rent Asset";
        MapViewTelematics: Record "Vehicle Telematics";
        VFR1Qty, VFR2Qty, VFR3Qty : Decimal;
    begin
        if CheckHasExtraChargeLine() then
            error(RentSalesLineHasExtrChargeErr, "Line No.", "Rent Item No.");

        RentSetup.Get;
        RentLine.Get("Document Type", "Document No.", "Attached to Rent Line No.");
        RentPeriod.Get(RentLine."Rent Period Type");
        RentItem.Get("Rent Item No.");
        RentItem.TestField("Extra Charge Resource No.");
        RentHeader.Get("Document Type", "Document No.");


        RentPriceCalcMgt.FindSalesPrice(
            TempRentItemSalesPrice, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
            RentHeader."Customer Price Group", '', "Rent Item No.", RentLine."Rent Period Type", RentHeader."Currency Code",
            RentHeader."Document Date", false);

        if RentHeader."Overtime Calculation" = RentHeader."Overtime Calculation"::"Current Period" then begin
            if TempRentItemSalesPrice.FindFirst then;
            FillVFRunFrom(RentLine);

            /*
            if RentAsset.get(RentLine."Rent Asset No.") and (RentAsset."Vehicle Serial No." <> '') then begin
                MapViewTelematics.Reset();
                MapViewTelematics.SetRange("Vehicle Serial No.", RentAsset."Vehicle Serial No.");
                MapViewTelematics.SetFilter("Date Stamp", '..%1', "End Date");
                if MapViewTelematics.FindLast() then begin
                    if MapViewTelematics."Variable Field Run 1" > "VF Run 1 From" then begin
                        ExtraRun := (MapViewTelematics."Variable Field Run 1" - "VF Run 1 From") - RentPeriod."Variable Field Run 1" * Quantity;
                        if ExtraRun > 0 then begin
                            if RentItem."Variable Field 1" <> '' then
                                ExtraResourceNo := RentItem."Variable Field 1"
                            else
                                ExtraResourceNo := RentItem."Extra Charge Resource No.";
                            InsertRentSalesLine(ExtraResourceNo, RentSetup."Variable Field Run 1", ExtraRun, TempRentItemSalesPrice."Variable Field Run 1", RentHeader."Location Code", "VF Run 1 From", MapViewTelematics."Variable Field Run 1");
                        end;
                    end;
                    if MapViewTelematics."Variable Field Run 2" > "VF Run 2 From" then begin
                        ExtraRun := (MapViewTelematics."Variable Field Run 2" - "VF Run 2 From") - RentPeriod."Variable Field Run 2" * Quantity;
                        if ExtraRun > 0 then begin
                            if RentItem."Variable Field 2" <> '' then
                                ExtraResourceNo := RentItem."Variable Field 2"
                            else
                                ExtraResourceNo := RentItem."Extra Charge Resource No.";
                            InsertRentSalesLine(ExtraResourceNo, RentSetup."Variable Field Run 1", ExtraRun, TempRentItemSalesPrice."Variable Field Run 2", RentHeader."Location Code", "VF Run 2 From", MapViewTelematics."Variable Field Run 2");
                        end;
                    end;
                    if MapViewTelematics."Variable Field Run 3" > "VF Run 3 From" then begin
                        ExtraRun := (MapViewTelematics."Variable Field Run 3" - "VF Run 3 From") - RentPeriod."Variable Field Run 3" * Quantity;
                        if ExtraRun > 0 then begin
                            if RentItem."Variable Field 3" <> '' then
                                ExtraResourceNo := RentItem."Variable Field 3"
                            else
                                ExtraResourceNo := RentItem."Extra Charge Resource No.";
                            InsertRentSalesLine(ExtraResourceNo, RentSetup."Variable Field Run 1", ExtraRun, TempRentItemSalesPrice."Variable Field Run 3", RentHeader."Location Code", "VF Run 3 From", MapViewTelematics."Variable Field Run 3");
                        end;
                    end;
                end;
            end;
            */


            ExtraRun := ("VF Run 1 To" - "VF Run 1 From") - RentPeriod."Variable Field Run 1" * Quantity;
            if ExtraRun > 0 then begin
                if RentItem."Variable Field 1" <> '' then
                    ExtraResourceNo := RentItem."Variable Field 1"
                else
                    ExtraResourceNo := RentItem."Extra Charge Resource No.";
                InsertRentSalesLine(ExtraResourceNo, RentSetup."Variable Field Run 1", ExtraRun, TempRentItemSalesPrice."Variable Field Run 1", RentHeader."Location Code");
            end;
            ExtraRun := ("VF Run 2 To" - "VF Run 2 From") - RentPeriod."Variable Field Run 2" * Quantity;
            if ExtraRun > 0 then begin
                if RentItem."Variable Field 2" <> '' then
                    ExtraResourceNo := RentItem."Variable Field 2"
                else
                    ExtraResourceNo := RentItem."Extra Charge Resource No.";
                InsertRentSalesLine(ExtraResourceNo, RentSetup."Variable Field Run 1", ExtraRun, TempRentItemSalesPrice."Variable Field Run 2", RentHeader."Location Code");
            end;
            ExtraRun := ("VF Run 3 To" - "VF Run 3 From") - RentPeriod."Variable Field Run 3" * Quantity;
            if ExtraRun > 0 then begin
                if RentItem."Variable Field 2" <> '' then
                    ExtraResourceNo := RentItem."Variable Field 3"
                else
                    ExtraResourceNo := RentItem."Extra Charge Resource No.";
                InsertRentSalesLine(ExtraResourceNo, RentSetup."Variable Field Run 1", ExtraRun, TempRentItemSalesPrice."Variable Field Run 3", RentHeader."Location Code");
            end;

        end;
    end;

    local procedure FillVFRunFrom(RentLineVF: Record "Rent Line")
    var
        RentSalesLineVF: Record "Rent Sales Line";
    begin
        if RentLineVF."Planned Shipment Date" = "Start Date" then begin
            "VF Run 1 From" := RentLineVF."VF Run 1 From";
            "VF Run 2 From" := RentLineVF."VF Run 2 From";
            "VF Run 3 From" := RentLineVF."VF Run 3 From";
        end else begin
            RentSalesLineVF.Reset;
            RentSalesLineVF.SetRange("Document Type", "Document Type");
            RentSalesLineVF.SetRange("Document No.", "Document No.");
            RentSalesLineVF.SetRange("Attached to Rent Line No.", RentLineVF."Line No.");
            RentSalesLineVF.SetFilter("Line No.", '<>%1', "Line No.");
            //RentSalesLineVF.SetRange("End Date", "Start Date" + 1);
            if RentSalesLineVF.FindLast() then begin
                "VF Run 1 From" := RentSalesLineVF."VF Run 1 To";
                "VF Run 2 From" := RentSalesLineVF."VF Run 2 To";
                "VF Run 3 From" := RentSalesLineVF."VF Run 3 To";
            end;
        end;
    end;

    local procedure InsertRentSalesLine(ResourceNo: Code[20]; UOMCode: Code[10]; Quantity: Decimal; UnitPrice: Decimal; LocationCode: Code[10])
    var
        RentSalesLineNo: Integer;
        RentSalesLineToInsert: Record "Rent Sales Line";
    begin
        RentSalesLineToInsert.Reset;
        RentSalesLineToInsert.SetRange("Document Type", "Document Type");
        RentSalesLineToInsert.SetRange("Document No.", "Document No.");
        if RentSalesLineToInsert.FindLast then
            RentSalesLineNo := RentSalesLineToInsert."Line No." + 10000
        else
            RentSalesLineNo := 10000;

        RentSalesLineToInsert.Init;
        RentSalesLineToInsert."Document Type" := "Document Type";
        RentSalesLineToInsert."Document No." := "Document No.";
        RentSalesLineToInsert."Line No." := RentSalesLineNo;
        RentSalesLineToInsert.Type := RentSalesLineToInsert.Type::Resource;
        RentSalesLineToInsert.Validate("No.", ResourceNo);
        RentSalesLineToInsert.Description := Description; //Overwrite Description
        RentSalesLineToInsert."Unit of Measure Code" := UOMCode;
        RentSalesLineToInsert."Attached to Rent Line No." := "Attached to Rent Line No.";
        RentSalesLineToInsert."Attach. to Rent Sales Line No." := "Line No.";
        RentSalesLineToInsert.Validate(Quantity, ROUND(Quantity, 1));
        RentSalesLineToInsert.Validate("Unit Price", UnitPrice);
        RentSalesLineToInsert.Validate("Line Discount %", "Line Discount %");
        RentSalesLineToInsert."To Invoice" := true;
        RentSalesLineToInsert."Location Code" := LocationCode;
        RentSalesLineToInsert."Rent Item No." := "Rent Item No.";
        RentSalesLineToInsert."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        RentSalesLineToInsert."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        RentSalesLineToInsert."Extra Charge Line" := true;
        //RentSalesLineToInsert."VF Run 1 From" := VFR1;
        //RentSalesLineToInsert."VF Run 1 To" := VFR2;
        RentSalesLineToInsert.Insert;
    end;


    procedure CancelRentSalesLine(RentSalesLineToCancel: Record "Rent Sales Line")
    var
        CancelingRentSalesLine: Record "Rent Sales Line";
        LineNo: Integer;
    begin
        CancelingRentSalesLine.Reset;
        CancelingRentSalesLine.SetRange("Document Type", RentSalesLineToCancel."Document Type");
        CancelingRentSalesLine.SetRange("Document No.", RentSalesLineToCancel."Document No.");
        if CancelingRentSalesLine.FindLast then
            LineNo := CancelingRentSalesLine."Line No." + 10000;
        CancelingRentSalesLine.Init;
        CancelingRentSalesLine := RentSalesLineToCancel;
        OnAfterInitCancelingRentSalesLine(CancelingRentSalesLine);
        CancelingRentSalesLine."Line No." := LineNo;
        CancelingRentSalesLine.Validate(Quantity, -RentSalesLineToCancel.Quantity);
        CancelingRentSalesLine."Cancels Line No." := RentSalesLineToCancel."Line No.";
        CancelingRentSalesLine.Insert(true);
    end;


    procedure ShowItemSub()
    var
        //ItemSubstitutionMgt: Codeunit "Item Subst.";
        ItemSubstitutionSync: Codeunit "Item Substitution Sync";
        TransferExtendedText: Codeunit "Transfer Extended Text";
    begin
        ItemSubstitutionSync.ItemSubstGetRent(Rec);
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Line", intFieldNo));
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    local procedure CheckHasExtraChargeLine(): Boolean
    var
        RentSalesLineExtra: Record "Rent Sales Line";
    begin
        RentSalesLineExtra.Reset;
        RentSalesLineExtra.SetRange("Document Type", "Document Type");
        RentSalesLineExtra.SetRange("Document No.", "Document No.");
        RentSalesLineExtra.SetRange("Attach. to Rent Sales Line No.", "Line No.");
        if RentSalesLineExtra.FindFirst() then
            EXIT(true)
        else
            exit(false);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnbeforefilterCheckDiscount(retsalesline: record "Rent Sales Line"; var SalesDiscount: Record "SP Sales Disc. Group Items"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnbeforeCheckDiscount(retsalesline: record "Rent Sales Line"; var SalesDiscount: Record "SP Sales Disc. Group Items"; var Errorexist: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitCancelingRentSalesLine(var RentsaleslineToCancel: record "Rent Sales Line")
    begin
    end;
}

