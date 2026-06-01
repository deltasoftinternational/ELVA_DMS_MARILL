Table 25006209 "Quest. Subj. Group Question"
{
    // 06/03/2018 GH P1
    //   *Added ENG captions

    Caption = 'Quest. Subj. Group Question';

    fields
    {
        field(10; "Questionary Subject Group Code"; Code[20])
        {
            Caption = 'Questionary Subject Group Code';
            NotBlank = true;
            TableRelation = "Questionary Subject Group".Code;
        }
        field(20; "No."; Integer)
        {
            Caption = 'No.';
            MinValue = 1;
        }
        field(100; "Question Text"; Text[250])
        {
            Caption = 'Question Text';
        }
        field(110; "Answer Type"; Option)
        {
            Caption = 'Answer Type';
            OptionCaption = ' ,Option,Dictionary,Boolean,Integer,Decimal,Percent,Date';
            OptionMembers = " ",Option,Dictionary,Boolean,"Integer",Decimal,Percent,Date;

            trigger OnValidate()
            begin
                if xRec."Answer Type" = "Answer Type" then
                    exit;

                Validate("MIN Constrain", '');
                Validate("MAX Constrain", '');
                Validate("Default Value", '');

                if ("Answer Type" = "answer type"::Boolean) or
                   not ("Answer Type" in ["answer type"::Option, "answer type"::Dictionary])
                then begin
                    QAnswer.Reset;
                    QAnswer.SetRange("Questionary Subject Group Code", "Questionary Subject Group Code");
                    QAnswer.SetRange("Question No.", "No.");
                    QAnswer.DeleteAll;
                end;

                if ("Answer Type" = "answer type"::Boolean) then begin
                    QAnswer.Reset;
                    QAnswer.Init;
                    QAnswer."Questionary Subject Group Code" := "Questionary Subject Group Code";
                    QAnswer."Question No." := "No.";
                    QAnswer."Answer Text" := 'YES';
                    QAnswer."Sorting No." := 1;
                    QAnswer.Insert;
                    QAnswer."Answer Text" := 'NO';
                    QAnswer."Sorting No." := 2;
                    QAnswer.Insert;
                end;
            end;
        }
        field(200; "MIN Constrain"; Text[50])
        {
            Caption = 'MIN Constrain';

            trigger OnValidate()
            begin
                if "MIN Constrain" = '' then begin
                    "Min Date" := 0D;
                    "Min Dec" := 0;
                    "Min Int" := 0;
                    exit;
                end;

                if not IsTypeAllowedToConstrain then
                    Error(TypeIsNotAllowedToConstrainErr, "Answer Type");

                "MIN Constrain" := SetValue("MIN Constrain", 1);
            end;
        }
        field(210; "MAX Constrain"; Text[50])
        {
            Caption = 'MAX Constrain';

            trigger OnValidate()
            begin
                if "MAX Constrain" = '' then begin
                    "Max Date" := 0D;
                    "Max Dec" := 0;
                    "Max Int" := 0;
                    exit;
                end;

                if not IsTypeAllowedToConstrain then
                    Error(TypeIsNotAllowedToConstrainErr, "Answer Type");

                "MAX Constrain" := SetValue("MAX Constrain", 2);
            end;
        }
        field(300; "Default Value"; Text[50])
        {

            trigger OnLookup()
            begin
                if LookupAnswer("Questionary Subject Group Code", "No.", "Default Value") then
                    Validate("Default Value");
            end;

            trigger OnValidate()
            begin
                if "Default Value" = '' then begin
                    "Value Date" := 0D;
                    "Value Dec" := 0;
                    "Value Int" := 0;
                    "Value Bool" := false;
                    exit;
                end;

                "Default Value" := SetValue("Default Value", 0);
            end;
        }
        field(1000; "Value Int"; Integer)
        {
        }
        field(1010; "Min Int"; Integer)
        {
        }
        field(1020; "Max Int"; Integer)
        {
        }
        field(1100; "Value Dec"; Decimal)
        {
        }
        field(1110; "Min Dec"; Decimal)
        {
        }
        field(1120; "Max Dec"; Decimal)
        {
        }
        field(1200; "Value Date"; Date)
        {
        }
        field(1210; "Min Date"; Date)
        {
        }
        field(1220; "Max Date"; Date)
        {
        }
        field(1330; "Value Bool"; Boolean)
        {
        }
        field(6000; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Line,,Control';
            OptionMembers = Line,,Control;

            trigger OnValidate()
            begin
                case Type of
                    Type::Line:
                        Indentation := 0;
                    Type::Control:
                        Indentation := 1
                    else
                        Indentation := 0;
                end;
            end;
        }
        field(6002; SubType; Option)
        {
            OptionCaption = ' ,Textbox-Small,Textbox-Standard,Radio Button,Checkbox';
            OptionMembers = " ","Textbox-Small","Textbox-Standard","Radio Button",Checkbox,Button;

            trigger OnValidate()
            begin
                if Type = Type::Line then
                    TestField(SubType, Subtype::" ");
            end;
        }
        field(6010; Indentation; Integer)
        {
            MinValue = 0;
        }
        field(6100; "Control Color"; Code[10])
        {
            Caption = 'Control Color';
            Description = 'Hex Color Code';
        }
        field(6110; "Control AssistEdit"; Boolean)
        {
        }
        field(6111; "IsBold"; Boolean)
        {
        }
        field(6112; "IsMandatory"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Questionary Subject Group Code", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //IF "No." = 0 THEN
        //  "No." := GetNo("Questionary Subject Group Code");
    end;

    var
        TypeIsNotAllowedToConstrainErr: label '%1 is not allowed to constrain';
        ValueIsNotDateErr: label '%1 is not date';
        ValueIsNotDecimalErr: label '%1 is not decimal';
        ValueIsNotIntegerErr: label '%1 is not integer';
        ValueIsNotPercentErr: label '%1 is not percent';
        ValueIsNotBoolErr: label '%1 is not boolean';
        IncorrectMinMaxErr: label 'Incorrect min (%1) and max (%2) values';
        DefaultValueOutOfRangeErr: label 'Default value (%1) is out of range';
        QAnswer: Record "Quest. Subj. Group Q. Answer";

    local procedure GetNo(GroupCode: Code[20]): Integer
    var
        Rec2: Record "Quest. Subj. Group Question";
    begin
        if GroupCode = '' then
            exit(0);

        Rec2.Reset;
        Rec2.SetRange("Questionary Subject Group Code", GroupCode);
        if Rec2.FindLast then
            exit(Rec2."No." + 1);

        exit(1);
    end;


    procedure IsTypeAllowedToConstrain(): Boolean
    begin
        exit("Answer Type" in ["answer type"::Date, "answer type"::Decimal,
                               "answer type"::Integer, "answer type"::Percent]);
    end;


    procedure IsDateConst(InText: Text): Boolean
    begin
        exit(UpperCase(InText) in ['TODAY']);
    end;

    local procedure SetValue(NewValue: Text; ValueType: Option Default,"Min","Max"): Text
    var
        DateX: Date;
        IntX: Integer;
        DecX: Decimal;
        ValueX: Variant;
    begin
        ConvertValue("Answer Type", NewValue, false, ValueX);

        case "Answer Type" of
            "answer type"::Date:
                begin
                    DateX := ValueX;
                    case ValueType of
                        Valuetype::Default:
                            Validate("Value Date", DateX);
                        Valuetype::Min:
                            Validate("Min Date", DateX);
                        Valuetype::Max:
                            Validate("Max Date", DateX);
                    end;
                    CheckDate;
                end;
            "answer type"::Decimal:
                begin
                    DecX := ValueX;
                    case ValueType of
                        Valuetype::Default:
                            Validate("Value Dec", DecX);
                        Valuetype::Min:
                            Validate("Min Dec", DecX);
                        Valuetype::Max:
                            Validate("Max Dec", DecX);
                    end;
                    CheckDec;
                end;
            "answer type"::Integer,
            "answer type"::Percent:
                begin
                    IntX := ValueX;
                    case ValueType of
                        Valuetype::Default:
                            Validate("Value Int", IntX);
                        Valuetype::Min:
                            Validate("Min Int", IntX);
                        Valuetype::Max:
                            Validate("Max Int", IntX);
                    end;
                    CheckInt;
                end;
            "answer type"::Option:
                begin
                    if NewValue <> '' then begin
                        QAnswer.Get("Questionary Subject Group Code", "No.", NewValue);
                    end;
                end;
            "answer type"::Boolean:
                begin
                    if ValueType = Valuetype::Default then
                        "Value Bool" := ValueX;
                end;
        end;
        exit(NewValue);
    end;

    local procedure CheckInt()
    begin
        if ("MIN Constrain" <> '') and ("MAX Constrain" <> '') then
            if "Min Int" > "Max Int" then
                Error(IncorrectMinMaxErr, "Min Int", "Max Int");

        if "Default Value" <> '' then begin
            if ("MIN Constrain" <> '') and ("Value Int" < "Min Int") or
               ("MAX Constrain" <> '') and ("Value Int" > "Max Int")
            then
                Message(DefaultValueOutOfRangeErr, "Value Int");
        end;
    end;

    local procedure CheckDate()
    begin
        if ("MIN Constrain" <> '') and not IsDateConst("MIN Constrain") and
           ("MAX Constrain" <> '') and not IsDateConst("MAX Constrain")
        then
            if "Min Date" > "Max Date" then
                Error(IncorrectMinMaxErr, "Min Date", "Max Date");

        if ("Default Value" <> '') and not IsDateConst("Default Value") then begin
            if ("MIN Constrain" <> '') and ("Value Date" < "Min Date") and not IsDateConst("MIN Constrain") or
               ("MAX Constrain" <> '') and ("Value Date" > "Max Date") and not IsDateConst("MAX Constrain")
            then
                Message(DefaultValueOutOfRangeErr, "Value Date");
        end;
    end;

    local procedure CheckDec()
    begin
        if ("MIN Constrain" <> '') and ("MAX Constrain" <> '') then
            if "Min Dec" > "Max Dec" then
                Error(IncorrectMinMaxErr, "Min Dec", "Max Dec");

        if "Default Value" <> '' then begin
            if ("MIN Constrain" <> '') and ("Value Dec" < "Min Dec") or
               ("MAX Constrain" <> '') and ("Value Dec" > "Max Dec")
            then
                Message(DefaultValueOutOfRangeErr, "Value Dec");
        end;
    end;


    procedure ConvertValue(ValueType: Option " ",Option,Dictionary,Boolean,"Integer",Decimal,Percent,Date; var ValueText: Text; ReplaceConst: Boolean; var ValueX: Variant)
    var
        BoolStr: Text;
        DateX: Date;
        IntX: Integer;
        DecX: Decimal;
    begin
        Clear(ValueX);

        case ValueType of
            Valuetype::Option:
                begin
                    ValueText := UpperCase(ValueText);
                    ValueX := ValueText;
                end;
            Valuetype::Boolean:
                begin
                    ValueText := UpperCase(ValueText);
                    if ValueText in ['1', 'T', 'Y', 'TRUE'] then
                        ValueText := 'YES';
                    if ValueText in ['0', 'F', 'N', 'FALSE'] then
                        ValueText := 'NO';
                    if not (ValueText in ['YES', 'NO']) then
                        Error(ValueIsNotBoolErr, ValueText);
                    ValueX := ValueText = 'YES';
                end;

            Valuetype::Integer,
            Valuetype::Percent:
                begin
                    if not Evaluate(IntX, ValueText) then
                        Error(ValueIsNotIntegerErr, ValueText);
                    if (ValueType = Valuetype::Percent) and
                       ((IntX < 0) or (IntX > 100))
                    then
                        Error(ValueIsNotPercentErr, ValueText);
                    ValueX := IntX;
                end;

            Valuetype::Decimal:
                begin
                    if not Evaluate(DecX, ValueText) then
                        Error(ValueIsNotDecimalErr, ValueText);
                    ValueX := DecX;
                end;

            Valuetype::Date:
                begin
                    ValueText := UpperCase(ValueText);
                    if ValueText in ['T'] then
                        ValueText := 'TODAY';
                    if IsDateConst(ValueText) then begin
                        DateX := 0D;
                        if ReplaceConst then
                            DateX := GetDateConstValue(ValueText, Today);
                    end else
                        if not Evaluate(DateX, ValueText) then
                            Error(ValueIsNotDateErr, ValueText);
                    ValueX := DateX;
                end;
            else
                ValueX := ValueText;
        end;
    end;


    procedure GetValuesAsText(ValueType: Option " ",Option,Dictionary,Boolean,"Integer",Decimal,Percent,Date; ValueX: Variant) ValueText: Text
    var
        BoolX: Boolean;
        IntX: Integer;
        DecX: Decimal;
        DateX: Date;
    begin
        ValueText := '';

        case ValueType of
            Valuetype::" ",
            Valuetype::Option:
                begin
                    ValueText := ValueX;
                    ValueText := UpperCase(ValueText);
                end;

            Valuetype::Dictionary:
                ValueText := ValueX;

            Valuetype::Boolean:
                begin
                    BoolX := ValueX;
                    if BoolX then
                        ValueText := 'YES'
                    else
                        ValueText := 'NO';
                end;

            Valuetype::Integer,
            Valuetype::Percent:
                begin
                    IntX := ValueX;
                    ValueText := Format(IntX);
                end;

            Valuetype::Decimal:
                begin
                    DecX := ValueX;
                    ValueText := Format(DecX);
                end;

            Valuetype::Date:
                begin
                    DateX := ValueX;
                    ValueText := Format(DateX);
                end;
            else
                ValueX := ValueText;
        end;
    end;


    procedure GetDateConstValue(ConstValue: Text; DateX: Date): Date
    begin
        case ConstValue of
            'TODAY':
                exit(Today);
            else
                exit(0D);
        end;
    end;


    procedure LookupAnswer(SubjGroupCode: Code[20]; QuestionNo: Integer; var Value: Text[250]): Boolean
    var
        Rec2: Record "Quest. Subj. Group Question";
    begin
        Rec2.Get(SubjGroupCode, QuestionNo);
        if not (Rec2."Answer Type" in ["answer type"::Dictionary, "answer type"::Option, "answer type"::Boolean]) then
            exit;

        QAnswer.Reset;
        QAnswer.SetRange("Questionary Subject Group Code", SubjGroupCode);
        QAnswer.SetRange("Question No.", QuestionNo);
        if QAnswer.Get(SubjGroupCode, QuestionNo, CopyStr(Value, 1, MaxStrLen(QAnswer."Answer Text"))) then;
        if Page.RunModal(0, QAnswer) <> Action::LookupOK then
            exit(false);

        Value := QAnswer."Answer Text";
        exit(true);
    end;
}

