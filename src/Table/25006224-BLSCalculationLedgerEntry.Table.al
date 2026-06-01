Table 25006224 "BLS Calculation Ledger Entry"
{

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
        }
        field(140; "Service Variant Code"; Code[20])
        {
            Caption = 'Service Variant Code';
        }
        field(160; "Object Code"; Code[20])
        {
            Caption = 'Object Code';
            TableRelation = "BLS Object";
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
        }
        field(215; "Base Unit Price"; Decimal)
        {
            Caption = 'Base Unit Price';
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
        }
        field(410; "Discount Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Discount Amount';
            DecimalPlaces = 2 : 2;
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
        }
        field(430; Quantity; Decimal)
        {
            Caption = 'Quantity';
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
        field(2000; "Invoice Ledger Entry No."; Integer)
        {
            TableRelation = "BLS Invoicing Ledger Entry"."Entry No.";
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
        field(5000; "BLS Service Ledger Entry No."; Integer)
        {
            Caption = 'BLS Service Ledger Entry No.';
            TableRelation = "BLS Ledger Entry";
        }
        field(55020; "External Contract No."; Code[50])
        {
            Caption = 'External Contract No.';
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
        BLSMgt: Codeunit "BLS Management";

    local procedure UnlinkServiceLedger()
    var
        ServiceLedgEntry: Record "BLS Ledger Entry";
        DeleteQst: label 'Are You sure to delete calculation ledger entry with incorrect last calculation date? EPS Card No. %1';
    begin
        ServiceLedgEntry.Reset;
        ServiceLedgEntry.SetRange("Calculation Ledger Entry No.", "Entry No.");
        ServiceLedgEntry.ModifyAll("Calculation Ledger Entry No.", 0, false);
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
}

