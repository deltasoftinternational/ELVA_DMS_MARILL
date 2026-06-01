//Table 25006287 "Schedule Caption"
Table 25006169 "Schedule Caption"
{
    // There are predefined values for GroupingCode:
    //   '' - supposed to appear in any place;
    //   'ITEM' - only on area with resources (that could be changed);
    //   'ALLOC' - only on allocations (that could be changed);
    //   'HEADER'
    //   'ENABLED'
    //   'DISABLED'
    //   here could be additional variants;
    // Important: the field value should be in ASCII range!

    Caption = 'Schedule Caption';

    fields
    {
        field(10; ID; Integer)
        {
        }
        field(20; Caption; Text[30])
        {
        }
        field(30; SequenceNo; Integer)
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
    }

    keys
    {
        key(Key1; GroupingCode, ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: label '';
}

