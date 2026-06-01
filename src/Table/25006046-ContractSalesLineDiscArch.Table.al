Table 25006046 "Contract Sales Line Disc.Arch."
{
    Caption = 'Contract Sales Line Discount Archive';
    DrillDownPageID = "Contract Sales Line Disc.Arch.";
    LookupPageID = "Contract Sales Line Disc.Arch.";

    fields
    {
        field(5; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            Description = 'Not Supported. Reserved for future.';
            OptionCaption = 'Quote,Contract';
            OptionMembers = Quote,Contract;
        }
        field(10; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(40; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item Category,Labor';
            OptionMembers = "Item Category",Labor;
        }
        field(50; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(Labor)) "Service Labor"."No."
            else
            if (Type = const("Item Category")) "Item Category".Code;
        }
        field(60; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(70; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(190; "Contract Expiration Date"; Date)
        {
            Caption = 'Contract Expiration Date';
        }
        field(220; "Line Discount %"; Decimal)
        {
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(240; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            Editable = false;
        }
        field(5047; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
    }

    keys
    {
        key(Key1; "Contract Type", "Contract No.", "Doc. No. Occurrence", "Version No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

