Table 25006608 "Rent Period"
{
    Caption = 'Rent Period';
    DrillDownPageID = "Rent Period List";
    LookupPageID = "Rent Period List";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }
        field(50; Duration; DateFormula)
        {
            Caption = 'Duration';
        }
        field(60; "Variable Field Run 1"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006608,60';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(70; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006608,70';
            DataClassification = ToBeClassified;
        }
        field(80; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006608,80';
            DataClassification = ToBeClassified;
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
    }

    var
        VFMgt: Codeunit "Variable Field Management";

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Period", FieldNo));
    end;
}

