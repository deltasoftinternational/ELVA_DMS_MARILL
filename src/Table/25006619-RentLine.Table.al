Table 25006619 "Rent Line"
{
    Caption = 'Rent Line';
    DrillDownPageID = "Rent Lines";
    LookupPageID = "Rent Lines";
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
        field(50; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';
            TableRelation = "Rent Item";

            trigger OnValidate()
            var
                DocumentDate: Date;
            begin
                if "Quantity Invoiced" <> 0 then
                    Error(Err003);

                if (Status = Status::Rented) or (Status = Status::Returned) or (Status = Status::"In Service") then
                    Error(Err004);

                if (xRec."Rent Item No." <> "Rent Item No.") and ("Rent Item No." <> '') then begin
                    RentItem.Get("Rent Item No.");
                    RentHeader.Get("Document Type", "Document No.");
                    "Gen. Bus. Posting Group" := RentHeader."Gen. Bus. Posting Group";
                    "VAT Bus. Posting Group" := RentHeader."VAT Bus. Posting Group";
                    if "Rent Period Type" <> '' then begin
                        if RentHeader."Document Date" = 0D then
                            DocumentDate := WorkDate
                        else
                            DocumentDate := RentHeader."Document Date";


                        PriceCalcMgt.FindSalesLinePrice(RentHeader, Rec, FieldNo("Rent Item No."));

                        Validate(Quantity, 1);
                        Validate("Unit Price");
                    end;

                    if RentItemCategory.Get(RentItem."Rent Item Category Code") then begin
                        "Gen. Prod. Posting Group" := RentItemCategory."Def. Gen. Prod. Posting Group";
                        "VAT Prod. Posting Group" := RentItemCategory."Def. VAT Prod. Posting Group";
                    end;

                    Validate("VAT Prod. Posting Group");
                    //VALIDATE("Unit of Measure Code");
                    UpdateUnitPrice(FieldNo("Rent Item No."));
                    //UpdateAmounts;
                end;

                if RentItem.Get("Rent Item No.") then begin
                    Description := RentItem.Description;
                    //  "Sales Price" := RentItem."Sales Price";
                    "Model Code" := RentItem."Model Code";
                    "Shortcut Dimension 1 Code" := RentItem."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := RentItem."Global Dimension 2 Code";
                end;

                If (not "Component Line") and ("Rent Asset No." = '') then begin
                    RentItemRelation.Reset;
                    RentItemRelation.SetRange(RentItemRelation."Rent Item No.", "Rent Item No.");
                    if RentItemRelation.Count = 1 then begin
                        RentItemRelation.Find('-');
                        Validate("Rent Asset No.", RentItemRelation."Rent Asset No.");
                    end;
                end;


                CallCreateDim;

                UpdateLineDiscount;
            end;
        }

        field(60; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Allocated,Rented,Returned,In Service';
            OptionMembers = " ","Allocated","Rented","Returned","In Service";
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
        field(100; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
        }
        field(110; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            TableRelation = "Rent Asset";

            trigger OnLookup()
            begin
                RentItemRelation.Reset;
                RentItemRelation.SetRange("Rent Item No.", "Rent Item No.");
                if RentItemRelation.FindSet then
                    repeat
                        if RentAsset.Get(RentItemRelation."Rent Asset No.") then
                            RentAsset.Mark(true);
                    until RentItemRelation.Next = 0;
                RentAsset.MarkedOnly(true);
                if Page.RunModal(0, RentAsset) = Action::LookupOK then
                    Validate("Rent Asset No.", RentAsset."No.");
            end;

            trigger OnValidate()
            begin
                if (Status = Status::Rented) or (Status = Status::Returned) or (Status = Status::"In Service") then
                    Error(Err005);

                RentAsset.Get(Rec."Rent Asset No.");
                if RentAsset.Status = RentAsset.Status::Disposed then
                    Error(Err006);

                if Rec."Rent Asset No." <> xRec."Rent Asset No." then begin
                    RentLineComponent.Reset();
                    RentLineComponent.SetRange("Document Type", Rec."Document Type");
                    RentLineComponent.SetRange("Document No.", Rec."Document No.");
                    RentLineComponent.SetRange("Attached to Line No.", Rec."Line No.");
                    RentLineComponent.SetRange("Component Line", true);
                    If RentLineComponent.FindFirst() then
                        RentLineComponent.DeleteAll(true);
                end;

                //RentPlanningMgt.UpdatePlanningEntriesLine(Rec);
                if "Rent Asset No." = '' then begin
                    "Serial No." := '';
                    "Vehicle Serial No." := '';
                end else begin
                    RentAsset.Get("Rent Asset No.");
                    "Serial No." := RentAsset."Serial No.";
                    "Vehicle Serial No." := RentAsset."Vehicle Serial No.";

                    If (not "Component Line") and ("Rent Item No." = '') then begin
                        RentItemRelation.Reset;
                        RentItemRelation.SetRange(RentItemRelation."Rent Asset No.", "Rent Asset No.");
                        if RentItemRelation.Count = 1 then begin
                            RentItemRelation.Find('-');
                            Validate("Rent Item No.", RentItemRelation."Rent Item No.");
                        end;
                    end;

                    AddRentAssetComponents();
                end;
                UpdateStatus("Rent Asset No.");
            end;
        }
        field(120; "Rent Asset Description"; Text[100])
        {
            CalcFormula = lookup("Rent Asset".Description where("No." = field("Rent Asset No.")));
            Caption = 'Rent Asset Description';
            FieldClass = FlowField;
        }
        field(130; "Rent Asset Quantity"; Decimal)
        {
            Caption = 'Rent Asset Quantity';
            Editable = false;
        }
        field(140; "Planned Shipment Date"; Date)
        {
            Caption = 'Planned Shipment Date';

            trigger OnValidate()
            begin
                //RentPlanningMgt.UpdatePlanningEntriesLine(Rec);
            end;
        }
        field(145; "Planned Return Date"; Date)
        {
            Caption = 'Planned Return Date';

            trigger OnValidate()
            begin
                //RentPlanningMgt.UpdatePlanningEntriesLine(Rec);
            end;
        }
        field(150; "Rent Period Type"; Code[20])
        {
            Caption = 'Rent Period Type';
            TableRelation = "Rent Period";

            trigger OnValidate()
            var
                DocumentDate: Date;
            begin
                if "Quantity Invoiced" <> 0 then
                    Error(Err002);
                RentHeader.Get("Document Type", "Document No.");
                if (xRec."Rent Period Type" <> "Rent Period Type") and ("Rent Period Type" <> '') then begin
                    if "Rent Item No." <> '' then begin
                        if RentHeader."Document Date" = 0D then
                            DocumentDate := WorkDate
                        else
                            DocumentDate := RentHeader."Document Date";
                        /*
                        RentItemSalesPrice.RESET;
                        RentItemSalesPrice.SETCURRENTKEY("Rent Period Price");
                        RentItemSalesPrice.SETRANGE("Rent Item No.","Rent Item No.");
                        RentItemSalesPrice.SETRANGE("Rent Period Code","Rent Period Type");
                        RentItemSalesPrice.SETFILTER("Starting Date",'..%1',DocumentDate);
                        RentItemSalesPrice.SETFILTER("Ending Date",'%1..|%2',DocumentDate,0D);

                        IF RentItemSalesPrice.FINDFIRST THEN BEGIN
                          VALIDATE(Quantity,1);
                          VALIDATE("Unit Price",RentItemSalesPrice."Rent Period Price");
                        END;
                        */
                        PriceCalcMgt.FindSalesLinePrice(RentHeader, Rec, FieldNo("Rent Item No."));

                        Validate(Quantity, 1);
                        Validate("Unit Price");

                    end;
                end;

                if RentPeriod.Get("Rent Period Type") and ("Rent Start Date" <> 0D) and (Quantity <> 0) and (RentHeader."Rent Type" = RentHeader."Rent Type"::"Set End Date") then begin
                    CalculatedDate := "Rent Start Date";
                    i := 0;
                    repeat
                        CalculatedDate := CalcDate(RentPeriod.Duration, CalculatedDate);
                        i += 1;
                    until i = Quantity;
                    if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Calendar Period" then
                        CalculatedDate := CalcDate('<-1D>', CalculatedDate);
                    Validate("Rent End Date", CalculatedDate);
                end;

            end;
        }
        field(160; Quantity; Decimal)
        {
            Caption = 'Rent Periods';

            trigger OnValidate()
            begin
                RentHeader.Get("Document Type", "Document No.");
                SalesLineInvQty := 0;

                "Line Amount" := Quantity * "Unit Price" * "Rent Asset Quantity";

                if "Line No." <> 0 then begin
                    //Get Invoiced Quantity
                    RentSalesLine.Reset;
                    RentSalesLine.SetRange("Document Type", "Document Type");
                    RentSalesLine.SetRange("Document No.", "Document No.");
                    RentSalesLine.SetRange("Attached to Rent Line No.", "Line No.");
                    RentSalesLine.SetRange("Extra Charge Line", false);
                    if RentSalesLine.FindFirst then
                        repeat
                            SalesLineInvQty += RentSalesLine.Quantity;
                        until RentSalesLine.Next = 0;

                    "Qty. to Invoice" := Quantity - SalesLineInvQty;
                end else begin
                    "Qty. to Invoice" := Quantity;
                end;

                if RentPeriod.Get("Rent Period Type") and ("Rent Start Date" <> 0D) and (Quantity <> 0) and (RentHeader."Rent Type" = RentHeader."Rent Type"::"Set End Date") then begin
                    CalculatedDate := "Rent Start Date";
                    i := 0;
                    repeat
                        CalculatedDate := CalcDate(RentPeriod.Duration, CalculatedDate);
                        i += 1;
                    until i = Quantity;
                    RentSetup.Get;
                    if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Calendar Period" then
                        CalculatedDate := CalcDate('<-1D>', CalculatedDate);
                    Validate("Rent End Date", CalculatedDate);
                end;

                UpdateLineDiscount;
            end;
        }
        field(170; "Unit Price"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                "Line Amount" := Quantity * "Unit Price" * "Rent Asset Quantity";
            end;
        }
        field(180; "Line Amount"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            Caption = 'Line Amount';
        }
        field(190; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Periods to Invoice';

            trigger OnValidate()
            begin
                if "Qty. to Invoice" > Quantity - "Quantity Invoiced" then
                    Error(Err001, Quantity - "Quantity Invoiced");

                /*
                IF "Qty. to Invoice" = MaxQtyToInvoice THEN
                  InitQtyToInvoice
                ELSE
                  "Qty. to Invoice (Base)" := CalcBaseQty("Qty. to Invoice");
                IF ("Qty. to Invoice" * Quantity < 0) OR
                   (ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice))
                THEN
                  ERROR(
                    Text005,
                    MaxQtyToInvoice);
                IF ("Qty. to Invoice (Base)" * "Quantity (Base)" < 0) OR
                   (ABS("Qty. to Invoice (Base)") > ABS(MaxQtyToInvoiceBase))
                THEN
                  ERROR(
                    Text006,
                    MaxQtyToInvoiceBase);
                "VAT Difference" := 0;
                CalcInvDiscToInvoice;
                CalcPrepaymentToDeduct;
                */

            end;
        }
        field(200; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Periods Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(210; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Line Discount Amount" :=
                  ROUND(
                    ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100, Currency."Amount Rounding Precision");
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(220; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            begin
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
        field(230; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            Editable = false;

            trigger OnValidate()
            begin
                /*
                TESTFIELD(Quantity);
                CalcInvDiscToInvoice;
                */
                UpdateAmounts;

            end;
        }
        field(240; "Inv. Disc. Amount to Invoice"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            Editable = false;
        }
        field(250; "VAT Identifier"; Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(260; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateAmounts;
            end;
        }
        field(270; Amount; Decimal)
        {
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

                //InitOutstandingAmount;
                //IF Type = Type::"Charge (Item)" THEN
                //  UpdateItemChargeAssgnt;
            end;
        }
        field(280; "VAT Base Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(290; "Amount Including VAT"; Decimal)
        {
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

                //InitOutstandingAmount;
            end;
        }
        field(300; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(310; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(320; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(330; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(340; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                //TESTFIELD("Job Contract Entry No.",0);
                //TESTFIELD("Qty. per Unit of Measure",1);
                //VALIDATE(Quantity,"Quantity (Base)");
                //UpdateUnitPrice(FIELDNO("Quantity (Base)"));
            end;
        }
        field(350; "VAT Difference"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(360; "Gen. Bus. Posting Group"; Code[20])
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
        field(370; "Gen. Prod. Posting Group"; Code[20])
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
        field(380; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                Validate("VAT Prod. Posting Group");
            end;
        }
        field(390; "VAT Prod. Posting Group"; Code[20])
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
                            //TESTFIELD(Type,Type::"G/L Account");
                            //VATPostingSetup.TESTFIELD("Sales VAT Account");
                            //TESTFIELD("No.",VATPostingSetup."Sales VAT Account");
                        end;
                end;
                //IF RentHeader."Prices Including VAT" AND (Type IN [Type::Item,Type::Resource]) THEN
                "Unit Price" :=
                  ROUND(
                    "Unit Price" * (100 + "VAT %") / (100 + xRec."VAT %"),
                    Currency."Unit-Amount Rounding Precision");
            end;
        }
        field(400; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(450; "Actual Shipment Date"; Date)
        {
            CalcFormula = min("Rent Ledger Entry"."Shipment Date" where("Rent Order No." = field("Document No."),
                                                                         "Rent Order Type" = const(Order),
                                                                         "Rent Order Line No." = field("Line No."),
                                                                         "Rent Transfer Type" = const(Shipment),
                                                                         "Entry Type" = const(Inventory)
                                                                         ));
            Caption = 'Actual Shipment Date';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin

            end;
        }
        field(460; "Actual Return Date"; Date)
        {
            CalcFormula = max("Rent Ledger Entry"."Shipment Date" where("Rent Order No." = field("Document No."),
                                                                         "Rent Order Type" = const(Order),
                                                                         "Rent Order Line No." = field("Line No."),
                                                                         "Rent Transfer Type" = const(Receipt),
                                                                         "Entry Type" = const(Inventory)
                                                                         ));
            Caption = 'Actual Return Date';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin

            end;
        }
        field(470; "Rent Start Date"; Date)
        {
            Caption = 'Rent Start Date';

            trigger OnValidate()
            begin
                RentHeader.Get("Document Type", "Document No.");
                if "Planned Shipment Date" = 0D then
                    "Planned Shipment Date" := "Rent Start Date";



                if RentPeriod.Get("Rent Period Type") and ("Rent Start Date" <> 0D) and (Quantity <> 0) and (RentHeader."Rent Type" = RentHeader."Rent Type"::"Set End Date") then begin
                    CalculatedDate := "Rent Start Date";
                    i := 0;
                    repeat
                        CalculatedDate := CalcDate(RentPeriod.Duration, CalculatedDate);
                        i += 1;
                    until i = Quantity;
                    if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Calendar Period" then
                        CalculatedDate := CalcDate('<-1D>', CalculatedDate);
                    Validate("Rent End Date", CalculatedDate);
                end;
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
        field(485; "Rent End Date"; Date)
        {
            Caption = 'Rent End Date';

            trigger OnValidate()
            begin
                //IF "Planned Return Date" = 0D THEN
                RentHeader.Get("Document Type", "Document No.");
                if RentHeader."Rent Type" = RentHeader."Rent Type"::"Set End Date" then
                    "Planned Return Date" := "Rent End Date";

                //RentPlanningMgt.UpdatePlanningEntriesLine(Rec);
            end;
        }
        field(490; "Serial No."; Text[30])
        {
            Caption = 'Serial No.';
        }
        field(500; "Model Code"; Code[20])
        {
            Caption = 'Model';
        }
        field(510; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(520; "Campaign No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(530; "Last Date Invoiced"; Date)
        {
            Caption = 'Last Date Invoiced';
            DataClassification = ToBeClassified;
        }
        field(600; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            DataClassification = ToBeClassified;
            TableRelation = Vehicle;
        }
        field(1100; "VF Run 1 From"; Decimal)
        {
            CaptionClass = '7,25006619,1100';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1110; "VF Run 1 To"; Decimal)
        {
            CaptionClass = '7,25006619,1110';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1120; "VF Run 2 From"; Decimal)
        {
            CaptionClass = '7,25006619,1120';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1130; "VF Run 2 To"; Decimal)
        {
            CaptionClass = '7,25006619,1130';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1140; "VF Run 3 From"; Decimal)
        {
            CaptionClass = '7,25006619,1140';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1150; "VF Run 3 To"; Decimal)
        {
            CaptionClass = '7,25006619,1150';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1200; "Sell-to Customer No."; Code[20])
        {
            CalcFormula = lookup("Rent Header"."Sell-to Customer No." where("Document Type" = field("Document Type"),
                                                                             "No." = field("Document No.")));
            Caption = 'Sell-to Customer No.';
            FieldClass = FlowField;
        }
        field(1210; "Locked"; Boolean)
        {
            Caption = 'Locked';
        }
        field(1220; "Locks Line"; Integer)
        {
            Caption = 'Locks Line';
        }
        field(1225; "Root Lock Line"; Integer)
        {
            Caption = 'Root Lock Line';
        }
        field(1230; "Quantity Shipped"; Decimal)
        {
            CalcFormula = Sum("Rent Ledger Entry"."Quantity" where("Rent Order No." = field("Document No."),
                                                                         "Rent Order Type" = const(Order),
                                                                         "Rent Order Line No." = field("Line No."),
                                                                         "Rent Transfer Type" = const(Shipment),
                                                                         "Document Type" = const(Receipt),
                                                                         "Entry Type" = const(Inventory)
                                                                         ));
            Caption = 'Quantity Shipped';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin

            end;
        }
        field(1240; "Quantity Returned"; Decimal)
        {
            CalcFormula = Sum("Rent Ledger Entry"."Quantity" where("Rent Order No." = field("Document No."),
                                                                         "Rent Order Type" = const(Order),
                                                                         "Rent Order Line No." = field("Line No."),
                                                                         "Rent Transfer Type" = const(Receipt),
                                                                         "Document Type" = const(Receipt),
                                                                         "Entry Type" = const(Inventory)
                                                                         ));
            Caption = 'Quantity Returned';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin

            end;
        }
        field(1250; "Component Line"; Boolean)
        {
            Caption = 'Component Line';
        }
        field(1260; "Manual Invoicing Start Date"; Date)
        {
            Caption = 'Manual Invoicing Start Date';

            trigger OnValidate()
            begin
                if "Last Date Invoiced" <> 0D then
                    Error(ManualRentInvoicingStartDateErr);
            end;
        }
        field(1270; "Manual Invoicing End Date"; Date)
        {
            Caption = 'Manual Invoicing End Date';
        }
        field(1280; "Invoice Additional Description"; Text[100])
        {
            Caption = 'Invoice Additional Description';
        }
        field(5000; Closed; Boolean)
        {
            Caption = 'Closed';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Line Amount";
        }
        key(Key2; "Location Code", "Planned Shipment Date")
        {
        }
        key(Key3; "Location Code", "Planned Return Date")
        {
        }
        key(Key4; "Location Code", "Last Date Invoiced")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        RentTransferLine: Record "Rent Transfer Line";
        PostedRentTransferLine: Record "Posted Rent Transfer Line";
        RentSalesLineToCheck: Record "Rent Sales Line";
        RentLineToCheck: Record "Rent Line";
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Rent Order No.", "Document No.");
        SalesLine.SetRange("Rent Order Line No.", "Line No.");
        if SalesLine.FindFirst then
            Error(RentSalesDocExistsErr, Format(SalesLine."Document Type"), SalesLine."Document No.");

        SalesInvoiceLine.Reset;
        SalesInvoiceLine.SetRange("Rent Order No.", "Document No.");
        SalesInvoiceLine.SetRange("Rent Order Line No.", "Line No.");
        if SalesInvoiceLine.FindFirst then
            Error(RentPostedSalesDocExistsErr, Format(SalesLine."document type"::Invoice), SalesInvoiceLine."Document No.");

        SalesCrMemoLine.Reset;
        SalesCrMemoLine.SetRange("Rent Order No.", "Document No.");
        SalesCrMemoLine.SetRange("Rent Order Line No.", "Line No.");
        if SalesCrMemoLine.FindFirst then
            Error(RentPostedSalesDocExistsErr, Format(SalesLine."document type"::"Credit Memo"), SalesCrMemoLine."Document No.");

        RentTransferLine.Reset;
        RentTransferLine.SetRange("Rent Order No.", "Document No.");
        RentTransferLine.SetRange("Rent Line No.", "Line No.");
        if RentTransferLine.FindFirst then
            Error(RentTransferExistsErr, RentTransferLine."Document No.");

        PostedRentTransferLine.Reset;
        PostedRentTransferLine.SetRange("Rent Order No.", "Document No.");
        PostedRentTransferLine.SetRange("Rent Line No.", "Line No.");
        if PostedRentTransferLine.FindFirst then
            Error(RentPostedTransferExistsErr, PostedRentTransferLine."Document No.");

        RentSalesLineToCheck.Reset;
        RentSalesLineToCheck.SetRange("Document Type", "Document Type");
        RentSalesLineToCheck.SetRange("Document No.", "Document No.");
        RentSalesLineToCheck.SetRange("Attached to Rent Line No.", "Line No.");
        if RentSalesLineToCheck.FindFirst then
            Error(RentSalesLineExistsErr);


        RentLineToCheck.Reset();
        RentLineToCheck.SetRange("Document Type", "Document Type");
        RentLineToCheck.SetRange("Document No.", "Document No.");
        RentLineToCheck.SetRange("Locks Line", "Line No.");
        if RentSalesLineToCheck.FindFirst or Locked then
            Error(RentPriceLineExistsErr);

        //If locked previouse line then unlock it
        if "Locks Line" <> 0 then begin
            if RentLineToCheck.Get("Document Type", "Document No.", "Locks Line") then begin
                RentLineToCheck.Locked := false;
                RentLineToCheck.Modify();
            end;
        end;

        RentLineComponent.Reset();
        RentLineComponent.SetRange("Document Type", Rec."Document Type");
        RentLineComponent.SetRange("Document No.", Rec."Document No.");
        RentLineComponent.SetRange("Attached to Line No.", Rec."Line No.");
        RentLineComponent.SetRange("Component Line", true);
        If RentLineComponent.FindFirst() then
            RentLineComponent.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        "Rent Asset Quantity" := 1;
        RentHeader.Get("Document Type", "Document No.");
        if RentHeader."Shipment Date" <> 0D then begin
            Validate("Rent Start Date", RentHeader."Shipment Date");
        end;
        IF "Location Code" = '' then
            Validate("Location Code", RentHeader."Location Code");

        if "Rent Asset No." <> '' then
            AddRentAssetComponents;
    end;

    trigger OnModify()
    begin
        UpdateStatus("Rent Asset No.");
    end;

    var
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        RentItemSalesPrice: Record "Rent Item Sales Price";
        RentItem: Record "Rent Item";
        RentPackage: Record "Rent Package";
        RentPackageLine: Record "Rent Package Line";
        RentLine: Record "Rent Line";
        RentSalesLine: Record "Rent Sales Line";
        RentHeader: Record "Rent Header";
        RentPeriod: Record "Rent Period";
        Currency: Record Currency;
        RentItemCategory: Record "Rent Item Category";
        LineNo: Integer;
        SalesLineInvQty: Decimal;
        Err001: label 'Quantity to Invoice can''t be greater than %1';
        StatusCheckSuspended: Boolean;
        Err002: label 'Can''t change period type. Rent Line already invoiced.';
        Err003: label 'Can''t change Rent Item. Rent Line already invoiced.';
        Err004: label 'Can''t change Rent Item. Rent Line already has shipments.';

        Err005: label 'Can''t change Rent Asset. Rent Line already has shipments.';
        Err006: label 'Can''t use this Rent Asset. Rent Asset is Disposed.';
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
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        PriceCalcMgt: Codeunit "Rent Price & Disc. Calc. Mgt.";
        RentMgt: Codeunit "Rent Management";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        VATPostingSetup: Record "VAT Posting Setup";
        VATProdPostingGroup: Code[20];
        CalculatedDate: Date;
        i: Decimal;
        RentItemRelation: Record "Rent Item Relation";
        DimMgt: Codeunit DimensionManagement;
        VFMgt: Codeunit "Variable Field Management";
        RentAsset: Record "Rent Asset";
        RentSetup: Record "Rent Mgt. Setup";
        RentSalesDocExistsErr: label 'Sales %1 %2 for rent order line exists!';
        RentPostedSalesDocExistsErr: label 'Posted sales %1 %2 for rent order line exists!';
        RentTransferExistsErr: label 'Transfer order %1 for rent order line exists!';
        RentPostedTransferExistsErr: label 'Posted transfer order %1 for rent order line exists!';
        RentSalesLineExistsErr: label 'Rent sales line for rent order line exists!';
        RentPriceLineExistsErr: label 'Rent price line for rent order line exists!';
        RentAssetNotSpecifiedErr: label 'Rent Asset not specified for line %1 !';
        RentLineHasExtrChargeErr: label 'There is already an extra charge line for Rent Line No. %1, Rent Item No. %2';
        OvertimeCalcTypeErr: Label 'You can''t use function to calculate charges from Rent Line if Overtime Calculation method is "Current Period". You must use function from Rental Sales Lines.';
        ActualReturnDateErr: Label 'You can run extra charge calculation once Rent Asset is returned';
        ManualRentInvoicingStartDateErr: Label 'You can''t change Manual Invoicing Start Date if there is already some period invoiced! ';
        CantCancelByDatesErr: Label 'To cancel specific invoiced dates Last Date Invoiced field value %1 must be later than Manual Invoicing End Date field value %2';
        RentAssetComponent: Record "Rent Asset Component";
        RentLineComponent: Record "Rent Line";


    procedure ApplyDefaultPackage()
    var
        VATProdPostingGroup1: Code[20];
        RentHeader1: Record "Rent Header";
    begin
        RentHeader1.Get(Rec."Document Type", Rec."Document No.");
        if RentItem.Get(Rec."Rent Item No.") then begin
            //Get Default rent package
            if RentPackage.Get(RentItem."Default Rent Package No.") then begin
                RentPackageLine.Reset;
                RentPackageLine.SetRange("Package No.", RentPackage."No.");
                if RentPackageLine.FindFirst then
                    repeat
                        if RentPackageLine.Type = RentPackageLine.Type::"Rent Item" then begin
                            //Add rent item line
                            RentLine.Reset;
                            RentLine.SetRange("Document Type", Rec."Document Type");
                            RentLine.SetRange("Document No.", Rec."Document No.");
                            if RentLine.FindLast then
                                LineNo := RentLine."Line No." + 10000
                            else
                                LineNo := 10000;

                            RentLine.Init;
                            RentLine."Line No." := LineNo;
                            RentLine."Document Type" := Rec."Document Type";
                            RentLine."Document No." := Rec."Document No.";
                            RentLine.Validate("Rent Item No.", RentPackageLine."No.");
                            RentLine.Validate(Quantity, RentPackageLine.Quantity);
                            RentLine.Validate("Rent Period Type", RentPackageLine."Rent Period Code");
                            RentLine."Rent Asset Quantity" := 1;

                            if RentPackageLine."Unit Price" <> 0 then begin
                                //Check VAT and Currency

                                if (RentItem.Get(RentPackageLine."No.")) then
                                    if RentItemCategory.Get(RentItem."Rent Item Category Code") then
                                        VATProdPostingGroup1 := RentItemCategory."Def. VAT Prod. Posting Group";

                                ConvertPriceToVAT(
                                  RentPackageLine."Price Includes VAT",
                                  RentLine."VAT Prod. Posting Group",
                                  RentPackageLine."VAT Bus. Posting Gr. (Price)",
                                  RentHeader1."Prices Including VAT",
                                  RentLine."VAT Bus. Posting Group",
                                  RentLine."VAT Calculation Type",
                                  RentLine."VAT %",
                                  RentPackageLine."Unit Price");
                                ConvertPriceLCYToFCY(RentHeader1, RentPackageLine."Currency Code", RentPackageLine."Unit Price");

                                RentLine.Validate("Unit Price", RentPackageLine."Unit Price");
                            end;

                            RentLine.Insert(true);
                        end else begin
                            //Add rent sales line
                            RentSalesLine.Reset;
                            RentSalesLine.SetRange("Document Type", Rec."Document Type");
                            RentSalesLine.SetRange("Document No.", Rec."Document No.");
                            if RentSalesLine.FindLast then
                                LineNo := RentSalesLine."Line No." + 10000
                            else
                                LineNo := 10000;

                            RentSalesLine.Init;
                            RentSalesLine."Line No." := LineNo;
                            RentSalesLine."Document Type" := Rec."Document Type";
                            RentSalesLine."Document No." := Rec."Document No.";
                            RentSalesLine.Validate(Type, RentPackageLine.Type);
                            RentSalesLine.Validate("No.", RentPackageLine."No.");
                            RentSalesLine.Validate(Description, RentPackageLine.Description);
                            RentSalesLine.Validate(Quantity, RentPackageLine.Quantity);

                            if RentPackageLine."Unit Price" <> 0 then begin
                                //Check VAT and Currency
                                ConvertPriceToVAT(RentPackageLine."Price Includes VAT",
                                  RentSalesLine."VAT Prod. Posting Group",
                                  RentPackageLine."VAT Bus. Posting Gr. (Price)",
                                  RentHeader1."Prices Including VAT",
                                  RentSalesLine."VAT Bus. Posting Group",
                                  RentSalesLine."VAT Calculation Type",
                                  RentSalesLine."VAT %", RentPackageLine."Unit Price");

                                ConvertPriceLCYToFCY(RentHeader1, RentPackageLine."Currency Code", RentPackageLine."Unit Price");
                                RentSalesLine.Validate("Unit Price", RentPackageLine."Unit Price");
                            end;
                            RentSalesLine.Insert(true);
                        end;
                    until RentPackageLine.Next = 0;
            end;
        end;
    end;


    procedure CreateSalesLines(RentHeader1: Record "Rent Header"; CalculateOnDate: Date)
    var
        CalcToDateLine: Date;
        CalcFromDateLine: Date;
    begin
        RentSetup.Get;
        RentLine.Reset;
        RentLine.SetRange("Document No.", RentHeader1."No.");
        RentLine.SetRange("Document Type", RentHeader1."Document Type");
        RentLine.SetFilter("Qty. to Invoice", '<>0');
        RentLine.SetRange("Component Line", false);
        if RentLine.FindFirst then
            repeat
                RentLine.CreateSalesLine(CalculateOnDate);
            until RentLine.Next = 0;
    end;



    procedure CreateSalesLine(CalculateOnDate: Date);
    var
        CalcToDateLine: Date;
        CalcFromDateLine: Date;
        RentHeader1: Record "Rent Header";
        MapViewTelematics: Record "Vehicle Telematics";
        ExtraRun: Decimal;
        ExtraResourceNo: Code[20];
    begin
        RentSetup.Get;
        RentHeader1.Get("Document Type", "Document No.");
        //RentLine.SetFilter("Qty. to Invoice", '<>0');

        TestField("Rent Start Date");
        if RentSetup."Invoice Only with Rent Asset" and ("Rent Asset No." = '') then
            Error(RentAssetNotSpecifiedErr, Format("Line No."));
        //Get Rent Period
        RentPeriod.Get("Rent Period Type");
        //Get Rent Item
        RentItem.Get("Rent Item No.");
        RentItem.TestField("Resource No.");

        //Add rent sales line
        RentSalesLine.Reset;
        RentSalesLine.SetRange("Document Type", "Document Type");
        RentSalesLine.SetRange("Document No.", "Document No.");
        if RentSalesLine.FindLast then
            LineNo := RentSalesLine."Line No." + 10000
        else
            LineNo := 10000;

        CalcToDateLine := CalculateOnDate;
        if ("Rent End Date" > 0D) AND ("Rent End Date" < CalculateOnDate) then
            CalcToDateLine := "Rent End Date";
        if "Last Date Invoiced" <> 0D then
            if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Standard Period" then
                CalcFromDateLine := "Last Date Invoiced"
            else
                CalcFromDateLine := "Last Date Invoiced" + 1;
        if CalcFromDateLine = 0D then
            CalcFromDateLine := "Rent Start Date";


        RentSalesLine.Init;
        RentSalesLine."Document Type" := "Document Type";
        RentSalesLine."Document No." := "Document No.";
        RentSalesLine."Line No." := LineNo;
        RentSalesLine.Type := RentSalesLine.Type::Resource;
        RentSalesLine.Validate("No.", RentItem."Resource No.");
        //RentSalesLine.Description := Description; //Overwrite Description
        RentSalesLine."Unit of Measure Code" := RentPeriod."Unit of Measure Code";
        RentSalesLine."Attached to Rent Line No." := "Line No.";

        RentSalesLine.Validate("Rent Asset Quantity", "Rent Asset Quantity");
        RentSalesLine.Validate(Periods, "Qty. to Invoice");
        RentSalesLine.Validate(Quantity, ROUND("Qty. to Invoice" * "Rent Asset Quantity", 1));

        RentSalesLine.Validate("Unit Price", "Unit Price");
        RentSalesLine.Validate(RentSalesLine."Line Discount %", "Line Discount %");
        RentSalesLine."To Invoice" := true;
        RentSalesLine."Location Code" := RentHeader1."Location Code";
        RentSalesLine."Rent Item No." := "Rent Item No.";
        RentSalesLine."Vehicle Serial No." := "Vehicle Serial No.";
        RentSalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        RentSalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        /*
        if "Last Date Invoiced" = 0D then
            RentSalesLine."Start Date" := "Rent Start Date"
        else
            if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Standard Period" then
                RentSalesLine."Start Date" := "Last Date Invoiced"
            else
                RentSalesLine."Start Date" := "Last Date Invoiced" + 1;
        */
        RentPeriod.Get("Rent Period Type");
        CalcFields("Actual Return Date", "Actual Shipment Date");

        RentSalesLine."Start Date" := CalcFromDateLine;
        RentSalesLine."End Date" := CalcFromDateLine + ROUND((RentSalesLine.Quantity * CalculatePeriod(CalcFromDateLine, RentPeriod.Duration, '+')), 1, '=');
        RentSalesLine."Dimension Set ID" := "Dimension Set ID";
        UpdateRentSalesLineVFRun(RentSalesLine, Rec);

        if RentHeader1."Overtime Calculation" = RentHeader."Overtime Calculation"::"Current Period" then begin
            if RentAsset.get("Rent Asset No.") and (RentAsset."Vehicle Serial No." <> '') then begin
                MapViewTelematics.Reset();
                MapViewTelematics.SetRange("Vehicle Serial No.", RentAsset."Vehicle Serial No.");
                MapViewTelematics.SetFilter("Date Stamp", '..%1', RentSalesLine."End Date");
                if MapViewTelematics.FindLast() then begin
                    if MapViewTelematics."Variable Field Run 1" > RentSalesLine."VF Run 1 From" then begin
                        RentSalesLine."VF Run 1 To" := MapViewTelematics."Variable Field Run 1";
                    end;
                    if MapViewTelematics."Variable Field Run 2" > RentSalesLine."VF Run 2 From" then begin
                        RentSalesLine."VF Run 2 To" := MapViewTelematics."Variable Field Run 2";
                    end;
                    if MapViewTelematics."Variable Field Run 3" > RentSalesLine."VF Run 3 From" then begin
                        RentSalesLine."VF Run 3 To" := MapViewTelematics."Variable Field Run 3";
                    end;
                end
            end;
        end;

        RentSalesLine.Insert(true);

        if RentHeader1."Overtime Calculation" = RentHeader."Overtime Calculation"::"Current Period" then begin
            RentSalesLine.CreateExtraChargeLines();
        end;

        //Update Rent Line Quantity to invoice fields
        "Quantity Invoiced" := "Quantity Invoiced" + "Qty. to Invoice";
        if Quantity <> "Quantity Invoiced" then
            "Qty. to Invoice" := Quantity - "Quantity Invoiced"
        else
            "Qty. to Invoice" := 0;
        "Last Date Invoiced" := RentSalesLine."End Date";
        Modify;
    end;

    procedure CreateSalesLineCancelByDates()
    var
        CalcToDateLine: Date;
        CalcFromDateLine: Date;
        RentHeader1: Record "Rent Header";
        MapViewTelematics: Record "Vehicle Telematics";
        ExtraRun: Decimal;
        ExtraResourceNo: Code[20];
        DaysInPeriod: Decimal;
        CalcPeriods: Decimal;
    begin
        RentSetup.Get;
        RentHeader1.Get("Document Type", "Document No.");
        //RentLine.SetFilter("Qty. to Invoice", '<>0');

        TestField("Last Date Invoiced");
        TestField("Manual Invoicing End Date");
        if not ("Manual Invoicing End Date" < "Last Date Invoiced") then
            Error(CantCancelByDatesErr, "Last Date Invoiced", "Manual Invoicing End Date");
        if RentSetup."Invoice Only with Rent Asset" and ("Rent Asset No." = '') then
            Error(RentAssetNotSpecifiedErr, Format("Line No."));
        //Get Rent Period
        RentPeriod.Get("Rent Period Type");
        //Get Rent Item
        RentItem.Get("Rent Item No.");
        RentItem.TestField("Resource No.");

        //Add rent sales line
        RentSalesLine.Reset;
        RentSalesLine.SetRange("Document Type", "Document Type");
        RentSalesLine.SetRange("Document No.", "Document No.");
        if RentSalesLine.FindLast then
            LineNo := RentSalesLine."Line No." + 10000
        else
            LineNo := 10000;

        CalcToDateLine := "Last Date Invoiced";
        if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Standard Period" then
            CalcFromDateLine := "Manual Invoicing End Date"
        else
            CalcFromDateLine := "Manual Invoicing End Date" + 1;


        RentSalesLine.Init;
        RentSalesLine."Document Type" := "Document Type";
        RentSalesLine."Document No." := "Document No.";
        RentSalesLine."Line No." := LineNo;
        RentSalesLine.Type := RentSalesLine.Type::Resource;
        RentSalesLine.Validate("No.", RentItem."Resource No.");
        RentSalesLine."Unit of Measure Code" := RentPeriod."Unit of Measure Code";
        RentSalesLine."Attached to Rent Line No." := "Line No.";

        RentSalesLine.Validate("Rent Asset Quantity", "Rent Asset Quantity");

        DaysInPeriod := RentLine.CalculatePeriod(CalcDate('<CM>', CalcToDateLine), RentPeriod.Duration, '-');
        if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Standard Period" then
            CalcPeriods := (CalcToDateLine - CalcFromDateLine) / DaysInPeriod
        else
            CalcPeriods := ((CalcToDateLine - CalcFromDateLine) + 1) / DaysInPeriod;

        RentSalesLine.Validate(Periods, -CalcPeriods);
        RentSalesLine.Validate(Quantity, ROUND(-CalcPeriods * "Rent Asset Quantity", 0.00001));

        RentSalesLine.Validate("Unit Price", "Unit Price");
        RentSalesLine.Validate(RentSalesLine."Line Discount %", "Line Discount %");
        RentSalesLine."To Invoice" := true;
        RentSalesLine."Location Code" := RentHeader1."Location Code";
        RentSalesLine."Rent Item No." := "Rent Item No.";
        RentSalesLine."Vehicle Serial No." := "Vehicle Serial No.";
        RentSalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        RentSalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        RentPeriod.Get("Rent Period Type");
        CalcFields("Actual Return Date", "Actual Shipment Date");

        RentSalesLine."Start Date" := CalcFromDateLine;
        RentSalesLine."End Date" := CalcToDateLine;
        RentSalesLine."Dimension Set ID" := "Dimension Set ID";
        //UpdateRentSalesLineVFRun(RentSalesLine, Rec);

        RentSalesLine.Insert(true);

        //Update Rent Line Quantity to invoice fields
        "Quantity Invoiced" := "Quantity Invoiced" - CalcPeriods;
        if Quantity <> "Quantity Invoiced" then
            "Qty. to Invoice" := Quantity - "Quantity Invoiced"
        else
            "Qty. to Invoice" := 0;
        "Last Date Invoiced" := "Manual Invoicing End Date";
        Modify;
    end;

    procedure SetRentHeader(NewRentHeader: Record "Rent Header")
    begin
        /*
        RentHeader := NewRentHeader;
        
        IF RentHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          RentHeader.TESTFIELD("Currency Factor");
          Currency.GET(RentHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
        */

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


    procedure UpdateAmounts()
    begin
        GetRentHeader;
        if "Line Amount" <> ROUND(Quantity * "Unit Price" * "Rent Asset Quantity", Currency."Amount Rounding Precision") - "Line Discount Amount" then begin
            "Line Amount" := ROUND(Quantity * "Unit Price" * "Rent Asset Quantity", Currency."Amount Rounding Precision") - "Line Discount Amount";
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
        Field.Get(Database::"Rent Line", FieldNumber);
        exit(Field."Field Caption");
    end;

    local procedure TestStatusOpen()
    begin
        //IF StatusCheckSuspended THEN
        //  EXIT;
        GetRentHeader;
        //IF Type IN [Type::Item,Type::"Fixed Asset"] THEN
        RentHeader.TestField(Status, RentHeader.Status::Open);
    end;

    local procedure UpdateUnitPrice(CalledByFieldNo: Integer)
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        GetRentHeader;

        //PriceCalcMgt.FindSalesLineLineDisc(RentHeader,Rec);
        PriceCalcMgt.FindSalesLinePrice(RentHeader, Rec, CalledByFieldNo);
        //PriceCalcMgt.FindSalesLinePrice4Weeks(RentHeader, Rec, CalledByFieldNo);
        //PriceCalcMgt.FindSalesLinePriceWeekly(RentHeader, Rec, CalledByFieldNo);
        //PriceCalcMgt.FindSalesLinePriceDaily(RentHeader, Rec, CalledByFieldNo);

        Validate("Unit Price");
    end;

    local procedure ConvertPriceToVAT(FromPricesInclVAT: Boolean; FromVATProdPostingGr: Code[10]; FromVATBusPostingGr: Code[10]; ToPricesInclVAT: Boolean; ToVATBusPostingGr: Code[10]; ToVATCalcType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax"; ToVATPerCent: Decimal; var UnitPrice: Decimal)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        Text010: label 'Prices including VAT cannot be calculated when %1 is %2.';
    begin
        if FromPricesInclVAT then begin
            VATPostingSetup.Get(FromVATBusPostingGr, FromVATProdPostingGr);

            case VATPostingSetup."VAT Calculation Type" of
                VATPostingSetup."vat calculation type"::"Reverse Charge VAT":
                    VATPostingSetup."VAT %" := 0;
                VATPostingSetup."vat calculation type"::"Sales Tax":
                    Error(
                      Text010,
                      VATPostingSetup.FieldCaption("VAT Calculation Type"),
                      VATPostingSetup."VAT Calculation Type");
            end;

            case ToVATCalcType of
                Tovatcalctype::"Normal VAT",
                Tovatcalctype::"Full VAT",
                Tovatcalctype::"Sales Tax":
                    begin
                        if ToPricesInclVAT then begin
                            if ToVATBusPostingGr <> FromVATBusPostingGr then
                                UnitPrice := UnitPrice * (100 + ToVATPerCent) / (100 + VATPostingSetup."VAT %");
                        end else
                            UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
                    end;
                Tovatcalctype::"Reverse Charge VAT":
                    UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
            end;
        end else
            if ToPricesInclVAT then
                UnitPrice := UnitPrice * (1 + ToVATPerCent / 100);
    end;

    local procedure ConvertPriceLCYToFCY(RentHeader1: Record "Rent Header"; CurrencyCode: Code[10]; var UnitPrice: Decimal)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if RentHeader1."Currency Code" <> '' then begin
            if Currency.Get(RentHeader1."Currency Code") then;
            if CurrencyCode = '' then
                UnitPrice :=
                  CurrExchRate.ExchangeAmtLCYToFCY(RentHeaderExchDate(RentHeader1), Currency.Code, UnitPrice, RentHeader1."Currency Factor");
            UnitPrice := ROUND(UnitPrice, Currency."Unit-Amount Rounding Precision");
        end else
            UnitPrice := ROUND(UnitPrice, GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure RentHeaderExchDate(RentHeader1: Record "Rent Header"): Date
    begin
        if (RentHeader1."Document Type" in [RentHeader1."document type"::Quote]) and
   (RentHeader1."Posting Date" = 0D)
then
            exit(WorkDate);
        exit(RentHeader1."Posting Date");
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
         DimMgt.EditDimensionSet(
           "Dimension Set ID", StrSubstNo('%1 %2', "Document Type", "Document No."),
           "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
        end;
    end;


    procedure CallCreateDim()
    begin
        CreateDim(
            Database::"Rent Item", "Rent Item No.",
            Database::Vehicle, "Vehicle Serial No.",
            Database::Location, "Location Code"
        );
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        RentHeader: Record "Rent Header";
        NewDimSetID: Integer;
        Dimsource: List of [Dictionary of [Integer, code[20]]];
    begin
        SourceCodeSetup.Get;
        /*TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;*/

        RentHeader.Get("Document Type", "Document No.");

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Type1, No1);
        DimMgt.AddDimSource(Dimsource, Type2, No2);
        DimMgt.AddDimSource(Dimsource, Type3, No3);

        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, Dimsource, SourceCodeSetup."Rent Management",
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", RentHeader."Dimension Set ID", DATABASE::Customer);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Line", intFieldNo));
    end;

    local procedure UpdateLineDiscount()
    begin
        GetRentHeader;
        PriceCalcMgt.FindRentItemDisc(RentHeader, Rec);
        Validate("Line Discount %");
    end;


    procedure CreateNewPriceLine()
    var
        NewRentLine: Record "Rent Line";
        RentHeader: Record "Rent Header";
    begin
        if Locked then //or ("Locks Line" <> 0)
            Exit;

        if not ((Status = Status::Rented) or (Status = Status::"In Service") or ("Root Lock Line" <> 0)) then
            Exit;

        if "Quantity Invoiced" = 0 then
            Exit;

        RentHeader.get("Document Type", "Document No.");
        RentPeriod.Get("Rent Period Type");
        RentSetup.Get;

        NewRentLine.Init();
        NewRentLine.TransferFields(Rec);
        NewRentLine."Line No." := "Line No." + 10;

        NewRentLine."Locks Line" := "Line No.";
        if RentHeader."Rent Type" = RentHeader."Rent Type"::"Open End Date" then begin
            //"Rent End Date" := "Rent Start Date" + (Quantity * (CalcDate(RentPeriod.Duration, Today) - Today));            
            //"Rent End Date" := "Rent Start Date" + ROUND((Quantity * CalculatePeriod("Rent Start Date", RentPeriod.Duration, '+')), 1, '=');
            if "Last Date Invoiced" = 0D then
                Exit;
            "Rent End Date" := "Last Date Invoiced";
        end;

        NewRentLine."Quantity Invoiced" := 0;
        NewRentLine.Validate(Quantity);
        NewRentLine.Status := NewRentLine.Status::" ";
        if "Root Lock Line" <> 0 then
            NewRentLine."Root Lock Line" := "Root Lock Line"
        else
            NewRentLine."Root Lock Line" := "Line No.";
        NewRentLine.Insert(true);

        if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Standard Period" then
            NewRentLine."Rent Start Date" := "Rent End Date"
        else
            NewRentLine."Rent Start Date" := CalcDate('<+1D>', "Rent End Date");
        NewRentLine.Modify(true);

        Locked := true;
        Modify(false);
    end;



    procedure CreateExtraChargeLines(CalculateOnDate: Date)
    var
        ActualDays: Integer;
        OrderDays: Decimal;
        RentPeriod: Record "Rent Period";
        ExtraDays: Decimal;
        TempRentItemSalesPrice: Record "Rent Item Sales Price" temporary;
        DaysInPeriod: Integer;
        ExtraRentPeriod: Record "Rent Period";
        ExtraPeriods: Integer;
        ExtraRun: Decimal;
        //RentLinePeriod: Record "Rent Line";
        RentLineVFR: Record "Rent Line";
        VFR1Qty, VFR2Qty, VFR3Qty : Decimal;
        RentAsset: Record "Rent Asset";
        MapViewTelematics: Record "Vehicle Telematics";
    begin
        CalcFields("Sell-to Customer No.", "Actual Shipment Date", "Actual Return Date", "Quantity Shipped", "Quantity Returned");
        RentHeader.Get("Document Type", "Document No.");
        if RentHeader."Overtime Calculation" = RentHeader."Overtime Calculation"::"Current Period" then
            Error(OvertimeCalcTypeErr);
        if "Actual Return Date" = 0D then
            Error(ActualReturnDateErr);
        if CheckHasExtraChargeLine() then
            error(RentLineHasExtrChargeErr, "Line No.", "Rent Item No.");

        //RentLinePeriod.Reset();
        //RentLinePeriod.SetRange("Document Type", "Document Type");
        //RentLinePeriod.SetRange("Document No.", "Document No.");
        //if RentLinePeriod.FindLast() then begin
        //    with RentLinePeriod do begin
        RentSetup.Get;
        RentPeriod.Get("Rent Period Type");
        RentItem.Get("Rent Item No.");
        RentItem.TestField("Extra Charge Resource No.");

        if RentHeader."Overtime Calculation" = RentHeader."Overtime Calculation"::"Total Period" then begin

            //ActualDays := "Actual Return Date" - "Actual Shipment Date";
            //OrderDays := Quantity * CalculatePeriod(CalculateOnDate, RentPeriod.Duration, '-');
            //ExtraDays := ActualDays - OrderDays;

            PriceCalcMgt.FindSalesPrice(
                TempRentItemSalesPrice, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
                RentHeader."Customer Price Group", '', "Rent Item No.", "Rent Period Type", RentHeader."Currency Code",
                RentHeader."Document Date", false);

            CalcFields("Actual Return Date", "Actual Shipment Date");
            if ("Actual Return Date" <> 0D) and ("Actual Shipment Date" <> 0D) then begin
                ActualDays := "Actual Return Date" - "Actual Shipment Date";
                //OrderDays := Quantity * (CalcDate(RentPeriod.Duration, "Rent Start Date") - "Rent Start Date");
                OrderDays := Quantity * CalculatePeriod("Actual Return Date", RentPeriod.Duration, '-');
                ExtraDays := ActualDays - OrderDays;
                if ExtraDays > 0 then begin
                    if TempRentItemSalesPrice.FindFirst then begin
                        if (TempRentItemSalesPrice."Extra Period Price" > 0) and (TempRentItemSalesPrice."Extra Period Code" <> '') then begin
                            ExtraRentPeriod.Get(TempRentItemSalesPrice."Extra Period Code");
                            //DaysInPeriod := CalcDate(ExtraRentPeriod.Duration, Today) - Today;
                            DaysInPeriod := CalculatePeriod(CalculateOnDate, RentPeriod.Duration, '-');
                            ExtraPeriods := 0;
                            if DaysInPeriod <> 0 then
                                ExtraPeriods := ROUND(ExtraDays / DaysInPeriod, 1, '>');
                            if ExtraPeriods > 0 then begin
                                InsertRentSalesLine(RentSalesLine, RentItem."Extra Charge Resource No.", ExtraRentPeriod."Unit of Measure Code", ExtraPeriods, TempRentItemSalesPrice."Extra Period Price", RentHeader."Location Code");
                            end;
                        end;
                    end;
                end;
            end;

            if TempRentItemSalesPrice.FindFirst then;

            //RentLineVFR.Reset();
            //RentLineVFR.SetRange("Document Type", "Document Type");
            //RentLineVFR.SetRange("Document No.", "Document No.");
            //if RentLineVFR.FindFirst() then
            //repeat
            //    VFR1Qty += RentLineVFR."VF Run 1 To" - RentLineVFR."VF Run 1 From";
            //    VFR2Qty += RentLineVFR."VF Run 2 To" - RentLineVFR."VF Run 2 From";
            //    VFR3Qty += RentLineVFR."VF Run 3 To" - RentLineVFR."VF Run 3 From";
            //until RentLineVFR.Next = 0;
            VFR1Qty += "VF Run 1 To" - "VF Run 1 From";
            VFR2Qty += "VF Run 2 To" - "VF Run 2 From";
            VFR3Qty += "VF Run 3 To" - "VF Run 3 From";

            ExtraRun := VFR1Qty - RentPeriod."Variable Field Run 1" * "Quantity Invoiced";
            if ExtraRun > 0 then begin
                InsertRentSalesLine(RentSalesLine, RentItem."Extra Charge Resource No.", RentSetup."Variable Field Run 1", ExtraRun, TempRentItemSalesPrice."Variable Field Run 1", RentHeader."Location Code");
            end;
            ExtraRun := VFR2Qty - RentPeriod."Variable Field Run 2" * "Quantity Invoiced";
            if ExtraRun > 0 then begin
                InsertRentSalesLine(RentSalesLine, RentItem."Extra Charge Resource No.", RentSetup."Variable Field Run 2", ExtraRun, TempRentItemSalesPrice."Variable Field Run 2", RentHeader."Location Code");
            end;
            ExtraRun := VFR3Qty - RentPeriod."Variable Field Run 3" * "Quantity Invoiced";
            if ExtraRun > 0 then begin
                InsertRentSalesLine(RentSalesLine, RentItem."Extra Charge Resource No.", RentSetup."Variable Field Run 3", ExtraRun, TempRentItemSalesPrice."Variable Field Run 3", RentHeader."Location Code");
            end;
        end;
        //end;
        //end;
    end;


    procedure CreateExtraChargeLinesWorksheetTotalPeriod(RentWkshEntryNo: Integer; CalculateOnDate: Date): Integer
    var
        ActualDays: Integer;
        OrderDays: Decimal;
        RentPeriod: Record "Rent Period";
        ExtraDays: Decimal;
        TempRentItemSalesPrice: Record "Rent Item Sales Price" temporary;
        DaysInPeriod: Integer;
        ExtraRentPeriod: Record "Rent Period";
        ExtraPeriods: Integer;
        ExtraRun: Decimal;
        RentLinePeriod: Record "Rent Line";
        RentLineVFR: Record "Rent Line";
        VFR1Qty, VFR2Qty, VFR3Qty : Decimal;
    begin
        CalcFields("Sell-to Customer No.", "Actual Shipment Date", "Actual Return Date", "Quantity Shipped", "Quantity Returned");
        RentHeader.Get("Document Type", "Document No.");
        //if RentHeader."Overtime Calculation" = RentHeader."Overtime Calculation"::"Current Period" then
        //    exit(RentWkshEntryNo);
        if "Actual Return Date" = 0D then
            exit(RentWkshEntryNo);
        if CheckHasExtraChargeLine() then
            exit(RentWkshEntryNo);

        if "Rent Period Type" = '' then
            exit(RentWkshEntryNo);

        if "Rent Item No." = '' then
            exit(RentWkshEntryNo);

        //RentLinePeriod.Reset();
        //RentLinePeriod.SetRange("Document Type", "Document Type");
        //RentLinePeriod.SetRange("Document No.", "Document No.");
        //if RentLinePeriod.FindLast() then begin
        //with RentLinePeriod do begin
        RentSetup.Get;
        RentPeriod.Get("Rent Period Type");
        RentItem.Get("Rent Item No.");
        RentItem.TestField("Extra Charge Resource No.");
        //CalcFields("Actual Return Date", "Actual Shipment Date");
        //ActualDays := "Actual Return Date" - "Actual Shipment Date";
        //OrderDays := Quantity * (CalcDate(RentPeriod.Duration, CalculateOnDate) - CalculateOnDate);
        //OrderDays := Quantity * CalculatePeriod(CalculateOnDate, RentPeriod.Duration, '-');
        //ExtraDays := ActualDays - OrderDays;
        RentSetup.Get;
        RentPeriod.Get("Rent Period Type");
        RentItem.Get("Rent Item No.");
        RentHeader.Get("Document Type", "Document No.");

        PriceCalcMgt.FindSalesPrice(
            TempRentItemSalesPrice, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
            RentHeader."Customer Price Group", '', "Rent Item No.", "Rent Period Type", RentHeader."Currency Code",
            RentHeader."Document Date", false);

        CalcFields("Actual Return Date", "Actual Shipment Date");

        if ("Actual Return Date" <> 0D) and ("Actual Shipment Date" <> 0D) then begin
            ActualDays := "Actual Return Date" - "Actual Shipment Date";
            //OrderDays := Quantity * (CalcDate(RentPeriod.Duration, "Rent Start Date") - "Rent Start Date");
            OrderDays := (Quantity + GetQuantityInvoicedWksht()) * CalculatePeriod(CalculateOnDate, RentPeriod.Duration, '-');
            ExtraDays := ActualDays - OrderDays;
            if ExtraDays > 0 then begin
                if TempRentItemSalesPrice.FindFirst then begin
                    if (TempRentItemSalesPrice."Extra Period Price" > 0) and (TempRentItemSalesPrice."Extra Period Code" <> '') then begin
                        ExtraRentPeriod.Get(TempRentItemSalesPrice."Extra Period Code");
                        //DaysInPeriod := CalcDate(ExtraRentPeriod.Duration, CalculateOnDate) - CalculateOnDate;
                        DaysInPeriod := CalculatePeriod(CalculateOnDate, RentPeriod.Duration, '-');
                        ExtraPeriods := 0;
                        if DaysInPeriod <> 0 then
                            ExtraPeriods := ROUND(ExtraDays / DaysInPeriod, 1, '>');
                        if ExtraPeriods > 0 then begin
                            RentWkshEntryNo := InsertRentWkshtLineTotalPeriod(RentWkshEntryNo, RentItem."Extra Charge Resource No.", ExtraRentPeriod."Unit of Measure Code", ExtraPeriods, TempRentItemSalesPrice."Extra Period Price", RentHeader."Location Code", CalculateOnDate);
                        end;
                    end;
                end;
            end;
        end;

        if TempRentItemSalesPrice.FindFirst then;

        //RentLineVFR.Reset();
        //RentLineVFR.SetRange("Document Type", "Document Type");
        //RentLineVFR.SetRange("Document No.", "Document No.");
        //if RentLineVFR.FindFirst() then
        //repeat
        //    VFR1Qty += RentLineVFR."VF Run 1 To" - RentLineVFR."VF Run 1 From";
        //    VFR2Qty += RentLineVFR."VF Run 2 To" - RentLineVFR."VF Run 2 From";
        //    VFR3Qty += RentLineVFR."VF Run 3 To" - RentLineVFR."VF Run 3 From";
        //until RentLineVFR.Next = 0;

        VFR1Qty += "VF Run 1 To" - "VF Run 1 From";
        VFR2Qty += "VF Run 2 To" - "VF Run 2 From";
        VFR3Qty += "VF Run 3 To" - "VF Run 3 From";

        ExtraRun := VFR1Qty - RentPeriod."Variable Field Run 1" * ("Quantity Invoiced" + GetQuantityInvoicedWksht());
        if ExtraRun > 0 then begin
            RentWkshEntryNo := InsertRentWkshtLineTotalPeriod(RentWkshEntryNo, RentItem."Extra Charge Resource No.", RentSetup."Variable Field Run 1", Round(ExtraRun, 1), TempRentItemSalesPrice."Variable Field Run 1", RentHeader."Location Code", CalculateOnDate);
        end;
        ExtraRun := VFR2Qty - RentPeriod."Variable Field Run 2" * ("Quantity Invoiced" + GetQuantityInvoicedWksht());
        if ExtraRun > 0 then begin
            RentWkshEntryNo := InsertRentWkshtLineTotalPeriod(RentWkshEntryNo, RentItem."Extra Charge Resource No.", RentSetup."Variable Field Run 2", Round(ExtraRun, 1), TempRentItemSalesPrice."Variable Field Run 2", RentHeader."Location Code", CalculateOnDate);
        end;
        ExtraRun := VFR3Qty - RentPeriod."Variable Field Run 3" * ("Quantity Invoiced" + GetQuantityInvoicedWksht());
        if ExtraRun > 0 then begin
            RentWkshEntryNo := InsertRentWkshtLineTotalPeriod(RentWkshEntryNo, RentItem."Extra Charge Resource No.", RentSetup."Variable Field Run 3", Round(ExtraRun, 1), TempRentItemSalesPrice."Variable Field Run 3", RentHeader."Location Code", CalculateOnDate);
        end;

        //end;
        //end;
        exit(RentWkshEntryNo);
    end;

    procedure CreateExtraChargeLinesWorksheetCurrentPeriod(RentWkshEntryNo: Integer; CalculateOnDate: Date; RentWkshtLine: Record "Rent Billing Worksheet Line"): Integer
    var
        ActualDays: Integer;
        OrderDays: Decimal;
        RentPeriod: Record "Rent Period";
        ExtraDays: Decimal;
        TempRentItemSalesPrice: Record "Rent Item Sales Price" temporary;
        DaysInPeriod: Integer;
        ExtraRentPeriod: Record "Rent Period";
        ExtraPeriods: Integer;
        VFR1Qty, VFR2Qty, VFR3Qty : Decimal;
        ExtraRun: Decimal;
    begin

        RentHeader.Get(RentWkshtLine."Document Type", RentWkshtLine."Document No.");

        if RentHeader."Overtime Calculation" = RentHeader."Overtime Calculation"::"Total Period" then
            if CheckHasExtraChargeLine() then
                exit(RentWkshEntryNo);


        RentSetup.Get;
        RentPeriod.Get(RentWkshtLine."Rent Period Type");
        RentItem.Get(RentWkshtLine."Rent Item No.");
        RentItem.TestField("Extra Charge Resource No.");

        PriceCalcMgt.FindSalesPrice(
            TempRentItemSalesPrice, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
            RentHeader."Customer Price Group", '', RentWkshtLine."Rent Item No.", RentWkshtLine."Rent Period Type", RentHeader."Currency Code",
            RentHeader."Document Date", false);

        if TempRentItemSalesPrice.FindFirst then;
        VFR1Qty += RentWkshtLine."VF Run 1 To" - RentWkshtLine."VF Run 1 From";
        VFR2Qty += RentWkshtLine."VF Run 2 To" - RentWkshtLine."VF Run 2 From";
        VFR3Qty += RentWkshtLine."VF Run 3 To" - RentWkshtLine."VF Run 3 From";
        ExtraRun := VFR1Qty - RentPeriod."Variable Field Run 1" * RentWkshtLine.Quantity;
        if (ExtraRun > 0) and (RentWkshtLine."VF Run 1 To" > 0) and (RentWkshtLine."VF Run 1 From" > 0) then begin
            RentWkshEntryNo := InsertRentWkshtLineCurrentPeriod(RentWkshEntryNo, RentItem."Extra Charge Resource No.", RentSetup."Variable Field Run 1", Round(ExtraRun, 1), TempRentItemSalesPrice."Variable Field Run 1", RentHeader."Location Code", CalculateOnDate, RentWkshtLine);
        end;
        ExtraRun := VFR2Qty - RentPeriod."Variable Field Run 2" * RentWkshtLine.Quantity;
        if (ExtraRun > 0) and (RentWkshtLine."VF Run 2 To" > 0) and (RentWkshtLine."VF Run 2 From" > 0) then begin
            RentWkshEntryNo := InsertRentWkshtLineCurrentPeriod(RentWkshEntryNo, RentItem."Extra Charge Resource No.", RentSetup."Variable Field Run 2", Round(ExtraRun, 1), TempRentItemSalesPrice."Variable Field Run 2", RentHeader."Location Code", CalculateOnDate, RentWkshtLine);
        end;
        ExtraRun := VFR3Qty - RentPeriod."Variable Field Run 3" * RentWkshtLine.Quantity;
        if (ExtraRun > 0) and (RentWkshtLine."VF Run 3 To" > 0) and (RentWkshtLine."VF Run 3 From" > 0) then begin
            RentWkshEntryNo := InsertRentWkshtLineCurrentPeriod(RentWkshEntryNo, RentItem."Extra Charge Resource No.", RentSetup."Variable Field Run 3", Round(ExtraRun, 1), TempRentItemSalesPrice."Variable Field Run 3", RentHeader."Location Code", CalculateOnDate, RentWkshtLine);
        end;

        exit(RentWkshEntryNo);
    end;

    local procedure InsertRentWkshtLineTotalPeriod(RentWkshEntryNo: Integer; ResourceNo: Code[20]; UOMCode: Code[10]; Quantity: Decimal; UnitPrice: Decimal; LocationCode: Code[10]; CalcPeriodEnd: Date): Integer
    var
        RentSalesLineNo: Integer;
        RentWkshtLineToInsert: Record "Rent Billing Worksheet Line";
        Customer: Record Customer;
    begin
        RentHeader.Get("Document Type", "Document No.");
        RentWkshtLineToInsert.Init;
        RentWkshtLineToInsert.TransferFields(Rec);

        //RentWkshtLineToInsert."Line No." := RentWkshEntryNo;
        RentWkshtLineToInsert.Validate(Type, RentWkshtLineToInsert.Type::Resource);
        RentWkshtLineToInsert.Validate("No.", ResourceNo);

        RentWkshtLineToInsert."Entry No." := RentWkshEntryNo;
        //RentWkshtLineToInsert."Attached to Rent Line No." := "Line No.";
        RentWkshtLineToInsert.Validate(Quantity, Quantity);
        RentWkshtLineToInsert.Validate("Unit Price", UnitPrice);
        RentWkshtLineToInsert."Unit of Measure Code" := UOMCode;
        RentWkshtLineToInsert."To Invoice" := true;
        RentWkshtLineToInsert."Process Line" := true;
        RentWkshtLineToInsert."Location Code" := LocationCode;
        //RentWkshtLineToInsert."Extra Charge Line" := true;
        RentWkshtLineToInsert."Sell-to Customer No." := "Sell-to Customer No.";
        RentWkshtLineToInsert."Bill-to Customer No." := RentHeader."Bill-to Customer No.";
        if Customer.get("Sell-to Customer No.") then
            RentWkshtLineToInsert."Sell-to Customer Name" := Customer.Name;
        if Customer.get(RentHeader."Bill-to Customer No.") then
            RentWkshtLineToInsert."Bill-to Customer Name" := Customer.Name;
        RentWkshtLineToInsert."Extra Charge Line" := true;
        RentWkshtLineToInsert."Period Ending Date" := CalcPeriodEnd;
        RentWkshtLineToInsert."Line Amount" := RentWkshtLineToInsert.Quantity * RentWkshtLineToInsert."Unit Price";
        RentWkshtLineToInsert.Insert(true);
        RentWkshEntryNo += 1;
        exit(RentWkshEntryNo);
    end;

    local procedure InsertRentWkshtLineCurrentPeriod(RentWkshEntryNo: Integer; ResourceNo: Code[20]; UOMCode: Code[10]; Quantity: Decimal; UnitPrice: Decimal; LocationCode: Code[10]; CalcPeriodEnd: Date; RentWkshtLine: Record "Rent Billing Worksheet Line"): Integer
    var
        RentSalesLineNo: Integer;
        RentWkshtLineToInsert: Record "Rent Billing Worksheet Line";
        Customer: Record Customer;
    begin
        RentHeader.Get("Document Type", "Document No.");
        RentWkshtLineToInsert.Init;
        RentWkshtLineToInsert.TransferFields(RentWkshtLine);

        //RentWkshtLineToInsert."Line No." := RentWkshEntryNo;
        RentWkshtLineToInsert.Validate(Type, RentWkshtLineToInsert.Type::Resource);
        RentWkshtLineToInsert.Validate("No.", ResourceNo);

        RentWkshtLineToInsert."Entry No." := RentWkshEntryNo;
        //RentWkshtLineToInsert."Attached to Rent Line No." := "Line No.";
        RentWkshtLineToInsert.Validate(Quantity, ROUND(Quantity, 1));
        RentWkshtLineToInsert.Validate("Unit Price", UnitPrice);
        RentWkshtLineToInsert."Unit of Measure Code" := UOMCode;
        RentWkshtLineToInsert."To Invoice" := true;
        RentWkshtLineToInsert."Process Line" := true;
        RentWkshtLineToInsert."Location Code" := LocationCode;
        //RentWkshtLineToInsert."Extra Charge Line" := true;
        RentWkshtLineToInsert."Sell-to Customer No." := "Sell-to Customer No.";
        RentWkshtLineToInsert."Bill-to Customer No." := RentHeader."Bill-to Customer No.";
        if Customer.get("Sell-to Customer No.") then
            RentWkshtLineToInsert."Sell-to Customer Name" := Customer.Name;
        if Customer.get(RentHeader."Bill-to Customer No.") then
            RentWkshtLineToInsert."Bill-to Customer Name" := Customer.Name;
        RentWkshtLineToInsert."Extra Charge Line" := true;
        RentWkshtLineToInsert."Period Ending Date" := CalcPeriodEnd;
        RentWkshtLineToInsert."Line Amount" := RentWkshtLineToInsert.Quantity * RentWkshtLineToInsert."Unit Price";
        RentWkshtLineToInsert.Insert(true);
        RentWkshEntryNo += 1;
        exit(RentWkshEntryNo);
    end;

    local procedure InsertRentSalesLine(var RentSalesLineToInsert: Record "Rent Sales Line"; ResourceNo: Code[20]; UOMCode: Code[10]; Quantity: Decimal; UnitPrice: Decimal; LocationCode: Code[10])
    var
        RentSalesLineNo: Integer;
        Resource: Record Resource;
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
        //RentSalesLineToInsert.Description := Description; //Overwrite Description
        RentSalesLineToInsert."Attached to Rent Line No." := "Line No.";
        RentSalesLineToInsert.Validate(Quantity, ROUND(Quantity, 1));
        RentSalesLineToInsert.Validate("Unit Price", UnitPrice);
        RentSalesLineToInsert.Validate("Line Discount %", "Line Discount %");
        RentSalesLineToInsert."Unit of Measure Code" := UOMCode;
        RentSalesLineToInsert."To Invoice" := true;
        RentSalesLineToInsert."Location Code" := LocationCode;
        RentSalesLineToInsert."Rent Item No." := "Rent Item No.";
        RentSalesLineToInsert."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        RentSalesLineToInsert."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        RentSalesLineToInsert."Extra Charge Line" := true;
        RentSalesLineToInsert.Insert(true);
    end;

    local procedure UpdateRentSalesLineVFRun(var RentSalesLineVFRun: Record "Rent Sales Line"; RentLineFrom: Record "Rent Line")
    var
        RentSalesLineToCheck: Record "Rent Sales Line";
    begin
        RentSalesLineToCheck.Reset;
        RentSalesLineToCheck.SetRange("Document Type", RentLineFrom."Document Type");
        RentSalesLineToCheck.SetRange("Document No.", RentLineFrom."Document No.");
        RentSalesLineToCheck.SetRange("Attached to Rent Line No.", RentLineFrom."Line No.");
        RentSalesLineToCheck.SetFilter("Line No.", '<>%1', RentSalesLineVFRun."Line No.");
        RentSalesLineToCheck.SetFilter("VF Run 1 To", '>%1', 0);
        if RentSalesLineToCheck.FindLast() then begin
            RentSalesLineVFRun."VF Run 1 From" := RentSalesLineToCheck."VF Run 1 To";
        end else begin
            RentSalesLineVFRun."VF Run 1 From" := RentLineFrom."VF Run 1 From";
        end;

        RentSalesLineToCheck.Reset;
        RentSalesLineToCheck.SetRange("Document Type", RentLineFrom."Document Type");
        RentSalesLineToCheck.SetRange("Document No.", RentLineFrom."Document No.");
        RentSalesLineToCheck.SetRange("Attached to Rent Line No.", RentLineFrom."Line No.");
        RentSalesLineToCheck.SetFilter("Line No.", '<>%1', RentSalesLineVFRun."Line No.");
        RentSalesLineToCheck.SetFilter("VF Run 2 To", '>%1', 0);
        if RentSalesLineToCheck.FindLast() then begin
            RentSalesLineVFRun."VF Run 2 From" := RentSalesLineToCheck."VF Run 2 To";
        end else begin
            RentSalesLineVFRun."VF Run 2 From" := RentLineFrom."VF Run 2 From";
        end;

        RentSalesLineToCheck.Reset;
        RentSalesLineToCheck.SetRange("Document Type", RentLineFrom."Document Type");
        RentSalesLineToCheck.SetRange("Document No.", RentLineFrom."Document No.");
        RentSalesLineToCheck.SetRange("Attached to Rent Line No.", RentLineFrom."Line No.");
        RentSalesLineToCheck.SetFilter("Line No.", '<>%1', RentSalesLineVFRun."Line No.");
        RentSalesLineToCheck.SetFilter("VF Run 3 To", '>%1', 0);
        if RentSalesLineToCheck.FindLast() then begin
            RentSalesLineVFRun."VF Run 3 From" := RentSalesLineToCheck."VF Run 3 To";
        end else begin
            RentSalesLineVFRun."VF Run 3 From" := RentLineFrom."VF Run 3 From";
        end;


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
        RentSalesLineExtra.SetRange("Attached to Rent Line No.", "Line No.");
        RentSalesLineExtra.SetRange("Extra Charge Line", true);
        if RentSalesLineExtra.FindFirst() then
            EXIT(true)
        else
            exit(false);
    end;

    local procedure UpdateStatus(RentAssetNo: Code[20])
    begin
        if "Rent Asset No." = '' then
            Status := Status::" "
        else begin
            if (Status = Status::" ") and ("Root Lock Line" = 0) then
                Status := Status::Allocated;
        end;
    end;

    local procedure AddRentAssetComponents()
    begin
        If ("Line No." = 0) or ("Rent Asset No." = '') or ("Locks Line" <> 0) then
            exit;
        RentAssetComponent.Reset;
        RentAssetComponent.SetRange("Main Asset No.", "Rent Asset No.");
        if RentAssetComponent.FindFirst then
            repeat
                RentLineComponent.Reset;
                RentLineComponent.SetRange("Document Type", "Document Type");
                RentLineComponent.SetRange("Document No.", "Document No.");
                RentLineComponent.SetRange("Attached to Line No.", "Line No.");
                RentLineComponent.SetRange("Rent Asset No.", RentAssetComponent."Rent Asset No.");
                if not RentLineComponent.FindFirst then begin
                    RentLineComponent.Reset;
                    RentLineComponent.SetRange("Document Type", "Document Type");
                    RentLineComponent.SetRange("Document No.", "Document No.");
                    if RentLineComponent.FindLast then
                        if "Line No." > RentLineComponent."Line No." then
                            LineNo := "Line No." + 10000
                        else
                            LineNo := RentLineComponent."Line No." + 10000
                    else
                        LineNo := "Line No." + 10000;

                    RentLineComponent.Init;
                    RentLineComponent."Line No." := LineNo;
                    RentLineComponent."Component Line" := true;
                    RentLineComponent."Document Type" := "Document Type";
                    RentLineComponent."Document No." := "Document No.";
                    RentLineComponent.Validate("Rent Item No.", "Rent Item No.");
                    RentLineComponent.Validate(Quantity, Quantity);
                    RentLineComponent.Validate("Rent Period Type", "Rent Period Type");
                    RentLineComponent."Rent Asset Quantity" := 1;
                    RentLineComponent.Validate("Rent Asset No.", RentAssetComponent."Rent Asset No.");
                    RentLineComponent.Validate("Unit Price", 0);
                    RentLineComponent."Attached to Line No." := "Line No.";
                    RentLineComponent.VALIDATE("Rent Start Date", "Rent Start Date");
                    RentLineComponent.VALIDATE("Rent End Date", "Rent End Date");
                    RentLineComponent."Location Code" := "Location Code";
                    RentLineComponent.Insert(true);
                end
            until RentAssetComponent.Next = 0;
    end;

    procedure CalculatedStatus(): Integer
    var
        CalculatedStatus: Integer;
        RootRentLine: Record "Rent Line";
    begin
        if "Root Lock Line" = 0 then
            CalculatedStatus := Status
        else begin
            RootRentLine.Get("Document Type", "Document No.", "Root Lock Line");
            CalculatedStatus := RootRentLine.Status;
        end;
        exit(CalculatedStatus);
    end;

    procedure CalculatePeriod(DateTo: Date; DurationFormula: DateFormula; Direction: Code[1]): integer
    var
    begin
        RentSetup.Get();
        if Direction = '+' then
            if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Standard Period" then
                exit(CalcDate('<-1D>', CalcDate(StrSubstNo('+%1', DurationFormula), CALCDATE('<+1D>', DateTo))) - DateTo)
            else
                //exit(CalcDate(StrSubstNo('+%1', DurationFormula), DateTo) - DateTo)
                exit(CalcDate(StrSubstNo('<+1D+%1-1D>', DurationFormula), DateTo) - DateTo)
        else
            if RentSetup."Rent Period Calc. Type" = RentSetup."Rent Period Calc. Type"::"Standard Period" then
                exit(DateTo - CalcDate('<-1D>', CalcDate(StrSubstNo('-%1', DurationFormula), CALCDATE('<+1D>', DateTo))))
            else
                //exit(DateTo - CalcDate(StrSubstNo('-%1', DurationFormula), DateTo));
                exit(DateTo - CalcDate(StrSubstNo('<+1D-%1-1D>', DurationFormula), DateTo));
    end;

    procedure CreateSpecialChargeSalesLine(var RentWkshtLine: Record "Rent Billing Worksheet Line")
    var
        RentSalesLineToInsert: Record "Rent Sales Line";
        RentSalesLineNo: Integer;
        RentHeader: Record "Rent Header";
    begin
        if RentWkshtLine."Document No." = '' then
            exit;

        RentSalesLineToInsert.Reset;
        RentSalesLineToInsert.SetRange("Document Type", RentWkshtLine."Document Type");
        RentSalesLineToInsert.SetRange("Document No.", RentWkshtLine."Document No.");
        if RentSalesLineToInsert.FindLast then
            RentSalesLineNo := RentSalesLineToInsert."Line No." + 10000
        else
            RentSalesLineNo := 10000;

        RentSalesLineToInsert.Init;
        RentSalesLineToInsert."Document Type" := RentWkshtLine."Document Type";
        RentSalesLineToInsert."Document No." := RentWkshtLine."Document No.";
        RentSalesLineToInsert."Line No." := RentSalesLineNo;
        RentSalesLineToInsert.Type := RentWkshtLine.Type;
        RentSalesLineToInsert.Validate("No.", RentWkshtLine."No.");
        RentSalesLineToInsert.Description := RentWkshtLine.Description; //Overwrite Description
        RentSalesLineToInsert.Validate(Quantity, ROUND(RentWkshtLine.Quantity, 1));
        RentSalesLineToInsert.Validate("Unit Price", RentWkshtLine."Unit Price");
        RentSalesLineToInsert.Validate("Line Discount %", RentWkshtLine."Line Discount %");
        RentSalesLineToInsert."Unit of Measure Code" := RentWkshtLine."Unit of Measure Code";
        RentSalesLineToInsert."Location Code" := RentWkshtLine."Location Code";
        RentSalesLineToInsert."Rent Item No." := RentWkshtLine."Rent Item No.";
        RentSalesLineToInsert."Shortcut Dimension 1 Code" := RentWkshtLine."Shortcut Dimension 1 Code";
        RentSalesLineToInsert."Shortcut Dimension 2 Code" := RentWkshtLine."Shortcut Dimension 2 Code";
        RentSalesLineToInsert."Extra Charge Line" := false;
        RentSalesLineToInsert."To Invoice" := true;

        if RentSalesLineToInsert."Location Code" = '' then
            if RentHeader.Get(RentSalesLineToInsert."Document Type", RentSalesLineToInsert."Document No.") then
                RentSalesLineToInsert."Location Code" := RentHeader."Location Code";

        RentSalesLineToInsert.Insert(true);
    end;

    procedure GetQuantityInvoiced(): Decimal
    var
        SalesLineInvQty: Decimal;
    begin

        RentSalesLine.Reset;
        RentSalesLine.SetRange("Document Type", "Document Type");
        RentSalesLine.SetRange("Document No.", "Document No.");
        RentSalesLine.SetRange("Attached to Rent Line No.", "Line No.");
        if RentSalesLine.FindFirst then
            repeat
                SalesLineInvQty += RentSalesLine.Periods;
            until RentSalesLine.Next = 0;

        exit(SalesLineInvQty);
    end;

    procedure GetQuantityInvoicedWksht(): Decimal
    var
        WkshtInvQty: Decimal;
        RentBillWkshLine: Record "Rent Billing Worksheet Line";
    begin
        RentBillWkshLine.Reset;
        RentBillWkshLine.SetRange("Document Type", "Document Type");
        RentBillWkshLine.SetRange("Document No.", "Document No.");
        RentBillWkshLine.SetRange("Line No.", "Line No.");
        RentBillWkshLine.SetRange("Extra Charge Line", false);
        if RentBillWkshLine.FindFirst then
            repeat
                WkshtInvQty += RentBillWkshLine.Periods;
            until RentBillWkshLine.Next = 0;

        exit(WkshtInvQty);
    end;

}

