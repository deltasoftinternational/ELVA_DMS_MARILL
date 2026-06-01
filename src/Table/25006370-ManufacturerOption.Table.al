Table 25006370 "Manufacturer Option"
{
    // 30.05.2013 Elva Baltic P15
    //   * Option Code - Upholstery: "Vehicle Interior" table using instead of "Interior Upholstery"

    Caption = 'Manufacturer Option';
    DrillDownPageID = "Manufacturer Options";
    LookupPageID = "Manufacturer Options";

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(23; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));

            trigger OnLookup()
            var
                Item: Record Item;
                LookUpMgt: Codeunit LookUpManagement;
            begin
                Item.Reset;
                if LookUpMgt.LookUpModelVersion(Item, "Model Version No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", Item."No.")
            end;
        }
        field(30; "Option Code"; Code[20])
        {
            Caption = 'Option Code';
            NotBlank = true;
            TableRelation = if (Type = const(Color)) "Body Color".Code where("Make Code" = field("Make Code"))
            else
            if (Type = const(Upholstery)) "Vehicle Interior".Code where("Make Code" = field("Make Code"));

            trigger OnLookup()
            var
                ExteriorColor: Record "Body Color";
                VehicleInterior: Record "Vehicle Interior";
            begin
                case Type of
                    Type::Option:
                        begin
                            OnBeforeOnLookUpOptionCode(Rec)
                        end;
                    Type::Color:
                        begin
                            ExteriorColor.SetRange("Make Code", "Make Code");
                            if Page.RunModal(Page::"Body Colors", ExteriorColor) = Action::LookupOK then
                                Validate("Option Code", ExteriorColor.Code);
                        end;
                    Type::Upholstery:
                        begin
                            //30.05.2013 Elva Baltic P15 >>
                            VehicleInterior.SetRange("Make Code", "Make Code");
                            if Page.RunModal(Page::"Vehicle Interiors", VehicleInterior) = Action::LookupOK then
                                Validate("Option Code", VehicleInterior.Code);

                            //30.05.2013 Elva Baltic P15 <<
                        end;
                end;
            end;

            trigger OnValidate()
            var
                recExteriorColor: Record "Body Color";
                recInteriorUpholstery: Record "Picture Mgt. Setup";
            begin
                if Standard then begin
                    NoSeriesMgt.TestManual("No. Series");
                end else begin
                    "External Code" := "Option Code";
                end;
            end;
        }
        field(40; "External Code"; Code[50])
        {
            Caption = 'External Code';
        }
        field(50; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(60; Standard; Boolean)
        {
            Caption = 'Standard';

            trigger OnValidate()
            var
                Make: Record Make;
                MakeSetup: Record "Make Setup";
            begin
                if Standard and ("Make Code" <> '') and (Type = Type::Option) then begin
                    if MakeSetup.Get("Make Code") then
                        if "Option Code" = '' then begin
                            "No. Series" := MakeSetup."Standard Option Nos.";
                            "Option Code" := NoSeriesMgt.GetNextNo("No. Series", WorkDate(), true);
                        end;
                end;
            end;
        }
        field(70; "Bill of Materials"; Boolean)
        {
            CalcFormula = exist("Manufacturer Option BOM Comp." where("Make Code" = field("Make Code"),
                                                                       "Model Code" = field("Model Code"),
                                                                       "Model Version No." = field("Model Version No."),
                                                                       "Parent Option Code" = field("Option Code")));
            Caption = 'Bill of Materials';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(90; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
        }
        field(100; "Class Code"; Code[10])
        {
            Caption = 'Class Code';
            TableRelation = "Option Class".Code where("Make Code" = field("Make Code"));
        }
        field(110; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(120; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(140; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
        }
        field(160; Condition; Boolean)
        {
            CalcFormula = exist("Manufacturer Option Condition" where("Make Code" = field("Make Code"),
                                                                       "Model Code" = field("Model Code"),
                                                                       "Model Version No." = field("Model Version No."),
                                                                       "Option Code" = field("Option Code")));
            Caption = 'Condition';
            Editable = false;
            FieldClass = FlowField;
        }
        field(170; Exclude; Boolean)
        {
            Caption = 'Exclude';
        }
    }

    keys
    {
        key(Key1; "Make Code", "Model Code", "Model Version No.", Type, "Option Code")
        {
            Clustered = true;
        }
        key(Key2; Standard)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        OptionSalesPrice: Record "Option Sales Price";
        OptionSaleDiscount: Record "Option Sales Discount";
    begin
        OptionSalesPrice.Reset;
        OptionSalesPrice.SetRange("Make Code", "Make Code");
        OptionSalesPrice.SetRange("Model Code", "Model Code");
        OptionSalesPrice.SetRange("Model Version No.", "Model Version No.");
        OptionSalesPrice.SetRange("Option Type", OptionSalesPrice."option type"::"Manufacturer Option");
        OptionSalesPrice.SetRange("Option Code", "Option Code");
        OptionSalesPrice.DeleteAll(true);

        OptionSaleDiscount.Reset;
        OptionSaleDiscount.SetRange("Make Code", "Make Code");
        OptionSaleDiscount.SetRange("Model Code", "Model Code");
        OptionSaleDiscount.SetRange("Model Version No.", "Model Version No.");
        OptionSaleDiscount.SetRange("Option Type", OptionSaleDiscount."option type"::"Manufacturer Option");
        OptionSaleDiscount.SetRange("Option Code", "Option Code");
        OptionSaleDiscount.DeleteAll(true);
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";


    procedure GetCurrentPrice() CurrPrice: Decimal
    var
        OptionSalesPrice: Record "Option Sales Price";
    begin
        OptionSalesPrice.Reset;
        OptionSalesPrice.SetRange("Option Code", "Option Code");
        OptionSalesPrice.SetRange("Sales Type", OptionSalesPrice."sales type"::"All Customers");
        OptionSalesPrice.SetRange("Option Subtype", "Type");
        OptionSalesPrice.SetRange("Option Type", OptionSalesPrice."Option Type"::"Manufacturer Option");
        OptionSalesPrice.SetFilter("Starting Date", '<=%1', WorkDate);
        OptionSalesPrice.SetFilter("Ending Date", '''''|>=%1', WorkDate);
        if OptionSalesPrice.FindLast then
            CurrPrice := OptionSalesPrice."Unit Price";
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnLookUpOptionCode(var ManufacturerOption: Record "Manufacturer Option")
    begin
    end;
}

