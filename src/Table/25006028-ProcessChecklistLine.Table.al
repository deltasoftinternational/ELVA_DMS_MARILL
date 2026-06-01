Table 25006028 "Process Checklist Line"
{
    Caption = 'Process Checklist Line';
    LookupPageID = "Process Checklist Lines";

    fields
    {
        field(10; "Process Checklist No."; Code[20])
        {
            Caption = 'Process Checklist No.';
            TableRelation = "Process Checklist Header";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(100; "Question Text"; Text[250])
        {
            Caption = 'Question';
        }
        field(110; "Answer Type"; Option)
        {
            Caption = 'Answer Type';
            OptionCaption = ' ,Option,Dictionary,Boolean,Integer,Decimal,Percent,Date';
            OptionMembers = " ",Option,Dictionary,Boolean,"Integer",Decimal,Percent,Date;
        }
        field(120; "Answer Text"; Text[250])
        {
            Caption = 'Answer';

            trigger OnLookup()
            begin
                if Question.LookupAnswer("Questionary Subject Group Code", "Question No.", "Answer Text") then
                    Validate("Answer Text");
            end;

            trigger OnValidate()
            begin
                "Answer Text" := SetValue("Answer Text");
            end;
        }
        field(130; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Line,Group,Control';
            OptionMembers = Line,Group,Control;

            trigger OnValidate()
            begin
                case "Line Type" of
                    "line type"::Group:
                        Indentation := 0;
                    "line type"::Line:
                        Indentation := 2;
                    "line type"::Control:
                        Indentation := 3
                    else
                        Indentation := 0;
                end;
            end;
        }
        field(900; "Questionary Subject Group Code"; Code[20])
        {
            Caption = 'Questionary Subject Group Code';
            NotBlank = true;
            TableRelation = "Questionary Subject Group".Code;
        }
        field(910; "Question No."; Integer)
        {
            BlankZero = true;
            Caption = 'Question No.';
            MinValue = 1;
        }
        field(1000; "Value Int"; Integer)
        {

            trigger OnValidate()
            begin
                CheckInt;
            end;
        }
        field(1100; "Value Dec"; Decimal)
        {

            trigger OnValidate()
            begin
                CheckDec;
            end;
        }
        field(1200; "Value Date"; Date)
        {

            trigger OnValidate()
            begin
                CheckDate;
            end;
        }
        field(1300; "Value Bool"; Boolean)
        {
        }
        field(2000; "Type Code"; Code[10])
        {
        }
        field(2010; "Type Description"; Text[30])
        {
        }
        field(2020; Value; Code[10])
        {
        }
        field(2030; "Value Description"; Text[30])
        {
        }
        field(6002; SubType; Option)
        {
            OptionCaption = ' ,Textbox-Small,Textbox-Standard,Radio Button,Checkbox';
            OptionMembers = " ","Textbox-Small","Textbox-Standard","Radio Button",Checkbox,Button;

            trigger OnValidate()
            begin
                if "Line Type" = "line type"::Line then
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
        field(6200; "Parent Line No."; Integer)
        {
        }
        field(6210; "IsBold"; Boolean)
        {
        }
        field(6220; "IsMandatory"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Process Checklist No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        CheckListHeader: Record "Process Checklist Header";
        Question: Record "Quest. Subj. Group Question";
        QAnswer: Record "Quest. Subj. Group Q. Answer";
        TypeIsNotAllowedToConstrainErr: label '%1 is not allowed to constrain';
        ValueIsNotDateErr: label '%1 is not date';
        ValueIsNotDecimalErr: label '%1 is not decimal';
        ValueIsNotIntegerErr: label '%1 is not integer';
        ValueIsNotPercentErr: label '%1 is not percent';
        IncorrectMinMaxErr: label 'Incorrect min (%1) and max (%2) values';
        ValueOutOfRangeErr: label 'Value (%1) is out of range';
        NotModifyErr: label 'Trade-In document No. %1 modification or deleting is not allowed';

    local procedure SetValue(NewValue: Text): Text
    var
        DateX: Date;
        IntX: Integer;
        DecX: Decimal;
        ValueX: Variant;
    begin
        if NewValue = '' then begin
            "Value Date" := 0D;
            "Value Dec" := 0;
            "Value Int" := 0;
            "Value Bool" := false;
            exit;
        end;

        TestField("Questionary Subject Group Code");
        TestField("Question No.");
        Question.Get("Questionary Subject Group Code", "Question No.");
        Question.ConvertValue("Answer Type", NewValue, false, ValueX);

        case "Answer Type" of
            "answer type"::Date:
                begin
                    DateX := ValueX;
                    Validate("Value Date", DateX);
                end;
            "answer type"::Decimal:
                begin
                    DecX := ValueX;
                    Validate("Value Dec", DecX);
                end;
            "answer type"::Integer,
            "answer type"::Percent:
                begin
                    IntX := ValueX;
                    Validate("Value Int", IntX);
                end;
            "answer type"::Option:
                begin
                    if NewValue <> '' then begin
                        QAnswer.Get("Questionary Subject Group Code", "Question No.", NewValue);
                    end;
                end;
            "answer type"::Boolean:
                begin
                    "Value Bool" := ValueX;
                end;
        end;
        exit(NewValue);
    end;

    local procedure CheckInt()
    begin
        TestField("Questionary Subject Group Code");
        TestField("Question No.");
        Question.Get("Questionary Subject Group Code", "Question No.");

        if (Question."MIN Constrain" <> '') and ("Value Int" < Question."Min Int") or
           (Question."MAX Constrain" <> '') and ("Value Int" > Question."Max Int")
        then
            Error(ValueOutOfRangeErr, "Value Int");
    end;

    local procedure CheckDate()
    begin
        TestField("Questionary Subject Group Code");
        TestField("Question No.");
        Question.Get("Questionary Subject Group Code", "Question No.");

        if (Question."MIN Constrain" <> '') then begin
            if Question.IsDateConst(Question."MIN Constrain") then
                Question."Min Date" := Question.GetDateConstValue(Question."MIN Constrain", Question."Min Date");
            if ("Value Date" < Question."Min Date") then
                Error(ValueOutOfRangeErr, "Value Date");
        end;

        if (Question."MAX Constrain" <> '') then begin
            if Question.IsDateConst(Question."MAX Constrain") then
                Question."Max Date" := Question.GetDateConstValue(Question."MAX Constrain", Question."Max Date");
            if ("Value Date" > Question."Max Date") then
                Error(ValueOutOfRangeErr, "Value Date");
        end;
    end;

    local procedure CheckDec()
    begin
        TestField("Questionary Subject Group Code");
        TestField("Question No.");
        Question.Get("Questionary Subject Group Code", "Question No.");

        if (Question."MIN Constrain" <> '') and ("Value Dec" < Question."Min Dec") or
           (Question."MAX Constrain" <> '') and ("Value Dec" > Question."Max Dec")
        then
            Error(ValueOutOfRangeErr, "Value Dec");
    end;


    procedure IsAllowedModification(): Boolean
    begin
        if "Process Checklist No." = '' then
            exit(false);

        CheckListHeader.Get("Process Checklist No.");
        //EXIT(TCheckListHeader.IsAllowedModification);
    end;

    PROCEDURE GetLineControlType(): Integer;
    VAR
        ProcessChecklistLine: Record "Process Checklist Line";
    BEGIN
        ProcessChecklistLine.RESET;
        ProcessChecklistLine.SETRANGE("Parent Line No.", "Line No.");
        ProcessChecklistLine.SETRANGE("Line Type", ProcessChecklistLine."Line Type"::Control);
        IF ProcessChecklistLine.FINDFIRST THEN
            EXIT(ProcessChecklistLine.SubType)
    END;
}

