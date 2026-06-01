Table 25006612 "Rent Ledger Entry"
{
    DrillDownPageID = "Rent Ledger Entries";
    LookupPageID = "Rent Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Inventory,Sale,Cost';
            OptionMembers = Inventory,Sale,Cost;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(10; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(12; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(13; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
        }
        field(14; "Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';
        }
        field(15; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(16; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(17; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(18; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(20; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit UserProfileManagement;
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
        field(21; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(22; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(23; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(24; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(25; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(26; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(27; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(28; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(29; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(32; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(33; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        }
        field(34; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';
        }
        field(37; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = ,Shipment,Receipt,"Positive Adjmt.","Negative Adjmt.","Rent Order","Posted Sales Invoice","Posted Sales Cr.Memo";
        }
        field(38; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(39; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(40; "Transfer-from Code"; Code[20])      //Not used
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(41; "Transfer-to Code"; Code[20])        //Not used
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(42; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            TableRelation = "Rent Asset";
        }
        field(43; "Rent Order No."; Code[20])
        {
            Caption = 'Rent Order No.';
        }
        field(44; "Rent Order Type"; Option)
        {
            Caption = 'Rent Order Type';
            OptionMembers = Quote,"Order","Return Order";
        }
        field(45; "Rent Order Line No."; Integer)
        {
            Caption = 'Rent Order Line No.';
        }
        field(46; "Rent Transfer Type"; Option)
        {
            Caption = 'Rent Transfer Type';
            OptionMembers = Shipment,Receipt,Internal;
        }
        field(47; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(48; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(49; "Deal Type"; Code[10])
        {
            Caption = 'Deal Type';
            TableRelation = "Deal Type";

            trigger OnValidate()
            var
                tcDMS001: label 'Do you want to change lines too?';
            begin
            end;
        }
        field(50; "Rent Order Sales Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(53; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(58; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(59; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
        }
        field(60; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
        }
        field(61; "Line Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';
        }
        field(62; "Inv. Discount Amount"; Decimal)
        {
        }
        field(63; "Inv. Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Inv. Discount Amount (LCY)';
        }
        field(64; "Amount Including VAT (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
        }
        field(65; "Amount Including VAT"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(66; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(67; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(68; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(69; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(70; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(100; Type; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",,"External Service";

            trigger OnValidate()
            var
                TempSalesLine: Record "Sales Line" temporary;
            begin
            end;
        }
        field(110; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(120; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(130; "Available Quantity"; Decimal)
        {
            Caption = 'Available Quantity';
            DecimalPlaces = 0 : 5;
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
        field(570; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006165,570';
            DataClassification = ToBeClassified;
        }
        field(580; "Variable Field Run 2"; Decimal)
        {
            CaptionClass = '7,25006165,580';
            DataClassification = ToBeClassified;
        }
        field(590; "Variable Field Run 3"; Decimal)
        {
            CaptionClass = '7,25006165,590';
            DataClassification = ToBeClassified;
        }
        field(600; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
        }
        field(610; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = ToBeClassified;
        }
        field(620; Days; Integer)
        {
            Caption = 'Days';
            DataClassification = ToBeClassified;
        }
        field(630; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            DataClassification = ToBeClassified;
        }
        field(640; "Outstanding Qty."; Integer)
        {
            Caption = 'Outstanding Qty.';
            DataClassification = ToBeClassified;
        }
        field(650; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = ToBeClassified;
        }
        field(660; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            DataClassification = ToBeClassified;
            TableRelation = Vehicle;
        }
        field(670; VIN; Code[20])
        {
            Caption = 'VIN';
            DataClassification = ToBeClassified;
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
        key(Key3; "Rent Order No.", "Document No.", "Posting Date")
        {
        }
        key(Key4; "Rent Order No.", "Rent Order Line No.")
        {
        }
        key(Key5; "Rent Asset No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        VFMgt: Codeunit "Variable Field Management";

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Entry No."));
    end;

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Ledger Entry", FieldNo));
    end;
}

