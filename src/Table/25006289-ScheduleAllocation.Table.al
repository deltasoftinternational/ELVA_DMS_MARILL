//Table 25006289 "Schedule Allocation"
Table 25006800 "Schedule Allocation"
{
    Caption = 'Schedule Allocation';

    fields
    {
        field(10; EntryNo; Integer)
        {
        }
        field(20; ItemID; Code[100])
        {
        }
        field(30; ItemNo; Code[20])
        {
        }
        field(40; Text; Text[250])
        {
        }
        field(50; StartDT; Decimal)
        {
            Description = 'Datetime as decimal';
        }
        field(60; EndDT; Decimal)
        {
            Description = 'Datetime as decimal';
        }
        field(70; DisplayStartDT; Decimal)
        {
        }
        field(80; DisplayEndDT; Decimal)
        {
        }
        field(90; BackColorR; Integer)
        {
            Description = 'Red';
        }
        field(92; BackColorG; Integer)
        {
            Description = 'Green';
        }
        field(94; BackColorB; Integer)
        {
            Description = 'Blue';
        }
        field(100; ForeColorR; Integer)
        {
            Description = 'Red';
        }
        field(102; ForeColorG; Integer)
        {
            Description = 'Green';
        }
        field(104; ForeColorB; Integer)
        {
            Description = 'Blue';
        }
        field(110; Editable; Boolean)
        {
        }
        field(120; AllocType; Option)
        {
            OptionMembers = Background,Normal;
        }
        field(200; OriginalEntryNo; Integer)
        {
        }
        field(210; GroupingCode; Code[20])
        {
            Caption = 'GroupingCode';

            trigger OnValidate()
            var
                Text001: label 'Value ef %1 must have only ASCII chars.';
                DocumentManagement: Codeunit DocumentManagementDMS;
            begin
                if not DocumentManagement.IsASCII(GroupingCode, 1, StrLen(GroupingCode)) then
                    Error(Text001, FieldCaption(GroupingCode));
            end;
        }
        field(220; Travel; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

