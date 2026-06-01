Table 25006296 "Process Checklist Line Arch."
{
    // 09/08/2018 EB.P30 GH
    //   Created

    Caption = 'Process Checklist Line Arch.';
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
        }
        field(130; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Line,Group,Control';
            OptionMembers = Line,Group,Control;
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
        }
        field(1100; "Value Dec"; Decimal)
        {
        }
        field(1200; "Value Date"; Date)
        {
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
        field(5047; "Version No."; Integer)
        {
            Caption = 'Version No.';
            DataClassification = ToBeClassified;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
            DataClassification = ToBeClassified;
        }
        field(6002; SubType; Option)
        {
            OptionCaption = ' ,Textbox-Small,Textbox-Standard,Radio Button,Checkbox';
            OptionMembers = " ","Textbox-Small","Textbox-Standard","Radio Button",Checkbox,Button;
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
    }

    keys
    {
        key(Key1; "Process Checklist No.", "Line No.", "Doc. No. Occurrence", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

