Table 25006137 "External Serv. Ledger Entry"
{
    // 15.07.2008. EDMS P2
    //   * Added key "Ext. Service No.,Ext. Service Tracking No.,Entry Type"

    Caption = 'External Serv. Ledger Entry';
    DrillDownPageID = "Ext. Service Ledger Entries";
    LookupPageID = "Ext. Service Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "External Serv. No."; Code[20])
        {
            Caption = 'External Serv. No.';
            TableRelation = "External Service";
        }
        field(3; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(10; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(11; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = "External Serv. Tracking No."."External Serv. Tracking No." where("External Service No." = field("External Serv. No."));
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(28; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(30; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(31; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Customer)) Customer."No."
            else
            if ("Source Type" = const(Vendor)) Vendor."No.";
        }
        field(60; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(70; "Vehicle Serial No."; Code[20])
        {

        }
        field(80; "Vehicle Registration No."; Code[20])
        {

        }
        field(90; "VIN"; Code[20])
        {

        }
        field(100; "Make Code"; Code[20])
        {

        }
        field(110; "Model Code"; Code[20])
        {

        }
        field(120; "Service Order No."; Code[20])
        {

        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Posting Date")
        {
        }
        key(Key3; "External Serv. No.", "Posting Date")
        {
        }
        key(Key4; "External Serv. No.", "External Serv. Tracking No.", "Entry Type")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }


    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Entry No."));
    end;
}

