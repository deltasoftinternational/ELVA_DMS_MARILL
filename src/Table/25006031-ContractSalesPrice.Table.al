Table 25006031 "Contract Sales Price"
{
    // 23.08.2013 EDMS P8
    //   * New type "Labor Price Group" in field Type

    Caption = 'Contract Sales Price';
    LookupPageID = "Contract Sales Prices";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = if (Type = const(Item)) Item where("Item Type" = const(Item))
            else
            if (Type = const(Labor)) "Service Labor"."No."
            else
            if (Type = const("Labor Price Group")) "Service Labor Price Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                if Code <> xRec.Code then begin
                    "Unit of Measure Code" := '';
                    "Variant Code" := '';
                end;
            end;
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));
            end;
        }
        field(5; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(7; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Price Includes VAT" <> xRec."Price Includes VAT") and "Price Includes VAT" then
                    Message(Text100, FieldCaption("VAT Bus. Posting Gr. (Price)"))
            end;
        }
        field(10; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(11; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
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
                TestStatusOpen;
                if CurrFieldNo = 0 then
                    exit;

                Validate("Starting Date");
            end;
        }
        field(20; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            Description = 'Not Supported. Reserved for future.';
            OptionCaption = 'Quote,Contract';
            OptionMembers = Quote,Contract;
        }
        field(30; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(40; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item,Labor,Labor Price Group';
            OptionMembers = Item,Labor,"Labor Price Group";
        }
        field(60; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                Vehicle.Reset;
                if cuLookupMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then begin
                    Validate("Vehicle Serial No.", Vehicle."Serial No.");
                    VIN := Vehicle.VIN;
                end;
            end;
        }
        field(65; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
            begin
                recVehicle.Reset;
                if cuLookupMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") then begin
                    Validate("Vehicle Serial No.", recVehicle."Serial No.");
                    VIN := recVehicle.VIN;
                end;
            end;

            trigger OnValidate()
            var
                recReservationEntry: Record "Reservation Entry";
                iEntryNo: Integer;
                cSalesLineReserve: Codeunit "Sales Line-Reserve";
                recVehicle: Record Vehicle;
                codSerialNoPre: Code[20];
                codDefCycle: Code[20];
                cuVehAccCycle: Codeunit VehicleAccountingCycleMgt;
            begin
                TestStatusOpen;
                if "Vehicle Serial No." = '' then begin
                    VIN := '';
                end
                else begin
                    Vehicle.Reset;
                    if Vehicle.Get("Vehicle Serial No.") then begin
                        codSerialNoPre := "Vehicle Serial No.";
                        VIN := Vehicle.VIN;
                        "Vehicle Serial No." := codSerialNoPre;
                    end;
                end;
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field(Code))
            else
            if (Type = const(Labor)) "Unit of Measure".Code;
        }
        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field(Code));
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Service';
            OptionMembers = " ","Spare Parts Trade",Service;
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006770; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "Contract Type", "Contract No.", Type, "Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code", "Location Code", "Document Profile", "Vehicle Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: label '%1 cannot be after %2';
        Cust: Record Customer;
        Campaign: Record Campaign;
        Item: Record Item;
        Vehicle: Record Vehicle;
        Contract: Record Contract;
        cuLookupMgt: Codeunit LookUpManagement;
        Text100: label 'Don''t forget to set %1';

    local procedure TestStatusOpen()
    begin
        Contract.TestField(Status, Contract.Status::Inactive);
    end;
}

