Table 25006008 "VIN Decoding"
{
    // 30.03.2007. EDMS P2
    //   *Added new code on function fGetRightField for right working if not put "Make code" in table "Variable Field Usage"
    // 
    // 25.01.2007. EDMS P2
    //   added new fields
    // 
    // 24.01.2007. EDMS P2
    //   added new fields
    //   added new functions
    // 
    // 23.01.2007. EDMS P2
    //  deleted old fields and added new fields
    //  added new function FDecode which takes VIN of vehicle and fill needed fields

    Caption = 'VIN Decoding';
    DrillDownPageID = "Resource Skills EDMS";
    LookupPageID = "Resource Skills EDMS";

    fields
    {
        field(3; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(5; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; Position; Code[10])
        {
            Caption = 'Position';
            NotBlank = true;
        }
        field(20; Combination; Code[10])
        {
            Caption = 'Combination';
            NotBlank = true;
        }
        field(30; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code;
        }
        field(35; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No.";
        }
        field(45; "Parent Entry No."; Integer)
        {
            Caption = 'Parent Entry No.';
        }
        field(55; "Primary Entry"; Boolean)
        {
            Caption = 'Primary Entry';
        }
        field(65; "Combination Value Field"; Code[10])
        {
            Caption = 'Combination Value Field';
            TableRelation = "Variable Field";
        }
        field(75; "Forbidden Symbols Field"; Text[250])
        {
            Caption = 'Forbidden Symbols Field';
        }
        field(85; "VIN Lenght"; Integer)
        {
            Caption = 'VIN Lenght';
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006008,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006008,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006008,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006803; "Variable Field 25006803"; Code[20])
        {
            CaptionClass = '7,25006008,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006803"),
                  "Make Code", "Variable Field 25006803") then begin
                    Validate("Variable Field 25006803", VFOptions.Code);
                end;
            end;
        }
        field(25006804; "Variable Field 25006804"; Code[20])
        {
            CaptionClass = '7,25006008,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006804"),
                  "Make Code", "Variable Field 25006804") then begin
                    Validate("Variable Field 25006804", VFOptions.Code);
                end;
            end;
        }
        field(25006805; "Variable Field 25006805"; Code[20])
        {
            CaptionClass = '7,25006008,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006805"),
                  "Make Code", "Variable Field 25006805") then begin
                    Validate("Variable Field 25006805", VFOptions.Code);
                end;
            end;
        }
        field(25006806; "Variable Field 25006806"; Code[20])
        {
            CaptionClass = '7,25006008,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006806"),
                  "Make Code", "Variable Field 25006806") then begin
                    Validate("Variable Field 25006806", VFOptions.Code);
                end;
            end;
        }
        field(25006807; "Variable Field 25006807"; Code[20])
        {
            CaptionClass = '7,25006008,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006807"),
                  "Make Code", "Variable Field 25006807") then begin
                    Validate("Variable Field 25006807", VFOptions.Code);
                end;
            end;
        }
        field(25006808; "Variable Field 25006808"; Code[20])
        {
            CaptionClass = '7,25006008,25006808';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006808"),
                  "Make Code", "Variable Field 25006808") then begin
                    Validate("Variable Field 25006808", VFOptions.Code);
                end;
            end;
        }
        field(25006809; "Variable Field 25006809"; Code[20])
        {
            CaptionClass = '7,25006008,25006809';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006809"),
                  "Make Code", "Variable Field 25006809") then begin
                    Validate("Variable Field 25006809", VFOptions.Code);
                end;
            end;
        }
        field(25006810; "Variable Field 25006810"; Code[20])
        {
            CaptionClass = '7,25006008,25006810';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006810"),
                  "Make Code", "Variable Field 25006810") then begin
                    Validate("Variable Field 25006810", VFOptions.Code);
                end;
            end;
        }
        field(25006811; "Variable Field 25006811"; Code[20])
        {
            CaptionClass = '7,25006008,25006811';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006811"),
                  "Make Code", "Variable Field 25006811") then begin
                    Validate("Variable Field 25006811", VFOptions.Code);
                end;
            end;
        }
        field(25006812; "Variable Field 25006812"; Code[20])
        {
            CaptionClass = '7,25006008,25006812';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006812"),
                  "Make Code", "Variable Field 25006812") then begin
                    Validate("Variable Field 25006812", VFOptions.Code);
                end;
            end;
        }
        field(25006813; "Variable Field 25006813"; Code[20])
        {
            CaptionClass = '7,25006008,25006813';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006813"),
                  "Make Code", "Variable Field 25006813") then begin
                    Validate("Variable Field 25006813", VFOptions.Code);
                end;
            end;
        }
        field(25006814; "Variable Field 25006814"; Code[20])
        {
            CaptionClass = '7,25006008,25006814';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006814"),
                  "Make Code", "Variable Field 25006814") then begin
                    Validate("Variable Field 25006814", VFOptions.Code);
                end;
            end;
        }
        field(25006815; "Variable Field 25006815"; Code[20])
        {
            CaptionClass = '7,25006008,25006815';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"VIN Decoding", FieldNo("Variable Field 25006815"),
                  "Make Code", "Variable Field 25006815") then begin
                    Validate("Variable Field 25006815", VFOptions.Code);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Make Code", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        VFMgt: Codeunit "Variable Field Management";
        LookupMgt: Codeunit LookUpManagement;
        VINDecoding: Record "VIN Decoding";
        MakeCode: Code[20];


    procedure Decode2(var recVehicle: Record Vehicle)
    var
        intParent: Integer;
    begin
        intParent := FindMakeCode(recVehicle);
        CheckVINLenght(recVehicle, intParent);
        if intParent <> -1 then
        
            FindChilds(recVehicle, intParent);
    end;


    procedure CheckVINLenght(recVehicle: Record Vehicle; intEntryNo: Integer)
    var
        intVINLenght: Integer;
        txtDMS100: label 'Quantity of VIN symbols must be %1.';
        i: Integer;
        i2: Integer;
        i3: Integer;
        codForbiddenSymbol: Code[17];
        intForbiddenSymbol: Integer;
        txtDMS101: label 'VIN must not consist from %1.';
        recVINDecoding: Record "VIN Decoding";
        test: Text[30];
    begin
        intVINLenght := StrLen(recVehicle.VIN);
        recVINDecoding.Reset;
        if recVINDecoding.Get(MakeCode, intEntryNo) then;
        if (intVINLenght <> recVINDecoding."VIN Lenght") and (recVINDecoding."VIN Lenght" <> 0) then
            Error(StrSubstNo(txtDMS100, recVINDecoding."VIN Lenght"));


        if recVINDecoding."Forbidden Symbols Field" <> '' then begin

            for i := 1 to intVINLenght do
                if CopyStr(recVehicle.VIN, i, 1) = ',' then
                    Error(StrSubstNo(txtDMS101, ','));

            for i := 1 to StrLen(recVINDecoding."Forbidden Symbols Field") + 1 do begin
                if (CopyStr(recVINDecoding."Forbidden Symbols Field", i, 1) = ',') or
                 (i = StrLen(recVINDecoding."Forbidden Symbols Field") + 1) then begin
                    intForbiddenSymbol := StrLen(codForbiddenSymbol);
                    for i2 := 1 to intVINLenght - intForbiddenSymbol + 1 do begin
                        if CopyStr(recVehicle.VIN, i2, intForbiddenSymbol) = codForbiddenSymbol then
                            Error(StrSubstNo(txtDMS101, codForbiddenSymbol));
                    end;
                    codForbiddenSymbol := '';
                end
                else
                    codForbiddenSymbol := codForbiddenSymbol + CopyStr(recVINDecoding."Forbidden Symbols Field", i, 1);
            end;
        end;
    end;


    procedure FindMakeCode(var recVehicle: Record Vehicle): Integer
    var
        recVINDecoding: Record "VIN Decoding";
        intReturnValue: Integer;
    begin
        recVINDecoding.Reset;
        recVINDecoding.SetRange("Primary Entry", true);
        if recVINDecoding.FindSet then
            repeat
                if CheckValues(recVehicle, recVINDecoding) then begin
                    MakeCode := recVINDecoding."Make Code";
                    recVehicle."Make Code" := recVINDecoding."Make Code";
                    intReturnValue := recVINDecoding."Entry No.";
                    exit(intReturnValue);
                end;
            until recVINDecoding.Next = 0;
        exit(-1);
    end;


    procedure FindChilds(var recVehicle: Record Vehicle; intParent: Integer)
    var
        recVINDecoding: Record "VIN Decoding";
        codVINValue: Code[17];
    begin
        recVINDecoding.Reset;
        recVINDecoding.SetRange("Primary Entry", false);
        recVINDecoding.SetRange("Make Code", MakeCode);
        recVINDecoding.SetRange("Parent Entry No.", intParent);
        if recVINDecoding.FindSet then
            repeat
                if recVINDecoding."Combination Value Field" <> '' then begin
                    codVINValue := CheckValues2(recVehicle, recVINDecoding);
                    GetRightField2(recVehicle, recVINDecoding."Combination Value Field", codVINValue);
                end
                else
                    if CheckValues(recVehicle, recVINDecoding) then begin
                        if (recVINDecoding."Model Code" <> '') then
                            recVehicle."Model Code" := recVINDecoding."Model Code";
                        if (recVINDecoding."Model Version No." <> '') then
                            recVehicle."Model Version No." := recVINDecoding."Model Version No.";

                        if (recVINDecoding."Variable Field 25006800" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006800"),
                             recVINDecoding."Variable Field 25006800");
                        if (recVINDecoding."Variable Field 25006801" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006801"),
                             recVINDecoding."Variable Field 25006801");
                        if (recVINDecoding."Variable Field 25006802" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006802"),
                             recVINDecoding."Variable Field 25006802");
                        if (recVINDecoding."Variable Field 25006803" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006803"),
                             recVINDecoding."Variable Field 25006803");
                        if (recVINDecoding."Variable Field 25006804" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006804"),
                             recVINDecoding."Variable Field 25006804");
                        if (recVINDecoding."Variable Field 25006805" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006805"),
                             recVINDecoding."Variable Field 25006805");
                        if (recVINDecoding."Variable Field 25006806" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006806"),
                             recVINDecoding."Variable Field 25006806");
                        if (recVINDecoding."Variable Field 25006807" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006807"),
                             recVINDecoding."Variable Field 25006807");
                        if (recVINDecoding."Variable Field 25006808" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006808"),
                             recVINDecoding."Variable Field 25006808");
                        if (recVINDecoding."Variable Field 25006809" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006809"),
                             recVINDecoding."Variable Field 25006809");
                        if (recVINDecoding."Variable Field 25006810" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006810"),
                             recVINDecoding."Variable Field 25006810");
                        if (recVINDecoding."Variable Field 25006811" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006811"),
                             recVINDecoding."Variable Field 25006811");
                        if (recVINDecoding."Variable Field 25006812" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006812"),
                             recVINDecoding."Variable Field 25006812");
                        if (recVINDecoding."Variable Field 25006813" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006813"),
                             recVINDecoding."Variable Field 25006813");
                        if (recVINDecoding."Variable Field 25006814" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006814"),
                             recVINDecoding."Variable Field 25006814");
                        if (recVINDecoding."Variable Field 25006815" <> '') then
                            GetRightField(recVehicle, recVINDecoding.FieldNo("Variable Field 25006815"),
                             recVINDecoding."Variable Field 25006815");

                        FindChilds(recVehicle, recVINDecoding."Entry No.");
                    end;
            until recVINDecoding.Next = 0;
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"VIN Decoding", intFieldNo));
    end;


    procedure GetRightField(var recVehicle: Record Vehicle; intFieldNo: Integer; codValue: Code[20])
    var
        refRecordRef2: RecordRef;
        refFieldRef: FieldRef;
        recVFUsage: Record "Variable Field Usage";
        recVFUsage1: Record "Variable Field Usage";
    begin
        //MK DMS 24.01.2007. -->
        refRecordRef2.Open(Database::Vehicle);
        refRecordRef2.GetTable(recVehicle);
        recVFUsage.Reset;
        recVFUsage.SetRange("Table No.", Database::"VIN Decoding");
        recVFUsage.SetRange("Field No.", intFieldNo);

        if recVFUsage.FindFirst then
            repeat
                recVFUsage1.Reset;
                recVFUsage1.SetCurrentkey("Variable Field Code");
                recVFUsage1.SetRange("Table No.", Database::Vehicle);
                recVFUsage1.SetRange("Variable Field Code", recVFUsage."Variable Field Code");
                if recVFUsage1.FindFirst then begin
                    refFieldRef := refRecordRef2.Field(recVFUsage1."Field No.");
                    refFieldRef.Value(codValue);
                end;
            until recVFUsage.Next = 0;
        refRecordRef2.SetTable(recVehicle);
    end;


    procedure GetRightField2(var recVehicle: Record Vehicle; codVariableField: Code[10]; codVINValue: Code[17])
    var
        refRecordRef2: RecordRef;
        refFieldRef: FieldRef;
        recVFUsage1: Record "Variable Field Usage";
    begin
        refRecordRef2.Open(Database::Vehicle);
        refRecordRef2.GetTable(recVehicle);

        recVFUsage1.Reset;
        recVFUsage1.SetCurrentkey("Variable Field Code");
        recVFUsage1.SetRange("Table No.", Database::Vehicle);
        recVFUsage1.SetRange("Variable Field Code", codVariableField);

        if recVFUsage1.FindFirst then begin
            refFieldRef := refRecordRef2.Field(recVFUsage1."Field No.");
            refFieldRef.Value(codVINValue);
        end;
        refRecordRef2.SetTable(recVehicle);
    end;


    procedure CheckValues(recVehicle: Record Vehicle; recVINDecoding: Record "VIN Decoding"): Boolean
    var
        intLenght: Integer;
        i: Integer;
        intValue: Integer;
        codPosition: Code[2];
        codVehiclePosVal: Code[17];
    begin
        codVehiclePosVal := '';
        Clear(codPosition);
        intLenght := StrLen(recVINDecoding.Position);
        for i := 1 to intLenght do begin
            codPosition := CopyStr(recVINDecoding.Position, i, 1);
            if codPosition = 'A' then codPosition := '10';
            if codPosition = 'B' then codPosition := '11';
            if codPosition = 'C' then codPosition := '12';
            if codPosition = 'D' then codPosition := '13';
            if codPosition = 'E' then codPosition := '14';
            if codPosition = 'F' then codPosition := '15';
            if codPosition = 'G' then codPosition := '16';
            if codPosition = 'H' then codPosition := '17';
            Evaluate(intValue, codPosition);
            codVehiclePosVal := codVehiclePosVal + CopyStr(recVehicle.VIN, intValue, 1);
        end;
        if codVehiclePosVal = recVINDecoding.Combination then
            exit(true)
        else
            exit(false);
    end;


    procedure CheckValues2(recVehicle: Record Vehicle; recVINDecoding: Record "VIN Decoding"): Code[17]
    var
        intLenght: Integer;
        i: Integer;
        codVehiclePosVal: Code[17];
        intValue: Integer;
        codPosition: Code[2];
    begin
        codVehiclePosVal := '';
        Clear(codPosition);
        intLenght := StrLen(recVINDecoding.Position);
        for i := 1 to intLenght do begin
            codPosition := CopyStr(recVINDecoding.Position, i, 1);
            if codPosition = 'A' then codPosition := '10';
            if codPosition = 'B' then codPosition := '11';
            if codPosition = 'C' then codPosition := '12';
            if codPosition = 'D' then codPosition := '13';
            if codPosition = 'E' then codPosition := '14';
            if codPosition = 'F' then codPosition := '15';
            if codPosition = 'G' then codPosition := '16';
            if codPosition = 'H' then codPosition := '17';
            Evaluate(intValue, codPosition);
            codVehiclePosVal := codVehiclePosVal + CopyStr(recVehicle.VIN, intValue, 1);
        end;
        exit(codVehiclePosVal);
    end;
}

