Table 25006122 "Service Labor Standard Time"
{
    Caption = 'Service Labor Standard Time';
    LookupPageID = "Service Labor Standard Times";

    fields
    {
        field(6; "Labor No."; Code[20])
        {
            Caption = 'Labor No.';
            NotBlank = true;
            TableRelation = "Service Labor"."No.";

            trigger OnValidate()
            var
                ServiceLabor: Record "Service Labor";
            begin
                ServiceLabor.Reset;
                if ServiceLabor.Get("Labor No.") then
                    "Make Code" := ServiceLabor."Make Code";
            end;
        }
        field(9; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;
        }
        field(11; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(30; "Prod. Year From"; Code[4])
        {
            Caption = 'Prod. Year From';
        }
        field(40; "Prod. Year To"; Code[4])
        {
            Caption = 'Prod. Year To';
        }
        field(180; "Standard Time (Hours)"; Decimal)
        {
            Caption = 'Standard Time (Hours)';
        }
        field(260; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(270; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006122,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Service Labor Standard Time", FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006122,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Service Labor Standard Time", FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006122,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Service Labor Standard Time", FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006803; "Variable Field 25006803"; Code[20])
        {
            CaptionClass = '7,25006122,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Service Labor Standard Time", FieldNo("Variable Field 25006803"),
                  "Make Code", "Variable Field 25006803") then begin
                    Validate("Variable Field 25006803", VFOptions.Code);
                end;
            end;
        }
        field(25006804; "Variable Field 25006804"; Code[20])
        {
            CaptionClass = '7,25006122,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Service Labor Standard Time", FieldNo("Variable Field 25006804"),
                  "Make Code", "Variable Field 25006804") then begin
                    Validate("Variable Field 25006804", VFOptions.Code);
                end;
            end;
        }
        field(25006805; "Variable Field 25006805"; Code[20])
        {
            CaptionClass = '7,25006122,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Service Labor Standard Time", FieldNo("Variable Field 25006805"),
                  "Make Code", "Variable Field 25006805") then begin
                    Validate("Variable Field 25006805", VFOptions.Code);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Labor No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Make Code", "Model Code", "Prod. Year From", "Prod. Year To")
        {
        }
    }

    fieldgroups
    {
    }

    var
        VFMgt: Codeunit "Variable Field Management";
        LookupMgt: Codeunit LookUpManagement;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Service Labor Standard Time", intFieldNo));
    end;
}

