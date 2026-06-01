Table 25006012 "Model Version Specification"
{
    // 04.06.2007. EDMS P2
    //   * Created table

    Caption = 'Model Version Specification';

    fields
    {
        field(1; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(4; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(10; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                recItem.Reset;
                if cuLookupMgt.LookUpModelVersion(recItem, "Model Version No.", "Make Code", "Model Code") then
                    "Model Version No." := recItem."No.";
            end;
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006012,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006012,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006012,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006803; "Variable Field 25006803"; Code[20])
        {
            CaptionClass = '7,25006012,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006803"),
                  "Make Code", "Variable Field 25006803") then begin
                    Validate("Variable Field 25006803", VFOptions.Code);
                end;
            end;
        }
        field(25006804; "Variable Field 25006804"; Code[20])
        {
            CaptionClass = '7,25006012,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006804"),
                  "Make Code", "Variable Field 25006804") then begin
                    Validate("Variable Field 25006804", VFOptions.Code);
                end;
            end;
        }
        field(25006805; "Variable Field 25006805"; Code[20])
        {
            CaptionClass = '7,25006012,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006805"),
                  "Make Code", "Variable Field 25006805") then begin
                    Validate("Variable Field 25006805", VFOptions.Code);
                end;
            end;
        }
        field(25006806; "Variable Field 25006806"; Code[20])
        {
            CaptionClass = '7,25006012,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006806"),
                  "Make Code", "Variable Field 25006806") then begin
                    Validate("Variable Field 25006806", VFOptions.Code);
                end;
            end;
        }
        field(25006807; "Variable Field 25006807"; Code[20])
        {
            CaptionClass = '7,25006012,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006807"),
                  "Make Code", "Variable Field 25006807") then begin
                    Validate("Variable Field 25006807", VFOptions.Code);
                end;
            end;
        }
        field(25006808; "Variable Field 25006808"; Code[20])
        {
            CaptionClass = '7,25006012,25006808';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006808"),
                  "Make Code", "Variable Field 25006808") then begin
                    Validate("Variable Field 25006808", VFOptions.Code);
                end;
            end;
        }
        field(25006809; "Variable Field 25006809"; Code[20])
        {
            CaptionClass = '7,25006012,25006809';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006809"),
                  "Make Code", "Variable Field 25006809") then begin
                    Validate("Variable Field 25006809", VFOptions.Code);
                end;
            end;
        }
        field(25006810; "Variable Field 25006810"; Code[20])
        {
            CaptionClass = '7,25006012,25006810';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006810"),
                  "Make Code", "Variable Field 25006810") then begin
                    Validate("Variable Field 25006810", VFOptions.Code);
                end;
            end;
        }
        field(25006811; "Variable Field 25006811"; Code[20])
        {
            CaptionClass = '7,25006012,25006811';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006811"),
                  "Make Code", "Variable Field 25006811") then begin
                    Validate("Variable Field 25006811", VFOptions.Code);
                end;
            end;
        }
        field(25006812; "Variable Field 25006812"; Code[20])
        {
            CaptionClass = '7,25006012,25006812';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006812"),
                  "Make Code", "Variable Field 25006812") then begin
                    Validate("Variable Field 25006812", VFOptions.Code);
                end;
            end;
        }
        field(25006813; "Variable Field 25006813"; Code[20])
        {
            CaptionClass = '7,25006012,25006813';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006813"),
                  "Make Code", "Variable Field 25006813") then begin
                    Validate("Variable Field 25006813", VFOptions.Code);
                end;
            end;
        }
        field(25006814; "Variable Field 25006814"; Code[20])
        {
            CaptionClass = '7,25006012,25006814';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006814"),
                  "Make Code", "Variable Field 25006814") then begin
                    Validate("Variable Field 25006814", VFOptions.Code);
                end;
            end;
        }
        field(25006815; "Variable Field 25006815"; Code[20])
        {
            CaptionClass = '7,25006012,25006815';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006815"),
                  "Make Code", "Variable Field 25006815") then begin
                    Validate("Variable Field 25006815", VFOptions.Code);
                end;
            end;
        }
        field(25006816; "Variable Field 25006816"; Code[20])
        {
            CaptionClass = '7,25006012,25006816';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006816"),
                  "Make Code", "Variable Field 25006816") then begin
                    Validate("Variable Field 25006816", VFOptions.Code);
                end;
            end;
        }
        field(25006817; "Variable Field 25006817"; Code[20])
        {
            CaptionClass = '7,25006012,25006817';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006817"),
                  "Make Code", "Variable Field 25006817") then begin
                    Validate("Variable Field 25006817", VFOptions.Code);
                end;
            end;
        }
        field(25006818; "Variable Field 25006818"; Code[20])
        {
            CaptionClass = '7,25006012,25006818';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006818"),
                  "Make Code", "Variable Field 25006818") then begin
                    Validate("Variable Field 25006818", VFOptions.Code);
                end;
            end;
        }
        field(25006819; "Variable Field 25006819"; Code[20])
        {
            CaptionClass = '7,25006012,25006819';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006819"),
                  "Make Code", "Variable Field 25006819") then begin
                    Validate("Variable Field 25006819", VFOptions.Code);
                end;
            end;
        }
        field(25006820; "Variable Field 25006820"; Code[20])
        {
            CaptionClass = '7,25006012,25006820';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Model Version Specification", FieldNo("Variable Field 25006820"),
                  "Make Code", "Variable Field 25006820") then begin
                    Validate("Variable Field 25006820", VFOptions.Code);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Make Code", "Model Code", "Model Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        cuLookupMgt: Codeunit LookUpManagement;
        cuVFMgt: Codeunit "Variable Field Management";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(cuVFMgt);
        exit(cuVFMgt.IsVFActive(Database::"Model Version Specification", intFieldNo));
    end;
}

