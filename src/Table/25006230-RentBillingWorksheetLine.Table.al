Table 25006230 "Rent Billing Worksheet Line"
{
    Caption = 'Rent Billing Worksheet Line';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Process Line"; Boolean)
        {
            Caption = 'Process Line';
        }
        field(5; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            trigger OnValidate()
            var
                RentSalesLine: Record "Rent Sales Line";
            begin
                if ("Rent Sales Line No." <> 0) and RentSalesLine.Get("Document Type", "Document No.", "Rent Sales Line No.") then begin
                    RentSalesLine."To Invoice" := "To Invoice";
                    RentSalesLine.Modify();
                end;
            end;
        }
        field(10; "Document Type"; enum "Rent Document Type")
        {
            Caption = 'Document Type';
        }
        field(20; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Rent Header"."No.";
        }
        field(40; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';
            TableRelation = "Rent Item";
        }
        field(60; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Allocated,Rented,Returned';
            OptionMembers = " ","Allocated","Rented","Returned";
        }
        field(80; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(81; "Rent Line Description"; Text[100])
        {
            Caption = 'Rent Line Description';
        }
        field(90; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(95; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(100; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
        }
        field(105; "Rent Sales Line No."; Integer)
        {
            Caption = 'Rent Sales Line No.';
        }
        field(106; "Attach. to Rent Sales Line No."; Integer)
        {
            Caption = 'Attached to Rent Sales Line No.';
        }

        field(110; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            TableRelation = "Rent Asset";
            trigger OnLookup()
            var
                RentItemRelation: Record "Rent Item Relation";
                RentAsset: Record "Rent Asset";
            begin
                RentItemRelation.Reset;
                RentItemRelation.SetRange("Rent Item No.", "Rent Item No.");
                if RentItemRelation.FindSet then
                    repeat
                        if RentAsset.Get(RentItemRelation."Rent Asset No.") then
                            RentAsset.Mark(true);
                    until RentItemRelation.Next = 0;
                RentAsset.MarkedOnly(true);
                if Page.RunModal(0, RentAsset) = Action::LookupOK then
                    Validate("Rent Asset No.", RentAsset."No.");
            end;

            trigger OnValidate()
            var
                RentItemRelation: Record "Rent Item Relation";
                RentAsset: Record "Rent Asset";
            begin
                //RentPlanningMgt.UpdatePlanningEntriesLine(Rec);
                if "Rent Asset No." = '' then
                    "Serial No." := ''
                else begin
                    RentAsset.Get("Rent Asset No.");
                    "Serial No." := RentAsset."Serial No.";
                end;
                //UpdateStatus("Rent Asset No.");
            end;
        }
        field(130; "Rent Asset Quantity"; Decimal)
        {
            Caption = 'Rent Asset Quantity';
        }
        field(140; "Planned Shipment Date"; Date)
        {
            Caption = 'Planned Shipment Date';
        }
        field(145; "Planned Return Date"; Date)
        {
            Caption = 'Planned Return Date';
        }
        field(150; "Rent Period Type"; Code[20])
        {
            Caption = 'Rent Period Type';
            TableRelation = "Rent Period";
        }
        field(160; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(165; "Periods"; Decimal)
        {
            Caption = 'Rent Periods';
            trigger OnValidate()
            begin
                Validate(Quantity, Periods * "Rent Asset Quantity");
            end;
        }
        field(170; "Unit Price"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';
        }
        field(180; "Line Amount"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            Caption = 'Line Amount';
        }
        /*
        field(190; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Periods to Invoice';
            DecimalPlaces = 0 : 5;


        }
        */
        field(200; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Periods Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(210; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;


        }
        field(220; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';

        }
        /*
        field(230; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            Editable = false;

        }
        field(240; "Inv. Disc. Amount to Invoice"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            Editable = false;
        }
        
        field(250; "VAT Identifier"; Code[20])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        */
        field(260; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";


        }
        /*
        field(270; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;


        }
        field(280; "VAT Base Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(290; "Amount Including VAT"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;

        }
        field(300; "VAT Calculation Type"; Enum "Tax Calculation Type")
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
        }
        field(310; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(320; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";


        }
        field(330; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';


        }
        field(340; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;


        }
        field(350; "VAT Difference"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        */
        field(360; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";


        }
        field(370; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

        }
        field(380; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(390; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }

        field(400; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(450; "Actual Shipment Date"; Date)
        {
            CalcFormula = min("Rent Ledger Entry"."Shipment Date" where("Rent Order No." = field("Document No."),
                                                                         "Rent Order Type" = const(Order),
                                                                         "Rent Order Line No." = field("Line No."),
                                                                         "Rent Transfer Type" = const(Shipment),
                                                                         "Entry Type" = const(Inventory)
                                                                         ));
            Caption = 'Actual Shipment Date';
            Editable = false;
            FieldClass = FlowField;

        }
        field(460; "Actual Return Date"; Date)
        {
            CalcFormula = max("Rent Ledger Entry"."Shipment Date" where("Rent Order No." = field("Document No."),
                                                                         "Rent Order Type" = const(Order),
                                                                         "Rent Order Line No." = field("Line No."),
                                                                         "Rent Transfer Type" = const(Receipt),
                                                                         "Entry Type" = const(Inventory)
                                                                         ));
            Caption = 'Actual Return Date';
            Editable = false;
            FieldClass = FlowField;

        }
        field(470; "Rent Start Date"; Date)
        {
            Caption = 'Rent Start Date';

        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(485; "Rent End Date"; Date)
        {
            Caption = 'Rent End Date';

        }
        field(490; "Serial No."; Text[30])
        {
            Caption = 'Serial No.';
        }
        field(500; "Model Code"; Code[20])
        {
            Caption = 'Model';
        }
        field(510; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(520; "Campaign No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(530; "Last Date Invoiced"; Date)
        {
            Caption = 'Last Date Invoiced';
            DataClassification = ToBeClassified;
        }
        field(600; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            DataClassification = ToBeClassified;
            TableRelation = Vehicle;
        }
        field(1100; "VF Run 1 From"; Decimal)
        {
            CaptionClass = '7,25006230,1100';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1110; "VF Run 1 To"; Decimal)
        {
            CaptionClass = '7,25006230,1110';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1120; "VF Run 2 From"; Decimal)
        {
            CaptionClass = '7,25006230,1120';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1130; "VF Run 2 To"; Decimal)
        {
            CaptionClass = '7,25006230,1130';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1140; "VF Run 3 From"; Decimal)
        {
            CaptionClass = '7,25006230,1140';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1150; "VF Run 3 To"; Decimal)
        {
            CaptionClass = '7,25006230,1150';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(1200; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
        }
        field(1210; "Locked"; Boolean)
        {
            Caption = 'Locked';
        }
        field(1220; "Locks Line"; Integer)
        {
            Caption = 'Locks Line';
        }
        field(1230; "Quantity Shipped"; Decimal)
        {
            CalcFormula = Sum("Rent Ledger Entry"."Quantity" where("Rent Order No." = field("Document No."),
                                                                         "Rent Order Type" = const(Order),
                                                                         "Rent Order Line No." = field("Line No."),
                                                                         "Rent Transfer Type" = const(Shipment),
                                                                         "Document Type" = const(Receipt),
                                                                         "Entry Type" = const(Inventory)
                                                                         ));
            Caption = 'Quantity Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1240; "Quantity Returned"; Decimal)
        {
            CalcFormula = Sum("Rent Ledger Entry"."Quantity" where("Rent Order No." = field("Document No."),
                                                                         "Rent Order Type" = const(Order),
                                                                         "Rent Order Line No." = field("Line No."),
                                                                         "Rent Transfer Type" = const(Receipt),
                                                                         "Document Type" = const(Receipt),
                                                                         "Entry Type" = const(Inventory)
                                                                         ));
            Caption = 'Quantity Returned';
            Editable = false;
            FieldClass = FlowField;

        }
        //---------------- Added fields for worksheet
        field(3000; "Period Starting Date"; Date)
        {
            Caption = 'Invoice Period Starting Date';
        }
        field(3010; "Period Ending Date"; Date)
        {
            Caption = 'Invoice Period Ending Date';
        }
        field(3020; "Rent Type"; Enum "Rent Type")
        {
            Caption = 'Rent Type';
        }
        field(3030; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            TableRelation = Customer.Name;
            ValidateTableRelation = false;
        }
        field(3040; "Deal Type"; Code[10])
        {
            Caption = 'Deal Type';
            TableRelation = "Deal Type";
        }
        field(3050; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(3060; "Bill-to Customer Name"; Text[100])
        {
            Caption = 'Bill-to Customer Name';
            TableRelation = Customer.Name;
            ValidateTableRelation = false;
        }
        field(3070; "Overtime Calculation"; enum "Rent Overtime Calculation")
        {
            DataClassification = ToBeClassified;
        }
        field(3080; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Resource Unit of Measure".Code;
        }
        field(3090; "Extra Charge Line"; Boolean)
        {
            Caption = 'Extra Charge Line';

        }
        field(3100; Type; Enum "Sales Line Type")
        {
            Caption = 'Type';
        }
        field(3110; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item where("Item Type" = filter(" " | Item))
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const("External Service")) "External Service";

            trigger OnValidate()
            begin
                case Type of
                    Type::" ":
                        begin
                            StdTxt.Get("No.");
                            Description := StdTxt.Description;
                        end;
                    Type::"G/L Account":
                        begin
                            GLAcc.Get("No.");
                            GLAcc.CheckGLAcc;
                            Description := GLAcc.Name;
                            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                            "Tax Group Code" := GLAcc."Tax Group Code";
                            TestField("Gen. Prod. Posting Group");
                            TestField("VAT Prod. Posting Group");
                        end;
                    Type::Item:
                        begin
                            GetItem;
                            Description := Item.Description;
                            "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                            "Tax Group Code" := Item."Tax Group Code";
                            "Unit of Measure Code" := Item."Sales Unit of Measure";
                            TestField("Gen. Prod. Posting Group");
                            TestField("VAT Prod. Posting Group");
                        end;
                    Type::Resource:
                        begin
                            Res.Get("No.");
                            Description := Res.Name;
                            "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
                            "Tax Group Code" := Res."Tax Group Code";
                            TestField("Gen. Prod. Posting Group");
                            TestField("VAT Prod. Posting Group");
                        end;
                    Type::"Fixed Asset":
                        begin
                            FA.Get("No.");
                            FA.TestField(Inactive, false);
                            FA.TestField(Blocked, false);
                            Description := FA.Description;
                            GetFAPostingGroup;
                            TestField("Gen. Prod. Posting Group");
                            TestField("VAT Prod. Posting Group");
                        end;
                    Type::"Charge (Item)":
                        begin
                            ItemCharge.Get("No.");
                            Description := ItemCharge.Description;
                            "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
                            "Tax Group Code" := ItemCharge."Tax Group Code";
                            TestField("Gen. Prod. Posting Group");
                            TestField("VAT Prod. Posting Group");
                        end;
                end;

                if Type <> Type::" " then begin
                    if Type <> Type::"Fixed Asset" then
                        Validate("VAT Prod. Posting Group");
                    Validate("Unit of Measure Code");
                    //UpdateUnitPrice(FieldNo("No."));
                    //UpdateAmounts;
                end;

                //CallCreateDim;
            end;
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

    end;

    var
        BLSObject: Record "BLS Object";
        Customer: Record Customer;
        GLSetup: Record "General Ledger Setup";
        Service: Record "BLS Service";
        BLSMgt: Codeunit "BLS Management";
        ObjCodeMustBeEmptyErr: label 'Object must be empty for object type %1.';
        CreatedInvCnt: Integer;
        RentHeader: Record "Rent Header";
        VFMgt: Codeunit "Variable Field Management";
        StdTxt: Record "Standard Text";
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Resource: Record Resource;
        Res: Record Resource;
        FA: Record "Fixed Asset";
        ItemCharge: Record "Item Charge";
        Currency: Record Currency;
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";

    procedure SetInvCreated(CreatedInvCntPar: Integer)
    var

    begin
        CreatedInvCnt := CreatedInvCntPar;
    end;

    procedure GetInvCreated(): Integer

    begin
        exit(CreatedInvCnt);
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        SalesPricesIncVar: Integer;
    begin
        if not RentHeader.Get("Document Type", "Document No.") then begin
            RentHeader."No." := '';
            RentHeader.Init;
        end;
        if RentHeader."Prices Including VAT" then
            SalesPricesIncVar := 1
        else
            SalesPricesIncVar := 0;
        Clear(RentHeader);
        exit('2,' + Format(SalesPricesIncVar) + ',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        Field.Get(Database::"Rent Billing Worksheet Line", FieldNumber);
        exit(Field."Field Caption");
    end;

    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Billing Worksheet Line", intFieldNo));
    end;

    local procedure GetItem()
    begin
        TestField("No.");
        if "No." <> Item."No." then
            Item.Get("No.");
    end;

    local procedure GetFAPostingGroup()
    var
        LocalGLAcc: Record "G/L Account";
        FASetup: Record "FA Setup";
        FAPostingGr: Record "FA Posting Group";
        FADeprBook: Record "FA Depreciation Book";
    begin
        if (Type <> Type::"Fixed Asset") or ("No." = '') then
            exit;

        FAPostingGr.Get(FADeprBook."FA Posting Group");
        FAPostingGr.TestField("Acq. Cost Acc. on Disposal");
        LocalGLAcc.Get(FAPostingGr."Acq. Cost Acc. on Disposal");
        LocalGLAcc.CheckGLAcc;
        LocalGLAcc.TestField("Gen. Prod. Posting Group");
        "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
        "Tax Group Code" := LocalGLAcc."Tax Group Code";
        Validate("VAT Prod. Posting Group", LocalGLAcc."VAT Prod. Posting Group");
    end;

    local procedure UpdateUnitPrice(CalledByFieldNo: Integer)
    var
        TmpSalesLine: Record "Sales Line" temporary;
        TmpSalesHeader: Record "Sales Header" temporary;
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        GetRentHeader;
        TestField("Qty. per Unit of Measure");

        case Type of
            Type::Item, Type::Resource, Type::"External Service":
                begin
                    Clear(TmpSalesHeader);
                    Clear(TmpSalesLine);
                    TmpSalesHeader.Init;
                    TmpSalesHeader."No." := 'DummyNo';
                    TmpSalesHeader."Sell-to Customer No." := RentHeader."Sell-to Customer No.";
                    TmpSalesLine.Init;
                    TmpSalesLine."Sell-to Customer No." := RentHeader."Sell-to Customer No.";
                    TmpSalesLine."Document No." := TmpSalesHeader."No.";
                    TmpSalesLine."Document Type" := TmpSalesHeader."Document Type";
                    TmpSalesLine.Type := Type;
                    TmpSalesLine."No." := "No.";
                    // "Document Date" Rent Header, Location Code Rent Sales Line, "Bill-to Customer No."
                    PriceCalcMgt.FindSalesLinePrice(TmpSalesHeader, TmpSalesLine, CalledByFieldNo);
                    "Unit Price" := TmpSalesLine."Unit Price";
                end;
        end;
        Validate("Unit Price");
    end;

    local procedure GetRentHeader()
    begin
        TestField("Document No.");
        if ("Document Type" <> RentHeader."Document Type") or ("Document No." <> RentHeader."No.") then begin
            RentHeader.Get("Document Type", "Document No.");
            if RentHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                RentHeader.TestField("Currency Factor");
                Currency.Get(RentHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;

    procedure UpdateWrkshtVFRun(var RentWrkshtLine: Record "Rent Billing Worksheet Line"; RentLineFrom: Record "Rent Line")
    var
        RentSalesLineToCheck: Record "Rent Sales Line";
    begin
        RentSalesLineToCheck.Reset;
        RentSalesLineToCheck.SetRange("Document Type", RentLineFrom."Document Type");
        RentSalesLineToCheck.SetRange("Document No.", RentLineFrom."Document No.");
        RentSalesLineToCheck.SetRange("Attached to Rent Line No.", RentLineFrom."Line No.");
        //RentSalesLineToCheck.SetFilter("VF Run 1 To", '>%1', 0);
        if RentSalesLineToCheck.FindLast() then begin
            if RentSalesLineToCheck."VF Run 1 To" > 0 then
                RentWrkshtLine."VF Run 1 From" := RentSalesLineToCheck."VF Run 1 To";
        end else begin
            RentWrkshtLine."VF Run 1 From" := RentLineFrom."VF Run 1 From";
        end;

        RentSalesLineToCheck.Reset;
        RentSalesLineToCheck.SetRange("Document Type", RentLineFrom."Document Type");
        RentSalesLineToCheck.SetRange("Document No.", RentLineFrom."Document No.");
        RentSalesLineToCheck.SetRange("Attached to Rent Line No.", RentLineFrom."Line No.");
        //RentSalesLineToCheck.SetFilter("VF Run 2 To", '>%1', 0);
        if RentSalesLineToCheck.FindLast() then begin
            if RentSalesLineToCheck."VF Run 2 To" > 0 then
                RentWrkshtLine."VF Run 2 From" := RentSalesLineToCheck."VF Run 2 To";
        end else begin
            RentWrkshtLine."VF Run 2 From" := RentLineFrom."VF Run 2 From";
        end;

        RentSalesLineToCheck.Reset;
        RentSalesLineToCheck.SetRange("Document Type", RentLineFrom."Document Type");
        RentSalesLineToCheck.SetRange("Document No.", RentLineFrom."Document No.");
        RentSalesLineToCheck.SetRange("Attached to Rent Line No.", RentLineFrom."Line No.");
        //RentSalesLineToCheck.SetFilter("VF Run 3 To", '>%1', 0);
        if RentSalesLineToCheck.FindLast() then begin
            if RentSalesLineToCheck."VF Run 3 To" > 0 then
                RentWrkshtLine."VF Run 3 From" := RentSalesLineToCheck."VF Run 3 To";
        end else begin
            RentWrkshtLine."VF Run 3 From" := RentLineFrom."VF Run 3 From";
        end;
    end;

    procedure SetStyle() Style: Text
    var
        IsHandled: Boolean;
    begin
        OnBeforeSetStyle(Style, IsHandled);
        if IsHandled Then
            exit(Style);

        if Rec."Extra Charge Line" then
            exit('Unfavorable');
        exit('');
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeSetStyle(var Style: Text; var IsHandled: Boolean)
    begin
    end;
}

