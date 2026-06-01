Table 25006190 "Common Log Entry"
{
    // 12.01.2015 EB.P7 #Username length EDMS
    //   User ID Field length changed to Code(50)


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Date and Time"; DateTime)
        {
            Caption = 'Date and Time';
        }
        field(3; Time; Time)
        {
            Caption = 'Time';
        }
        field(4; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(5; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(6; "Table Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                           "Object ID" = field("Table No.")));
            Caption = 'Table Name';
            FieldClass = FlowField;
        }
        field(7; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));
        }
        field(8; "Field Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                              "No." = field("Field No.")));
            Caption = 'Field Name';
            FieldClass = FlowField;
        }
        field(9; "Type of Change"; Option)
        {
            Caption = 'Type of Change';
            OptionCaption = 'Insertion,Modification,Deletion';
            OptionMembers = Insertion,Modification,Deletion;
        }
        field(10; "Old Value"; Text[250])
        {
            Caption = 'Old Value';
        }
        field(11; "New Value"; Text[250])
        {
            Caption = 'New Value';
        }
        field(12; "Primary Key"; Text[250])
        {
            Caption = 'Primary Key';
        }
        field(13; "Primary Key Field 1 No."; Integer)
        {
            Caption = 'Primary Key Field 1 No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));
        }
        field(14; "Primary Key Field 1 Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                              "No." = field("Primary Key Field 1 No.")));
            Caption = 'Primary Key Field 1 Name';
            FieldClass = FlowField;
        }
        field(15; "Primary Key Field 1 Value"; Text[50])
        {
            Caption = 'Primary Key Field 1 Value';
        }
        field(16; "Primary Key Field 2 No."; Integer)
        {
            Caption = 'Primary Key Field 2 No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));
        }
        field(17; "Primary Key Field 2 Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                              "No." = field("Primary Key Field 2 No.")));
            Caption = 'Primary Key Field 2 Name';
            FieldClass = FlowField;
        }
        field(18; "Primary Key Field 2 Value"; Text[50])
        {
            Caption = 'Primary Key Field 2 Value';
        }
        field(19; "Primary Key Field 3 No."; Integer)
        {
            Caption = 'Primary Key Field 3 No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));
        }
        field(20; "Primary Key Field 3 Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                              "No." = field("Primary Key Field 3 No.")));
            Caption = 'Primary Key Field 3 Name';
            FieldClass = FlowField;
        }
        field(21; "Primary Key Field 3 Value"; Text[50])
        {
            Caption = 'Primary Key Field 3 Value';
        }
        field(22; "Primary Key Field 4 No."; Integer)
        {
            Caption = 'Primary Key Field 4 No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));
        }
        field(23; "Primary Key Field 4 Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                              "No." = field("Primary Key Field 4 No.")));
            Caption = 'Primary Key Field 4 Name';
            FieldClass = FlowField;
        }
        field(24; "Primary Key Field 4 Value"; Text[50])
        {
            Caption = 'Primary Key Field 4 Value';
        }
        field(100; "Object Type"; Option)
        {
            OptionMembers = "Table",Form,"Report",Dataport,"XMLport","Codeunit",MenuSuite,"Page";
        }
        field(101; "Object No."; Integer)
        {
        }
        field(110; "Start Info"; Text[100])
        {
        }
        field(120; "Processing Info"; Text[100])
        {
        }
        field(130; "Processing Value"; Text[30])
        {
        }
        field(140; "End Info"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Table No.", "Primary Key Field 1 No.")
        {
        }
        key(Key3; "Table No.", "Date and Time")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        TempField: Record "Field" temporary;


    procedure InsertLogEntry(Type: Integer; ObjectID: Integer; CommonLogEntryPar: Record "Common Log Entry"; var FldRef: FieldRef; var xFldRef: FieldRef; var RecRef: RecordRef; TypeOfChange: Option Insertion,Modification,Deletion; RunModeFlags: Integer)
    var
        CommonLogEntry: Record "Common Log Entry";
        FlagsArray: array[16] of Boolean;
        KeyFldRef: FieldRef;
        KeyRef1: KeyRef;
        i: Integer;
        FldRefDefined: Boolean;
    begin
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        //FIRST FLAD means is fildref initialised
        FldRefDefined := FlagsArray[1];
        CommonLogEntry.Init;
        CommonLogEntry.TransferFields(CommonLogEntryPar);
        CommonLogEntry.Validate("Date and Time", CurrentDatetime);
        CommonLogEntry.Validate(Time, Dt2Time(CommonLogEntry."Date and Time"));
        CommonLogEntry.Validate("User ID", UserId);
        CommonLogEntry.Validate("Object Type", Type);
        CommonLogEntry.Validate("Object No.", ObjectID);

        CommonLogEntry."Table No." := RecRef.Number;
        if FldRefDefined then
            CommonLogEntry."Field No." := FldRef.Number;
        CommonLogEntry."Type of Change" := TypeOfChange;

        if TypeOfChange <> Typeofchange::Insertion then
            if FldRefDefined then
                CommonLogEntry."Old Value" := FormatValue(xFldRef, RecRef.Number);
        if TypeOfChange <> Typeofchange::Deletion then
            if FldRefDefined then
                CommonLogEntry."New Value" := FormatValue(FldRef, RecRef.Number);

        KeyRef1 := RecRef.KeyIndex(1);
        for i := 1 to KeyRef1.FieldCount do begin
            KeyFldRef := KeyRef1.FieldIndex(i);
            if i = 1 then
                CommonLogEntry."Primary Key" :=
                  StrSubstNo('%1=%2', KeyFldRef.Caption, FormatValue(KeyFldRef, RecRef.Number))
            else
                if MaxStrLen(CommonLogEntry."Primary Key") >
                  StrLen(CommonLogEntry."Primary Key") +
                  StrLen(StrSubstNo(', %1=%2', KeyFldRef.Caption, FormatValue(KeyFldRef, RecRef.Number)))
                then
                    CommonLogEntry."Primary Key" :=
                      CopyStr(
                        CommonLogEntry."Primary Key" +
                        StrSubstNo(', %1=%2', KeyFldRef.Caption, FormatValue(KeyFldRef, RecRef.Number)),
                        1, MaxStrLen(CommonLogEntry."Primary Key"));

            case i of
                1:
                    begin
                        CommonLogEntry."Primary Key Field 1 No." := KeyFldRef.Number;
                        CommonLogEntry."Primary Key Field 1 Value" := FormatValue(KeyFldRef, RecRef.Number);
                    end;
                2:
                    begin
                        CommonLogEntry."Primary Key Field 2 No." := KeyFldRef.Number;
                        CommonLogEntry."Primary Key Field 2 Value" := FormatValue(KeyFldRef, RecRef.Number);
                    end;
                3:
                    begin
                        CommonLogEntry."Primary Key Field 3 No." := KeyFldRef.Number;
                        CommonLogEntry."Primary Key Field 3 Value" := FormatValue(KeyFldRef, RecRef.Number);
                    end;
                4:
                    begin
                        CommonLogEntry."Primary Key Field 4 No." := KeyFldRef.Number;
                        CommonLogEntry."Primary Key Field 4 Value" := FormatValue(KeyFldRef, RecRef.Number);
                    end;
            end;
        end;
        CommonLogEntry.Insert(true);
    end;


    procedure FormatValue(var FldRef: FieldRef; TableNumber: Integer): Text[250]
    var
        "Field": Record "Field";
        OptionNo: Integer;
        OptionStr: Text[1024];
        i: Integer;
    begin
        GetField(TableNumber, FldRef.Number, Field);
        if Field.Type = Field.Type::Option then begin
            OptionNo := FldRef.Value;
            OptionStr := Format(FldRef.OptionCaption);
            for i := 1 to OptionNo do
                OptionStr := CopyStr(OptionStr, StrPos(OptionStr, ',') + 1);
            if StrPos(OptionStr, ',') > 0 then
                if StrPos(OptionStr, ',') = 1 then
                    OptionStr := ''
                else
                    OptionStr := CopyStr(OptionStr, 1, StrPos(OptionStr, ',') - 1);
            exit(OptionStr);
        end else
            exit(Format(FldRef.Value));
    end;

    local procedure GetField(TableNumber: Integer; FieldNumber: Integer; var Field2: Record "Field")
    var
        "Field": Record "Field";
    begin
        if not TempField.Get(TableNumber, FieldNumber) then begin
            Field.Get(TableNumber, FieldNumber);
            TempField := Field;
            TempField.Insert;
        end;
        Field2 := TempField;
    end;


    procedure "--SMALL TECHN--"()
    begin
    end;


    procedure CutNextBit(var Flags: Integer) RetValue: Boolean
    begin
        RetValue := ((Flags MOD 2) > 0);
        Flags := Flags DIV 2;
        exit(RetValue);
    end;


    procedure AdjustFlagsToArray(Flags: Integer; var ArrayEDMS: array[16] of Boolean)
    var
        i: Integer;
    begin
        for i := 1 to 16 do begin
            ArrayEDMS[i] := CutNextBit(Flags);
        end;
    end;
}

