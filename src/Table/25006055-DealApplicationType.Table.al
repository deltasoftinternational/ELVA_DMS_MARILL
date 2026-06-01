Table 25006055 "Deal Application Type"
{
    Caption = 'Deal Application Type';
    LookupPageID = "Deal Application Types";

    fields
    {
        field(10; "No."; Code[10])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "System Type"; Option)
        {
            Caption = 'System Type';
            OptionCaption = ' ,Leasing';
            OptionMembers = " ",Leasing;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

