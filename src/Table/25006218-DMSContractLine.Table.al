Table 25006218 "DMS Contract Line"
{
    Caption = 'Contract Service';

    fields
    {
        field(10; "DMS Contract No."; Code[20])
        {
            Caption = 'DMS Contract No.';
            NotBlank = true;
            TableRelation = Contract."Contract No.";
        }
        field(20; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            NotBlank = true;
            TableRelation = "BLS Service".Code;

            trigger OnValidate()
            begin
                if xRec."Service Code" <> "Service Code" then begin
                    "Service Description" := '';
                    "Unit of Measure Code" := '';
                    "Quantity Source" := "quantity source"::Contract;
                    Quantity := 0;
                    "Price Source" := "price source"::Contract;
                    "Price Including VAT" := false;
                    "Invoice Group Code" := '';
                    "Calculation Period Code" := '';
                    "Invoicing Period Code" := '';
                    "Discount Usage" := "discount usage"::" ";
                end;

                if "Service Code" <> '' then begin
                    Service.Get("Service Code");
                    "Service Description" := Service.Description;
                    "Unit of Measure Code" := Service."Base Unit of Measure Code";
                    "Quantity Source" := Service."Quantity Source";
                    Quantity := Service."Default Quantity";
                    "Price Source" := Service."Price Source";
                    "Price Including VAT" := Service."Price Including VAT";
                    "Invoice Group Code" := Service."Invoice Group Code";
                    "Calculation Period Code" := Service."Calculation Period Code";
                    "Invoicing Period Code" := Service."Invoicing Period Code";
                    "Discount Usage" := Service."Discount Usage";
                end;
            end;
        }
        field(30; "Object Code"; Code[20])
        {
            Caption = 'Object Code';
            TableRelation = "BLS Object".Code;

            trigger OnValidate()
            begin
                if xRec."Object Code" <> "Object Code" then
                    "Object Name" := '';

                if "Object Code" <> '' then begin
                    BLSObject.Get("Object Code");
                    BLSObject.TestField("Object Type", BLSObject."object type"::Standard);
                    "Object Name" := BLSObject.Name;
                end;
            end;
        }
        field(35; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = "Contract Vehicle"."Vehicle Serial No." where("Contract Type" = const(Contract),
                                                                           "Contract No." = field("DMS Contract No."));

            trigger OnValidate()
            begin
                if "Vehicle Serial No." <> '' then begin
                    ContractVehicle.Get(ContractVehicle."contract type"::Contract, "DMS Contract No.", "Vehicle Serial No.");
                    ContractVehicle.TestField(Blocked, false);
                end;
            end;
        }
        field(40; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                TestField("Starting Date");

                if not DateRangeIsCorrect("Starting Date", "Ending Date") then
                    Error(IncorrectDateRangeErr, "Starting Date", "Ending Date");

                if not DateInContractPeriod("Starting Date") then
                    Error(DateOutOfContractErr, "Starting Date");
            end;
        }
        field(100; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                if not DateRangeIsCorrect("Starting Date", "Ending Date") then
                    Error(IncorrectDateRangeErr, "Starting Date", "Ending Date");

                if not DateRangeIsCorrect("Last Calculation Date", "Ending Date") then
                    Error(IncorrectDateRangeErr, "Last Calculation Date", "Ending Date");

                if not DateInContractPeriod("Ending Date") then
                    Error(DateOutOfContractErr, "Ending Date");
            end;
        }
        field(200; "Service Description"; Text[50])
        {
            Caption = 'Service Description';
        }
        field(210; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Unit of Measure".Code;

            trigger OnValidate()
            var
                ResUnitOfMeasure: Record "Resource Unit of Measure";
                ResLedgEnty: Record "Res. Ledger Entry";
            begin
            end;
        }
        field(220; "Invoice Group Code"; Code[20])
        {
            Caption = 'Invoice Group Code';
        }
        field(300; "Object Name"; Text[50])
        {
            Caption = 'Object Name';
        }
        field(1000; "Quantity Source"; Option)
        {
            Caption = 'Quantity Source';
            OptionCaption = 'Contract,Service Ledger,Service Default';
            OptionMembers = Contract,"Service Ledger","Service Default";

            trigger OnValidate()
            begin
                if xRec."Quantity Source" <> "Quantity Source" then
                    Validate(Quantity, 0);
            end;
        }
        field(1010; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if Quantity <> 0 then begin
                    TestField("Service Code");
                    TestField("Quantity Source", "quantity source"::Contract);
                    Quantity := BLSMgt.NormalizeServiceQty("Service Code", 0, Quantity);
                end;
            end;
        }
        field(2000; "Price Source"; Option)
        {
            Caption = 'Price Source';
            OptionCaption = 'Contract,Price List,Service Ledger';
            OptionMembers = Contract,"Price List","Service Ledger";

            trigger OnValidate()
            begin
                if xRec."Price Source" <> "Price Source" then
                    Validate(Price, 0);
            end;
        }
        field(2010; Price; Decimal)
        {
            Caption = 'Price';
            DecimalPlaces = 2 : 5;

            trigger OnValidate()
            begin
                if Price <> 0 then
                    TestField("Price Source", "price source"::Contract);
            end;
        }
        field(2020; "Price Including VAT"; Boolean)
        {
            Caption = 'Price Including VAT';
        }
        field(2030; "Discount Usage"; Option)
        {
            Caption = 'Discount Usage';
            OptionCaption = ' ,Contract,All';
            OptionMembers = " ",Contract,All;
        }
        field(4000; "Calculation Period Code"; Code[20])
        {
            Caption = 'Calculation Period Code';
        }
        field(4010; "Invoicing Period Code"; Code[20])
        {
            Caption = 'Invoicing Period Code';
        }
        field(5000; "Last Calculation Date"; Date)
        {
            Caption = 'Last Calculation Date';
        }
        field(6000; "Veh. Make Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6010; "Veh. Model Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6020; "Veh. Model Version No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Version No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6030; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            FieldClass = FlowField;
        }
        field(8000; "Variable Field Run Start 1"; Integer)
        {
            CaptionClass = '7,25006218,8000';
        }
        field(8010; "Variable Field Run Start 2"; Integer)
        {
            CaptionClass = '7,25006218,8010';
        }
        field(8020; "Variable Field Run Start 3"; Integer)
        {
            CaptionClass = '7,25006218,8020';
        }

        field(7000; "Leasing Schedule No."; Code[20])
        {
            Caption = 'Leasing Schedule No.';
            TableRelation = "BLS Leasing Schedule Header"."No.";
        }
    }

    keys
    {
        key(Key1; "DMS Contract No.", "Service Code", "Object Code", "Vehicle Serial No.", "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if not IsAllowedModification then
            Error(NotModifyErr, "DMS Contract No.");
        TestField("Last Calculation Date", 0D);
    end;

    trigger OnInsert()
    begin
        if not IsAllowedModification then
            Error(NotModifyErr, "DMS Contract No.");
    end;

    trigger OnModify()
    begin
        if not IsAllowedModification then
            Error(NotModifyErr, "DMS Contract No.");
    end;

    trigger OnRename()
    begin
        if not IsAllowedModification then
            Error(NotModifyErr, "DMS Contract No.");
    end;

    var
        ApplicationManagement: Codeunit DocumentManagementDMS;
        BLSObject: Record "BLS Object";
        Contract: Record Contract;
        Service: Record "BLS Service";
        ContractVehicle: Record "Contract Vehicle";
        BLSMgt: Codeunit "BLS Management";
        DateOutOfContractErr: label 'Date %1 is out of contract active period.';
        IncorrectDateRangeErr: label 'Starting date (%1) must be before Ending Date (%2).';
        NotModifyErr: label 'Contract No. %1 modification or deleting is not allowed.';
        ObjCodeMustBeEmptyErr: label 'Object must be empty for object type %1.';
        ServiceLineExistErr: label 'Contract line has special conditions. Contract No. %1, Service Code %2,  %3 %4, From Date %5';
        Text001: label 'Would you like to change %1 as well?';
        Text002: label 'Would you like to recalculate %1 in other stages?';
        VFMgt: Codeunit "Variable Field Management";


    local procedure DateRangeIsCorrect(FromDate: Date; ToDate: Date): Boolean
    begin
        if (FromDate = 0D) or (ToDate = 0D) then
            exit(true);

        exit(FromDate <= ToDate);
    end;

    local procedure IsAllowedModification(): Boolean
    begin
        if not GetContract then
            exit(false);

        // EXIT(Contract.IsAllowedModification);
        exit(true);
    end;

    local procedure GetContract(): Boolean
    begin
        if "DMS Contract No." = '' then
            exit(false);

        exit(Contract.Get("DMS Contract No."));
    end;

    local procedure DateInContractPeriod(Date: Date): Boolean
    begin
        if Date = 0D then
            exit(true);

        if not GetContract then
            exit(false);

        exit(true);
        Contract.TestField("Starting Date");
        exit(
             (Date >= Contract."Starting Date") and
             ((Date <= Contract."Expiration Date") or (Contract."Expiration Date" = 0D))
            );
    end;

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"DMS Contract Line", FieldNo));
    end;
}

