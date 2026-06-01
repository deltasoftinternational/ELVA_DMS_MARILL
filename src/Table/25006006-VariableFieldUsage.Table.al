Table 25006006 "Variable Field Usage"
{
    Caption = 'Variable Field Usage';
    LookupPageID = "Variable Field Usage";

    fields
    {
        field(10; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));

            trigger OnLookup()
            begin
                LookUpMgt.LookUpVariableUsageObject("Table No.");
                Validate("Table No.");
            end;
        }
        field(20; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));

            trigger OnLookup()
            begin
                LookUpMgt.LookUpVariableUsageField("Field No.", "Table No.");
                Validate("Field No.");
            end;
        }
        field(27; "Variable Field Group Code"; Code[10])
        {
            Caption = 'Variable Field Group Code';
            TableRelation = "Variable Field Group";

            trigger OnValidate()
            begin
                if Rec."Variable Field Group Code" <> xRec."Variable Field Group Code" then
                    "Variable Field Code" := ''
            end;
        }
        field(30; "Variable Field Code"; Code[10])
        {
            Caption = 'Variable Field Code';
            TableRelation = "Variable Field" where("Variable Field Group Code" = field("Variable Field Group Code"));

            trigger OnValidate()
            var
                VF: Record "Variable Field";
            begin
                if VF.Get("Variable Field Code") then
                    "Variable Field Group Code" := VF."Variable Field Group Code";
            end;
        }
        field(40; "Table Name"; Text[30])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object ID" = field("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "Table No.", "Field No.")
        {
            Clustered = true;
        }
        key(Key2; "Variable Field Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Rec.TestField("Variable Field Code")
    end;

    trigger OnModify()
    begin
        Rec.TestField("Variable Field Code")
    end;

    var
        LookUpMgt: Codeunit LookUpManagement;
}

