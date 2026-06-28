Table 25006406 "Warranty Document Line"
{
    // 06.10.2017 EB.AKR Warranty
    //   Added Fields:
    //     51200 Labor Type
    //     51240 Initial Service Order No
    //     52003 Cost Adjustment Factor
    //     52004 Adjusted Amount
    //     52007 Replacement Part Serial No.
    // 
    //   Modified Function:
    //     No. - OnValidate

    Caption = 'Warranty Document Line';
    DrillDownPageID = "Warranty Document Subform";
    LookupPageID = "Warranty Document Subform";

    fields
    {
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Warranty Document Header";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
        }
        field(40; "Service Order Line No."; Integer)
        {
            Caption = 'Service Order Line No.';
        }
        field(50; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";

            trigger OnValidate()
            var
                ServiceHeader: Record "Service Header EDMS";
                recMarkup: Record "Sales/Serv. Item Markup";
                recItemDisc: Record "Sales Line Discount";
                recLabTransl: Record "Service Labor Translation";
                recItemTransl: Record "Item Translation";
            begin
                TestStatusOpen;

                GetWarrantyHeader;
            end;
        }
        field(60; "No."; Code[20])
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

            trigger OnLookup()
            var
                Item: Record Item;
                Labor: Record "Service Labor";
                ExternalService: Record "External Service";
                GLAccount: Record "G/L Account";
                ServiceHeader: Record "Service Header EDMS";
                StandardText: Record "Standard Text";
            begin
                //ServiceHeader.GET("Document Type","Document No.");

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
                            //Labor.SETFILTER("Make Code",'%1|''''',"Make Code");
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
                Markup: Record "Sales/Serv. Item Markup";
                ItemDisc: Record "Sales Line Discount";
                LabTransl: Record "Service Labor Translation";
                ItemTransl: Record "Item Translation";
                VariableFieldUsage: Record "Variable Field Usage";
                NewItemNo: Code[20];
                PrepaymentMgt: Codeunit "Prepayment Mgt.";
                Item: Record Item;
                Labor: Record "Service Labor";
                ExternalService: Record "External Service";
                GLAccount: Record "G/L Account";
                StandardText: Record "Standard Text";
            begin
                //06.10.2017 EB.AKR Warranty >>
                case Type of
                    Type::" ":
                        begin
                            if StandardText.Get("No.") then
                                Description := StandardText.Description;
                        end;
                    Type::"G/L Account":
                        begin
                            if GLAccount.Get("No.") then
                                Description := GLAccount.Description;
                        end;
                    Type::Item:
                        begin
                            if Item.Get("No.") then begin
                                Description := Item.Description;
                            end;
                        end;
                    Type::Labor:
                        begin
                            if Labor.Get("No.") then
                                Description := Labor.Description;
                            "Labor Type" := Labor."Labor Type";
                        end;
                    Type::"External Service":
                        begin
                            if ExternalService.Get("No.") then
                                Description := ExternalService.Description;
                        end;
                end;
                //06.10.2017 EB.AKR Warranty <<
            end;
        }
        field(70; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if "No." = '' then
                    Type := Type::" ";
            end;
        }
        field(80; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                TransferLine: Record "Transfer Line";
            begin
                Amount := Quantity * "Unit Price";
                /*
                TestStatusOpen;
                // 03.04.2014 Elva Baltic P21 >>
                IF (Type = Type::Item) AND (Quantity < xRec.Quantity) AND ItemExists("No.") THEN BEGIN
                  IF (Quantity < CalcTransferedQuantity) THEN
                    ERROR(Text125);
                  CALCFIELDS("Reserved Qty. (Base)");
                  IF (Quantity < "Reserved Qty. (Base)") THEN BEGIN
                    ServiceTransferMgt.FindTransferLine(Rec, TransferLine);
                    ERROR(Text126, TransferLine."Document No.");
                  END;
                END;
                // 03.04.2014 Elva Baltic P21 <<
                
                "Quantity (Base)" := CalcBaseQty(Quantity);
                
                CheckSPackage(FIELDNO(Quantity), 0); //02.01.2008 EDMS P3
                
                IF Type <> Type::" " THEN
                 TESTFIELD("No.");
                
                IF Reserve <> Reserve::Always THEN
                  CheckItemAvailable(FIELDNO(Quantity));
                
                UpdateUnitPrice(FIELDNO(Quantity));
                UpdateAmounts;
                
                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN
                  InitOutstanding;
                
                IF Type = Type::Item THEN BEGIN
                  UpdateUnitPrice(FIELDNO(Quantity));
                  IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN
                    ReserveServiceLine.VerifyQuantity(Rec,xRec);
                END;
                
                UpdateQtyHours(FIELDNO(Quantity));
                */

            end;
        }
        field(90; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                Amount := Quantity * "Unit Price";
                /*
                TestStatusOpen;
                
                CheckSPackage(FIELDNO("Unit Price"), 0); //02.01.2008 EDMS P3
                
                VALIDATE("Line Discount %");
                */

            end;
        }
        field(100; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;

            trigger OnValidate()
            begin
                /*
                TestStatusOpen;
                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                IF "VAT Calculation Type" IN ["VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"Reverse Charge VAT"] THEN
                 "Amount Including VAT" := ROUND(Amount + Amount * "VAT %" / 100,Currency."Amount Rounding Precision");
                */

            end;
        }
        field(110; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;

            trigger OnValidate()
            begin
                /*
                TestStatusOpen;
                
                "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      Amount :=
                        ROUND(
                          "Amount Including VAT" /
                          (1 + (1 - ServiceHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                          Currency."Amount Rounding Precision");
                      "VAT Base Amount" :=
                        ROUND(Amount * (1 - ServiceHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      Amount := 0;
                      "VAT Base Amount" := 0;
                    END;
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      ServiceHeader.TESTFIELD("VAT Base Discount %",0);
                      Amount :=
                        SalesTaxCalculate.ReverseCalculateTax(
                          "Tax Area Code","Tax Group Code","Tax Liable",ServiceHeader."Posting Date",
                          "Amount Including VAT","Quantity (Base)",ServiceHeader."Currency Factor");
                      IF Amount <> 0 THEN
                        "VAT %" :=
                          ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                      ELSE
                        "VAT %" := 0;
                      Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                      "VAT Base Amount" := Amount;
                    END;
                END;
                */

            end;
        }
        field(120; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(130; "Standard Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time (Hours)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                /*
                // 25.02.2015 EDMS P21 >>
                UnitOfMeasure.GET("Unit of Measure Code");
                IF UnitOfMeasure."Minutes Per UoM" = 0 THEN
                  ERROR(STRSUBSTNO(Text127, UnitOfMeasure.FIELDCAPTION("Minutes Per UoM"), FIELDCAPTION("Unit of Measure Code"), "Unit of Measure Code"));
                // 25.02.2015 EDMS P21 <<
                
                VALIDATE(Quantity,"Standard Time");
                //08.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                UpdateUnitPrice(FIELDNO("Standard Time"));
                //08.04.2014 Elva Baltic P1 #RX MMG7.00 <<
                */

            end;
        }
        field(140; "Symptom Code"; Code[20])
        {
            Caption = 'Symptom Code';
            TableRelation = "Symptom Code EDMS".Code where("Make Code" = field("Make Code"));
        }
        field(150; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21
            end;
        }
        field(5000; Closed; Boolean)
        {
            Caption = 'Closed';
            DataClassification = ToBeClassified;
        }
        field(51200; "Labor Type"; Option)
        {
            Caption = 'Labor Type';
            OptionCaption = 'Labor,Travel Time,Travel Distance,Travel Other,Meal Allowance,Other';
            OptionMembers = Labor,"Travel Time","Travel Distance","Travel Other","Meal Allowance",Other;
        }
        field(51240; "Initial Service Order No."; Code[20])
        {
            Caption = 'Initial Service Order No.';
        }
        field(52003; "Cost Adjustment Factor"; Decimal)
        {
            Caption = 'Cost Adjustment Factor';

            trigger OnValidate()
            begin
                "Adjusted Amount" := Amount * "Cost Adjustment Factor";
            end;
        }
        field(52004; "Adjusted Amount"; Decimal)
        {
            Caption = 'Adjusted Amount';
        }
        field(52007; "Replacement Part Serial No."; Code[20])
        {
            Caption = 'Replacement Part Serial No.';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        GetWarrantyHeader;
    end;

    trigger OnInsert()
    begin
        GetWarrantyHeader;
    end;

    trigger OnModify()
    begin
        GetWarrantyHeader;
    end;

    var
        WarrantyHeader: Record "Warranty Document Header";
        Currency: Record Currency;
        LookUpMgt: Codeunit LookUpManagement;
        Text001: label 'It''s allowed to set %1 for Labor lines only!';
        Text002: label 'It''s allowed to set %1 for Item lines only!';
        ModificationNotAllowedErr: label 'Modification not allowed';
        HideValidationDialog: Boolean;

    local procedure GetWarrantyHeader()
    begin
        TestField("Document No.");
        if ("Document No." <> WarrantyHeader."No.") then begin
            WarrantyHeader.Get("Document No.");
            if WarrantyHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                WarrantyHeader.TestField("Currency Factor");
                Currency.Get(WarrantyHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;

    local procedure TestStatusOpen()
    begin
        GetWarrantyHeader;
        if Type <> Type::" " then
            WarrantyHeader.TestField(Status, WarrantyHeader.Status::Open);
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        ServPricesIncVar: Integer;
        ServHeader: Record "Service Header EDMS";
    begin
        if not WarrantyHeader.Get("Document No.") then begin
            WarrantyHeader."No." := '';
            WarrantyHeader.Init;
        end;
        if WarrantyHeader."Prices Including VAT" then
            ServPricesIncVar := 1
        else
            ServPricesIncVar := 0;
        Clear(WarrantyHeader);
        exit('2,' + Format(ServPricesIncVar) + ',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        Field.Get(Database::"Warranty Document Line", FieldNumber);
        exit(Field."Field Caption");
    end;
}

