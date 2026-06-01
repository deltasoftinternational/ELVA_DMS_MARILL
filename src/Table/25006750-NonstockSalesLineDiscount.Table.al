Table 25006750 "Nonstock Sales Line Discount"
{
    Caption = 'Nonstock Item Sales Line Discount';
    LookupPageID = "Sales Line Discounts";

    fields
    {
        field(1; "Nonstock Item Entry No."; Code[20])
        {
            Caption = 'Nonstock Item Entry No.';
            NotBlank = true;
            TableRelation = "Nonstock Item";

            trigger OnValidate()
            begin
                if xRec."Nonstock Item Entry No." <> "Nonstock Item Entry No." then begin
                    "Unit of Measure Code" := '';
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
            end;
        }
        field(5; "Line Discount %"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(8; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = if ("Sales Type" = const("Customer Price Group")) "Customer Price Group"
            else
            if ("Sales Type" = const(Customer)) Customer
            else
            if ("Sales Type" = const(Campaign)) Campaign
            else
            if ("Sales Type" = const(Contract)) Contract."Contract No.";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnValidate()
            var
                CustPriceGr: Record "Customer Price Group";
                Cust: Record Customer;
                Campaign: Record Campaign;
            begin
                if "Sales Code" <> '' then begin
                    case "Sales Type" of
                        "sales type"::"All Customers":
                            Error(Text001, FieldCaption("Sales Code"));
                        "sales type"::"Customer Price Group":
                            begin
                            end;
                        "sales type"::Customer:
                            begin
                            end;
                        "sales type"::Campaign:
                            begin
                                Campaign.Get("Sales Code");
                                "Starting Date" := Campaign."Starting Date";
                                "Ending Date" := Campaign."Ending Date";
                            end;
                    end;
                end;
            end;
        }
        field(9; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            InitValue = "All Customers";
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,Contract';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign,Contract;

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
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006003; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006120; "Source Type"; Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'User,Contract';
            OptionMembers = User,Contract;
        }
        field(25006130; Source; Code[20])
        {
            Caption = 'Source';
            Editable = false;
        }
        field(25006140; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(25006701; "Price List Code"; Code[20])
        {
            TableRelation = "Price List Header";
        }
        field(25006702; "Price List Line No."; integer)
        {


        }

    }

    keys
    {
        key(Key1; "Nonstock Item Entry No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Vehicle Status Code", "Document Profile")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // DELTA SALESPRICE
        cuSalesPriceCalcMgt.NonstockSalesLineDiscToItem(Rec, xRec, 3);
    end;

    trigger OnInsert()
    begin
        TestField("Nonstock Item Entry No.");
        "Source Type" := "source type"::User;
        Source := UserId;
        // DELTA SALESPRICE
        cuSalesPriceCalcMgt.NonstockSalesLineDiscToItem(Rec, xRec, 0);
    end;

    trigger OnModify()
    begin
        // DELTA SALESPRICE
        cuSalesPriceCalcMgt.NonstockSalesLineDiscToItem(Rec, xRec, 1);
    end;

    trigger OnRename()
    begin
        TestField("Nonstock Item Entry No.");
        // DELTA SALESPRICE
        cuSalesPriceCalcMgt.NonstockSalesLineDiscToItem(Rec, xRec, 2);
    end;

    var
        Text000: label '%1 cannot be after %2';
        Text001: label '%1 must be blank.';
        cuSalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
}

