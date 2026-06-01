table 25006237 "Sales Line Discount DMS"
{
    // 06.12.2017 EB.P7 #T007
    //   Removed fields
    //     25006390"Item Category Code"
    //     25006400"Product Group Code"
    //     25006401"Product Subgroup Code"
    // 
    // 04.02.2016 EB.P30 #T032
    //   Change relations for fields:
    //     "Item Category Code"
    //     "Product Group Code"
    //     "Product Subgroup Code"
    //   Modified triggers:
    //     OnInsert
    //     OnRename
    // 
    // 26.11.2015 EB.P7 #T017
    //   Code from triggers moved to events
    // 
    // 05.12.2013 EDMS P8
    //   * Added options to Type field
    // 
    // 21.11.2013 EDMS P8
    //   * Added EDMS fields

    Caption = 'Sales Line Discount';
    //LookupPageID = "Sales Line Discounts";




    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = false;
            TableRelation = if (Type = const(Item)) Item
            else
            if (Type = const("Item Disc. Group")) "Item Discount Group"
            else
            if (Type = const(All)) "Item Category".Code;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if xRec.Code <> Code then begin
                    "Unit of Measure Code" := '';
                    "Variant Code" := '';

                    if Type = Type::Item then
                        if Item.Get(Code) then
                            "Unit of Measure Code" := Item."Sales Unit of Measure"
                end;
            end;
        }
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = if ("Sales Type" = const("Customer Disc. Group")) "Customer Discount Group"
            else
            if ("Sales Type" = const(Customer)) Customer
            else
            if ("Sales Type" = const(Campaign)) Campaign
            else
            if ("Sales Type" = const(Contract)) Contract."Contract No."
            else
            if ("Sales Type" = const(Assembly)) "Vehicle Assembly Header"."Assembly ID"
            else
            if ("Sales Type" = const(SPackage)) "Service Package"."No.";

            trigger OnValidate()
            begin
                if "Sales Code" <> '' then
                    case "Sales Type" of
                        "Sales Type"::"All Customers":
                            Error(Text001, FieldCaption("Sales Code"));
                        "Sales Type"::Campaign:
                            begin
                                Campaign.Get("Sales Code");
                                "Starting Date" := Campaign."Starting Date";
                                "Ending Date" := Campaign."Ending Date";
                            end;
                    end;
            end;
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));

                if CurrFieldNo = 0 then
                    exit;
                if "Sales Type" = "Sales Type"::Campaign then
                    Error(Text003, FieldCaption("Starting Date"), FieldCaption("Ending Date"), FieldCaption("Sales Type"), "Sales Type");
            end;
        }
        field(5; "Line Discount %"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(13; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign,Contract,Assembly,SPackage';
            OptionMembers = Customer,"Customer Disc. Group","All Customers",Campaign,Contract,Assembly,SPackage;

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then
                    Validate("Sales Code", '');
            end;
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            MinValue = 0;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                Validate("Starting Date");

                if CurrFieldNo = 0 then
                    exit;
                if "Sales Type" = "Sales Type"::Campaign then
                    Error(Text003, FieldCaption("Starting Date"), FieldCaption("Ending Date"), FieldCaption("Sales Type"), "Sales Type");
            end;
        }
        field(21; Type; Enum "Sales Line Discount Type")
        {
            Caption = 'Type';
            //FIXME BC16 upgrade
            //OptionCaption = 'Item,Item Disc. Group';
            //OptionMembers = Item,"Item Disc. Group";

            trigger OnValidate()
            begin
                if xRec.Type <> Type then
                    Validate(Code, '');
                if Type = Type::All then
                    Validate(Code, '');
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD(Code));

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateUnitofMeasureCode(Rec, xRec, IsHandled);
                if IsHandled then
                    exit;

                TestField(Type, Type::Item);
            end;
        }
        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD(Code));

            trigger OnValidate()
            begin
                TestField(Type, Type::Item);
            end;
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006007; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006010; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));
        }
        field(25006120; "Source Type"; Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'User,Contract';
            OptionMembers = User,Contract;
        }
        field(25006130; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
        }
        field(25006140; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(25006373; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
    }

    keys
    {
        //key(Key1; Type, "Code", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        //{
        //    Clustered = true;
        //}
        //FIXME STDKEY
        key(Key1; Type, "Code", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Vehicle Status Code", "Document Profile", "Vehicle Serial No.", "Make Code")
        {
            Clustered = true;
        }
        key(Key2; "Sales Type", "Sales Code", Type, "Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }

    }

    fieldgroups
    {
        fieldgroup(Brick; "Sales Type", "Sales Code", "Line Discount %", Type, "Code", "Starting Date", "Ending Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sales Type" = "Sales Type"::"All Customers" then
            "Sales Code" := ''
        else
            TestField("Sales Code");
        //TESTFIELD(Code);                      // 04.02.2016 EB.P30 #T032
    end;

    trigger OnRename()
    begin
        if "Sales Type" <> "Sales Type"::"All Customers" then
            TestField("Sales Code");
        //TESTFIELD(Code);                      // 04.02.2016 EB.P30 #T032
    end;

    var
        Text000: Label '%1 cannot be after %2';
        Text001: Label '%1 must be blank.';
        Campaign: Record Campaign;
        Text003: Label 'You can only change the %1 and %2 from the Campaign Card when %3 = %4.';

    [Obsolete('This table is replaced by the new implementation (V16) of price calculation: table Price List Line', '22.0')]
    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateUnitofMeasureCode(var SalesLineDiscount: Record "Sales Line Discount DMS"; xSalesLineDiscount: Record "Sales Line Discount DMS"; var IsHandled: Boolean)
    begin
    end;
}

