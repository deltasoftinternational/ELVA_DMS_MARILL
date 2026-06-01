//Table 25006288 "Schedule Item"
Table 25006170 "Schedule Item"
{
    Caption = 'Schedule Item';

    fields
    {
        field(6; Sequence; Integer)
        {
        }
        field(10; ItemID; Code[100])
        {
        }
        field(20; ItemNo; Code[20])
        {
        }
        field(30; Description; Text[100])
        {
        }
        field(40; GroupingCode; Code[20])
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
        field(50; Level; Integer)
        {
        }
        field(60; Current; Boolean)
        {
        }
        field(70; Parent; Boolean)
        {
        }
        field(80; Collapsed; Boolean)
        {
        }
        field(90; ForeColorR; Integer)
        {
            Description = 'Red';
        }
        field(92; ForeColorG; Integer)
        {
            Description = 'Green';
        }
        field(94; ForeColorB; Integer)
        {
            Description = 'Blue';
        }
        field(100; ScrollBarPosition; Integer)
        {
        }
        field(110; ScrollBarTotalCount; Integer)
        {
        }
    }

    keys
    {
        key(Key1; Sequence)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

