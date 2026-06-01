Table 25006753 "Lost Sales Setup"
{
    Caption = 'Lost Sales Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(100; "On Service Doc. Deletion"; Option)
        {
            Caption = 'On Service Doc. Deletion';
            OptionCaption = 'No,Yes,Prompt';
            OptionMembers = No,Yes,Prompt;
        }
        field(110; "On Sales Doc. Deletion"; Option)
        {
            Caption = 'On Sales Doc. Deletion';
            OptionCaption = 'No,Yes,Prompt';
            OptionMembers = No,Yes,Prompt;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

