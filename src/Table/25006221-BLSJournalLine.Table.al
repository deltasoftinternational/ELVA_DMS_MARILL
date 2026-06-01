Table 25006221 "BLS Journal Line"
{
    Caption = 'BLS Journal Line';

    fields
    {
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

            trigger OnValidate()
            begin
                Validate("Document Date", "Posting Date");
            end;
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
            TableRelation = Contract."Contract No." where("Use For Billing" = const(true));

            trigger OnValidate()
            begin
                if xRec."Contract No." <> "Contract No." then
                    Validate("Customer No.", '');

                if "Contract No." <> '' then begin
                    ContractDMS.Get("Contract No.");
                    ContractDMS.TestField("Use For Billing", true);
                    ContractDMS.TestField("Bill-to Customer No.");
                    Validate("Currency Code", ContractDMS."Currency Code");
                    Validate("Customer No.", ContractDMS."Bill-to Customer No.");
                end;

            end;
        }
        field(410; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if xRec."Customer No." <> "Customer No." then begin
                    "Customer Name" := '';
                    if "Contract No." = '' then
                        "Currency Code" := '';
                    "Customer Price Group" := '';
                    "Customer Discount Group" := '';
                end;

                if "Customer No." <> '' then begin
                    Customer.Get("Customer No.");
                    "Customer Name" := Customer.Name;
                    if "Contract No." = '' then begin
                        "Currency Code" := Customer."Currency Code";
                    end else begin
                        ContractDMS.Get("Contract No.");
                        ContractDMS.TestField("Bill-to Customer No.", "Customer No.");
                        ContractDMS.TestField("Currency Code", "Currency Code");
                    end;
                end;
            end;
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

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(470; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
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

            trigger OnValidate()
            begin
                if xRec."Service Code" <> "Service Code" then begin
                    "Service Description" := '';
                    "Unit of Measure Code" := '';
                    "Service Group Code" := '';
                    Validate("Service Variant Code", '');
                end;

                if "Service Code" <> '' then begin
                    Service.Get("Service Code");
                    "Service Description" := Service.Description;
                    "Unit of Measure Code" := Service."Base Unit of Measure Code";
                    "Service Group Code" := Service."Service Group Code";
                end;
            end;
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
        field(620; "Object Name"; Text[50])
        {
            Caption = 'Object Name';
        }
        field(700; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if Quantity <> 0 then begin
                    TestField("Service Code");
                    Quantity := BLSMgt.NormalizeServiceQty("Service Code", 0, Quantity);
                end;

                Validate("Unit Price");
            end;
        }
        field(710; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                GetGLSetup;
                "Total Price" := ROUND(Quantity * "Unit Price", GLSetup."Amount Rounding Precision");
                Validate("Discount, %");
            end;
        }
        field(720; "Total Price"; Decimal)
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
        field(730; "Discount, %"; Decimal)
        {
            BlankZero = true;
            Caption = 'Discount, %';

            trigger OnValidate()
            begin
                GetGLSetup;
                "Discount Amount" := ROUND("Total Price" * "Discount, %" / 100, GLSetup."Amount Rounding Precision");
                "Total Price Incl. Discount" := "Total Price" - "Discount Amount";
            end;
        }
        field(740; "Discount Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Discount Amount';
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if "Discount Amount" <> 0 then begin
                    TestField("Total Price");
                    GetGLSetup;
                    "Discount, %" := ROUND("Discount Amount" / "Total Price" * 100, GLSetup."Amount Rounding Precision");
                end;

                "Total Price Incl. Discount" := "Total Price" - "Discount Amount";
            end;
        }
        field(750; "Total Price Incl. Discount"; Decimal)
        {
            Caption = 'Total Price Incl. Discount';
            DecimalPlaces = 2 : 2;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Total Price Incl. Discount" <> 0 then begin
                    TestField("Total Price");
                    GetGLSetup;
                    "Discount Amount" := "Total Price" - "Total Price Incl. Discount";
                    "Discount, %" := ROUND("Discount Amount" / "Total Price" * 100, GLSetup."Amount Rounding Precision");
                end;
            end;
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
        field(3000; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            begin
                if ("Vehicle Serial No." <> '') then begin
                    if ("Contract No." = '') then begin
                        Validate("Contract No.", BLSMgt.GetContractByVehicle("Vehicle Serial No.", "Posting Date", true));
                    end else begin
                        if not BLSMgt.CheckVehicleInContract("Contract No.", "Vehicle Serial No.", "Posting Date") then
                            Error(VehicleOutOFContractErr, "Contract No.", "Vehicle Serial No.", "Posting Date");
                    end;
                end;
            end;
        }
        field(3001; "Veh. Make Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3002; "Veh. Model Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3003; "Veh. Model Version No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Version No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3004; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            FieldClass = FlowField;
        }
        field(4000; "Variable Field Run Start 1"; Decimal)
        {
            CaptionClass = '7,25006221,4000';
        }
        field(4010; "Variable Field Run Start 2"; Decimal)
        {
            CaptionClass = '7,25006221,4010';
        }
        field(4020; "Variable Field Run Start 3"; Decimal)
        {
            CaptionClass = '7,25006221,4020';
        }
        field(4100; "Variable Field Run End 1"; Decimal)
        {
            CaptionClass = '7,25006221,4100';
        }
        field(4110; "Variable Field Run End 2"; Decimal)
        {
            CaptionClass = '7,25006221,4110';
        }
        field(4120; "Variable Field Run End 3"; Decimal)
        {
            CaptionClass = '7,25006221,4120';
        }
        field(55020; "External Contract No."; Code[50])
        {
            Caption = 'External Contract No.';
            Editable = false;
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
        BLSJnlTemplate.Get("Journal Template Name");
        BLSJnlBatch.Get("Journal Template Name", "Journal Batch Name");
    end;

    var
        BLSJnlTemplate: Record "BLS Journal Template";
        BLSJnlBatch: Record "BLS Journal Batch";
        BLSJnlLine: Record "BLS Journal Line";
        BLSObject: Record "BLS Object";
        Contract: Record Contract;
        ContractDMS: Record Contract;
        Customer: Record Customer;
        GLSetup: Record "General Ledger Setup";
        Service: Record "BLS Service";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        BLSMgt: Codeunit "BLS Management";
        GLSetupRead: Boolean;
        PriceListTxt: label 'Price List';
        PreviouseTxt: label 'Previouse';
        ContractTxt: label 'Contract';
        VehicleOutOFContractErr: label 'Vehicle %1 is out of contract %2 at %3';
        VFMgt: Codeunit "Variable Field Management";

    procedure EmptyLine(): Boolean
    begin
        exit(("Service Code" = '') and (Quantity = 0));
    end;


    procedure SetUpNewLine(LastBLSJnlLine: Record "BLS Journal Line")
    begin
        BLSJnlTemplate.Get("Journal Template Name");
        BLSJnlBatch.Get("Journal Template Name", "Journal Batch Name");
        BLSJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        BLSJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if BLSJnlLine.FindFirst then begin
            "Posting Date" := LastBLSJnlLine."Posting Date";
            "Document Date" := LastBLSJnlLine."Posting Date";
            "Document No." := LastBLSJnlLine."Document No.";
            "Entry Type" := LastBLSJnlLine."Entry Type";
        end else begin
            "Posting Date" := WorkDate;
            "Document Date" := WorkDate;
            if BLSJnlBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                "Document No." := NoSeriesMgt.PeekNextNo(BLSJnlBatch."No. Series", "Posting Date");
            end;
        end;
        "Recurring Method" := LastBLSJnlLine."Recurring Method";
        "Source Code" := BLSJnlTemplate."Source Code";
        "Reason Code" := BLSJnlBatch."Reason Code";
        "Posting No. Series" := BLSJnlBatch."Posting No. Series";
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
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


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', "Journal Template Name", "Journal Batch Name", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure SetPrice()
    var
        GLSetup: Record "General Ledger Setup";
        CurrCode: Code[10];
        TextArr: array[5] of Text[50];
        WindowTxt: Text;
        ValueArr: array[5] of Decimal;
        NewPrice: Decimal;
        FaultReason: Option " ","In Process","Incorrect Input","Not in Contract","More Conditions","Other Source";
        Selection: Integer;
        ArrLength: Integer;
        PriceNotFoundErr: label 'Price is not found.';
        i: Integer;
    begin
        TestField("Service Code");
        TestField("Posting Date");
        TestField("Customer No.");

        Clear(TextArr);
        Clear(ValueArr);
        ArrLength := 0;

        if BLSMgt.GetServiceStandardPrice("Service Code", "Service Variant Code", "Object Code",
                                          "Customer No.", "Customer Price Group", "Posting Date",
                                          "Currency Code", Quantity, NewPrice)
        then begin
            ArrLength += 1;
            TextArr[ArrLength] := PriceListTxt;
            ValueArr[ArrLength] := NewPrice;
        end;

        if "Contract No." <> '' then begin
            BLSMgt.GetServiceContractPrice("Contract No.", "Service Code", "Service Variant Code", "Object Code",
                                            "Vehicle Serial No.", "Customer Price Group", "Posting Date",
                                            Quantity, NewPrice, FaultReason);
            if FaultReason = Faultreason::" " then begin
                ArrLength += 1;
                TextArr[ArrLength] := ContractTxt;
                ValueArr[ArrLength] := NewPrice;
            end;
        end;

        if ArrLength = 0 then
            Error(PriceNotFoundErr);

        GLSetup.Get;
        if "Currency Code" = '' then
            CurrCode := GLSetup."LCY Code"
        else
            CurrCode := "Currency Code";

        WindowTxt := '';
        for i := 1 to ArrLength do begin
            if i > 1 then
                WindowTxt := WindowTxt + ',';
            WindowTxt := WindowTxt + StrSubstNo('%1   (%2 %3)', TextArr[i], Format(ValueArr[i], 0, 1), CurrCode);
        end;

        Selection := StrMenu(WindowTxt, 1);
        if Selection = 0 then
            exit;

        Validate("Unit Price", ValueArr[Selection]);
    end;


    procedure SetDiscount()
    var
        TextArr: array[5] of Text[50];
        WindowTxt: Text;
        ValueArr: array[5] of Decimal;
        NewDiscount: Decimal;
        Selection: Integer;
        ArrLength: Integer;
        i: Integer;
    begin
        TestField("Service Code");
        TestField("Posting Date");
        TestField("Customer No.");

        Clear(TextArr);
        Clear(ValueArr);
        ArrLength := 0;

        ArrLength += 1;
        TextArr[ArrLength] := '0 %';
        ValueArr[ArrLength] := 0;

        if BLSMgt.GetServiceStandardDiscount("Service Code", "Service Variant Code", "Object Code",
                                             "Customer No.", "Customer Discount Group", "Posting Date",
                                             "Currency Code", Quantity, NewDiscount)
        then begin
            ArrLength += 1;
            TextArr[ArrLength] := PriceListTxt;
            ValueArr[ArrLength] := NewDiscount;
        end;

        if "Contract No." <> '' then
            if BLSMgt.GetServiceContractDiscount("Contract No.", "Service Code", "Service Variant Code", "Object Code",
                                                 "Customer Discount Group", "Posting Date",
                                                 Quantity, NewDiscount)
            then begin
                ArrLength += 1;
                TextArr[ArrLength] := ContractTxt;
                ValueArr[ArrLength] := NewDiscount;
            end;

        WindowTxt := TextArr[1];
        for i := 2 to ArrLength do
            WindowTxt := WindowTxt + ',' + StrSubstNo('%1   (%2 %)', TextArr[i], ValueArr[i]);

        Selection := StrMenu(WindowTxt, 1);
        if Selection = 0 then
            exit;

        Validate("Discount, %", ValueArr[Selection]);
    end;

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"BLS Journal Line", FieldNo));
    end;
}

