Table 25006213 "BLS Service"
{
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "BLS Service List";
    LookupPageID = "BLS Service List";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(100; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(101; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(110; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(120; "Base Unit of Measure Code"; Code[10])
        {
            Caption = 'Base Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;

            trigger OnValidate()
            var
                ResUnitOfMeasure: Record "Resource Unit of Measure";
                ResLedgEnty: Record "Res. Ledger Entry";
            begin
            end;
        }
        field(130; "Service Group Code"; Code[20])
        {
            Caption = 'Service Group Code';

            trigger OnValidate()
            begin
                /*
                IF (xRec."Service Group Code" <> "Service Group Code") AND ("Service Group Code" <> '') THEN BEGIN
                  ServiceGroup.GET("Service Group Code");
                  ServiceGroup.TESTFIELD(Blocked, FALSE);
                
                  "Calculation Period Code" := ServiceGroup."Calculation Period Code";
                  "Service Variant Mandatory" := ServiceGroup."Service Variant Mandatory";
                  "Object Mandatory" := ServiceGroup."Object Mandatory";
                  VALIDATE("Quantity Source", ServiceGroup."Quantity Source");
                  VALIDATE("Qty. Corr. For Partial Period", ServiceGroup."Qty. Corr. For Partial Period");
                  VALIDATE("Default Quantity", ServiceGroup."Default Quantity");
                  "Qty. Rounding Precision" := ServiceGroup."Qty. Rounding Precision";
                  "Qty. Rounding Type" := ServiceGroup."Qty. Rounding Type";
                  "Calculation Rounding Precision" := ServiceGroup."Calculation Rounding Precision";
                  "Calculation Rounding Type" := ServiceGroup."Calculation Rounding Type";
                  VALIDATE("Price Source", ServiceGroup."Price Source");
                  VALIDATE("Price Including VAT", ServiceGroup."Price Including VAT");
                  VALIDATE("Price Corr. For Partial Period", ServiceGroup."Price Corr. For Partial Period");
                  "Invoice Group Code" := ServiceGroup."Invoice Group Code";
                  "Gen. Prod. Posting Group" := ServiceGroup."Gen. Prod. Posting Group";
                  "VAT Prod. Posting Group" := ServiceGroup."VAT Prod. Posting Group";
                  "Calculation Period Code" := ServiceGroup."Calculation Period Code";
                  "Invoicing Period Code" := ServiceGroup."Invoicing Period Code";
                  // "Without Contract If Except" := ServiceGroup."Without Contract If Except";
                
                END;
                */

            end;
        }
        field(200; "Service Variant Mandatory"; Boolean)
        {
            Caption = 'Service Variant Mandatory';
        }
        field(205; "Combine Service Variants"; Option)
        {
            Caption = 'Combine Service Variants';
            OptionCaption = ' ,On Calculation,On Invoicing';
            OptionMembers = " ","On Calculation","On Invoicing";
        }
        field(210; "Object Mandatory"; Boolean)
        {
            Caption = 'Object Mandatory';
        }
        field(220; "Combine Objects"; Option)
        {
            Caption = 'Combine Objects';
            OptionCaption = ' ,On Calculation,On Invoicing';
            OptionMembers = " ","On Calculation","On Invoicing";
        }
        field(810; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(820; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(1000; "Quantity Source"; Option)
        {
            Caption = 'Quantity Source';
            OptionCaption = 'Contract,Service Ledger,Service Default';
            OptionMembers = Contract,"Service Ledger","Service Default";
        }
        field(1010; "Qty. Corr. For Partial Period"; Option)
        {
            Caption = 'Quantity Correction For Partial Period';
            OptionCaption = ' ,By Calendar Days,By Work Days';
            OptionMembers = " ","By Calendar Days","By Work Days";

            trigger OnValidate()
            begin
                if "Qty. Corr. For Partial Period" <> "qty. corr. for partial period"::" " then
                    Validate("Price Corr. For Partial Period", "price corr. for partial period"::" ");
            end;
        }
        field(1020; "Default Quantity"; Decimal)
        {
            Caption = 'Default Quantity';
        }
        field(1030; "Separate Entries"; Boolean)
        {
            Caption = 'Separate Entries';
        }
        field(1100; "Qty. Rounding Precision"; Decimal)
        {
            Caption = 'Quantity Rounding Precision';
            DecimalPlaces = 0 : 5;
            InitValue = 0;
        }
        field(1110; "Qty. Rounding Type"; Option)
        {
            Caption = 'Quantity Rounding Type';
            OptionCaption = 'Nearest,Up,Down';
            OptionMembers = Nearest,Up,Down;
        }
        field(1120; "Calculation Rounding Precision"; Decimal)
        {
            Caption = 'Calculation Rounding Precision';
            DecimalPlaces = 0 : 5;
            InitValue = 0;
        }
        field(1130; "Calculation Rounding Type"; Option)
        {
            Caption = 'Calculation Rounding Type';
            OptionCaption = 'Nearest,Up,Down';
            OptionMembers = Nearest,Up,Down;
        }
        field(2000; "Price Source"; Option)
        {
            Caption = 'Price Source';
            OptionCaption = 'Contract,Price List,Service Ledger';
            OptionMembers = Contract,"Price List","Service Ledger";
        }
        field(2010; "Price Including VAT"; Boolean)
        {
            Caption = 'Price Including VAT';
        }
        field(2020; "Price Corr. For Partial Period"; Option)
        {
            Caption = 'Price Correction For Partial Period';
            OptionCaption = ' ,By Calendar Days,By Work Days';
            OptionMembers = " ","By Calendar Days","By Work Days";

            trigger OnValidate()
            begin
                if "Price Corr. For Partial Period" <> "price corr. for partial period"::" " then
                    Validate("Qty. Corr. For Partial Period", "qty. corr. for partial period"::" ");
            end;
        }
        field(2030; "Calculate Average Price"; Option)
        {
            Caption = 'Calculate Average Price';
            OptionCaption = ' ,On Calculation,On Invoicing';
            OptionMembers = " ","On Calculation","On Invoicing";
        }
        field(2040; "Discount Usage"; Option)
        {
            Caption = 'Discount Usage';
            OptionCaption = ' ,Contract,All';
            OptionMembers = " ",Contract,All;
        }
        field(2050; "Price Period, Days"; Integer)
        {
            Caption = 'Price Period, Days';
        }
        field(3000; "Posting Type"; Option)
        {
            Caption = 'Posting Type';
            OptionCaption = ' ,G/L Account,Resource';
            OptionMembers = " ","G/L Account",Resource;

            trigger OnValidate()
            begin
                if xRec."Posting Type" <> "Posting Type" then
                    Validate("Posting No.", '');
            end;
        }
        field(3010; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            TableRelation = if ("Posting Type" = const("G/L Account")) "G/L Account"."No."
            else
            if ("Posting Type" = const(Resource)) Resource."No.";

            trigger OnValidate()
            begin
                if xRec."Posting No." <> "Posting No." then
                    "Posting Name" := '';

                if "Posting No." <> '' then
                    case "Posting Type" of
                        "posting type"::"G/L Account":
                            begin
                                GLAccount.Get("Posting No.");
                                GLAccount.TestField(Blocked, false);
                                "Posting Name" := GLAccount.Name;
                            end;

                        "posting type"::Resource:
                            begin
                                Resource.Get("Posting No.");
                                Resource.TestField(Blocked, false);
                                "Posting Name" := Resource.Name;
                            end;
                    end;
            end;
        }
        field(3020; "Posting Name"; Text[50])
        {
            Caption = 'Posting Name';
            Editable = false;
        }
        field(3030; "Invoice Line Description"; Text[50])
        {
            Caption = 'Invoice Line Description';
        }
        field(3040; "Invoice Line Addit.Description"; Text[250])
        {
            Caption = 'Invoice Line Additional Description';
        }
        field(3050; "Invoice Line Addit.Descriptio2"; Text[250])
        {
            Caption = 'Invoice Line Additional Description 2';
        }
        field(3100; "Invoice Group Code"; Code[20])
        {
            Caption = 'Invoice Group Code';
        }
        field(3110; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(3120; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(4000; "Calculation Period Code"; Code[20])
        {
            Caption = 'Calculation Period Code';
        }
        field(4010; "Invoicing Period Code"; Code[20])
        {
            Caption = 'Invoicing Period Code';
        }
        field(4020; "Without Invoicing"; Boolean)
        {
            Caption = 'Without Invoicing';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, "Base Unit of Measure Code", "Service Group Code", Blocked)
        {
        }
    }

    trigger OnDelete()
    begin
        if BLSMgt.ServiceIsInUse(Code) then
            Error(IsInUseErr, Code);

        DimMgt.DeleteDefaultDim(Database::"BLS Service", Code);
    end;

    var
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        GLAccount: Record "G/L Account";
        Resource: Record Resource;
        BLSMgt: Codeunit "BLS Management";
        DimMgt: Codeunit DimensionManagement;
        IsInUseErr: label 'Service %1 is in use.';


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        //DimMgt.SaveDefaultDim(Database::Table81201,Code,FieldNumber,ShortcutDimCode); //FIXME 
        Modify;
    end;


    procedure GetAddDescriptionBy(var TextLines: array[10] of Text[250]; LineLength: Integer)
    var
        ResultText: Text;
        LineText: Text;
        LineNo: Integer;
        LastPos: Integer;
    begin
        Clear(TextLines);

        if "Invoice Line Addit.Description" = '' then
            exit;

        if (LineLength <= 0) or (LineLength > 250) then
            LineLength := 250;

        LineNo := 0;
        ResultText := "Invoice Line Addit.Description";
        while (LineNo < 10) and (ResultText <> '') do begin
            LineNo += 1;
            TextLines[LineNo] := CopyStr(ResultText, 1, LineLength);
            if StrLen(ResultText) <= LineLength then
                ResultText := ''
            else
                ResultText := CopyStr(ResultText, LineLength + 1, StrLen(ResultText) - LineLength);
        end;
    end;

    local procedure GetLastWordPos(InText: Text; LineLength: Integer): Integer
    var
        LastPos: Integer;
    begin
        if InText = '' then
            exit(0);

        if StrLen(InText) <= LineLength then
            exit(LineLength);

        if CopyStr(InText, LineLength + 1, 1) in [' ', ',', '.'] then
            exit(LineLength + 1);

        LastPos := LineLength;
        /*
        REPEAT
        
        UNTIL (LastPos = 0) OR Is
        */

    end;

    local procedure GetWord(var InText: Text; MaxWordLength: Integer): Text[250]
    begin
        if InText = '' then
            exit('');

        /*
        WHILE COPYSTR(InText, 1, 1) IN [' ', ',', '.'] DO
          InText := COPYSTR(InText, 2, STRLEN(InText) -1);
        
        SepPos := STRPOS(InText, ' ');
        x := STRPOS(InText, ',');
        IF (x > 0) AND (x < SepPos) OR (SepPos = 0) THEN
          SepPos := x;
        x := STRPOS(InText, '.');
        IF (x > 0) AND (x < SepPos) OR (SepPos = 0) THEN
          SepPos := x;
        
        IF SepPos = 0 THEN
          ResText :=
        */

    end;


    procedure GetVATProdPostingGroup(): Code[10]
    begin
        if "VAT Prod. Posting Group" <> '' then
            exit("VAT Prod. Posting Group");

        if "Posting No." <> '' then
            case "Posting Type" of
                "posting type"::"G/L Account":
                    begin
                        if GLAccount.Get("Posting No.") then
                            exit(GLAccount."VAT Prod. Posting Group");
                    end;
                "posting type"::Resource:
                    begin
                        if Resource.Get("Posting No.") then
                            exit(Resource."VAT Prod. Posting Group");
                    end;
            end;

        exit('');
    end;
}

