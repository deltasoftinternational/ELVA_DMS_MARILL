/*table 25006070 "Report Standard Text"
{
    Caption = 'Report Standard Text';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));
            end;
        }
        field(3; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Starting Date");
            end;
        }
        field(4; "Standard Text Code"; Code[20])
        {
            Caption = 'Standard Text Code';
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text";
        }
        field(5; "Report Caption"; Text[250])
        {
            Caption = 'Report Caption';
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report), "Object ID" = FIELD("Report ID")));
            Editable = false;
        }
        field(6; "Show in Bold"; Boolean)
        {
            Caption = 'Show in Bold';
            DataClassification = ToBeClassified;
        }
        field(7; "Show in Italic"; Boolean)
        {
            Caption = 'Show in Italic';
            DataClassification = ToBeClassified;
        }
        field(8; Sequence; Code[10])
        {
            Numeric = true;
            Caption = 'Sequence';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Report ID", "Starting Date", Sequence)
        {
            Clustered = true;
        }
    }
    var
        Text000: Label '%1 cannot be after %2';
}*/
