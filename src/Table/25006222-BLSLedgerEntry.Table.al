Table 25006222 "BLS Ledger Entry"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "BLS Journal Template";
        }
        field(20; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "BLS Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(100; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(110; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(120; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(140; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(150; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(160; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Sale,Purchase';
            OptionMembers = Sale,Purchase;
        }
        field(400; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(410; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(420; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
        }
        field(430; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(440; "Customer Discount Group"; Code[20])
        {
            Caption = 'Customer Discount Group';
            TableRelation = "Customer Discount Group";
        }
        field(450; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(460; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(470; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
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
        field(500; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            NotBlank = true;
            TableRelation = "BLS Service".Code;
        }
        field(510; "Service Variant Code"; Code[20])
        {
            Caption = 'Service Variant Code';
        }
        field(520; "Service Description"; Text[50])
        {
            Caption = 'Service Description';
        }
        field(530; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;

            trigger OnValidate()
            var
                ResourceUnitOfMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }
        field(540; "Calculation Period Code"; Code[20])
        {
            Caption = 'Calculation Period Code';
        }
        field(550; "Service Group Code"; Code[20])
        {
            Caption = 'Service Group Code';
        }
        field(610; "Object Code"; Code[20])
        {
            Caption = 'Object Code';
        }
        field(620; "Object Name"; Text[50])
        {
            Caption = 'Object Name';
        }
        field(700; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(710; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(720; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(730; "Discount, %"; Decimal)
        {
            BlankZero = true;
            Caption = 'Discount, %';
        }
        field(740; "Discount Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Discount Amount';
            DecimalPlaces = 2 : 2;
        }
        field(750; "Total Price Incl. Discount"; Decimal)
        {
            Caption = 'Total Price Incl. Discount';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
        }
        field(800; "Recurring Method"; Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(810; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(820; "Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
        }
        field(840; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(850; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(860; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(900; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(910; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(920; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit UserProfileManagement;
            begin
                UserMgt.LookupUserID("Journal Batch Name");
            end;
        }
        field(1000; "Quantity (Balance)"; Decimal)
        {
            Caption = 'Quantity (Balance)';
            DecimalPlaces = 0 : 5;
        }
        field(1020; "Total Price (Balance)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price (Balance)';
        }
        field(1050; "Total Price Incl. Disc. (Bal.)"; Decimal)
        {
            Caption = 'Total Price Incl. Discount (Balance)';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
        }
        field(2000; "Calculation Ledger Entry No."; Integer)
        {
            Caption = 'Calculation Ledger Entry No.';
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
        field(4000; "Variable Field Run Start 1"; Decimal)
        {
            CaptionClass = '7,25006222,4000';
        }
        field(4010; "Variable Field Run Start 2"; Decimal)
        {
            CaptionClass = '7,25006222,4010';
        }
        field(4020; "Variable Field Run Start 3"; Decimal)
        {
            CaptionClass = '7,25006222,4020';
        }
        field(4100; "Variable Field Run End 1"; Decimal)
        {
            CaptionClass = '7,25006222,4100';
        }
        field(4110; "Variable Field Run End 2"; Decimal)
        {
            CaptionClass = '7,25006222,4110';
        }
        field(4120; "Variable Field Run End 3"; Decimal)
        {
            CaptionClass = '7,25006222,4120';
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
        key(Key2; "Document No.", "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit DimensionManagement;
        VFMgt: Codeunit "Variable Field Management";


    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Entry No."));
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

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"BLS Ledger Entry", FieldNo));
    end;
}

