Table 25006136 "Service Package Version Line"
{
    // 19.02.2015 EDMS P21
    //   Modified Length from 30 to 50 for fields:
    //     70 Description
    //     80 "Description 2"
    // 
    // 18.03.2008. EDMS P2
    //   * Changed code CreateServLine

    Caption = 'Service Package Version Line';
    DrillDownPageID = "Service Lines Prep EDMS";
    LookupPageID = "Service Lines Prep EDMS";

    fields
    {
        field(2; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            NotBlank = true;
            TableRelation = "Service Package"."No.";
        }
        field(4; "Version No."; Integer)
        {
            Caption = 'Version No.';
            NotBlank = true;
            TableRelation = "Service Package Version"."Version No." where("Package No." = field("Package No."));
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(8; "Package Type"; Option)
        {
            Caption = 'Package Type';
            OptionCaption = 'Campaign Service Package,Service Package,Instruction';
            OptionMembers = "Campaign Service Package","Service Package",Instruction;
        }
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;
        }
        field(50; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Comment,G/L Account,Item,Labor,Ext. Service,Resource';
            OptionMembers = "Comment","G/L Account",Item,Labor,"Ext. Service",Resource;
        }
        field(60; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("Comment")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item where("Item Type" = const(Item))
            else
            if (Type = const(Labor)) "Service Labor"
            else
            if (Type = const("Ext. Service")) "External Service"
            else
            if (Type = const(Resource)) Resource;

            trigger OnValidate()
            begin
                case Type of
                    Type::"Comment":
                        begin
                            StandardText.Get("No.");
                            Description := StandardText.Description;
                        end;
                    Type::"G/L Account":
                        begin
                            GLAccount.Get("No.");
                            GLAccount.CheckGLAcc;
                            GLAccount.TestField("Direct Posting", true);
                            Description := GLAccount.Name;
                            Validate(Quantity, 1);
                        end;
                    Type::Item:
                        begin
                            Item.Get("No.");
                            Item.TestField("Item Type", Item."item type"::Item);
                            Description := Item.Description;
                            "Description 2" := Item."Description 2";
                            "Unit of Measure Code" := Item."Base Unit of Measure";
                        end;
                    Type::Labor:
                        begin
                            Labor.Get("No.");
                            Description := Labor.Description;
                            "Description 2" := Labor."Description 2";
                            "Unit of Measure Code" := Labor."Unit of Measure Code";
                            if not NotShowStandardTimeForm then
                                GetStandardTime;
                        end;
                    Type::"Ext. Service":
                        begin
                            ExtService.Get("No.");
                            Description := ExtService.Description;
                            "Description 2" := ExtService."Description 2";
                            "Unit of Measure Code" := ExtService."Unit of Measure Code";
                            Validate(Quantity, 1);
                        end;
                    Type::Resource:
                        begin
                            Resource.Get("No.");
                            Description := Resource.Name;
                            "Description 2" := Resource."Name 2";
                            "Unit of Measure Code" := Resource."Base Unit of Measure";
                        end;
                end;

                if Type <> Type::"Comment" then begin
                    Validate("Unit of Measure Code");
                    UpdateUnitPrice(FieldNo("No."));
                end;
            end;
        }
        field(70; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(80; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(90; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Quantity (Base)" := CalcBaseQty(Quantity);

                if (Type = Type::Item) and (CurrFieldNo <> FieldNo("No.")) then
                    UpdateUnitPrice(FieldNo(Quantity))
                else
                    Validate("Discount %");
            end;
        }
        field(100; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            "Unit of Measure";
        }
        field(110; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                Validate("Discount %");
            end;
        }
        field(111; "Discount %"; Decimal)
        {
            BlankZero = true;
            Caption = 'Discount %';

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(200; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(210; "Standard Time"; Decimal)
        {
            Caption = 'Standard Time';

            trigger OnValidate()
            begin
                Validate(Quantity, "Standard Time");
            end;
        }
        field(212; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            Editable = false;
        }
        field(220; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;

            trigger OnValidate()
            begin
                if ("Allow Invoice Disc." <> xRec."Allow Invoice Disc.") and
                   (not "Allow Invoice Disc.")
                then
                    UpdateAmounts;
            end;
        }
        field(230; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(240; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate(Quantity, "Quantity (Base)");
                UpdateUnitPrice(FieldNo("Quantity (Base)"));
            end;
        }
        field(60100; Group; Boolean)
        {
            Caption = 'Group';
        }
        field(60110; "Group ID"; Integer)
        {
            Caption = 'Group ID';
            TableRelation = "Service Package Version Line"."Line No." where("Package No." = field("Package No."),
                                                                             "Version No." = field("Version No."),
                                                                             Group = const(true));

            trigger OnLookup()
            var
                VersionSpec: Record "Service Package Version Line";
            begin
                if Group then
                    exit;

                VersionSpec.Reset;
                VersionSpec.SetRange("Package No.", "Package No.");
                VersionSpec.SetRange("Version No.", "Version No.");

                if LookUpMgt.LookUpServPackSpecGroup(VersionSpec, "Group ID") then
                    Validate("Group ID");
                CalcFields("Group Description");
            end;

            trigger OnValidate()
            begin
                CalcFields("Group Description");
            end;
        }
        field(60120; "Group Description"; Text[30])
        {
            CalcFormula = lookup("Service Package Version Line".Description where("Package No." = field("Package No."),
                                                                                   "Version No." = field("Version No."),
                                                                                   "Line No." = field("Group ID")));
            Caption = 'Group Description';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                VersionSpec: Record "Service Package Version Line";
            begin
                if Group then
                    exit;

                VersionSpec.Reset;
                VersionSpec.SetRange("Package No.", "Package No.");
                VersionSpec.SetRange("Version No.", "Version No.");

                if LookUpMgt.LookUpServPackSpecGroup(VersionSpec, "Group ID") then
                    Validate("Group ID");
                CalcFields("Group Description");
            end;
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006136,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Package Version Line", FieldNo("Variable Field 25006800"),
                  '', "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006136,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Package Version Line", FieldNo("Variable Field 25006801"),
                  '', "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006136,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Package Version Line", FieldNo("Variable Field 25006802"),
                  '', "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Package No.", "Version No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Line Amount", Quantity;
        }
        key(Key2; "Package Type", "Make Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GLAccount: Record "G/L Account";
        StandardText: Record "Standard Text";
        Item: Record Item;
        Labor: Record "Service Labor";
        ExtService: Record "External Service";
        LookUpMgt: Codeunit LookUpManagement;
        Currency: Record Currency;
        SPVersion: Record "Service Package Version";
        SPackage: Record "Service Package";
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        VFMgt: Codeunit "Variable Field Management";
        NotShowStandardTimeForm: Boolean;
        VehicleServicePlanStageTmp_CS: Record "Vehicle Service Plan Stage" temporary;
        Resource: Record "Resource";


    procedure CreateServLine(DocType: Option Quote,"Order","Return Order"; DocNo: Code[20])
    var
        ServLine: Record "Service Line EDMS";
        ServicePackage: Record "Service Package";
        LineNo: Integer;
    begin
        ServLine.Reset;
        ServLine.SetRange("Document Type", DocType);
        ServLine.SetRange("Document No.", DocNo);
        if ServLine.FindLast then
            LineNo := ServLine."Line No." + 10000
        else
            LineNo := 10000;

        ServLine.Init;
        ServLine."Line No." := LineNo;
        ServLine.Validate("Document Type", DocType);
        ServLine.Validate("Document No.", DocNo);
        ServLine.Insert;

        ServLine.Validate(Type, Type);

        //18.03.2008. EDMS P2 moved up this code>>
        ServLine."Package No." := "Package No.";
        ServLine."Package Version No." := "Version No.";
        ServLine."Package Version Spec. Line No." := "Line No.";
        //18.03.2008. EDMS P2 moved up this code<<

        ServLine.Validate("No.", "No.");
        //IF Type = Type::" " THEN
        ServLine.Description := Description;
        ServLine.Validate("Unit of Measure", "Unit of Measure Code");

        if Type <> Type::"Comment" then begin
            if Type = Type::"G/L Account" then begin
                ServLine.Validate("Line Discount %", "Discount %");  //21.02.2013 EDMS P8
                ServLine.Validate("Unit Price", "Unit Price");  //01.02.2013 EDMS P8
            end;
            ServLine."Standard Time" := "Standard Time";
            ServLine.Validate(Quantity, Quantity);
        end;

        //29.01.2010 EDMS P2 >>
        if ServicePackage.Get("Package No.") then
            ServLine."Campaign No." := ServicePackage."Campaign No.";
        //29.01.2010 EDMS P2 <<

        ServLine.Group := Group;
        ServLine."Group ID" := "Group ID";
        if ServLine."Group ID" <> 0 then
            ServLine."Group ID" += LineNo;

        FillServiceVariableFields(ServLine, Rec);

        ServLine."Plan No." := VehicleServicePlanStageTmp_CS."Plan No.";
        ServLine."Plan Stage Recurrence" := VehicleServicePlanStageTmp_CS.Recurrence;
        ServLine."Plan Stage Code" := VehicleServicePlanStageTmp_CS.Code;

        ServLine.Modify;
    end;


    procedure GetStandardTime()
    var
        StandTime: Record "Service Labor Standard Time";
    begin
        GetSPHeaders;

        StandTime.SetFilter("Make Code", "Make Code");
        if not StandTime.FindFirst then
            StandTime.SetRange("Make Code", '');
        StandTime.SetRange("Labor No.", "No.");
        if StandTime.IsEmpty then
            exit;

        StandTime.SetFilter("Prod. Year From", SPVersion."Prod. Year From");

        StandTime.SetFilter("Prod. Year To", SPVersion."Prod. Year To");


        if StandTime.Count <> 1 then begin
            if Page.RunModal(Page::"Service Labor Standard Times", StandTime) = Action::LookupOK then
                Validate("Standard Time", StandTime."Standard Time (Hours)");
        end else begin
            if StandTime.FindFirst then
                Validate("Standard Time", StandTime."Standard Time (Hours)");
        end;
    end;


    procedure fReplaceStr(a: Text[250]): Text[1024]
    var
        b: Text[1024];
        c: Integer;
    begin
        a := ConvertStr(a, ',;', '||');

        c := StrPos(a, '|');

        if c = 0 then exit('*' + a + '*');

        repeat
            if c <> 0 then begin
                b := b + CopyStr(a, 1, c - 1);
                a := CopyStr(a, c + 1);
            end
            else begin
                b := b + CopyStr(a, 1);
                a := '';
            end;

            b := b + '*';
            c := StrPos(a, '|');

            if (c <> 0) then
                b := b + '|*'
            else begin
                b := b + '|*' + a;
                a := '';
            end;
        until a = '';

        b := '*' + b + '*';

        exit(b);
    end;


    procedure UpdateAmounts()
    var
        LineDiscAmt: Decimal;
    begin
        TestField(Type);
        GetSPHeaders;

        LineDiscAmt :=
          ROUND(
            ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") *
            "Discount %" / 100, Currency."Amount Rounding Precision");

        if "Line Amount" <> ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") - LineDiscAmt then
            "Line Amount" := ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") - LineDiscAmt;
    end;

    local procedure GetSPHeaders()
    begin
        if ("Version No." <> SPVersion."Version No.") or ("Package No." <> SPVersion."Package No.") then
            SPVersion.Get("Package No.", "Version No.");

        if ("Package No." <> SPackage."No.") then begin
            SPackage.Get("Package No.");
            if SPackage."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                SPackage.TestField("Currency Factor");
                Currency.Get(SPackage."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;


    procedure UpdateUnitPrice(CalledByFieldNo: Integer)
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        GetSPHeaders;
        TestField("Qty. per Unit of Measure");

        case Type of
            Type::Item, Type::Labor, Type::"Ext. Service":
                begin
                    // DELTA SALESPRICE
                    PriceCalcMgt.FindDMSSPLineLineDisc(SPackage, Rec);
                    PriceCalcMgt.FindDMSSPLinePrice(SPackage, Rec, CalledByFieldNo);
                end;
        end;
        Validate("Unit Price");
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Service Package Version Line", intFieldNo));
    end;


    procedure SetNotShowTimeForm(NotShowForm1: Boolean)
    begin
        NotShowStandardTimeForm := NotShowForm1;
    end;


    procedure FillServiceVariableFields(var ServiceLine: Record "Service Line EDMS"; ServPackVerSpec: Record "Service Package Version Line")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        RecordRef.Open(Database::"Service Package Version Line");
        RecordRef.GetTable(ServPackVerSpec);
        RecordRef2.Open(Database::"Service Line EDMS");
        RecordRef2.GetTable(ServiceLine);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Package Version Line");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Service Line EDMS");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(ServiceLine);
    end;


    procedure NoAssistEdit()
    var
        NonstockItem: Record "Nonstock Item";
        NonstockItemMgt: Codeunit "Catalog Item Management";
    begin
        //EDMS
        if Type = Type::Item then begin
            NonstockItem.Reset;
            if LookUpMgt.LookUpNonstockItem(NonstockItem, "No.") then begin
                if NonstockItem."Item No." = '' then begin
                    NonstockItemMgt.NonstockAutoItem(NonstockItem);
                    NonstockItem.Get(NonstockItem."Entry No.");
                    Validate("No.", NonstockItem."Item No.");
                end
                else begin
                    Validate("No.", NonstockItem."Item No.");
                end;
            end;
        end;
    end;


    procedure SetCurrPlanStage(VehicleServicePlanStagePar: Record "Vehicle Service Plan Stage"): Integer
    begin
        Clear(VehicleServicePlanStageTmp_CS);
        VehicleServicePlanStageTmp_CS := VehicleServicePlanStagePar;
        exit(0);
    end;
}

