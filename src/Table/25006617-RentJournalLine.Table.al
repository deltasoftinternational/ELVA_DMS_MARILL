Table 25006617 "Rent Journal Line"
{

    fields
    {
        field(10; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Rent Journal Template";
        }
        field(20; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Rent Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(50; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(60; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(70; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(80; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(90; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(100; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(110; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(120; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(130; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(160; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';
            TableRelation = "Rent Item";
        }
        field(190; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Inventory,Sale,Cost';
            OptionMembers = Inventory,Sale,Cost;
        }
        field(200; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = ,Shipment,Receipt,"Positive Adjmt.","Negative Adjmt.","Rent Order","Posted Sales Invoice","Posted Sales Cr.Memo";
        }
        field(210; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(220; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        /*
        field(230; "Transfer-from Code"; Code[20])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                Location: Record Location;
                Confirmed: Boolean;
            begin
            end;
        }
        field(240; "Transfer-to Code"; Code[20])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                Location: Record Location;
                Confirmed: Boolean;
            begin
            end;
        }
        */
        field(250; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(260; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            TableRelation = "Rent Asset";
        }
        field(270; "Rent Order No."; Code[20])
        {
            Caption = 'Rent Order No.';
        }
        field(280; "Rent Order Type"; Option)
        {
            Caption = 'Rent Order Type';
            OptionMembers = Quote,"Order","Return Order";
        }
        field(290; "Rent Order Line No."; Integer)
        {
            Caption = 'Rent Order Line No.';
        }
        field(295; "Rent Order Sales Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(300; "Rent Transfer Type"; Option)
        {
            Caption = 'Rent Transfer Type';
            OptionMembers = Shipment,Receipt,Internal;
        }
        field(310; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(320; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(330; "Deal Type"; Code[10])
        {
            Caption = 'Deal Type';
            TableRelation = "Deal Type";

            trigger OnValidate()
            var
                recServiceLine: Record "Service Line EDMS";
                tcDMS001: label 'Do you want to change lines too?';
            begin
            end;
        }
        field(340; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(350; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(360; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(370; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(380; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            var
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
                Validate(Quantity);
            end;
        }
        field(400; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                "Total Cost" := Quantity * "Unit Cost";
            end;
        }
        field(410; "Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';

            trigger OnValidate()
            begin
                TestField(Quantity);
                GetGLSetup;
                "Unit Cost" := ROUND("Total Cost" / Quantity, GLSetup."Unit-Amount Rounding Precision");
            end;
        }
        field(420; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                Amount := Quantity * "Unit Price";
            end;
        }
        field(430; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';

            trigger OnValidate()
            begin
                TestField(Quantity);
                GetGLSetup;
                "Unit Price" := ROUND(Amount / Quantity, GLSetup."Unit-Amount Rounding Precision");
            end;
        }
        field(440; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
        }
        field(450; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
        }
        field(460; "Line Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';
        }
        field(470; "Inv. Discount Amount"; Decimal)
        {
            Caption = 'Inv. Discount Amount';
        }
        field(475; "Inv. Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Inv. Discount Amount (LCY)';
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

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(490; "Amount Including VAT (LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
        }
        field(500; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(510; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(520; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(530; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(540; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(550; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(570; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006617,570';
            DataClassification = ToBeClassified;
        }
        field(580; "Variable Field Run 2"; Decimal)
        {
            CaptionClass = '7,25006617,580';
            DataClassification = ToBeClassified;
        }
        field(590; "Variable Field Run 3"; Decimal)
        {
            CaptionClass = '7,25006617,590';
            DataClassification = ToBeClassified;
        }
        field(600; Type; Option)
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
        field(610; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(612; "Service Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(620; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
        }
        field(630; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = ToBeClassified;
        }
        field(640; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            DataClassification = ToBeClassified;
            TableRelation = Vehicle;
        }
        field(650; VIN; Code[20])
        {
            Caption = 'VIN';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        LockTable;
        RentJnlTemplate.Get("Journal Template Name");
        RentJnlBatch.Get("Journal Template Name", "Journal Batch Name");

        ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
    end;

    var
        RentJnlTemplate: Record "Rent Journal Template";
        RentJnlBatch: Record "Rent Journal Batch";
        RentJnlLine: Record "Rent Journal Line";
        RentItem: Record "Rent Item";
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        GLSetupRead: Boolean;
        VFMgt: Codeunit "Variable Field Management";



    procedure SetUpNewLine(LastRentJnlLine: Record "Rent Journal Line")
    begin
        RentJnlTemplate.Get("Journal Template Name");
        RentJnlBatch.Get("Journal Template Name", "Journal Batch Name");
        RentJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        RentJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if RentJnlLine.FindFirst then begin
            "Posting Date" := LastRentJnlLine."Posting Date";
            "Document Date" := LastRentJnlLine."Document Date";
            "Document No." := LastRentJnlLine."Document No.";
        end else begin
            "Posting Date" := WorkDate;
            "Document Date" := WorkDate;
            if RentJnlBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                "Document No." := NoSeriesMgt.PeekNextNo(RentJnlBatch."No. Series", "Posting Date");
            end;
        end;
    end;



    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        Dimsource: List of [Dictionary of [Integer, code[20]]];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Type1, No1);
        DimMgt.AddDimSource(Dimsource, Type2, No2);
        DimMgt.AddDimSource(Dimsource, Type3, No3);
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, Dimsource, "Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1 %2 %3', "Journal Template Name", "Journal Batch Name", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Journal Line", intFieldNo));
    end;
}

