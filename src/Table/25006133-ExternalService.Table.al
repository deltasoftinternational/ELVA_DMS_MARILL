Table 25006133 "External Service"
{
    // 15.07.2008. EDMS P2
    //   * Changed field Comment property CalaFormula

    Caption = 'External Service';
    DataCaptionFields = "No.", Description;
    LookupPageID = "External Service List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
                    "Search Description" := Description;
                "Last Date Modified" := Today;
            end;
        }
        field(30; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(40; "Description 2"; Text[50])
        {
            Caption = 'Description 2';

            trigger OnValidate()
            begin
                "Last Date Modified" := Today;
            end;
        }
        field(50; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(60; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(70; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(80; Comment; Boolean)
        {
            CalcFormula = exist("Service Comment Line EDMS" where(Type = const("External Service"),
                                                                   "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                "Last Date Modified" := Today;
                Validate("Price/Profit Calculation");
            end;
        }
        field(100; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                Validate("Price/Profit Calculation");
            end;
        }
        field(110; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                "Last Date Modified" := Today;
                Validate("Price/Profit Calculation");
            end;
        }
        field(120; "Vendor No."; Code[20])
        {
            Caption = 'Vendor Number';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(210; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(211; "Allow Tracking Nos."; Boolean)
        {
            Caption = 'Allow Tracking Nos.';
        }
        field(212; "Tracking Nos."; Code[20])
        {
            Caption = 'Tracking Nos.';
            TableRelation = "No. Series";
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
                        FieldError("VAT Bus. Posting Gr. (Price)");
                end;
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
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GetServSetup;
            ServSetup.TestField("External Service Nos.");
            "No." := NoSeriesMgt.GetNextNo(ServSetup."External Service Nos.", 0D, true);
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
        VATPostingSetup: Record "VAT Posting Setup";
        Text001: label 'Prices including VAT cannot be calculated when %1 is %2.';
        GLSetupRead: Boolean;
        GLSetup: Record "General Ledger Setup";
        ServSetup: Record "Service Mgt. Setup EDMS";
        NoSeriesMgt: Codeunit "No. Series";
        HasServSetup: Boolean;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure AssistEdit(): Boolean
    begin
        GetServSetup;
        ServSetup.TestField("External Service Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(ServSetup."External Service Nos.", ServSetup."External Service Nos.",
       ServSetup."External Service Nos.") then begin
            "No." := NoSeriesMgt.GetNextNo(ServSetup."External Service Nos.", WorkDate(), true);
            exit(true);
        end;
    end;


    procedure GetServSetup()
    begin
        if not HasServSetup then begin
            ServSetup.Get;
            HasServSetup := true;
        end;
    end;
}

