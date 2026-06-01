Table 25006121 "Service Labor"
{
    // 16.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added CaptionML to field:
    //     "Labor Discount Group"

    Caption = 'Service Labor';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = "Service Labor List";
    LookupPageID = "Service Labor List";

    fields
    {
        field(8; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    GetServSetup;
                    NoSeriesMgt.TestManual(ServSetup."Labor Nos.");
                end;
            end;
        }
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make.Code;
        }
        field(40; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
                    "Search Description" := Description;
                "Last Date Modified" := Today;
            end;
        }
        field(50; "Description 2"; Text[100])
        {
            Caption = 'Description 2';

            trigger OnValidate()
            begin
                "Last Date Modified" := Today;
            end;
        }
        field(60; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(70; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                "Last Date Modified" := Today;

                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");

                Validate("Price/Profit Calculation");
            end;
        }
        field(80; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                "Last Date Modified" := Today;
                Validate("Price/Profit Calculation");
            end;
        }
        field(86; Comment; Boolean)
        {
            CalcFormula = exist("Service Comment Line EDMS" where(Type = const(Labor),
                                                                   "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                "Last Date Modified" := Today;

                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(100; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                "Last Date Modified" := Today;

                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(120; "Group Code"; Code[10])
        {
            Caption = 'Group Code';
            TableRelation = "Service Labor Group".Code;

            trigger OnValidate()
            begin
                if "Group Code" <> xRec."Group Code" then
                    Validate("Subgroup Code", '');
            end;
        }
        field(130; "Subgroup Code"; Code[10])
        {
            Caption = 'Subgroup Code';
            TableRelation = "Service Labor Subgroup".Code where("Group Code" = field("Group Code"));
        }
        field(150; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(160; "Free of Charge"; Boolean)
        {
            Caption = 'Free of Charge';
        }
        field(180; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(200; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(280; "Date Created"; Date)
        {
            Caption = 'Date Created';
        }
        field(290; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';

            trigger OnValidate()
            var
                VATPostingSetup: Record "VAT Posting Setup";
            begin
                if "Price Includes VAT" then begin
                    if not VATPostingSetup.Get("VAT Bus. Posting Gr. (Price)", "VAT Prod. Posting Group") then
                        Error(
                          Text002,
                          FieldCaption("VAT Bus. Posting Gr. (Price)"),
                          FieldCaption("VAT Prod. Posting Group"));

                end;
                Validate("Price/Profit Calculation");
            end;
        }
        field(300; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                Validate("Price/Profit Calculation");
            end;
        }
        field(310; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                Validate("Price/Profit Calculation");
            end;
        }
        field(320; "Price/Profit Calculation"; Option)
        {
            Caption = 'Price/Profit Calculation';
            OptionCaption = 'Profit=Price-Cost,Price=Cost+Profit,No Relationship';
            OptionMembers = "Profit=Price-Cost","Price=Cost+Profit","No Relationship";

            trigger OnValidate()
            begin
                if "Price Includes VAT" and
                   ("Price/Profit Calculation" < "price/profit calculation"::"No Relationship")
                then begin
                    VATPostingSetup.Get("VAT Bus. Posting Gr. (Price)", "VAT Prod. Posting Group");
                    case VATPostingSetup."VAT Calculation Type" of
                        VATPostingSetup."vat calculation type"::"Reverse Charge VAT":
                            VATPostingSetup."VAT %" := 0;
                        VATPostingSetup."vat calculation type"::"Sales Tax":
                            Error(
                              Text001,
                              VATPostingSetup.FieldCaption("VAT Calculation Type"),
                              VATPostingSetup."VAT Calculation Type");
                    end;
                end else
                    Clear(VATPostingSetup);

                case "Price/Profit Calculation" of
                    "price/profit calculation"::"Profit=Price-Cost":
                        if "Unit Price" <> 0 then
                            "Profit %" :=
                              ROUND(
                                100 * (1 - "Unit Cost" / ("Unit Price" /
                                (1 + VATPostingSetup."VAT %" / 100))), 0.00001)
                        else
                            "Profit %" := 0;
                    "price/profit calculation"::"Price=Cost+Profit":
                        if "Profit %" < 100 then begin
                            GetGLSetup;
                            "Unit Price" :=
                              ROUND(
                                ("Unit Cost" / (1 - "Profit %" / 100)) *
                                (1 + VATPostingSetup."VAT %" / 100), GLSetup."Unit-Amount Rounding Precision");
                        end;
                end;
            end;
        }
        field(330; "Profit %"; Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0 : 5;
            MaxValue = 99.99999;

            trigger OnValidate()
            begin
                Validate("Price/Profit Calculation");
            end;
        }
        field(340; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                //  TestNoEntriesExist(FIELDCAPTION("Unit Cost"));
                Validate("Price/Profit Calculation");
            end;
        }
        field(350; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                //TestNoOpenEntriesExist(FIELDCAPTION("Base Unit of Measure"));
            end;
        }
        field(360; "Price Group Code"; Code[10])
        {
            Caption = 'Price Group Code';
            TableRelation = "Service Labor Price Group"."No.";
        }
        field(370; "Labor Discount Group"; Code[20])
        {
            Caption = 'Labor Discount Group';
            TableRelation = "Service Labor Discount Group";
        }
        field(51100; "Separate Labor Line on Invoice"; Boolean)
        {
            Caption = 'Separate Labor Line on Invoice';
        }
        field(51200; "Labor Type"; Option)
        {
            Caption = 'Labor Type';
            OptionCaption = 'Labor,Travel Time,Travel Distance,Travel Other,Meal Allowance,Other';
            OptionMembers = Labor,"Travel Time","Travel Distance","Travel Other","Meal Allowance",Other;
        }
        field(51210; "Keep Prices and Discounts"; Boolean)
        {
            Caption = 'Keep Prices and Discounts';
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006121,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Labor", FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006121,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Labor", FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006121,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Labor", FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Make Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GetServSetup;
            ServSetup.TestField("Labor Nos.");
            "No." := NoSeriesMgt.GetNextNo(ServSetup."Labor Nos.", 0D, true);
        end;
        "Date Created" := WorkDate;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        ServSetup: Record "Service Mgt. Setup EDMS";
        NoSeriesMgt: Codeunit "No. Series";
        VFMgt: Codeunit "Variable Field Management";
        LookUpMgt: Codeunit LookUpManagement;
        DimMgt: Codeunit DimensionManagement;
        GLSetup: Record "General Ledger Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        Text001: label 'Prices including VAT cannot be calculated when %1 is %2.';
        GLSetupRead: Boolean;
        HasServSetup: Boolean;
        Text002: label 'Can''t find VAT Posting Setup. Please check fields %1 and %2.';


    procedure AssistEdit(): Boolean
    begin
        GetServSetup;
        ServSetup.TestField("Labor Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(ServSetup."Labor Nos.", ServSetup."Labor Nos.", ServSetup."Labor Nos.") then begin
            "No." := NoSeriesMgt.GetNextNo(ServSetup."Labor Nos.", WorkDate(), true);
            exit(true);
        end;
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Service Labor", intFieldNo));
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure GetServSetup()
    begin
        if not HasServSetup then begin
            ServSetup.Get;
            HasServSetup := true;
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::"Service Labor", "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;
}

