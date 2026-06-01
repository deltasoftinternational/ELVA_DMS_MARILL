Table 25006191 "Service WIP Setup"
{

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "WIP Document No. Series"; Code[20])
        {
            Caption = 'WIP Document No. Series';
            TableRelation = "No. Series".Code;
        }
        field(30; "Default Resource Unit Cost"; Decimal)
        {
            Caption = 'Default Resource Unit Cost';
        }
        field(70; "WIP Method"; Option)
        {
            Caption = 'WIP Method';
            OptionMembers = "Cost Method","Sales Method";
        }
        field(80; "Post Labor Cost for Sales Meth"; Boolean)
        {
            Caption = 'Post Labor Cost for Sales Method';
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

