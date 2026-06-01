Table 25006216 "BLS Contract Category"
{
    Caption = 'Contract Category';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "BLS Contract Categories";
    LookupPageID = "BLS Contract Categories";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(1000; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(2000; "Use For Billing"; Boolean)
        {
            Caption = 'Use For Billing';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

