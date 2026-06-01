Table 25006384 "Vehicle Assembly Line Arch."
{
    // 11.04.2013 EDMS P8
    //   * Renamed field 'Manuf. Option Type' to 'Option Subtype'
    //   * Removed code from field 'Option Code'

    Caption = 'Vehicle Assembly Line Arch.';
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
                if "Option Type" <> xRec."Option Type" then begin
                    TestField("Option Code", '');
                end;

                if "Option Type" = "option type"::"Vehicle Base" then
                    if ModelVersion.Get("Model Version No.") then begin
                        Description := ModelVersion.Description + ModelVersion."Description 2";
                        "Description 2" := '';
                    end;
            end;
        }
        field(60; "Option Code"; Code[50])
        {
            Caption = 'Option Code';
            TableRelation = if ("Option Type" = const("Manufacturer Option")) "Manufacturer Option"."Option Code" where("Make Code" = field("Make Code"),
                                                                                                                       "Model Code" = field("Model Code"),
                                                                                                                       "Model Version No." = field("Model Version No."))
            else
            if ("Option Type" = const("Vehicle Base")) Item."No." where("Item Type" = const("Model Version"))
            else
            if ("Option Type" = const("Own Option")) "Own Option"."Option Code" where("Make Code" = field("Make Code"), "Model Code" = field("Model Code"))
            else
            if ("Option Type" = const("Item")) Item."No." where("Item Type" = const("Item"));

            trigger OnLookup()
            var
                OwnOptions: Page "Own Options";
                ManOptions: Page "Manufacturer Options";
            begin
            end;

            trigger OnValidate()
            var
                ManufacturerOptionCondition: Record "Manufacturer Option Condition";
                VehicleAssemblyLine: Record "Vehicle Assembly Line";
                ComesWith: Text[250];
            begin
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
            Editable = false;
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
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
        field(250; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
    }

    keys
    {
        key(Key1; "Serial No.", "Assembly ID", "Version No.", "Line No.")
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

    trigger OnInsert()
    var
        VehAssembly: Record "Vehicle Assembly Line Arch.";
    begin
        TestField("Model Code");
        TestField("Make Code");
        TestField("Model Version No.");
        TestField("Serial No.");
    end;

    trigger OnModify()
    var
        Released: Boolean;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        PurchLine.Reset;
        PurchLine.SetCurrentkey("Vehicle Serial No.", "Vehicle Assembly ID");
        PurchLine.SetRange("Vehicle Serial No.", "Serial No.");
        PurchLine.SetRange("Vehicle Assembly ID", "Assembly ID");
        if PurchLine.FindSet then
            repeat
                PurchHeader.Reset;
                PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.");
                PurchHeader.TestField(Status, PurchHeader.Status::Open);
            until PurchLine.Next = 0;

        SalesLine.Reset;
        SalesLine.SetCurrentkey("Vehicle Serial No.", "Vehicle Assembly ID");
        SalesLine.SetRange("Vehicle Serial No.", "Serial No.");
        SalesLine.SetRange("Vehicle Assembly ID", "Assembly ID");
        if SalesLine.FindSet then
            repeat
                SalesHeader.Reset;
                SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                SalesHeader.TestField(Status, SalesHeader.Status::Open);
            until SalesLine.Next = 0;
    end;

    var
        TempVehicleAssembly: Record "Vehicle Assembly Line Arch.";
        VehAssemblyHeader: Record "Vehicle Assembly Header Arch.";
        Currency: Record Currency;
        Text002: label 'Option %1 is not compatible with option %2';
        Text003: label 'Option %1 has to be used with option(s): \%2';


    procedure UpdateAmounts()
    var
        SalesAmount: Decimal;
    begin
        if Amount <> "Sales Price" - "Line Discount Amount" then
            Amount := "Sales Price" - "Line Discount Amount";
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
        VehOptLedg.SetRange("Option Subtype", VehAssembly."Option Subtype");
        VehOptLedg.SetRange("Option Code", VehAssembly."Option Code");
        exit(not VehOptLedg.IsEmpty);
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


    procedure SetAssemblyHeader(NewVehAssemblyHeader: Record "Vehicle Assembly Header Arch.")
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
}

