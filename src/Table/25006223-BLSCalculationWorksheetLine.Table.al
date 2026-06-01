Table 25006223 "BLS Calculation Worksheet Line"
{
    Caption = 'Calculation Worksheet Line';

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(100; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if xRec."Customer No." <> "Customer No." then
                    "Customer Name" := '';

                if "Customer No." <> '' then begin
                    Customer.Get("Customer No.");
                    "Customer Name" := Customer.Name;
                end;
            end;
        }
        field(110; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(120; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(122; "Line type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Services,Lease Schedule';
            OptionMembers = Services,"Lease Schedule";
        }
        field(130; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            NotBlank = true;
            TableRelation = "BLS Service";

            trigger OnValidate()
            begin
                if xRec."Service Code" <> "Service Code" then begin
                    "Service Description" := '';
                    "Unit of Measure Code" := '';
                    Validate("Service Variant Code", '');
                end;

                if "Service Code" <> '' then begin
                    Service.Get("Service Code");
                    "Service Description" := Service.Description;
                    "Unit of Measure Code" := Service."Base Unit of Measure Code";
                end;
            end;
        }
        field(140; "Service Variant Code"; Code[20])
        {
            Caption = 'Service Variant Code';
        }
        field(160; "Object Code"; Code[20])
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
        field(170; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(180; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(190; "Quantity Source"; Option)
        {
            Caption = 'Quantity Source';
            OptionCaption = ' ,Contract,Price List,Service Ledger,Specific';
            OptionMembers = " ",Contract,"Price List","Service Ledger",Specific;
        }
        field(200; "Price Source"; Option)
        {
            Caption = 'Price Source';
            OptionCaption = ' ,Contract,Price List,Service Ledger,Specific';
            OptionMembers = " ",Contract,"Price List","Service Ledger",Specific;
        }
        field(210; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                GLSetup.Get;
                "Total Price" := ROUND(Quantity * "Unit Price", GLSetup."Amount Rounding Precision");
                Validate("Discount, %");
            end;
        }
        field(215; "Base Unit Price"; Decimal)
        {
            Caption = 'Base Unit Price';

            trigger OnValidate()
            begin
                if "Discount, %" = 0 then
                    "Base Unit Price Incl. Discount" := "Base Unit Price"
                else
                    "Base Unit Price Incl. Discount" := ROUND("Base Unit Price" * (100 - "Discount, %") / 100);
            end;
        }
        field(220; "Discount Source"; Option)
        {
            Caption = 'Discount Source';
            OptionCaption = ' ,Contract,Price List,Service Ledger,Specific';
            OptionMembers = " ",Contract,"Price List","Service Ledger",Specific;
        }
        field(230; "Discount, %"; Decimal)
        {
            Caption = 'Discount, %';

            trigger OnValidate()
            begin
                GLSetup.Get;
                "Discount Amount" := ROUND("Total Price" * "Discount, %" / 100, GLSetup."Amount Rounding Precision");
                "Total Price Incl. Discount" := "Total Price" - "Discount Amount";

                Validate("Base Unit Price");
            end;
        }
        field(240; "Specific Source"; Integer)
        {
            Caption = 'Specific Source';
        }
        field(250; "Specific No."; Code[20])
        {
            Caption = 'Specific No.';
        }
        field(300; "Period Starting Date"; Date)
        {
            Caption = 'Period Starting Date';
        }
        field(310; "Period Ending Date"; Date)
        {
            Caption = 'Period Ending Date';
        }
        field(400; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';

            trigger OnValidate()
            begin
                if Quantity = 0 then begin
                    if "Unit Price" = 0 then
                        TestField(Quantity);
                    Quantity := "Total Price" / "Unit Price";
                end else
                    "Unit Price" := ROUND("Total Price" / Quantity, GLSetup."Unit-Amount Rounding Precision");

                Validate("Discount, %");
            end;
        }
        field(410; "Discount Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Discount Amount';
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if "Discount Amount" <> 0 then begin
                    TestField("Total Price");
                    GLSetup.Get;
                    "Discount, %" := ROUND("Discount Amount" / "Total Price" * 100, GLSetup."Amount Rounding Precision");
                end;

                "Total Price Incl. Discount" := "Total Price" - "Discount Amount";
            end;
        }
        field(415; "Base Unit Price Incl. Discount"; Decimal)
        {
            Caption = 'Base Unit Price Incl. Discount';
        }
        field(420; "Total Price Incl. Discount"; Decimal)
        {
            Caption = 'Total Price Incl. Discount';
            DecimalPlaces = 2 : 2;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Total Price Incl. Discount" <> 0 then begin
                    TestField("Total Price");
                    GLSetup.Get;
                    "Discount Amount" := "Total Price" - "Total Price Incl. Discount";
                    "Discount, %" := ROUND("Discount Amount" / "Total Price" * 100, GLSetup."Amount Rounding Precision");
                end;
            end;
        }
        field(430; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                if Quantity <> 0 then begin
                    TestField("Service Code");
                    Quantity := BLSMgt.NormalizeServiceQty("Service Code", 0, Quantity);
                end;

                Validate("Unit Price");
            end;
        }
        field(440; "Base Quantity"; Decimal)
        {
            Caption = 'Base Quantity';
        }
        field(500; "Invoice Group Code"; Code[20])
        {
            Caption = 'Invoice Group Code';
        }
        field(510; "Calculation Period Code"; Code[20])
        {
            Caption = 'Calculation Period Code';
        }
        field(600; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(610; "Customer Discount Group"; Code[20])
        {
            Caption = 'Customer Discount Group';
            TableRelation = "Customer Discount Group";
        }
        field(620; "Service Group Code"; Code[20])
        {
            Caption = 'Service Group Code';
        }
        field(630; "Discount Usage"; Option)
        {
            Caption = 'Discount Usage';
            OptionCaption = ' ,Contract,All';
            OptionMembers = " ",Contract,All;
        }
        field(700; "Grouping ID"; Integer)
        {
        }
        field(710; "Service Date"; Date)
        {
            Caption = 'Service Date';
        }
        field(1000; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
        }
        field(1010; "Service Description"; Text[50])
        {
            Caption = 'Service Description';
        }
        field(1015; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;

            trigger OnValidate()
            var
                ResourceUnitOfMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }
        field(1020; "Object Name"; Text[50])
        {
            Caption = 'Object Name';
        }
        field(3000; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(3010; "Veh. Make Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3020; "Veh. Model Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3030; "Veh. Model Version No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Version No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3040; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            FieldClass = FlowField;
        }
        field(4000; "Lease Base Amount"; Decimal)
        {
            Caption = 'Lease Base Amount';
        }
        field(4010; "Lease Interest Amount"; Decimal)
        {
            Caption = 'Lease Interest Amount';
        }
        field(4020; "Lease Total Amount"; Decimal)
        {
            Caption = 'Lease Total Amount';
        }
        field(55020; "External Contract No."; Code[50])
        {
            Caption = 'External Contract No.';
        }
        field(4030; "Leasing Schedule No."; Code[20])
        {
            Caption = 'Leasing Schedule No.';
            TableRelation = "BLS Leasing Schedule Header";
        }
        field(4040; "Leasing Schedule Line No."; Integer)
        {
            Caption = 'Leasing Schedule Line No.';
        }
        field(4050; "Additional Service Amount"; Decimal)
        {
            Caption = 'Additional Service Amount';
        }
        field(5000; "BLS Service Ledger Entry No."; Integer)
        {
            Caption = 'BLS Service Ledger Entry No.';
            TableRelation = "BLS Ledger Entry";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        UnlinkServiceLedger;
    end;

    var
        BLSObject: Record "BLS Object";
        Customer: Record Customer;
        GLSetup: Record "General Ledger Setup";
        Service: Record "BLS Service";
        BLSMgt: Codeunit "BLS Management";
        ObjCodeMustBeEmptyErr: label 'Object must be empty for object type %1.';
        CreatedInvCnt: Integer;

    local procedure UnlinkServiceLedger()
    var
        ContractService: Record "DMS Contract Line";
        ServiceLedgEntry: Record "BLS Ledger Entry";
        DeleteQst: label 'Are You sure to delete calculation ledger entry with incorrect last calculation date? EPS Card No. %1';
    begin
        ServiceLedgEntry.Reset;
        ServiceLedgEntry.SetRange("Calculation Ledger Entry No.", "Entry No.");
        ServiceLedgEntry.ModifyAll("Calculation Ledger Entry No.", 0, false);


        if "Contract No." <> '' then begin
            ContractService.Reset;
            ContractService.SetRange("DMS Contract No.", "Contract No.");
            ContractService.SetRange("Service Code", "Service Code");
            ContractService.SetRange("Object Code", "Object Code");
            ContractService.SetRange("Last Calculation Date", "Period Ending Date");
            if ContractService.FindLast then begin
                if ContractService."Starting Date" >= "Period Starting Date" then
                    ContractService."Last Calculation Date" := 0D
                else
                    ContractService."Last Calculation Date" := "Period Starting Date" - 1;
                ContractService.Modify;
            end;
        end;
    end;


    procedure ShowContract()
    var
        Contract: Record Contract;
    begin
        if "Contract No." = '' then
            exit;

        begin
            Contract.Reset;
            Contract.SetRange("Contract No.", "Contract No.");
            Page.Run(Page::Contract, Contract);
        end;
    end;

    procedure SetInvCreated(CreatedInvCntPar: Integer)
    var

    begin
        CreatedInvCnt := CreatedInvCntPar;
    end;

    procedure GetInvCreated(): Integer

    begin
        exit(CreatedInvCnt);
    end;
}

