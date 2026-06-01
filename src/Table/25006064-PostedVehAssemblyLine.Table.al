Table 25006064 "Posted Veh. Assembly Line"
{
    Caption = 'Vehicle Assembly Line';
    LookupPageID = "Vehicle Assembly Worksheet";

    fields
    {
        field(1; "Source ID"; Integer)
        {
            Caption = 'Source ID';
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
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
            OptionCaption = 'Manufacturer Option,Own Option,Vehicle Base';
            OptionMembers = "Manufacturer Option","Own Option","Vehicle Base";

            trigger OnValidate()
            var
                ModelVersion: Record Item;
            begin
            end;
        }
        field(60; "Option Code"; Code[50])
        {
            Caption = 'Option Code';

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
                CRLF: Text[2];
                ManufacturerOptionConditionTmp: Record "Manufacturer Option Condition" temporary;
                LineNo: Integer;
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
        }
        field(170; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(180; Amount; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO(Amount));
            Caption = 'Amount';
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
        }
        field(260; "Purchase Discount %"; Decimal)
        {
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
        key(Key1; "Serial No.", "Assembly ID", "Line No.", "Source ID", "Source No.")
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
        VehAssembly: Record "Vehicle Assembly Line";
    begin
    end;

    trigger OnModify()
    var
        Released: Boolean;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
    end;

    var
        VehAssemblyHeader: Record "Vehicle Assembly Header";

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
}

