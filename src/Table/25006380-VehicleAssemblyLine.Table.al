//Table 25006380 "Vehicle Assembly Line"
Table 25006270 "Vehicle Assembly Line"
{
    // 13.05.2016 EB.P7 #EQI_25
    //   Confirm added to insert linked options
    // 
    // 11.04.2013 EDMS P8
    //   * Renamed field 'Manuf. Option Type' to 'Option Subtype'

    Caption = 'Vehicle Assembly Line';
    LookupPageID = "Vehicle Assembly Worksheet";

    fields
    {
        field(5; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            Editable = false;
        }
        field(10; "Assembly ID"; Code[20])
        {
            Caption = 'Assembly ID';
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Manufacturer Option,Own Option,Vehicle Base,Item,Comment';
            OptionMembers = "Manufacturer Option","Own Option","Vehicle Base","Item","Comment";

            trigger OnValidate()
            var
                ModelVersion: Record Item;
            begin
                if ("Option Type" = "option type"::"Own Option") and ("Option Subtype" <> "option subtype"::Option) then
                    Error(Text005, Format("option type"::"Own Option"), Format("option subtype"::Option));

                if "Option Type" <> xRec."Option Type" then begin
                    TestField("Option Code", '');
                end;

                if "Option Type" = "option type"::"Vehicle Base" then
                    if ModelVersion.Get("Model Version No.") then begin
                        Description := ModelVersion.Description + ModelVersion."Description 2";
                        "Description 2" := '';
                    end;

                UpdateSalesPrice(FieldNo("Option Type"));
                UpdatePurchasePrice(FieldNo("Option Type"));
            end;
        }
        field(60; "Option Code"; Code[50])
        {
            Caption = 'Option Code';

            trigger OnLookup()
            var
                OwnOptions: Page "Own Options";
                ManOptions: Page "Manufacturer Options";
                Items: Page "Item List";
                StandardTexts: Page "Standard Text Codes";
            begin
                case "Option Type" of
                    "option type"::"Vehicle Base":
                        ;
                    "option type"::"Manufacturer Option":
                        begin
                            ManOption.Reset;
                            ManOption.SetRange("Make Code", "Make Code");
                            ManOption.SetRange("Model Code", "Model Code");
                            ManOption.SetRange("Model Version No.", "Model Version No.");
                            ManOption.SetRange(Type, "Option Subtype");
                            Clear(ManOptions);
                            ManOptions.SetTableview(ManOption);
                            if "Option Code" <> '' then begin
                                ManOption.SetRange("Option Code", "Option Code");
                                if ManOption.FindSet then;
                                ManOption.SetRange("Option Code");
                                ManOptions.SetRecord(ManOption);
                            end;
                            ManOptions.LookupMode(true);
                            if ManOptions.RunModal = Action::LookupOK then begin
                                ManOptions.GetRecord(ManOption);
                                Validate("Option Code", ManOption."Option Code");
                            end;
                        end;
                    "option type"::"Own Option":
                        begin
                            OwnOption.Reset;
                            OwnOption.SetRange("Make Code", "Make Code");
                            OwnOption.SetRange("Model Code", "Model Code");
                            Clear(OwnOptions);
                            OwnOptions.SetTableview(OwnOption);
                            OwnOptions.LookupMode(true);
                            if OwnOptions.RunModal = Action::LookupOK then begin
                                OwnOptions.GetRecord(OwnOption);
                                Validate("Option Code", OwnOption."Option Code");
                            end;
                        end;
                    "Option Type"::Item:
                        begin
                            Item.Reset;
                            Item.SetRange("Item Type", Item."Item Type"::Item);
                            Clear(Items);
                            Items.SetTableview(Item);
                            Items.LookupMode(true);
                            if Items.RunModal = Action::LookupOK then begin
                                Items.GetRecord(Item);
                                Validate("Option Code", Item."No.");
                            end;
                        end;
                    "Option Type"::Comment:
                        begin

                        end;
                end;
            end;

            trigger OnValidate()
            var
                ManufacturerOptionCondition: Record "Manufacturer Option Condition";
                VehicleAssemblyLine: Record "Vehicle Assembly Line";
                ComesWith: Text[250];
                CRLF: Text[2];
                ManufacturerOptionConditionTmp: Record "Manufacturer Option Condition" temporary;
                LineNo: Integer;
            begin
                CRLF := ' ';
                CRLF[1] := 13;
                CRLF[2] := 10;

                TempVehicleAssembly := Rec;
                Init;

                "Make Code" := TempVehicleAssembly."Make Code";
                "Model Code" := TempVehicleAssembly."Model Code";
                "Model Version No." := TempVehicleAssembly."Model Version No.";
                "Option Type" := TempVehicleAssembly."Option Type";
                "Option Subtype" := TempVehicleAssembly."Option Subtype";
                "Option Code" := TempVehicleAssembly."Option Code";
                OnBeforeCopyOptionType(Rec, TempVehicleAssembly);
                case "Option Type" of
                    "option type"::"Manufacturer Option":
                        begin
                            ManOption.Reset;
                            if ManOption.Get("Make Code", "Model Code", "Model Version No.", "Option Subtype", "Option Code") then begin
                                Validate(Description, ManOption.Description);
                                Validate("Description 2", ManOption."Description 2");
                                Validate("Option Subtype", ManOption.Type);
                                Validate(Standard, ManOption.Standard);
                            end;
                        end;
                    "option type"::"Own Option":
                        begin
                            OwnOption.Reset;
                            if OwnOption.Get("Make Code", "Model Code", "Option Code") then begin
                                Validate(Description, OwnOption.Description);
                                Validate("Description 2", OwnOption."Description 2");
                            end;
                        end;
                    "option type"::Item:
                        begin
                            Item.Reset;
                            If StrLen("Option Code") > MaxStrLen(Item."No.") then
                                Error(Text007, MaxStrLen(Item."No."));
                            if Item.Get("Option Code") then begin
                                Validate(Description, Item.Description);
                                Validate("Description 2", Item."Description 2");
                            end;
                        end;
                end;

                Validate(Posted, IsPosted(Rec));

                if "Option Type" <> "Option Type"::Comment then begin
                    UpdateSalesPrice(FieldNo("Option Code"));
                    UpdatePurchasePrice(FieldNo("Option Code"));

                    if "Sales Price" = 0 then
                        "Sales Price" := ManOption.GetCurrentPrice;
                end;

                if "Option Type" = "option type"::"Manufacturer Option" then begin
                    ComesWith := '';
                    VehicleAssemblyLine.Reset;
                    VehicleAssemblyLine.SetRange("Serial No.", "Serial No.");
                    VehicleAssemblyLine.SetRange("Assembly ID", "Assembly ID");
                    VehicleAssemblyLine.SetRange("Option Type", VehicleAssemblyLine."option type"::"Manufacturer Option");
                    VehicleAssemblyLine.SetRange("Option Subtype", "Option Subtype");

                    ManufacturerOptionCondition.Reset;
                    ManufacturerOptionCondition.SetRange("Make Code", "Make Code");
                    ManufacturerOptionCondition.SetRange("Model Code", "Model Code");
                    ManufacturerOptionCondition.SetRange("Model Version No.", "Model Version No.");
                    ManufacturerOptionCondition.SetRange("Option Type", "Option Subtype");
                    ManufacturerOptionCondition.SetRange("Option Code", "Option Code");
                    if ManufacturerOptionCondition.FindFirst then
                        repeat
                            VehicleAssemblyLine.SetRange("Option Code", ManufacturerOptionCondition."Condition Option Code");
                            case ManufacturerOptionCondition."Condition Type" of
                                ManufacturerOptionCondition."condition type"::"Only with":
                                    begin
                                        if not VehicleAssemblyLine.FindFirst then begin
                                            if ComesWith <> '' then
                                                ComesWith := ComesWith + CRLF;
                                            ManufacturerOptionCondition.CalcFields("Condition Option Description");
                                            ComesWith := ComesWith + ManufacturerOptionCondition."Condition Option Code" + ' - ' + ManufacturerOptionCondition."Condition Option Description";
                                            ManufacturerOptionConditionTmp.Init;
                                            ManufacturerOptionConditionTmp := ManufacturerOptionCondition;
                                            ManufacturerOptionConditionTmp.Insert;
                                        end;
                                    end;
                                ManufacturerOptionCondition."condition type"::"Not with":
                                    begin
                                        if VehicleAssemblyLine.FindFirst then
                                            Message(StrSubstNo(Text002, "Option Code", ManufacturerOptionCondition."Condition Option Code"));
                                    end;
                            end;
                        until ManufacturerOptionCondition.Next = 0;
                    if ComesWith <> '' then
                        if Dialog.Confirm(Text006, false, "Option Code", CRLF + ComesWith) then begin
                            ManufacturerOptionConditionTmp.Reset;
                            if ManufacturerOptionConditionTmp.FindFirst then begin
                                VehicleAssemblyLine.Reset;
                                VehicleAssemblyLine.SetRange("Serial No.", "Serial No.");
                                VehicleAssemblyLine.SetRange("Assembly ID", "Assembly ID");
                                VehicleAssemblyLine.FindLast;
                                LineNo := VehicleAssemblyLine."Line No.";
                                repeat
                                    LineNo += 10000;
                                    VehicleAssemblyLine.Init;
                                    VehicleAssemblyLine."Line No." := LineNo;
                                    VehicleAssemblyLine.Validate("Serial No.", "Serial No.");
                                    VehicleAssemblyLine.Validate("Assembly ID", "Assembly ID");
                                    VehicleAssemblyLine.Validate("Option Type", "Option Type");
                                    VehicleAssemblyLine.Validate("Option Code", ManufacturerOptionConditionTmp."Condition Option Code");
                                    VehicleAssemblyLine."Make Code" := "Make Code";
                                    VehicleAssemblyLine."Model Code" := "Model Code";
                                    VehicleAssemblyLine."Model Version No." := "Model Version No.";
                                    ManufacturerOptionConditionTmp.CalcFields("Condition Option Description");
                                    VehicleAssemblyLine."External Code" := ManufacturerOptionConditionTmp."Option External Code";


                                    ManOption.Reset;
                                    if ManOption.Get("Make Code", "Model Code", "Model Version No.",
                                      ManufacturerOptionConditionTmp."Condition Option Type", ManufacturerOptionConditionTmp."Condition Option Code") then begin
                                        VehicleAssemblyLine.Validate(Description, ManOption.Description);
                                        VehicleAssemblyLine.Validate("Description 2", ManOption."Description 2");
                                        VehicleAssemblyLine.Validate("Option Subtype", ManOption.Type);
                                        VehicleAssemblyLine.Validate(Standard, ManOption.Standard);
                                    end;

                                    VehicleAssemblyLine.UpdateSalesPrice(FieldNo("Option Code"));
                                    VehicleAssemblyLine.UpdatePurchasePrice(FieldNo("Option Code"));

                                    if VehicleAssemblyLine."Sales Price" = 0 then
                                        VehicleAssemblyLine."Sales Price" := ManOption.GetCurrentPrice;

                                    VehicleAssemblyLine.Insert;
                                until ManufacturerOptionConditionTmp.Next = 0;

                            end;
                        end;
                end;
            end;
        }
        field(70; "External Code"; Code[50])
        {
            CalcFormula = lookup("Manufacturer Option"."External Code" where("Make Code" = field("Make Code"),
                                                                              "Model Code" = field("Model Code"),
                                                                              "Model Version No." = field("Model Version No."),
                                                                              "Option Code" = field("Option Code")));
            Caption = 'External Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(90; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(95; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Editable = false;

            trigger OnLookup()
            var
                Item: Record Item;
            begin
                Item.SetCurrentkey("Item Type", "Make Code", "Model Code");
                Item.SetRange("Item Type", Item."item type"::"Model Version");
                Item.SetRange("Make Code", "Make Code");
                Item.SetRange("Model Code", "Model Code");
                if Page.RunModal(Page::"Item List", Item) = Action::LookupOK then //30.10.2012 EDMS
                    "Model Code" := Item."No.";
            end;
        }
        field(97; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount (LCY)';
        }
        field(100; "Sales Price"; Decimal)
        {
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Sales Price"));
            Caption = 'Unit Price';
            Description = 'Unit price';

            trigger OnValidate()
            begin
                Validate("Line Discount %");
            end;
        }
        field(110; Standard; Boolean)
        {
            Caption = 'Standard';
            Editable = false;
        }
        field(120; "Option Subtype"; Option)
        {
            Caption = 'Option Subtype';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;

            trigger OnValidate()
            begin
                if ("Option Type" = "option type"::"Own Option") and ("Option Subtype" <> "option subtype"::Option) then
                    Error(Text005, Format("option type"::"Own Option"), Format("option subtype"::Option));
            end;
        }
        field(140; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(150; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
        }
        field(160; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                GetAssemblyHeader;
                "Line Discount Amount" :=
                  ROUND("Sales Price" *
                          "Line Discount %" / 100, Currency."Amount Rounding Precision");
                UpdateAmounts;
            end;
        }
        field(170; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            begin
                if "Sales Price" <> 0 then
                    "Line Discount %" :=
                      ROUND(
                       "Line Discount Amount" / "Sales Price" * 100,
                        0.00001)
                else
                    "Line Discount %" := 0;
                UpdateAmounts;
            end;
        }
        field(180; Amount; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO(Amount));
            Caption = 'Amount';

            trigger OnValidate()
            begin
                TestField("Sales Price");
                GetAssemblyHeader;
                Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                Validate(
                  "Line Discount Amount", ROUND("Sales Price", Currency."Amount Rounding Precision") - Amount);

                VehPriceCalcMgt.UpdateSalesLineAmounts(Rec);
            end;
        }
        field(190; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
        field(200; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(230; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(240; "PDI Created"; Boolean)
        {
            Caption = 'PDI Created';
        }
        field(250; "Direct Purchase Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                Validate("Purchase Discount %");
            end;
        }
        field(260; "Purchase Discount %"; Decimal)
        {

            trigger OnValidate()
            begin
                GetAssemblyHeader;
                "Purchase Discount Amount" :=
                  ROUND("Direct Purchase Cost" *
                          "Purchase Discount %" / 100, Currency."Amount Rounding Precision");
                UpdateAmounts;
            end;
        }
        field(270; "Purchase Discount Amount"; Decimal)
        {
        }
        field(280; "Purchase Cost Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Serial No.", "Assembly ID", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; "Option Type", "Option Subtype", "Option Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        VehPriceCalcMgt.UpdateSalesLineAmounts(Rec);
    end;

    trigger OnInsert()
    var
        VehAssembly: Record "Vehicle Assembly Line";
        Ishandled: Boolean;
    begin
        TestField("Model Code");
        TestField("Make Code");
        TestField("Model Version No.");
        TestField("Serial No.");

        VehAssembly := Rec;

        if "Option Type" = "option type"::"Vehicle Base" then begin
            VehAssembly.SetRange("Option Type", "option type"::"Vehicle Base");
            VehAssembly.SetRange("Assembly ID", "Assembly ID");
            VehAssembly.SetRange("Serial No.", "Serial No.");
            if VehAssembly.Count > 0 then Error(Text001, Format("Option Type"))
        end;

        if "Option Subtype" = "option subtype"::Color then begin
            VehAssembly.SetRange("Option Subtype", "option subtype"::Color);
            VehAssembly.SetRange("Assembly ID", "Assembly ID");
            VehAssembly.SetRange("Serial No.", "Serial No.");
            if VehAssembly.Count > 0 then Error(Text004, Format("Option Subtype"))
        end;

        if "Option Subtype" = "option subtype"::Upholstery then begin
            VehAssembly.SetRange("Option Subtype", "option subtype"::Upholstery);
            VehAssembly.SetRange("Assembly ID", "Assembly ID");
            VehAssembly.SetRange("Serial No.", "Serial No.");
            if VehAssembly.Count > 0 then Error(Text004, Format("Option Subtype"))
        end;

        VehAssembly := Rec;
        VehPriceCalcMgt.UpdateSalesLineAmounts(VehAssembly);
        OnBeforeInsertAndUpdatePurchLineAmounts(VehAssembly, Ishandled);
        If not Ishandled then
            VehPriceCalcMgt.UpdatePurchLineAmounts(VehAssembly);
    end;

    trigger OnModify()
    var
        Released: Boolean;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NoTestOnPurchase: Boolean;
    begin
        //>>DELTA 01
        SalesLine.Reset;
        SalesLine.SetCurrentkey("Vehicle Serial No.", "Vehicle Assembly ID");
        SalesLine.SetRange("Vehicle Serial No.", "Serial No.");
        SalesLine.SetRange("Vehicle Assembly ID", "Assembly ID");
        if SalesLine.FindSet then Begin
            repeat
                SalesHeader.Reset;
                SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                SalesHeader.TestField(Status, SalesHeader.Status::Open);
            until SalesLine.Next = 0;
            NoTestOnPurchase := True;
        End;
        If NoTestOnPurchase = false then Begin
            //<<DELTA 01       
            PurchLine.Reset;
            PurchLine.SetCurrentkey("Vehicle Serial No.", "Vehicle Assembly ID");
            PurchLine.SetRange("Vehicle Serial No.", "Serial No.");
            PurchLine.SetRange("Vehicle Assembly ID", "Assembly ID");
            OnAfterSetFilerOnBeforePurchLineFind(PurchLine, Rec);
            if PurchLine.FindSet then
                repeat
                    PurchHeader.Reset;
                    PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.");
                    PurchHeader.TestField(Status, PurchHeader.Status::Open);
                until PurchLine.Next = 0;
            //>>DELTA 01
        End;
        // SalesLine.Reset;
        // SalesLine.SetCurrentkey("Vehicle Serial No.", "Vehicle Assembly ID");
        // SalesLine.SetRange("Vehicle Serial No.", "Serial No.");
        // SalesLine.SetRange("Vehicle Assembly ID", "Assembly ID");
        // if SalesLine.FindSet then
        //     repeat
        //         SalesHeader.Reset;
        //         SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        //         SalesHeader.TestField(Status, SalesHeader.Status::Open);
        //     until SalesLine.Next = 0;
        //>>DELTA 01       
    end;

    var
        ManOption: Record "Manufacturer Option";
        OwnOption: Record "Own Option";
        Item: Record Item;
        TempVehicleAssembly: Record "Vehicle Assembly Line";
        VehAssemblyHeader: Record "Vehicle Assembly Header";
        Currency: Record Currency;
        VehPriceCalcMgt: Codeunit VehicleSalesPriceDiscountMgt;
        Text001: label 'It''s restricted to insert two lines of type %1';
        Text002: label 'Option %1 is not compatible with option %2';
        Text003: label 'Option %1 must be used with option(s): \%2';
        Text004: label 'It''s restricted to insert two lines of subtype %1';
        Text005: label 'Option Type %1 must be used with Option Subtype: \%2';
        Text006: label 'Option "%1" can be used only with following option(s). Would you like to insert them now? \%2';
        Text007: Label 'Item No. must not exceed %1 number of characters';


    procedure UpdateAmounts()
    var
        SalesAmount: Decimal;
    begin
        if Amount <> "Sales Price" - "Line Discount Amount" then
            Amount := "Sales Price" - "Line Discount Amount";

        if "Purchase Cost Amount" <> "Direct Purchase Cost" - "Purchase Discount Amount" then
            "Purchase Cost Amount" := "Direct Purchase Cost" - "Purchase Discount Amount";
    end;


    procedure IsPosted(VehAssembly: Record "Vehicle Assembly Line"): Boolean
    var
        VehOptLedg: Record "Vehicle Opt. Ledger Entry";
    begin
        VehAssembly.TestField("Serial No.");
        VehAssembly.TestField("Assembly ID");

        VehOptLedg.Reset;
        VehOptLedg.SetCurrentkey("Vehicle Serial No.");
        VehOptLedg.SetRange("Vehicle Serial No.", VehAssembly."Serial No.");
        VehOptLedg.SetRange("Entry Type", VehOptLedg."entry type"::"Put On");
        VehOptLedg.SetRange(Open, true);
        VehOptLedg.SetRange(Correction, false);
        VehOptLedg.SetRange("Option Type", VehAssembly."Option Type");
        VehOptLedg.SetRange("Option Code", VehAssembly."Option Code");
        exit(not VehOptLedg.IsEmpty);
    end;


    procedure UpdateSalesPrice(CalledByFieldNo: Integer)
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        Validate("Sales Price", 0);

        GetAssemblyHeader;

        VehPriceCalcMgt.FindAssemblyLineDisc(VehAssemblyHeader, Rec);
        VehPriceCalcMgt.FindAssemblyLinePrice(VehAssemblyHeader, Rec);
        OnBeforeValidateSalesPrice(Rec);
        Validate("Sales Price");
    end;


    procedure UpdatePurchasePrice(CalledByFieldNo: Integer)
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        Validate("Direct Purchase Cost", 0);

        GetAssemblyHeader;

        VehPriceCalcMgt.FindAssemblyLinePurchaseDisc(VehAssemblyHeader, Rec);
        VehPriceCalcMgt.FindAssemblyLinePurchasePrice(VehAssemblyHeader, Rec);

        Validate("Direct Purchase Cost");
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        Field.Get(Database::"Vehicle Assembly Line", FieldNumber);
        exit(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        SalesPricesIncVar: Integer;
    begin
        if not VehAssemblyHeader.Get("Assembly ID") then begin
            VehAssemblyHeader."Assembly ID" := '';
            VehAssemblyHeader.Init;
        end;
        if VehAssemblyHeader."Prices Including VAT" then
            SalesPricesIncVar := 1
        else
            SalesPricesIncVar := 0;
        Clear(VehAssemblyHeader);

        exit('2,' + Format(SalesPricesIncVar) + ',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetAssemblyHeader()
    begin
        TestField("Assembly ID");
        if "Assembly ID" <> VehAssemblyHeader."Assembly ID" then begin
            if not VehAssemblyHeader.Get("Assembly ID") then begin
                VehAssemblyHeader.Init;
                VehAssemblyHeader."Assembly ID" := "Assembly ID";
                VehAssemblyHeader.Insert;
            end;

            if VehAssemblyHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                VehAssemblyHeader.TestField("Currency Factor");
                Currency.Get(VehAssemblyHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;


    procedure SetAssemblyHeader(NewVehAssemblyHeader: Record "Vehicle Assembly Header")
    begin
        VehAssemblyHeader := NewVehAssemblyHeader;

        if NewVehAssemblyHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            NewVehAssemblyHeader.TestField("Currency Factor");
            Currency.Get(NewVehAssemblyHeader."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
    end;


    procedure CheckOptionConditions()
    var
        VehAssembly: Record "Vehicle Assembly Line";
        VehAssemblyToCheck: Record "Vehicle Assembly Line";
        ManufacturerOptionCondition: Record "Manufacturer Option Condition";
        ManOptionToCheck: Record "Manufacturer Option";
        OptWithCondErrorTxt: label 'Option %1 must be used with option: %2';
        OptNotWithCondErrorTxt: label 'Option %1 must not be used with option: %2';
    begin
        VehAssemblyToCheck.Reset();
        VehAssemblyToCheck.SetRange("Assembly ID", "Assembly ID");
        VehAssemblyToCheck.SetRange("Option Type", VehAssembly."Option Type"::"Manufacturer Option");
        VehAssembly.Reset();
        VehAssembly.SetRange("Assembly ID", "Assembly ID");
        VehAssembly.SetRange("Option Type", VehAssembly."Option Type"::"Manufacturer Option");
        if VehAssembly.FindSet() then
            repeat
                ManufacturerOptionCondition.Reset;
                ManufacturerOptionCondition.SetRange("Make Code", VehAssembly."Make Code");
                ManufacturerOptionCondition.SetRange("Model Code", VehAssembly."Model Code");
                ManufacturerOptionCondition.SetRange("Model Version No.", VehAssembly."Model Version No.");
                ManufacturerOptionCondition.SetRange("Option Type", VehAssembly."Option Subtype");
                ManufacturerOptionCondition.SetRange("Option Code", VehAssembly."Option Code");
                if ManufacturerOptionCondition.FindFirst then
                    repeat
                        VehAssemblyToCheck.SetRange("Option Code", ManufacturerOptionCondition."Condition Option Code");
                        case ManufacturerOptionCondition."Condition Type" of
                            ManufacturerOptionCondition."condition type"::"Only with":
                                begin
                                    if not VehAssemblyToCheck.FindFirst then
                                        Error(OptWithCondErrorTxt, VehAssembly."Option Code", ManufacturerOptionCondition."Condition Option Code");
                                end;
                            ManufacturerOptionCondition."condition type"::"Not with":
                                begin
                                    if VehAssemblyToCheck.FindFirst then
                                        Error(OptNotWithCondErrorTxt, VehAssembly."Option Code", VehAssemblyToCheck."Option Code");
                                end;
                        end;
                    until ManufacturerOptionCondition.Next = 0;
            until VehAssembly.Next() = 0;
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeValidateSalesPrice(Var Rec: Record "Vehicle Assembly Line")
    begin
    end;

    [IntegrationEvent(True, false)]
    local procedure OnBeforeCopyOptionType(Var Rec: Record "Vehicle Assembly Line"; TempVehicleAssembly: Record "Vehicle Assembly Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertAndUpdatePurchLineAmounts(var VehAssembly: Record "Vehicle Assembly Line"; var Ishandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetFilerOnBeforePurchLineFind(var PurchLine: Record "Purchase Line"; var Rec: Record "Vehicle Assembly Line")
    begin
    end;
}

