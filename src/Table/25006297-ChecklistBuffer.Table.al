Table 25006297 "Checklist Buffer"
{
    Caption = 'GH CheckList';

    fields
    {
        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(15; Type; Option)
        {
            OptionMembers = " ",Group,Item;
        }
        field(17; "Sub Type"; Option)
        {
            OptionMembers = ,TextSmall,TextNormal,Radio,Check,Button;
        }
        field(18; "Parent Line No."; Integer)
        {
        }
        field(40; Value; Text[250])
        {
            Caption = 'Radio Button Value 1';
        }
        field(50; Caption; Text[250])
        {
        }
        field(60; Color; Code[10])
        {
        }
        field(70; Selected; Boolean)
        {
        }
        field(80; "Assist Edit"; Boolean)
        {
        }
        field(90; TextLength; Integer)
        {
            Caption = 'TextLength';
            DataClassification = ToBeClassified;
        }
        field(100; "IsBold"; Boolean)
        {
        }
        field(110; "IsMandatory"; Boolean)
        {
        }
        field(120; "IsDisabled"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

