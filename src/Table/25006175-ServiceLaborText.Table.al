Table 25006175 "Service Labor Text"
{
    Caption = 'Service Labor Text';
    LookupPageID = "Service Labor Texts";

    fields
    {
        field(10; "Service Labor No."; Code[20])
        {
            Caption = 'Service Labor No.';
            TableRelation = "Service Labor";
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(40; "Description 3"; Text[50])
        {
            Caption = 'Description 3';
        }
        field(50; "Description 4"; Text[50])
        {
            Caption = 'Description 4';
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006175,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                if ServiceLabor.Get("Service Labor No.") then;
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Service Labor Text", FieldNo("Variable Field 25006800"),
                  ServiceLabor."Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006175,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                if ServiceLabor.Get("Service Labor No.") then;
                VFOptions.Reset;
                if cuLookupMgt.LookUpVariableField(VFOptions, Database::"Service Labor Text", FieldNo("Variable Field 25006801"),
                  ServiceLabor."Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Service Labor No.", "Variable Field 25006800", "Variable Field 25006801")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        cuVFMgt: Codeunit "Variable Field Management";
        cuLookupMgt: Codeunit LookUpManagement;
        ServiceLabor: Record "Service Labor";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        if ServiceLabor.Get("Service Labor No.") then;
        Clear(cuVFMgt);
        exit(cuVFMgt.IsVFActive(Database::"Service Labor Text", intFieldNo));
    end;
}

